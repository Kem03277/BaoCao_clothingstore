import React, { useEffect, useState } from 'react';
import './App.css';
import { AuthProvider, useAuth } from './context/AuthContext';
import { CartProvider, useCart } from './context/CartContext';
import { WishlistProvider } from './context/WishlistContext';
import { ThemeProvider } from './context/ThemeContext';

// Layout & Common components
import { Navbar } from './components/Navbar';
import { CartDrawer } from './components/CartDrawer';
import { CartNotification } from './components/CartNotification';
import { ProductDetailModal } from './components/ProductDetailModal';
import { ApiTestPanel } from './components/ApiTestPanel';
import { Preloader } from './components/home/Preloader';

// User-facing pages
import { HomePage } from './pages/HomePage';
import { ShopPage } from './pages/ShopPage';
import { AuthPage } from './pages/AuthPage';
import { ProfilePage } from './pages/ProfilePage';
import { CheckoutPage } from './pages/CheckoutPage';
import { OrderHistoryPage } from './pages/OrderHistoryPage';
import { WishlistPage } from './pages/WishlistPage';
import { PostsPage } from './pages/PostsPage';
import { productApi } from './api';

// Admin pages
import { AdminLayout } from './pages/admin/AdminLayout';
import { AdminLoginView } from './pages/admin/AdminLoginView';
import { VnpayPaymentPage } from './components/VnpayPaymentPage';
import { Sparkles, Mail, Phone, MapPin, Shield } from 'lucide-react';

const getInitialView = () => {
  try {
    const user = JSON.parse(localStorage.getItem('user') || 'null');
    const roleCode = user?.roleCode?.toUpperCase();
    const hasManagementAccess = roleCode === 'ADMIN'
      || roleCode === 'ROLE_ADMIN'
      || roleCode === 'STAFF'
      || roleCode === 'ROLE_STAFF';

    return sessionStorage.getItem('clothingstore.adminPortalActive') === 'true'
      && localStorage.getItem('token')
      && hasManagementAccess
      ? 'admin'
      : 'home';
  } catch {
    return 'home';
  }
};

