import React from 'react';
import { Heart, Trash2, ShoppingBag, ArrowRight, Sparkles } from 'lucide-react';
import { useWishlist } from '../context/WishlistContext';
import { useCart } from '../context/CartContext';
import { ProductCard } from '../components/ProductCard';

export const WishlistPage = ({ onNavigateShop, onSelectProduct }) => {
  const { wishlist } = useWishlist();

  if (wishlist.length === 0) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="bg-white dark:bg-[#141416] rounded-3xl border border-black/5 dark:border-white/10 p-12 sm:p-20 text-center max-w-xl mx-auto shadow-sm space-y-4 transition-colors duration-300">
          <div className="w-16 h-16 rounded-full bg-[#0B0B0D] dark:bg-[#1A1A1E] text-[#C6A77B] flex items-center justify-center mx-auto shadow-xl border border-[#C6A77B]/20">
            <Heart className="w-8 h-8" />
          </div>
          <span className="text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
            Danh Sách Yêu Thích
          </span>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4]">
            Chưa Có Sản Phẩm Nào
          </h2>
          <p className="text-xs text-zinc-500 dark:text-zinc-400 max-w-sm mx-auto leading-relaxed">
            Nhấn vào biểu tượng trái tim trên các mẫu thiết kế bạn ưng ý để lưu lại và theo dõi ưu đãi đặc quyền.
          </p>
          <div className="pt-2">
            <button
              onClick={onNavigateShop}
              className="px-8 py-3.5 rounded-full bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D] text-xs font-bold uppercase tracking-widest hover:bg-black dark:hover:opacity-90 transition flex items-center gap-2 mx-auto cursor-pointer"
            >
              <span>Khám phá bộ sưu tập</span>
              <ArrowRight className="w-4 h-4 text-[#C6A77B] dark:text-[#0B0B0D]" />
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 border-b border-black/5 dark:border-white/10 pb-6">
        <div>
          <span className="text-xs uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
            Sản Phẩm Đã Lưu
          </span>
          <h1 className="text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] mt-1">
            Danh Sách Yêu Thích
          </h1>
        </div>
        <button
          onClick={onNavigateShop}
          className="text-xs font-bold uppercase tracking-wider text-[#0B0B0D] dark:text-[#F8F7F4] hover:text-[#C6A77B] flex items-center gap-1.5 transition cursor-pointer"
        >
          <span>Tiếp tục mua sắm</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-6">
        {wishlist.map((product) => (
          <ProductCard
            key={product.id}
            product={product}
            onSelect={onSelectProduct}
          />
        ))}
      </div>
    </div>
  );
};
