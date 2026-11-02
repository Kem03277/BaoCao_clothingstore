import React, { useEffect, useState } from 'react';
import {
  AlertCircle,
  CheckCircle,
  Edit,
  Eye,
  FileText,
  Image as ImageIcon,
  Loader2,
  Plus,
  Search,
  Send,
  RotateCcw,
  Trash2,
  X,
} from 'lucide-react';
import { postApi, postCategoryApi } from '../../api';
import { AdminPagination } from './AdminPagination';
import { useAdminNotification, AdminToast } from '../../context/AdminNotificationContext';

const EMPTY_FORM = {
  title: '',
  slug: '',
  thumbnailUrl: '',
  content: '',
  status: 'DRAFT',
  postCategoryId: '',
};

const formatDate = (date) => date
  ? new Intl.DateTimeFormat('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }).format(new Date(date))
  : '—';

const fetchPostRows = () => postApi.getAllForManagement();

export const PostAdminView = () => {
  const { showConfirm } = useAdminNotification();
  const [posts, setPosts] = useState([]);
  const [trashPosts, setTrashPosts] = useState([]);
  const [activeTab, setActiveTab] = useState('active');
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [formOpen, setFormOpen] = useState(false);
  const [editingPost, setEditingPost] = useState(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [feedback, setFeedback] = useState(null);

  const fetchPosts = async () => {
    try {
      const [activeRows, deletedRows] = await Promise.all([fetchPostRows(), postApi.getTrash()]);
      setPosts(activeRows || []);
      setTrashPosts(deletedRows || []);
    } catch (error) {
      setFeedback({ type: 'error', message: `Không thể tải bài viết: ${error.message || 'Lỗi máy chủ'}` });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let active = true;
    Promise.all([fetchPostRows(), postApi.getTrash()])
      .then(([activeRows, deletedRows]) => {
        if (active) {
          setPosts(activeRows || []);
          setTrashPosts(deletedRows || []);
        }
      })
      .catch((error) => {
        if (active) {
          setFeedback({ type: 'error', message: `Không thể tải bài viết: ${error.message || 'Lỗi máy chủ'}` });
        }
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => { active = false; };
  }, []);

  useEffect(() => {
    postCategoryApi.getAll()
      .then((rows) => setCategories(rows || []))
      .catch((error) => setFeedback({
        type: 'error',
        message: `Không thể tải danh mục bài viết: ${error.message || 'Lỗi máy chủ'}`,
      }));
  }, []);

  const showFeedback = (type, message) => {
    setFeedback({ type, message });
    window.setTimeout(() => setFeedback(null), 4500);
  };

  const openCreate = () => {
    setEditingPost(null);
    setForm({ ...EMPTY_FORM, postCategoryId: categories[0]?.id?.toString() || '' });
    setFormOpen(true);
  };

  const openEdit = (post) => {
    setEditingPost(post);
    setForm({
      title: post.title || '',
      slug: post.slug || '',
      thumbnailUrl: post.thumbnailUrl || '',
      content: post.content || '',
      status: post.status || 'DRAFT',
      postCategoryId: post.postCategoryId?.toString() || '',
    });
    setFormOpen(true);
  };

  const handleUpload = async (event) => {
    const file = event.target.files?.[0];
    event.target.value = '';
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      showFeedback('error', 'Vui lòng chọn tệp hình ảnh hợp lệ.');
      return;
    }

    setUploading(true);
    try {
      const uploaded = await postApi.uploadThumbnail(file);
      setForm((current) => ({ ...current, thumbnailUrl: uploaded.url || uploaded.path }));
      showFeedback('success', 'Đã tải ảnh bìa lên thành công.');
    } catch (error) {
      showFeedback('error', `Không thể tải ảnh bìa: ${error.message || 'Vui lòng thử lại'}`);
    } finally {
      setUploading(false);
    }
  };

  const handleSave = async (event) => {
    event.preventDefault();
    if (!categories.length) {
      showFeedback('error', 'Chưa có danh mục bài viết hoạt động để gán cho bài viết.');
      return;
    }
    setSaving(true);
    const request = {
      ...form,
      postCategoryId: Number(form.postCategoryId),
    };

    try {
      if (editingPost) {
        await postApi.update(editingPost.id, request);
      } else {
        await postApi.create(request);
      }
      setFormOpen(false);
      setEditingPost(null);
      showFeedback('success', editingPost ? 'Đã cập nhật bài viết.' : 'Đã tạo bài viết mới.');
      setLoading(true);
      await fetchPosts();
    } catch (error) {
      showFeedback('error', `Không thể lưu bài viết: ${error.message || 'Vui lòng thử lại'}`);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (post) => {
    const confirmed = await showConfirm({
      title: 'Chuyển bài viết vào thùng rác',
      message: `Bạn có chắc muốn chuyển bài viết "${post.title}" vào thùng rác không?`,
      type: 'warning',
      confirmText: 'Chuyển vào thùng rác',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await postApi.delete(post.id);
      showFeedback('success', 'Đã chuyển bài viết vào thùng rác thành công.');
      setLoading(true);
      await fetchPosts();
    } catch (error) {
      showFeedback('error', `Không thể xóa bài viết: ${error.message || 'Vui lòng thử lại'}`);
    }
  };

  const handleRestore = async (post) => {
    try {
      await postApi.restore(post.id);
      showFeedback('success', `Đã khôi phục bài viết "${post.title}".`);
      setLoading(true);
      await fetchPosts();
    } catch (error) {
      showFeedback('error', `Không thể khôi phục bài viết: ${error.message || 'Lỗi máy chủ'}`);
    }
  };

  const handleDeletePermanently = async (post) => {
    const confirmed = await showConfirm({
      title: 'Xóa vĩnh viễn bài viết',
      message: `CẢNH BÁO: Xóa vĩnh viễn bài viết "${post.title}"? Thao tác này không thể hoàn tác.`,
      type: 'danger',
      confirmText: 'Xóa vĩnh viễn',
      cancelText: 'Hủy',
    });
    if (!confirmed) return;
    try {
      await postApi.deletePermanently(post.id);
      showFeedback('success', `Đã xóa vĩnh viễn bài viết "${post.title}".`);
      setLoading(true);
      await fetchPosts();
    } catch (error) {
      showFeedback('error', `Không thể xóa vĩnh viễn bài viết: ${error.message || 'Lỗi máy chủ'}`);
    }
  };

  const handleRestoreAll = async () => {
    const confirmed = await showConfirm({
      title: 'Khôi phục tất cả bài viết',
      message: 'Bạn có chắc muốn khôi phục tất cả bài viết trong thùng rác không?',
      type: 'info',
      confirmText: 'Khôi phục tất cả',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await postApi.restoreAll();
      showFeedback('success', 'Đã khôi phục tất cả bài viết trong thùng rác.');
      setLoading(true);
      await fetchPosts();
    } catch (error) {
      showFeedback('error', `Không thể khôi phục bài viết: ${error.message || 'Lỗi máy chủ'}`);
    }
  };

  const visiblePosts = activeTab === 'active' ? posts : trashPosts;
  const filteredPosts = visiblePosts.filter((post) => (
    (activeTab === 'trash' || statusFilter === 'ALL' || post.status === statusFilter)
      && `${post.title || ''} ${post.postCategoryName || ''}`.toLocaleLowerCase('vi')
        .includes(search.trim().toLocaleLowerCase('vi'))
  ));
  const totalPages = Math.max(1, Math.ceil(filteredPosts.length / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedPosts = filteredPosts.slice((safePage - 1) * pageSize, safePage * pageSize);
  const publishedCount = posts.filter((post) => post.status === 'PUBLISHED').length;
  const draftCount = posts.filter((post) => post.status === 'DRAFT').length;

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      <div className="flex flex-col gap-4 border-b border-black/5 pb-6 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p className="mb-1 text-[10px] font-bold uppercase tracking-[0.25em] text-[#C6A77B]">Editorial desk</p>
          <h2 className="text-2xl font-extrabold tracking-tight text-[#0B0B0D] sm:text-3xl">Quản lý bài viết</h2>
          <p className="mt-1 text-xs text-zinc-500">Tạo bản nháp, xuất bản và cập nhật tạp chí thời trang.</p>
        </div>
        <button
          type="button"
          onClick={openCreate}
          disabled={!categories.length || activeTab === 'trash'}
          className="inline-flex items-center justify-center gap-2 rounded-full bg-[#0B0B0D] px-5 py-2.5 text-xs font-bold uppercase tracking-wider text-[#C6A77B] shadow-sm transition hover:bg-black disabled:cursor-not-allowed disabled:opacity-50"
        >
          <Plus className="h-4 w-4" />
          Tạo bài viết
        </button>
      </div>

      <div className="grid gap-3 sm:grid-cols-3">
        {[
          { label: 'Tổng bài viết', value: posts.length, icon: FileText },
          { label: 'Đã xuất bản', value: publishedCount, icon: Send },
          { label: 'Bản nháp', value: draftCount, icon: Eye },
        ].map((stat) => {
          const Icon = stat.icon;
          return (
            <div key={stat.label} className="flex items-center gap-4 rounded-2xl border border-black/5 bg-white p-4 shadow-sm">
              <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-[#C6A77B]/15 text-[#9A7545]">
                <Icon className="h-5 w-5" />
              </span>
              <span>
                <span className="block text-2xl font-extrabold text-[#0B0B0D]">{stat.value}</span>
                <span className="text-[10px] font-bold uppercase tracking-wider text-zinc-500">{stat.label}</span>
              </span>
            </div>
          );
        })}
      </div>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex flex-wrap items-center gap-2">
          <div className="inline-flex self-start rounded-full bg-black/5 p-1">
            {[
              ['active', `Bài viết (${posts.length})`],
              ['trash', `Thùng rác (${trashPosts.length})`],
            ].map(([value, label]) => (
              <button
                type="button"
                key={value}
                onClick={() => { setActiveTab(value); setCurrentPage(1); }}
                className={`rounded-full px-4 py-2 text-[10px] font-bold uppercase tracking-wider transition ${
                  activeTab === value
                    ? value === 'trash' ? 'bg-rose-600 text-white shadow' : 'bg-[#0B0B0D] text-[#C6A77B] shadow'
                    : 'text-zinc-600 hover:text-black'
                }`}
              >
                {label}
              </button>
            ))}
          </div>
          {activeTab === 'trash' && trashPosts.length > 0 && (
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
        {activeTab === 'active' && <div className="inline-flex self-start rounded-full bg-black/5 p-1">
          {[
            ['ALL', 'Tất cả'],
            ['PUBLISHED', 'Đã xuất bản'],
            ['DRAFT', 'Bản nháp'],
          ].map(([value, label]) => (
            <button
              type="button"
              key={value}
              onClick={() => { setStatusFilter(value); setCurrentPage(1); }}
              className={`rounded-full px-4 py-2 text-[10px] font-bold uppercase tracking-wider transition ${
                statusFilter === value ? 'bg-[#0B0B0D] text-[#C6A77B] shadow' : 'text-zinc-600 hover:text-black'
              }`}
            >
              {label}
            </button>
          ))}
        </div>}
        <label className="relative w-full sm:max-w-xs">
          <Search className="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-zinc-400" />
          <input
            type="search"
            value={search}
            onChange={(event) => { setSearch(event.target.value); setCurrentPage(1); }}
            placeholder="Tìm tiêu đề, danh mục..."
            className="w-full rounded-full border border-zinc-200 bg-white py-2.5 pl-10 pr-4 text-xs outline-none focus:border-[#C6A77B]"
          />
        </label>
      </div>

      <div className="overflow-hidden rounded-3xl border border-black/5 bg-white shadow-sm">
        {loading ? (
          <div className="flex min-h-56 items-center justify-center gap-3 text-sm text-zinc-500">
            <Loader2 className="h-5 w-5 animate-spin text-[#C6A77B]" />
            Đang tải dữ liệu bài viết...
          </div>
        ) : filteredPosts.length === 0 ? (
          <div className="px-6 py-16 text-center">
            <FileText className="mx-auto h-8 w-8 text-[#C6A77B]" />
            <p className="mt-3 text-sm font-semibold text-zinc-700">Chưa có bài viết nào trong danh sách này.</p>
            <p className="mt-1 text-xs text-zinc-500">Tạo bài viết mới để bắt đầu xây dựng tạp chí.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full min-w-[760px] text-left">
              <thead className="bg-zinc-50 text-[10px] uppercase tracking-wider text-zinc-500">
                <tr>
                  <th className="px-5 py-4 font-bold">Bài viết</th>
                  <th className="px-5 py-4 font-bold">Danh mục</th>
                  <th className="px-5 py-4 font-bold">Trạng thái</th>
                  <th className="px-5 py-4 font-bold">Ngày đăng</th>
                  <th className="px-5 py-4 text-right font-bold">Thao tác</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5">
                {paginatedPosts.map((post) => (
                  <tr key={post.id} className="transition hover:bg-zinc-50/70">
                    <td className="px-5 py-4">
                      <div className="flex items-center gap-3">
                        {post.thumbnailUrl ? (
                          <img src={post.thumbnailUrl} alt="" className="h-14 w-20 rounded-xl object-cover" />
                        ) : (
                          <span className="flex h-14 w-20 items-center justify-center rounded-xl bg-zinc-100 text-zinc-400">
                            <ImageIcon className="h-5 w-5" />
                          </span>
                        )}
                        <div className="max-w-sm">
                          <p className="line-clamp-2 text-xs font-bold text-[#0B0B0D]">{post.title}</p>
                          <p className="mt-1 truncate text-[10px] text-zinc-400">/{post.slug}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-5 py-4 text-xs text-zinc-600">{post.postCategoryName || '—'}</td>
                    <td className="px-5 py-4">
                      <span className={`rounded-full px-3 py-1.5 text-[9px] font-bold uppercase tracking-wider ${
                        post.status === 'PUBLISHED'
                          ? 'bg-emerald-50 text-emerald-700'
                          : 'bg-amber-50 text-amber-700'
                      }`}>
                        {post.status === 'PUBLISHED' ? 'Đã xuất bản' : 'Bản nháp'}
                      </span>
                    </td>
                    <td className="px-5 py-4 text-xs text-zinc-500">{formatDate(post.publishedAt || post.createdAt)}</td>
                    <td className="px-5 py-4">
                      <div className="flex justify-end gap-1">
                        {activeTab === 'trash' ? (
                          <>
                            <button
                              type="button"
                              onClick={() => handleRestore(post)}
                              title="Khôi phục bài viết"
                              className="inline-flex items-center gap-1.5 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-[10px] font-bold text-emerald-700 hover:bg-emerald-100"
                            >
                              <RotateCcw className="h-3.5 w-3.5" />
                              Khôi phục
                            </button>
                            <button
                              type="button"
                              onClick={() => handleDeletePermanently(post)}
                              title="Xóa vĩnh viễn"
                              className="rounded-full border border-rose-200 bg-rose-50 px-3 py-1.5 text-[10px] font-bold text-rose-700 hover:bg-rose-100"
                            >
                              Xóa vĩnh viễn
                            </button>
                          </>
                        ) : (
                          <>
                        <button
                          type="button"
                          onClick={() => openEdit(post)}
                          title="Chỉnh sửa bài viết"
                          className="rounded-xl p-2 text-zinc-500 transition hover:bg-[#C6A77B]/15 hover:text-[#8E7049]"
                        >
                          <Edit className="h-4 w-4" />
                        </button>
                        <button
                          type="button"
                          onClick={() => handleDelete(post)}
                          title="Chuyển bài viết vào thùng rác"
                          className="rounded-xl p-2 text-zinc-400 transition hover:bg-rose-50 hover:text-rose-600"
                        >
                          <Trash2 className="h-4 w-4" />
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
        totalItems={filteredPosts.length}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {formOpen && (
        <div className="fixed inset-0 z-[70] flex items-center justify-center overflow-y-auto bg-black/60 p-4 backdrop-blur-sm">
          <div className="my-auto w-full max-w-3xl overflow-hidden rounded-[2rem] bg-white shadow-2xl">
            <div className="flex items-center justify-between border-b border-black/5 px-6 py-5 sm:px-8">
              <div>
                <p className="text-[9px] font-bold uppercase tracking-[0.24em] text-[#A98758]">Editorial desk</p>
                <h3 className="mt-1 text-lg font-extrabold text-[#0B0B0D]">
                  {editingPost ? 'Cập nhật bài viết' : 'Tạo bài viết mới'}
                </h3>
              </div>
              <button
                type="button"
                onClick={() => setFormOpen(false)}
                className="rounded-full p-2 text-zinc-400 transition hover:bg-zinc-100 hover:text-zinc-800"
                aria-label="Đóng biểu mẫu"
              >
                <X className="h-5 w-5" />
              </button>
            </div>
            <form onSubmit={handleSave} className="max-h-[calc(100vh-9rem)] space-y-4 overflow-y-auto p-6 sm:p-8">
              <div className="grid gap-4 sm:grid-cols-2">
                <label className="sm:col-span-2">
                  <span className="mb-1.5 block text-[10px] font-bold uppercase tracking-wider text-zinc-600">Tiêu đề *</span>
                  <input
                    required
                    maxLength={200}
                    value={form.title}
                    onChange={(event) => setForm({ ...form, title: event.target.value })}
                    className="w-full rounded-xl border border-zinc-200 px-4 py-3 text-sm outline-none focus:border-[#C6A77B]"
                    placeholder="Nhập tiêu đề bài viết"
                  />
                </label>
                <label>
                  <span className="mb-1.5 block text-[10px] font-bold uppercase tracking-wider text-zinc-600">Slug (tùy chọn)</span>
                  <input
                    value={form.slug}
                    onChange={(event) => setForm({ ...form, slug: event.target.value })}
                    className="w-full rounded-xl border border-zinc-200 px-4 py-3 text-sm outline-none focus:border-[#C6A77B]"
                    placeholder="tu-dong-tao-tu-tieu-de"
                  />
                </label>
                <label>
                  <span className="mb-1.5 block text-[10px] font-bold uppercase tracking-wider text-zinc-600">Danh mục *</span>
                  <select
                    required
                    value={form.postCategoryId}
                    onChange={(event) => setForm({ ...form, postCategoryId: event.target.value })}
                    className="w-full rounded-xl border border-zinc-200 bg-white px-4 py-3 text-sm outline-none focus:border-[#C6A77B]"
                  >
                    <option value="" disabled>Chọn danh mục</option>
                    {categories.map((category) => (
                      <option key={category.id} value={category.id}>{category.categoryName}</option>
                    ))}
                  </select>
                </label>
                <div className="sm:col-span-2">
                  <span className="mb-1.5 block text-[10px] font-bold uppercase tracking-wider text-zinc-600">Ảnh bìa</span>
                  <div className="flex flex-col gap-3 sm:flex-row">
                    <input
                      value={form.thumbnailUrl}
                      onChange={(event) => setForm({ ...form, thumbnailUrl: event.target.value })}
                      className="min-w-0 flex-1 rounded-xl border border-zinc-200 px-4 py-3 text-sm outline-none focus:border-[#C6A77B]"
                      placeholder="Dán đường dẫn ảnh hoặc tải ảnh lên"
                    />
                    <label className={`inline-flex cursor-pointer items-center justify-center gap-2 rounded-xl border border-zinc-200 px-4 py-3 text-xs font-bold text-zinc-700 transition hover:bg-zinc-50 ${uploading ? 'pointer-events-none opacity-60' : ''}`}>
                      {uploading ? <Loader2 className="h-4 w-4 animate-spin" /> : <ImageIcon className="h-4 w-4 text-[#A98758]" />}
                      {uploading ? 'Đang tải...' : 'Tải ảnh'}
                      <input type="file" accept="image/*" onChange={handleUpload} className="hidden" />
                    </label>
                  </div>
                  {form.thumbnailUrl && (
                    <img src={form.thumbnailUrl} alt="Xem trước ảnh bìa" className="mt-3 h-36 w-full rounded-2xl object-cover sm:w-64" />
                  )}
                </div>
                <label>
                  <span className="mb-1.5 block text-[10px] font-bold uppercase tracking-wider text-zinc-600">Trạng thái</span>
                  <select
                    value={form.status}
                    onChange={(event) => setForm({ ...form, status: event.target.value })}
                    className="w-full rounded-xl border border-zinc-200 bg-white px-4 py-3 text-sm outline-none focus:border-[#C6A77B]"
                  >
                    <option value="DRAFT">Bản nháp</option>
                    <option value="PUBLISHED">Xuất bản</option>
                  </select>
                </label>
                <label className="sm:col-span-2">
                  <span className="mb-1.5 block text-[10px] font-bold uppercase tracking-wider text-zinc-600">Nội dung *</span>
                  <textarea
                    required
                    rows={10}
                    value={form.content}
                    onChange={(event) => setForm({ ...form, content: event.target.value })}
                    className="w-full resize-y rounded-xl border border-zinc-200 px-4 py-3 text-sm leading-6 outline-none focus:border-[#C6A77B]"
                    placeholder="Viết nội dung bài viết..."
                  />
                </label>
              </div>
              <div className="flex flex-col-reverse gap-2 border-t border-black/5 pt-4 sm:flex-row sm:justify-end">
                <button
                  type="button"
                  onClick={() => setFormOpen(false)}
                  className="rounded-full border border-black/10 px-5 py-2.5 text-xs font-bold text-zinc-600 transition hover:bg-zinc-50"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={saving || uploading || !categories.length}
                  className="inline-flex items-center justify-center gap-2 rounded-full bg-[#0B0B0D] px-6 py-2.5 text-xs font-bold uppercase tracking-wider text-[#C6A77B] shadow-lg disabled:opacity-50"
                >
                  {saving && <Loader2 className="h-4 w-4 animate-spin" />}
                  {saving ? 'Đang lưu...' : editingPost ? 'Lưu thay đổi' : 'Tạo bài viết'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
