import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useGSAP } from '@gsap/react';
import { gsap } from '../../lib/gsap';
import { ArrowUpRight, RefreshCw, Sparkles } from 'lucide-react';
import { categoryApi } from '../../api';
import './Categories.css';

const FALLBACK_IMAGE =
  'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=900&q=85';

const MAX_FEATURED_CATEGORIES = 8;

const CATEGORY_IMAGES = [
  {
    keywords: ['ao thun', 't shirt', 'tee'],
    image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['ao so mi', 'shirt'],
    image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['polo'],
    image: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['ao khoac', 'jacket', 'coat'],
    image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['hoodie', 'sweatshirt', 'ao ni'],
    image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['jeans', 'denim'],
    image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['kaki', 'chino'],
    image: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['short', 'shorts'],
    image: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['quan tay', 'quan au', 'trouser', 'pants'],
    image: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?auto=format&fit=crop&w=900&q=85',
  },
  {
    keywords: ['vay', 'dam', 'dress', 'skirt'],
    image: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=900&q=85',
  },
];

const normalizeCategoryName = (name = '') =>
  name
    .toLocaleLowerCase('vi')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/đ/g, 'd');

const getCategoryImage = (name) => {
  const normalizedName = normalizeCategoryName(name);
  const match = CATEGORY_IMAGES.find(({ keywords }) =>
    keywords.some((keyword) => normalizedName.includes(keyword))
  );
  return match?.image || FALLBACK_IMAGE;
};

const isHiddenCategory = (category) => {
  const name = normalizeCategoryName(category.name);
  return name === 'quan tay' || name === 'vay & dam' || name === 'vay va dam';
};

