import React, { useState } from 'react';
import { X, Play, CheckCircle, AlertCircle, Copy, Terminal, Loader2, Sparkles } from 'lucide-react';
import {
  productApi,
  categoryApi,
  brandApi,
  postApi,
  authApi,
  orderApi,
  dashboardApi,
  couponApi,
  customerApi,
  inventoryApi,
} from '../api';

const API_ENDPOINTS = [
  { id: 'get_products', name: 'GET /api/products', group: 'Sản phẩm', fn: () => productApi.getAll() },
  { id: 'get_categories', name: 'GET /api/categories', group: 'Danh mục', fn: () => categoryApi.getAll() },
  { id: 'get_brands', name: 'GET /api/brands', group: 'Thương hiệu', fn: () => brandApi.getAll() },
  { id: 'get_posts', name: 'GET /api/posts', group: 'Bài viết', fn: () => postApi.getAll() },
  { id: 'get_me', name: 'GET /api/auth/me (Cần đăng nhập)', group: 'Xác thực', fn: () => authApi.getCurrentUser() },
  { id: 'get_dashboard_revenue', name: 'GET /api/admin/dashboard/revenue?from=...&to=... (Admin)', group: 'Dashboard', fn: () => dashboardApi.getRevenue('2026-01-01', '2026-12-31') },
  { id: 'get_dashboard_status', name: 'GET /api/admin/dashboard/orders-by-status (Admin)', group: 'Dashboard', fn: () => dashboardApi.getOrderCounts() },
  { id: 'get_orders', name: 'GET /api/admin/orders (Admin/Staff)', group: 'Đơn hàng', fn: () => orderApi.getOrders() },
  { id: 'get_coupons', name: 'GET /api/admin/coupons (Admin)', group: 'Mã giảm giá', fn: () => couponApi.getAll() },
  { id: 'get_users', name: 'GET /api/admin/users (Admin)', group: 'Người dùng', fn: () => customerApi.getAllUsers() },
  { id: 'get_low_stock', name: 'GET /api/inventory/low-stock (Admin/Staff)', group: 'Kho hàng', fn: () => inventoryApi.findLowStock() },
];

