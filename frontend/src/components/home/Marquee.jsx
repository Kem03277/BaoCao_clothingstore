import React, { useRef } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap, ScrollTrigger } from '../../lib/gsap';
import { Sparkles } from 'lucide-react';

export const Marquee = () => {
  const containerRef = useRef(null);
  const row1Ref = useRef(null);
  const row2Ref = useRef(null);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      // Track 1: Leftward continuous scroll
      const tween1 = gsap.to(row1Ref.current, {
        xPercent: -50,
        ease: 'none',
        duration: 22,
        repeat: -1,
      });

      // Track 2: Rightward continuous scroll
      const tween2 = gsap.fromTo(
        row2Ref.current,
        { xPercent: -50 },
        {
          xPercent: 0,
          ease: 'none',
          duration: 26,
          repeat: -1,
        }
      );

      // Scroll speed acceleration
      ScrollTrigger.create({
        trigger: containerRef.current,
        start: 'top bottom',
        end: 'bottom top',
        onUpdate: (self) => {
          const velocity = Math.abs(self.getVelocity() / 250);
          const timeScale = gsap.utils.clamp(1, 4, 1 + velocity);
          gsap.to([tween1, tween2], {
            timeScale: timeScale,
            duration: 0.35,
            overwrite: 'auto',
          });
        },
      });
    },
    { scope: containerRef }
  );

  const statementItems1 = [
    'STYLE IS AN ATTITUDE',
    'CLOTHINGSTORE',
    'NEW GENERATION FASHION',
    'HAUTE COUTURE 2026',
    'TAILORED PERFECTION',
  ];

  const statementItems2 = [
    'DEFINING MODERN LUXURY',
    'PURE SILK & MERINO',
    'CRAFTED FOR IDENTITY',
    'AVANT-GARDE READY TO WEAR',
    'TIMELESS ELEGANCE',
  ];

  return (
    <section
      ref={containerRef}
      className="py-12 sm:py-16 bg-[#F8F7F4] dark:bg-[#09090B] text-[#0B0B0D] dark:text-white overflow-hidden border-y border-black/5 dark:border-white/5 select-none relative transition-colors duration-500"
      aria-label="Brand Statement Marquee"
    >
      {/* Side Fade Gradients */}
      <div className="absolute left-0 top-0 bottom-0 w-24 sm:w-44 bg-gradient-to-r from-[#F8F7F4] dark:from-[#09090B] to-transparent z-10 pointer-events-none" />
      <div className="absolute right-0 top-0 bottom-0 w-24 sm:w-44 bg-gradient-to-l from-[#F8F7F4] dark:from-[#09090B] to-transparent z-10 pointer-events-none" />

      {/* Row 1: Leftward */}
      <div className="flex whitespace-nowrap overflow-hidden mb-3">
        <div ref={row1Ref} className="flex items-center gap-8 shrink-0">
          {[...statementItems1, ...statementItems1, ...statementItems1].map((text, idx) => (
            <div key={idx} className="flex items-center gap-8">
              <span
                className={`text-2xl sm:text-5xl font-extrabold uppercase tracking-[0.18em] transition-colors duration-300 ${
                  idx % 2 === 0
                    ? 'text-[#0B0B0D] dark:text-white'
                    : 'text-transparent [-webkit-text-stroke:1px_#C6A77B] hover:text-[#C6A77B]'
                }`}
              >
                {text}
              </span>
              <Sparkles className="w-5 h-5 text-[#C6A77B] shrink-0 animate-spin" style={{ animationDuration: '8s' }} />
            </div>
          ))}
        </div>
      </div>

      {/* Row 2: Rightward */}
      <div className="flex whitespace-nowrap overflow-hidden">
        <div ref={row2Ref} className="flex items-center gap-8 shrink-0">
          {[...statementItems2, ...statementItems2, ...statementItems2].map((text, idx) => (
            <div key={idx} className="flex items-center gap-8">
              <span
                className={`text-xl sm:text-4xl font-serif italic font-light uppercase tracking-[0.2em] transition-colors duration-300 ${
                  idx % 2 !== 0
                    ? 'text-[#9E8254] dark:text-[#E2CEAE]'
                    : 'text-transparent [-webkit-text-stroke:1px_rgba(0,0,0,0.3)] dark:[-webkit-text-stroke:1px_rgba(255,255,255,0.4)] hover:text-black dark:hover:text-white'
                }`}
              >
                {text}
              </span>
              <span className="w-2.5 h-2.5 rounded-full bg-[#C6A77B]/60 shrink-0" />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};
