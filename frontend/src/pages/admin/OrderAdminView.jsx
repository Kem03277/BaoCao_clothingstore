import React, { useCallback, useEffect, useState } from 'react';
import {
  ShoppingBag,
  Clock,
  CheckCircle,
  Truck,
  XCircle,
  Eye,
  Filter,
  Loader2,
  Calendar,
  X,
  Phone,
  User,
  MapPin,
  RefreshCw,
  Sparkles,
  ArrowRight,
  Tag,
} from 'lucide-react';
import { orderApi, productApi } from '../../api';
import { AdminPagination } from './AdminPagination';
import { useAdminNotification, AdminToast } from '../../context/AdminNotificationContext';

const ORDER_STATUSES = [
  { key: 'ALL', label: 'Tất cả đơn' },
  { key: 'NEW', label: 'Mới tạo' },
  { key: 'PENDING', label: 'Chờ xử lý' },
  { key: 'CONFIRMED', label: 'Đã xác nhận' },
  { key: 'PROCESSING', label: 'Đang xử lý' },
  { key: 'SHIPPING', label: 'Đang giao hàng' },
  { key: 'SHIPPED', label: 'Đang giao (cũ)' },
  { key: 'DELIVERED', label: 'Đã giao' },
  { key: 'CANCELLED', label: 'Đã hủy' },
];

const getStatusLabel = (status) =>
  ORDER_STATUSES.find(({ key }) => key === status?.toUpperCase())?.label || status || 'Chưa xác định';

const ORDER_STATUS_COLORS = {
  NEW: 'bg-[#C6A77B]/15 text-[#8A653B] border-[#C6A77B]/30',
  PENDING: 'bg-zinc-100 text-zinc-700 border-zinc-200',
  CONFIRMED: 'bg-indigo-50 text-indigo-800 border-indigo-200',
  PROCESSING: 'bg-amber-50 text-amber-800 border-amber-200',
  SHIPPING: 'bg-sky-50 text-sky-800 border-sky-200',
  SHIPPED: 'bg-sky-50 text-sky-800 border-sky-200',
  DELIVERED: 'bg-emerald-50 text-emerald-800 border-emerald-200',
  CANCELLED: 'bg-rose-50 text-rose-800 border-rose-200',
};

