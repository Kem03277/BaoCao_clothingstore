import React, { useState, useEffect } from 'react';
import {
  Shield,
  Lock,
  Mail,
  ArrowRight,
  AlertCircle,
  Loader2,
  Sparkles,
  Eye,
  EyeOff,
  CheckCircle,
  Info,
  Store,
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';

export const AdminLoginView = ({ onLoginSuccess, onBackToStore }) => {
  const { login, authMessage, setAuthMessage } = useAuth();
  const [email, setEmail] = useState(() => localStorage.getItem('saved_admin_email') || 'admin@gmail.com');
  const [password, setPassword] = useState('123456');
  const [rememberMe, setRememberMe] = useState(true);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (authMessage) {
      const timer = setTimeout(() => {
        setAuthMessage(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [authMessage, setAuthMessage]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!email.trim() || !password) {
      setError('Vui lòng nhập đầy đủ Email và Mật khẩu.');
      return;
    }

    setLoading(true);

    if (rememberMe) {
      localStorage.setItem('saved_admin_email', email.trim());
    } else {
      localStorage.removeItem('saved_admin_email');
    }

    const res = await login(email.trim(), password, true);
    setLoading(false);

    if (res.success) {
      if (onLoginSuccess) onLoginSuccess();
    } else {
      setError(res.message || 'Email hoặc mật khẩu không chính xác, hoặc tài khoản chưa có quyền Quản trị.');
    }
  };

  const handleFillDemo = (demoEmail, demoPass) => {
    setEmail(demoEmail);
    setPassword(demoPass);
    setError('');
  };

  return (
    <div className="min-h-screen bg-[#0B0B0D] flex items-center justify-center p-4 selection:bg-[#C6A77B] selection:text-[#0B0B0D] relative overflow-hidden font-sans">
      
      {/* Ambient Luxury Lighting */}
      <div className="absolute top-1/4 left-1/3 w-96 h-96 bg-[#C6A77B]/10 rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute bottom-1/4 right-1/3 w-96 h-96 bg-[#E2CEAE]/5 rounded-full blur-[140px] pointer-events-none" />

      <div className="w-full max-w-md relative z-10">
        
        {/* Main Obsidian Luxury Card */}
        <div className="bg-[#141416]/95 backdrop-blur-2xl border border-white/10 rounded-3xl p-8 sm:p-10 shadow-2xl space-y-6 text-white relative">
          
          {/* Header */}
          <div className="text-center space-y-3">
            <div className="w-14 h-14 mx-auto rounded-2xl bg-gradient-to-tr from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] flex items-center justify-center text-[#0B0B0D] shadow-xl shadow-[#C6A77B]/20">
              <Sparkles className="w-7 h-7 fill-current" />
            </div>
            <div>
              <span className="font-display font-extrabold text-lg tracking-[0.2em] text-white">
                CLOTHING<span className="text-[#C6A77B]">ATELIER</span>
              </span>
              <h1 className="text-xl font-extrabold tracking-tight text-white mt-1">
                Cổng Quản Trị Hệ Thống
              </h1>
              <p className="text-xs text-zinc-400 mt-0.5">
                Xác thực danh tính ban điều hành & kiểm soát vận hành
              </p>
            </div>
          </div>

          {/* Toast / Message */}
          {authMessage && (
            <div
              className={`p-3.5 rounded-2xl text-xs flex items-center gap-2.5 transition ${
                authMessage.type === 'info'
                  ? 'bg-blue-500/15 border border-blue-500/30 text-blue-300'
                  : 'bg-emerald-500/15 border border-emerald-500/30 text-emerald-300'
              }`}
            >
              <Info className="w-4 h-4 shrink-0 text-[#C6A77B]" />
              <span>{authMessage.text}</span>
            </div>
          )}

          {/* Error Banner */}
          {error && (
            <div className="p-3.5 rounded-2xl bg-rose-500/15 border border-rose-500/30 text-rose-300 text-xs flex items-center gap-2.5 animate-shake">
              <AlertCircle className="w-4 h-4 shrink-0 text-rose-400" />
              <span>{error}</span>
            </div>
          )}

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-4 text-xs">
            
            {/* Email Field */}
            <div className="space-y-1.5">
              <label className="block text-[11px] font-bold text-zinc-300 uppercase tracking-wider">
                Email Quản Trị Viên
              </label>
              <div className="relative">
                <Mail className="w-4 h-4 absolute left-3.5 top-3.5 text-zinc-500" />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="admin@gmail.com"
                  className="w-full pl-10 pr-4 py-3 rounded-xl bg-black/60 border border-white/10 text-xs text-white placeholder-zinc-600 focus:outline-none focus:border-[#C6A77B] focus:ring-1 focus:ring-[#C6A77B] transition"
                  required
                />
              </div>
            </div>

            {/* Password Field */}
            <div className="space-y-1.5">
              <label className="block text-[11px] font-bold text-zinc-300 uppercase tracking-wider">
                Mật Khẩu Truy Cập
              </label>
              <div className="relative">
                <Lock className="w-4 h-4 absolute left-3.5 top-3.5 text-zinc-500" />
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  className="w-full pl-10 pr-10 py-3 rounded-xl bg-black/60 border border-white/10 text-xs text-white placeholder-zinc-600 focus:outline-none focus:border-[#C6A77B] focus:ring-1 focus:ring-[#C6A77B] transition font-mono"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3.5 top-3.5 text-zinc-500 hover:text-white transition"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            {/* Remember Me */}
            <div className="flex items-center justify-between pt-1">
              <label className="flex items-center gap-2 cursor-pointer text-zinc-400 hover:text-zinc-200">
                <input
                  type="checkbox"
                  checked={rememberMe}
                  onChange={(e) => setRememberMe(e.target.checked)}
                  className="w-4 h-4 rounded border-white/20 bg-black text-[#C6A77B] focus:ring-[#C6A77B]"
                />
                <span>Ghi nhớ phiên đăng nhập</span>
              </label>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3.5 rounded-full bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] font-extrabold uppercase tracking-widest text-xs flex items-center justify-center gap-2 shadow-xl shadow-[#C6A77B]/20 hover:scale-[1.02] transition-all duration-300 cursor-pointer disabled:opacity-50"
            >
              {loading ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" />
                  <span>Đang thẩm định...</span>
                </>
              ) : (
                <>
                  <span>Đăng Nhập Quản Trị</span>
                  <ArrowRight className="w-4 h-4" />
                </>
              )}
            </button>
          </form>

          {/* Quick Demo Credentials */}
          <div className="pt-4 border-t border-white/10 space-y-2.5 text-center">
            <p className="text-[10px] uppercase tracking-[0.2em] font-bold text-zinc-500">
              Tài khoản mẫu thử nghiệm
            </p>
            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => handleFillDemo('admin@gmail.com', '123456')}
                className="flex-1 py-2 px-3 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 text-[11px] font-bold text-[#E2CEAE] transition"
              >
                ADMIN: admin@gmail.com
              </button>
            </div>
          </div>

          {/* Back to storefront link */}
          <div className="text-center pt-2">
            <button
              type="button"
              onClick={onBackToStore || (() => window.location.href = '/')}
              className="inline-flex items-center gap-2 text-xs text-zinc-400 hover:text-[#C6A77B] transition font-bold"
            >
              <Store className="w-3.5 h-3.5" />
              <span>Quay lại trang bán lẻ</span>
            </button>
          </div>

        </div>

      </div>

    </div>
  );
};
