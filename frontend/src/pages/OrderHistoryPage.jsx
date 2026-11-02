import React, { useState, useEffect } from 'react';
import {
  Package, Clock, CheckCircle, XCircle, Truck,
  ChevronDown, ChevronUp, ShoppingBag, Calendar, Search, CreditCard, LoaderCircle,
  AlertTriangle, AlertCircle, X, Tag
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { userOrderApi, productApi } from '../api';
import { vnpayApi } from '../api/vnpayApi';

const formatVND = (n) =>
  new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(n || 0);

const formatDate = (str) => {
  if (!str) return '';
  return new Date(str).toLocaleDateString('vi-VN', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const STATUS_MAP = {
  PENDING: { label: 'Chờ thanh toán', color: 'text-amber-800 bg-amber-50 border-amber-200 dark:text-amber-300 dark:bg-amber-950/40 dark:border-amber-800', icon: Clock },
  NEW: { label: 'Chờ xác nhận', color: 'text-amber-800 bg-amber-50 border-amber-200 dark:text-amber-300 dark:bg-amber-950/40 dark:border-amber-800', icon: Clock },
  CONFIRMED: { label: 'Đã xác nhận', color: 'text-blue-800 bg-blue-50 border-blue-200 dark:text-blue-300 dark:bg-blue-950/40 dark:border-blue-800', icon: CheckCircle },
  SHIPPING: { label: 'Đang vận chuyển', color: 'text-indigo-800 bg-indigo-50 border-indigo-200 dark:text-indigo-300 dark:bg-indigo-950/40 dark:border-indigo-800', icon: Truck },
  DELIVERED: { label: 'Đã nhận hàng', color: 'text-emerald-800 bg-emerald-50 border-emerald-200 dark:text-emerald-300 dark:bg-emerald-950/40 dark:border-emerald-800', icon: CheckCircle },
  CANCELLED: { label: 'Đã hủy', color: 'text-rose-800 bg-rose-50 border-rose-200 dark:text-rose-300 dark:bg-rose-950/40 dark:border-rose-800', icon: XCircle },
};

const CANCEL_REASONS = [
  'Muốn thay đổi địa chỉ hoặc số điện thoại nhận hàng',
  'Muốn thay đổi sản phẩm trong đơn (kích cỡ, màu sắc)',
  'Tìm thấy giá tốt hơn ở nơi khác',
  'Thời gian giao hàng không phù hợp',
  'Đổi ý, không còn nhu cầu mua nữa',
  'Lý do khác',
];

const StatusBadge = ({ status }) => {
  const s = STATUS_MAP[status] || {
    label: status,
    color: 'text-zinc-700 bg-zinc-50 border-zinc-200',
    icon: Package,
  };
  return (
    <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold border ${s.color}`}>
      <s.icon className="w-3.5 h-3.5" />
      {s.label}
    </span>
  );
};

export const OrderHistoryPage = ({ onNavigateLogin, onNavigateShop, onContinuePayment }) => {
  const { isAuthenticated } = useAuth();
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filterStatus, setFilterStatus] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedOrderId, setExpandedOrderId] = useState(null);
  const [retryingOrderId, setRetryingOrderId] = useState(null);
  const [productImagesMap, setProductImagesMap] = useState({});

  // Cancellation modal & feedback state
  const [orderToCancel, setOrderToCancel] = useState(null);
  const [cancelReason, setCancelReason] = useState(CANCEL_REASONS[0]);
  const [customReason, setCustomReason] = useState('');
  const [canceling, setCanceling] = useState(false);
  const [toast, setToast] = useState(null); // { type: 'success' | 'error', title: string, message: string }

  const showToast = (type, title, message) => {
    setToast({ type, title, message });
  };

  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => {
      setToast(null);
    }, 4500);
    return () => clearTimeout(timer);
  }, [toast]);

  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Escape' && orderToCancel && !canceling) {
        setOrderToCancel(null);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [orderToCancel, canceling]);

  useEffect(() => {
    if (isAuthenticated) {
      loadOrders();
    } else {
      setLoading(false);
    }
  }, [isAuthenticated]);

  const loadOrders = async () => {
    setLoading(true);
    try {
      const data = await userOrderApi.getMyOrders();
      const orderList = data || [];
      setOrders(orderList);

      // Collect product IDs that don't have an imageUrl yet
      const missingProductIds = [];
      orderList.forEach((order) => {
        (order.items || order.orderItems || []).forEach((item) => {
          if (!item.imageUrl && !item.mainImageUrl && item.productId) {
            missingProductIds.push(item.productId);
          }
        });
      });

      // Fetch product details for missing images if any
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
          // silently ignore image fetch error
        }
      }
    } catch {
      setOrders([]);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenCancelModal = (order) => {
    setOrderToCancel(order);
    setCancelReason(CANCEL_REASONS[0]);
    setCustomReason('');
  };

  const handleConfirmCancel = async () => {
    if (!orderToCancel) return;
    setCanceling(true);
    try {
      await userOrderApi.cancelMyOrder(orderToCancel.id);
      const code = orderToCancel.orderCode || `#${orderToCancel.id}`;
      setOrderToCancel(null);
      showToast(
        'success',
        'Hủy đơn hàng thành công',
        `Đơn hàng ${code} đã được hủy theo yêu cầu của bạn.`
      );
      await loadOrders();
    } catch (err) {
      const errorMsg =
        err?.message ||
        err?.data?.message ||
        'Không thể hủy đơn hàng lúc này. Vui lòng thử lại sau.';
      showToast('error', 'Không thể hủy đơn hàng', errorMsg);
    } finally {
      setCanceling(false);
    }
  };

  const handleContinuePayment = async (order) => {
    setRetryingOrderId(order.id);
    try {
      const session = await vnpayApi.retryPayment(order.orderCode);
      onContinuePayment?.(session);
    } catch (error) {
      showToast(
        'error',
        'Lỗi thanh toán',
        error?.response?.data?.message || error?.message || 'Không thể tạo lại thanh toán VNPay lúc này.'
      );
      await loadOrders();
    } finally {
      setRetryingOrderId(null);
    }
  };

  if (!isAuthenticated) {
    return (
      <div className="max-w-md mx-auto px-4 py-20 text-center space-y-4">
        <div className="w-16 h-16 rounded-full bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center mx-auto shadow-xl">
          <ShoppingBag className="w-8 h-8" />
        </div>
        <h2 className="text-2xl font-bold tracking-tight text-[#0B0B0D]">Vui lòng đăng nhập</h2>
        <p className="text-xs text-zinc-500">
          Đăng nhập tài khoản để xem toàn bộ lịch sử đơn hàng và tiến trình giao hàng.
        </p>
        <button
          onClick={onNavigateLogin}
          className="mt-4 px-8 py-3.5 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-widest hover:bg-black transition"
        >
          Đăng nhập ngay
        </button>
      </div>
    );
  }

  const filteredOrders = orders.filter((o) => {
    if (filterStatus && o.status !== filterStatus) return false;
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      const code = (o.orderCode || `#${o.id}`).toLowerCase();
      if (!code.includes(q)) return false;
    }
    return true;
  });

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <span className="text-xs uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
            Quản Lý Mua Hàng
          </span>
          <h1 className="text-3xl font-extrabold tracking-tight text-[#0B0B0D] mt-1">
            Lịch Sử Đơn Hàng
          </h1>
        </div>
        <p className="text-xs sm:text-sm text-zinc-500 font-medium">
          {orders.length} đơn hàng đã thực hiện
        </p>
      </div>

      {/* Filters and Search Bar */}
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
          <input
            type="text"
            placeholder="Tìm theo mã đơn hàng..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-2 rounded-full border border-zinc-200 text-xs sm:text-sm bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
          />
        </div>

        <div className="flex items-center gap-2">
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="px-4 py-2 rounded-full border border-zinc-200 text-xs font-bold uppercase tracking-wider text-zinc-700 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] cursor-pointer"
          >
            <option value="">Tất cả trạng thái</option>
            {Object.entries(STATUS_MAP).map(([k, v]) => (
              <option key={k} value={k}>
                {v.label}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* Orders List */}
      {loading ? (
        <div className="space-y-4">
          {[1, 2, 3].map((i) => (
            <div key={i} className="h-24 rounded-3xl bg-white border border-black/5 p-6 animate-pulse" />
          ))}
        </div>
      ) : filteredOrders.length === 0 ? (
        <div className="bg-white rounded-3xl border border-black/5 p-12 text-center space-y-3">
          <Package className="w-14 h-14 text-zinc-300 mx-auto stroke-[1.2]" />
          <h3 className="text-lg font-bold text-[#0B0B0D]">
            {filterStatus ? 'Không có đơn hàng nào với trạng thái này' : 'Chưa có đơn hàng nào'}
          </h3>
          <p className="text-xs text-zinc-500 max-w-sm mx-auto">
            Hãy khám phá các trang phục mới nhất trong bộ sưu tập 2026.
          </p>
          <button
            onClick={onNavigateShop}
            className="mt-2 px-6 py-2.5 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-widest hover:bg-black transition"
          >
            Khám phá cửa hàng
          </button>
        </div>
      ) : (
        <div className="space-y-4">
          {filteredOrders.map((order) => {
            const isExpanded = expandedOrderId === order.id;
            const canCancel = ['NEW', 'CONFIRMED'].includes(order.status);
            const canContinuePayment = order.paymentMethod === 'VNPAY'
              && ['PENDING', 'FAILED'].includes(order.paymentStatus)
              && ['PENDING', 'CANCELLED'].includes(order.status);
            const items = order.items || order.orderItems || [];

            return (
              <div
                key={order.id}
                className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden transition-all duration-300 hover:shadow-md"
              >
                {/* Header Summary Row */}
                <div
                  onClick={() => setExpandedOrderId(isExpanded ? null : order.id)}
                  className="p-5 sm:p-6 flex items-center justify-between gap-4 cursor-pointer"
                >
                  <div className="flex items-center gap-3.5">
                    <div className="w-11 h-11 rounded-2xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center shrink-0">
                      <Package className="w-5 h-5" />
                    </div>
                    <div>
                      <p className="text-sm font-bold text-[#0B0B0D]">
                        {order.orderCode || `#${order.id}`}
                      </p>
                      <p className="text-[11px] text-zinc-400 mt-0.5 flex items-center gap-1.5">
                        <Calendar className="w-3 h-3 text-[#C6A77B]" />
                        {formatDate(order.createdAt)}
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-4">
                    <div className="text-right hidden sm:block">
                      <p className="text-base font-bold text-[#0B0B0D]">
                        {formatVND(order.totalAmount)}
                      </p>
                      <p className="text-[11px] text-zinc-400">{items.length} món đồ</p>
                    </div>

                    <StatusBadge status={order.status} />

                    <button className="p-1 rounded-full text-zinc-400 hover:text-black">
                      {isExpanded ? <ChevronUp className="w-5 h-5" /> : <ChevronDown className="w-5 h-5" />}
                    </button>
                  </div>
                </div>

                {canContinuePayment && (
                  <div className="border-t border-black/5 px-5 pb-4 sm:px-6">
                    <button
                      type="button"
                      onClick={() => handleContinuePayment(order)}
                      disabled={retryingOrderId === order.id}
                      className="inline-flex items-center gap-2 rounded-full bg-[#0B0B0D] px-4 py-2 text-xs font-bold uppercase tracking-wider text-white transition hover:bg-black disabled:cursor-wait disabled:opacity-60"
                    >
                      {retryingOrderId === order.id
                        ? <LoaderCircle className="h-4 w-4 animate-spin" />
                        : <CreditCard className="h-4 w-4 text-[#C6A77B]" />}
                      Tiếp tục thanh toán online
                    </button>
                  </div>
                )}

                {/* Expanded Details */}
                {isExpanded && (
                  <div className="px-6 pb-6 pt-2 border-t border-black/5 space-y-4 animate-in fade-in duration-200">
                    
                    {/* Items List */}
                    <div className="space-y-3 pt-2">
                      <p className="text-xs font-bold text-[#0B0B0D] dark:text-white uppercase tracking-wider">
                        Danh sách sản phẩm:
                      </p>
                      <div className="divide-y divide-black/5 dark:divide-white/5">
                        {items.map((item, idx) => {
                          const itemImg =
                            item.imageUrl ||
                            item.mainImageUrl ||
                            item.image ||
                            item.productImage ||
                            productImagesMap[item.productId] ||
                            'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200';

                          return (
                            <div key={idx} className="py-3 flex items-center justify-between text-xs gap-3.5">
                              <div className="flex items-center gap-3.5 min-w-0">
                                {/* Product Image Thumbnail */}
                                <div className="w-14 h-16 sm:w-16 sm:h-20 rounded-xl bg-[#F8F7F4] dark:bg-[#1a1a1e] overflow-hidden border border-black/5 dark:border-white/10 shrink-0 shadow-2xs group relative">
                                  <img
                                    src={itemImg}
                                    alt={item.productName || item.name || 'Sản phẩm thời trang'}
                                    className="w-full h-full object-cover object-center transition-transform duration-300 group-hover:scale-105"
                                    onError={(e) => {
                                      e.target.onerror = null;
                                      e.target.src = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200';
                                    }}
                                  />
                                </div>
                                <div className="min-w-0 space-y-1">
                                  <p className="font-bold text-[#0B0B0D] dark:text-white line-clamp-2 leading-snug">
                                    {item.productName || item.name || 'Sản phẩm thời trang'}
                                  </p>
                                  <div className="flex flex-wrap items-center gap-2 text-[11px] text-zinc-500 dark:text-zinc-400">
                                    <span className="px-2 py-0.5 rounded-md bg-zinc-100 dark:bg-zinc-800 font-medium text-zinc-700 dark:text-zinc-300">
                                      Size: {item.sizeName || item.size || 'M'}
                                    </span>
                                    <span>·</span>
                                    <span>
                                      Số lượng: <strong className="text-[#0B0B0D] dark:text-white">{item.quantity}</strong>
                                    </span>
                                    {item.unitPrice && (
                                      <>
                                        <span>·</span>
                                        <span>Đơn vị: {formatVND(item.unitPrice)}</span>
                                      </>
                                    )}
                                  </div>
                                </div>
                              </div>
                              <span className="font-extrabold text-[#0B0B0D] dark:text-white text-sm shrink-0">
                                {formatVND(item.lineTotal || (item.unitPrice || item.price) * item.quantity)}
                              </span>
                            </div>
                          );
                        })}
                      </div>
                    </div>

                    {/* Delivery Details */}
                    {(order.shippingAddress || order.recipientName) && (
                      <div className="p-4 rounded-2xl bg-zinc-50 border border-zinc-100 text-xs text-zinc-600 space-y-1">
                        <p className="font-bold text-[#0B0B0D]">Địa chỉ giao hàng:</p>
                        {order.recipientName && (
                          <p>
                            Người nhận: <strong>{order.recipientName}</strong> {order.recipientPhone ? `(${order.recipientPhone})` : ''}
                          </p>
                        )}
                        {order.shippingAddress && <p>{order.shippingAddress}</p>}
                        {order.note && <p className="italic text-zinc-400">Ghi chú: {order.note}</p>}
                      </div>
                    )}

                    {/* Cost Breakdown */}
                    <div className="flex flex-wrap justify-between items-center gap-2 text-xs text-zinc-500 pt-2 border-t border-black/5 dark:border-white/5">
                      <span>Tạm tính: {formatVND(order.subtotal || order.totalAmount)}</span>
                      {order.couponCode || Number(order.discountAmount) > 0 ? (
                        <span className="inline-flex items-center gap-1.5 text-emerald-600 dark:text-emerald-400 font-semibold">
                          <Tag className="w-3.5 h-3.5" />
                          <span>Mã giảm giá ({order.couponCode || 'Voucher'}):</span>
                          <span>-{formatVND(order.discountAmount || 0)}</span>
                        </span>
                      ) : (
                        <span className="text-zinc-400">Mã giảm giá: Không sử dụng</span>
                      )}
                      <span className="font-bold text-[#0B0B0D] dark:text-white text-sm">
                        Tổng thanh toán: {formatVND(order.totalAmount)}
                      </span>
                    </div>

                    {canCancel && (
                      <div className="pt-3 flex justify-end">
                        <button
                          type="button"
                          onClick={() => handleOpenCancelModal(order)}
                          className="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-rose-300/80 text-rose-600 hover:bg-rose-50 hover:border-rose-400 dark:border-rose-900/60 dark:text-rose-400 dark:hover:bg-rose-950/30 text-xs font-bold uppercase tracking-wider transition shadow-2xs cursor-pointer"
                        >
                          <XCircle className="w-3.5 h-3.5" />
                          Hủy đơn hàng này
                        </button>
                      </div>
                    )}

                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {/* Luxury Toast Notification */}
      {toast && (
        <div className="fixed bottom-6 right-6 z-[60] max-w-sm w-[calc(100vw-3rem)] animate-in slide-in-from-bottom-4 fade-in duration-300">
          <div
            className={`p-4 rounded-2xl shadow-2xl border flex items-start gap-3 backdrop-blur-md transition-all ${
              toast.type === 'success'
                ? 'bg-[#0B0B0D]/95 text-white border-[#C6A77B]/40 shadow-black/30'
                : 'bg-rose-950/95 text-white border-rose-800 shadow-rose-950/40'
            }`}
          >
            <div className="p-1 shrink-0 mt-0.5">
              {toast.type === 'success' ? (
                <div className="w-6 h-6 rounded-full bg-[#C6A77B]/20 text-[#C6A77B] flex items-center justify-center">
                  <CheckCircle className="w-4 h-4" />
                </div>
              ) : (
                <div className="w-6 h-6 rounded-full bg-rose-500/20 text-rose-400 flex items-center justify-center">
                  <AlertCircle className="w-4 h-4" />
                </div>
              )}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-xs font-bold uppercase tracking-wider text-[#C6A77B]">
                {toast.title}
              </p>
              <p className="text-xs text-zinc-300 mt-1 leading-relaxed">
                {toast.message}
              </p>
            </div>
            <button
              type="button"
              onClick={() => setToast(null)}
              className="text-zinc-400 hover:text-white p-1 rounded-lg transition shrink-0 cursor-pointer"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      {/* Cancel Order Confirmation Modal */}
      {orderToCancel && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div
            className="fixed inset-0"
            onClick={() => !canceling && setOrderToCancel(null)}
          />
          <div className="relative w-full max-w-md bg-white dark:bg-[#141416] rounded-3xl p-6 sm:p-7 shadow-2xl border border-black/10 dark:border-white/10 z-10 space-y-5 animate-in zoom-in-95 duration-200">
            {/* Close button */}
            <button
              type="button"
              disabled={canceling}
              onClick={() => setOrderToCancel(null)}
              className="absolute top-4 right-4 p-2 rounded-full text-zinc-400 hover:text-zinc-700 dark:hover:text-zinc-200 hover:bg-zinc-100 dark:hover:bg-zinc-800 transition disabled:opacity-50 cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>

            {/* Header Icon & Title */}
            <div className="text-center space-y-2">
              <div className="w-14 h-14 rounded-2xl bg-rose-50 dark:bg-rose-950/40 text-rose-600 dark:text-rose-400 mx-auto flex items-center justify-center border border-rose-100 dark:border-rose-900/50 shadow-sm">
                <AlertTriangle className="w-7 h-7" />
              </div>
              <div>
                <span className="text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
                  Xác Nhận Hủy Đơn
                </span>
                <h3 className="text-xl font-black text-[#0B0B0D] dark:text-white tracking-tight mt-0.5">
                  Bạn có chắc muốn hủy đơn hàng?
                </h3>
              </div>
              <p className="text-xs text-zinc-500 dark:text-zinc-400 leading-relaxed max-w-sm mx-auto">
                Thao tác này sẽ hủy xử lý đơn hàng và không thể hoàn tác sau khi đã xác nhận.
              </p>
            </div>

            {/* Order Brief Info */}
            <div className="p-4 rounded-2xl bg-[#F8F7F4] dark:bg-[#1a1a1e] border border-black/5 dark:border-white/5 space-y-2.5 text-xs">
              <div className="flex items-center justify-between">
                <span className="text-zinc-500 dark:text-zinc-400">Mã đơn hàng:</span>
                <span className="font-mono font-bold text-[#0B0B0D] dark:text-white">
                  {orderToCancel.orderCode || `#${orderToCancel.id}`}
                </span>
              </div>

              {/* Items Preview with Thumbnails */}
              <div className="divide-y divide-black/5 dark:divide-white/5 max-h-36 overflow-y-auto pr-1">
                {(orderToCancel.items || orderToCancel.orderItems || []).map((it, idx) => {
                  const itImg =
                    it.imageUrl ||
                    it.mainImageUrl ||
                    it.image ||
                    it.productImage ||
                    productImagesMap[it.productId] ||
                    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=100';
                  return (
                    <div key={idx} className="py-2 flex items-center justify-between gap-2.5">
                      <div className="flex items-center gap-2.5 min-w-0">
                        <div className="w-10 h-12 rounded-lg bg-zinc-200 dark:bg-zinc-800 overflow-hidden shrink-0 border border-black/5 dark:border-white/10">
                          <img
                            src={itImg}
                            alt={it.productName || it.name}
                            className="w-full h-full object-cover"
                            onError={(e) => {
                              e.target.onerror = null;
                              e.target.src = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=100';
                            }}
                          />
                        </div>
                        <div className="min-w-0">
                          <p className="font-semibold text-[#0B0B0D] dark:text-white truncate">
                            {it.productName || it.name || 'Sản phẩm thời trang'}
                          </p>
                          <p className="text-[10px] text-zinc-400">
                            Size: {it.sizeName || it.size || 'M'} · SL: {it.quantity}
                          </p>
                        </div>
                      </div>
                      <span className="font-bold text-[#0B0B0D] dark:text-white shrink-0 text-right">
                        {formatVND(it.lineTotal || (it.unitPrice || it.price) * it.quantity)}
                      </span>
                    </div>
                  );
                })}
              </div>

              {(orderToCancel.couponCode || Number(orderToCancel.discountAmount) > 0) && (
                <div className="flex items-center justify-between pt-1.5 border-t border-black/5 dark:border-white/5 text-[11px]">
                  <span className="text-zinc-500 dark:text-zinc-400 flex items-center gap-1">
                    <Tag className="w-3 h-3 text-[#C6A77B]" />
                    Mã giảm giá ({orderToCancel.couponCode || 'Voucher'}):
                  </span>
                  <span className="font-semibold text-emerald-600 dark:text-emerald-400 font-mono">
                    -{formatVND(orderToCancel.discountAmount)}
                  </span>
                </div>
              )}

              <div className="flex items-center justify-between pt-1.5 border-t border-black/5 dark:border-white/5">
                <span className="text-zinc-500 dark:text-zinc-400 font-medium">Tổng thanh toán:</span>
                <span className="text-sm font-extrabold text-[#0B0B0D] dark:text-white">
                  {formatVND(orderToCancel.totalAmount)}
                </span>
              </div>
            </div>

            {/* Reason selector */}
            <div className="space-y-2">
              <label className="block text-[11px] font-bold uppercase tracking-wider text-zinc-600 dark:text-zinc-400">
                Lý do hủy đơn hàng:
              </label>
              <div className="space-y-1.5 max-h-40 overflow-y-auto pr-1">
                {CANCEL_REASONS.map((reason) => {
                  const isSelected = cancelReason === reason;
                  return (
                    <button
                      key={reason}
                      type="button"
                      onClick={() => setCancelReason(reason)}
                      className={`w-full text-left p-2.5 rounded-xl text-xs flex items-center justify-between border transition cursor-pointer ${
                        isSelected
                          ? 'border-[#C6A77B] bg-[#C6A77B]/10 dark:bg-[#C6A77B]/15 text-[#0B0B0D] dark:text-white font-semibold'
                          : 'border-zinc-200 dark:border-zinc-800 hover:bg-zinc-50 dark:hover:bg-zinc-800/60 text-zinc-600 dark:text-zinc-300'
                      }`}
                    >
                      <span className="truncate pr-2">{reason}</span>
                      <span
                        className={`w-4 h-4 rounded-full border flex items-center justify-center shrink-0 ${
                          isSelected ? 'border-[#C6A77B] bg-[#C6A77B]' : 'border-zinc-300 dark:border-zinc-700'
                        }`}
                      >
                        {isSelected && <span className="w-1.5 h-1.5 rounded-full bg-white" />}
                      </span>
                    </button>
                  );
                })}
              </div>

              {cancelReason === 'Lý do khác' && (
                <input
                  type="text"
                  placeholder="Nhập lý do cụ thể của bạn..."
                  value={customReason}
                  onChange={(e) => setCustomReason(e.target.value)}
                  maxLength={150}
                  className="w-full px-3.5 py-2 rounded-xl text-xs border border-zinc-200 dark:border-zinc-700 bg-white dark:bg-[#1a1a1e] text-[#0B0B0D] dark:text-white placeholder:text-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] mt-1"
                />
              )}
            </div>

            {/* Actions */}
            <div className="flex flex-col sm:flex-row gap-2.5 pt-1">
              <button
                type="button"
                disabled={canceling}
                onClick={() => setOrderToCancel(null)}
                className="flex-1 py-3 rounded-full border border-zinc-200 dark:border-zinc-700 text-zinc-700 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-zinc-800 text-xs font-bold uppercase tracking-wider transition cursor-pointer disabled:opacity-50"
              >
                Giữ lại đơn hàng
              </button>
              <button
                type="button"
                disabled={canceling}
                onClick={handleConfirmCancel}
                className="flex-1 py-3 rounded-full bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold uppercase tracking-wider transition shadow-lg shadow-rose-600/25 flex items-center justify-center gap-2 cursor-pointer disabled:opacity-50"
              >
                {canceling ? (
                  <>
                    <LoaderCircle className="w-4 h-4 animate-spin" />
                    Đang hủy...
                  </>
                ) : (
                  'Xác nhận hủy đơn'
                )}
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};
