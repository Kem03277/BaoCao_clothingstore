import React, { useState } from 'react';
import { Sparkles, ArrowRight, MapPin, Phone, Mail, CheckCircle2 } from 'lucide-react';

export const Footer = ({ onNavigateShop, onSelectCategory }) => {
  const [email, setEmail] = useState('');
  const [subscribed, setSubscribed] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (email.trim()) {
      setSubscribed(true);
      setEmail('');
      setTimeout(() => setSubscribed(false), 5000);
    }
  };

  return (
    <footer className="bg-[#EEE9E0] dark:bg-[#111113] text-[#0B0B0D] dark:text-white pt-20 pb-10 border-t border-[#C6A77B]/20 dark:border-white/10 relative overflow-hidden select-none transition-colors duration-500">
      
      {/* Background Subtle Gradient */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[700px] h-[300px] bg-[#C6A77B]/10 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Top Grid: Newsletter + Quick Nav */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-12 pb-16 border-b border-black/10 dark:border-white/10">
          
          {/* Brand Manifesto (5 cols) */}
          <div className="lg:col-span-5 space-y-5">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-[#C6A77B] to-[#E5D2B8] flex items-center justify-center text-[#0B0B0D] shadow-md">
                <Sparkles className="w-4 h-4 fill-current" />
              </div>
              <span className="font-serif text-xl tracking-[0.2em] font-light text-[#0B0B0D] dark:text-white">
                CLOTHING<span className="font-extrabold text-[#C6A77B]">STORE</span>
              </span>
            </div>

            <p className="text-xs sm:text-sm text-zinc-600 dark:text-zinc-400 font-sans leading-relaxed max-w-sm">
              Biểu tượng thời trang cao cấp đương đại kết hợp tinh hoa may đo bespoke truyền thống và nghệ thuật số 3D.
            </p>

            <div className="space-y-1.5 text-xs text-zinc-600 dark:text-zinc-400 font-sans">
              <p className="flex items-center gap-2">
                <MapPin className="w-3.5 h-3.5 text-[#C6A77B]" />
                <span>Flagship: 123 Đồng Khởi, Quận 1, TP. Hồ Chí Minh</span>
              </p>
              <p className="flex items-center gap-2">
                <Phone className="w-3.5 h-3.5 text-[#C6A77B]" />
                <span>Hotline: 1900 8888 (08:00 - 22:00)</span>
              </p>
              <p className="flex items-center gap-2">
                <Mail className="w-3.5 h-3.5 text-[#C6A77B]" />
                <span>concierge@clothingstore.vn</span>
              </p>
            </div>
          </div>

          {/* Quick Nav (3 cols) */}
          <div className="lg:col-span-3 space-y-3">
            <h4 className="font-bold text-xs uppercase tracking-[0.2em] text-[#C6A77B] font-mono">
              Khám Phá Danh Mục
            </h4>
            <ul className="space-y-2 text-xs text-zinc-600 dark:text-zinc-400 font-sans">
              <li>
                <button onClick={() => onSelectCategory?.(1)} className="hover:text-[#0B0B0D] dark:hover:text-white transition">
                  Thời Trang Nam (Men Edit)
                </button>
              </li>
              <li>
                <button onClick={() => onSelectCategory?.(2)} className="hover:text-[#0B0B0D] dark:hover:text-white transition">
                  Thời Trang Nữ (Women Couture)
                </button>
              </li>
              <li>
                <button onClick={() => onNavigateShop?.()} className="hover:text-[#0B0B0D] dark:hover:text-white transition">
                  Bộ Sưu Tập Mới 2026
                </button>
              </li>
              <li>
                <button onClick={() => onSelectCategory?.(4)} className="hover:text-[#0B0B0D] dark:hover:text-white transition">
                  Phụ Kiện Da &amp; Khuy Vàng
                </button>
              </li>
            </ul>
          </div>

          {/* Newsletter Subscription (4 cols) */}
          <div className="lg:col-span-4 space-y-4">
            <h4 className="font-bold text-xs uppercase tracking-[0.2em] text-[#C6A77B] font-mono">
              Bản Tin Thời Trang Haute Couture
            </h4>
            <p className="text-xs text-zinc-600 dark:text-zinc-400 font-sans leading-relaxed">
              Nhận thông báo đặc quyền về các đợt phát hành số lượng giới hạn và lời mời tham gia sự kiện Runway độc quyền.
            </p>

            {subscribed ? (
              <div className="p-3.5 rounded-2xl bg-emerald-500/15 border border-emerald-500/30 text-emerald-600 dark:text-emerald-300 text-xs flex items-center gap-2">
                <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                <span>Cảm ơn quý khách! Chúng tôi đã lưu địa chỉ email.</span>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-2.5">
                <div className="relative">
                  <input
                    type="email"
                    required
                    placeholder="Nhập email của bạn..."
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full px-4 py-3 rounded-full bg-black/5 dark:bg-white/5 border border-black/15 dark:border-white/15 text-xs text-[#0B0B0D] dark:text-white placeholder:text-zinc-400 dark:placeholder:text-zinc-500 focus:outline-none focus:border-[#C6A77B] transition"
                  />
                  <button
                    type="submit"
                    className="absolute right-1.5 top-1.5 bottom-1.5 px-4 rounded-full bg-[#C6A77B] text-[#0B0B0D] hover:bg-[#E2CEAE] font-bold text-xs uppercase tracking-wider transition flex items-center gap-1 cursor-pointer"
                  >
                    <span>Gửi</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </button>
                </div>
              </form>
            )}
          </div>

        </div>

        {/* Giant Editorial Watermark Typography */}
        <div className="pt-16 pb-8 overflow-hidden select-none pointer-events-none opacity-10 dark:opacity-15 hover:opacity-20 transition-opacity">
          <h2 className="text-center font-black tracking-tighter text-6xl sm:text-9xl lg:text-[13vw] leading-none text-transparent [-webkit-text-stroke:1px_rgba(0,0,0,0.3)] dark:[-webkit-text-stroke:1px_rgba(255,255,255,0.4)] uppercase">
            CLOTHINGSTORE
          </h2>
        </div>

        {/* Bottom Bar */}
        <div className="pt-6 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-zinc-500 font-mono">
          <p>© 2026 CLOTHINGSTORE ATELIER. All Rights Reserved.</p>
          <div className="flex items-center gap-6">
            <span className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer">Chính sách bảo mật</span>
            <span>·</span>
            <span className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer">Điều khoản dịch vụ</span>
            <span>·</span>
            <span className="hover:text-[#0B0B0D] dark:hover:text-white transition cursor-pointer">Bảo hành may đo</span>
          </div>
        </div>

      </div>
    </footer>
  );
};
