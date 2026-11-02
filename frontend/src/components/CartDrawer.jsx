import React, { useState } from 'react';
import { X, Trash2, ShoppingBag, ArrowRight, Tag } from 'lucide-react';
import { useCart } from '../context/CartContext';
import { couponApi } from '../api';

export const CartDrawer = ({ setCurrentView, onSelectCartProduct }) => {
  const {
    cartItems,
    isCartOpen,
    setIsCartOpen,
    updateQuantity,
    removeFromCart,
    subtotal,
    discountAmount,
    shippingFee,
    totalAmount,
    storeInformation,
    storeInformationError,
    storeInformationLoading,
    appliedCoupon,
    setAppliedCoupon,
  } = useCart();

  const [couponCode, setCouponCode] = useState('');
  const [couponLoading, setCouponLoading] = useState(false);
  const [couponError, setCouponError] = useState('');

  if (!isCartOpen) return null;

  const handleApplyCoupon = async (e) => {
    e.preventDefault();
    if (!couponCode.trim()) return;

    setCouponLoading(true);
    setCouponError('');

    try {
      const result = await couponApi.validate(
        couponCode.trim(),
        cartItems.map((item) => ({ productId: item.id, quantity: item.quantity }))
      );
      setAppliedCoupon({
        ...result.coupon,
        eligibleProductIds: result.eligibleProductIds,
      });
      setCouponCode('');
      setCouponError('');
    } catch (error) {
      setCouponError(error?.data?.message || 'Mã không hợp lệ hoặc đã hết hạn');
    } finally {
      setCouponLoading(false);
    }
  };

  const handleCheckout = () => {
    if (cartItems.length === 0) return;
    setIsCartOpen(false);
    setCurrentView?.('checkout');
  };

  const formatVND = (num) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num || 0);

  return (
    <div className="fixed inset-0 z-50 overflow-hidden">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/60 backdrop-blur-sm transition-opacity"
        onClick={() => setIsCartOpen(false)}
      />

      <div className="fixed inset-y-0 right-0 max-w-full flex pl-10">
        <div className="w-screen max-w-md bg-white dark:bg-[#141416] shadow-2xl flex flex-col justify-between border-l border-black/10 dark:border-white/10 transition-colors duration-300">
          
          {/* Header */}
          <div className="p-6 border-b border-black/5 dark:border-white/10 flex items-center justify-between bg-[#F8F7F4] dark:bg-[#0B0B0D] transition-colors duration-300">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-lg bg-[#0B0B0D] dark:bg-[#1A1A1E] flex items-center justify-center text-[#C6A77B] border border-[#C6A77B]/20">
                <ShoppingBag className="w-4 h-4" />
              </div>
              <div>
                <h2 className="text-base font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider">
                  Giỏ hàng của bạn
                </h2>
                <span className="text-xs text-zinc-500 dark:text-zinc-400 font-medium">
                  {cartItems.length} sản phẩm đã chọn
                </span>
              </div>
            </div>
            <button
              onClick={() => setIsCartOpen(false)}
              className="p-2 rounded-full text-zinc-400 hover:text-zinc-700 dark:hover:text-zinc-200 hover:bg-black/5 dark:hover:bg-white/5 transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Body: Items */}
          <div className="p-6 overflow-y-auto flex-1 divide-y divide-black/5 dark:divide-white/10">
            {cartItems.length === 0 ? (
              <div className="h-full flex flex-col items-center justify-center text-center py-16 text-zinc-400 space-y-3">
                <ShoppingBag className="w-14 h-14 stroke-[1.2] text-zinc-300 dark:text-zinc-600" />
                <p className="text-sm font-semibold text-[#0B0B0D] dark:text-[#F8F7F4]">Giỏ hàng của bạn đang trống</p>
                <p className="text-xs text-zinc-500 dark:text-zinc-400 max-w-xs">
                  Khám phá những thiết kế thời trang tinh tế mới nhất từ bộ sưu tập của chúng tôi.
                </p>
                <button
                  onClick={() => {
                    setIsCartOpen(false);
                    setCurrentView?.('shop');
                  }}
                  className="mt-3 px-5 py-2 rounded-full bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D] text-xs font-bold uppercase tracking-wider hover:bg-black dark:hover:opacity-90 transition cursor-pointer"
                >
                  Khám phá ngay
                </button>
              </div>
            ) : (
              cartItems.map((item) => (
                <div key={item.key} className="py-4 flex gap-4 items-center">
                      <button
                        type="button"
                        onClick={() => onSelectCartProduct?.(item)}
                        aria-label={`Xem chi tiết ${item.name}`}
                        className="w-18 h-22 rounded-xl overflow-hidden bg-zinc-100 dark:bg-zinc-800 border border-black/5 dark:border-white/10 shrink-0 cursor-pointer focus:outline-none focus:ring-2 focus:ring-[#C6A77B]"
                      >
                        <img
                          src={item.image}
                          alt={item.name}
                      className="w-full h-full object-cover"
                      onError={(e) => {
                        e.target.src = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200';
                      }}
                    />
                  </button>
                  <div className="flex-1 min-w-0">
                    <button
                      type="button"
                      onClick={() => onSelectCartProduct?.(item)}
                      className="block max-w-full text-left text-sm font-semibold text-[#0B0B0D] dark:text-[#F8F7F4] truncate hover:text-[#C6A77B] transition cursor-pointer"
                    >
                      {item.name}
                    </button>
                    <p className="text-xs text-zinc-500 dark:text-zinc-400 mt-0.5">
                      Kích cỡ: <span className="font-bold text-[#0B0B0D] dark:text-white">{item.size}</span> · {formatVND(item.price)}
                    </p>

                    {/* Quantity controls */}
                    <div className="flex items-center gap-2 mt-2.5">
                      <div className="flex items-center border border-zinc-200 dark:border-white/10 rounded-lg bg-zinc-50 dark:bg-white/5">
                        <button
                          onClick={() => updateQuantity(item.key, item.quantity - 1)}
                          className="px-2.5 py-0.5 text-xs text-zinc-600 dark:text-zinc-300 hover:text-black dark:hover:text-white font-bold"
                        >
                          -
                        </button>
                        <span className="px-2 text-xs font-bold text-[#0B0B0D] dark:text-white">
                          {item.quantity}
                        </span>
                        <button
                          onClick={() => updateQuantity(item.key, item.quantity + 1)}
                          className="px-2.5 py-0.5 text-xs text-zinc-600 dark:text-zinc-300 hover:text-black dark:hover:text-white font-bold"
                        >
                          +
                        </button>
                      </div>
                      <span className="text-xs font-bold text-[#0B0B0D] dark:text-white ml-auto">
                        {formatVND(item.price * item.quantity)}
                      </span>
                    </div>
                  </div>

                  <button
                    onClick={() => removeFromCart(item.key)}
                    className="p-2 rounded-xl text-zinc-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-500/10 transition"
                    title="Xóa khỏi giỏ"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              ))
            )}
          </div>

          {/* Footer: Coupon & Summary */}
          {cartItems.length > 0 && (
            <div className="p-6 border-t border-black/5 dark:border-white/10 bg-[#F8F7F4] dark:bg-[#0B0B0D] space-y-4 transition-colors duration-300">
              {/* Coupon input */}
              <form onSubmit={handleApplyCoupon} className="flex gap-2">
                <div className="relative flex-1">
                  <Tag className="w-3.5 h-3.5 absolute left-3 top-3 text-zinc-400" />
                  <input
                    type="text"
                    placeholder="MÃ GIẢM GIÁ..."
                    value={couponCode}
                    onChange={(e) => setCouponCode(e.target.value)}
                    className="w-full pl-8 pr-3 py-2 text-xs rounded-xl border border-zinc-200 dark:border-white/10 bg-white dark:bg-[#1A1A1E] text-zinc-900 dark:text-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] uppercase font-semibold"
                  />
                </div>
                <button
                  type="submit"
                  disabled={couponLoading}
                  className="px-4 py-2 rounded-xl text-xs font-bold bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D] hover:bg-black dark:hover:opacity-90 transition disabled:opacity-50 cursor-pointer"
                >
                  {couponLoading ? '...' : 'Áp dụng'}
                </button>
              </form>

              {couponError && <p className="text-xs text-rose-500 font-medium">{couponError}</p>}

              {appliedCoupon && (
                <div className="flex items-center justify-between p-2.5 rounded-xl bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-200 dark:border-emerald-500/20 text-emerald-800 dark:text-emerald-400 text-xs">
                  <span>
                    Mã <strong>{appliedCoupon.code}</strong> đã áp dụng thành công: -{formatVND(discountAmount)}
                  </span>
                  <button
                    onClick={() => setAppliedCoupon(null)}
                    className="text-emerald-900 dark:text-emerald-300 hover:underline font-bold cursor-pointer"
                  >
                    Gỡ
                  </button>
                </div>
              )}

              {/* Price Breakdown */}
              <div className="space-y-1.5 text-xs text-zinc-600 dark:text-zinc-400 pt-2 border-t border-black/5 dark:border-white/10">
                <div className="flex justify-between">
                  <span>Tạm tính</span>
                  <span className="font-semibold text-[#0B0B0D] dark:text-white">{formatVND(subtotal)}</span>
                </div>
                {discountAmount > 0 && (
                  <div className="flex justify-between text-emerald-600 dark:text-emerald-400">
                    <span>Ưu đãi giảm</span>
                    <span className="font-semibold">-{formatVND(discountAmount)}</span>
                  </div>
                )}
                <div className="flex justify-between">
                  <span>Phí vận chuyển</span>
                  <span>
                    {shippingFee === 0 ? (
                      <strong className="text-emerald-600 dark:text-emerald-400">Miễn phí giao hàng</strong>
                    ) : (
                      formatVND(shippingFee)
                    )}
                  </span>
                </div>
                <div className="flex justify-between text-sm font-bold text-[#0B0B0D] dark:text-white pt-2 border-t border-black/10 dark:border-white/10">
                  <span>Tổng thanh toán</span>
                  <span className="text-base text-[#0B0B0D] dark:text-[#C6A77B]">
                    {formatVND(totalAmount)}
                  </span>
                </div>
              </div>

              {/* Checkout Button */}
              <button
                onClick={handleCheckout}
                disabled={cartItems.length === 0}
                className="w-full py-3.5 px-6 rounded-2xl bg-gradient-to-r from-[#0B0B0D] via-[#1c1c22] to-[#0B0B0D] dark:from-[#C6A77B] dark:via-[#E2CEAE] dark:to-[#C6A77B] hover:opacity-95 text-white dark:text-[#0B0B0D] font-bold text-xs uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl transition cursor-pointer disabled:cursor-not-allowed disabled:opacity-50"
              >
                <span>Tiến hành đặt hàng</span>
                <ArrowRight className="w-4 h-4 text-[#C6A77B] dark:text-[#0B0B0D]" />
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
