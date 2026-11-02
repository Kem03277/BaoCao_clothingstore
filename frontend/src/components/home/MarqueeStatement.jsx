import React, { useRef } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { Sparkles } from 'lucide-react';

gsap.registerPlugin(ScrollTrigger);

export const MarqueeStatement = () => {
  const containerRef = useRef(null);
  const row1Ref = useRef(null);
  const row2Ref = useRef(null);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      // Infinite continuous marquee track 1 (Leftward)
      const tween1 = gsap.to(row1Ref.current, {
        xPercent: -50,
        ease: 'none',
        duration: 25,
        repeat: -1,
      });

      // Infinite continuous marquee track 2 (Rightward)
      const tween2 = gsap.fromTo(
        row2Ref.current,
        { xPercent: -50 },
        {
          xPercent: 0,
          ease: 'none',
          duration: 28,
          repeat: -1,
        }
      );

      // Scroll speed acceleration with ScrollTrigger
      ScrollTrigger.create({
        trigger: containerRef.current,
        start: 'top bottom',
        end: 'bottom top',
        onUpdate: (self) => {
          const velocity = Math.abs(self.getVelocity() / 300);
          const timeScale = gsap.utils.clamp(1, 4, 1 + velocity);
          gsap.to([tween1, tween2], {
            timeScale: timeScale,
            duration: 0.3,
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
    'TIMELESS ELEGANCE',
  ];

  const statementItems2 = [
    'DEFINING MODERN LUXURY',
    'TAILORED PERFECTION',
    'CRAFTED FOR IDENTITY',
    'PURE SILK & MERINO',
    'AVANT-GARDE READY TO WEAR',
  ];

  return (
    <section
      ref={containerRef}
      className="py-12 sm:py-16 bg-[#0B0B0D] text-white overflow-hidden border-y border-white/10 select-none relative"
      aria-label="Brand Statement Marquee"
    >
      {/* Ambient Side Fade Gradients */}
      <div className="absolute left-0 top-0 bottom-0 w-24 sm:w-40 bg-gradient-to-r from-[#0B0B0D] to-transparent z-10 pointer-events-none" />
      <div className="absolute right-0 top-0 bottom-0 w-24 sm:w-40 bg-gradient-to-l from-[#0B0B0D] to-transparent z-10 pointer-events-none" />

      {/* Track 1: Moving Left */}
      <div className="flex whitespace-nowrap overflow-hidden mb-4">
        <div ref={row1Ref} className="flex items-center gap-8 shrink-0">
          {[...statementItems1, ...statementItems1, ...statementItems1].map((text, idx) => (
            <div key={idx} className="flex items-center gap-8">
              <span
                className={`text-2xl sm:text-5xl font-extrabold uppercase tracking-[0.18em] transition-colors duration-300 ${
                  idx % 2 === 0
                    ? 'text-white'
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

      {/* Track 2: Moving Right */}
      <div className="flex whitespace-nowrap overflow-hidden">
        <div ref={row2Ref} className="flex items-center gap-8 shrink-0">
          {[...statementItems2, ...statementItems2, ...statementItems2].map((text, idx) => (
            <div key={idx} className="flex items-center gap-8">
              <span
                className={`text-xl sm:text-4xl font-extrabold uppercase tracking-[0.2em] font-serif transition-colors duration-300 ${
                  idx % 2 !== 0
                    ? 'text-[#E2CEAE]'
                    : 'text-transparent [-webkit-text-stroke:1px_rgba(255,255,255,0.4)] hover:text-white'
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
