import React, { useState, useEffect, useRef } from 'react';
import { gsap } from '../../lib/gsap';
import {
  ShoppingBag, Heart, Sparkles,
  Sun, Moon, User, Package, Shield, LogOut,
} from 'lucide-react';
import { useCart } from '../../context/CartContext';
import { useWishlist } from '../../context/WishlistContext';
import { useTheme } from '../../context/ThemeContext';
import { useAuth } from '../../context/AuthContext';

export const Header = ({
  onNavigateShop,
  onNavigateLogin,
  onNavigateProfile,
  onNavigateOrders,
  onNavigateAdmin,
}) => {
  const { user, isAuthenticated, hasManagementAccess, logout } = useAuth();
  const { itemCount, setIsCartOpen } = useCart();
  const { wishlistCount } = useWishlist();
  const { isDark, toggleTheme } = useTheme();

  const headerRef = useRef(null);
  const lastScrollY = useRef(0);

  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);

  // Scroll direction detection (hide on scroll down, show on scroll up)
  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      setIsScrolled(currentScrollY > 40);

      if (currentScrollY > 120) {
        if (currentScrollY > lastScrollY.current) {
          // Scrolling down: hide header
          gsap.to(headerRef.current, { yPercent: -100, duration: 0.35, ease: 'power2.out' });
        } else {
          // Scrolling up: reveal header
          gsap.to(headerRef.current, { yPercent: 0, duration: 0.35, ease: 'power2.out' });
        }
      } else {
        gsap.to(headerRef.current, { yPercent: 0, duration: 0.35, ease: 'power2.out' });
      }

      lastScrollY.current = currentScrollY;
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <>
      <header
        ref={headerRef}
        className={`fixed top-0 left-0 right-0 z-50 transition-colors duration-500 ${
          isScrolled
            ? 'bg-[#FAF9F6]/90 dark:bg-[#09090B]/90 backdrop-blur-md border-b border-black/5 dark:border-white/10 py-3.5 shadow-xl dark:shadow-2xl'
            : 'bg-transparent py-5 border-b border-black/5 dark:border-white/10'
        }`}
      >
        <div className="mx-auto w-full max-w-[1440px] px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between gap-2 sm:gap-4 lg:gap-6">
            
            {/* Brand Logo */}
            <button
              onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
              className="group flex shrink-0 cursor-pointer items-center gap-3 text-left focus:outline-none sm:gap-3.5"
            >
              <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-tr from-[#C6A77B] to-[#E5D2B8] text-[#0B0B0D] shadow-md transition-transform duration-300 group-hover:scale-105 sm:h-10 sm:w-10">
                <Sparkles className="h-4 w-4 fill-current sm:h-5 sm:w-5" />
              </div>
              <div className="flex flex-col">
                <span className="whitespace-nowrap font-serif text-lg font-light leading-none tracking-[0.16em] text-[#0B0B0D] dark:text-white sm:text-xl sm:tracking-[0.2em] xl:text-2xl">
                  CLOTHING<span className="font-extrabold text-[#C6A77B]">STORE</span>
                </span>
                <span className="mt-1 font-sans text-[8px] uppercase tracking-[0.4em] text-zinc-500 dark:text-zinc-400 sm:text-[9px]">
                  Haute Couture
                </span>
              </div>
            </button>

            {/* Desktop Quick Nav */}
            <nav className="hidden lg:flex items-center gap-3 xl:gap-5 text-xs uppercase tracking-[0.08em] font-medium text-zinc-600 dark:text-zinc-300 whitespace-nowrap shrink-0">
              <button
                onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer relative py-1 group whitespace-nowrap"
              >
                <span className="whitespace-nowrap">Trang chủ</span>
                <span className="absolute bottom-0 left-0 w-full h-[1.5px] bg-[#C6A77B]" />
              </button>
              <button
                onClick={() => onNavigateShop?.()}
                className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer relative py-1 group whitespace-nowrap"
              >
                <span className="whitespace-nowrap">Sản phẩm</span>
                <span className="absolute bottom-0 left-0 w-0 h-[1.5px] bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>
              <button
                onClick={() => document.getElementById('categories-section')?.scrollIntoView({ behavior: 'smooth' })}
                className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer relative py-1 group whitespace-nowrap"
              >
                <span className="whitespace-nowrap">Danh mục</span>
                <span className="absolute bottom-0 left-0 w-0 h-[1.5px] bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>
              <button
                onClick={() => document.getElementById('brand-story-section')?.scrollIntoView({ behavior: 'smooth' })}
                className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer relative py-1 group whitespace-nowrap"
              >
                <span className="whitespace-nowrap">Thương hiệu</span>
                <span className="absolute bottom-0 left-0 w-0 h-[1.5px] bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>
              <button
                onClick={() => document.getElementById('showroom-3d')?.scrollIntoView({ behavior: 'smooth' })}
                className="text-[#C6A77B] hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer flex items-center gap-1.5 py-1 group relative whitespace-nowrap"
              >
                <Sparkles className="w-3 h-3 text-[#C6A77B] shrink-0" />
                <span className="whitespace-nowrap">Atelier 3D</span>
                <span className="absolute bottom-0 left-0 w-0 h-[1.5px] bg-[#C6A77B] group-hover:w-full transition-all duration-300" />
              </button>
            </nav>

            {/* Right Action Icons */}
            <div className="flex items-center gap-1.5 sm:gap-2.5 text-[#0B0B0D] dark:text-white">
              {/* Wishlist */}
              <button
                onClick={() => onNavigateShop?.()}
                className="relative p-2 rounded-full text-zinc-600 dark:text-zinc-300 hover:text-[#0B0B0D] dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/10 transition cursor-pointer"
                title="Yêu thích"
              >
                <Heart className="w-4 h-4" />
                {wishlistCount > 0 && (
                  <span className="absolute -top-0.5 -right-0.5 w-4 h-4 rounded-full bg-rose-500 text-[10px] font-bold text-white flex items-center justify-center animate-bounce">
                    {wishlistCount}
                  </span>
                )}
              </button>

              {/* Cart Drawer Trigger */}
              <button
                onClick={() => setIsCartOpen?.(true)}
                className="relative p-2 rounded-full text-zinc-600 dark:text-zinc-300 hover:text-[#0B0B0D] dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/10 transition cursor-pointer"
                title="Giỏ hàng"
              >
                <ShoppingBag className="w-4 h-4" />
                {itemCount > 0 && (
                  <span className="absolute -top-0.5 -right-0.5 w-4 h-4 rounded-full bg-[#C6A77B] text-[10px] font-bold text-[#0B0B0D] flex items-center justify-center animate-pulse">
                    {itemCount}
                  </span>
                )}
              </button>

              {/* Theme Toggle */}
              <button
                onClick={toggleTheme}
                className="p-2 rounded-full text-zinc-600 dark:text-zinc-300 hover:text-[#0B0B0D] dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/10 transition cursor-pointer"
                title={isDark ? "Giao diện tối (Nhấn để đổi sang sáng)" : "Giao diện sáng (Nhấn để đổi sang tối)"}
              >
                {isDark ? <Moon className="w-4 h-4 text-[#C6A77B]" /> : <Sun className="w-4 h-4 text-amber-500 hover:text-amber-600" />}
              </button>

              {/* User Auth: Login Button OR User Profile Menu */}
              {isAuthenticated ? (
                <div className="relative">
                  <button
                    onClick={() => setUserDropdownOpen(!userDropdownOpen)}
                    className="flex items-center gap-1.5 p-1 rounded-full hover:bg-black/5 dark:hover:bg-white/10 transition cursor-pointer"
                    title={user?.fullName || 'Tài khoản'}
                  >
                    {user?.avatarUrl ? (
                      <img
                        src={user.avatarUrl}
                        alt={user.fullName}
                        className="w-7 h-7 rounded-full object-cover ring-1 ring-[#C6A77B]"
                      />
                    ) : (
                      <div className="w-7 h-7 rounded-full bg-gradient-to-tr from-[#C6A77B] to-[#E2CEAE] text-[#0B0B0D] font-bold text-xs flex items-center justify-center shadow-xs">
                        {user?.fullName?.charAt(0) || 'U'}
                      </div>
                    )}
                    <span className="hidden xl:inline text-xs font-semibold text-[#0B0B0D] dark:text-zinc-200">
                      {user?.fullName?.split(' ').slice(-1)[0] || 'Tài khoản'}
                    </span>
                  </button>

                  {userDropdownOpen && (
                    <>
                      <div
                        className="fixed inset-0 z-40"
                        onClick={() => setUserDropdownOpen(false)}
                      />
                      <div className="absolute right-0 top-full mt-2 w-60 rounded-2xl bg-white dark:bg-[#141416] border border-black/10 dark:border-white/10 shadow-2xl p-2 z-50 animate-in fade-in slide-in-from-top-2 duration-200">
                        <div className="px-3 py-2.5 border-b border-black/5 dark:border-white/5 mb-1">
                          <p className="text-xs font-bold text-[#0B0B0D] dark:text-white truncate">{user?.fullName}</p>
                          <p className="text-[11px] text-zinc-500 dark:text-zinc-400 truncate">{user?.email}</p>
                        </div>

                        <button
                          onClick={() => {
                            onNavigateProfile?.();
                            setUserDropdownOpen(false);
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-700 dark:text-zinc-300 hover:text-black dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/5 transition cursor-pointer"
                        >
                          <User className="w-3.5 h-3.5 text-[#C6A77B]" />
                          <span>Tài khoản của tôi</span>
                        </button>

                        <button
                          onClick={() => {
                            onNavigateOrders?.();
                            setUserDropdownOpen(false);
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-700 dark:text-zinc-300 hover:text-black dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/5 transition cursor-pointer"
                        >
                          <Package className="w-3.5 h-3.5 text-[#C6A77B]" />
                          <span>Đơn hàng đã đặt</span>
                        </button>

                        {hasManagementAccess && (
                          <button
                            onClick={() => {
                              onNavigateAdmin?.();
                              setUserDropdownOpen(false);
                            }}
                            className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-[#C6A77B] hover:bg-black/5 dark:hover:bg-white/5 transition font-medium cursor-pointer"
                          >
                            <Shield className="w-3.5 h-3.5" />
                            <span>Trang quản trị Admin</span>
                          </button>
                        )}

                        <div className="my-1 border-t border-black/5 dark:border-white/5" />

                        <button
                          onClick={() => {
                            logout();
                            setUserDropdownOpen(false);
                          }}
                          className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-rose-500 hover:bg-rose-500/10 transition font-medium cursor-pointer"
                        >
                          <LogOut className="w-3.5 h-3.5" />
                          <span>Đăng xuất</span>
                        </button>
                      </div>
                    </>
                  )}
                </div>
              ) : (
                <button
                  onClick={onNavigateLogin}
                  className="shrink-0 whitespace-nowrap px-3.5 sm:px-4 py-1.5 rounded-full bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] hover:opacity-95 text-[#0B0B0D] font-bold text-xs uppercase tracking-wider transition-all duration-300 shadow-md flex items-center gap-1.5 cursor-pointer ml-1"
                  title="Đăng nhập tài khoản"
                >
                  <User className="w-3.5 h-3.5" />
                  <span className="hidden whitespace-nowrap sm:inline">Đăng nhập</span>
                </button>
              )}

            </div>

          </div>
        </div>

      </header>

    </>
  );
};
