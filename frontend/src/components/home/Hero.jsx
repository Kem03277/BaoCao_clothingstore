import React, { lazy, Suspense, useEffect, useRef, useState } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from '../../lib/gsap';
import { ArrowRight, Sparkles as SparklesIcon, Play } from 'lucide-react';

const Hero3DScene = lazy(() => import('../three/Hero3DScene'));

/**
 * Fullscreen 3D Hero Section
 * Editorial typography, interactive R3F 3D garment sculpture, studio lighting
 */
export const Hero = ({ onNavigateShop }) => {
  const containerRef = useRef(null);
  const headlineRef = useRef(null);
  const [show3DScene, setShow3DScene] = useState(false);

  useEffect(() => {
    const timer = window.setTimeout(() => setShow3DScene(true), 500);
    return () => window.clearTimeout(timer);
  }, []);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      const tl = gsap.timeline({ delay: 0.2 });

      // Stagger reveal headline lines
      tl.fromTo(
        '.hero-line',
        { y: 70, opacity: 0, rotateX: -20 },
        { y: 0, opacity: 1, rotateX: 0, duration: 1.2, ease: 'power4.out', stagger: 0.15 }
      );

      // Stagger reveal subtitles, buttons, and lookbook strip
      tl.fromTo(
        '.hero-fade',
        { y: 35, opacity: 0 },
        { y: 0, opacity: 1, duration: 0.9, ease: 'power3.out', stagger: 0.1 },
        '-=0.6'
      );

      // Smooth floating animation on 3D canvas container
      gsap.to('.hero-canvas-wrap', {
        y: -15,
        duration: 2.5,
        repeat: -1,
        yoyo: true,
        ease: 'sine.inOut',
      });
    },
    { scope: containerRef }
  );

  return (
    <section
      ref={containerRef}
      className="relative flex min-h-[100svh] w-full items-center overflow-hidden bg-[#F8F7F4] pb-8 pt-20 text-[#0B0B0D] transition-colors duration-500 dark:bg-[#09090B] dark:text-white sm:pb-10 sm:pt-24 lg:pb-8 lg:pt-24"
      aria-label="3D Immersive Hero"
    >
      {/* Background Studio Ambience & Golden Glow Flares */}
      <div className="absolute top-1/4 right-1/4 w-[500px] h-[500px] bg-[#C6A77B]/10 rounded-full blur-[140px] pointer-events-none" />
      <div className="absolute -bottom-20 left-10 w-[450px] h-[450px] bg-[#C6A77B]/5 rounded-full blur-[130px] pointer-events-none" />

      <div className="relative z-10 mx-auto w-full max-w-[1120px] px-5 sm:px-8 lg:px-0">
        <div className="grid min-h-[calc(100svh-11rem)] grid-cols-1 items-center gap-8 sm:gap-10 lg:grid-cols-12 lg:gap-6">
          
          {/* Left: Editorial Headline & Actions (7 cols) */}
          <div className="space-y-5 sm:space-y-6 lg:col-span-7 lg:space-y-7">
            
            {/* Tag Badge */}
            <div className="hero-fade inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/10 border border-[#C6A77B]/30 backdrop-blur-md">
              <SparklesIcon className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
                Spring / Summer 2026 Haute Couture
              </span>
            </div>

            {/* Master Headline: DEFINE YOUR STYLE */}
            <div ref={headlineRef} className="space-y-1">
              <div className="overflow-hidden">
                <h1 className="hero-line text-5xl font-black uppercase leading-[0.92] tracking-tight text-[#0B0B0D] dark:text-white sm:text-7xl xl:text-7xl 2xl:text-8xl">
                  DEFINE YOUR
                </h1>
              </div>
              <div className="overflow-hidden">
                <h1 className="hero-line text-5xl font-serif font-light italic leading-[0.92] tracking-tight text-[#C6A77B] sm:text-7xl xl:text-7xl 2xl:text-8xl">
                  STYLE.
                </h1>
              </div>
            </div>

            {/* Subheading: "Khẳng định phong cách. Tạo dấu ấn riêng." */}
            <p className="hero-fade font-serif text-lg italic text-[#9E8254] dark:text-[#E2CEAE] sm:text-2xl xl:text-3xl">
              Khẳng định phong cách. Tạo dấu ấn riêng.
            </p>

            <p className="hero-fade max-w-2xl font-sans text-xs leading-relaxed text-zinc-600 dark:text-zinc-300 sm:text-sm lg:text-base">
              Mỗi thiết kế từ ClothingStore là sự giao thoa chuẩn mực giữa tay nghề may đo thủ công bespoke và tạo hình 3D tương tác. Tôn vinh vẻ đẹp vĩnh cửu và sự tự do của phong cách cá nhân.
            </p>

            {/* Action Buttons */}
            <div className="hero-fade flex flex-wrap items-center gap-4 pt-4">
              <button
                type="button"
                onClick={onNavigateShop}
                className="px-8 py-4 rounded-full bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] font-bold text-xs uppercase tracking-[0.2em] shadow-2xl hover:scale-105 transition-all duration-300 flex items-center gap-2 group cursor-pointer"
              >
                <span>KHÁM PHÁ BỘ SƯU TẬP</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </button>

              <button
                type="button"
                onClick={onNavigateShop}
                className="px-7 py-4 rounded-full bg-black/5 hover:bg-black/10 dark:bg-white/10 dark:hover:bg-white/15 border border-black/10 dark:border-white/20 text-[#0B0B0D] dark:text-white font-semibold text-xs uppercase tracking-widest transition flex items-center gap-2 cursor-pointer"
              >
                <Play className="w-3.5 h-3.5 text-[#C6A77B] fill-current" />
                <span>MUA SẮM NGAY</span>
              </button>
            </div>

            {/* Lookbook Avatar Strip */}
            <div className="hero-fade pt-4 flex items-center gap-4 border-t border-black/10 dark:border-white/10">
              <div className="flex -space-x-2.5 overflow-hidden p-0.5">
                <img
                  src="https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=120&auto=format&fit=crop&q=80"
                  alt="Look 1"
                  className="inline-block h-10 w-10 rounded-full ring-2 ring-[#C6A77B] object-cover"
                />
                <img
                  src="https://images.unsplash.com/photo-1509631179647-0177331693ae?w=120&auto=format&fit=crop&q=80"
                  alt="Look 2"
                  className="inline-block h-10 w-10 rounded-full ring-2 ring-[#C6A77B] object-cover"
                />
                <img
                  src="https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=120&auto=format&fit=crop&q=80"
                  alt="Look 3"
                  className="inline-block h-10 w-10 rounded-full ring-2 ring-[#C6A77B] object-cover"
                />
                <img
                  src="https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=120&auto=format&fit=crop&q=80"
                  alt="Look 4"
                  className="inline-block h-10 w-10 rounded-full ring-2 ring-[#C6A77B] object-cover"
                />
              </div>
              <div className="text-xs">
                <p className="font-bold text-[#0B0B0D] dark:text-white flex items-center gap-1.5">
                  <span>120+ Mẫu Runway 2026</span>
                  <span className="text-[10px] px-2 py-0.5 rounded-full bg-[#C6A77B]/20 text-[#C6A77B] font-mono">
                    Haute Couture
                  </span>
                </p>
                <p className="text-[11px] text-zinc-500 dark:text-zinc-400 font-sans">
                  Hình ảnh minh họa thực tế &amp; mô phỏng sợi dệt 3D
                </p>
              </div>
            </div>

          </div>

          {/* Right: Three.js Interactive 3D Canvas (5 cols) */}
          <div className="hero-canvas-wrap relative flex h-[min(60svh,640px)] min-h-[340px] items-center justify-center sm:min-h-[420px] lg:col-span-5">
            {show3DScene && (
              <Suspense fallback={null}>
                <Hero3DScene />
              </Suspense>
            )}

            {/* Minimal Hint */}
            <div className="absolute bottom-4 right-4 pointer-events-none px-3 py-1 rounded-full bg-black/60 border border-white/10 text-[10px] font-mono text-zinc-400 backdrop-blur-md">
              Rê chuột để cảm nhận phom dáng 3D
            </div>
          </div>

        </div>
      </div>
    </section>
  );
};
