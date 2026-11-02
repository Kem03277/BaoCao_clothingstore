import React, { useState, useEffect } from 'react';
import {
  ShoppingBag, User, Shield, LogOut,
  Heart, Package, ChevronDown,
  Sparkles, ArrowRight, Sun, Moon
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';
import { useWishlist } from '../context/WishlistContext';
import { useTheme } from '../context/ThemeContext';

export const Navbar = ({ currentView, setCurrentView, onOpenApiTester, onSelectCategory }) => {
  const { user, isAuthenticated, hasManagementAccess, logout } = useAuth();
  const { itemCount, setIsCartOpen } = useCart();
  const { wishlistCount } = useWishlist();
  const { isDark, toggleTheme } = useTheme();
  
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [collectionsDropdownOpen, setCollectionsDropdownOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);
  const [scrollProgress, setScrollProgress] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 20);
      const totalScroll = document.documentElement.scrollHeight - window.innerHeight;
      if (totalScroll > 0) {
        setScrollProgress(window.scrollY / totalScroll);
      }
    };
    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <>
      <header
        className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${
          isScrolled
            ? 'bg-[#FAF9F6]/90 dark:bg-[#0B0B0D]/90 backdrop-blur-md py-3 shadow-xl dark:shadow-2xl border-b border-black/5 dark:border-white/10'
            : currentView === 'home'
              ? 'bg-transparent py-5 border-b border-black/5 dark:border-white/10'
              : 'bg-[#FAF9F6] dark:bg-[#0B0B0D] py-4 border-b border-black/5 dark:border-white/10'
        }`}
      >
        {/* Subtle Luxury Champagne Gold Scroll Progress Indicator */}
        <div
          className="absolute top-0 left-0 right-0 h-[2px] bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] origin-left pointer-events-none transition-transform duration-75"
          style={{ transform: `scaleX(${scrollProgress})` }}
        />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between gap-6">
            
            {/* Brand Logo */}
            <button
              onClick={() => {
                setCurrentView('home');
                window.scrollTo({ top: 0, behavior: 'smooth' });
              }}
              className="flex items-center gap-2.5 text-left group cursor-pointer focus:outline-none"
            >
              <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-[#C6A77B] to-[#E5D2B8] flex items-center justify-center text-[#0B0B0D] shadow-md group-hover:scale-105 transition-transform duration-300">
                <Sparkles className="w-4 h-4 fill-current" />
              </div>
              <div className="flex flex-col">
                <span className="font-serif text-lg sm:text-xl tracking-[0.2em] font-light text-[#0B0B0D] dark:text-white leading-none">
                  CLOTHING<span className="font-extrabold text-[#C6A77B]">STORE</span>
                </span>
                <span className="text-[8px] tracking-[0.35em] text-zinc-500 dark:text-zinc-400 uppercase font-sans mt-0.5">
                  Haute Couture
                </span>
              </div>
            </button>

            {/* Desktop Navigation */}
            <nav className="hidden lg:flex items-center gap-5 xl:gap-7 text-[11px] xl:text-xs font-semibold tracking-[0.04em] text-zinc-600 dark:text-zinc-300 whitespace-nowrap shrink-0">
              <button
                onClick={() => {
                  setCurrentView('home');
                  window.scrollTo({ top: 0, behavior: 'smooth' });
                }}
                className={`transition-colors duration-200 cursor-pointer relative py-2 group whitespace-nowrap ${
                  currentView === 'home'
                    ? 'text-[#0B0B0D] dark:text-white'
                    : 'text-zinc-600 dark:text-zinc-300 hover:text-[#9A7546] dark:hover:text-[#E2CEAE]'
                }`}
                aria-current={currentView === 'home' ? 'page' : undefined}
              >
                <span className="whitespace-nowrap">Trang chủ</span>
                <span
                  className={`absolute bottom-0 left-0 h-0.5 rounded-full bg-[#C6A77B] transition-all duration-300 ${
                    currentView === 'home' ? 'w-full' : 'w-0 group-hover:w-full'
                  }`}
                />
              </button>

              <button
                onClick={() => setCurrentView('shop')}
                className={`transition-colors duration-200 cursor-pointer relative py-2 group whitespace-nowrap ${
                  currentView === 'shop'
                    ? 'text-[#0B0B0D] dark:text-white'
                    : 'text-zinc-600 dark:text-zinc-300 hover:text-[#9A7546] dark:hover:text-[#E2CEAE]'
                }`}
                aria-current={currentView === 'shop' ? 'page' : undefined}
              >
                <span className="whitespace-nowrap">Sản phẩm</span>
                <span
                  className={`absolute bottom-0 left-0 h-0.5 rounded-full bg-[#C6A77B] transition-all duration-300 ${
                    currentView === 'shop' ? 'w-full' : 'w-0 group-hover:w-full'
                  }`}
                />
              </button>

              <button
                onClick={() => setCurrentView('posts')}
                className={`transition-colors duration-200 cursor-pointer relative py-2 group whitespace-nowrap ${
                  currentView === 'posts'
                    ? 'text-[#0B0B0D] dark:text-white'
                    : 'text-zinc-600 dark:text-zinc-300 hover:text-[#9A7546] dark:hover:text-[#E2CEAE]'
                }`}
                aria-current={currentView === 'posts' ? 'page' : undefined}
              >
                <span className="whitespace-nowrap">Bài viết</span>
                <span
                  className={`absolute bottom-0 left-0 h-0.5 rounded-full bg-[#C6A77B] transition-all duration-300 ${
                    currentView === 'posts' ? 'w-full' : 'w-0 group-hover:w-full'
                  }`}
                />
              </button>

              <button
                onClick={() => {
                  setCurrentView('home');
                  setTimeout(() => {
                    document.getElementById('categories-section')?.scrollIntoView({ behavior: 'smooth' });
                  }, 120);
                }}
                className="hover:text-[#9A7546] dark:hover:text-[#E2CEAE] transition-colors duration-200 cursor-pointer relative py-2 group text-zinc-600 dark:text-zinc-300 whitespace-nowrap"
              >
                <span className="whitespace-nowrap">Danh mục</span>
                <span className="absolute bottom-0 left-0 w-0 h-0.5 rounded-full bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>

              <button
                onClick={() => {
                  setCurrentView('home');
                  setTimeout(() => {
                    document.getElementById('brand-story-section')?.scrollIntoView({ behavior: 'smooth' });
                  }, 120);
                }}
                className="hover:text-[#9A7546] dark:hover:text-[#E2CEAE] transition-colors duration-200 cursor-pointer relative py-2 group text-zinc-600 dark:text-zinc-300 whitespace-nowrap"
              >
                <span className="whitespace-nowrap">Thương hiệu</span>
                <span className="absolute bottom-0 left-0 w-0 h-0.5 rounded-full bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>

              <button
                onClick={() => {
                  setCurrentView('home');
                  setTimeout(() => {
                    document.getElementById('showroom-3d')?.scrollIntoView({ behavior: 'smooth' });
                  }, 120);
                }}
                className="text-[#A88452] dark:text-[#D8BB91] hover:text-[#0B0B0D] dark:hover:text-white transition-colors duration-200 cursor-pointer flex items-center gap-1.5 py-2 group relative whitespace-nowrap"
              >
                <Sparkles className="w-3 h-3 text-[#C6A77B] shrink-0" />
                <span className="whitespace-nowrap">Atelier 3D</span>
                <span className="absolute bottom-0 left-0 w-0 h-0.5 rounded-full bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>
            </nav>

            {/* Actions: Search, Wishlist, Cart, User */}
            <div className="flex items-center gap-2 sm:gap-3">
              {/* Wishlist */}
              <button
                onClick={() => setCurrentView('wishlist')}
                className={`relative p-2 rounded-full transition cursor-pointer ${
                  currentView === 'wishlist'
                    ? 'text-[#C6A77B] bg-black/5 dark:bg-white/10'
                    : 'text-zinc-600 hover:text-black dark:text-zinc-300 dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/5'
                }`}
                title="Danh sách yêu thích"
              >
                <Heart className="w-4 h-4" />
                {wishlistCount > 0 && (
                  <span className="absolute -top-1 -right-1 w-4 h-4 rounded-full bg-rose-500 text-[10px] font-bold text-white flex items-center justify-center">
                    {wishlistCount}
                  </span>
                )}
              </button>

              {/* Cart Button */}
              <button
                onClick={() => setIsCartOpen(true)}
                className="relative p-2 rounded-full text-zinc-600 hover:text-black dark:text-zinc-300 dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/5 transition cursor-pointer"
                title="Giỏ hàng"
              >
                <ShoppingBag className="w-4 h-4" />
                {itemCount > 0 && (
                  <span className="absolute -top-1 -right-1 w-4 h-4 rounded-full bg-[#C6A77B] text-[10px] font-bold text-[#0B0B0D] flex items-center justify-center shadow-md">
                    {itemCount}
                  </span>
                )}
              </button>

              {/* Theme Toggle Button (Light / Dark) */}
              <button
                onClick={toggleTheme}
                className="relative p-2 rounded-full text-zinc-600 hover:text-black dark:text-zinc-300 dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/10 transition group cursor-pointer focus:outline-none"
                title={isDark ? 'Giao diện tối (Nhấn để đổi sang sáng)' : 'Giao diện sáng (Nhấn để đổi sang tối)'}
                aria-label="Đổi giao diện sáng/tối"
              >
                {isDark ? (
                  <Moon className="w-4 h-4 text-[#C6A77B] group-hover:-rotate-12 group-hover:scale-110 transition-transform duration-300" />
                ) : (
                  <Sun className="w-4 h-4 text-amber-500 group-hover:rotate-45 group-hover:scale-110 transition-transform duration-300" />
                )}
              </button>

              {/* User / Auth */}
              {isAuthenticated ? (
                <div className="relative">
                  <button
                    onClick={() => setUserDropdownOpen(!userDropdownOpen)}
                    className="flex items-center gap-2 p-1.5 rounded-full hover:bg-white/10 transition"
                  >
                    {user?.avatarUrl ? (
                      <img
                        src={user.avatarUrl}
                        alt={user.fullName}
                        className="w-7 h-7 rounded-full object-cover ring-1 ring-[#C6A77B]"
                      />
                    ) : (
                      <div className="w-7 h-7 rounded-full bg-[#C6A77B] text-[#0B0B0D] font-extrabold text-xs flex items-center justify-center">
                        {user?.fullName?.charAt(0) || 'U'}
                      </div>
                    )}
                    <span className="hidden xl:inline select-none text-sm font-bold text-white">
                      {user?.fullName?.split(' ').slice(-1)[0] || 'Tài khoản'}
                    </span>
                  </button>

                  {userDropdownOpen && (
                    <>
                      <div
                        className="fixed inset-0 z-40"
                        onClick={() => setUserDropdownOpen(false)}
                      />
                      <div className="absolute right-0 top-full mt-2 w-60 rounded-2xl bg-[#141416] border border-white/10 shadow-2xl p-2 z-50">
                        <div className="px-3 py-2.5 border-b border-white/5 mb-1">
                          <p className="text-xs font-semibold text-white truncate">{user?.fullName}</p>
                          <p className="text-[11px] text-zinc-400 truncate">{user?.email}</p>
                        </div>

                        <button
                          onClick={() => {
                            setCurrentView('profile');
                            setUserDropdownOpen(false);
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-300 hover:text-white hover:bg-white/5 transition"
                        >
                          <User className="w-3.5 h-3.5 text-[#C6A77B]" />
                          Tài khoản của tôi
                        </button>
                        <button
                          onClick={() => {
                            setCurrentView('orders');
                            setUserDropdownOpen(false);
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-300 hover:text-white hover:bg-white/5 transition"
                        >
                          <Package className="w-3.5 h-3.5 text-[#C6A77B]" />
                          Đơn hàng đã đặt
                        </button>
                        <button
                          onClick={() => {
                            setCurrentView('wishlist');
                            setUserDropdownOpen(false);
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-300 hover:text-white hover:bg-white/5 transition"
                        >
                          <Heart className="w-3.5 h-3.5 text-rose-400" />
                          Sản phẩm yêu thích
                        </button>
                        {hasManagementAccess && (
                          <button
                            onClick={() => {
                              setCurrentView('admin');
                              setUserDropdownOpen(false);
                            }}
                            className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-[#C6A77B] hover:bg-white/5 transition font-medium"
                          >
                            <Shield className="w-3.5 h-3.5" />
                            Trang quản trị Admin
                          </button>
                        )}

                        <div className="my-1 border-t border-white/5" />

                        <button
                          onClick={() => {
                            logout();
                            setUserDropdownOpen(false);
                            setCurrentView('home');
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-rose-400 hover:bg-rose-500/10 transition font-medium"
                        >
                          <LogOut className="w-3.5 h-3.5" />
                          Đăng xuất
                        </button>
                      </div>
                    </>
                  )}
                </div>
              ) : (
                <button
                  onClick={() => setCurrentView('login')}
                  className="px-4 py-1.5 rounded-full bg-gradient-to-r from-[#C6A77B] to-[#DFCA9B] hover:opacity-95 text-[#0B0B0D] font-bold text-xs uppercase tracking-wider transition shadow-md"
                >
                  Đăng nhập
                </button>
              )}

            </div>
          </div>
        </div>
      </header>
    </>
  );
};