export const ApiTestPanel = ({ isOpen, onClose }) => {
  const [selectedApi, setSelectedApi] = useState(API_ENDPOINTS[0]);
  const [loading, setLoading] = useState(false);
  const [response, setResponse] = useState(null);
  const [status, setStatus] = useState(null);
  const [duration, setDuration] = useState(null);
  const [copied, setCopied] = useState(false);

  if (!isOpen) return null;

  const handleExecute = async () => {
    setLoading(true);
    setResponse(null);
    setStatus(null);
    const start = performance.now();

    try {
      const data = await selectedApi.fn();
      const end = performance.now();
      setDuration(Math.round(end - start));
      setStatus(200);
      setResponse(data);
    } catch (err) {
      const end = performance.now();
      setDuration(Math.round(end - start));
      setStatus(err.status || 500);
      setResponse(err.data || { error: err.message });
    } finally {
      setLoading(false);
    }
  };

  const copyToClipboard = () => {
    if (!response) return;
    navigator.clipboard.writeText(JSON.stringify(response, null, 2));
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="fixed inset-0 z-50 overflow-hidden flex items-center justify-center p-4 bg-black/70 backdrop-blur-md animate-in fade-in duration-200">
      <div className="relative w-full max-w-4xl bg-[#0B0B0D] border border-white/10 text-zinc-200 rounded-3xl shadow-2xl flex flex-col h-[85vh] overflow-hidden">
        
        {/* Header */}
        <div className="px-6 py-4 border-b border-white/10 flex items-center justify-between bg-black/40">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-[#C6A77B]/15 border border-[#C6A77B]/30 text-[#C6A77B] flex items-center justify-center">
              <Terminal className="w-4 h-4" />
            </div>
            <div>
              <h2 className="text-base font-extrabold text-white flex items-center gap-2">
                <span>Trình Kiểm Tra API Spring Boot</span>
                <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-[#C6A77B]/20 text-[#E2CEAE] border border-[#C6A77B]/30">
                  Axios Live
                </span>
              </h2>
              <p className="text-[11px] text-zinc-400">Kiểm định và debug dữ liệu trả về từ Spring Boot RESTful API (Port 8080)</p>
            </div>
          </div>

          <button
            onClick={onClose}
            className="p-2 rounded-full text-zinc-400 hover:text-white hover:bg-white/5 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content: 2 Columns */}
        <div className="flex-1 flex flex-col md:flex-row min-h-0 overflow-hidden">
          
          {/* Left: Endpoint list */}
          <div className="w-full md:w-1/3 border-r border-white/10 p-4 overflow-y-auto space-y-1.5 bg-black/20">
            <p className="text-[10px] font-bold uppercase tracking-widest text-[#C6A77B] mb-2 px-2">
              Danh Sách Endpoints
            </p>
            {API_ENDPOINTS.map((endpoint) => (
              <button
                key={endpoint.id}
                onClick={() => {
                  setSelectedApi(endpoint);
                  setResponse(null);
                  setStatus(null);
                }}
                className={`w-full text-left p-3 rounded-2xl text-xs transition flex flex-col gap-0.5 cursor-pointer ${
                  selectedApi.id === endpoint.id
                    ? 'bg-gradient-to-r from-[#C6A77B] to-[#E2CEAE] text-[#0B0B0D] font-extrabold shadow-md'
                    : 'text-zinc-300 hover:bg-white/5'
                }`}
              >
                <span className="text-[10px] opacity-75 font-mono">{endpoint.group}</span>
                <span className="font-bold truncate">{endpoint.name}</span>
              </button>
            ))}
          </div>

          {/* Right: Request & Response */}
          <div className="flex-1 flex flex-col min-h-0 p-6 bg-[#141416]/50">
            
            {/* Top Bar with Execute Button */}
            <div className="flex items-center justify-between pb-4 border-b border-white/10">
              <div className="min-w-0 pr-4">
                <span className="text-[10px] text-zinc-500 font-mono uppercase tracking-wider">Endpoint đang chọn:</span>
                <p className="text-sm font-bold text-[#E2CEAE] font-mono mt-0.5 truncate">{selectedApi.name}</p>
              </div>

              <button
                onClick={handleExecute}
                disabled={loading}
                className="flex items-center gap-2 px-6 py-2.5 rounded-full bg-gradient-to-r from-[#C6A77B] to-[#E2CEAE] hover:opacity-95 text-[#0B0B0D] text-xs font-extrabold uppercase tracking-wider transition shadow-lg shadow-[#C6A77B]/20 disabled:opacity-50 cursor-pointer shrink-0"
              >
                {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Play className="w-4 h-4 fill-current" />}
                <span>{loading ? 'Đang gọi...' : 'Gửi Request'}</span>
              </button>
            </div>

            {/* Status & Stats */}
            {status !== null && (
              <div className="flex items-center gap-4 py-3 text-xs border-b border-white/10">
                <div className="flex items-center gap-1.5 font-bold">
                  {status >= 200 && status < 300 ? (
                    <span className="flex items-center gap-1 text-emerald-400">
                      <CheckCircle className="w-4 h-4" /> {status} OK
                    </span>
                  ) : (
                    <span className="flex items-center gap-1 text-rose-400">
                      <AlertCircle className="w-4 h-4" /> {status} Error
                    </span>
                  )}
                </div>
                {duration && <span className="text-zinc-400 font-mono">Thời gian phản hồi: <strong className="text-white">{duration} ms</strong></span>}
                <button
                  onClick={copyToClipboard}
                  className="ml-auto flex items-center gap-1 text-zinc-400 hover:text-white transition font-medium"
                >
                  <Copy className="w-3.5 h-3.5 text-[#C6A77B]" />
                  <span>{copied ? 'Đã sao chép' : 'Sao chép JSON'}</span>
                </button>
              </div>
            )}

            {/* Response Viewer */}
            <div className="flex-1 mt-4 rounded-2xl bg-black/80 border border-white/10 p-4 font-mono text-xs overflow-auto text-emerald-300">
              {loading ? (
                <div className="h-full flex flex-col items-center justify-center text-zinc-500 gap-2">
                  <Loader2 className="w-6 h-6 animate-spin text-[#C6A77B]" />
                  <span>Đang gửi HTTP Request qua Axios tới Spring Boot...</span>
                </div>
              ) : response !== null ? (
                <pre>{JSON.stringify(response, null, 2)}</pre>
              ) : (
                <div className="h-full flex items-center justify-center text-zinc-600">
                  Nhấn "Gửi Request" để kiểm tra API này.
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
