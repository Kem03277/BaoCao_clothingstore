import React, { useEffect, useRef } from 'react';
import { gsap } from '../../lib/gsap';
import { Sparkles } from 'lucide-react';

export const Preloader = ({ onComplete }) => {
  const containerRef = useRef(null);
  const counterRef = useRef(null);
  const logoRef = useRef(null);
  const ringRef = useRef(null);
  const progressBarRef = useRef(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      const tl = gsap.timeline({
        onComplete: () => {
          onComplete?.();
        },
      });

      const counterObj = { val: 0 };
      tl.to(counterObj, {
        val: 100,
        duration: 0.55,
        ease: 'power2.out',
        onUpdate: () => {
          const current = Math.floor(counterObj.val);
          if (counterRef.current) {
            counterRef.current.textContent = `${current}%`;
          }
          if (progressBarRef.current) {
            progressBarRef.current.style.width = `${current}%`;
          }
        },
      });

      // Logo entrance & ring pulse
      tl.fromTo(
        logoRef.current,
        { scale: 0.8, opacity: 0, y: 20 },
        { scale: 1, opacity: 1, y: 0, duration: 0.45, ease: 'power3.out' },
        0.1
      );

      tl.fromTo(
        ringRef.current,
        { scale: 0.6, opacity: 0 },
        { scale: 1.2, opacity: 0.6, duration: 0.55, ease: 'power2.out' },
        0.15
      );

      tl.to(
        containerRef.current,
        {
          yPercent: -100,
          duration: 0.35,
          ease: 'power4.inOut',
        },
        0.65
      );
    }, containerRef);

    return () => ctx.revert();
  }, [onComplete]);

  return (
    <div
      ref={containerRef}
      className="fixed inset-0 z-[999] flex flex-col items-center justify-between bg-[#09090B] text-white p-8 sm:p-12 select-none"
      aria-label="Loading Experience"
    >
      {/* Top Tag */}
      <div className="w-full flex items-center justify-between text-xs font-mono text-zinc-400">
        <span className="uppercase tracking-[0.25em] text-[#C6A77B]">
          CLOTHINGSTORE ATELIER
        </span>
        <span className="uppercase tracking-widest text-[10px]">
          SPRING / SUMMER 2026
        </span>
      </div>

      {/* Center Animated Emblem */}
      <div className="relative flex flex-col items-center justify-center">
        {/* Glowing Aura Ring */}
        <div
          ref={ringRef}
          className="absolute w-44 h-44 rounded-full border border-[#C6A77B]/40 blur-sm pointer-events-none"
        />

        <div ref={logoRef} className="flex flex-col items-center space-y-3 z-10">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-[#C6A77B] to-[#E5D2B8] flex items-center justify-center text-[#0B0B0D] shadow-2xl">
            <Sparkles className="w-7 h-7 fill-current" />
          </div>
          <h1 className="font-serif text-3xl sm:text-4xl tracking-[0.25em] font-light text-white text-center">
            CLOTHING<span className="font-extrabold text-[#C6A77B]">STORE</span>
          </h1>
          <p className="text-[10px] tracking-[0.4em] uppercase text-zinc-400 font-sans">
            Haute Couture &amp; 3D Digital Craft
          </p>
        </div>
      </div>

      {/* Bottom Counter & Status Bar */}
      <div className="w-full max-w-md space-y-3">
        <div className="flex items-center justify-between text-xs font-mono">
          <span className="text-zinc-500 uppercase tracking-widest text-[11px]">
            Đang tải trải nghiệm...
          </span>
          <span ref={counterRef} className="font-bold text-[#C6A77B] text-base">
            0%
          </span>
        </div>

        {/* Minimal Progress Line */}
        <div className="w-full h-[2px] bg-white/10 rounded-full overflow-hidden">
          <div
            ref={progressBarRef}
            className="h-full bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] transition-all duration-75"
            style={{ width: '0%' }}
          />
        </div>
      </div>
    </div>
  );
};
