import React from 'react';
import { ShoppingBag, Eye, Heart } from 'lucide-react';
import { useCart } from '../context/CartContext';
import { useWishlist } from '../context/WishlistContext';

export const ProductCard = ({ product, onSelect }) => {
  const { addToCart } = useCart();
  const { isInWishlist, toggleWishlist } = useWishlist();

  const inWishlist = isInWishlist(product.id);

  const formattedPrice = new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
  }).format(product.price || 0);

  const imageUrl =
    product.mainImageUrl ||
    product.additionalImageUrls?.[0] ||
    'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80';

  const handleQuickAdd = (e) => {
    e.stopPropagation();
    addToCart(product, 1, 'M', { openCart: false, showNotification: true });
  };

  const handleToggleWishlist = (e) => {
    e.stopPropagation();
    toggleWishlist(product);
  };

  return (
    <div
      onClick={() => onSelect?.(product)}
      className="group relative flex flex-col justify-between bg-white dark:bg-[#141416] rounded-2xl border border-black/5 dark:border-white/10 overflow-hidden shadow-sm hover:shadow-2xl hover:-translate-y-1.5 transition-all duration-500 cursor-pointer"
    >
      {/* Visual Image Container with 3:4 aspect ratio */}
      <div className="relative aspect-[3/4] w-full overflow-hidden bg-[#F2EDE6] dark:bg-[#1A1A1E]">
        <img
          src={imageUrl}
          alt={product.name}
          className="h-full w-full object-cover object-center group-hover:scale-108 transition-transform duration-700 ease-out"
          onError={(e) => {
            e.target.src =
              'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800&auto=format&fit=crop&q=80';
          }}
        />

        {/* Ambient Dark Gradient on Hover */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-black/20 opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none" />

        {/* Top Badges */}
        <div className="absolute top-3 left-3 right-3 flex items-center justify-between pointer-events-none">
          {product.quantity !== undefined && (
            <div>
              {product.quantity > 0 ? (
                <span className="text-[10px] font-bold tracking-widest uppercase px-2.5 py-1 rounded-full bg-white/90 text-[#0B0B0D] backdrop-blur-md shadow-sm">
                  NEW SEASON
                </span>
              ) : (
                <span className="text-[10px] font-bold tracking-widest uppercase px-2.5 py-1 rounded-full bg-rose-500 text-white shadow-sm">
                  HẾT HÀNG
                </span>
              )}
            </div>
          )}

          {/* Wishlist Button */}
          <button
            onClick={handleToggleWishlist}
            className={`pointer-events-auto p-2 rounded-full transition-all duration-300 shadow-md ${
              inWishlist
                ? 'bg-rose-500 text-white'
                : 'bg-white/85 text-zinc-600 hover:text-rose-500 hover:bg-white'
            }`}
            title={inWishlist ? 'Bỏ thích' : 'Thêm vào yêu thích'}
          >
            <Heart className={`w-3.5 h-3.5 ${inWishlist ? 'fill-current' : ''}`} />
          </button>
        </div>

        {/* Quick Actions Hover Overlay */}
        <div className="absolute bottom-3 left-3 right-3 flex items-center gap-2 translate-y-3 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300">
          <button
            onClick={handleQuickAdd}
            disabled={product.quantity === 0}
            className="flex-1 py-2.5 px-3 rounded-xl bg-white text-[#0B0B0D] font-bold text-xs uppercase tracking-wider hover:bg-[#C6A77B] hover:text-white shadow-xl transition flex items-center justify-center gap-1.5 disabled:opacity-50"
          >
            <ShoppingBag className="w-3.5 h-3.5" />
            <span>Thêm vào giỏ</span>
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              onSelect?.(product);
            }}
            className="p-2.5 rounded-xl bg-white/90 text-[#0B0B0D] hover:bg-white shadow-xl transition"
            title="Xem chi tiết"
          >
            <Eye className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Product Information */}
      <div className="p-4 flex flex-col flex-1 justify-between gap-2.5 bg-white dark:bg-[#141416]">
        <div>
          <span className="text-[10px] font-bold uppercase tracking-[0.18em] text-[#C6A77B]">
            {product.categoryName || 'AURA COLLECTION'}
          </span>
          <h3 className="text-sm font-semibold text-[#171717] dark:text-[#F8F7F4] group-hover:text-[#C6A77B] dark:group-hover:text-[#C6A77B] transition-colors line-clamp-1 mt-0.5">
            {product.name}
          </h3>
          <p className="text-xs text-zinc-500 dark:text-zinc-400 line-clamp-1 mt-1 leading-relaxed">
            {product.description || 'Chất liệu vải may cao cấp, phom dáng thanh lịch sang trọng.'}
          </p>
        </div>

        <div className="flex items-center justify-between pt-2.5 border-t border-black/5 dark:border-white/10">
          <span className="text-base font-bold text-[#0B0B0D] dark:text-white tracking-tight">
            {formattedPrice}
          </span>
          {product.quantity !== undefined && product.quantity > 0 && (
            <span className="text-[11px] text-zinc-400 dark:text-zinc-500">
              Còn {product.quantity} sp
            </span>
          )}
        </div>
      </div>
    </div>
  );
};
