import React, { useEffect, useState, useMemo } from 'react';
import {
  Package,
  ShoppingBag,
  Users,
  TrendingUp,
  Calendar,
  RefreshCw,
  Sparkles,
  Award,
  ArrowUpRight,
  CheckCircle2,
  AlertCircle,
  Clock,
  Truck,
  ShieldCheck,
  BarChart3,
  Flame,
  Crown,
  Medal,
  ChevronRight,
  XCircle,
  Percent,
} from 'lucide-react';
import { dashboardApi, productApi, customerApi } from '../../api';

const toLocalDateString = (date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const ORDER_STATUS_MAP = {
  DELIVERED: {
    label: 'Giao thành công',
    icon: CheckCircle2,
    color: '#10B981',
    barColor: 'bg-emerald-500',
    textColor: 'text-emerald-700 dark:text-emerald-400',
    bgColor: 'bg-emerald-50 dark:bg-emerald-950/40',
    borderColor: 'border-emerald-200 dark:border-emerald-800/60',
  },
  SHIPPED: {
    label: 'Đang vận chuyển',
    icon: Truck,
    color: '#0284C7',
    barColor: 'bg-sky-500',
    textColor: 'text-sky-700 dark:text-sky-400',
    bgColor: 'bg-sky-50 dark:bg-sky-950/40',
    borderColor: 'border-sky-200 dark:border-sky-800/60',
  },
  SHIPPING: {
    label: 'Đang giao hàng',
    icon: Truck,
    color: '#0284C7',
    barColor: 'bg-sky-500',
    textColor: 'text-sky-700 dark:text-sky-400',
    bgColor: 'bg-sky-50 dark:bg-sky-950/40',
    borderColor: 'border-sky-200 dark:border-sky-800/60',
  },
  CONFIRMED: {
    label: 'Đã xác nhận',
    icon: CheckCircle2,
    color: '#6366F1',
    barColor: 'bg-indigo-500',
    textColor: 'text-indigo-700 dark:text-indigo-400',
    bgColor: 'bg-indigo-50 dark:bg-indigo-950/40',
    borderColor: 'border-indigo-200 dark:border-indigo-800/60',
  },
  PROCESSING: {
    label: 'Đang xử lý',
    icon: Clock,
    color: '#F59E0B',
    barColor: 'bg-amber-500',
    textColor: 'text-amber-700 dark:text-amber-400',
    bgColor: 'bg-amber-50 dark:bg-amber-950/40',
    borderColor: 'border-amber-200 dark:border-amber-800/60',
  },
  NEW: {
    label: 'Mới tạo',
    icon: Sparkles,
    color: '#C6A77B',
    barColor: 'bg-[#C6A77B]',
    textColor: 'text-[#8A653B] dark:text-[#C6A77B]',
    bgColor: 'bg-[#C6A77B]/10',
    borderColor: 'border-[#C6A77B]/30',
  },
  PENDING: {
    label: 'Chờ xử lý',
    icon: Clock,
    color: '#71717A',
    barColor: 'bg-zinc-400',
    textColor: 'text-zinc-700 dark:text-zinc-300',
    bgColor: 'bg-zinc-100 dark:bg-zinc-800',
    borderColor: 'border-zinc-200 dark:border-zinc-700',
  },
  CANCELLED: {
    label: 'Đã hủy',
    icon: XCircle,
    color: '#F43F5E',
    barColor: 'bg-rose-500',
    textColor: 'text-rose-700 dark:text-rose-400',
    bgColor: 'bg-rose-50 dark:bg-rose-950/40',
    borderColor: 'border-rose-200 dark:border-rose-800/60',
  },
};

const getStatusMeta = (status) => {
  const upper = String(status || '').toUpperCase();
  return ORDER_STATUS_MAP[upper] || {
    label: status || 'Khác',
    icon: AlertCircle,
    color: '#A1A1AA',
    barColor: 'bg-zinc-400',
    textColor: 'text-zinc-600 dark:text-zinc-400',
    bgColor: 'bg-zinc-100 dark:bg-zinc-800',
    borderColor: 'border-zinc-200 dark:border-zinc-700',
  };
};

export const DashboardView = () => {
  const [revenue, setRevenue] = useState(null);
  const [dailyRevenue, setDailyRevenue] = useState([]);
  const [orderCounts, setOrderCounts] = useState([]);
  const [topProducts, setTopProducts] = useState([]);
  const [allProducts, setAllProducts] = useState([]);
  const [productCount, setProductCount] = useState(0);
  const [userCount, setUserCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [chartMode, setChartMode] = useState('area'); // 'area' | 'bar'
  const [hoveredDay, setHoveredDay] = useState(null);

  const fetchDashboardData = async () => {
    setLoading(true);
    const today = new Date();
    const fromDate = toLocalDateString(new Date(today.getFullYear(), 0, 1));
    const toDate = toLocalDateString(today);

    try {
      const [revRes, dailyRes, countsRes, topRes, prodsRes, usersRes] = await Promise.allSettled([
        dashboardApi.getRevenue(fromDate, toDate),
        dashboardApi.getDailyRevenue(fromDate, toDate),
        dashboardApi.getOrderCounts(),
        dashboardApi.getTopProducts(5),
        productApi.getAllPages(),
        customerApi.getAllUsers(),
      ]);

      if (revRes.status === 'fulfilled') setRevenue(revRes.value?.revenue ?? revRes.value);
      if (dailyRes.status === 'fulfilled') setDailyRevenue(dailyRes.value || []);
      if (countsRes.status === 'fulfilled') setOrderCounts(countsRes.value || []);
      if (topRes.status === 'fulfilled') setTopProducts(topRes.value || []);
      if (prodsRes.status === 'fulfilled') {
        const list = prodsRes.value || [];
        setAllProducts(list);
        setProductCount(list.length);
      }
      if (usersRes.status === 'fulfilled') setUserCount(usersRes.value?.length || 0);
    } catch (err) {
      console.error('Lỗi khi tải dữ liệu dashboard:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const totalOrders = useMemo(() => {
    return orderCounts.reduce((acc, curr) => acc + (curr.count || curr.orderCount || 0), 0);
  }, [orderCounts]);

  const deliveredOrders = useMemo(() => {
    const item = orderCounts.find(
      (c) => (c.status || c.orderStatus || '').toUpperCase() === 'DELIVERED'
    );
    return item?.count || item?.orderCount || 0;
  }, [orderCounts]);

  const deliveryRate = totalOrders > 0 ? Math.round((deliveredOrders / totalOrders) * 100) : 0;
  const aov = totalOrders > 0 && revenue ? Math.round(Number(revenue) / totalOrders) : 0;

  const formatVND = (amount) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0);

  // SVG Chart Computations for 7 Days or available Daily Revenue
  const chartDays = useMemo(() => {
    if (!dailyRevenue || dailyRevenue.length === 0) return [];
    return dailyRevenue.slice(-10);
  }, [dailyRevenue]);

  const maxDailyRevenue = useMemo(() => {
    if (chartDays.length === 0) return 1;
    return Math.max(...chartDays.map((d) => Number(d.revenue || 0)), 1);
  }, [chartDays]);

  // Compute SVG coordinates
  const svgWidth = 800;
  const svgHeight = 220;
  const paddingX = 45;
  const paddingTop = 25;
  const paddingBottom = 40;
  const plotWidth = svgWidth - paddingX * 2;
  const plotHeight = svgHeight - paddingTop - paddingBottom;

  const chartPoints = useMemo(() => {
    if (chartDays.length === 0) return [];
    return chartDays.map((d, i) => {
      const x = chartDays.length > 1
        ? paddingX + (i / (chartDays.length - 1)) * plotWidth
        : svgWidth / 2;
      const y = paddingTop + plotHeight - (Number(d.revenue || 0) / maxDailyRevenue) * plotHeight;
      return { x, y, ...d };
    });
  }, [chartDays, maxDailyRevenue, plotWidth, plotHeight]);

  const areaPath = useMemo(() => {
    if (chartPoints.length === 0) return '';
    if (chartPoints.length === 1) {
      const p = chartPoints[0];
      return `M ${p.x - 20} ${p.y} L ${p.x + 20} ${p.y} L ${p.x + 20} ${paddingTop + plotHeight} L ${p.x - 20} ${paddingTop + plotHeight} Z`;
    }
    let d = `M ${chartPoints[0].x} ${chartPoints[0].y}`;
    for (let i = 0; i < chartPoints.length - 1; i++) {
      const p0 = chartPoints[i];
      const p1 = chartPoints[i + 1];
      const cx = (p0.x + p1.x) / 2;
      d += ` C ${cx} ${p0.y}, ${cx} ${p1.y}, ${p1.x} ${p1.y}`;
    }
    const last = chartPoints[chartPoints.length - 1];
    d += ` L ${last.x} ${paddingTop + plotHeight} L ${chartPoints[0].x} ${paddingTop + plotHeight} Z`;
    return d;
  }, [chartPoints, plotHeight]);

  const linePath = useMemo(() => {
    if (chartPoints.length === 0) return '';
    if (chartPoints.length === 1) {
      return `M ${chartPoints[0].x - 20} ${chartPoints[0].y} L ${chartPoints[0].x + 20} ${chartPoints[0].y}`;
    }
    let d = `M ${chartPoints[0].x} ${chartPoints[0].y}`;
    for (let i = 0; i < chartPoints.length - 1; i++) {
      const p0 = chartPoints[i];
      const p1 = chartPoints[i + 1];
      const cx = (p0.x + p1.x) / 2;
      d += ` C ${cx} ${p0.y}, ${cx} ${p1.y}, ${p1.x} ${p1.y}`;
    }
    return d;
  }, [chartPoints]);

  const handleChartMouseMove = (e) => {
    if (!chartPoints || chartPoints.length === 0) return;
    const rect = e.currentTarget.getBoundingClientRect();
    const mouseX = e.clientX - rect.left;
    const svgX = (mouseX / rect.width) * svgWidth;

    let closest = chartPoints[0];
    let minDiff = Math.abs(chartPoints[0].x - svgX);
    for (let i = 1; i < chartPoints.length; i++) {
      const diff = Math.abs(chartPoints[i].x - svgX);
      if (diff < minDiff) {
        minDiff = diff;
        closest = chartPoints[i];
      }
    }
    if (!hoveredDay || hoveredDay.date !== closest.date) {
      setHoveredDay(closest);
    }
  };

  return (
    <div className="space-y-8 animate-in fade-in duration-300">
      
      {/* ── 1. LUXURY EXECUTIVE WELCOME BANNER ── */}
      <div className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-[#0B0B0D] via-[#141416] to-[#1E1C1A] text-white p-6 sm:p-8 border border-[#C6A77B]/30 shadow-2xl">
        {/* Glow Effects */}
        <div className="absolute top-0 right-0 -mt-10 -mr-10 w-80 h-80 rounded-full bg-gradient-to-br from-[#C6A77B]/20 to-transparent blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-1/3 -mb-10 w-60 h-60 rounded-full bg-amber-500/10 blur-3xl pointer-events-none" />

        <div className="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
          <div className="space-y-2 max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#C6A77B]/20 border border-[#C6A77B]/30 text-[#E2CEAE] text-[10px] font-bold uppercase tracking-[0.25em]">
              <Sparkles className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span>Atelier Executive Suite · 2026</span>
            </div>
            <h1 className="text-2xl sm:text-3xl lg:text-4xl font-extrabold tracking-tight text-white font-display">
              Tổng Quan Hoạt Động <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#C6A77B] via-[#F3E5D0] to-[#C6A77B]">Atelier</span>
            </h1>
            <p className="text-xs sm:text-sm text-zinc-300 leading-relaxed font-light">
              Theo dõi và phân tích chỉ số kinh doanh, dòng tiền, đơn hàng và danh mục thời trang cao cấp theo thời gian thực.
            </p>
            
            {/* Quick KPI Badges */}
            <div className="flex flex-wrap items-center gap-2.5 pt-2">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/10 backdrop-blur-sm text-[11px] font-semibold text-zinc-200 border border-white/10">
                <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
                Hệ thống ổn định 99.9%
              </span>
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/10 backdrop-blur-sm text-[11px] font-semibold text-zinc-200 border border-white/10">
                <Percent className="w-3.5 h-3.5 text-[#C6A77B]" />
                Tỷ lệ giao đạt {deliveryRate}%
              </span>
              {aov > 0 && (
                <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/10 backdrop-blur-sm text-[11px] font-semibold text-zinc-200 border border-white/10">
                  <TrendingUp className="w-3.5 h-3.5 text-amber-400" />
                  AOV: {formatVND(aov)}
                </span>
              )}
            </div>
          </div>

          <div className="flex flex-col sm:flex-row lg:flex-col items-start lg:items-end gap-3 shrink-0">
            <button
              onClick={fetchDashboardData}
              disabled={loading}
              className="flex items-center gap-2 px-5 py-3 rounded-full bg-[#C6A77B] hover:bg-[#d8b88d] text-[#0B0B0D] text-xs font-bold uppercase tracking-wider shadow-lg shadow-[#C6A77B]/20 transition-all hover:scale-[1.02] cursor-pointer disabled:opacity-50"
            >
              <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
              <span>{loading ? 'Đang đồng bộ...' : 'Làm mới dữ liệu'}</span>
            </button>
            <span className="text-[11px] text-zinc-400 font-mono">
              Cập nhật lúc: {new Date().toLocaleTimeString('vi-VN')}
            </span>
          </div>
        </div>
      </div>

      {/* ── 2. METRIC CARDS (GRID OF 4) ── */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        
        {/* Card 1: Doanh thu */}
        <div className="relative p-6 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group overflow-hidden">
          <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B]" />
          <div className="flex items-center justify-between mb-4">
            <span className="text-[11px] font-bold text-zinc-400 dark:text-zinc-500 uppercase tracking-widest">
              Doanh thu kết toán
            </span>
            <div className="w-11 h-11 rounded-2xl bg-[#0B0B0D] dark:bg-black/60 text-[#C6A77B] border border-[#C6A77B]/30 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform">
              <TrendingUp className="w-5 h-5" />
            </div>
          </div>
          <p className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] font-display">
            {formatVND(revenue)}
          </p>
          <div className="flex items-center gap-1.5 text-[11px] font-semibold text-emerald-600 dark:text-emerald-400 mt-2.5">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
            <span>Năm {new Date().getFullYear()} · Đã trừ đơn hủy</span>
          </div>
        </div>

        {/* Card 2: Tổng đơn hàng */}
        <div className="relative p-6 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group overflow-hidden">
          <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-indigo-500 via-sky-400 to-indigo-500" />
          <div className="flex items-center justify-between mb-4">
            <span className="text-[11px] font-bold text-zinc-400 dark:text-zinc-500 uppercase tracking-widest">
              Tổng số đơn hàng
            </span>
            <div className="w-11 h-11 rounded-2xl bg-indigo-50 dark:bg-indigo-950/50 text-indigo-600 dark:text-indigo-400 border border-indigo-200 dark:border-indigo-800/60 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform">
              <ShoppingBag className="w-5 h-5" />
            </div>
          </div>
          <p className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] font-display">
            {totalOrders} <span className="text-sm font-sans font-medium text-zinc-500">đơn</span>
          </p>
          <div className="flex items-center gap-1.5 text-[11px] text-zinc-500 dark:text-zinc-400 mt-2.5">
            <span className="font-semibold text-indigo-600 dark:text-indigo-400">{deliveredOrders}</span> đã giao thành công
          </div>
        </div>

        {/* Card 3: Bộ sưu tập */}
        <div className="relative p-6 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group overflow-hidden">
          <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-amber-500 via-orange-400 to-amber-500" />
          <div className="flex items-center justify-between mb-4">
            <span className="text-[11px] font-bold text-zinc-400 dark:text-zinc-500 uppercase tracking-widest">
              Bộ sưu tập hiện diện
            </span>
            <div className="w-11 h-11 rounded-2xl bg-amber-50 dark:bg-amber-950/50 text-amber-600 dark:text-amber-400 border border-amber-200 dark:border-amber-800/60 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform">
              <Package className="w-5 h-5" />
            </div>
          </div>
          <p className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] font-display">
            {productCount} <span className="text-sm font-sans font-medium text-zinc-500">sản phẩm</span>
          </p>
          <div className="flex items-center gap-1.5 text-[11px] text-emerald-600 dark:text-emerald-400 mt-2.5 font-medium">
            <CheckCircle2 className="w-3.5 h-3.5 shrink-0" />
            <span>Sẵn sàng kinh doanh</span>
          </div>
        </div>

        {/* Card 4: Khách hàng */}
        <div className="relative p-6 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group overflow-hidden">
          <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-emerald-500 via-teal-400 to-emerald-500" />
          <div className="flex items-center justify-between mb-4">
            <span className="text-[11px] font-bold text-zinc-400 dark:text-zinc-500 uppercase tracking-widest">
              Cơ sở khách hàng
            </span>
            <div className="w-11 h-11 rounded-2xl bg-emerald-50 dark:bg-emerald-950/50 text-emerald-600 dark:text-emerald-400 border border-emerald-200 dark:border-emerald-800/60 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform">
              <Users className="w-5 h-5" />
            </div>
          </div>
          <p className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4] font-display">
            {userCount} <span className="text-sm font-sans font-medium text-zinc-500">thành viên</span>
          </p>
          <div className="flex items-center gap-1.5 text-[11px] text-zinc-500 dark:text-zinc-400 mt-2.5 font-medium">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
            <span>Tài khoản kích hoạt Atelier</span>
          </div>
        </div>
      </div>

      {/* ── 3. INTERACTIVE REVENUE VISUALIZATION (CHART) ── */}
      <div className="p-6 sm:p-8 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm space-y-6">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-black/5 dark:border-white/10 pb-5">
          <div>
            <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
              <BarChart3 className="w-3.5 h-3.5" />
              <span>Biểu đồ dòng tiền thời gian thực</span>
            </div>
            <h3 className="text-lg sm:text-xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-[#F8F7F4]">
              Xu Hướng Doanh Thu Theo Ngày
            </h3>
            <p className="text-xs text-zinc-500 dark:text-zinc-400 mt-0.5">
              Theo dõi biến động dòng tiền thanh toán trong các chu kỳ bán hàng gần nhất
            </p>
          </div>

          <div className="flex items-center gap-2 self-start sm:self-auto bg-zinc-100 dark:bg-zinc-800/80 p-1 rounded-full border border-black/5 dark:border-white/10">
            <button
              type="button"
              onClick={() => setChartMode('area')}
              className={`px-4 py-1.5 rounded-full text-xs font-bold transition-all cursor-pointer ${
                chartMode === 'area'
                  ? 'bg-white dark:bg-[#0B0B0D] text-[#C6A77B] shadow-sm'
                  : 'text-zinc-500 hover:text-zinc-900 dark:hover:text-white'
              }`}
            >
              Đường cong (Area)
            </button>
            <button
              type="button"
              onClick={() => setChartMode('bar')}
              className={`px-4 py-1.5 rounded-full text-xs font-bold transition-all cursor-pointer ${
                chartMode === 'bar'
                  ? 'bg-white dark:bg-[#0B0B0D] text-[#C6A77B] shadow-sm'
                  : 'text-zinc-500 hover:text-zinc-900 dark:hover:text-white'
              }`}
            >
              Cột (Columns)
            </button>
          </div>
        </div>

        {/* SVG Area / Bar Chart Container */}
        {chartPoints.length === 0 ? (
          <div className="py-16 text-center text-xs text-zinc-400">
            Chưa có đủ dữ liệu doanh thu phát sinh theo ngày để dựng biểu đồ
          </div>
        ) : (
          <div className="relative">
            <div
              className="w-full overflow-x-auto cursor-crosshair select-none"
              onMouseMove={handleChartMouseMove}
              onMouseLeave={() => setHoveredDay(null)}
            >
              <svg
                viewBox={`0 0 ${svgWidth} ${svgHeight}`}
                className="w-full h-56 sm:h-64 overflow-visible pointer-events-none"
              >
                <defs>
                  {/* Luxury Gold Area Gradient */}
                  <linearGradient id="revenueAreaGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#C6A77B" stopOpacity="0.45" />
                    <stop offset="60%" stopColor="#C6A77B" stopOpacity="0.12" />
                    <stop offset="100%" stopColor="#C6A77B" stopOpacity="0.0" />
                  </linearGradient>

                  {/* Bar Fill Gradient */}
                  <linearGradient id="barGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#E2CEAE" />
                    <stop offset="100%" stopColor="#C6A77B" />
                  </linearGradient>

                  {/* Active Bar Gradient */}
                  <linearGradient id="activeBarGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#FFF2DE" />
                    <stop offset="100%" stopColor="#D8B88D" />
                  </linearGradient>
                </defs>

                {/* Horizontal Guide Grid Lines */}
                {[0, 0.25, 0.5, 0.75, 1].map((ratio, index) => {
                  const y = paddingTop + plotHeight * (1 - ratio);
                  return (
                    <g key={index}>
                      <line
                        x1={paddingX}
                        y1={y}
                        x2={svgWidth - paddingX}
                        y2={y}
                        stroke="currentColor"
                        strokeDasharray="4 4"
                        className="text-zinc-200 dark:text-zinc-800"
                        strokeWidth="1"
                      />
                      <text
                        x={paddingX - 10}
                        y={y + 3}
                        textAnchor="end"
                        className="text-[9px] fill-zinc-400 font-mono"
                      >
                        {formatVND(maxDailyRevenue * ratio).replace('₫', '').trim()}
                      </text>
                    </g>
                  );
                })}

                {/* Active Day Vertical Guideline */}
                {hoveredDay && (
                  <line
                    x1={hoveredDay.x}
                    y1={paddingTop - 5}
                    x2={hoveredDay.x}
                    y2={paddingTop + plotHeight}
                    stroke="#C6A77B"
                    strokeWidth="1.5"
                    strokeDasharray="3 3"
                    className="opacity-80"
                  />
                )}

                {/* Mode: Area Chart */}
                {chartMode === 'area' && (
                  <g>
                    <path d={areaPath} fill="url(#revenueAreaGradient)" />
                    <path
                      d={linePath}
                      fill="none"
                      stroke="#C6A77B"
                      strokeWidth="3.5"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </g>
                )}

                {/* Mode: Bar Columns */}
                {chartMode === 'bar' && (
                  chartPoints.map((p, idx) => {
                    const barWidth = Math.max(16, plotWidth / (chartPoints.length * 2.2));
                    const barHeight = paddingTop + plotHeight - p.y;
                    const isHovered = hoveredDay?.date === p.date;
                    return (
                      <rect
                        key={idx}
                        x={p.x - barWidth / 2}
                        y={p.y}
                        width={barWidth}
                        height={Math.max(4, barHeight)}
                        rx="6"
                        fill={isHovered ? "url(#activeBarGradient)" : "url(#barGradient)"}
                      />
                    );
                  })
                )}

                {/* Data Points (Dots and labels) */}
                {chartPoints.map((p, idx) => {
                  const isHovered = hoveredDay?.date === p.date;
                  return (
                    <g key={idx}>
                      <circle
                        cx={p.x}
                        cy={p.y}
                        r={isHovered ? 7.5 : 4.5}
                        className={
                          isHovered
                            ? "fill-[#C6A77B] stroke-white dark:stroke-[#0B0B0D]"
                            : "fill-[#0B0B0D] dark:fill-black stroke-[#C6A77B]"
                        }
                        strokeWidth={isHovered ? 3 : 2}
                      />
                      {/* X-axis Date Label */}
                      <text
                        x={p.x}
                        y={svgHeight - 12}
                        textAnchor="middle"
                        className={`text-[10px] font-mono ${
                          isHovered
                            ? 'fill-[#C6A77B] font-bold'
                            : 'fill-zinc-400 dark:fill-zinc-500'
                        }`}
                      >
                        {String(p.date || '').split('-').slice(1).join('/')}
                      </text>
                    </g>
                  );
                })}

                {/* SVG Native Tooltip Card (Zero flickering, scales perfectly, no layout shift) */}
                {hoveredDay && (() => {
                  const clampedX = Math.max(75, Math.min(svgWidth - 75, hoveredDay.x));
                  const isTopPeak = hoveredDay.y < 70;
                  const cardY = isTopPeak ? hoveredDay.y + 16 : hoveredDay.y - 62;
                  return (
                    <g>
                      {/* Tooltip Background Box */}
                      <rect
                        x={clampedX - 68}
                        y={cardY}
                        width="136"
                        height="48"
                        rx="14"
                        fill="#0B0B0D"
                        stroke="#C6A77B"
                        strokeWidth="1.5"
                        fillOpacity="0.96"
                      />
                      {/* Tooltip Date */}
                      <text
                        x={clampedX}
                        y={cardY + 18}
                        textAnchor="middle"
                        fill="#A1A1AA"
                        fontSize="10"
                        fontFamily="monospace"
                        fontWeight="bold"
                        letterSpacing="0.05em"
                      >
                        {hoveredDay.date}
                      </text>
                      {/* Tooltip Amount */}
                      <text
                        x={clampedX}
                        y={cardY + 37}
                        textAnchor="middle"
                        fill="#C6A77B"
                        fontSize="13"
                        fontFamily="sans-serif"
                        fontWeight="800"
                      >
                        {formatVND(hoveredDay.revenue)}
                      </text>
                    </g>
                  );
                })()}
              </svg>
            </div>

            {/* Quick Chart Stats Footer */}
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 pt-4 border-t border-black/5 dark:border-white/10 text-xs">
              <div className="p-3 rounded-2xl bg-[#F8F7F4] dark:bg-[#1A1A1E]">
                <p className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider">Ngày cao nhất</p>
                <p className="text-sm font-extrabold text-[#0B0B0D] dark:text-white mt-0.5">
                  {formatVND(maxDailyRevenue)}
                </p>
              </div>
              <div className="p-3 rounded-2xl bg-[#F8F7F4] dark:bg-[#1A1A1E]">
                <p className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider">Số chu kỳ kết toán</p>
                <p className="text-sm font-extrabold text-[#0B0B0D] dark:text-white mt-0.5 font-mono">
                  {chartDays.length} ngày phát sinh
                </p>
              </div>
              <div className="col-span-2 sm:col-span-1 p-3 rounded-2xl bg-[#F8F7F4] dark:bg-[#1A1A1E]">
                <p className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider">Doanh thu trung bình</p>
                <p className="text-sm font-extrabold text-[#C6A77B] mt-0.5">
                  {formatVND(
                    chartDays.reduce((acc, c) => acc + Number(c.revenue || 0), 0) /
                      Math.max(1, chartDays.length)
                  )}
                </p>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* ── 4. TWO COLUMNS: ORDER STATUS DISTRIBUTION & BEST-SELLERS LEADERBOARD ── */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        
        {/* CỘT TRÁI: PHÂN BỔ TRẠNG THÁI ĐƠN HÀNG */}
        <div className="lg:col-span-6 p-6 sm:p-7 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm space-y-5">
          <div className="flex items-center justify-between border-b border-black/5 dark:border-white/10 pb-4">
            <div>
              <span className="text-[10px] font-bold text-[#C6A77B] uppercase tracking-widest">
                Tiến trình chuỗi cung ứng
              </span>
              <h3 className="text-base sm:text-lg font-extrabold text-[#0B0B0D] dark:text-[#F8F7F4] tracking-tight flex items-center gap-2 mt-0.5">
                <ShoppingBag className="w-4 h-4 text-[#C6A77B]" />
                Phân Bổ Trạng Thái Đơn Hàng
              </h3>
            </div>
            <span className="text-xs font-mono font-bold text-[#C6A77B] bg-[#C6A77B]/10 border border-[#C6A77B]/20 px-3 py-1 rounded-full">
              {totalOrders} Tổng đơn
            </span>
          </div>

          {/* Multi-segmented Overview Bar */}
          {totalOrders > 0 && (
            <div className="space-y-1.5">
              <div className="h-3.5 w-full bg-zinc-100 dark:bg-zinc-800 rounded-full overflow-hidden flex shadow-inner">
                {orderCounts.map((item, idx) => {
                  const statusKey = item.status || item.orderStatus || 'Khác';
                  const meta = getStatusMeta(statusKey);
                  const count = item.count || item.orderCount || 0;
                  const pct = Math.max(0, (count / totalOrders) * 100);
                  if (pct === 0) return null;
                  return (
                    <div
                      key={idx}
                      className={`h-full ${meta.barColor} transition-all duration-500 first:rounded-l-full last:rounded-r-full`}
                      style={{ width: `${pct}%` }}
                      title={`${meta.label}: ${count} đơn (${Math.round(pct)}%)`}
                    />
                  );
                })}
              </div>
              <p className="text-[10px] text-zinc-400 dark:text-zinc-500 text-right font-medium">
                Tỷ trọng phân bổ luồng đơn hàng Atelier
              </p>
            </div>
          )}

          {/* Detailed Status Cards */}
          {orderCounts.length === 0 ? (
            <p className="text-xs text-zinc-400 py-10 text-center">Chưa có dữ liệu đơn hàng nào được ghi nhận</p>
          ) : (
            <div className="space-y-3">
              {orderCounts.map((item, idx) => {
                const statusKey = item.status || item.orderStatus || 'Khác';
                const meta = getStatusMeta(statusKey);
                const count = item.count || item.orderCount || 0;
                const percentage = totalOrders > 0 ? Math.round((count / totalOrders) * 100) : 0;
                const StatusIcon = meta.icon;

                return (
                  <div
                    key={idx}
                    className="p-3.5 rounded-2xl bg-[#F8F7F4] dark:bg-[#1A1A1E] border border-black/5 dark:border-white/5 space-y-2 hover:border-[#C6A77B]/30 transition-all"
                  >
                    <div className="flex items-center justify-between text-xs">
                      <div className="flex items-center gap-2.5">
                        <div className={`w-7 h-7 rounded-xl ${meta.bgColor} ${meta.textColor} flex items-center justify-center shrink-0`}>
                          <StatusIcon className="w-3.5 h-3.5" />
                        </div>
                        <div>
                          <span className="font-extrabold text-[#0B0B0D] dark:text-[#F8F7F4]">
                            {meta.label}
                          </span>
                          <span className="text-[10px] text-zinc-400 font-mono ml-2">
                            ({statusKey})
                          </span>
                        </div>
                      </div>

                      <div className="flex items-center gap-2">
                        <span className="font-mono text-xs font-extrabold text-[#0B0B0D] dark:text-white">
                          {count} đơn
                        </span>
                        <span className={`text-[11px] font-bold font-mono px-2 py-0.5 rounded-full ${meta.bgColor} ${meta.textColor}`}>
                          {percentage}%
                        </span>
                      </div>
                    </div>

                    {/* Progress Track */}
                    <div className="h-1.5 w-full bg-zinc-200 dark:bg-zinc-800 rounded-full overflow-hidden">
                      <div
                        className={`h-full rounded-full transition-all duration-700 ${meta.barColor}`}
                        style={{ width: `${percentage}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* CỘT PHẢI: TOP TUYỆT TÁC BÁN CHẠY NHẤT (BEST-SELLERS LEADERBOARD) */}
        <div className="lg:col-span-6 p-6 sm:p-7 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm space-y-5">
          <div className="flex items-center justify-between border-b border-black/5 dark:border-white/10 pb-4">
            <div>
              <span className="text-[10px] font-bold text-[#C6A77B] uppercase tracking-widest">
                Vinh danh bộ sưu tập
              </span>
              <h3 className="text-base sm:text-lg font-extrabold text-[#0B0B0D] dark:text-[#F8F7F4] tracking-tight flex items-center gap-2 mt-0.5">
                <Flame className="w-4 h-4 text-amber-500 fill-amber-500" />
                Tuyệt Tác Bán Chạy Nhất
              </h3>
            </div>
            <span className="text-xs font-mono font-bold text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-800/60 px-3 py-1 rounded-full flex items-center gap-1">
              <Award className="w-3.5 h-3.5" />
              Top Best-Sellers
            </span>
          </div>

          {topProducts.length === 0 ? (
            <p className="text-xs text-zinc-400 py-10 text-center">Chưa có dữ liệu giao dịch sản phẩm nào</p>
          ) : (
            <div className="space-y-3">
              {topProducts.map((p, idx) => {
                const productName = p.name || p.productName;
                const quantitySold = p.quantitySold ?? 0;
                // Find extra product details from allProducts
                const productDetail = allProducts.find(
                  (item) => item.id === p.productId || item.name === productName
                );
                const thumb = productDetail?.images?.[0]?.imageUrl || productDetail?.imageUrl;
                const price = productDetail?.price;
                const categoryName = productDetail?.category?.name || productDetail?.categoryName;

                // Rank badges
                const isTop1 = idx === 0;
                const isTop2 = idx === 1;
                const isTop3 = idx === 2;

                return (
                  <div
                    key={idx}
                    className={`p-3.5 rounded-2xl border transition-all duration-200 flex items-center justify-between gap-4 ${
                      isTop1
                        ? 'bg-gradient-to-r from-[#C6A77B]/10 via-[#F8F7F4] to-transparent dark:from-[#C6A77B]/15 dark:to-[#1A1A1E] border-[#C6A77B]/40 shadow-sm'
                        : 'bg-[#F8F7F4] dark:bg-[#1A1A1E] border-black/5 dark:border-white/5 hover:border-[#C6A77B]/30'
                    }`}
                  >
                    <div className="flex items-center gap-3.5 min-w-0">
                      {/* Rank Icon Badge */}
                      <div className="relative shrink-0">
                        <div
                          className={`w-9 h-9 rounded-2xl flex items-center justify-center font-extrabold text-xs shadow-sm ${
                            isTop1
                              ? 'bg-gradient-to-br from-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] ring-2 ring-[#C6A77B]/40 shadow-[#C6A77B]/20'
                              : isTop2
                              ? 'bg-zinc-200 dark:bg-zinc-700 text-zinc-800 dark:text-zinc-200'
                              : isTop3
                              ? 'bg-amber-100 dark:bg-amber-950/60 text-amber-800 dark:text-amber-300'
                              : 'bg-[#0B0B0D] text-zinc-400'
                          }`}
                        >
                          {isTop1 ? <Crown className="w-4 h-4 fill-current" /> : `#${idx + 1}`}
                        </div>
                      </div>

                      {/* Product Thumbnail */}
                      <div className="w-12 h-12 rounded-xl bg-white dark:bg-black/40 border border-black/5 dark:border-white/10 overflow-hidden shrink-0 flex items-center justify-center">
                        {thumb ? (
                          <img
                            src={thumb}
                            alt=""
                            className="w-full h-full object-cover object-top hover:scale-110 transition-transform"
                          />
                        ) : (
                          <Package className="w-5 h-5 text-zinc-400" />
                        )}
                      </div>

                      {/* Title & Category Info */}
                      <div className="min-w-0 space-y-0.5">
                        <h4 className="text-xs sm:text-sm font-bold text-[#0B0B0D] dark:text-[#F8F7F4] truncate">
                          {productName}
                        </h4>
                        <div className="flex items-center gap-2 text-[10px] text-zinc-500 dark:text-zinc-400">
                          {categoryName && (
                            <span className="font-semibold text-[#C6A77B]">
                              {categoryName}
                            </span>
                          )}
                          {price && (
                            <>
                              <span>·</span>
                              <span className="font-mono font-medium">{formatVND(price)}</span>
                            </>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* Sold Quantity & Badge */}
                    <div className="text-right shrink-0">
                      <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#0B0B0D] dark:bg-black text-[#C6A77B] text-xs font-extrabold font-mono shadow-sm">
                        <span>{quantitySold}</span>
                        <span className="text-[10px] font-sans font-medium text-zinc-400">đã bán</span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      {/* ── 5. RECENT FINANCIAL FLOW SETTLEMENT TABLE ── */}
      {dailyRevenue.length > 0 && (
        <div className="p-6 sm:p-7 rounded-3xl bg-white dark:bg-[#141416] border border-black/5 dark:border-white/10 shadow-sm space-y-4">
          <div className="flex items-center justify-between border-b border-black/5 dark:border-white/10 pb-4">
            <div>
              <span className="text-[10px] font-bold text-[#C6A77B] uppercase tracking-widest">
                Sao kê kết toán tài chính
              </span>
              <h3 className="text-base sm:text-lg font-extrabold text-[#0B0B0D] dark:text-[#F8F7F4] tracking-tight flex items-center gap-2 mt-0.5">
                <Calendar className="w-4 h-4 text-[#C6A77B]" />
                Doanh Số Giao Dịch Gần Nhất
              </h3>
            </div>
            <span className="text-xs text-zinc-500 font-medium">Chu kỳ 7 ngày gần nhất</span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] dark:bg-[#1A1A1E] text-zinc-600 dark:text-zinc-400 font-bold uppercase tracking-wider text-[10px]">
                <tr>
                  <th className="py-3 px-5 rounded-l-2xl">Ngày ghi nhận</th>
                  <th className="py-3 px-5">Kênh giao dịch</th>
                  <th className="py-3 px-5">Trạng thái kết toán</th>
                  <th className="py-3 px-5 rounded-r-2xl text-right">Doanh thu ghi nhận</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5 dark:divide-white/5 text-[#0B0B0D] dark:text-[#F8F7F4]">
                {dailyRevenue.slice(-7).reverse().map((item, index) => (
                  <tr key={index} className="hover:bg-[#F8F7F4]/60 dark:hover:bg-white/5 transition-colors">
                    <td className="py-3.5 px-5 font-mono font-bold text-xs flex items-center gap-2">
                      <div className="w-2 h-2 rounded-full bg-[#C6A77B]" />
                      <span>{item.date}</span>
                    </td>
                    <td className="py-3.5 px-5 text-zinc-500 dark:text-zinc-400 font-medium">
                      Atelier Storefront & COD / VNPAY
                    </td>
                    <td className="py-3.5 px-5">
                      <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 border border-emerald-200 dark:border-emerald-800/60 text-[10px] font-bold">
                        <CheckCircle2 className="w-3 h-3" />
                        Đã đối soát
                      </span>
                    </td>
                    <td className="py-3.5 px-5 text-right font-extrabold text-[#0B0B0D] dark:text-[#C6A77B] font-mono text-sm">
                      {formatVND(item.revenue)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

    </div>
  );
};
