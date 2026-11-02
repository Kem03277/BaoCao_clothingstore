import React, { useRef } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { Sparkles, ArrowRight, ChevronRight, Zap } from 'lucide-react';
import { ProductCard } from '../ProductCard';

gsap.registerPlugin(ScrollTrigger);

export const NewArrivalsSection = ({ products = [], loading = false, onSelectProduct, onNavigateShop }) => {
  const containerRef = useRef(null);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      gsap.fromTo(
        '.drop-card',
        { y: 50, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 0.9,
          stagger: 0.1,
          ease: 'power3.out',
          scrollTrigger: {
            trigger: containerRef.current,
            start: 'top 80%',
            once: true,
          },
        }
      );
    },
    { scope: containerRef, dependencies: [products, loading] }
  );

  return (
    <section
      ref={containerRef}
      className="py-24 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"
      aria-label="New Arrivals"
    >
      {/* Section Header */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12">
        <div className="space-y-3">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#0B0B0D]/5 dark:bg-white/10 border border-[#C6A77B]/30 backdrop-blur-md">
            <Zap className="w-3.5 h-3.5 text-[#C6A77B]" />
            <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
              Limited Edition Releases
            </span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4]">
            JUST <span className="font-serif italic font-normal text-[#C6A77B]">DROPPED</span>
          </h2>
          <p className="text-sm text-zinc-600 dark:text-zinc-400 max-w-md font-sans">
            Những sáng tạo thời trang mới nhất vừa cập bến từ xưởng may Haute Couture với số lượng giới hạn.
          </p>
        </div>

        <button
          onClick={onNavigateShop}
          className="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-[#0B0B0D] dark:bg-white text-white dark:text-[#0B0B0D] hover:bg-[#C6A77B] dark:hover:bg-[#C6A77B] dark:hover:text-[#0B0B0D] text-xs uppercase font-bold tracking-widest transition-all duration-300 cursor-pointer self-start md:self-auto group"
        >
          <span>XEM TẤT CẢ</span>
          <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
        </button>
      </div>

      {/* Product Grid / Responsive Showcase */}
      {loading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-6">
          {Array.from({ length: 4 }).map((_, idx) => (
            <div
              key={idx}
              className="bg-white dark:bg-[#141416] rounded-2xl p-4 border border-black/5 dark:border-white/10 animate-pulse space-y-4"
            >
              <div className="aspect-[3/4] bg-zinc-200 dark:bg-zinc-800 rounded-xl" />
              <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-3/4" />
              <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-1/2" />
            </div>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-6">
          {products.slice(0, 8).map((product) => (
            <div key={product.id} className="drop-card">
              <ProductCard product={product} onSelect={onSelectProduct} />
            </div>
          ))}
        </div>
      )}
    </section>
  );
};