/* ── Customer-facing App ── */
const CustomerApp = () => {
  const { isAuthenticated, hasManagementAccess, authMessage, setAuthMessage } = useAuth();
  const { setIsCartOpen, updateCartItem, clearCart } = useCart();

  const [showPreloader, setShowPreloader] = useState(true);
  const [currentView, setCurrentView] = useState(getInitialView);
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [selectedCartItem, setSelectedCartItem] = useState(null);
  const [productDetailLoading, setProductDetailLoading] = useState(false);
  const [productDetailError, setProductDetailError] = useState('');
  const [apiTesterOpen, setApiTesterOpen] = useState(false);
  const [shopFilterCategory, setShopFilterCategory] = useState(null);
  const [shopSearchKeyword, setShopSearchKeyword] = useState('');
  const [newsletterEmail, setNewsletterEmail] = useState('');
  const [newsletterSubscribed, setNewsletterSubscribed] = useState(false);
  const [returnToCheckoutAfterLogin, setReturnToCheckoutAfterLogin] = useState(false);
  const [vnpayReturnOrderCode, setVnpayReturnOrderCode] = useState(
    () => new URLSearchParams(window.location.search).get('vnp_order')
  );
  const [vnpayPaymentSession, setVnpayPaymentSession] = useState(null);

  useEffect(() => {
    if (!vnpayReturnOrderCode) return;
    setCurrentView('payment-result');
    window.history.replaceState({}, document.title, window.location.pathname);
  }, [vnpayReturnOrderCode]);

  useEffect(() => {
    if (currentView === 'admin' && hasManagementAccess) {
      sessionStorage.setItem('clothingstore.adminPortalActive', 'true');
    } else if (currentView !== 'admin') {
      sessionStorage.removeItem('clothingstore.adminPortalActive');
    }
  }, [currentView, hasManagementAccess]);

  // Auto-dismiss auth message
  React.useEffect(() => {
    if (authMessage) {
      const timer = setTimeout(() => setAuthMessage(null), 4000);
      return () => clearTimeout(timer);
    }
  }, [authMessage, setAuthMessage]);

  const handleSelectProduct = (product) => {
    setSelectedCartItem(null);
    setProductDetailError('');
    setSelectedProduct(product);
  };
  const handleSelectCartProduct = async (item) => {
    setIsCartOpen(false);
    setSelectedCartItem(item);
    setProductDetailError('');
    setProductDetailLoading(true);
    try {
      const product = await productApi.getById(item.id);
      setSelectedProduct(product);
    } catch (error) {
      setSelectedProduct(item);
      setProductDetailError(error.message || 'Không thể tải đầy đủ thông tin sản phẩm.');
    } finally {
      setProductDetailLoading(false);
    }
  };
  const handleCloseProduct = () => {
    setSelectedProduct(null);
    setSelectedCartItem(null);
    setProductDetailError('');
  };
  const handleUpdateCartProduct = (size, quantity, checkout = false) => {
    if (!selectedCartItem) return;
    updateCartItem(selectedCartItem.key, size, quantity);
    handleCloseProduct();
    if (checkout) {
      setCurrentView('checkout');
    } else {
      setIsCartOpen(true);
    }
  };

  const handleAuthSuccess = () => {
    setCurrentView(returnToCheckoutAfterLogin ? 'checkout' : 'home');
    setReturnToCheckoutAfterLogin(false);
  };

  const handleCheckoutLogin = () => {
    setReturnToCheckoutAfterLogin(true);
    setCurrentView('login');
  };

  const handleSubscribeNewsletter = (e) => {
    e.preventDefault();
    if (newsletterEmail.trim()) {
      setNewsletterSubscribed(true);
      setNewsletterEmail('');
      setTimeout(() => setNewsletterSubscribed(false), 4000);
    }
  };

  const renderPage = () => {
    switch (currentView) {
      case 'home':
        return (
          <HomePage
            onNavigateShop={() => {
              setShopFilterCategory(null);
              setShopSearchKeyword('');
              setCurrentView('shop');
            }}
            onNavigateLogin={() => setCurrentView('login')}
            onNavigateProfile={() => setCurrentView('profile')}
            onNavigateOrders={() => setCurrentView('orders')}
            onNavigateAdmin={() => setCurrentView('admin')}
            onNavigatePosts={() => setCurrentView('posts')}
            onSelectProduct={handleSelectProduct}
            onSelectCategory={(catId) => {
              setShopFilterCategory(catId);
              setCurrentView('shop');
            }}
          />
        );
      case 'shop':
        return (
          <ShopPage
            onSelectProduct={handleSelectProduct}
            initialCategory={shopFilterCategory}
            initialKeyword={shopSearchKeyword}
          />
        );
      case 'login':
        return (
          <AuthPage
            mode="login"
            onSuccess={handleAuthSuccess}
            onBack={() => setCurrentView('home')}
          />
        );
      case 'register':
        return (
          <AuthPage
            mode="register"
            onSuccess={handleAuthSuccess}
            onBack={() => setCurrentView('home')}
          />
        );
      case 'profile':
        return (
          <ProfilePage
            onNavigateLogin={() => setCurrentView('login')}
          />
        );
      case 'orders':
        return (
          <OrderHistoryPage
            onNavigateLogin={() => setCurrentView('login')}
            onNavigateShop={() => setCurrentView('shop')}
            onContinuePayment={(session) => {
              setVnpayPaymentSession(session);
              setVnpayReturnOrderCode(session.orderCode);
              setCurrentView('payment-result');
            }}
          />
        );
      case 'wishlist':
        return (
          <WishlistPage
            onNavigateShop={() => setCurrentView('shop')}
            onSelectProduct={handleSelectProduct}
          />
        );
      case 'posts':
        return <PostsPage />;
      case 'checkout':
        return (
          <CheckoutPage
            onBack={() => setCurrentView('shop')}
            onSuccess={() => setCurrentView('orders')}
            onNavigateLogin={handleCheckoutLogin}
          />
        );
      case 'payment-result':
        return (
          <VnpayPaymentPage
            orderCode={vnpayReturnOrderCode}
            session={vnpayPaymentSession}
            onPaid={clearCart}
            onContinue={() => {
              setVnpayReturnOrderCode(null);
              setVnpayPaymentSession(null);
              setCurrentView('orders');
            }}
          />
        );
      case 'admin':
        if (hasManagementAccess) {
          return <AdminLayout onNavigateStore={() => setCurrentView('home')} />;
        }
        return (
          <AdminLoginView
            onLoginSuccess={() => setCurrentView('admin')}
            onBackToStore={() => setCurrentView('home')}
          />
        );
      default:
        return (
          <HomePage
            onNavigateShop={() => setCurrentView('shop')}
            onNavigateLogin={() => setCurrentView('login')}
            onNavigateProfile={() => setCurrentView('profile')}
            onNavigateOrders={() => setCurrentView('orders')}
            onNavigateAdmin={() => setCurrentView('admin')}
            onNavigatePosts={() => setCurrentView('posts')}
            onSelectProduct={handleSelectProduct}
          />
        );
    }
  };

  // Admin layout takes full screen
  if (currentView === 'admin') {
    if (hasManagementAccess) {
      return (
        <div>
          <AdminLayout onNavigateStore={() => setCurrentView('home')} />
        </div>
      );
    }
    return (
      <AdminLoginView
        onLoginSuccess={() => setCurrentView('admin')}
        onBackToStore={() => setCurrentView('home')}
      />
    );
  }

  // Full-screen auth views
  if (currentView === 'login' || currentView === 'register') {
    return renderPage();
  }

  return (
    <div className="min-h-screen flex flex-col justify-between bg-[#F8F7F4] dark:bg-[#0B0B0D] text-[#171717] dark:text-[#F8F7F4] transition-colors duration-300">
      {showPreloader && (
        <Preloader
          onComplete={() => {
            setShowPreloader(false);
          }}
        />
      )}
      {/* Global Toast Notification */}
      {authMessage && (
        <div
          className={`fixed top-4 left-1/2 -translate-x-1/2 z-[100] px-5 py-3 rounded-full text-xs font-semibold shadow-2xl backdrop-blur-md border flex items-center gap-2 transition-all animate-in fade-in slide-in-from-top-3 duration-300 ${authMessage.type === 'success'
              ? 'bg-[#0B0B0D] text-[#C6A77B] border-[#C6A77B]/40'
              : authMessage.type === 'error'
                ? 'bg-rose-600/90 text-white border-rose-500'
                : 'bg-zinc-800 text-white border-zinc-700'
            }`}
        >
          <Sparkles className="w-3.5 h-3.5 shrink-0" />
          <span>{authMessage.text}</span>
        </div>
      )}

      {/* Primary Sticky Header (Used on other pages; HomePage has its dedicated cinematic Header) */}
      {currentView !== 'home' && (
        <Navbar
          currentView={currentView}
          setCurrentView={setCurrentView}
          onOpenApiTester={() => setApiTesterOpen(true)}
          onSelectCategory={(catId) => {
            setShopFilterCategory(catId);
            setCurrentView('shop');
          }}
        />
      )}

      {/* Main Dynamic View */}
      <main className={`flex-1 ${currentView !== 'home' ? 'pt-20' : ''}`}>
        {renderPage()}
      </main>

      {/* ── 5.7. Luxury Footer (HomePage has its dedicated cinematic Footer) ── */}
      {!['checkout', 'home'].includes(currentView) && (
        <footer className="bg-[#0B0B0D] text-white pt-16 pb-8 border-t border-white/10">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 pb-12 border-b border-white/10">

              {/* Col 1 & 2: Brand Manifesto */}
              <div className="lg:col-span-2 space-y-4">
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-[#C6A77B] to-[#E5D2B8] flex items-center justify-center text-[#0B0B0D] shadow-md">
                    <Sparkles className="w-4 h-4 fill-current" />
                  </div>
                  <span className="font-display text-lg tracking-[0.2em] font-extrabold text-white">
                    CLOTHING<span className="text-[#C6A77B]">STORE</span>
                  </span>
                </div>
                <p className="text-xs text-zinc-400 leading-relaxed max-w-sm font-sans">
                  Biểu tượng của phong cách thời trang đương đại và triết lý tối giản tinh tế. Từng sản phẩm đều được kiến tạo từ những xưởng may thủ công đạt tiêu chuẩn quốc tế.
                </p>
                <div className="pt-2 text-xs text-zinc-400 space-y-1">
                  <p className="flex items-center gap-2">
                    <MapPin className="w-3.5 h-3.5 text-[#C6A77B]" />
                    <span>Flagship Store: 123 Đồng Khởi, Quận 1, TP. Hồ Chí Minh</span>
                  </p>
                  <p className="flex items-center gap-2">
                    <Phone className="w-3.5 h-3.5 text-[#C6A77B]" />
                    <span>Hotline hỗ trợ: 1900 8888 (08:00 - 22:00)</span>
                  </p>
                  <p className="flex items-center gap-2">
                    <Mail className="w-3.5 h-3.5 text-[#C6A77B]" />
                    <span>concierge@clothingstore.vn</span>
                  </p>
                </div>
              </div>

              {/* Col 3: Quick Navigation */}
              <div>
                <h4 className="font-bold text-sm tracking-wider uppercase text-white mb-4">
                  Khám Phá
                </h4>
                <ul className="space-y-2.5 text-xs text-zinc-400">
                  <li>
                    <button onClick={() => setCurrentView('home')} className="hover:text-[#C6A77B] transition">
                      Trang chủ
                    </button>
                  </li>
                  <li>
                    <button onClick={() => setCurrentView('shop')} className="hover:text-[#C6A77B] transition">
                      Bộ sưu tập 2026
                    </button>
                  </li>
                  <li>
                    <button onClick={() => setCurrentView('posts')} className="hover:text-[#C6A77B] transition">
                      Bài viết
                    </button>
                  </li>
                  <li>
                    <button onClick={() => setCurrentView('wishlist')} className="hover:text-[#C6A77B] transition">
                      Sản phẩm yêu thích
                    </button>
                  </li>
                  {isAuthenticated && (
                    <li>
                      <button onClick={() => setCurrentView('orders')} className="hover:text-[#C6A77B] transition">
                        Tra cứu đơn hàng
                      </button>
                    </li>
                  )}
                  <li>
                    <button onClick={() => setCurrentView('admin')} className="hover:text-[#C6A77B] transition flex items-center gap-1.5 pt-1">
                      <Shield className="w-3.5 h-3.5 text-[#C6A77B]" />
                      <span>Cổng quản trị Atelier</span>
                    </button>
                  </li>
                </ul>
              </div>

              {/* Col 4: Customer Services */}
              <div>
                <h4 className="font-bold text-sm tracking-wider uppercase text-white mb-4">
                  Dịch Vụ Khách Hàng
                </h4>
                <ul className="space-y-2.5 text-xs text-zinc-400">
                  <li>Chính sách đổi hàng trong 30 ngày</li>
                  <li>Hướng dẫn bảo quản chất liệu len &amp; lụa</li>
                  <li>Dịch vụ đo may riêng biệt (Made-to-Measure)</li>
                  <li>Câu hỏi thường gặp (FAQ)</li>
                  <li>Điều khoản bảo mật &amp; quyền riêng tư</li>
                </ul>
              </div>

              {/* Col 5: Newsletter */}
              <div>
                <h4 className="font-bold text-sm tracking-wider uppercase text-white mb-4">
                  Bản Tin Thời Trang
                </h4>
                <p className="text-xs text-zinc-400 mb-3 leading-relaxed">
                  Đăng ký để nhận thông tin sớm nhất về các bộ sưu tập giới hạn và lời mời tham dự Private Sale.
                </p>

                {newsletterSubscribed ? (
                  <div className="p-3 rounded-2xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-semibold">
                    Cảm ơn bạn! Chúng tôi đã lưu địa chỉ email của bạn.
                  </div>
                ) : (
                  <form onSubmit={handleSubscribeNewsletter} className="space-y-2">
                    <input
                      type="email"
                      placeholder="Email của bạn..."
                      value={newsletterEmail}
                      onChange={(e) => setNewsletterEmail(e.target.value)}
                      required
                      className="w-full px-3.5 py-2.5 rounded-full border border-white/10 bg-white/5 text-xs text-white placeholder:text-zinc-500 focus:outline-none focus:border-[#C6A77B]"
                    />
                    <button
                      type="submit"
                      className="w-full py-2.5 rounded-full bg-[#C6A77B] text-[#0B0B0D] font-bold text-xs uppercase tracking-wider hover:opacity-95 transition"
                    >
                      Đăng ký nhận tin
                    </button>
                  </form>
                )}
              </div>

            </div>

            {/* Giant Luxury Watermark Brand Typography */}
            <div className="pt-12 pb-6 overflow-hidden select-none pointer-events-none opacity-15">
              <h2 className="text-center font-black tracking-tighter text-6xl sm:text-9xl lg:text-[13vw] leading-none text-transparent [-webkit-text-stroke:1px_rgba(255,255,255,0.35)] uppercase">
                CLOTHINGSTORE
              </h2>
            </div>

            {/* Bottom Copyright & Badges */}
            <div className="pt-4 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-zinc-500">
              <p>© 2026 ClothingStore Haute Couture. Kết nối Spring Boot REST API &amp; React Three Fiber.</p>
              <div className="flex items-center gap-4 text-zinc-400">
                <span className="hover:text-white transition cursor-pointer">Bảo mật</span>
                <span>·</span>
                <span className="hover:text-white transition cursor-pointer">Điều khoản</span>
                <span>·</span>
                <span className="hover:text-white transition cursor-pointer">Quyền riêng tư</span>
              </div>
            </div>
          </div>
        </footer>
      )}

      {/* Global Overlays & Modals */}
      <CartDrawer
        setCurrentView={setCurrentView}
        onSelectCartProduct={handleSelectCartProduct}
      />
      <CartNotification />

      {productDetailLoading && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/60 backdrop-blur-sm">
          <div className="flex items-center gap-3 rounded-2xl bg-white px-6 py-4 text-sm font-semibold text-zinc-700 shadow-xl dark:bg-[#141416] dark:text-white">
            <span className="h-5 w-5 animate-spin rounded-full border-2 border-[#C6A77B] border-t-transparent" />
            Đang tải chi tiết sản phẩm...
          </div>
        </div>
      )}

      {selectedProduct && (
        <ProductDetailModal
          key={`${selectedProduct.id}-${selectedCartItem?.key || 'catalog'}`}
          product={selectedProduct}
          initialSize={selectedCartItem?.size}
          initialQuantity={selectedCartItem?.quantity}
          isEditingCartItem={Boolean(selectedCartItem)}
          productDetailError={productDetailError}
          onUpdateCartItem={handleUpdateCartProduct}
          onClose={handleCloseProduct}
          onNavigateCheckout={() => setCurrentView('checkout')}
        />
      )}

      {apiTesterOpen && <ApiTestPanel onClose={() => setApiTesterOpen(false)} />}
    </div>
  );
};

/* ── Root App ── */
export default function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <CartProvider>
          <WishlistProvider>
            <CustomerApp />
          </WishlistProvider>
        </CartProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}
