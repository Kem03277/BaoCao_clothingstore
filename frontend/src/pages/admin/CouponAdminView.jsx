import React, { useEffect, useState } from 'react';
import { Tag, Plus, Edit, Trash2, CheckCircle, AlertCircle, Loader2, X, RefreshCw, Sparkles, Percent, Power, RotateCcw } from 'lucide-react';
import { couponApi } from '../../api';
import { AdminPagination } from './AdminPagination';
import { useAdminNotification, AdminToast } from '../../context/AdminNotificationContext';

export const CouponAdminView = () => {
  const { showConfirm } = useAdminNotification();
  const [coupons, setCoupons] = useState([]);
  const [trashCoupons, setTrashCoupons] = useState([]);
  const [activeTab, setActiveTab] = useState('active');
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCoupon, setEditingCoupon] = useState(null);
  const [formData, setFormData] = useState({
    code: '',
    name: '',
    discountType: 'PERCENTAGE',
    discountValue: 10,
    applyScope: 'ALL',
    minOrderAmount: 0,
    maxDiscount: 50000,
    startAt: '',
    endAt: '',
    status: true,
  });
  const [submitting, setSubmitting] = useState(false);
  const [togglingCouponId, setTogglingCouponId] = useState(null);
  const [feedback, setFeedback] = useState(null);
  const [currentTime, setCurrentTime] = useState(() => Date.now());

  const fetchCoupons = async () => {
    setLoading(true);
    try {
      const [active, trash] = await Promise.all([couponApi.getAll(), couponApi.getTrash()]);
      setCoupons(active || []);
      setTrashCoupons(trash || []);
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi tải mã giảm giá: ' + err.message });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCoupons();
  }, []);

  useEffect(() => {
    const timer = window.setInterval(() => setCurrentTime(Date.now()), 30000);
    return () => window.clearInterval(timer);
  }, []);

  const handleOpenCreate = () => {
    setEditingCoupon(null);
    setFormData({
      code: '',
      name: '',
      discountType: 'PERCENTAGE',
      discountValue: 10,
      applyScope: 'ALL',
      minOrderAmount: 0,
      maxDiscount: 50000,
      startAt: '',
      endAt: '',
      status: true,
    });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (c) => {
    const isPercentage = ['PERCENT', 'PERCENTAGE'].includes(c.discountType?.toUpperCase());
    const convertedDiscountValue = isPercentage
      ? c.discountValue || 0
      : Number(c.minOrderAmount) > 0
        ? Math.min(100, Math.round((c.discountValue / c.minOrderAmount) * 10000) / 100)
        : null;
    if (convertedDiscountValue === null) {
      setFeedback({
        type: 'error',
        message: 'Mã giảm giá cũ không có đơn tối thiểu nên không thể tự quy đổi an toàn. Hãy tạo mã phần trăm mới.',
      });
      return;
    }

    setEditingCoupon(c);
    setFormData({
      code: c.code || '',
      name: c.name || '',
      discountType: 'PERCENTAGE',
      discountValue: convertedDiscountValue,
      applyScope: c.applyScope || 'ALL',
      minOrderAmount: c.minOrderAmount || 0,
      maxDiscount: c.maxDiscount || 0,
      startAt: c.startAt?.slice(0, 16) || '',
      endAt: c.endAt?.slice(0, 16) || '',
      status: c.status !== false,
    });
    setIsModalOpen(true);
    if (!isPercentage) {
      setFeedback({
        type: 'success',
        message: `Mã cũ đã được quy đổi thành ${convertedDiscountValue}% để chỉnh sửa. Lưu lại để áp dụng mức giảm theo phần trăm.`,
      });
    }
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setSubmitting(true);

    try {
      const payload = {
        ...formData,
        startAt: formData.startAt ? `${formData.startAt}:00` : null,
        endAt: formData.endAt ? `${formData.endAt}:00` : null,
      };
      if (editingCoupon) {
        await couponApi.update(editingCoupon.id, payload);
        setFeedback({ type: 'success', message: 'Cập nhật mã giảm giá thành công' });
      } else {
        await couponApi.create(payload);
        setFeedback({ type: 'success', message: 'Tạo mã giảm giá mới thành công' });
      }
      setIsModalOpen(false);
      fetchCoupons();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi: ' + (err.message || 'Không thể lưu mã giảm giá') });
    } finally {
      setSubmitting(false);
    }
  };

  const handleToggleStatus = async (coupon) => {
    const expired = coupon.endAt && new Date(coupon.endAt).getTime() <= currentTime;
    if (togglingCouponId || expired) return;

    setTogglingCouponId(coupon.id);
    try {
      const updatedCoupon = await couponApi.updateStatus(coupon.id, !coupon.status);
      setCoupons((current) => current.map((item) => item.id === coupon.id ? updatedCoupon : item));
      setFeedback({
        type: 'success',
        message: updatedCoupon.status ? 'Đã bật mã giảm giá' : 'Đã tắt mã giảm giá',
      });
    } catch (err) {
      setFeedback({ type: 'error', message: 'Không thể đổi trạng thái: ' + (err.message || err.data?.message || 'Lỗi không xác định') });
    } finally {
      setTogglingCouponId(null);
    }
  };

  const getCouponState = (coupon) => {
    if (coupon.endAt && new Date(coupon.endAt).getTime() <= currentTime) return 'expired';
    if (coupon.startAt && new Date(coupon.startAt).getTime() > currentTime) return 'scheduled';
    return coupon.status ? 'active' : 'disabled';
  };

  const handleDelete = async (id) => {
    const confirmed = await showConfirm({
      title: 'Chuyển vào thùng rác',
      message: 'Bạn có chắc chắn muốn chuyển mã giảm giá này vào thùng rác?',
      type: 'warning',
      confirmText: 'Chuyển vào thùng rác',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await couponApi.delete(id);
      setFeedback({ type: 'success', message: 'Đã chuyển mã giảm giá vào thùng rác thành công' });
      fetchCoupons();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi xóa mã: ' + err.message });
    }
  };

  const handleRestore = async (coupon) => {
    try {
      await couponApi.restore(coupon.id);
      setFeedback({ type: 'success', message: `Đã khôi phục mã ${coupon.code}` });
      fetchCoupons();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Không thể khôi phục mã: ' + (err.message || 'Lỗi máy chủ') });
    }
  };

  const handleDeletePermanently = async (coupon) => {
    const confirmed = await showConfirm({
      title: 'Xóa vĩnh viễn mã giảm giá',
      message: `CẢNH BÁO: Xóa vĩnh viễn mã ${coupon.code}? Thao tác này không thể hoàn tác.`,
      type: 'danger',
      confirmText: 'Xóa vĩnh viễn',
      cancelText: 'Hủy',
    });
    if (!confirmed) return;
    try {
      await couponApi.deletePermanently(coupon.id);
      setFeedback({ type: 'success', message: `Đã xóa vĩnh viễn mã ${coupon.code}` });
      fetchCoupons();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Không thể xóa vĩnh viễn: ' + (err.message || 'Mã có thể đang được đơn hàng sử dụng') });
    }
  };

  const handleRestoreAll = async () => {
    const confirmed = await showConfirm({
      title: 'Khôi phục tất cả chiến dịch',
      message: 'Bạn có chắc muốn khôi phục tất cả chiến dịch trong thùng rác không?',
      type: 'info',
      confirmText: 'Khôi phục tất cả',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await couponApi.restoreAll();
      setFeedback({ type: 'success', message: 'Đã khôi phục tất cả chiến dịch trong thùng rác' });
      fetchCoupons();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Không thể khôi phục chiến dịch: ' + (err.message || 'Lỗi máy chủ') });
    }
  };

  const formatVND = (num) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num || 0);
  const visibleCoupons = activeTab === 'active' ? coupons : trashCoupons;
  const totalPages = Math.max(1, Math.ceil(visibleCoupons.length / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedCoupons = visibleCoupons.slice((safePage - 1) * pageSize, safePage * pageSize);

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Toast Feedback */}
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Chiến dịch quà tặng & voucher</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Mã Giảm Giá & Ưu Đãi
          </h2>
          <p className="text-xs text-zinc-500 mt-1">
            Kiến tạo các chiến dịch chiết khấu độc quyền cho khách hàng thân thiết
          </p>
        </div>

        <div className="flex items-center gap-3 self-start sm:self-auto">
          <button
            onClick={fetchCoupons}
            disabled={loading}
            className="flex items-center gap-2 px-5 py-2.5 rounded-full border border-black/10 bg-white hover:bg-zinc-50 text-[#0B0B0D] text-xs font-bold uppercase tracking-wider shadow-xs transition hover:border-[#C6A77B]/40 cursor-pointer disabled:opacity-50"
          >
            <RefreshCw className={`w-3.5 h-3.5 text-[#C6A77B] ${loading ? 'animate-spin' : ''}`} />
            <span>Tải lại</span>
          </button>

          {activeTab === 'active' && <button
            onClick={handleOpenCreate}
            className="flex items-center gap-2 px-6 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-[#C6A77B] text-xs font-bold uppercase tracking-wider shadow-lg transition hover:scale-105 cursor-pointer"
          >
            <Plus className="w-4 h-4" />
            <span>Tạo mã mới</span>
          </button>}
        </div>
      </div>

      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="inline-flex gap-1 rounded-full bg-black/5 p-1.5">
          {[
            ['active', `Chiến dịch (${coupons.length})`],
            ['trash', `Thùng rác (${trashCoupons.length})`],
          ].map(([tab, label]) => (
            <button
              type="button"
              key={tab}
              onClick={() => { setActiveTab(tab); setCurrentPage(1); }}
              className={`rounded-full px-4 py-2 text-[10px] font-bold uppercase tracking-wider transition ${
                activeTab === tab
                  ? tab === 'trash' ? 'bg-rose-600 text-white shadow' : 'bg-[#0B0B0D] text-[#C6A77B] shadow'
                  : 'text-zinc-600 hover:text-black'
              }`}
            >
              {label}
            </button>
          ))}
        </div>
        {activeTab === 'trash' && trashCoupons.length > 0 && (
          <button
            type="button"
            onClick={handleRestoreAll}
            className="inline-flex items-center gap-2 rounded-full bg-emerald-600 px-4 py-2.5 text-[10px] font-bold uppercase tracking-wider text-white transition hover:bg-emerald-700"
          >
            <RotateCcw className="h-3.5 w-3.5" />
            Khôi phục tất cả
          </button>
        )}
      </div>

      {/* Coupon List */}
      <div className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-16 text-center flex flex-col items-center justify-center gap-3 text-zinc-400">
            <Loader2 className="w-7 h-7 animate-spin text-[#C6A77B]" />
            <span className="text-xs font-medium">Đang tải danh sách coupon...</span>
          </div>
        ) : visibleCoupons.length === 0 ? (
          <div className="p-16 text-center text-zinc-400 text-xs">
            {activeTab === 'trash'
              ? 'Thùng rác chiến dịch đang trống.'
              : 'Chưa có mã giảm giá nào. Nhấn "Tạo mã mới" để bắt đầu chiến dịch ưu đãi.'}
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] text-zinc-600 font-bold uppercase tracking-wider text-[10px] border-b border-black/5">
                <tr>
                  <th className="py-3.5 px-5">Mã Coupon</th>
                  <th className="py-3.5 px-5">Tên chương trình</th>
                  <th className="py-3.5 px-5">Mức giảm giá</th>
                  <th className="py-3.5 px-5">Đơn tối thiểu</th>
                  <th className="py-3.5 px-5">Trạng thái</th>
                  <th className="py-3.5 px-5">Thời hạn</th>
                  <th className="py-3.5 px-5 text-right">Thao tác</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5 text-[#0B0B0D]">
                {paginatedCoupons.map((c) => (
                  <tr key={c.id} className="hover:bg-[#F8F7F4]/50 transition-colors">
                    
                    {/* Code Badge */}
                    <td className="py-3.5 px-5 font-mono">
                      <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg bg-[#0B0B0D] text-[#C6A77B] font-extrabold text-xs tracking-wider border border-[#C6A77B]/30">
                        <Tag className="w-3 h-3 text-[#C6A77B]" />
                        {c.code}
                      </span>
                    </td>

                    {/* Name */}
                    <td className="py-3.5 px-5 font-bold text-[#0B0B0D]">
                      {c.name || 'Ưu đãi Signature'}
                    </td>

                    {/* Discount Value */}
                    <td className="py-3.5 px-5 font-extrabold text-[#0B0B0D] font-mono">
                      {['PERCENT', 'PERCENTAGE'].includes(c.discountType?.toUpperCase())
                        ? `${c.discountValue}% (Tối đa ${formatVND(c.maxDiscount)})`
                        : `${formatVND(c.discountValue)} · mã cũ`}
                    </td>

                    {/* Minimum Order */}
                    <td className="py-3.5 px-5 text-zinc-600 font-mono">
                      {c.minOrderAmount ? formatVND(c.minOrderAmount) : 'Không giới hạn'}
                    </td>

                    {/* Status */}
                    <td className="py-3.5 px-5">
                      {getCouponState(c) === 'expired' ? (
                        <span className="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-rose-50 text-rose-700 border border-rose-200">
                          Hết hạn
                        </span>
                      ) : getCouponState(c) === 'scheduled' ? (
                        <span className="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-amber-50 text-amber-700 border border-amber-200">
                          Chưa bắt đầu
                        </span>
                      ) : c.status ? (
                        <span className="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-800 border border-emerald-200">
                          Đang hoạt động
                        </span>
                      ) : (
                        <span className="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-zinc-100 text-zinc-500">
                          Đã tắt
                        </span>
                      )}
                    </td>

                    <td className="py-3.5 px-5 text-zinc-600">
                      {c.endAt ? new Date(c.endAt).toLocaleString('vi-VN') : 'Không thời hạn'}
                    </td>

                    {/* Actions */}
                    <td className="py-3.5 px-5 text-right">
                      <div className="flex items-center justify-end gap-1.5">
                        {activeTab === 'trash' ? (
                          <>
                            <button
                              type="button"
                              onClick={() => handleRestore(c)}
                              title="Khôi phục chiến dịch"
                              className="inline-flex items-center gap-1.5 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-[10px] font-bold text-emerald-700 hover:bg-emerald-100"
                            >
                              <RotateCcw className="h-3.5 w-3.5" />
                              Khôi phục
                            </button>
                            <button
                              type="button"
                              onClick={() => handleDeletePermanently(c)}
                              title="Xóa vĩnh viễn"
                              className="rounded-full border border-rose-200 bg-rose-50 px-3 py-1.5 text-[10px] font-bold text-rose-700 hover:bg-rose-100"
                            >
                              Xóa vĩnh viễn
                            </button>
                          </>
                        ) : (
                          <>
                        <button
                          onClick={() => handleToggleStatus(c)}
                          title={getCouponState(c) === 'expired' ? 'Coupon đã hết hạn' : c.status ? 'Tắt mã giảm giá' : 'Bật mã giảm giá'}
                          aria-label={c.status ? 'Tắt mã giảm giá' : 'Bật mã giảm giá'}
                          disabled={getCouponState(c) === 'expired' || togglingCouponId !== null}
                          className={`p-2 rounded-xl transition cursor-pointer disabled:cursor-not-allowed disabled:opacity-40 ${
                            c.status
                              ? 'text-emerald-700 hover:bg-rose-50 hover:text-rose-600'
                              : 'text-zinc-400 hover:bg-emerald-50 hover:text-emerald-700'
                          }`}
                        >
                          {togglingCouponId === c.id
                            ? <Loader2 className="w-4 h-4 animate-spin" />
                            : <Power className="w-4 h-4" />}
                        </button>
                        <button
                          onClick={() => handleOpenEdit(c)}
                          title="Sửa ưu đãi"
                          className="p-2 rounded-xl text-zinc-600 hover:text-[#0B0B0D] hover:bg-[#C6A77B]/15 transition cursor-pointer"
                        >
                          <Edit className="w-4 h-4 text-[#C6A77B]" />
                        </button>
                        <button
                          onClick={() => handleDelete(c.id)}
                          title="Xóa ưu đãi"
                          className="p-2 rounded-xl text-zinc-400 hover:text-rose-600 hover:bg-rose-50 transition cursor-pointer"
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
        totalItems={visibleCoupons.length}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {/* Modal Create / Edit */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-lg bg-white rounded-3xl p-7 shadow-2xl space-y-5 border border-black/10">
            <div className="flex items-center justify-between pb-3 border-b border-black/5">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center">
                  <Tag className="w-4 h-4" />
                </div>
                <h3 className="text-base font-extrabold text-[#0B0B0D] tracking-tight">
                  {editingCoupon ? `Sửa Mã Giảm Giá #${editingCoupon.id}` : 'Tạo Mã Giảm Giá Mới'}
                </h3>
              </div>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-400 hover:text-zinc-700 transition"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSave} className="space-y-4 text-xs">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Mã Code Voucher
                  </label>
                  <input
                    type="text"
                    value={formData.code}
                    onChange={(e) => setFormData({ ...formData, code: e.target.value.toUpperCase() })}
                    placeholder="VD: LUXURY20, ATELIER100"
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 font-mono font-bold uppercase focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                </div>

                <div className="flex items-center rounded-xl border border-[#C6A77B]/30 bg-[#C6A77B]/10 px-4 py-2.5 text-xs font-bold text-[#8A653B]">
                  <Percent className="mr-2 h-4 w-4" />
                  Mức giảm giá theo phần trăm
                </div>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Tên chương trình ưu đãi
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="VD: Ưu đãi bộ sưu tập Thu Đông 2026"
                  className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Phần trăm giảm (%)
                  </label>
                  <input
                    type="number"
                    min="0.01"
                    max="100"
                    step="0.01"
                    value={formData.discountValue}
                    onChange={(e) => setFormData({ ...formData, discountValue: parseFloat(e.target.value) || 0 })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Giảm tối đa (VNĐ)
                  </label>
                  <input
                    type="number"
                    value={formData.maxDiscount}
                    onChange={(e) => setFormData({ ...formData, maxDiscount: parseFloat(e.target.value) || 0 })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Giá trị đơn hàng tối thiểu (VNĐ)
                </label>
                <input
                  type="number"
                  value={formData.minOrderAmount}
                  onChange={(e) => setFormData({ ...formData, minOrderAmount: parseFloat(e.target.value) || 0 })}
                  className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Bắt đầu áp dụng
                  </label>
                  <input
                    type="datetime-local"
                    value={formData.startAt}
                    onChange={(e) => setFormData({ ...formData, startAt: e.target.value })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Hết hạn lúc
                  </label>
                  <input
                    type="datetime-local"
                    value={formData.endAt}
                    min={formData.startAt || undefined}
                    onChange={(e) => setFormData({ ...formData, endAt: e.target.value })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>
              </div>

              <div className="flex items-center gap-2 pt-1">
                <input
                  type="checkbox"
                  id="coupon_status"
                  checked={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.checked })}
                  className="w-4 h-4 rounded text-[#C6A77B] focus:ring-[#C6A77B]"
                />
                <label htmlFor="coupon_status" className="font-bold text-zinc-800 text-xs cursor-pointer">
                  Kích hoạt mã giảm giá này ngay lập tức
                </label>
              </div>

              <div className="flex justify-end gap-2.5 pt-4 border-t border-black/5">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-5 py-2.5 rounded-full border border-black/10 text-zinc-700 hover:bg-zinc-50 font-bold uppercase tracking-wider text-[11px]"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={submitting}
                  className="px-6 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-[#C6A77B] font-bold uppercase tracking-wider text-[11px] flex items-center gap-2 shadow-lg disabled:opacity-50"
                >
                  {submitting && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  <span>{submitting ? 'Đang lưu...' : 'Lưu ưu đãi'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
};
