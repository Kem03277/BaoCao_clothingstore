import React, { useCallback, useEffect, useState } from 'react';
import { ArrowUpRight, RefreshCw, Sparkles } from 'lucide-react';
import { brandApi } from '../../api';
import './BrandShowcase.css';

const MAX_FEATURED_BRANDS = 10;

export const BrandShowcase = () => {
  const [brands, setBrands] = useState([]);
  const [brokenLogos, setBrokenLogos] = useState(() => new Set());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const requestBrands = useCallback(async () => {
    const data = await brandApi.getAll();
    if (!Array.isArray(data)) {
      throw new Error('Dữ liệu thương hiệu không hợp lệ.');
    }
    return data;
  }, []);

  useEffect(() => {
    let isMounted = true;

    requestBrands()
      .then((data) => {
        if (isMounted) setBrands(data);
      })
      .catch((loadError) => {
        console.error('Không thể tải thương hiệu:', loadError);
        if (isMounted) setError('Chưa thể tải danh sách thương hiệu. Vui lòng thử lại.');
      })
      .finally(() => {
        if (isMounted) setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, [requestBrands]);

  const retryLoadingBrands = async () => {
    setError('');
    setLoading(true);
    try {
      setBrands(await requestBrands());
      setBrokenLogos(new Set());
    } catch (loadError) {
      console.error('Không thể tải thương hiệu:', loadError);
      setError('Chưa thể tải danh sách thương hiệu. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  const handleLogoError = (brandId) => {
    setBrokenLogos((current) => new Set(current).add(brandId));
  };

  const featuredBrands = brands.slice(0, MAX_FEATURED_BRANDS);

  return (
    <section
      id="brand-story-section"
      className="brand-showcase-section py-20 sm:py-24"
      aria-label="Thương hiệu thời trang"
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mx-auto mb-10 max-w-3xl text-center sm:mb-12">
          <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-[#C6A77B]/30 bg-[#C6A77B]/10 px-3.5 py-1.5">
            <Sparkles className="h-3.5 w-3.5 text-[#A47D4C]" />
            <span className="text-[10px] font-bold uppercase tracking-[0.22em] text-[#8F6D42] dark:text-[#D8BB91]">
              Đối tác thời trang
            </span>
          </div>
          <h2 className="text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] sm:text-5xl">
            THƯƠNG HIỆU <span className="font-serif font-light italic text-[#B59363]">NỔI BẬT</span>
          </h2>
          <p className="mx-auto mt-3 max-w-xl text-sm leading-6 text-zinc-600 dark:text-zinc-400">
            Khám phá những thương hiệu đang có mặt tại ClothingStore, với tên và logo được đồng bộ trực tiếp từ dữ liệu cửa hàng.
          </p>
        </div>

        {error ? (
          <div className="rounded-3xl border border-rose-200 bg-white p-8 text-center dark:border-rose-900/50 dark:bg-[#141416]">
            <p className="text-sm font-semibold text-zinc-700 dark:text-zinc-200">{error}</p>
            <button
              type="button"
              onClick={retryLoadingBrands}
              className="mt-4 inline-flex items-center gap-2 rounded-full bg-[#0B0B0D] px-5 py-2.5 text-xs font-bold text-white transition hover:bg-[#292522] dark:bg-[#C6A77B] dark:text-[#0B0B0D]"
            >
              <RefreshCw className="h-3.5 w-3.5" />
              Tải lại thương hiệu
            </button>
          </div>
        ) : loading ? (
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 sm:gap-4 lg:grid-cols-5">
            {Array.from({ length: 10 }, (_, index) => (
              <div
                key={index}
                className="h-36 animate-pulse rounded-2xl border border-black/5 bg-white dark:border-white/10 dark:bg-[#141416] sm:h-40"
              />
            ))}
          </div>
        ) : featuredBrands.length === 0 ? (
          <div className="rounded-3xl border border-black/5 bg-white px-6 py-14 text-center text-sm text-zinc-500 dark:border-white/10 dark:bg-[#141416] dark:text-zinc-400">
            Chưa có thương hiệu nào.
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 sm:gap-4 lg:grid-cols-5">
            {featuredBrands.map((brand) => {
              const showLogo = brand.logoUrl && !brokenLogos.has(brand.id);
              return (
                <article
                  key={brand.id}
                  className="brand-showcase-card group relative flex min-h-36 flex-col items-center justify-center overflow-hidden rounded-2xl border border-black/[0.06] bg-white px-4 py-5 text-center shadow-sm transition duration-300 hover:-translate-y-1 hover:border-[#C6A77B]/50 hover:shadow-xl dark:border-white/10 dark:bg-[#141416] sm:min-h-40 sm:rounded-3xl sm:px-5"
                >
                  <span className="pointer-events-none absolute inset-x-8 top-0 h-px bg-gradient-to-r from-transparent via-[#C6A77B]/60 to-transparent opacity-0 transition-opacity group-hover:opacity-100" />
                  <div className="mb-3 flex h-16 w-full items-center justify-center sm:h-[4.5rem]">
                    {showLogo ? (
                      <img
                        src={brand.logoUrl}
                        alt={`Logo ${brand.brandName}`}
                        loading="lazy"
                        className="brand-showcase-logo max-h-full max-w-[72%] object-contain transition duration-300 group-hover:scale-105"
                        onError={() => handleLogoError(brand.id)}
                      />
                    ) : (
                      <span className="flex h-14 w-14 items-center justify-center rounded-2xl border border-[#C6A77B]/25 bg-[#C6A77B]/10 font-serif text-xl font-bold text-[#9A7548] dark:text-[#D8BB91]">
                        {(brand.brandName || '?').slice(0, 1).toUpperCase()}
                      </span>
                    )}
                  </div>
                  <h3 className="text-sm font-extrabold tracking-wide text-[#171717] transition-colors group-hover:text-[#9A7548] dark:text-[#F8F7F4] dark:group-hover:text-[#D8BB91] sm:text-base">
                    {brand.brandName}
                  </h3>
                  {brand.description && (
                    <p className="mt-1.5 line-clamp-2 text-[10px] leading-relaxed text-zinc-500 dark:text-zinc-400 sm:text-[11px]">
                      {brand.description}
                    </p>
                  )}
                  <ArrowUpRight className="absolute right-3 top-3 h-3.5 w-3.5 text-[#B59363] opacity-0 transition duration-300 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 group-hover:opacity-100" />
                </article>
              );
            })}
          </div>
        )}
      </div>
    </section>
  );
};
