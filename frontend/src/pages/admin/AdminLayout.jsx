import React, { useState } from 'react';
import {
  LayoutDashboard,
  Package,
  Tags,
  ShoppingBag,
  FileText,
  Tag,
  Users,
  Boxes,
  LogOut,
  Shield,
  Menu,
  X,
  KeyRound,
  CheckCircle,
  AlertCircle,
  Loader2,
  ChevronDown,
  Sparkles,
  Eye,
  EyeOff,
  Store,
  Sun,
  Moon,
  Camera,
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../context/ThemeContext';
import { authApi } from '../../api';
import { AdminNotificationProvider } from '../../context/AdminNotificationContext';
import { DashboardView } from './DashboardView';
import { ProductAdminView } from './ProductAdminView';
import { PostAdminView } from './PostAdminView';
import { CategoryBrandAdminView } from './CategoryBrandAdminView';
import { OrderAdminView } from './OrderAdminView';
import { CouponAdminView } from './CouponAdminView';
import { UserAdminView } from './UserAdminView';
import { InventoryAdminView } from './InventoryAdminView';

export const AdminLayout = ({ onNavigateStore }) => {
  const { user, setUser, logout, changeAdminPassword } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const [currentTab, setCurrentTab] = useState(() => {
    const savedTab = sessionStorage.getItem('clothingstore.adminTab');
    const validTabs = ['dashboard', 'products', 'posts', 'categories-brands', 'orders', 'coupons', 'inventory', 'users'];
    return validTabs.includes(savedTab) ? savedTab : 'dashboard';
  });
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const [avatarUploading, setAvatarUploading] = useState(false);
  const [avatarMessage, setAvatarMessage] = useState('');

  // Logout confirm modal
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);

  // Change password modal
  const [showChangePassword, setShowChangePassword] = useState(false);
  const [passwordForm, setPasswordForm] = useState({ currentPassword: '', newPassword: '', confirmPassword: '' });
  const [visiblePasswords, setVisiblePasswords] = useState({ current: false, new: false, confirm: false });
  const [passwordSubmitting, setPasswordSubmitting] = useState(false);
  const [passwordMessage, setPasswordMessage] = useState(null);

  const menuItems = [
    { id: 'dashboard', label: 'Tổng quan & Doanh số', icon: LayoutDashboard },
    { id: 'products', label: 'Quản lý Sản phẩm', icon: Package },
    { id: 'posts', label: 'Quản lý Bài viết', icon: FileText },
    { id: 'categories-brands', label: 'Danh mục & Thương hiệu', icon: Tags },
    { id: 'orders', label: 'Quản lý Đơn hàng', icon: ShoppingBag },
    { id: 'coupons', label: 'Chiến dịch Khuyến mãi', icon: Tag },
    { id: 'inventory', label: 'Kho hàng & Nhập xuất', icon: Boxes },
    { id: 'users', label: 'Quản lý Khách hàng', icon: Users },
  ];

  const handleConfirmLogout = () => {
    setShowLogoutConfirm(false);
    logout('Bạn đã đăng xuất khỏi hệ thống thành công.');
  };

  const handleBackToStore = () => {
    if (onNavigateStore) {
      onNavigateStore();
    } else {
      window.location.href = '/';
    }
  };

  const handleAdminAvatarChange = async (event) => {
    const file = event.target.files?.[0];
    event.target.value = '';
    if (!file) return;
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
      setAvatarMessage('Chọn ảnh JPG, PNG hoặc WebP.');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setAvatarMessage('Ảnh đại diện không được vượt quá 5 MB.');
      return;
    }

    setAvatarUploading(true);
    setAvatarMessage('');
    try {
      const updatedUser = await authApi.updateOwnAvatar(file);
      setUser(updatedUser);
      localStorage.setItem('user', JSON.stringify(updatedUser));
      setAvatarMessage('Đã cập nhật ảnh đại diện.');
    } catch (error) {
      setAvatarMessage(`Không thể cập nhật ảnh: ${error.message || 'Vui lòng thử lại.'}`);
    } finally {
      setAvatarUploading(false);
    }
  };

  const handleChangePasswordSubmit = async (e) => {
    e.preventDefault();
    setPasswordMessage(null);

    if (passwordForm.newPassword.length < 6) {
      setPasswordMessage({ type: 'error', text: 'Mật khẩu mới phải có ít nhất 6 ký tự.' });
      return;
    }

    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
      setPasswordMessage({ type: 'error', text: 'Mật khẩu xác nhận không khớp.' });
      return;
    }

    setPasswordSubmitting(true);
    const res = await changeAdminPassword(passwordForm.currentPassword, passwordForm.newPassword);
    setPasswordSubmitting(false);

    if (res.success) {
      setPasswordMessage({ type: 'success', text: 'Đổi mật khẩu thành công! Hãy ghi nhớ mật khẩu mới.' });
      setTimeout(() => {
        setShowChangePassword(false);
        setPasswordForm({ currentPassword: '', newPassword: '', confirmPassword: '' });
        setPasswordMessage(null);
      }, 2000);
    } else {
      setPasswordMessage({ type: 'error', text: res.message || 'Mật khẩu hiện tại không đúng.' });
    }
  };

  const currentTabObj = menuItems.find((m) => m.id === currentTab) || menuItems[0];

  React.useEffect(() => {
    sessionStorage.setItem('clothingstore.adminTab', currentTab);
  }, [currentTab]);

  return (
    <AdminNotificationProvider>
      <div className="min-h-screen bg-[#F8F7F4] dark:bg-[#0B0B0D] flex flex-col md:flex-row text-[#0B0B0D] dark:text-[#F8F7F4] font-sans antialiased selection:bg-[#C6A77B] selection:text-[#0B0B0D] transition-colors duration-300">
      
      {/* ── 1. LUXURY OBSIDIAN ATELIER SIDEBAR ── */}
      <aside
        className={`fixed inset-y-0 left-0 z-40 flex h-screen w-72 flex-col overflow-hidden border-r border-white/10 bg-[#0B0B0D] text-zinc-300 transition-transform duration-300 ease-in-out md:sticky md:top-0 md:translate-x-0 ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex min-h-0 flex-1 flex-col">
          {/* Logo & Header */}
          <div className="h-20 shrink-0 px-6 flex items-center justify-between border-b border-white/10">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] flex items-center justify-center text-[#0B0B0D] shadow-lg shadow-[#C6A77B]/20">
                <Sparkles className="w-5 h-5 fill-current" />
              </div>
              <div>
                <span className="font-display font-extrabold text-base text-white tracking-[0.18em]">
                  CLOTHING<span className="text-[#C6A77B]">ATELIER</span>
                </span>
                <span className="block text-[9px] uppercase tracking-[0.25em] font-bold text-[#C6A77B]/80 font-mono">
                  Admin Suite · 2026
                </span>
              </div>
            </div>
            <button
              onClick={() => setSidebarOpen(false)}
              className="md:hidden p-1.5 rounded-xl text-zinc-400 hover:text-white hover:bg-white/5 transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Navigation Links */}
          <nav className="min-h-0 flex-1 overflow-y-auto p-4 space-y-1.5">
            <p className="px-3 text-[10px] font-bold uppercase tracking-[0.2em] text-[#C6A77B]/70 mb-3">
              Quản trị chuyên môn
            </p>
            {menuItems.map((item) => {
              const Icon = item.icon;
              const isActive = currentTab === item.id;

              return (
                <button
                  key={item.id}
                  onClick={() => {
                    setCurrentTab(item.id);
                    setSidebarOpen(false);
                  }}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-xs font-semibold transition-all duration-200 cursor-pointer ${
                    isActive
                      ? 'bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] font-extrabold shadow-lg shadow-[#C6A77B]/25 scale-[1.01]'
                      : 'hover:bg-white/5 hover:text-white text-zinc-400'
                  }`}
                >
                  <Icon className={`w-4 h-4 shrink-0 ${isActive ? 'text-[#0B0B0D]' : 'text-zinc-400'}`} />
                  <span className="truncate">{item.label}</span>
                </button>
              );
            })}
          </nav>
        </div>

        {/* Sidebar Footer Controls */}
        <div className="shrink-0 p-4 border-t border-white/10 space-y-3 bg-black/30">
          {/* User profile & Logout */}
          <div className="flex items-center justify-between pt-2 border-t border-white/5">
            <div className="flex items-center gap-2.5 min-w-0">
              <label
                title="Đổi ảnh đại diện"
                className={`group relative h-9 w-9 shrink-0 cursor-pointer overflow-hidden rounded-xl bg-gradient-to-br from-[#C6A77B] to-[#B59363] text-xs font-extrabold text-[#0B0B0D] shadow-sm ${
                  avatarUploading ? 'pointer-events-none' : ''
                }`}
              >
                {user?.avatarUrl ? (
                  <img src={user.avatarUrl} alt="Ảnh đại diện quản trị viên" className="h-full w-full object-cover" />
                ) : (
                  <span className="flex h-full w-full items-center justify-center">
                    {user?.fullName?.charAt(0) || 'A'}
                  </span>
                )}
                <span className="absolute inset-0 flex items-center justify-center bg-black/55 text-white opacity-0 transition group-hover:opacity-100">
                  {avatarUploading
                    ? <Loader2 className="h-4 w-4 animate-spin" />
                    : <Camera className="h-4 w-4" />}
                </span>
                <input
                  type="file"
                  accept="image/jpeg,image/png,image/webp"
                  onChange={handleAdminAvatarChange}
                  disabled={avatarUploading}
                  className="hidden"
                />
              </label>
              <div className="min-w-0">
                <p className="text-xs font-bold text-white truncate">{user?.fullName || 'Quản trị viên'}</p>
                <p className="text-[10px] text-zinc-400 font-mono truncate">{user?.email || 'admin@clothingstore.com'}</p>
              </div>
            </div>

            <button
              onClick={() => setShowLogoutConfirm(true)}
              title="Đăng xuất khỏi hệ thống"
              className="p-2 rounded-xl text-zinc-400 hover:text-rose-400 hover:bg-white/5 transition cursor-pointer"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* ── 2. MAIN CONTENT AREA ── */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        
        {/* Luxury Glassmorphic Top Header */}
        <header className="h-20 bg-white/80 dark:bg-[#141416]/80 backdrop-blur-md border-b border-black/5 dark:border-white/10 px-4 sm:px-8 flex items-center justify-between sticky top-0 z-20 transition-colors duration-300">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setSidebarOpen(true)}
              className="md:hidden p-2 rounded-2xl text-zinc-700 dark:text-zinc-200 hover:bg-black/5 dark:hover:bg-white/5 transition"
            >
              <Menu className="w-5 h-5" />
            </button>

            <div>
              <div className="flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B]">
                <span>Atelier Suite</span>
                <span>·</span>
                <span>{currentTabObj.label}</span>
              </div>
              <h1 className="text-lg sm:text-xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4]">
                {currentTabObj.label}
              </h1>
            </div>
          </div>

          <div className="flex items-center gap-3">
            {/* Global Theme Toggle */}
            <button
              onClick={toggleTheme}
              className="p-2.5 rounded-full border border-black/10 dark:border-white/10 bg-white dark:bg-[#1A1A1E] hover:bg-zinc-100 dark:hover:bg-white/10 text-zinc-700 dark:text-zinc-200 transition cursor-pointer"
              title={isDark ? 'Giao diện tối (Nhấn để đổi sang sáng)' : 'Giao diện sáng (Nhấn để đổi sang tối)'}
            >
              {isDark ? (
                <Moon className="w-4 h-4 text-[#C6A77B]" />
              ) : (
                <Sun className="w-4 h-4 text-amber-500 hover:text-amber-600" />
              )}
            </button>

            {/* Quick Storefront Link */}
            <button
              onClick={handleBackToStore}
              className="hidden lg:flex items-center gap-1.5 px-4 py-2 rounded-full border border-black/10 dark:border-white/10 bg-white dark:bg-[#1A1A1E] hover:bg-zinc-50 dark:hover:bg-white/10 text-xs font-bold text-[#0B0B0D] dark:text-[#F8F7F4] transition shadow-xs cursor-pointer"
            >
              <Store className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span>Xem Cửa Hàng</span>
            </button>

            {/* Admin User Dropdown */}
            <div className="relative">
              <button
                onClick={() => setUserMenuOpen(!userMenuOpen)}
                className="flex items-center gap-2.5 p-1.5 pr-3 rounded-full hover:bg-black/5 transition border border-transparent hover:border-black/5 cursor-pointer"
              >
                  <div className="relative h-8 w-8 overflow-hidden rounded-full border border-[#C6A77B]/30 bg-[#0B0B0D] text-xs font-extrabold text-[#C6A77B]">
                    {user?.avatarUrl ? (
                      <img src={user.avatarUrl} alt="" className="h-full w-full object-cover" />
                    ) : (
                      <span className="flex h-full w-full items-center justify-center">
                        {user?.fullName?.charAt(0) || 'A'}
                      </span>
                    )}
                    {avatarUploading && (
                      <span className="absolute inset-0 flex items-center justify-center bg-black/60">
                        <Loader2 className="h-4 w-4 animate-spin text-white" />
                      </span>
                    )}
                  </div>
                <span className="hidden sm:inline text-xs font-bold text-[#0B0B0D]">
                  {user?.fullName || 'Admin'}
                </span>
                <ChevronDown className="w-3.5 h-3.5 text-zinc-400" />
              </button>

              {userMenuOpen && (
                <div className="absolute right-0 mt-2 w-60 rounded-3xl bg-white shadow-2xl border border-black/10 py-3 z-50 text-xs animate-in fade-in zoom-in-95 duration-200">
                  <div className="px-4 py-2 border-b border-black/5">
                    <p className="font-extrabold text-[#0B0B0D] truncate">{user?.fullName}</p>
                    <p className="text-[11px] text-zinc-500 font-mono truncate">{user?.email}</p>
                    <span className="inline-block mt-1 text-[9px] font-bold uppercase tracking-widest px-2.5 py-0.5 rounded-full bg-[#C6A77B]/15 text-[#C6A77B]">
                      {user?.roleCode || 'ADMINISTRATOR'}
                    </span>
                  </div>

                  <label className={`flex w-full cursor-pointer items-center gap-2.5 px-4 py-2.5 font-medium text-zinc-700 transition hover:bg-zinc-50 ${
                    avatarUploading ? 'pointer-events-none opacity-60' : ''
                  }`}>
                    {avatarUploading
                      ? <Loader2 className="h-4 w-4 animate-spin text-[#C6A77B]" />
                      : <Camera className="h-4 w-4 text-[#C6A77B]" />}
                    <span>{avatarUploading ? 'Đang tải ảnh...' : 'Đổi ảnh đại diện'}</span>
                    <input
                      type="file"
                      accept="image/jpeg,image/png,image/webp"
                      onChange={handleAdminAvatarChange}
                      disabled={avatarUploading}
                      className="hidden"
                    />
                  </label>
                  {avatarMessage && (
                    <p className={`px-4 pb-2 text-[10px] ${
                      avatarMessage.startsWith('Đã cập nhật') ? 'text-emerald-700' : 'text-rose-600'
                    }`}>
                      {avatarMessage}
                    </p>
                  )}

                  <button
                    onClick={() => {
                      setUserMenuOpen(false);
                      setShowChangePassword(true);
                    }}
                    className="w-full text-left px-4 py-2.5 hover:bg-zinc-50 text-zinc-700 flex items-center gap-2.5 font-medium transition cursor-pointer"
                  >
                    <KeyRound className="w-4 h-4 text-[#C6A77B]" />
                    <span>Đổi mật khẩu tài khoản</span>
                  </button>

                  <button
                    onClick={() => {
                      setUserMenuOpen(false);
                      handleBackToStore();
                    }}
                    className="w-full text-left px-4 py-2.5 hover:bg-zinc-50 text-zinc-700 flex items-center gap-2.5 font-medium transition cursor-pointer"
                  >
                    <Store className="w-4 h-4 text-[#C6A77B]" />
                    <span>Về trang người dùng</span>
                  </button>

                  <div className="border-t border-black/5 my-1.5"></div>

                  <button
                    onClick={() => {
                      setUserMenuOpen(false);
                      setShowLogoutConfirm(true);
                    }}
                    className="w-full text-left px-4 py-2.5 hover:bg-rose-50 text-rose-600 flex items-center gap-2.5 font-bold transition cursor-pointer"
                  >
                    <LogOut className="w-4 h-4" />
                    <span>Đăng xuất hệ thống</span>
                  </button>
                </div>
              )}
            </div>
          </div>
        </header>

        {/* Dynamic View Body */}
        <main className="flex-1 p-4 sm:p-8 max-w-7xl w-full mx-auto overflow-y-auto">
          {currentTab === 'dashboard' && <DashboardView />}
          {currentTab === 'products' && <ProductAdminView />}
          {currentTab === 'posts' && <PostAdminView />}
          {currentTab === 'categories-brands' && <CategoryBrandAdminView />}
          {currentTab === 'orders' && <OrderAdminView />}
          {currentTab === 'coupons' && <CouponAdminView />}
          {currentTab === 'inventory' && <InventoryAdminView />}
          {currentTab === 'users' && <UserAdminView />}
        </main>
      </div>

      {/* Logout Confirmation Modal */}
      {showLogoutConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div
            className="fixed inset-0"
            onClick={() => setShowLogoutConfirm(false)}
          ></div>
          <div className="relative w-full max-w-sm bg-white rounded-3xl p-7 shadow-2xl space-y-5 text-center z-10 border border-black/10">
            <div className="w-14 h-14 rounded-2xl bg-rose-50 text-rose-600 mx-auto flex items-center justify-center border border-rose-100 shadow-sm">
              <LogOut className="w-6 h-6" />
            </div>
            <div>
              <h3 className="text-lg font-extrabold text-[#0B0B0D] tracking-tight">Xác nhận đăng xuất</h3>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Bạn có chắc chắn muốn kết thúc phiên làm việc quản trị Atelier hiện tại không?
              </p>
            </div>
            <div className="flex gap-3 pt-2">
              <button
                type="button"
                onClick={() => setShowLogoutConfirm(false)}
                className="flex-1 py-3 rounded-full border border-black/10 text-zinc-700 hover:bg-zinc-50 text-xs font-bold uppercase tracking-wider transition cursor-pointer"
              >
                Hủy bỏ
              </button>
              <button
                type="button"
                onClick={handleConfirmLogout}
                className="flex-1 py-3 rounded-full bg-[#0B0B0D] hover:bg-black text-white text-xs font-bold uppercase tracking-wider transition shadow-lg cursor-pointer"
              >
                Đăng xuất
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Change Password Modal */}
      {showChangePassword && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-md bg-white rounded-3xl p-7 shadow-2xl space-y-5 border border-black/10">
            <div className="flex items-center justify-between pb-3 border-b border-black/5">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center">
                  <KeyRound className="w-4 h-4" />
                </div>
                <h3 className="text-base font-extrabold text-[#0B0B0D] tracking-tight">
                  Đổi Mật Khẩu Quản Trị
                </h3>
              </div>
              <button
                onClick={() => setShowChangePassword(false)}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-400 hover:text-zinc-700 transition"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {passwordMessage && (
              <div
                className={`p-3.5 rounded-2xl text-xs flex items-center gap-2.5 ${
                  passwordMessage.type === 'success'
                    ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                    : 'bg-rose-50 text-rose-800 border border-rose-200'
                }`}
              >
                {passwordMessage.type === 'success' ? (
                  <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0" />
                ) : (
                  <AlertCircle className="w-4 h-4 text-rose-600 shrink-0" />
                )}
                <span>{passwordMessage.text}</span>
              </div>
            )}

            <form onSubmit={handleChangePasswordSubmit} className="space-y-4 text-xs">
              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Mật khẩu hiện tại
                </label>
                <div className="relative">
                  <input
                    type={visiblePasswords.current ? 'text' : 'password'}
                    value={passwordForm.currentPassword}
                    onChange={(e) => setPasswordForm({ ...passwordForm, currentPassword: e.target.value })}
                    placeholder="Nhập mật khẩu đang sử dụng"
                    className="w-full px-4 py-2.5 pr-11 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setVisiblePasswords((visible) => ({ ...visible, current: !visible.current }))}
                    className="absolute inset-y-0 right-0 flex items-center px-3 text-zinc-400 hover:text-zinc-700"
                    aria-label={visiblePasswords.current ? 'Ẩn mật khẩu hiện tại' : 'Hiện mật khẩu hiện tại'}
                    title={visiblePasswords.current ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
                  >
                    {visiblePasswords.current ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Mật khẩu mới (tối thiểu 6 ký tự)
                </label>
                <div className="relative">
                  <input
                    type={visiblePasswords.new ? 'text' : 'password'}
                    value={passwordForm.newPassword}
                    onChange={(e) => setPasswordForm({ ...passwordForm, newPassword: e.target.value })}
                    placeholder="Nhập mật khẩu mới"
                    className="w-full px-4 py-2.5 pr-11 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setVisiblePasswords((visible) => ({ ...visible, new: !visible.new }))}
                    className="absolute inset-y-0 right-0 flex items-center px-3 text-zinc-400 hover:text-zinc-700"
                    aria-label={visiblePasswords.new ? 'Ẩn mật khẩu mới' : 'Hiện mật khẩu mới'}
                    title={visiblePasswords.new ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
                  >
                    {visiblePasswords.new ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Xác nhận mật khẩu mới
                </label>
                <div className="relative">
                  <input
                    type={visiblePasswords.confirm ? 'text' : 'password'}
                    value={passwordForm.confirmPassword}
                    onChange={(e) => setPasswordForm({ ...passwordForm, confirmPassword: e.target.value })}
                    placeholder="Nhập lại mật khẩu mới"
                    className="w-full px-4 py-2.5 pr-11 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setVisiblePasswords((visible) => ({ ...visible, confirm: !visible.confirm }))}
                    className="absolute inset-y-0 right-0 flex items-center px-3 text-zinc-400 hover:text-zinc-700"
                    aria-label={visiblePasswords.confirm ? 'Ẩn xác nhận mật khẩu' : 'Hiện xác nhận mật khẩu'}
                    title={visiblePasswords.confirm ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
                  >
                    {visiblePasswords.confirm ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </button>
                </div>
              </div>

              <div className="flex justify-end gap-2.5 pt-4 border-t border-black/5">
                <button
                  type="button"
                  onClick={() => setShowChangePassword(false)}
                  className="px-5 py-2.5 rounded-full border border-black/10 text-zinc-700 hover:bg-zinc-50 font-bold uppercase tracking-wider text-[11px]"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={passwordSubmitting}
                  className="px-6 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-white font-bold uppercase tracking-wider text-[11px] flex items-center gap-2 shadow-lg disabled:opacity-50"
                >
                  {passwordSubmitting && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  <span>{passwordSubmitting ? 'Đang cập nhật...' : 'Đổi mật khẩu'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      </div>
    </AdminNotificationProvider>
  );
};