export const OrderAdminView = () => {
  const { showConfirm } = useAdminNotification();
  const [orders, setOrders] = useState([]);
  const [totalItems, setTotalItems] = useState(0);
  const [selectedStatus, setSelectedStatus] = useState('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [loading, setLoading] = useState(true);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [actionLoading, setActionLoading] = useState(false);
  const [updatingOrderId, setUpdatingOrderId] = useState(null);
  const [feedback, setFeedback] = useState(null);
  const [productImagesMap, setProductImagesMap] = useState({});

  const fetchOrders = useCallback(async (page) => {
    const pageIndex = typeof page === 'number' ? page : Math.max(0, currentPage - 1);
    setLoading(true);
    try {
      const params = {};
      if (selectedStatus !== 'ALL') {
        params.status = selectedStatus;
      }
      const result = await orderApi.getOrdersPage({ ...params, page: pageIndex, size: pageSize });
      const orderList = result.content || [];
      setOrders(orderList);
      setTotalItems(result.totalElements || 0);

      // Collect product IDs if any items don't have images
      const missingProductIds = [];
      orderList.forEach((order) => {
        (order.items || order.orderItems || []).forEach((item) => {
          if (!item.imageUrl && !item.mainImageUrl && item.productId) {
            missingProductIds.push(item.productId);
          }
        });
      });

      if (missingProductIds.length > 0) {
        try {
          const prods = await productApi.getAll();
          if (Array.isArray(prods)) {
            const map = {};
            prods.forEach((p) => {
              if (p?.id && (p.mainImageUrl || p.additionalImageUrls?.[0])) {
                map[p.id] = p.mainImageUrl || p.additionalImageUrls[0];
              }
            });
            setProductImagesMap(map);
          }
        } catch {
          // ignore fallback error
        }
      }
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi tải đơn hàng: ' + err.message });
    } finally {
      setLoading(false);
    }
  }, [currentPage, selectedStatus]);

  const handleViewOrder = async (order) => {
    setSelectedOrder(order);
    try {
      const fullOrder = await orderApi.getOrderById(order.id);
      if (fullOrder) {
        setSelectedOrder(fullOrder);
      }
    } catch {
      // keep existing order
    }
  };

  useEffect(() => {
    fetchOrders();
  }, [fetchOrders]);

  const totalPages = Math.max(1, Math.ceil(totalItems / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedOrders = orders;

  const handleUpdateStatus = async (orderId, newStatus) => {
    setActionLoading(true);
    setUpdatingOrderId(orderId);
    try {
      const updatedOrder = await orderApi.updateStatus(orderId, newStatus);
      const updatedStatus = updatedOrder.status || newStatus;
      setFeedback({ type: 'success', message: `Đã đổi trạng thái đơn sang: ${getStatusLabel(updatedStatus)}` });
      await fetchOrders();
      if (selectedOrder && selectedOrder.id === orderId) {
        setSelectedOrder({ ...selectedOrder, ...updatedOrder, status: updatedStatus });
      }
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi cập nhật: ' + err.message });
    } finally {
      setActionLoading(false);
      setUpdatingOrderId(null);
    }
  };

  const handleCancelOrder = async (orderId) => {
    const confirmed = await showConfirm({
      title: 'Hủy đơn hàng',
      message: 'Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này sẽ cập nhật trạng thái đơn thành Đã Hủy.',
      type: 'danger',
      confirmText: 'Hủy đơn hàng',
      cancelText: 'Quay lại',
    });
    if (!confirmed) return;
    setActionLoading(true);
    try {
      await orderApi.cancelOrder(orderId);
      setFeedback({ type: 'success', message: 'Đã hủy đơn hàng thành công' });
      await fetchOrders();
      if (selectedOrder && selectedOrder.id === orderId) {
        setSelectedOrder({ ...selectedOrder, status: 'CANCELLED' });
      }
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi hủy đơn: ' + err.message });
    } finally {
      setActionLoading(false);
    }
  };

  const formatVND = (num) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num || 0);

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Toast Feedback */}
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      {/* Title & Refresh */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Xử lý luân chuyển đơn</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Quản Lý Đơn Hàng
          </h2>
          <p className="text-xs text-zinc-500 mt-1">
            Theo dõi, kiểm tra chi tiết và điều phối tiến trình giao hàng trang phục cao cấp
          </p>
        </div>

        <button
          onClick={() => fetchOrders()}
          disabled={loading}
          className="self-start sm:self-auto flex items-center gap-2 px-5 py-2.5 rounded-full border border-black/10 bg-white hover:bg-zinc-50 text-[#0B0B0D] text-xs font-bold uppercase tracking-wider shadow-xs transition hover:border-[#C6A77B]/40 cursor-pointer disabled:opacity-50"
        >
          <RefreshCw className={`w-3.5 h-3.5 text-[#C6A77B] ${loading ? 'animate-spin' : ''}`} />
          <span>Làm mới danh sách</span>
        </button>
      </div>

      {/* Filter Status Pills */}
      <div className="flex flex-wrap gap-2 p-1.5 bg-black/5 rounded-full max-w-fit">
        {ORDER_STATUSES.map((st) => (
          <button
            key={st.key}
            onClick={() => { setSelectedStatus(st.key); setCurrentPage(1); }}
            className={`px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider transition-all duration-200 cursor-pointer ${
              selectedStatus === st.key
                ? 'bg-[#0B0B0D] text-[#C6A77B] shadow-md'
                : 'text-zinc-600 hover:text-[#0B0B0D]'
            }`}
          >
            {st.label}
          </button>
        ))}
      </div>

      {/* Orders Table */}
      <div className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-16 text-center flex flex-col items-center justify-center gap-3 text-zinc-400">
            <Loader2 className="w-7 h-7 animate-spin text-[#C6A77B]" />
            <span className="text-xs font-medium">Đang tải danh sách đơn hàng...</span>
          </div>
        ) : orders.length === 0 ? (
          <div className="p-16 text-center text-zinc-400 text-xs">
            Không có đơn hàng nào phù hợp với bộ lọc.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] text-zinc-600 font-bold uppercase tracking-wider text-[10px] border-b border-black/5">
                <tr>
                  <th className="py-3.5 px-5">Mã đơn</th>
                  <th className="py-3.5 px-5">Người nhận</th>
                  <th className="py-3.5 px-5">Số điện thoại</th>
                  <th className="py-3.5 px-5">Mã giảm giá</th>
                  <th className="py-3.5 px-5">Tổng tiền</th>
                  <th className="py-3.5 px-5">Trạng thái</th>
                  <th className="py-3.5 px-5">Ngày tạo</th>
                  <th className="py-3.5 px-5 text-right">Chi tiết</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5 text-[#0B0B0D]">
                {paginatedOrders.map((order) => (
                  <tr key={order.id} className="hover:bg-[#F8F7F4]/50 transition-colors">
                    
                    {/* Code */}
                    <td className="py-3.5 px-5 font-mono font-bold text-[#0B0B0D]">
                      {order.orderCode || `#${order.id}`}
                    </td>

                    {/* Customer */}
                    <td className="py-3.5 px-5 font-bold text-[#0B0B0D]">
                      {order.recipientName || order.receiverName || order.userName || order.user?.fullName || 'Khách hàng'}
                    </td>

                    {/* Phone */}
                    <td className="py-3.5 px-5 font-mono text-zinc-500">
                      {order.recipientPhone || order.receiverPhone || order.user?.phone || 'Chưa cung cấp'}
                    </td>

                    {/* Voucher / Coupon */}
                    <td className="py-3.5 px-5">
                      {order.couponCode || Number(order.discountAmount) > 0 ? (
                        <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-200 text-[10px] font-bold">
                          <Tag className="w-3 h-3 text-emerald-600" />
                          <span>{order.couponCode || 'Voucher'}</span>
                          {Number(order.discountAmount) > 0 && (
                            <span className="font-mono text-emerald-600">(-{formatVND(order.discountAmount)})</span>
                          )}
                        </span>
                      ) : (
                        <span className="text-zinc-400 font-mono text-[11px] italic">Không dùng</span>
                      )}
                    </td>

                    {/* Total Amount */}
                    <td className="py-3.5 px-5 font-extrabold text-[#0B0B0D] font-mono">
                      {formatVND(order.totalAmount || order.totalPrice)}
                    </td>

                    {/* Inline status update */}
                    <td className="py-3.5 px-5">
                      <div className="relative inline-flex items-center">
                        <select
                          aria-label={`Đổi trạng thái đơn ${order.orderCode || order.id}`}
                          value={order.status?.toUpperCase() || ''}
                          onChange={(event) => handleUpdateStatus(order.id, event.target.value)}
                          disabled={actionLoading}
                          className={`appearance-none cursor-pointer rounded-full border py-1 pl-3 pr-7 text-[10px] font-bold uppercase tracking-wider outline-none transition focus:ring-2 focus:ring-[#C6A77B]/40 disabled:cursor-wait disabled:opacity-60 ${
                            ORDER_STATUS_COLORS[order.status?.toUpperCase()] || 'border-zinc-200 bg-zinc-100 text-zinc-700'
                          }`}
                        >
                          {ORDER_STATUSES.filter(({ key }) => key !== 'ALL').map(({ key, label }) => (
                            <option key={key} value={key}>{label}</option>
                          ))}
                        </select>
                        {updatingOrderId === order.id ? (
                          <Loader2 className="pointer-events-none absolute right-2 h-3 w-3 animate-spin" />
                        ) : (
                          <span className="pointer-events-none absolute right-2 text-[9px]">▼</span>
                        )}
                      </div>
                    </td>

                    {/* Created Date */}
                    <td className="py-3.5 px-5 text-zinc-400 font-mono text-[11px]">
                      {order.createdAt ? new Date(order.createdAt).toLocaleDateString('vi-VN') : 'Mới'}
                    </td>

                    {/* Actions */}
                    <td className="py-3.5 px-5 text-right">
                      <button
                        onClick={() => handleViewOrder(order)}
                        className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-full bg-[#0B0B0D] hover:bg-black text-[#C6A77B] text-[11px] font-bold uppercase tracking-wider transition shadow-sm cursor-pointer"
                      >
                        <Eye className="w-3.5 h-3.5" />
                        <span>Xem</span>
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
      <AdminPagination
        totalItems={totalItems}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {/* ── Order Detail Modal ── */}
      {selectedOrder && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-2xl bg-white rounded-3xl p-7 shadow-2xl space-y-6 max-h-[90vh] overflow-y-auto border border-black/10">
            
            {/* Header */}
            <div className="flex items-center justify-between pb-4 border-b border-black/5">
              <div>
                <span className="text-[10px] font-bold text-[#C6A77B] uppercase tracking-widest">
                  Chi tiết đơn hàng
                </span>
                <h3 className="text-xl font-extrabold text-[#0B0B0D] tracking-tight mt-0.5">
                  Đơn hàng {selectedOrder.orderCode || `#${selectedOrder.id}`}
                </h3>
              </div>
              <button
                onClick={() => setSelectedOrder(null)}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-400 hover:text-zinc-700 transition"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Receiver & Shipping Info */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 p-4 rounded-2xl bg-[#F8F7F4] border border-black/5 text-xs">
              <div className="space-y-1">
                <p className="font-bold text-zinc-400 uppercase tracking-widest text-[10px]">Người nhận hàng</p>
                <p className="font-extrabold text-[#0B0B0D] text-sm">
                  {selectedOrder.recipientName || selectedOrder.receiverName || selectedOrder.userName || 'Khách vãng lai'}
                </p>
                <p className="font-mono text-zinc-600">
                  {selectedOrder.recipientPhone || selectedOrder.receiverPhone || 'Chưa cung cấp số điện thoại'}
                </p>
              </div>
              <div className="space-y-1">
                <p className="font-bold text-zinc-400 uppercase tracking-widest text-[10px]">Địa chỉ giao hàng</p>
                <p className="text-zinc-700 leading-relaxed font-medium">
                  {selectedOrder.shippingAddress || selectedOrder.address || 'Giao tại xưởng'}
                </p>
                {selectedOrder.note && (
                  <p className="italic text-zinc-400 text-[11px] pt-1">
                    Ghi chú: {selectedOrder.note}
                  </p>
                )}
              </div>
            </div>

            {/* Item Breakdown */}
            {(() => {
              const orderItems = selectedOrder.items || selectedOrder.orderItems || [];
              return (
                <div className="space-y-3">
                  <h4 className="text-xs font-bold uppercase tracking-wider text-zinc-500">
                    Sản phẩm trong kiện hàng ({orderItems.length})
                  </h4>
                  {orderItems.length === 0 ? (
                    <div className="p-6 text-center text-zinc-400 text-xs border border-dashed border-black/10 rounded-2xl bg-zinc-50/50">
                      Chưa có danh sách sản phẩm chi tiết cho đơn hàng này.
                    </div>
                  ) : (
                    <div className="divide-y divide-black/5 border border-black/5 rounded-2xl p-2 bg-white max-h-60 overflow-y-auto">
                      {orderItems.map((it, idx) => {
                        const itImg =
                          it.imageUrl ||
                          it.mainImageUrl ||
                          it.image ||
                          it.productImage ||
                          it.product?.mainImageUrl ||
                          productImagesMap[it.productId] ||
                          'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=100';

                        return (
                          <div key={idx} className="p-3 flex items-center justify-between text-xs gap-3">
                            <div className="flex items-center gap-3.5 min-w-0">
                              <div className="w-12 h-14 rounded-xl bg-zinc-100 overflow-hidden border border-black/5 shrink-0 shadow-2xs">
                                <img
                                  src={itImg}
                                  alt={it.productName || it.name || 'Sản phẩm'}
                                  className="w-full h-full object-cover"
                                  onError={(e) => {
                                    e.target.onerror = null;
                                    e.target.src = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=100';
                                  }}
                                />
                              </div>
                              <div className="min-w-0 space-y-1">
                                <p className="font-bold text-[#0B0B0D] truncate">
                                  {it.productName || it.name || it.product?.name || 'Sản phẩm Atelier'}
                                </p>
                                <div className="flex flex-wrap items-center gap-2 text-[11px] text-zinc-400 font-mono">
                                  <span className="px-1.5 py-0.5 rounded bg-zinc-100 text-zinc-700 font-medium">
                                    Size: {it.sizeName || it.size || 'M'}
                                  </span>
                                  <span>·</span>
                                  <span>
                                    Số lượng: <strong className="text-[#0B0B0D]">{it.quantity}</strong>
                                  </span>
                                  {it.unitPrice && (
                                    <>
                                      <span>·</span>
                                      <span>Đơn giá: {formatVND(it.unitPrice)}</span>
                                    </>
                                  )}
                                </div>
                              </div>
                            </div>
                            <span className="font-extrabold text-[#0B0B0D] font-mono shrink-0">
                              {formatVND(it.lineTotal || (it.unitPrice || it.price) * it.quantity)}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                  )}
                </div>
              );
            })()}

            {/* Financial Summary */}
            <div className="p-4 rounded-2xl bg-[#0B0B0D] text-white space-y-2.5 text-xs">
              <div className="flex justify-between items-center text-zinc-400">
                <span>Tạm tính:</span>
                <span className="font-mono text-white">
                  {formatVND(selectedOrder.subtotal || selectedOrder.totalAmount)}
                </span>
              </div>

              {/* Discount / Coupon row */}
              <div className="flex justify-between items-center">
                <span className="flex items-center gap-1.5 text-zinc-400">
                  <Tag className="w-3.5 h-3.5 text-[#C6A77B]" />
                  <span>Mã giảm giá (Coupon):</span>
                  {selectedOrder.couponCode && (
                    <span className="px-2 py-0.5 rounded-md bg-[#C6A77B]/20 text-[#C6A77B] font-mono font-bold text-[10px] uppercase">
                      {selectedOrder.couponCode}
                    </span>
                  )}
                </span>
                {Number(selectedOrder.discountAmount) > 0 ? (
                  <span className="font-bold text-emerald-400 font-mono">
                    -{formatVND(selectedOrder.discountAmount)}
                  </span>
                ) : (
                  <span className="text-zinc-500 italic">Không sử dụng</span>
                )}
              </div>

              {Number(selectedOrder.shippingFee) > 0 && (
                <div className="flex justify-between items-center text-zinc-400">
                  <span>Phí vận chuyển:</span>
                  <span className="font-mono text-white">
                    {formatVND(selectedOrder.shippingFee)}
                  </span>
                </div>
              )}

              <div className="pt-2 border-t border-white/10 flex justify-between items-center">
                <span className="font-bold text-zinc-300 uppercase tracking-wider">
                  Tổng thanh toán {selectedOrder.paymentMethod ? `(${selectedOrder.paymentMethod})` : ''}
                </span>
                <span className="text-xl font-extrabold text-[#C6A77B] font-mono">
                  {formatVND(selectedOrder.totalAmount || selectedOrder.totalPrice)}
                </span>
              </div>
            </div>

            {/* Status Change Selector */}
            <div className="pt-2 border-t border-black/5 space-y-3">
              <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider">
                Chuyển trạng thái đơn hàng
              </label>
              <div className="flex flex-wrap gap-2">
                {ORDER_STATUSES.filter(({ key }) => key !== 'ALL').map(({ key: st, label }) => (
                  <button
                    key={st}
                    onClick={() => handleUpdateStatus(selectedOrder.id, st)}
                    disabled={actionLoading || selectedOrder.status?.toUpperCase() === st}
                    className={`px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider transition shadow-2xs cursor-pointer ${
                      selectedOrder.status === st
                        ? 'bg-[#0B0B0D] text-[#C6A77B] border border-[#C6A77B]/40'
                        : 'border border-black/10 bg-white hover:bg-zinc-50 text-zinc-700 hover:border-[#C6A77B]/40'
                    } disabled:opacity-50`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </div>

          </div>
        </div>
      )}

    </div>
  );
};
