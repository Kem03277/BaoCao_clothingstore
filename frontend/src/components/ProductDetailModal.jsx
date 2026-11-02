import React, { useState, useMemo, useEffect } from 'react';
import {
  X, ShoppingBag, Check, Truck, RefreshCw,
  Heart, Ruler
} from 'lucide-react';
import { useCart } from '../context/CartContext';
import { useWishlist } from '../context/WishlistContext';
import { calculateProductSizeStock, SIZES } from '../lib/sizeStock';

export const ProductDetailModal = ({
  product,
  onClose,
  onNavigateCheckout,
  initialSize = 'M',
  initialQuantity = 1,
  isEditingCartItem = false,
  productDetailError = '',
  onUpdateCartItem,
}) => {
  const { addToCart } = useCart();
  const { isInWishlist, toggleWishlist } = useWishlist();

  // Tính toán số lượng tồn kho của từng size
  const sizeStock = useMemo(() => calculateProductSizeStock(product), [product]);

  // Khởi tạo size ban đầu: nếu size chỉ định hết hàng, tự động chọn size đầu tiên còn hàng
  const [selectedSize, setSelectedSize] = useState(() => {
    if (initialSize && (sizeStock[initialSize] || 0) > 0) return initialSize;
    const available = SIZES.find((s) => (sizeStock[s] || 0) > 0);
    return available || initialSize || 'M';
  });

  const selectedStock = sizeStock[selectedSize] ?? 0;

  const [quantity, setQuantity] = useState(() => {
    if (selectedStock === 0) return 0;
    return Math.min(Math.max(1, initialQuantity), selectedStock);
  });

  // Tự động điều chỉnh số lượng khi đổi size
  useEffect(() => {
    if (selectedStock === 0) {
      setQuantity(0);
    } else if (quantity === 0) {
      setQuantity(1);
    } else if (quantity > selectedStock) {
      setQuantity(selectedStock);
    }
  }, [selectedSize, selectedStock]);

  const [showSizeGuide, setShowSizeGuide] = useState(false);
  const [addedToast, setAddedToast] = useState(false);
  const [activeImage, setActiveImage] = useState(
    product?.mainImageUrl || product?.additionalImageUrls?.[0] || 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800'
  );

  const allImages = [
    ...(product?.mainImageUrl ? [product.mainImageUrl] : []),
    ...(product?.additionalImageUrls || []),
  ];
  if (allImages.length === 0) {
    allImages.push('https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800');
  }

  if (!product) return null;

  const inWishlist = isInWishlist(product.id);
  const formattedPrice = new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
  }).format(product.price || 0);

  const handleAdd = () => {
    if (selectedStock <= 0) return;
    if (isEditingCartItem) {
      onUpdateCartItem?.(selectedSize, quantity);
      return;
    }
    addToCart(product, quantity, selectedSize);
    setAddedToast(true);
    setTimeout(() => setAddedToast(false), 2000);
  };

  const handleBuyNow = () => {
    if (selectedStock <= 0) return;
    if (isEditingCartItem) {
      onUpdateCartItem?.(selectedSize, quantity, true);
      return;
    }
    addToCart(product, quantity, selectedSize);
    onClose();
    onNavigateCheckout?.();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-md animate-in fade-in duration-300">
      <div className="relative w-full max-w-4xl bg-white dark:bg-[#141416] rounded-3xl shadow-2xl overflow-hidden max-h-[92vh] flex flex-col md:flex-row border border-black/10 dark:border-white/10 transition-colors duration-300">
        
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 z-20 p-2.5 rounded-full bg-white/90 dark:bg-[#202025] hover:bg-white dark:hover:bg-[#2a2a30] text-zinc-700 dark:text-zinc-200 shadow-md transition"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Product Gallery */}
        <div className="md:w-1/2 p-6 bg-[#F8F7F4] dark:bg-[#0B0B0D] flex flex-col justify-between border-b md:border-b-0 md:border-r border-black/5 dark:border-white/10 transition-colors duration-300">
          {/* Main Visual Frame */}
          <div className="relative aspect-[3/4] w-full overflow-hidden rounded-2xl bg-white shadow-sm">
            <img
              src={activeImage}
              alt={product.name}
              className="h-full w-full object-cover object-center transition-all duration-300"
              onError={(e) => {
                e.target.src = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800';
              }}
            />
          </div>

          {/* Product thumbnails */}
          {allImages.length > 1 && (
            <div className="flex gap-2 mt-4 overflow-x-auto pb-1">
              {allImages.map((img, idx) => (
                <button
                  key={idx}
                  onClick={() => setActiveImage(img)}
                  className={`w-14 h-18 rounded-xl overflow-hidden border-2 transition shrink-0 ${
                    activeImage === img
                      ? 'border-[#C6A77B] shadow-md scale-105'
                      : 'border-transparent opacity-60 hover:opacity-100'
                  }`}
                >
                  <img src={img} alt="thumb" className="w-full h-full object-cover" />
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Right: Product Details & Purchase Actions */}
        <div className="md:w-1/2 p-6 pt-14 md:p-8 md:pt-14 flex flex-col justify-between overflow-y-auto bg-white dark:bg-[#141416] transition-colors duration-300">
          <div className="space-y-4">
            {productDetailError && (
              <div className="rounded-xl border border-amber-200 bg-amber-50 px-3 py-2 text-xs font-medium text-amber-800">
                {productDetailError} Đang hiển thị thông tin đã lưu trong giỏ hàng.
              </div>
            )}
            <div className="flex items-center justify-between">
              <span className="text-[11px] font-bold uppercase tracking-[0.2em] text-[#C6A77B]">
                {product.categoryName || 'PREMIUM EDITION'}
              </span>
              <button
                onClick={() => toggleWishlist(product)}
                className={`p-2 rounded-full transition ${
                  inWishlist
                    ? 'text-rose-500 bg-rose-50 dark:bg-rose-500/10'
                    : 'text-zinc-400 hover:text-rose-500 hover:bg-zinc-100 dark:hover:bg-white/5'
                }`}
                title="Yêu thích"
              >
                <Heart className={`w-4 h-4 ${inWishlist ? 'fill-current' : ''}`} />
              </button>
            </div>

            <h2 className="text-2xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4]">
              {product.name}
            </h2>

            <div className="flex items-baseline gap-3">
              <span className="text-2xl font-bold text-[#0B0B0D] dark:text-[#F8F7F4]">
                {formattedPrice}
              </span>
              <span
                className={`text-xs px-2.5 py-0.5 rounded-full font-semibold ${
                  selectedStock > 0
                    ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-700 dark:text-emerald-400'
                    : product.quantity > 0
                      ? 'bg-amber-50 dark:bg-amber-500/10 text-amber-700 dark:text-amber-400'
                      : 'bg-rose-50 dark:bg-rose-500/10 text-rose-700 dark:text-rose-400'
                }`}
              >
                {selectedStock > 0
                  ? `Còn hàng (${product.quantity} chiếc · Size ${selectedSize}: ${selectedStock})`
                  : product.quantity > 0
                    ? `Size ${selectedSize} tạm hết (Tổng còn ${product.quantity})`
                    : 'Hết hàng'}
              </span>
            </div>

            <p className="text-sm text-zinc-600 dark:text-zinc-300 leading-relaxed font-sans pt-2 border-t border-black/5 dark:border-white/10">
              {product.description ||
                'Chất liệu cao cấp được tuyển chọn tỉ mỉ mang lại cảm giác dễ chịu và tôn dáng chuẩn mực. Thiết kế đương đại phù hợp cho cả môi trường công sở lẫn các buổi dạ tiệc sang trọng.'}
            </p>

            {/* Size Selector with per-size quantity */}
            <div className="pt-2">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-baseline gap-2">
                  <label className="text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider">
                    Kích cỡ (Size):
                  </label>
                  {selectedStock > 0 ? (
                    <span className="text-[11px] font-semibold text-[#C6A77B]">
                      · Size {selectedSize}: còn {selectedStock} chiếc
                    </span>
                  ) : (
                    <span className="text-[11px] font-semibold text-rose-500">
                      · Size {selectedSize}: Hết hàng
                    </span>
                  )}
                </div>
                <button
                  type="button"
                  onClick={() => setShowSizeGuide(!showSizeGuide)}
                  className="text-xs text-[#C6A77B] hover:underline flex items-center gap-1 font-medium"
                >
                  <Ruler className="w-3.5 h-3.5" />
                  Bảng kích thước
                </button>
              </div>

              {/* 4 Size Pills with real-time stock */}
              <div className="grid max-w-sm grid-cols-4 gap-2.5">
                {SIZES.map((size) => {
                  const stock = sizeStock[size] || 0;
                  const isOutOfStock = stock === 0;
                  const isSelected = selectedSize === size;

                  return (
                    <button
                      key={size}
                      type="button"
                      disabled={isOutOfStock}
                      onClick={() => setSelectedSize(size)}
                      aria-pressed={isSelected}
                      className={`relative flex flex-col items-center justify-center py-2 px-1 rounded-2xl border transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#C6A77B] focus-visible:ring-offset-2 dark:focus-visible:ring-offset-[#141416] ${
                        isOutOfStock
                          ? 'border-zinc-200/60 bg-zinc-100/60 text-zinc-400 opacity-50 cursor-not-allowed dark:border-white/5 dark:bg-white/[0.02] dark:text-zinc-600'
                          : isSelected
                            ? 'border-[#0B0B0D] bg-[#0B0B0D] text-white shadow-md scale-[1.02] dark:border-[#C6A77B] dark:bg-[#C6A77B] dark:text-[#0B0B0D]'
                            : 'border-zinc-200 bg-white text-zinc-800 hover:border-[#C6A77B] hover:bg-[#C6A77B]/5 dark:border-white/10 dark:bg-white/5 dark:text-zinc-300 dark:hover:border-[#C6A77B]'
                      }`}
                    >
                      <span className="text-sm font-extrabold leading-tight">{size}</span>
                      <span
                        className={`text-[10px] font-semibold mt-0.5 leading-none ${
                          isOutOfStock
                            ? 'text-rose-500 line-through'
                            : isSelected
                              ? 'text-[#C6A77B] dark:text-[#0B0B0D]'
                              : 'text-zinc-400 dark:text-zinc-400'
                        }`}
                      >
                        {isOutOfStock ? 'Hết hàng' : `Còn ${stock}`}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Size guide expandable */}
              {showSizeGuide && (
                <div className="mt-3 overflow-hidden rounded-2xl border border-[#C6A77B]/20 bg-gradient-to-br from-[#FBF8F3] to-white p-4 shadow-sm dark:from-[#1D1B19] dark:to-[#171719] animate-in fade-in duration-200">
                  <div className="mb-3 flex items-center justify-between gap-3">
                    <p className="text-xs font-extrabold uppercase tracking-[0.12em] text-[#0B0B0D] dark:text-white">
                      Gợi ý chọn kích cỡ & Tồn kho
                    </p>
                    <span className="text-[10px] font-semibold text-zinc-500 dark:text-zinc-400">
                      Tham khảo
                    </span>
                  </div>
                  <div className="grid grid-cols-2 gap-2">
                    {[
                      { size: 'S', weight: '45–55 kg', height: '1m50–1m62' },
                      { size: 'M', weight: '56–65 kg', height: '1m63–1m70' },
                      { size: 'L', weight: '66–75 kg', height: '1m71–1m78' },
                      { size: 'XL', weight: '76–85 kg', height: '1m78–1m85' },
                    ].map(({ size, weight, height }) => {
                      const stock = sizeStock[size] || 0;
                      return (
                        <div
                          key={size}
                          className={`flex min-w-0 items-center justify-between rounded-xl border px-2.5 py-2 ${
                            selectedSize === size
                              ? 'border-[#C6A77B]/60 bg-[#C6A77B]/10 dark:bg-[#C6A77B]/15'
                              : 'border-black/5 bg-white/80 dark:border-white/10 dark:bg-white/[0.03]'
                          }`}
                        >
                          <div className="flex items-center gap-2 min-w-0">
                            <span
                              className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-lg text-xs font-extrabold ${
                                selectedSize === size
                                  ? 'bg-[#C6A77B] text-[#0B0B0D]'
                                  : 'bg-zinc-100 text-zinc-700 dark:bg-white/10 dark:text-zinc-200'
                              }`}
                            >
                              {size}
                            </span>
                            <span className="min-w-0">
                              <span className="block text-[11px] font-bold leading-4 text-zinc-800 dark:text-zinc-100 truncate">
                                {weight}
                              </span>
                              <span className="block text-[10px] leading-4 text-zinc-500 dark:text-zinc-400 truncate">
                                {height}
                              </span>
                            </span>
                          </div>
                          <span
                            className={`text-[10px] font-bold px-1.5 py-0.5 rounded-md shrink-0 ml-1.5 ${
                              stock > 0
                                ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-400'
                                : 'bg-rose-50 text-rose-600 dark:bg-rose-500/10 dark:text-rose-400'
                            }`}
                          >
                            {stock > 0 ? `Còn ${stock}` : 'Hết'}
                          </span>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>

            {/* Quantity Stepper with Stock Limit */}
            <div className="pt-2">
              <div className="flex items-center justify-between mb-2">
                <label className="block text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider">
                  Số lượng:
                </label>
                {selectedStock > 0 && (
                  <span className="text-[11px] text-zinc-500 dark:text-zinc-400 font-mono">
                    Tồn kho Size {selectedSize}: <strong className="text-[#0B0B0D] dark:text-white font-bold">{selectedStock}</strong>
                  </span>
                )}
              </div>
              <div className="flex items-center gap-3">
                <div className="flex items-center border border-zinc-200 dark:border-white/10 rounded-xl bg-zinc-50 dark:bg-white/5">
                  <button
                    type="button"
                    disabled={quantity <= 1 || selectedStock === 0}
                    onClick={() => setQuantity((q) => Math.max(1, q - 1))}
                    className="w-9 h-9 flex items-center justify-center text-zinc-600 dark:text-zinc-300 hover:text-black dark:hover:text-white font-bold disabled:opacity-30 disabled:cursor-not-allowed cursor-pointer"
                  >
                    -
                  </button>
                  <span className="w-10 text-center font-bold text-sm text-[#0B0B0D] dark:text-white">
                    {selectedStock === 0 ? 0 : quantity}
                  </span>
                  <button
                    type="button"
                    disabled={quantity >= selectedStock || selectedStock === 0}
                    onClick={() => setQuantity((q) => Math.min(selectedStock, q + 1))}
                    className="w-9 h-9 flex items-center justify-center text-zinc-600 dark:text-zinc-300 hover:text-black dark:hover:text-white font-bold disabled:opacity-30 disabled:cursor-not-allowed cursor-pointer"
                  >
                    +
                  </button>
                </div>

                {selectedStock === 0 ? (
                  <span className="text-xs text-rose-500 font-semibold">
                    Size {selectedSize} đang tạm hết hàng
                  </span>
                ) : quantity >= selectedStock ? (
                  <span className="text-xs text-amber-600 dark:text-amber-400 font-medium">
                    Đã đạt giới hạn số lượng có sẵn
                  </span>
                ) : null}
              </div>
            </div>

            {/* Guarantees */}
            <div className="pt-4 border-t border-black/5 dark:border-white/10 grid grid-cols-2 gap-3 text-xs text-zinc-600 dark:text-zinc-400">
              <div className="flex items-center gap-2">
                <Truck className="w-4 h-4 text-[#C6A77B]" />
                <span>Giao hàng toàn quốc</span>
              </div>
              <div className="flex items-center gap-2">
                <RefreshCw className="w-4 h-4 text-[#C6A77B]" />
                <span>Đổi trả trong 30 ngày</span>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="pt-6 border-t border-black/5 space-y-2 mt-4">
            {addedToast && (
              <div className="p-2.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-semibold flex items-center gap-2 animate-in fade-in duration-200">
                <Check className="w-4 h-4 text-emerald-600" />
                <span>Đã thêm vào giỏ hàng thành công!</span>
              </div>
            )}

            <div className="flex gap-2.5">
              <button
                type="button"
                onClick={handleAdd}
                disabled={product.quantity === 0 || selectedStock === 0}
                className="flex-1 py-3.5 px-4 rounded-2xl bg-[#0B0B0D] hover:bg-black text-white font-bold text-xs uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl transition disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
              >
                <ShoppingBag className="w-4 h-4" />
                <span>
                  {selectedStock === 0
                    ? 'Size hết hàng'
                    : isEditingCartItem
                      ? 'Cập nhật giỏ hàng'
                      : 'Thêm vào giỏ'}
                </span>
              </button>

              <button
                type="button"
                onClick={handleBuyNow}
                disabled={product.quantity === 0 || selectedStock === 0}
                className="flex-1 py-3.5 px-4 rounded-2xl bg-gradient-to-r from-[#C6A77B] to-[#E2CEAE] hover:opacity-95 text-[#0B0B0D] font-bold text-xs uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl transition disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer"
              >
                <span>{isEditingCartItem ? 'Cập nhật & thanh toán' : 'Mua ngay'}</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
