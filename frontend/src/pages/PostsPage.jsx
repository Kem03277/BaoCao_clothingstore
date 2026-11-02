import React, { useEffect, useMemo, useState } from 'react';
import {
  ArrowLeft,
  ArrowRight,
  CalendarDays,
  Clock3,
  Loader2,
  Newspaper,
  Search,
  Sparkles,
} from 'lucide-react';
import { postApi, postCategoryApi } from '../api';

const formatDate = (date) => {
  if (!date) return 'Mới cập nhật';
  return new Intl.DateTimeFormat('vi-VN', { day: '2-digit', month: 'long', year: 'numeric' })
    .format(new Date(date));
};

const getExcerpt = (content = '') => {
  const plainText = (content || '').replace(/\s+/g, ' ').trim();
  return plainText.length > 170 ? `${plainText.slice(0, 170).trim()}…` : plainText;
};

const getReadTime = (content = '') => Math.max(1, Math.ceil(((content || '').trim().split(/\s+/).length || 1) / 200));

const ArticleImage = ({ post, className = '' }) => (
  <div className={`relative overflow-hidden bg-gradient-to-br from-zinc-800 via-zinc-900 to-black ${className}`}>
    {post.thumbnailUrl && (
      <img
        src={post.thumbnailUrl}
        alt={post.title}
        className="absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-105"
        onError={(event) => { event.currentTarget.style.display = 'none'; }}
      />
    )}
    <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
  </div>
);

const fetchContent = () => Promise.all([postApi.getAll(), postCategoryApi.getAll()]);