export const Categories = ({ onSelectCategory, onNavigateShop }) => {
  const containerRef = useRef(null);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const requestCategories = useCallback(async () => {
    const data = await categoryApi.getAll();
    if (!Array.isArray(data)) {
      throw new Error('Dữ liệu danh mục không hợp lệ.');
    }
    return data;
  }, []);

  useEffect(() => {
    let isMounted = true;

    requestCategories()
      .then((data) => {
        if (isMounted) setCategories(data);
      })
      .catch((loadError) => {
        console.error('Không thể tải danh mục sản phẩm:', loadError);
        if (isMounted) setError('Chưa thể tải danh mục. Vui lòng thử lại.');
      })
      .finally(() => {
        if (isMounted) setLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, [requestCategories]);

  const retryLoadingCategories = async () => {
    setError('');
    setLoading(true);
    try {
      setCategories(await requestCategories());
    } catch (loadError) {
      console.error('Không thể tải danh mục sản phẩm:', loadError);
      setError('Chưa thể tải danh mục. Vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  const visibleCategories = categories
    .filter((category) => !isHiddenCategory(category))
    .slice(0, MAX_FEATURED_CATEGORIES);

  useGSAP(
    () => {
      if (loading || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

      gsap.fromTo(
        '.category-editorial-card',
        { y: 28, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 0.65,
          stagger: 0.08,
          ease: 'power2.out',
          scrollTrigger: {
            trigger: containerRef.current,
            start: 'top 82%',
            once: true,
          },
        }
      );
    },
    { scope: containerRef, dependencies: [visibleCategories, loading], revertOnUpdate: true }
  );

  return (
    <section
      ref={containerRef}
      id="categories-section"
      className="category-editorial-section py-20 sm:py-24"
      aria-label="Danh mục sản phẩm"
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mb-9 sm:mb-12">
          <div>
            <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-[#C6A77B]/30 bg-[#C6A77B]/10 px-3.5 py-1.5">
              <Sparkles className="h-3.5 w-3.5 text-[#A47D4C]" />
              <span className="text-[10px] font-bold uppercase tracking-[0.22em] text-[#8F6D42] dark:text-[#D8BB91]">
                Khám phá bộ sưu tập
              </span>
            </div>
            <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between sm:gap-8">
              <h2 className="text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] sm:text-5xl">
                DANH MỤC <span className="font-serif font-light italic text-[#B59363]">SẢN PHẨM</span>
              </h2>
              <button
                type="button"
                onClick={onNavigateShop}
                className="group inline-flex shrink-0 items-center justify-center gap-2 self-start rounded-full border border-black/15 bg-white/70 px-5 py-3 text-[11px] font-bold uppercase tracking-[0.14em] text-[#0B0B0D] shadow-sm transition hover:-translate-y-0.5 hover:border-[#C6A77B] hover:bg-white hover:text-[#A47D4C] hover:shadow-md dark:border-white/20 dark:bg-white/5 dark:text-white dark:hover:bg-white/10 dark:hover:text-[#D8BB91] sm:self-auto"
              >
                Xem tất cả sản phẩm
                <ArrowUpRight className="h-4 w-4 transition-transform group-hover:-translate-y-0.5 group-hover:translate-x-0.5" />
              </button>
            </div>
            <p className="mt-3 max-w-xl text-sm leading-6 text-zinc-600 dark:text-zinc-400">
              Chọn danh mục yêu thích và tìm thiết kế phù hợp với phong cách của bạn.
            </p>
          </div>
        </div>

        {error ? (
          <div className="rounded-3xl border border-rose-200 bg-white p-8 text-center dark:border-rose-900/50 dark:bg-[#141416]">
            <p className="text-sm font-semibold text-zinc-700 dark:text-zinc-200">{error}</p>
            <button
              type="button"
              onClick={retryLoadingCategories}
              className="mt-4 inline-flex items-center gap-2 rounded-full bg-[#0B0B0D] px-5 py-2.5 text-xs font-bold text-white transition hover:bg-[#292522] dark:bg-[#C6A77B] dark:text-[#0B0B0D]"
            >
              <RefreshCw className="h-3.5 w-3.5" />
              Tải lại danh mục
            </button>
          </div>
        ) : loading ? (
          <div className="grid grid-cols-2 gap-4 sm:gap-5 lg:grid-cols-4">
            {Array.from({ length: 4 }, (_, index) => (
              <div
                key={index}
                className="aspect-[4/5] animate-pulse rounded-3xl bg-zinc-200 dark:bg-zinc-800"
              />
            ))}
          </div>
        ) : visibleCategories.length === 0 ? (
          <div className="rounded-3xl border border-black/5 bg-white px-6 py-14 text-center text-sm text-zinc-500 dark:border-white/10 dark:bg-[#141416] dark:text-zinc-400">
            Chưa có danh mục sản phẩm.
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-4 sm:gap-5 lg:grid-cols-4">
            {visibleCategories.map((category, index) => (
              <button
                key={category.id}
                type="button"
                onClick={() => {
                  if (onSelectCategory) {
                    onSelectCategory(category.id);
                  } else {
                    onNavigateShop?.();
                  }
                }}
                className="category-editorial-card group relative aspect-[4/5] overflow-hidden rounded-2xl bg-[#1a1714] text-left shadow-md transition duration-500 hover:-translate-y-1 hover:shadow-2xl focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[#C6A77B] sm:rounded-3xl"
                aria-label={`Xem danh mục ${category.name}`}
              >
                <img
                  src={getCategoryImage(category.name)}
                  alt=""
                  loading={index < 4 ? 'eager' : 'lazy'}
                  className="absolute inset-0 h-full w-full object-cover transition duration-700 ease-out group-hover:scale-105"
                  onError={(event) => {
                    if (!event.currentTarget.dataset.fallbackApplied) {
                      event.currentTarget.dataset.fallbackApplied = 'true';
                      event.currentTarget.src = FALLBACK_IMAGE;
                    } else {
                      event.currentTarget.style.display = 'none';
                    }
                  }}
                />
                <span className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/15 to-black/5 transition-colors duration-500 group-hover:from-black/90" />
                <span className="absolute left-3 top-3 rounded-full border border-white/25 bg-black/20 px-2.5 py-1 text-[9px] font-semibold uppercase tracking-[0.16em] text-white/90 backdrop-blur-md sm:left-4 sm:top-4 sm:px-3 sm:text-[10px]">
                  Danh mục {String(index + 1).padStart(2, '0')}
                </span>
                <span className="absolute inset-x-0 bottom-0 flex items-end justify-between gap-2 p-3.5 sm:p-5">
                  <span className="min-w-0">
                    <span className="block text-base font-extrabold leading-tight tracking-tight text-white sm:text-xl lg:text-2xl">
                      {category.name}
                    </span>
                    {category.description && (
                      <span className="mt-1.5 line-clamp-2 block text-[10px] leading-relaxed text-white/75 sm:text-xs">
                        {category.description}
                      </span>
                    )}
                  </span>
                  <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full border border-white/45 bg-white/10 text-white backdrop-blur transition duration-300 group-hover:border-[#C6A77B] group-hover:bg-[#C6A77B] group-hover:text-[#0B0B0D] sm:h-10 sm:w-10">
                    <ArrowUpRight className="h-4 w-4 transition-transform group-hover:-translate-y-0.5 group-hover:translate-x-0.5 sm:h-5 sm:w-5" />
                  </span>
                </span>
              </button>
            ))}
          </div>
        )}
      </div>
    </section>
  );
};
