import React, { useRef, useState, useEffect, useMemo } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from '../../lib/gsap';
import {
  ArrowRight, ShoppingBag, Heart, Sparkles,
  ChevronLeft, ChevronRight
} from 'lucide-react';
import { useCart } from '../../context/CartContext';
import { useWishlist } from '../../context/WishlistContext';

export const FeaturedCollection = ({ products = [], onSelectProduct, onNavigateShop }) => {
  const containerRef = useRef(null);
  const scrollContainerRef = useRef(null);
  const dragStateRef = useRef({ pointerId: null, startX: 0, startScrollLeft: 0, moved: false });
  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(true);
  const [scrollProgress, setScrollProgress] = useState(0);
  const [isDragging, setIsDragging] = useState(false);

  const { addToCart } = useCart();
  const { isInWishlist, toggleWishlist } = useWishlist();

  const displayProducts = useMemo(
    () => (Array.isArray(products)
      ? products.filter((product) => typeof product.tag === 'string' && product.tag.trim().toLowerCase() === 'hot')
      : []),
    [products]
  );

  // Smooth scroll left/right
  const scroll = (direction) => {
    if (!scrollContainerRef.current) return;
    const scrollAmount = window.innerWidth < 640 ? 320 : 420;
    scrollContainerRef.current.scrollBy({
      left: direction === 'left' ? -scrollAmount : scrollAmount,
      behavior: 'smooth',
    });
  };

  const handleScroll = () => {
    if (!scrollContainerRef.current) return;
    const { scrollLeft, scrollWidth, clientWidth } = scrollContainerRef.current;
    setCanScrollLeft(scrollLeft > 10);
    setCanScrollRight(scrollLeft < scrollWidth - clientWidth - 10);
    const maxScroll = scrollWidth - clientWidth;
    setScrollProgress(maxScroll > 0 ? (scrollLeft / maxScroll) * 100 : 0);
  };

  const handlePointerDown = (event) => {
    if (event.button !== 0 || event.target.closest('button, a, input')) return;
    const container = scrollContainerRef.current;
    if (!container) return;

    dragStateRef.current = {
      pointerId: event.pointerId,
      startX: event.clientX,
      startScrollLeft: container.scrollLeft,
      moved: false,
      cardIndex: Number(event.target.closest('.featured-card')?.dataset.productIndex ?? -1),
    };
    container.setPointerCapture(event.pointerId);
  };

  const handlePointerMove = (event) => {
    const drag = dragStateRef.current;
    const container = scrollContainerRef.current;
    if (!container || drag.pointerId !== event.pointerId) return;

    const deltaX = event.clientX - drag.startX;
    if (!drag.moved && Math.abs(deltaX) > 5) {
      drag.moved = true;
      setIsDragging(true);
    }

    if (drag.moved) {
      event.preventDefault();
      container.scrollLeft = drag.startScrollLeft - deltaX;
    }
  };

  const handlePointerUp = (event) => {
    const container = scrollContainerRef.current;
    if (dragStateRef.current.pointerId !== event.pointerId) return;
    if (container?.hasPointerCapture(event.pointerId)) {
      container.releasePointerCapture(event.pointerId);
    }
    if (event.type !== 'pointercancel' && !dragStateRef.current.moved) {
      const product = displayProducts[dragStateRef.current.cardIndex];
      if (product) onSelectProduct?.(product);
    }
    dragStateRef.current.pointerId = null;
    setIsDragging(false);
  };

  useEffect(() => {
    handleScroll();
  }, [displayProducts]);

  // GSAP reveal on viewport entry without scroll hijacking / pinning
  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      gsap.fromTo(
        '.featured-header',
        { y: 40, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 1,
          ease: 'power3.out',
          scrollTrigger: {
            trigger: containerRef.current,
            start: 'top 80%',
            once: true,
          },
        }
      );

      gsap.fromTo(
        '.featured-card',
        { y: 60, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 0.9,
          stagger: 0.1,
          ease: 'power3.out',
          scrollTrigger: {
            trigger: containerRef.current,
            start: 'top 75%',
            once: true,
          },
        }
      );
    },
    { scope: containerRef }
  );

  return (
    <section
      ref={containerRef}
      className="relative bg-[#F8F7F4] dark:bg-[#09090B] text-[#0B0B0D] dark:text-white overflow-hidden py-24 sm:py-32 border-t border-black/5 dark:border-white/5 z-10 transition-colors duration-500"
      aria-label="Sản phẩm nổi bật"
    >
      {/* Background Subtle Gradient Glow */}
      <div className="absolute top-1/2 right-1/4 w-[500px] h-[500px] rounded-full blur-[160px] pointer-events-none bg-[#C6A77B]/5" />

      {/* Top Header inside Section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full mb-12 flex flex-col md:flex-row md:items-end justify-between gap-6 featured-header">
        <div className="space-y-3">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/10 border border-[#C6A77B]/30 backdrop-blur-md">
            <Sparkles className="w-3.5 h-3.5 text-[#C6A77B]" />
            <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
              Tuyển chọn từ Atelier
            </span>
          </div>
          <h2 className="flex flex-wrap items-baseline gap-x-3 text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-white sm:text-5xl">
            <span>SẢN PHẨM</span>
            <span className="font-serif font-light italic text-[#C6A77B]">NỔI BẬT</span>
          </h2>
          <p className="text-xs sm:text-sm text-zinc-600 dark:text-zinc-400 max-w-lg font-sans">
            Khám phá những thiết kế được yêu thích, chọn lọc riêng cho phong cách của bạn.
          </p>
        </div>

        {/* Action Controls & Navigation Arrows */}
        <div className="flex items-center gap-4">
          
          {/* Circular Navigation Buttons */}
          <div className="flex items-center gap-2">
            <button
              onClick={() => scroll('left')}
              disabled={!canScrollLeft}
              className={`w-11 h-11 rounded-full border flex items-center justify-center transition-all cursor-pointer ${
                canScrollLeft
                  ? 'border-black/20 text-[#0B0B0D] hover:border-[#C6A77B] hover:text-[#C6A77B] bg-black/5 hover:bg-black/10 dark:border-white/20 dark:text-white dark:hover:border-[#C6A77B] dark:hover:text-[#C6A77B] dark:bg-white/5 dark:hover:bg-white/10'
                  : 'border-black/10 dark:border-white/10 text-black/20 dark:text-white/30 cursor-not-allowed opacity-40'
              }`}
              aria-label="Trượt sang trái"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>

            <button
              onClick={() => scroll('right')}
              disabled={!canScrollRight}
              className={`w-11 h-11 rounded-full border flex items-center justify-center transition-all cursor-pointer ${
                canScrollRight
                  ? 'border-black/20 text-[#0B0B0D] hover:border-[#C6A77B] hover:text-[#C6A77B] bg-black/5 hover:bg-black/10 dark:border-white/20 dark:text-white dark:hover:border-[#C6A77B] dark:hover:text-[#C6A77B] dark:bg-white/5 dark:hover:bg-white/10'
                  : 'border-black/10 dark:border-white/10 text-black/20 dark:text-white/30 cursor-not-allowed opacity-40'
              }`}
              aria-label="Trượt sang phải"
            >
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>

          <button
            onClick={onNavigateShop}
            className="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-[#0B0B0D] dark:bg-white text-white dark:text-[#0B0B0D] hover:bg-[#C6A77B] dark:hover:bg-[#C6A77B] text-xs uppercase font-bold tracking-widest transition-all duration-300 cursor-pointer shadow-lg group"
          >
            <span>Xem tất cả</span>
            <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </button>
        </div>
      </div>

      {/* Horizontal Smooth Scroll Container */}
      <div
        ref={scrollContainerRef}
        onScroll={handleScroll}
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
        onPointerUp={handlePointerUp}
        onPointerCancel={handlePointerUp}
        className={`w-full overflow-x-auto no-scrollbar px-4 sm:px-8 lg:px-16 pb-4 ${
          isDragging ? 'cursor-grabbing select-none' : 'cursor-grab'
        }`}
        style={{ scrollbarWidth: 'none', msOverflowStyle: 'none', touchAction: 'pan-y' }}
        aria-label="Kéo để xem thêm sản phẩm"
      >
        {displayProducts.length > 0 ? (
          <div className="flex gap-6 sm:gap-8 w-max items-stretch pr-8">
            {displayProducts.map((prod, idx) => {
            const inWishlist = isInWishlist(prod.id);
            const img = prod.mainImageUrl || prod.image || 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=800&q=80';
            const price = prod.priceFormatted || new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(prod.price || 0);

            return (
              <div
                key={prod.id || idx}
                data-product-index={idx}
                role="button"
                tabIndex={0}
                onKeyDown={(event) => {
                  if (event.target !== event.currentTarget) return;
                  if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    onSelectProduct?.(prod);
                  }
                }}
                className="featured-card group relative w-[280px] sm:w-[340px] rounded-3xl overflow-hidden bg-white dark:bg-[#121214] border border-black/10 dark:border-white/10 hover:border-[#C6A77B]/50 shadow-xl dark:shadow-2xl transition-all duration-500 cursor-pointer shrink-0 flex flex-col justify-between"
              >
                {/* Visual Image Container */}
                <div className="relative aspect-[3/4] w-full overflow-hidden bg-zinc-100 dark:bg-zinc-900">
                  <img
                    src={img}
                    alt={prod.name}
                    className="w-full h-full object-cover object-top group-hover:scale-108 transition-transform duration-700 ease-out"
                    loading="lazy"
                    onError={(e) => {
                      e.target.src = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80';
                    }}
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-transparent to-black/20" />

                  {/* Top Badge & Wishlist */}
                  <div className="absolute top-4 left-4 right-4 flex items-center justify-between">
                    <span className="text-[10px] font-bold uppercase tracking-widest px-2.5 py-1 rounded-full bg-black/60 backdrop-blur-md text-[#C6A77B] border border-white/10 font-mono">
                      {prod.tag || `Look 0${idx + 1}`}
                    </span>

                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        toggleWishlist(prod);
                      }}
                      className={`p-2 rounded-full transition shadow-md ${
                        inWishlist
                          ? 'bg-rose-500 text-white'
                          : 'bg-black/50 text-white hover:text-rose-500 hover:bg-black/80'
                      }`}
                      title="Yêu thích"
                    >
                      <Heart className={`w-3.5 h-3.5 ${inWishlist ? 'fill-current' : ''}`} />
                    </button>
                  </div>
                </div>

                {/* Card Info & Quick Add */}
                <div className="p-6 space-y-4 bg-white dark:bg-[#141417] transition-colors duration-300">
                  <div>
                    <span className="text-[10px] uppercase font-bold tracking-wider text-zinc-500 dark:text-zinc-400 font-mono">
                      {prod.category || 'Atelier Exclusive'}
                    </span>
                    <h3 className="text-base sm:text-lg font-bold text-[#0B0B0D] dark:text-white group-hover:text-[#C6A77B] dark:group-hover:text-[#E2CEAE] transition-colors truncate mt-0.5">
                      {prod.name}
                    </h3>
                  </div>

                  <div className="flex items-center justify-between pt-2 border-t border-black/5 dark:border-white/10">
                    <span className="text-base font-bold text-[#A88B58] dark:text-[#E2CEAE] font-mono">
                      {price}
                    </span>

                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        addToCart(prod, 1, 'M', { openCart: false, showNotification: true });
                      }}
                      className="p-2.5 rounded-full bg-black/5 text-[#0B0B0D] hover:bg-[#C6A77B] hover:text-[#0B0B0D] dark:bg-white/10 dark:text-white dark:hover:bg-[#C6A77B] dark:hover:text-[#0B0B0D] transition cursor-pointer"
                      title="Thêm vào giỏ"
                    >
                      <ShoppingBag className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            );
            })}
          </div>
        ) : (
          <p className="mx-auto max-w-7xl px-4 py-16 text-center text-sm text-zinc-500 dark:text-zinc-400">
            Hiện chưa có sản phẩm nổi bật. Các sản phẩm được gắn nhãn “hot” sẽ xuất hiện tại đây.
          </p>
        )}
      </div>

      {/* Progress Bar Line */}
      {displayProducts.length > 0 && (
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full mt-8">
          <div className="w-full h-0.5 bg-white/10 rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-[#C6A77B] to-[#FAF1E3] transition-all duration-150"
              style={{ width: `${Math.max(scrollProgress, 16)}%` }}
            />
          </div>
        </div>
      )}
    </section>
  );
};
