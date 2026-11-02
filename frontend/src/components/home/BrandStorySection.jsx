import React, { useRef } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { Sparkles, ShieldCheck, Feather, Globe, Compass, ArrowRight } from 'lucide-react';

gsap.registerPlugin(ScrollTrigger);

const CRAFT_METRICS = [
  {
    icon: Feather,
    val: '100%',
    title: 'Sợi Dệt Tự Nhiên Thượng Hạng',
    desc: 'Lụa tơ tằm Mulberry, cotton Ai Cập chải kỹ và len Merino nhập khẩu chuẩn châu Âu.',
  },
  {
    icon: Compass,
    val: '40+',
    title: 'Công Đoạn Cắt May Khắt Khe',
    desc: 'Mỗi đường viền, ve áo và đường ráp nối được kiểm định thủ công bởi nghệ nhân may đo lành nghề.',
  },
  {
    icon: Globe,
    val: 'Zero',
    title: 'Phát Thải Vải Thừa Độc Hại',
    desc: 'Quy trình dệt nhuộm tuần hoàn không độc hại, đạt tiêu chuẩn an toàn sinh thái OEKO-TEX Standard 100.',
  },
];

export const BrandStorySection = ({ onNavigateShop }) => {
  const containerRef = useRef(null);

  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      // Parallax on story image
      gsap.to('.story-image', {
        yPercent: -12,
        ease: 'none',
        scrollTrigger: {
          trigger: containerRef.current,
          start: 'top bottom',
          end: 'bottom top',
          scrub: 1.5,
        },
      });

      // Stagger reveal on text content
      gsap.fromTo(
        '.story-fade',
        { y: 40, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 1,
          stagger: 0.15,
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
      className="py-24 sm:py-32 bg-[#F8F7F4] dark:bg-[#0E0E11] text-[#101010] dark:text-[#F8F7F4] overflow-hidden transition-colors duration-500"
      aria-label="Brand Story"
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
          
          {/* Left Column: Editorial Imagery with Layering */}
          <div className="lg:col-span-6 relative">
            
            {/* Main Visual Card */}
            <div className="relative rounded-3xl overflow-hidden shadow-2xl aspect-[4/5] bg-zinc-200 dark:bg-zinc-800">
              <img
                src="https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80"
                alt="Brand Craftsmanship Look"
                className="story-image w-full h-[120%] object-cover object-center -mt-[10%]"
                loading="lazy"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent pointer-events-none" />
              
              <div className="absolute bottom-6 left-6 right-6 text-white pointer-events-none">
                <span className="text-[10px] uppercase font-bold tracking-widest text-[#E2CEAE] font-mono">
                  Atelier Craftsmanship
                </span>
                <p className="text-sm font-serif italic mt-0.5">
                  "Đường kim mũi chỉ là ngôn ngữ của sự tôn trọng."
                </p>
              </div>
            </div>

            {/* Overlapping Floating Badge */}
            <div className="hidden sm:block absolute -bottom-8 -right-8 w-44 rounded-2xl bg-white dark:bg-[#1A1A1E] p-4 shadow-2xl border border-black/5 dark:border-white/10 backdrop-blur-md">
              <Sparkles className="w-5 h-5 text-[#C6A77B] mb-2" />
              <p className="text-xs font-bold uppercase tracking-wider text-[#101010] dark:text-white">
                Bảo chứng Haute Couture
              </p>
              <p className="text-[10px] text-zinc-500 dark:text-zinc-400 mt-1">
                Kỹ thuật may đo thủ công tinh chỉnh từng milimet.
              </p>
            </div>

          </div>

          {/* Right Column: Editorial Copy & Craft Metrics */}
          <div className="lg:col-span-6 space-y-8">
            
            <div className="story-fade inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#C6A77B]/10 border border-[#C6A77B]/30">
              <Sparkles className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
                The Heritage Manifesto
              </span>
            </div>

            <div className="space-y-4">
              <h2 className="story-fade text-4xl sm:text-6xl font-extrabold tracking-tight leading-[1.05]">
                WEAR YOUR <br />
                <span className="font-serif italic font-normal text-[#C6A77B]">IDENTITY.</span>
              </h2>

              <p className="story-fade text-base sm:text-lg text-zinc-600 dark:text-zinc-300 font-sans leading-relaxed">
                ClothingStore mang đến những lựa chọn thời trang giúp bạn tự tin thể hiện phong cách riêng.
              </p>

              <p className="story-fade text-xs sm:text-sm text-zinc-500 dark:text-zinc-400 font-sans leading-relaxed">
                Chúng tôi từ chối tư duy sản xuất đại trà chớp nhoáng. Từng mẫu áo sơ mi, blazer và đầm dạ hội ra đời từ studio ClothingStore đều được gửi gắm tâm huyết, tôn vinh hình thể người mặc và bền vững theo thời gian.
              </p>
            </div>

            {/* Metrics List */}
            <div className="space-y-4 pt-2">
              {CRAFT_METRICS.map((item, idx) => {
                const IconComponent = item.icon;
                return (
                  <div
                    key={idx}
                    className="story-fade p-4 rounded-2xl bg-white dark:bg-[#141417] border border-black/5 dark:border-white/10 shadow-sm flex items-start gap-4 transition-transform hover:-translate-y-0.5 duration-300"
                  >
                    <div className="w-10 h-10 rounded-xl bg-[#F8F7F4] dark:bg-white/5 border border-[#C6A77B]/20 flex items-center justify-center text-[#C6A77B] shrink-0">
                      <IconComponent className="w-5 h-5" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-base font-extrabold text-[#C6A77B] font-mono">{item.val}</span>
                        <h4 className="text-xs font-bold uppercase tracking-wider text-[#101010] dark:text-white">
                          {item.title}
                        </h4>
                      </div>
                      <p className="text-xs text-zinc-500 dark:text-zinc-400 mt-1 leading-relaxed">
                        {item.desc}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* CTA */}
            <div className="story-fade pt-4">
              <button
                onClick={onNavigateShop}
                className="px-8 py-4 rounded-full bg-[#101010] dark:bg-white text-white dark:text-[#101010] hover:bg-[#C6A77B] dark:hover:bg-[#C6A77B] dark:hover:text-[#101010] font-bold text-xs uppercase tracking-widest shadow-xl hover:scale-105 transition-all duration-300 flex items-center gap-2 cursor-pointer"
              >
                <span>Khám phá thương hiệu</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>

          </div>

        </div>
      </div>
    </section>
  );
};
