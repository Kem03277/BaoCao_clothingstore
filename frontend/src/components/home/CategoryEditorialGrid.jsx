import React, { useRef } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { ArrowUpRight, Sparkles } from 'lucide-react';

gsap.registerPlugin(ScrollTrigger);

const CATEGORIES = [
  {
    id: 'men',
    categoryId: 1,
    title: 'MEN',
    subtitle: 'Đẳng cấp & Phong độ lịch lãm',
    image: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
    tag: 'Haute Tailoring',
    itemsCount: '48+ Thiết kế',
    colSpan: 'lg:col-span-7',
    aspect: 'aspect-[16/10] sm:aspect-[16/9]',
  },
  {
    id: 'women',
    categoryId: 2,
    title: 'WOMEN',
    subtitle: 'Thanh lịch quý phái & Quyến rũ',
    image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
    tag: 'Couture Capsule',
    itemsCount: '64+ Thiết kế',
    colSpan: 'lg:col-span-5',
    aspect: 'aspect-[4/5] sm:aspect-square lg:aspect-auto',
  },
  {
    id: 'streetwear',
    categoryId: 3,
    title: 'STREETWEAR',
    subtitle: 'Cá tính đường phố & Năng động đương đại',
    image: 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&w=1200&q=80',
    tag: 'Urban Vanguard',
    itemsCount: '36+ Thiết kế',
    colSpan: 'lg:col-span-5',
    aspect: 'aspect-[4/5] sm:aspect-square lg:aspect-auto',
  },
  {
    id: 'accessories',
    categoryId: 4,
    title: 'ACCESSORIES',
    subtitle: 'Phụ kiện da & Trang sức kim loại mạ vàng',
    image: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1200&q=80',
    tag: 'Artisan Objects',
    itemsCount: '24+ Thiết kế',
    colSpan: 'lg:col-span-7',
    aspect: 'aspect-[16/10] sm:aspect-[16/9]',
  },
];

export const CategoryEditorialGrid = ({ onSelectCategory, onNavigateShop }) => {
  const containerRef = useRef(null);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      const cards = gsap.utils.toArray('.category-card');
      cards.forEach((card, index) => {
        gsap.fromTo(
          card,
          {
            y: 60,
            opacity: 0,
            clipPath: 'inset(10% 0% 10% 0%)',
          },
          {
            y: 0,
            opacity: 1,
            clipPath: 'inset(0% 0% 0% 0%)',
            duration: 1.1,
            ease: 'power3.out',
            scrollTrigger: {
              trigger: card,
              start: 'top 85%',
              once: true,
            },
          }
        );
      });
    },
    { scope: containerRef }
  );

  return (
    <section
      ref={containerRef}
      className="py-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"
      aria-label="Shop By Category"
    >
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-16">
        <div className="space-y-3">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#0B0B0D]/5 dark:bg-white/10 border border-[#C6A77B]/30 backdrop-blur-md">
            <Sparkles className="w-3.5 h-3.5 text-[#C6A77B]" />
            <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
              Curated Collections
            </span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4]">
            SHOP BY <span className="font-serif italic font-normal text-[#C6A77B]">CATEGORY</span>
          </h2>
          <p className="text-sm text-zinc-600 dark:text-zinc-400 max-w-lg font-sans">
            Mỗi danh mục là một tuyên ngôn phong cách riêng biệt được tuyển chọn khắt khe từ chất liệu đến phom dáng cắt may.
          </p>
        </div>

        <button
          onClick={onNavigateShop}
          className="inline-flex items-center gap-2 px-6 py-3 rounded-full border border-black/15 dark:border-white/20 hover:border-[#C6A77B] text-xs uppercase font-bold tracking-widest text-[#0B0B0D] dark:text-[#F8F7F4] hover:text-[#C6A77B] transition-all duration-300 cursor-pointer self-start md:self-auto group"
        >
          <span>Khám phá toàn bộ danh mục</span>
          <ArrowUpRight className="w-4 h-4 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
        </button>
      </div>

      {/* Asymmetric Editorial Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        {CATEGORIES.map((cat) => (
          <div
            key={cat.id}
            onClick={() => onSelectCategory ? onSelectCategory(cat.categoryId) : onNavigateShop()}
            className={`category-card group relative rounded-3xl overflow-hidden cursor-pointer shadow-lg hover:shadow-2xl transition-all duration-700 ${cat.colSpan} ${cat.aspect}`}
          >
            {/* Background Image with Zoom */}
            <img
              src={cat.image}
              alt={cat.title}
              className="w-full h-full object-cover object-center group-hover:scale-108 transition-transform duration-1000 ease-out"
              loading="lazy"
            />

            {/* Dark Editorial Gradient Layer */}
            <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/35 to-black/10 group-hover:via-black/25 transition-colors duration-500" />

            {/* Top Tag Badge */}
            <div className="absolute top-6 left-6 right-6 flex items-center justify-between z-10">
              <span className="text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-full bg-white/20 backdrop-blur-md text-white border border-white/20">
                {cat.tag}
              </span>
              <span className="text-xs font-mono text-zinc-300 bg-black/40 px-3 py-1 rounded-full border border-white/10 backdrop-blur-sm">
                {cat.itemsCount}
              </span>
            </div>

            {/* Bottom Content & Interactive Arrow */}
            <div className="absolute bottom-6 left-6 right-6 z-10 flex items-end justify-between">
              <div>
                <h3 className="text-3xl sm:text-4xl font-extrabold tracking-tight text-white group-hover:text-[#E2CEAE] transition-colors duration-300">
                  {cat.title}
                </h3>
                <p className="text-xs sm:text-sm text-zinc-300 mt-1 font-sans max-w-md">
                  {cat.subtitle}
                </p>
              </div>

              {/* Floating Circle Button */}
              <div className="w-12 h-12 rounded-full bg-white/15 backdrop-blur-md border border-white/30 flex items-center justify-center text-white group-hover:bg-[#C6A77B] group-hover:text-[#0B0B0D] group-hover:scale-110 group-hover:border-[#C6A77B] transition-all duration-500 shadow-xl shrink-0 ml-4">
                <ArrowUpRight className="w-5 h-5 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
};
