import React, { useState, useEffect } from "react";
import {
  MapPin,
  CheckCircle,
  ArrowLeft,
  ShoppingBag,
  Plus,
  Truck,
  ShieldCheck,
  CreditCard,
  Check,
  AlertCircle,
  X,
} from "lucide-react";
import { useCart } from "../context/CartContext";
import { useAuth } from "../context/AuthContext";
import { addressApi, userOrderApi, couponApi } from "../api";
import { vnpayApi } from "../api/vnpayApi";
import { VnpayPaymentPage } from "../components/VnpayPaymentPage";

const formatVND = (n) =>
  new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(
    n || 0,
  );

export const CheckoutPage = ({ onBack, onSuccess, onNavigateLogin }) => {
  const { isAuthenticated } = useAuth();
  const {
    cartItems,
    subtotal,
    discountAmount,
    shippingFee,
    totalAmount,
    appliedCoupon,
    setAppliedCoupon,
    clearCart,
    storeInformation,
    storeInformationError,
    storeInformationLoading,
  } = useCart();

  const [addresses, setAddresses] = useState([]);
  const [selectedAddressId, setSelectedAddressId] = useState(null);
  const [addrLoading, setAddrLoading] = useState(true);
  const [note, setNote] = useState("");

  // Quick Address Creation Modal
  const [showAddAddressModal, setShowAddAddressModal] = useState(false);
  const [newAddrForm, setNewAddrForm] = useState({
    recipientName: "",
    phone: "",
    province: "TP. Hồ Chí Minh",
    addressLine: "",
  });
  const [newAddrLoading, setNewAddrLoading] = useState(false);
  const [newAddrError, setNewAddrError] = useState("");

  // Coupon
  const [couponCode, setCouponCode] = useState("");
  const [couponLoading, setCouponLoading] = useState(false);
  const [couponError, setCouponError] = useState("");

  // Order
  const [orderLoading, setOrderLoading] = useState(false);
  const [orderSuccess, setOrderSuccess] = useState(false);
  const [orderError, setOrderError] = useState("");
  const [paymentMethod, setPaymentMethod] = useState("COD");
  const [paymentSession, setPaymentSession] = useState(null);

  useEffect(() => {
    if (isAuthenticated) {
      loadAddresses();
    } else {
      setAddrLoading(false);
    }
  }, [isAuthenticated]);

  const loadAddresses = async () => {
    setAddrLoading(true);
    try {
      const data = await addressApi.getAll();
      setAddresses(data || []);
      if (data && data.length > 0) {
        setSelectedAddressId(data[0].id);
      }
    } catch {
      setAddresses([]);
    } finally {
      setAddrLoading(false);
    }
  };

  const handleCreateAddress = async (e) => {
    e.preventDefault();
    if (
      !newAddrForm.recipientName.trim() ||
      !newAddrForm.phone.trim() ||
      !newAddrForm.addressLine.trim()
    ) {
      setNewAddrError("Vui lòng điền đầy đủ thông tin địa chỉ");
      return;
    }

    setNewAddrLoading(true);
    setNewAddrError("");
    try {
      const created = await addressApi.create(newAddrForm);
      await loadAddresses();
      if (created?.id) setSelectedAddressId(created.id);
      setShowAddAddressModal(false);
      setNewAddrForm({
        recipientName: "",
        phone: "",
        province: "TP. Hồ Chí Minh",
        addressLine: "",
      });
    } catch (err) {
      setNewAddrError(err?.data?.message || "Không thể lưu địa chỉ");
    } finally {
      setNewAddrLoading(false);
    }
  };

  const handleApplyCoupon = async (e) => {
    e.preventDefault();
    if (!couponCode.trim()) return;
    setCouponLoading(true);
    setCouponError("");
    try {
      const result = await couponApi.validate(
        couponCode.trim(),
        cartItems.map((item) => ({
          productId: item.id,
          quantity: item.quantity,
        })),
      );
      setAppliedCoupon({
        ...result.coupon,
        eligibleProductIds: result.eligibleProductIds,
      });
      setCouponCode("");
      setCouponError("");
    } catch (error) {
      setCouponError(error?.data?.message || "Mã không hợp lệ hoặc đã hết hạn");
    } finally {
      setCouponLoading(false);
    }
  };

  const handlePlaceOrder = async () => {
    if (!selectedAddressId) {
      alert("Vui lòng chọn hoặc thêm địa chỉ nhận hàng");
      return;
    }
    if (cartItems.length === 0) {
      alert("Giỏ hàng của bạn đang trống");
      return;
    }

    setOrderLoading(true);
    setOrderError("");
    try {
      const orderRequest = {
        addressId: selectedAddressId,
        couponCode: appliedCoupon?.code || null,
        note: note || null,
        paymentMethod,
        items: cartItems.map((item) => ({
          productId: item.id,
          size: item.size || "M",
          quantity: item.quantity,
          price: item.price,
        })),
      };

      if (paymentMethod === "VNPAY") {
        const payment = await vnpayApi.createPayment(orderRequest);
        setPaymentSession(payment);
        return;
      }

      await userOrderApi.createOrder(orderRequest);

      setOrderSuccess(true);
      clearCart();
      setTimeout(() => {
        onSuccess?.();
      }, 2500);
    } catch (err) {
      setOrderError(
        err?.data?.message ||
          err?.message ||
          "Không thể tạo đơn hàng. Vui lòng thử lại.",
      );
    } finally {
      setOrderLoading(false);
    }
  };

  if (!isAuthenticated) {
    return (
      <div className="max-w-md mx-auto px-4 py-20 text-center space-y-4">
        <div className="w-16 h-16 rounded-full bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center mx-auto shadow-xl">
          <ShoppingBag className="w-8 h-8" />
        </div>
        <h2 className="text-2xl font-bold tracking-tight text-[#0B0B0D]">
          Đăng nhập để thanh toán
        </h2>
        <p className="text-xs text-zinc-500">
          Vui lòng đăng nhập vào tài khoản để bảo mật đơn hàng và theo dõi vận
          chuyển.
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

  if (paymentSession) {
    return (
      <VnpayPaymentPage
        session={paymentSession}
        onPaid={clearCart}
        onContinue={() => onSuccess?.()}
      />
    );
  }

  if (orderSuccess) {
    return (
      <div className="max-w-lg mx-auto px-4 py-24 text-center space-y-4 animate-in fade-in zoom-in-95 duration-500">
        <div className="w-20 h-20 rounded-full bg-emerald-50 border border-emerald-200 text-emerald-600 flex items-center justify-center mx-auto shadow-xl">
          <CheckCircle className="w-10 h-10" />
        </div>
        <span className="text-xs uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
          Đơn hàng hoàn tất
        </span>
        <h2 className="text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
          Đặt Hàng Thành Công!
        </h2>
        <p className="text-xs text-zinc-600 max-w-sm mx-auto leading-relaxed">
          Cảm ơn bạn đã lựa chọn ClothingStore. Chúng tôi đang đóng gói trang
          phục trong hộp quà Signature và bàn giao cho đơn vị vận chuyển.
        </p>
        <div className="inline-flex items-center gap-2 text-xs text-zinc-500 pt-2">
          <Truck className="w-4 h-4 text-[#C6A77B]" />
          <span>Thời gian giao hàng dự kiến: 2 - 3 ngày làm việc</span>
        </div>
        <p className="text-[11px] text-zinc-400 pt-4">
          Hệ thống đang chuyển bạn về trang Lịch sử đơn hàng...
        </p>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      {/* Header */}
      <div className="flex items-center gap-3 mb-8">
        <button
          onClick={onBack}
          className="p-2.5 rounded-full bg-white border border-zinc-200 text-zinc-700 hover:bg-zinc-100 transition shadow-xs"
        >
          <ArrowLeft className="w-4 h-4" />
        </button>
        <div>
          <span className="text-[10px] uppercase tracking-[0.2em] font-bold text-[#C6A77B]">
            Thanh toán an toàn
          </span>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Xác Nhận Đơn Hàng
          </h1>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        {/* Left: Address + Payment + Note */}
        <div className="lg:col-span-7 space-y-6">
          {/* Shipping Address Box */}
          <div className="bg-white rounded-3xl p-6 border border-black/5 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <h2 className="text-base font-bold text-[#0B0B0D] flex items-center gap-2">
                <MapPin className="w-4 h-4 text-[#C6A77B]" />
                Địa Chỉ Nhận Hàng
              </h2>
              <button
                type="button"
                onClick={() => setShowAddAddressModal(true)}
                className="text-xs text-[#C6A77B] hover:underline font-bold flex items-center gap-1 cursor-pointer"
              >
                <Plus className="w-3.5 h-3.5" />
                Thêm địa chỉ mới
              </button>
            </div>

            {addrLoading ? (
              <div className="space-y-2">
                <div className="h-16 rounded-2xl bg-zinc-100 animate-pulse" />
              </div>
            ) : addresses.length === 0 ? (
              <div className="text-center py-8 border-2 border-dashed border-zinc-200 rounded-2xl p-4">
                <MapPin className="w-8 h-8 text-zinc-300 mx-auto mb-2" />
                <p className="text-xs text-zinc-500 font-medium">
                  Bạn chưa có địa chỉ giao hàng nào
                </p>
                <button
                  onClick={() => setShowAddAddressModal(true)}
                  className="mt-3 px-5 py-2 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider hover:bg-black transition"
                >
                  Thêm địa chỉ đầu tiên
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                {addresses.map((addr) => (
                  <label
                    key={addr.id}
                    className={`flex items-start gap-3 p-4 rounded-2xl border-2 cursor-pointer transition ${
                      selectedAddressId === addr.id
                        ? "border-[#0B0B0D] bg-zinc-50/70 shadow-sm"
                        : "border-zinc-100 hover:border-zinc-200"
                    }`}
                  >
                    <input
                      type="radio"
                      name="address"
                      value={addr.id}
                      checked={selectedAddressId === addr.id}
                      onChange={() => setSelectedAddressId(addr.id)}
                      className="mt-1 accent-[#0B0B0D]"
                    />
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <span className="text-sm font-bold text-[#0B0B0D]">
                          {addr.recipientName}
                        </span>
                        <span className="text-xs text-zinc-400">·</span>
                        <span className="text-xs text-zinc-600">
                          {addr.phone}
                        </span>
                      </div>
                      <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                        {addr.addressLine}, {addr.province}
                      </p>
                    </div>
                  </label>
                ))}
              </div>
            )}
          </div>

          {/* Payment Method */}
          <div className="bg-white rounded-3xl p-6 border border-black/5 shadow-sm space-y-3">
            <h2 className="text-base font-bold text-[#0B0B0D] flex items-center gap-2">
              <CreditCard className="w-4 h-4 text-[#C6A77B]" />
              Phương Thức Thanh Toán
            </h2>
            <label
              className={`flex cursor-pointer items-center justify-between rounded-2xl border-2 p-4 transition ${
                paymentMethod === "COD"
                  ? "border-[#0B0B0D] bg-zinc-50"
                  : "border-zinc-100 hover:border-zinc-300"
              }`}
            >
              <div className="flex items-center gap-3">
                <input
                  type="radio"
                  name="paymentMethod"
                  value="COD"
                  checked={paymentMethod === "COD"}
                  onChange={() => setPaymentMethod("COD")}
                  className="accent-[#0B0B0D]"
                />
                <div className="w-8 h-8 rounded-full bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center font-bold text-xs">
                  COD
                </div>
                <div>
                  <p className="text-xs font-bold text-[#0B0B0D]">
                    Thanh toán khi nhận hàng (COD)
                  </p>
                  <p className="text-[11px] text-zinc-500">
                    Thanh toán trực tiếp cho nhân viên giao hàng khi nhận đơn.
                  </p>
                </div>
              </div>
              {paymentMethod === "COD" && (
                <Check className="w-4 h-4 text-[#C6A77B]" />
              )}
            </label>
            <label
              className={`flex cursor-pointer items-center justify-between rounded-2xl border-2 p-4 transition ${
                paymentMethod === "VNPAY"
                  ? "border-[#C6A77B] bg-[#C6A77B]/10"
                  : "border-zinc-100 hover:border-zinc-300"
              }`}
            >
              <div className="flex items-center gap-3">
                <input
                  type="radio"
                  name="paymentMethod"
                  value="VNPAY"
                  checked={paymentMethod === "VNPAY"}
                  onChange={() => setPaymentMethod("VNPAY")}
                  className="accent-[#C6A77B]"
                />
                <div className="flex h-8 w-8 items-center justify-center rounded-full bg-[#0066B3] text-[10px] font-extrabold text-white">
                  VNP
                </div>
                <div>
                  <p className="text-xs font-bold text-[#0B0B0D]">
                    VNPay QR / ATM / Banking
                  </p>
                  <p className="text-[11px] text-zinc-500">
                    Thanh toán trực tuyến an toàn qua cổng VNPay.
                  </p>
                </div>
              </div>
              {paymentMethod === "VNPAY" && (
                <Check className="h-4 w-4 text-[#A88452]" />
              )}
            </label>
          </div>

          {/* Order Note */}
          <div className="bg-white rounded-3xl p-6 border border-black/5 shadow-sm space-y-3">
            <label className="block text-xs font-bold text-[#0B0B0D] uppercase tracking-wider">
              Ghi chú đơn hàng (Tùy chọn)
            </label>
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="Ví dụ: Giao sau 17h, gọi cho tôi trước khi đến, đóng gói cẩn thận..."
              rows={2}
              className="w-full px-4 py-3 rounded-2xl border border-zinc-200 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B] resize-none"
            />
          </div>
        </div>

        {/* Right: Order Summary & Coupon & Submit Button */}
        <div className="lg:col-span-5 space-y-6">
          <div className="bg-white rounded-3xl p-6 border border-black/5 shadow-sm space-y-6 sticky top-24">
            <h2 className="text-base font-bold text-[#0B0B0D]">
              Tóm Tắt Đơn Hàng ({cartItems.length})
            </h2>

            {/* Item list */}
            <div className="space-y-3 max-h-60 overflow-y-auto pr-1 divide-y divide-black/5">
              {cartItems.map((item) => (
                <div
                  key={item.key}
                  className="pt-3 first:pt-0 flex items-center gap-3"
                >
                  <div className="w-12 h-16 rounded-xl overflow-hidden bg-zinc-100 shrink-0 border border-black/5">
                    <img
                      src={item.image}
                      alt={item.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs font-bold text-[#0B0B0D] truncate">
                      {item.name}
                    </p>
                    <p className="text-[11px] text-zinc-500">
                      Size {item.size} · SL: {item.quantity}
                    </p>
                  </div>
                  <span className="text-xs font-bold text-[#0B0B0D] shrink-0">
                    {formatVND(item.price * item.quantity)}
                  </span>
                </div>
              ))}
            </div>

            {/* Coupon Application */}
            <div className="pt-4 border-t border-black/5 space-y-2">
              <label className="block text-[11px] font-bold text-[#0B0B0D] uppercase tracking-wider">
                Mã giảm giá
              </label>
              {appliedCoupon ? (
                <div className="flex items-center justify-between p-3 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-semibold">
                  <span>
                    Mã <strong>{appliedCoupon.code}</strong> đã áp dụng thành
                    công: -{formatVND(discountAmount)}
                  </span>
                  <button
                    onClick={() => setAppliedCoupon(null)}
                    className="text-emerald-900 underline font-bold"
                  >
                    Gỡ
                  </button>
                </div>
              ) : (
                <form onSubmit={handleApplyCoupon} className="flex gap-2">
                  <input
                    type="text"
                    placeholder="NHẬP MÃ GIẢM GIÁ..."
                    value={couponCode}
                    onChange={(e) => setCouponCode(e.target.value)}
                    className="flex-1 px-3.5 py-2 text-xs rounded-xl border border-zinc-200 uppercase font-semibold focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                  <button
                    type="submit"
                    disabled={couponLoading}
                    className="px-4 py-2 rounded-xl bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider hover:bg-black transition disabled:opacity-50"
                  >
                    {couponLoading ? "..." : "Áp dụng"}
                  </button>
                </form>
              )}
              {couponError && (
                <p className="text-[11px] text-rose-500 font-medium">
                  {couponError}
                </p>
              )}
            </div>

            {/* Cost Breakdown */}
            <div className="space-y-2 text-xs text-zinc-600 pt-4 border-t border-black/5">
              <div className="flex justify-between">
                <span>Tạm tính</span>
                <span className="font-semibold text-[#0B0B0D]">
                  {formatVND(subtotal)}
                </span>
              </div>
              {discountAmount > 0 && (
                <div className="flex justify-between text-emerald-600 font-semibold">
                  <span>Ưu đãi giảm giá</span>
                  <span>-{formatVND(discountAmount)}</span>
                </div>
              )}
              <div className="flex justify-between">
                <span>Phí vận chuyển</span>
                <span>
                  {shippingFee === 0 ? (
                    <strong className="text-emerald-600">Miễn phí</strong>
                  ) : (
                    formatVND(shippingFee)
                  )}
                </span>
              </div>
              <div className="flex justify-between text-base font-bold text-[#0B0B0D] pt-3 border-t border-black/10">
                <span>Tổng thanh toán</span>
                <span className="text-lg text-[#0B0B0D]">
                  {formatVND(totalAmount)}
                </span>
              </div>
            </div>

            {/* Error Message if any */}
            {orderError && (
              <div className="p-3 rounded-2xl bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-center gap-2">
                <AlertCircle className="w-4 h-4 shrink-0" />
                <span>{orderError}</span>
              </div>
            )}

            {/* Place Order CTA */}
            <button
              onClick={handlePlaceOrder}
              disabled={
                orderLoading ||
                cartItems.length === 0 ||
                !selectedAddressId
              }
              className="w-full py-4 rounded-full bg-gradient-to-r from-[#0B0B0D] via-[#1c1c22] to-[#0B0B0D] hover:opacity-95 text-white font-bold text-xs uppercase tracking-[0.2em] shadow-xl transition disabled:opacity-50 flex items-center justify-center gap-2 cursor-pointer"
            >
              {orderLoading ? (
                <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <CheckCircle className="w-4 h-4 text-[#C6A77B]" />
                  <span>Xác nhận đặt hàng</span>
                </>
              )}
            </button>

            {/* Guarantees */}
            <div className="pt-2 border-t border-black/5 flex items-center justify-center gap-2 text-[11px] text-zinc-400">
              <ShieldCheck className="w-4 h-4 text-[#C6A77B]" />
              <span>Giao dịch được bảo mật an toàn 100%</span>
            </div>
          </div>
        </div>
      </div>

      {/* Quick Add Address Modal */}
      {showAddAddressModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md p-6 border border-black/10">
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-bold text-base text-[#0B0B0D]">
                Thêm Địa Chỉ Nhận Hàng
              </h3>
              <button
                onClick={() => setShowAddAddressModal(false)}
                className="p-2 rounded-full hover:bg-zinc-100 text-zinc-500"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {newAddrError && (
              <p className="mb-3 text-xs text-rose-500">{newAddrError}</p>
            )}

            <form onSubmit={handleCreateAddress} className="space-y-3">
              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
                  Tên người nhận
                </label>
                <input
                  type="text"
                  placeholder="Ví dụ: Nguyễn Văn A"
                  value={newAddrForm.recipientName}
                  onChange={(e) =>
                    setNewAddrForm((f) => ({
                      ...f,
                      recipientName: e.target.value,
                    }))
                  }
                  required
                  className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
                  Số điện thoại
                </label>
                <input
                  type="tel"
                  placeholder="Ví dụ: 0901234567"
                  value={newAddrForm.phone}
                  onChange={(e) =>
                    setNewAddrForm((f) => ({ ...f, phone: e.target.value }))
                  }
                  required
                  className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
                  Tỉnh / Thành phố
                </label>
                <input
                  type="text"
                  placeholder="TP. Hồ Chí Minh"
                  value={newAddrForm.province}
                  onChange={(e) =>
                    setNewAddrForm((f) => ({ ...f, province: e.target.value }))
                  }
                  required
                  className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
                  Địa chỉ cụ thể (Số nhà, đường, phường/xã)
                </label>
                <input
                  type="text"
                  placeholder="123 Đường Lê Lợi, Phường Bến Nghé, Quận 1"
                  value={newAddrForm.addressLine}
                  onChange={(e) =>
                    setNewAddrForm((f) => ({
                      ...f,
                      addressLine: e.target.value,
                    }))
                  }
                  required
                  className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                />
              </div>

              <div className="flex gap-3 pt-3">
                <button
                  type="button"
                  onClick={() => setShowAddAddressModal(false)}
                  className="flex-1 py-2.5 rounded-xl border border-zinc-200 text-xs font-bold text-zinc-600 hover:bg-zinc-50"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={newAddrLoading}
                  className="flex-1 py-2.5 rounded-xl bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider hover:bg-black transition disabled:opacity-50"
                >
                  {newAddrLoading ? "Đang lưu..." : "Lưu địa chỉ"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
