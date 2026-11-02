import React, { useEffect } from 'react';
import { Check, ShoppingBag, X } from 'lucide-react';
import { useCart } from '../context/CartContext';
import './CartNotification.css';

export const CartNotification = () => {
  const { cartNotification, dismissCartNotification } = useCart();

  useEffect(() => {
    if (!cartNotification) return undefined;

    const timer = window.setTimeout(dismissCartNotification, 3000);
    return () => window.clearTimeout(timer);
  }, [cartNotification, dismissCartNotification]);

  if (!cartNotification) return null;

  return (
    <div
      key={cartNotification.id}
      role="status"
      aria-live="polite"
      className="cart-notification fixed bottom-[calc(1rem+env(safe-area-inset-bottom))] right-4 z-[110] w-[min(24rem,calc(100vw-2rem))] overflow-hidden rounded-2xl border border-[#C6A77B]/30 bg-[#111113] text-white shadow-2xl sm:bottom-6 sm:right-6"
    >
      <div className="flex items-start gap-3.5 p-4">
        <div className="relative flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-[#C6A77B]/15 text-[#D8BB91]">
          <ShoppingBag className="h-5 w-5" />
          <span className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full border-2 border-[#111113] bg-emerald-500 text-white">
            <Check className="h-3 w-3" strokeWidth={3} />
          </span>
        </div>

        <div className="min-w-0 flex-1 pt-0.5">
          <p className="text-sm font-bold text-white">
            Đã thêm 1 sản phẩm vào giỏ hàng
          </p>
          <p className="mt-1 truncate text-xs text-zinc-400">
            {cartNotification.productName}
          </p>
        </div>

        <button
          type="button"
          onClick={dismissCartNotification}
          aria-label="Đóng thông báo"
          className="rounded-lg p-1 text-zinc-500 transition hover:bg-white/10 hover:text-white"
        >
          <X className="h-4 w-4" />
        </button>
      </div>
      <div className="cart-notification__progress h-0.5 bg-[#C6A77B]" />
    </div>
  );
};