export const PostsPage = () => {
  const [posts, setPosts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeCategory, setActiveCategory] = useState('all');
  const [search, setSearch] = useState('');
  const [selectedPost, setSelectedPost] = useState(null);

  const loadContent = async () => {
    try {
      const [postRows, categoryRows] = await fetchContent();
      setPosts(postRows || []);
      setCategories(categoryRows || []);
    } catch (requestError) {
      setError(requestError.message || 'Không thể tải bài viết lúc này.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let active = true;
    fetchContent()
      .then(([postRows, categoryRows]) => {
        if (active) {
          setPosts(postRows || []);
          setCategories(categoryRows || []);
        }
      })
      .catch((requestError) => {
        if (active) setError(requestError.message || 'Không thể tải bài viết lúc này.');
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => { active = false; };
  }, []);

  const filteredPosts = useMemo(() => {
    const keyword = search.trim().toLocaleLowerCase('vi');
    return posts.filter((post) => {
      const matchesCategory = activeCategory === 'all' || post.postCategoryId === activeCategory;
      const matchesSearch = !keyword
        || `${post.title || ''} ${post.content || ''} ${post.postCategoryName || ''}`
          .toLocaleLowerCase('vi').includes(keyword);
      return matchesCategory && matchesSearch;
    });
  }, [activeCategory, posts, search]);

  const openPost = (post) => {
    setSelectedPost(post);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  if (selectedPost) {
    return (
      <article className="min-h-[70vh] bg-[#F8F7F4] dark:bg-[#0B0B0D] text-[#171717] dark:text-[#F8F7F4]">
        <div className="mx-auto max-w-4xl px-4 pb-20 pt-10 sm:px-6 lg:px-8">
          <button
            type="button"
            onClick={() => setSelectedPost(null)}
            className="mb-8 inline-flex items-center gap-2 text-xs font-bold uppercase tracking-[0.16em] text-zinc-500 transition hover:text-[#B59363] dark:text-zinc-400"
          >
            <ArrowLeft className="h-4 w-4" />
            Tất cả bài viết
          </button>
          <div className="mb-5 flex flex-wrap items-center gap-3 text-[10px] font-bold uppercase tracking-[0.18em] text-[#A98758]">
            <span>{selectedPost.postCategoryName || 'Bài viết'}</span>
            <span className="h-1 w-1 rounded-full bg-[#C6A77B]" />
            <span className="inline-flex items-center gap-1.5">
              <CalendarDays className="h-3.5 w-3.5" />
              {formatDate(selectedPost.publishedAt)}
            </span>
          </div>
          <h1 className="font-serif text-3xl leading-tight tracking-tight sm:text-5xl">
            {selectedPost.title}
          </h1>
          <p className="mt-5 text-sm text-zinc-500 dark:text-zinc-400">
            {selectedPost.authorName ? `Tác giả ${selectedPost.authorName}` : 'ClothingStore Editorial'}
          </p>
          <div className="group mt-9 aspect-[16/8] overflow-hidden rounded-[2rem] shadow-2xl shadow-black/10">
            <ArticleImage post={selectedPost} className="h-full w-full" />
          </div>
          <div className="mx-auto mt-10 max-w-3xl whitespace-pre-line text-[15px] leading-8 text-zinc-700 dark:text-zinc-300 sm:text-base sm:leading-9">
            {selectedPost.content}
          </div>
          <div className="mt-14 border-t border-black/10 pt-7 dark:border-white/10">
            <p className="font-serif text-xl text-[#A98758]">CLOTHINGSTORE — Mặc điều bạn tin.</p>
          </div>
        </div>
      </article>
    );
  }

  const featuredPost = filteredPosts[0];
  const remainingPosts = featuredPost ? filteredPosts.slice(1) : [];

  return (
    <div className="min-h-[70vh] bg-[#F8F7F4] pb-20 text-[#171717] dark:bg-[#0B0B0D] dark:text-[#F8F7F4]">
      <section className="relative overflow-hidden bg-[#101012] text-white">
        <div className="absolute -right-24 -top-32 h-96 w-96 rounded-full bg-[#C6A77B]/15 blur-3xl" />
        <div className="absolute -bottom-48 left-1/4 h-96 w-96 rounded-full bg-[#C6A77B]/10 blur-3xl" />
        <div className="relative mx-auto grid max-w-7xl items-end gap-12 px-4 pb-14 pt-16 sm:px-6 sm:pb-20 sm:pt-24 lg:grid-cols-[1fr_auto] lg:px-8">
          <div className="max-w-3xl">
            <div className="mb-5 inline-flex items-center gap-2 text-[10px] font-bold uppercase tracking-[0.28em] text-[#D8BD96]">
              <Sparkles className="h-4 w-4" />
              The ClothingStore Journal
            </div>
            <h1 className="font-serif text-5xl leading-[0.98] tracking-tight sm:text-7xl">
              Chuyện của
              <span className="block italic text-[#D8BD96]">phong cách.</span>
            </h1>
            <p className="mt-6 max-w-xl text-sm leading-7 text-zinc-300 sm:text-base">
              Góc nhìn về thời trang, chất liệu và những lựa chọn tạo nên dấu ấn riêng — từ chính đội ngũ ClothingStore.
            </p>
          </div>
          <div className="hidden items-center gap-3 border-l border-white/15 pl-8 text-xs text-zinc-300 lg:flex">
            <Newspaper className="h-5 w-5 text-[#D8BD96]" />
            <span>{posts.length} bài viết đã xuất bản</span>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 pt-10 sm:px-6 lg:px-8">
        <div className="mb-8 flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
          <div className="flex flex-wrap gap-2">
            <button
              type="button"
              onClick={() => setActiveCategory('all')}
              className={`rounded-full px-4 py-2 text-[11px] font-bold uppercase tracking-wider transition ${
                activeCategory === 'all'
                  ? 'bg-[#111113] text-[#D8BD96] dark:bg-[#D8BD96] dark:text-[#111113]'
                  : 'border border-black/10 text-zinc-600 hover:border-[#C6A77B] dark:border-white/10 dark:text-zinc-300'
              }`}
            >
              Tất cả
            </button>
            {categories.map((category) => (
              <button
                type="button"
                key={category.id}
                onClick={() => setActiveCategory(category.id)}
                className={`rounded-full px-4 py-2 text-[11px] font-bold uppercase tracking-wider transition ${
                  activeCategory === category.id
                    ? 'bg-[#111113] text-[#D8BD96] dark:bg-[#D8BD96] dark:text-[#111113]'
                    : 'border border-black/10 text-zinc-600 hover:border-[#C6A77B] dark:border-white/10 dark:text-zinc-300'
                }`}
              >
                {category.categoryName}
              </button>
            ))}
          </div>
          <label className="relative block w-full lg:max-w-xs">
            <Search className="absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-zinc-400" />
            <input
              type="search"
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder="Tìm trong bài viết..."
              className="w-full rounded-full border border-black/10 bg-white py-3 pl-11 pr-4 text-xs outline-none transition focus:border-[#C6A77B] dark:border-white/10 dark:bg-white/5"
            />
          </label>
        </div>

        {loading ? (
          <div className="flex min-h-72 items-center justify-center gap-3 text-sm text-zinc-500">
            <Loader2 className="h-5 w-5 animate-spin text-[#C6A77B]" />
            Đang tải bài viết từ cửa hàng...
          </div>
        ) : error ? (
          <div className="rounded-3xl border border-rose-200 bg-rose-50 p-8 text-center dark:border-rose-500/20 dark:bg-rose-500/5">
            <p className="text-sm font-semibold text-rose-700 dark:text-rose-300">{error}</p>
            <button
              type="button"
              onClick={() => {
                setLoading(true);
                setError('');
                loadContent();
              }}
              className="mt-4 rounded-full bg-[#111113] px-5 py-2.5 text-xs font-bold text-[#D8BD96]"
            >
              Thử tải lại
            </button>
          </div>
        ) : filteredPosts.length === 0 ? (
          <div className="rounded-3xl border border-black/10 bg-white/70 px-6 py-20 text-center dark:border-white/10 dark:bg-white/[0.03]">
            <Newspaper className="mx-auto h-9 w-9 text-[#C6A77B]" />
            <h2 className="mt-4 font-serif text-2xl">Chưa có bài viết phù hợp</h2>
            <p className="mt-2 text-sm text-zinc-500 dark:text-zinc-400">
              {posts.length ? 'Hãy đổi từ khóa hoặc chọn danh mục khác.' : 'Các bài viết mới sẽ được cập nhật tại đây.'}
            </p>
          </div>
        ) : (
          <>
            <button
              type="button"
              onClick={() => openPost(featuredPost)}
              className="group grid w-full overflow-hidden rounded-[2rem] bg-[#111113] text-left text-white shadow-xl shadow-black/10 transition hover:shadow-2xl lg:grid-cols-[1.08fr_0.92fr]"
            >
              <div className="relative min-h-64 sm:min-h-96">
                <ArticleImage post={featuredPost} className="absolute inset-0 h-full w-full" />
                <span className="absolute left-5 top-5 rounded-full border border-white/30 bg-black/30 px-3 py-1.5 text-[9px] font-bold uppercase tracking-[0.2em] backdrop-blur-md">
                  Bài viết nổi bật
                </span>
              </div>
              <div className="flex flex-col justify-center p-7 sm:p-11 lg:p-14">
                <span className="text-[10px] font-bold uppercase tracking-[0.22em] text-[#D8BD96]">
                  {featuredPost.postCategoryName || 'Tạp chí'}
                </span>
                <h2 className="mt-4 font-serif text-3xl leading-tight sm:text-4xl">{featuredPost.title}</h2>
                <p className="mt-4 line-clamp-3 text-sm leading-7 text-zinc-300">{getExcerpt(featuredPost.content)}</p>
                <span className="mt-8 inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-[#D8BD96]">
                  Đọc câu chuyện <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
                </span>
              </div>
            </button>

            {remainingPosts.length > 0 && (
              <div className="mt-12">
                <div className="mb-6 flex items-end justify-between border-b border-black/10 pb-4 dark:border-white/10">
                  <div>
                    <p className="text-[10px] font-bold uppercase tracking-[0.24em] text-[#A98758]">Từ tạp chí</p>
                    <h2 className="mt-1 font-serif text-2xl sm:text-3xl">Những câu chuyện mới</h2>
                  </div>
                  <span className="hidden text-xs text-zinc-500 sm:block">{filteredPosts.length} bài viết</span>
                </div>
                <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                  {remainingPosts.map((post) => (
                    <button
                      type="button"
                      key={post.id}
                      onClick={() => openPost(post)}
                      className="group overflow-hidden rounded-[1.6rem] border border-black/5 bg-white text-left shadow-sm transition hover:-translate-y-1 hover:shadow-xl dark:border-white/10 dark:bg-[#151517]"
                    >
                      <div className="relative aspect-[1.5]">
                        <ArticleImage post={post} className="h-full w-full" />
                        <span className="absolute bottom-4 left-4 rounded-full bg-white/90 px-3 py-1.5 text-[9px] font-bold uppercase tracking-wider text-[#8E7049]">
                          {post.postCategoryName || 'Tạp chí'}
                        </span>
                      </div>
                      <div className="p-5">
                        <div className="flex items-center gap-2 text-[10px] text-zinc-500 dark:text-zinc-400">
                          <CalendarDays className="h-3.5 w-3.5 text-[#B59363]" />
                          {formatDate(post.publishedAt)}
                          <Clock3 className="ml-1 h-3.5 w-3.5 text-[#B59363]" />
                          <span>{getReadTime(post.content)} phút đọc</span>
                        </div>
                        <h3 className="mt-3 line-clamp-2 font-serif text-xl leading-snug">{post.title}</h3>
                        <p className="mt-2 line-clamp-3 text-xs leading-6 text-zinc-500 dark:text-zinc-400">
                          {getExcerpt(post.content)}
                        </p>
                        <span className="mt-4 inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-wider text-[#A98758]">
                          Khám phá <ArrowRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-1" />
                        </span>
                      </div>
                    </button>
                  ))}
                </div>
              </div>
            )}
          </>
        )}
      </section>
    </div>
  );
};
