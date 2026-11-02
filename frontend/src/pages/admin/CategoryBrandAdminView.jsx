import React, { useCallback, useEffect, useState } from 'react';
import {
  AlertCircle,
  CheckCircle,
  Edit,
  Image as ImageIcon,
  Loader2,
  Plus,
  RotateCcw,
  Search,
  Sparkles,
  Tag,
  Trash2,
  X,
} from 'lucide-react';
import { brandApi, categoryApi } from '../../api';
import { AdminPagination } from './AdminPagination';
import { useAdminNotification, AdminToast } from '../../context/AdminNotificationContext';

const EMPTY_FORM = {
  name: '',
  description: '',
  logoUrl: '',
  status: true,
};

export const CategoryBrandAdminView = () => {
  const { showConfirm } = useAdminNotification();
  const [activeType, setActiveType] = useState('categories');
  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [trashCategories, setTrashCategories] = useState([]);
  const [trashBrands, setTrashBrands] = useState([]);
  const [activeTab, setActiveTab] = useState('active');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [formOpen, setFormOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [feedback, setFeedback] = useState(null);

  const isCategory = activeType === 'categories';
  const activeEntries = isCategory ? categories : brands;
  const trashEntries = isCategory ? trashCategories : trashBrands;
  const entries = activeTab === 'active' ? activeEntries : trashEntries;

  const fetchEntries = useCallback(async () => {
    setLoading(true);
    try {
      if (isCategory) {
        const [active, trash] = await Promise.all([categoryApi.getAll(), categoryApi.getTrash()]);
        setCategories(active || []);
        setTrashCategories(trash || []);
      } else {
        const [active, trash] = await Promise.all([brandApi.getAllForManagement(), brandApi.getTrash()]);
        setBrands(active || []);
        setTrashBrands(trash || []);
      }
    } catch (error) {
      setFeedback({
        type: 'error',
        message: `Không thể tải ${isCategory ? 'danh mục' : 'thương hiệu'}: ${error.message || 'Lỗi máy chủ'}`,
      });
    } finally {
      setLoading(false);
    }
  }, [isCategory]);

  useEffect(() => {
    fetchEntries();
  }, [fetchEntries]);

  const showFeedback = (type, message) => {
    setFeedback({ type, message });
    window.setTimeout(() => setFeedback(null), 4000);
  };

  const openCreate = () => {
    setEditingItem(null);
    setForm({ ...EMPTY_FORM });
    setFormOpen(true);
  };

  const openEdit = (item) => {
    setEditingItem(item);
    setFormOpen(true);
    setForm(isCategory
      ? { ...EMPTY_FORM, name: item.name || '', description: item.description || '' }
      : {
          ...EMPTY_FORM,
          name: item.brandName || '',
          description: item.description || '',
          logoUrl: item.logoUrl || '',
          status: item.status !== false,
        });
  };

  const handleSave = async (event) => {
    event.preventDefault();
    setSaving(true);
    const request = isCategory
      ? { name: form.name, description: form.description }
      : {
          brandName: form.name,
          description: form.description,
          logoUrl: form.logoUrl,
          status: form.status,
        };
    const api = isCategory ? categoryApi : brandApi;

    try {
      if (editingItem) {
        await api.update(editingItem.id, request);
      } else {
        await api.create(request);
      }
      setFormOpen(false);
      setEditingItem(null);
      showFeedback('success', `${editingItem ? 'Đã cập nhật' : 'Đã tạo'} ${isCategory ? 'danh mục' : 'thương hiệu'} thành công.`);
      await fetchEntries();
    } catch (error) {
      showFeedback('error', `Không thể lưu: ${error.message || 'Vui lòng thử lại'}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (item) => {
    const itemName = isCategory ? item.name : item.brandName;
    const typeLabel = isCategory ? 'danh mục' : 'thương hiệu';
    const confirmed = await showConfirm({
      title: `Chuyển ${typeLabel} vào thùng rác`,
      message: `Bạn có chắc muốn chuyển ${typeLabel} "${itemName}" vào thùng rác không?`,
      type: 'warning',
      confirmText: 'Chuyển vào thùng rác',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await (isCategory ? categoryApi : brandApi).delete(item.id);
      showFeedback('success', `Đã chuyển ${typeLabel} "${itemName}" vào thùng rác.`);
      await fetchEntries();
    } catch (error) {
      showFeedback('error', error.message || 'Không thể xóa mục này.');
    }
  };

  const handleRestore = async (item) => {
    try {
      await (isCategory ? categoryApi : brandApi).restore(item.id);
      showFeedback('success', `Đã khôi phục ${isCategory ? 'danh mục' : 'thương hiệu'} thành công.`);
      await fetchEntries();
    } catch (error) {
      showFeedback('error', `Không thể khôi phục: ${error.message || 'Lỗi máy chủ'}`);
    }
  };

  const handleDeletePermanently = async (item) => {
    const itemName = isCategory ? item.name : item.brandName;
    const typeLabel = isCategory ? 'danh mục' : 'thương hiệu';
    const confirmed = await showConfirm({
      title: `Xóa vĩnh viễn ${typeLabel}`,
      message: `CẢNH BÁO: Xóa vĩnh viễn "${itemName}"? Thao tác này không thể hoàn tác.`,
      type: 'danger',
      confirmText: 'Xóa vĩnh viễn',
      cancelText: 'Hủy',
    });
    if (!confirmed) return;
    try {
      await (isCategory ? categoryApi : brandApi).deletePermanently(item.id);
      showFeedback('success', `Đã xóa vĩnh viễn "${itemName}".`);
      await fetchEntries();
    } catch (error) {
      showFeedback('error', `Không thể xóa vĩnh viễn: ${error.message || 'Có dữ liệu khác đang tham chiếu mục này'}`);
    }
  };

  const handleRestoreAll = async () => {
    const typeLabel = isCategory ? 'danh mục' : 'thương hiệu';
    const confirmed = await showConfirm({
      title: `Khôi phục tất cả ${typeLabel}`,
      message: `Bạn có chắc muốn khôi phục tất cả ${typeLabel} trong thùng rác không?`,
      type: 'info',
      confirmText: 'Khôi phục tất cả',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await (isCategory ? categoryApi : brandApi).restoreAll();
      showFeedback('success', `Đã khôi phục tất cả ${typeLabel}.`);
      await fetchEntries();
    } catch (error) {
      showFeedback('error', `Không thể khôi phục: ${error.message || 'Lỗi máy chủ'}`);
    }
  };

  const filteredEntries = entries.filter((item) => (
    (isCategory ? item.name : item.brandName || '').toLowerCase().includes(search.toLowerCase())
  ));
  const totalPages = Math.max(1, Math.ceil(filteredEntries.length / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedEntries = filteredEntries.slice((safePage - 1) * pageSize, safePage * pageSize);

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Danh mục & nhãn hàng</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Quản lý Danh mục & Thương hiệu
          </h2>
          <p className="text-xs text-zinc-500 mt-1">Tạo, cập nhật và quản lý các mục phân loại sản phẩm.</p>
        </div>
        {activeTab === 'active' && <button
          type="button"
          onClick={openCreate}
          className="inline-flex items-center justify-center gap-2 px-5 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-[#C6A77B] text-xs font-bold uppercase tracking-wider shadow-sm transition"
        >
          <Plus className="w-4 h-4" />
          Thêm {isCategory ? 'danh mục' : 'thương hiệu'}
        </button>}
      </div>

      <div className="flex flex-col sm:flex-row gap-3 justify-between">
        <div className="inline-flex gap-1 p-1.5 bg-black/5 rounded-full self-start">
          <button
            type="button"
            onClick={() => { setActiveType('categories'); setActiveTab('active'); setSearch(''); setCurrentPage(1); }}
            className={`px-4 py-2 rounded-full text-xs font-bold transition ${isCategory ? 'bg-[#0B0B0D] text-[#C6A77B] shadow' : 'text-zinc-600 hover:text-black'}`}
          >
            Danh mục ({categories.length})
          </button>
          <button
            type="button"
            onClick={() => { setActiveType('brands'); setActiveTab('active'); setSearch(''); setCurrentPage(1); }}
            className={`px-4 py-2 rounded-full text-xs font-bold transition ${!isCategory ? 'bg-[#0B0B0D] text-[#C6A77B] shadow' : 'text-zinc-600 hover:text-black'}`}
          >
            Thương hiệu ({brands.length})
          </button>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <div className="inline-flex gap-1 p-1 bg-black/5 rounded-full self-start">
            {[
              ['active', `${isCategory ? 'Danh mục' : 'Thương hiệu'} (${activeEntries.length})`],
              ['trash', `Thùng rác (${trashEntries.length})`],
            ].map(([tab, label]) => (
              <button
                type="button"
                key={tab}
                onClick={() => { setActiveTab(tab); setCurrentPage(1); }}
                className={`px-4 py-2 rounded-full text-[10px] font-bold uppercase tracking-wider transition ${
                  activeTab === tab
                    ? tab === 'trash' ? 'bg-rose-600 text-white shadow' : 'bg-[#0B0B0D] text-[#C6A77B] shadow'
                    : 'text-zinc-600 hover:text-black'
                }`}
              >
                {label}
              </button>
            ))}
          </div>
          {activeTab === 'trash' && trashEntries.length > 0 && (
            <button
              type="button"
              onClick={handleRestoreAll}
              className="inline-flex items-center gap-2 rounded-full bg-emerald-600 px-4 py-2 text-[10px] font-bold uppercase tracking-wider text-white transition hover:bg-emerald-700"
            >
              <RotateCcw className="h-3.5 w-3.5" />
              Khôi phục tất cả
            </button>
          )}
        </div>
        <div className="relative w-full sm:w-80">
          <Search className="w-4 h-4 absolute left-3.5 top-3 text-zinc-400" />
          <input
            type="search"
            value={search}
            onChange={(event) => { setSearch(event.target.value); setCurrentPage(1); }}
            placeholder={`Tìm ${isCategory ? 'danh mục' : 'thương hiệu'}...`}
            className="w-full pl-10 pr-4 py-2.5 text-xs rounded-full border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
          />
        </div>
      </div>

      <div className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-16 flex justify-center items-center gap-3 text-zinc-400 text-xs">
            <Loader2 className="w-6 h-6 animate-spin text-[#C6A77B]" />
            Đang tải dữ liệu...
          </div>
        ) : filteredEntries.length === 0 ? (
          <div className="p-16 text-center text-zinc-400 text-xs">
            Không tìm thấy {isCategory ? 'danh mục' : 'thương hiệu'} phù hợp.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] text-zinc-600 font-bold uppercase tracking-wider text-[10px] border-b border-black/5">
                <tr>
                  {!isCategory && <th className="py-3.5 px-5">Logo</th>}
                  <th className="py-3.5 px-5">{isCategory ? 'Tên danh mục' : 'Tên thương hiệu'}</th>
                  <th className="py-3.5 px-5">Mô tả</th>
                  {!isCategory && <th className="py-3.5 px-5">Trạng thái</th>}
                  <th className="py-3.5 px-5 text-right">Thao tác</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5">
                {paginatedEntries.map((item) => (
                  <tr key={item.id} className="hover:bg-[#F8F7F4]/60">
                    {!isCategory && (
                      <td className="py-3 px-5">
                        {item.logoUrl ? (
                          <img src={item.logoUrl} alt={item.brandName} className="w-12 h-10 object-contain rounded-lg border border-black/5 bg-white p-1" />
                        ) : (
                          <div className="w-12 h-10 rounded-lg bg-zinc-100 flex items-center justify-center text-zinc-400">
                            <ImageIcon className="w-4 h-4" />
                          </div>
                        )}
                      </td>
                    )}
                    <td className="py-3 px-5 font-bold text-[#0B0B0D]">
                      {isCategory ? item.name : item.brandName}
                    </td>
                    <td className="py-3 px-5 max-w-sm text-zinc-500">
                      <span className="line-clamp-2">{item.description || 'Chưa có mô tả'}</span>
                    </td>
                    {!isCategory && (
                      <td className="py-3 px-5">
                        <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold ${
                          item.status === false
                            ? 'bg-zinc-100 text-zinc-500'
                            : 'bg-emerald-50 text-emerald-700'
                        }`}>
                          {item.status === false ? 'Tạm ẩn' : 'Đang hoạt động'}
                        </span>
                      </td>
                    )}
                    <td className="py-3 px-5">
                      <div className="flex justify-end gap-1">
                        {activeTab === 'trash' ? (
                          <>
                            <button
                              type="button"
                              title="Khôi phục"
                              onClick={() => handleRestore(item)}
                              className="inline-flex items-center gap-1.5 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-[10px] font-bold text-emerald-700 hover:bg-emerald-100"
                            >
                              <RotateCcw className="w-3.5 h-3.5" />
                              Khôi phục
                            </button>
                            <button
                              type="button"
                              title="Xóa vĩnh viễn"
                              onClick={() => handleDeletePermanently(item)}
                              className="rounded-full border border-rose-200 bg-rose-50 px-3 py-1.5 text-[10px] font-bold text-rose-700 hover:bg-rose-100"
                            >
                              Xóa vĩnh viễn
                            </button>
                          </>
                        ) : (
                          <>
                        <button
                          type="button"
                          title="Chỉnh sửa"
                          onClick={() => openEdit(item)}
                          className="p-2 rounded-xl text-[#A98756] hover:bg-[#C6A77B]/15"
                        >
                          <Edit className="w-4 h-4" />
                        </button>
                        <button
                          type="button"
                          title="Chuyển vào thùng rác"
                          onClick={() => handleDelete(item)}
                          className="p-2 rounded-xl text-zinc-400 hover:text-rose-600 hover:bg-rose-50"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                          </>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
      <AdminPagination
        totalItems={filteredEntries.length}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {formOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <div className="w-full max-w-lg bg-white rounded-3xl p-6 sm:p-7 shadow-2xl border border-black/10">
            <div className="flex items-center justify-between pb-4 border-b border-black/5">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center">
                  {isCategory ? <Tag className="w-4 h-4" /> : <Sparkles className="w-4 h-4" />}
                </div>
                <h3 className="font-extrabold text-[#0B0B0D]">
                  {editingItem ? 'Cập nhật' : 'Thêm'} {isCategory ? 'danh mục' : 'thương hiệu'}
                </h3>
              </div>
              <button type="button" onClick={() => { setFormOpen(false); setEditingItem(null); }} aria-label="Đóng">
                <X className="w-5 h-5 text-zinc-400" />
              </button>
            </div>
            <form onSubmit={handleSave} className="space-y-4 pt-5">
              <label className="block text-[11px] font-bold text-zinc-700">
                {isCategory ? 'Tên danh mục' : 'Tên thương hiệu'}
                <input
                  required
                  maxLength={100}
                  value={form.name}
                  onChange={(event) => setForm({ ...form, name: event.target.value })}
                  className="mt-1.5 w-full px-4 py-2.5 rounded-xl border border-zinc-200 font-normal focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </label>
              {!isCategory && (
                <label className="block text-[11px] font-bold text-zinc-700">
                  Đường dẫn logo (URL)
                  <input
                    maxLength={150}
                    type="url"
                    value={form.logoUrl}
                    onChange={(event) => setForm({ ...form, logoUrl: event.target.value })}
                    placeholder="https://..."
                    className="mt-1.5 w-full px-4 py-2.5 rounded-xl border border-zinc-200 font-normal focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </label>
              )}
              <label className="block text-[11px] font-bold text-zinc-700">
                Mô tả
                <textarea
                  rows="3"
                  maxLength={isCategory ? 500 : 5000}
                  value={form.description}
                  onChange={(event) => setForm({ ...form, description: event.target.value })}
                  className="mt-1.5 w-full px-4 py-2.5 rounded-xl border border-zinc-200 font-normal resize-y focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </label>
              {!isCategory && (
                <label className="flex items-center gap-2 text-xs text-zinc-700 font-semibold">
                  <input
                    type="checkbox"
                    checked={form.status}
                    onChange={(event) => setForm({ ...form, status: event.target.checked })}
                    className="accent-[#A98756]"
                  />
                  Thương hiệu đang hoạt động
                </label>
              )}
              <div className="flex justify-end gap-2 pt-3 border-t border-black/5">
                <button
                  type="button"
                  onClick={() => { setFormOpen(false); setEditingItem(null); }}
                  className="px-5 py-2.5 rounded-full border border-black/10 text-zinc-600 text-xs font-bold"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={saving}
                  className="px-5 py-2.5 rounded-full bg-[#0B0B0D] text-[#C6A77B] text-xs font-bold inline-flex items-center gap-2 disabled:opacity-50"
                >
                  {saving && <Loader2 className="w-4 h-4 animate-spin" />}
                  {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
