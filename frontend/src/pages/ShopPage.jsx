import React, { useEffect, useState, useMemo } from 'react';
import {
  Search, SlidersHorizontal, X, ChevronDown, ChevronLeft, ChevronRight,
  ShoppingBag, RotateCcw, Filter
} from 'lucide-react';
import { productApi, categoryApi, brandApi } from '../api';
import { ProductCard } from '../components/ProductCard';
import './ShopPage.css';

const PRODUCTS_PER_PAGE = 6;

export const ShopPage = ({ onSelectProduct, initialCategory = null, initialKeyword = '' }) => {
  const [products, setProducts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalProducts, setTotalProducts] = useState(0);

  // Filters state
  const [searchQuery, setSearchQuery] = useState(initialKeyword || '');
  const [selectedCategory, setSelectedCategory] = useState(initialCategory ? String(initialCategory) : '');
  const [selectedBrand, setSelectedBrand] = useState('');
  const [selectedGender, setSelectedGender] = useState('');
  const [sortBy, setSortBy] = useState('newest');
  const [priceMin, setPriceMin] = useState('');
  const [priceMax, setPriceMax] = useState('');
  const [showMobileFilter, setShowMobileFilter] = useState(false);

  const updateFilters = (update) => {
    setCurrentPage(1);
    update();
  };

  // Load categories and brands once
  useEffect(() => {
    const loadMetadata = async () => {
      try {
        const [catRes, brandRes] = await Promise.allSettled([
          categoryApi.getAll(),
          brandApi.getAll(),
        ]);
        if (catRes.status === 'fulfilled') setCategories(catRes.value || []);
        if (brandRes.status === 'fulfilled') setBrands(brandRes.value || []);
      } catch (err) {
        console.error('Lỗi khi tải danh mục/thương hiệu:', err);
      }
    };
    loadMetadata();
  }, []);

  // Fetch products with backend filtering
  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      try {
        const params = {
          sort: sortBy,
        };
        if (selectedCategory) params.categoryId = selectedCategory;
        if (selectedBrand) params.brandId = selectedBrand;
        if (selectedGender) params.gender = selectedGender;
        const parsePrice = (v) => {
          if (!v || isNaN(v)) return undefined;
          const num = Number(v);
          return num > 0 && num < 1000 ? num * 1000 : num;
        };
        if (priceMin) params.minPrice = parsePrice(priceMin);
        if (priceMax) params.maxPrice = parsePrice(priceMax);
        if (searchQuery.trim()) params.keyword = searchQuery.trim();

        const result = await productApi.getPage({
          ...params,
          page: currentPage - 1,
          size: PRODUCTS_PER_PAGE,
        });
        setProducts(result?.content || []);
        setTotalProducts(result?.totalElements || 0);
      } catch (err) {
        console.error('Lỗi khi tải sản phẩm:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, [selectedCategory, selectedBrand, selectedGender, sortBy, priceMin, priceMax, searchQuery, currentPage]);

  const totalPages = Math.ceil(totalProducts / PRODUCTS_PER_PAGE);
  const visibleProducts = products;

  const pageNumbers = useMemo(() => {
    if (totalPages <= 7) {
      return Array.from({ length: totalPages }, (_, index) => index + 1);
    }

    const pages = [1];
    if (currentPage > 3) pages.push('start-ellipsis');
    for (
      let page = Math.max(2, currentPage - 1);
      page <= Math.min(totalPages - 1, currentPage + 1);
      page += 1
    ) {
      pages.push(page);
    }
    if (currentPage < totalPages - 2) pages.push('end-ellipsis');
    pages.push(totalPages);
    return pages;
  }, [currentPage, totalPages]);

  const clearFilters = () => {
    updateFilters(() => {
      setSearchQuery('');
      setSelectedCategory('');
      setSelectedBrand('');
      setSelectedGender('');
      setSortBy('newest');
      setPriceMin('');
      setPriceMax('');
    });
  };

  const hasActiveFilters =
    searchQuery || selectedCategory || selectedBrand || selectedGender || priceMin || priceMax || sortBy !== 'newest';

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">

      {/* Page Title & Subtitle */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 border-b border-black/5 dark:border-white/10 pb-6">
        <div>
          <span className="text-xs uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
            Bộ Sưu Tập Cửa Hàng
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] mt-1">
            Tất Cả Sản Phẩm
          </h1>
        </div>
      </div>

      {/* Search Bar & Quick Sort Controls */}
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
        {/* Search */}
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-400" />
          <input
            type="text"
            placeholder="Tìm kiếm sản phẩm, chất liệu, màu sắc..."
            value={searchQuery}
            onChange={(e) => updateFilters(() => setSearchQuery(e.target.value))}
            className="w-full pl-10 pr-9 py-2.5 rounded-full border border-zinc-200 dark:border-white/10 bg-white dark:bg-[#141416] text-[#0B0B0D] dark:text-[#F8F7F4] placeholder:text-zinc-400 dark:placeholder:text-zinc-500 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B] shadow-xs"
          />
          {searchQuery && (
            <button
              onClick={() => updateFilters(() => setSearchQuery(''))}
              className="absolute right-3.5 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-black dark:hover:text-white"
            >
              <X className="w-3.5 h-3.5" />
            </button>
          )}
        </div>

        {/* Sort & Filter Toggle */}
        <div className="flex items-center gap-2">
          {/* Mobile Filter Toggle */}
          <button
            onClick={() => setShowMobileFilter(!showMobileFilter)}
            className={`md:hidden flex items-center gap-1.5 px-4 py-2.5 rounded-full text-xs font-bold uppercase tracking-wider border transition ${hasActiveFilters
                ? 'bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D] border-transparent'
                : 'bg-white dark:bg-[#141416] border-zinc-200 dark:border-white/10 text-zinc-700 dark:text-zinc-300'
              }`}
          >
            <Filter className="w-3.5 h-3.5" />
            <span>Bộ lọc</span>
            {hasActiveFilters && (
              <span className="w-2 h-2 rounded-full bg-[#C6A77B] dark:bg-[#0B0B0D]" />
            )}
          </button>

          {/* Sort Selector */}
          <div className="relative">
            <select
              value={sortBy}
              onChange={(e) => updateFilters(() => setSortBy(e.target.value))}
              className="appearance-none pl-4 pr-9 py-2.5 rounded-full border border-zinc-200 dark:border-white/10 bg-white dark:bg-[#141416] text-xs font-bold uppercase tracking-wider text-zinc-700 dark:text-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] cursor-pointer shadow-xs"
            >
              <option value="newest" className="dark:bg-[#141416]">Mới nhất</option>
              <option value="price_asc" className="dark:bg-[#141416]">Giá: Thấp đến Cao</option>
              <option value="price_desc" className="dark:bg-[#141416]">Giá: Cao đến Thấp</option>
              <option value="name_asc" className="dark:bg-[#141416]">Tên: A đến Z</option>
            </select>
            <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-zinc-400 pointer-events-none" />
          </div>
        </div>
      </div>

      {/* Main Content Layout: Sidebar Filter (Desktop) + Product Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-8 items-start">

        {/* Desktop Filter Sidebar */}
        <aside className={`md:block ${showMobileFilter ? 'block' : 'hidden'} md:col-span-1 bg-white dark:bg-[#141416] rounded-3xl p-6 border border-black/5 dark:border-white/10 shadow-sm space-y-6 sticky top-24 transition-colors duration-300`}>
          <div className="flex items-center justify-between pb-4 border-b border-black/5 dark:border-white/10">
            <h3 className="font-bold text-base text-[#0B0B0D] dark:text-[#F8F7F4] flex items-center gap-2">
              <SlidersHorizontal className="w-4 h-4 text-[#C6A77B]" />
              Bộ Lọc Tuyển Chọn
            </h3>
            {hasActiveFilters && (
              <button
                onClick={clearFilters}
                className="text-xs text-[#C6A77B] hover:underline font-bold flex items-center gap-1 cursor-pointer"
              >
                <RotateCcw className="w-3 h-3" />
                Đặt lại
              </button>
            )}
          </div>

          {/* Categories */}
          <div>
            <label className="block text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider mb-2.5">
              Danh mục
            </label>
            <div className="space-y-1.5 max-h-48 overflow-y-auto pr-1">
              <button
                onClick={() => updateFilters(() => setSelectedCategory(''))}
                className={`w-full text-left px-3 py-2 rounded-xl text-xs font-semibold transition flex items-center justify-between ${!selectedCategory
                    ? 'bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D]'
                    : 'text-zinc-600 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-white/5'
                  }`}
              >
                <span>Tất cả</span>
              </button>
              {categories.map((c) => (
                <button
                  key={c.id}
                  onClick={() => updateFilters(() => setSelectedCategory(String(c.id)))}
                  className={`w-full text-left px-3 py-2 rounded-xl text-xs font-semibold transition flex items-center justify-between ${selectedCategory === String(c.id)
                      ? 'bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D]'
                      : 'text-zinc-600 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-white/5'
                    }`}
                >
                  <span>{c.name}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Gender */}
          <div>
            <label
              htmlFor="shop-gender-filter"
              className="block text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider mb-2.5"
            >
              Giới tính
            </label>
            <select
              id="shop-gender-filter"
              value={selectedGender}
              onChange={(e) => updateFilters(() => setSelectedGender(e.target.value))}
              className="w-full px-3 py-2 rounded-xl border border-zinc-200 dark:border-white/10 text-xs font-medium bg-white dark:bg-[#141416] text-[#0B0B0D] dark:text-[#F8F7F4] focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
            >
              <option value="" className="dark:bg-[#141416]">Tất cả giới tính</option>
              <option value="MALE" className="dark:bg-[#141416]">Nam</option>
              <option value="FEMALE" className="dark:bg-[#141416]">Nữ</option>
              <option value="UNISEX" className="dark:bg-[#141416]">Unisex</option>
            </select>
          </div>

          {/* Brands */}
          {brands.length > 0 && (
            <div>
              <label className="block text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider mb-2.5">
                Thương hiệu
              </label>
              <select
                value={selectedBrand}
                onChange={(e) => updateFilters(() => setSelectedBrand(e.target.value))}
                className="w-full px-3 py-2 rounded-xl border border-zinc-200 dark:border-white/10 text-xs font-medium bg-white dark:bg-[#141416] text-[#0B0B0D] dark:text-[#F8F7F4] focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
              >
                <option value="" className="dark:bg-[#141416]">Tất cả thương hiệu</option>
                {brands.map((b) => (
                  <option key={b.id} value={b.id} className="dark:bg-[#141416]">
                    {b.name || b.brandName}
                  </option>
                ))}
              </select>
            </div>
          )}

          {/* Price Range */}
          <div>
            <label className="block text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] uppercase tracking-wider mb-2.5">
              Khoảng giá (VNĐ)
            </label>
            <div className="grid grid-cols-2 gap-2 mb-2">
              <input
                type="number"
                placeholder="Từ (VD: 200k)"
                value={priceMin}
                onChange={(e) => updateFilters(() => setPriceMin(e.target.value))}
                min={0}
                className="w-full px-3 py-2 rounded-xl border border-zinc-200 dark:border-white/10 text-xs bg-white dark:bg-[#141416] text-[#0B0B0D] dark:text-[#F8F7F4] focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
              />
              <input
                type="number"
                placeholder="Đến (VD: 500k)"
                value={priceMax}
                onChange={(e) => updateFilters(() => setPriceMax(e.target.value))}
                min={0}
                className="w-full px-3 py-2 rounded-xl border border-zinc-200 dark:border-white/10 text-xs bg-white dark:bg-[#141416] text-[#0B0B0D] dark:text-[#F8F7F4] focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
              />
            </div>

            {/* Quick Price Tags */}
            <div className="flex flex-wrap gap-1.5 pt-1">
              <button
                type="button"
                onClick={() => updateFilters(() => { setPriceMin(''); setPriceMax('300000'); })}
                className="px-2 py-1 rounded-lg text-[10px] font-medium bg-zinc-100 hover:bg-zinc-200 dark:bg-white/5 dark:hover:bg-white/10 text-zinc-600 dark:text-zinc-300 transition"
              >
                &lt; 300k
              </button>
              <button
                type="button"
                onClick={() => updateFilters(() => { setPriceMin('300000'); setPriceMax('500000'); })}
                className="px-2 py-1 rounded-lg text-[10px] font-medium bg-zinc-100 hover:bg-zinc-200 dark:bg-white/5 dark:hover:bg-white/10 text-zinc-600 dark:text-zinc-300 transition"
              >
                300k - 500k
              </button>
              <button
                type="button"
                onClick={() => updateFilters(() => { setPriceMin('500000'); setPriceMax(''); })}
                className="px-2 py-1 rounded-lg text-[10px] font-medium bg-zinc-100 hover:bg-zinc-200 dark:bg-white/5 dark:hover:bg-white/10 text-zinc-600 dark:text-zinc-300 transition"
              >
                &gt; 500k
              </button>
            </div>
          </div>

          {/* Mobile Apply Button */}
          {showMobileFilter && (
            <button
              onClick={() => setShowMobileFilter(false)}
              className="w-full py-2.5 rounded-xl bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D] text-xs font-bold uppercase tracking-wider md:hidden"
            >
              Áp dụng bộ lọc
            </button>
          )}
        </aside>

        {/* Product Grid Area */}
        <main className="md:col-span-3">
          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-5">
              {Array.from({ length: 6 }).map((_, i) => (
                <div key={i} className="bg-white dark:bg-[#141416] rounded-2xl p-4 border border-black/5 dark:border-white/10 animate-pulse space-y-3">
                  <div className="aspect-[3/4] bg-zinc-200 dark:bg-zinc-800 rounded-xl" />
                  <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-2/3" />
                  <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-1/3" />
                </div>
              ))}
            </div>
          ) : products.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-24 text-center bg-white dark:bg-[#141416] rounded-3xl border border-black/5 dark:border-white/10 p-8">
              <ShoppingBag className="w-16 h-16 text-zinc-300 dark:text-zinc-600 mb-4 stroke-[1.2]" />
              <h3 className="text-xl font-bold text-[#0B0B0D] dark:text-[#F8F7F4]">
                Không tìm thấy sản phẩm phù hợp
              </h3>
              <p className="text-xs text-zinc-500 dark:text-zinc-400 mt-1 max-w-sm">
                Hãy thử nới lỏng bộ lọc hoặc tìm kiếm theo từ khóa khác.
              </p>
              {hasActiveFilters && (
                <button
                  onClick={clearFilters}
                  className="mt-5 px-6 py-2.5 rounded-full bg-[#0B0B0D] dark:bg-[#C6A77B] text-white dark:text-[#0B0B0D] text-xs font-bold uppercase tracking-widest hover:bg-black dark:hover:opacity-90 transition"
                >
                  Xóa toàn bộ bộ lọc
                </button>
              )}
            </div>
          ) : (
            <>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-5">
                {visibleProducts.map((product) => (
                  <ProductCard
                    key={product.id}
                    product={product}
                    onSelect={onSelectProduct}
                  />
                ))}
              </div>
              {totalPages > 1 && (
                <nav className="shop-pagination mt-10" aria-label="Phân trang sản phẩm">
                  <ul className="pagination">
                    <li className={`page-item ${currentPage === 1 ? 'disabled' : ''}`}>
                      <button
                        type="button"
                        className="page-link"
                        aria-label="Trang trước"
                        disabled={currentPage === 1}
                        onClick={() => setCurrentPage((page) => page - 1)}
                      >
                        <ChevronLeft className="h-4 w-4" />
                      </button>
                    </li>
                    {pageNumbers.map((page) => (
                      typeof page === 'string' ? (
                        <li key={page} className="page-item disabled" aria-hidden="true">
                          <span className="page-link">…</span>
                        </li>
                      ) : (
                        <li key={page} className={`page-item ${currentPage === page ? 'active' : ''}`}>
                          <button
                            type="button"
                            className="page-link"
                            aria-label={`Trang ${page}`}
                            aria-current={currentPage === page ? 'page' : undefined}
                            onClick={() => setCurrentPage(page)}
                          >
                            {page}
                          </button>
                        </li>
                      )
                    ))}
                    <li className={`page-item ${currentPage === totalPages ? 'disabled' : ''}`}>
                      <button
                        type="button"
                        className="page-link"
                        aria-label="Trang tiếp theo"
                        disabled={currentPage === totalPages}
                        onClick={() => setCurrentPage((page) => page + 1)}
                      >
                        <ChevronRight className="h-4 w-4" />
                      </button>
                    </li>
                  </ul>
                </nav>
              )}
            </>
          )}
        </main>

      </div>
    </div>
  );
};
