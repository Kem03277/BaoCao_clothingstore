import React, { useRef, useState } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { Sparkles, ArrowRight, Layers, Eye } from 'lucide-react';

gsap.registerPlugin(ScrollTrigger);

const COLLECTION_LOOKS = [
  {
    id: 1,
    title: 'THE NOCTURNE SILHOUETTE',
    subtitle: 'Nhung Tuyết & Đường Cắt May Kiến Trúc',
    description: 'Lấy cảm hứng từ bóng đêm đô thị, từng nếp gấp và đường may ôm trọn phom dáng với sự chuẩn xác của kỹ thuật may đo bespoke chuẩn Ý.',
    image: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=1600&q=85',
    tag: 'Look 01 · Nocturne 2026',
    fabric: '100% Wool & Italian Velvet',
    year: 'SPRING / SUMMER 2026',
  },
  {
    id: 2,
    title: 'GOLDEN HOUR DRAPING',
    subtitle: 'Lụa Tơ Tằm Dệt Ánh Kim Sa Tinh Xảo',
    description: 'Chuyển động uyển chuyển theo từng bước chân. Ánh sáng tự nhiên hòa quyện cùng sắc vàng sâm panh tạo nên ấn tượng thị giác choáng ngợp.',
    image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1600&q=85',
    tag: 'Look 02 · Imperial Gold',
    fabric: 'Champagne Mulberry Silk',
    year: 'HAUTE COUTURE EDIT',
  },
  {
    id: 3,
    title: 'VANGUARD MONOCHROME',
    subtitle: 'Tối Giản Đương Đại & Phom Dáng Phóng Khoáng',
    description: 'Phá vỡ quy tắc truyền thống bằng cấu trúc vai cứng cáp kết hợp cùng tà áo rủ tự nhiên. Tuyên ngôn của sự tự do và bản lĩnh cá nhân.',
    image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=1600&q=85',
    tag: 'Look 03 · Obsidian Black',
    fabric: 'Structure Wool Blend',
    year: 'LIMITED CAPSULE',
  },
];

export const CinematicCollectionShowcase = ({ onNavigateShop }) => {
  const containerRef = useRef(null);
  const triggerRef = useRef(null);
  const [activeLookIndex, setActiveLookIndex] = useState(0);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      // Pinned Storytelling Scroll Timeline
      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: triggerRef.current,
          start: 'top top',
          end: '+=180%',
          pin: true,
          scrub: 1.2,
          anticipatePin: 1,
        },
      });

      // Scale up main image frame smoothly from framed box to full viewport width
      tl.fromTo(
        '.showcase-viewport',
        { scale: 0.88, borderRadius: '2.5rem' },
        { scale: 1, borderRadius: '0rem', duration: 1, ease: 'power2.inOut' }
      );

      // Staggered reveal of editorial captions
      tl.fromTo(
        '.showcase-caption',
        { y: 50, opacity: 0 },
        { y: 0, opacity: 1, duration: 0.8, ease: 'power3.out' },
        '-=0.5'
      );

      // Parallax inner image movement
      tl.to(
        '.showcase-hero-img',
        { scale: 1.15, yPercent: -8, ease: 'none', duration: 1.5 },
        0
      );
    },
    { scope: containerRef }
  );

  const activeLook = COLLECTION_LOOKS[activeLookIndex];

  return (
    <section ref={containerRef} className="bg-[#070709] text-white relative" aria-label="The New Collection">
      {/* ScrollTrigger Pinned Viewport Container */}
      <div ref={triggerRef} className="h-screen w-full relative flex items-center justify-center overflow-hidden">
        
        {/* Animated Viewport Frame */}
        <div className="showcase-viewport w-full h-full relative overflow-hidden transition-all duration-700 bg-[#0B0B0D]">
          
          {/* Background Fashion Visual */}
          <img
            key={activeLook.id}
            src={activeLook.image}
            alt={activeLook.title}
            className="showcase-hero-img absolute inset-0 w-full h-full object-cover object-center transition-all duration-1000 ease-out"
          />

          {/* Cinematic Vignette & Editorial Dark Gradients */}
          <div className="absolute inset-0 bg-radial-[at_center] from-transparent via-black/40 to-black/85 pointer-events-none" />
          <div className="absolute inset-0 bg-gradient-to-t from-black via-black/30 to-black/60 pointer-events-none" />

          {/* Top Bar inside Showcase */}
          <div className="absolute top-8 left-6 sm:left-12 right-6 sm:right-12 z-20 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <span className="w-2.5 h-2.5 rounded-full bg-[#C6A77B] animate-ping" />
              <span className="text-[11px] font-bold uppercase tracking-[0.3em] text-[#C6A77B] font-mono">
                THE NEW COLLECTION · 2026
              </span>
            </div>

            <div className="hidden sm:flex items-center gap-2 bg-black/50 backdrop-blur-md px-4 py-2 rounded-full border border-white/10 text-xs font-mono text-zinc-300">
              <Layers className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span>{activeLook.fabric}</span>
            </div>
          </div>

          {/* Bottom Editorial Content & Navigation */}
          <div className="absolute bottom-8 sm:bottom-12 left-6 sm:left-12 right-6 sm:right-12 z-20">
            <div className="max-w-7xl mx-auto flex flex-col lg:flex-row lg:items-end justify-between gap-8">
              
              {/* Left Column: Headlines & Story */}
              <div className="showcase-caption max-w-2xl space-y-4">
                <span className="inline-block text-[10px] font-bold uppercase tracking-widest px-3 py-1 rounded-full bg-white/15 backdrop-blur-md text-white border border-white/20">
                  {activeLook.tag}
                </span>

                <h2 className="text-3xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-white leading-none">
                  {activeLook.title}
                </h2>

                <p className="text-sm sm:text-base text-[#E2CEAE] font-serif italic">
                  {activeLook.subtitle}
                </p>

                <p className="text-xs sm:text-sm text-zinc-300 font-sans leading-relaxed max-w-xl">
                  {activeLook.description}
                </p>

                <div className="pt-2 flex items-center gap-4">
                  <button
                    onClick={onNavigateShop}
                    className="px-8 py-3.5 rounded-full bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] font-bold text-xs uppercase tracking-widest shadow-2xl hover:scale-105 transition-all duration-300 flex items-center gap-2 cursor-pointer"
                  >
                    <span>Khám phá bộ sưu tập</span>
                    <ArrowRight className="w-4 h-4" />
                  </button>
                </div>
              </div>

              {/* Right Column: Look Switcher Thumbnails */}
              <div className="flex items-center gap-3 self-start lg:self-end">
                {COLLECTION_LOOKS.map((look, index) => {
                  const isCurrent = activeLookIndex === index;
                  return (
                    <button
                      key={look.id}
                      onClick={() => setActiveLookIndex(index)}
                      className={`group relative w-16 sm:w-20 h-24 sm:h-28 rounded-2xl overflow-hidden border-2 transition-all duration-300 cursor-pointer ${
                        isCurrent
                          ? 'border-[#C6A77B] scale-105 shadow-xl shadow-[#C6A77B]/20'
                          : 'border-white/20 opacity-60 hover:opacity-100 hover:border-white/50'
                      }`}
                    >
                      <img
                        src={look.image}
                        alt={look.title}
                        className="w-full h-full object-cover"
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent flex items-end p-1.5">
                        <span className="text-[9px] font-mono font-bold text-white">0{index + 1}</span>
                      </div>
                    </button>
                  );
                })}
              </div>

            </div>
          </div>

        </div>

      </div>
    </section>
  );
};
