import React, { useState } from 'react';
import { Eye, EyeOff, ShoppingBag, Sparkles, Mail, Lock, User, Phone, ArrowRight, ArrowLeft } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { authApi } from '../api';

export const AuthPage = ({ mode = 'login', onSuccess, onBack }) => {
  const { login } = useAuth();
  const [isLogin, setIsLogin] = useState(mode === 'login');
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const [form, setForm] = useState({
    fullName: '',
    email: '',
    password: '',
    phone: '',
  });

  const handleChange = (e) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    setError('');
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      const result = await login(form.email, form.password, false);
      if (result.success) {
        onSuccess?.({ user: result.user });
      } else {
        setError(result.message || 'Email hoặc mật khẩu không chính xác');
      }
    } catch {
      setError('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.');
    } finally {
      setLoading(false);
    }
  };

  const handleRegister = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      await authApi.register({
        fullName: form.fullName,
        email: form.email,
        password: form.password,
        phone: form.phone,
      });
      setSuccess('Đăng ký tài khoản thành công! Đang tiến hành đăng nhập...');
      const result = await login(form.email, form.password, false);
      if (result.success) {
        onSuccess?.({ user: result.user, registered: true });
      } else {
        setIsLogin(true);
        setSuccess('Đăng ký thành công! Vui lòng đăng nhập với thông tin vừa tạo.');
      }
    } catch (err) {
      setError(err?.data?.message || err?.message || 'Đăng ký thất bại. Email có thể đã tồn tại.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#0B0B0D] p-4 relative overflow-hidden text-white">
      
      {/* Ambient Lighting Gradients */}
      <div className="absolute top-0 right-1/4 w-[500px] h-[500px] bg-[#C6A77B]/10 rounded-full blur-[140px] pointer-events-none" />
      <div className="absolute bottom-0 left-1/4 w-[500px] h-[500px] bg-[#E2CEAE]/5 rounded-full blur-[140px] pointer-events-none" />

      {/* Back button */}
      {onBack && (
        <button
          onClick={onBack}
          className="absolute top-6 left-6 p-2.5 rounded-full bg-white/10 hover:bg-white/20 text-white transition cursor-pointer z-10"
          title="Quay lại"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
      )}

      <div className="relative w-full max-w-md z-10 py-12">
        
        {/* Brand Logo Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center gap-2.5 mb-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-[#C6A77B] to-[#E5D2B8] flex items-center justify-center text-[#0B0B0D] shadow-xl">
              <Sparkles className="w-5 h-5 fill-current" />
            </div>
            <span className="font-display text-xl tracking-[0.2em] font-extrabold text-white">
              CLOTHING<span className="text-[#C6A77B]">STORE</span>
            </span>
          </div>
          <p className="text-xs text-zinc-400 font-sans tracking-wide">
            {isLogin
              ? 'Đăng nhập vào không gian thời trang cao cấp của bạn'
              : 'Trở thành thành viên để tận hưởng đặc quyền độc quyền'}
          </p>
        </div>

        {/* Card */}
        <div className="bg-[#141416]/90 backdrop-blur-xl rounded-3xl border border-white/10 p-8 shadow-2xl">
          
          {/* Mode Switcher Tabs */}
          <div className="flex rounded-2xl bg-white/5 p-1 mb-6 border border-white/5">
            <button
              onClick={() => {
                setIsLogin(true);
                setError('');
                setSuccess('');
              }}
              className={`flex-1 py-2.5 rounded-xl text-xs uppercase tracking-wider font-bold transition-all ${
                isLogin
                  ? 'bg-[#0B0B0D] text-[#C6A77B] shadow-md border border-white/10'
                  : 'text-zinc-400 hover:text-white'
              }`}
            >
              Đăng nhập
            </button>
            <button
              onClick={() => {
                setIsLogin(false);
                setError('');
                setSuccess('');
              }}
              className={`flex-1 py-2.5 rounded-xl text-xs uppercase tracking-wider font-bold transition-all ${
                !isLogin
                  ? 'bg-[#0B0B0D] text-[#C6A77B] shadow-md border border-white/10'
                  : 'text-zinc-400 hover:text-white'
              }`}
            >
              Đăng ký
            </button>
          </div>

          {/* Feedback messages */}
          {success && (
            <div className="mb-4 p-3 rounded-2xl bg-emerald-500/15 border border-emerald-500/30 text-emerald-400 text-xs flex items-center gap-2">
              <Sparkles className="w-4 h-4 shrink-0" />
              <span>{success}</span>
            </div>
          )}
          {error && (
            <div className="mb-4 p-3 rounded-2xl bg-rose-500/15 border border-rose-500/30 text-rose-400 text-xs">
              {error}
            </div>
          )}

          <form onSubmit={isLogin ? handleLogin : handleRegister} className="space-y-4">
            
            {/* Full Name (register only) */}
            {!isLogin && (
              <div className="relative">
                <User className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                <input
                  type="text"
                  name="fullName"
                  placeholder="Họ và tên của bạn"
                  value={form.fullName}
                  onChange={handleChange}
                  required
                  className="w-full pl-10 pr-4 py-3 rounded-2xl border border-white/10 bg-white/5 text-xs sm:text-sm text-white placeholder:text-zinc-500 focus:outline-none focus:border-[#C6A77B] transition"
                />
              </div>
            )}

            {/* Email */}
            <div className="relative">
              <Mail className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
              <input
                type="email"
                name="email"
                placeholder="Email đăng nhập"
                value={form.email}
                onChange={handleChange}
                required
                className="w-full pl-10 pr-4 py-3 rounded-2xl border border-white/10 bg-white/5 text-xs sm:text-sm text-white placeholder:text-zinc-500 focus:outline-none focus:border-[#C6A77B] transition"
              />
            </div>

            {/* Phone (register only) */}
            {!isLogin && (
              <div className="relative">
                <Phone className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                <input
                  type="tel"
                  name="phone"
                  placeholder="Số điện thoại liên hệ"
                  value={form.phone}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-3 rounded-2xl border border-white/10 bg-white/5 text-xs sm:text-sm text-white placeholder:text-zinc-500 focus:outline-none focus:border-[#C6A77B] transition"
                />
              </div>
            )}

            {/* Password */}
            <div className="relative">
              <Lock className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
              <input
                type={showPass ? 'text' : 'password'}
                name="password"
                placeholder="Mật khẩu"
                value={form.password}
                onChange={handleChange}
                required
                minLength={isLogin ? 1 : 6}
                className="w-full pl-10 pr-12 py-3 rounded-2xl border border-white/10 bg-white/5 text-xs sm:text-sm text-white placeholder:text-zinc-500 focus:outline-none focus:border-[#C6A77B] transition"
              />
              <button
                type="button"
                onClick={() => setShowPass(!showPass)}
                className="absolute right-3.5 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-white transition"
              >
                {showPass ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>

            {/* Submit CTA */}
            <button
              type="submit"
              disabled={loading}
              className="w-full py-4 rounded-full bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] font-bold text-xs uppercase tracking-[0.2em] shadow-xl hover:scale-102 transition duration-300 flex items-center justify-center gap-2 disabled:opacity-50 cursor-pointer mt-2"
            >
              {loading ? (
                <span className="w-4 h-4 border-2 border-black/30 border-t-black rounded-full animate-spin" />
              ) : (
                <>
                  <span>{isLogin ? 'Đăng nhập ngay' : 'Đăng ký tài khoản'}</span>
                  <ArrowRight className="w-4 h-4" />
                </>
              )}
            </button>
          </form>

        </div>

        {/* Footer Note */}
        <p className="text-center text-[11px] text-zinc-500 mt-6 max-w-xs mx-auto">
          Bằng cách đăng nhập, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của ClothingStore.
        </p>

      </div>
    </div>
  );
};
