import React, { useRef } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from '../../lib/gsap';
import { ArrowRight, Quote, Sparkles } from 'lucide-react';

const LOOKS = [
  {
    image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=85',
    alt: 'Phong cách thời trang thanh lịch giữa phố',
    label: 'DẤU ẤN THANH LỊCH',
    caption: 'Tự tin trong từng khoảnh khắc.',
    className: 'lookbook-parallax-1',
  },
  {
    image: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=900&q=85',
    alt: 'Trang phục họa tiết nhẹ nhàng trong nắng',
    label: 'CẢM HỨNG MÙA MỚI',
    caption: 'Nhẹ nhàng, tự do và đầy sức sống.',
    className: '',
  },
  {
    image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=85',
    alt: 'Phong cách thời trang hiện đại và cá tính',
    label: 'PHONG CÁCH ĐƯƠNG ĐẠI',
    caption: 'Khác biệt theo cách của riêng bạn.',
    className: 'lookbook-parallax-2',
  },
];

export const Lookbook = ({ onNavigateShop }) => {
  const containerRef = useRef(null);

  useGSAP(
    () => {
      if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

      gsap.to('.lookbook-parallax-1', {
        yPercent: -10,
        ease: 'none',
        scrollTrigger: {
          trigger: containerRef.current,
          start: 'top bottom',
          end: 'bottom top',
          scrub: 1.5,
        },
      });

      gsap.to('.lookbook-parallax-2', {
        yPercent: 8,
        ease: 'none',
        scrollTrigger: {
          trigger: containerRef.current,
          start: 'top bottom',
          end: 'bottom top',
          scrub: 1.8,
        },
      });

      gsap.fromTo(
        '.lookbook-reveal',
        { y: 24, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 0.75,
          stagger: 0.1,
          ease: 'power2.out',
          scrollTrigger: {
            trigger: containerRef.current,
            start: 'top 78%',
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
      id="lookbook-section"
      className="relative overflow-hidden bg-[#F8F7F4] py-20 text-[#0B0B0D] transition-colors duration-500 dark:bg-[#09090B] dark:text-white sm:py-28"
      aria-label="Câu chuyện phong cách"
    >
      <div className="pointer-events-none absolute -right-36 top-12 h-96 w-96 rounded-full bg-[#C6A77B]/10 blur-[120px]" />
      <div className="pointer-events-none absolute -left-40 bottom-0 h-80 w-80 rounded-full bg-[#C6A77B]/[0.07] blur-[110px]" />

      <div className="relative z-10 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <header className="lookbook-reveal mx-auto mb-12 max-w-3xl text-center sm:mb-16">
          <div className="mb-5 inline-flex items-center gap-2 rounded-full border border-[#C6A77B]/30 bg-white/70 px-4 py-2 shadow-sm backdrop-blur dark:bg-white/5">
            <Sparkles className="h-3.5 w-3.5 text-[#B59363]" />
            <span className="text-[10px] font-bold uppercase tracking-[0.24em] text-[#9A7548] dark:text-[#D8BB91]">
              Tạp chí phong cách · 2026
            </span>
          </div>
          <h2 className="text-3xl font-extrabold leading-tight tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] sm:text-5xl lg:text-6xl">
            VẺ ĐẸP CỦA{' '}
            <span className="font-serif font-light italic text-[#B59363]">SỰ TINH TẾ</span>
          </h2>
          <p className="mx-auto mt-4 max-w-2xl text-sm leading-7 text-zinc-600 dark:text-zinc-400 sm:text-base">
            Mỗi thiết kế là sự hòa quyện của phom dáng, chất liệu và cá tính. Tinh tế không nằm ở điều phô trương, mà ở những chi tiết khiến bạn tự tin là chính mình.
          </p>
        </header>

        <div className="grid grid-cols-1 items-center gap-5 sm:gap-6 lg:grid-cols-12 lg:gap-7">
          <figure className="lookbook-reveal group relative overflow-hidden rounded-[1.75rem] bg-zinc-900 shadow-xl shadow-black/10 lg:col-span-5 lg:rounded-[2rem]">
            <div className="aspect-[4/4.5] overflow-hidden sm:aspect-[4/3] lg:aspect-[4/5]">
              <img
                src={LOOKS[0].image}
                alt={LOOKS[0].alt}
                className={`h-[115%] w-full object-cover object-top transition-transform duration-700 group-hover:scale-[1.03] ${LOOKS[0].className}`}
                loading="lazy"
              />
            </div>
            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/5 to-transparent" />
            <figcaption className="absolute inset-x-0 bottom-0 p-5 text-white sm:p-7">
              <span className="text-[9px] font-bold uppercase tracking-[0.22em] text-[#E2CEAE] sm:text-[10px]">
                Bộ sưu tập 01 · Dấu ấn thanh lịch
              </span>
              <p className="mt-2 font-serif text-lg italic sm:text-xl">
                “Mặc điều bạn yêu, tự tin theo cách bạn chọn.”
              </p>
            </figcaption>
            <span className="absolute left-5 top-5 rounded-full border border-white/30 bg-black/20 px-3 py-1.5 text-[9px] font-bold tracking-[0.18em] text-white backdrop-blur-md sm:left-6 sm:top-6">
              01 / 03
            </span>
          </figure>

          <div className="lookbook-reveal relative overflow-hidden rounded-[1.75rem] border border-[#C6A77B]/20 bg-white/80 px-6 py-9 text-center shadow-lg shadow-black/[0.04] backdrop-blur dark:bg-white/[0.045] sm:px-10 sm:py-11 lg:col-span-3 lg:px-6 lg:py-10">
            <div className="pointer-events-none absolute -right-12 -top-12 h-32 w-32 rounded-full border border-[#C6A77B]/15" />
            <div className="pointer-events-none absolute -right-7 -top-7 h-20 w-20 rounded-full border border-[#C6A77B]/15" />
            <div className="mx-auto mb-5 flex h-12 w-12 items-center justify-center rounded-2xl bg-[#C6A77B]/12 text-[#B59363]">
              <Quote className="h-6 w-6" />
            </div>
            <span className="text-[9px] font-bold uppercase tracking-[0.22em] text-[#9A7548] dark:text-[#D8BB91]">
              Tuyên ngôn phong cách
            </span>
            <blockquote className="mt-4 font-serif text-lg italic leading-8 text-[#6F5A3D] dark:text-[#E2CEAE] sm:text-xl">
              “Thời trang đổi thay theo mùa, phong thái riêng sẽ ở lại cùng năm tháng.”
            </blockquote>
            <div className="mx-auto my-6 h-px w-12 bg-[#C6A77B]/60" />
            <p className="text-xs leading-6 text-zinc-500 dark:text-zinc-400">
              Chọn chất liệu khiến bạn thoải mái. Chọn phom dáng khiến bạn tự tin.
            </p>
            <button
              type="button"
              onClick={onNavigateShop}
              className="group mt-7 inline-flex items-center justify-center gap-2 rounded-full bg-[#0B0B0D] px-6 py-3 text-[10px] font-bold uppercase tracking-[0.16em] text-white shadow-lg transition hover:-translate-y-0.5 hover:bg-[#C6A77B] hover:text-[#0B0B0D] dark:bg-[#C6A77B] dark:text-[#0B0B0D] dark:hover:bg-[#E2CEAE]"
            >
              Khám phá bộ sưu tập
              <ArrowRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-1" />
            </button>
          </div>

          <div className="grid grid-cols-2 gap-4 sm:gap-5 lg:col-span-4 lg:grid-cols-1">
            {LOOKS.slice(1).map((look, index) => (
              <figure
                key={look.label}
                className="lookbook-reveal group relative overflow-hidden rounded-2xl bg-zinc-900 shadow-lg shadow-black/10 sm:rounded-[1.75rem]"
              >
                <div className="aspect-[4/4.5] overflow-hidden sm:aspect-[4/3] lg:aspect-[4/3]">
                  <img
                    src={look.image}
                    alt={look.alt}
                    className={`h-[115%] w-full object-cover transition-transform duration-700 group-hover:scale-[1.04] ${look.className}`}
                    loading="lazy"
                  />
                </div>
                <div className="absolute inset-0 bg-gradient-to-t from-black/75 via-transparent to-black/10" />
                <figcaption className="absolute inset-x-0 bottom-0 p-3.5 text-white sm:p-5">
                  <span className="text-[8px] font-bold uppercase tracking-[0.17em] text-[#E2CEAE] sm:text-[9px]">
                    Bộ sưu tập {String(index + 2).padStart(2, '0')} · {look.label}
                  </span>
                  <p className="mt-1 text-[11px] font-medium sm:text-sm">{look.caption}</p>
                </figcaption>
              </figure>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
