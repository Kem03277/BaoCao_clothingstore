import React, { useEffect, useState } from 'react';
import {
  Boxes,
  AlertTriangle,
  ArrowDownRight,
  ArrowUpRight,
  SlidersHorizontal,
  History,
  CheckCircle,
  AlertCircle,
  Loader2,
  RefreshCw,
  X,
  Sparkles,
} from 'lucide-react';
import { inventoryApi, productApi } from '../../api';
import { useAuth } from '../../context/AuthContext';
import { AdminPagination } from './AdminPagination';
import { AdminToast } from '../../context/AdminNotificationContext';
import { calculateProductSizeStock } from '../../lib/sizeStock';

export const InventoryAdminView = () => {
  const { user } = useAuth();
  const [products, setProducts] = useState([]);
  const [lowStockList, setLowStockList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;

  // Stock action modal
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [modalType, setModalType] = useState('stock-in'); // 'stock-in', 'stock-out', 'adjustment', 'history'
  const [quantity, setQuantity] = useState(10);
  const [reason, setReason] = useState('Nhập hàng định kỳ từ xưởng may');
  const [transactions, setTransactions] = useState([]);
  const [submitting, setSubmitting] = useState(false);
  const [feedback, setFeedback] = useState(null);

  const fetchInventory = async () => {
    setLoading(true);
    try {
      const [prods, lowStock] = await Promise.all([
        productApi.getAllPages(),
        inventoryApi.findLowStock().catch(() => []),
      ]);
      setProducts(prods || []);
      setLowStockList(lowStock || []);
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi tải kho: ' + err.message });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchInventory();
  }, []);

  const totalPages = Math.max(1, Math.ceil(products.length / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedProducts = products.slice((safePage - 1) * pageSize, safePage * pageSize);

  const handleOpenAction = async (product, type) => {
    setSelectedProduct(product);
    setModalType(type);
    setQuantity(type === 'adjustment' ? product.quantity || 0 : 10);
    setReason(
      type === 'stock-in'
        ? 'Nhập hàng thêm từ xưởng may đạt chuẩn quốc tế'
        : type === 'stock-out'
        ? 'Xuất điều chuyển showroom / bán buôn'
        : 'Kiểm kê định kỳ cân đối lại kho'
    );

    if (type === 'history') {
      try {
        const historyData = await inventoryApi.findTransactions(product.id);
        setTransactions(historyData || []);
      } catch {
        setTransactions([]);
      }
    }
  };

  const handleExecuteAction = async (e) => {
    e.preventDefault();
    if (!selectedProduct) return;

    setSubmitting(true);
    try {
      if (modalType === 'stock-in') {
        await inventoryApi.stockIn(selectedProduct.id, {
          quantity: parseInt(quantity),
          reason,
          createdById: user?.id,
        });
        setFeedback({ type: 'success', message: `Đã nhập +${quantity} sản phẩm vào kho thành công` });
      } else if (modalType === 'stock-out') {
        await inventoryApi.stockOut(selectedProduct.id, {
          quantity: parseInt(quantity),
          reason,
          createdById: user?.id,
        });
        setFeedback({ type: 'success', message: `Đã xuất -${quantity} sản phẩm khỏi kho thành công` });
      } else if (modalType === 'adjustment') {
        await inventoryApi.adjustment(selectedProduct.id, {
          quantityChange: parseInt(quantity),
          reason,
          createdById: user?.id,
        });
        setFeedback({ type: 'success', message: `Đã điều chỉnh số lượng tồn kho thành công` });
      }

      setSelectedProduct(null);
      fetchInventory();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi: ' + (err.message || 'Thao tác kho thất bại') });
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Toast Feedback */}
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Kho vận & Hàng hóa</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Quản Lý Tồn Kho & Nhập Xuất
          </h2>
          <p className="text-xs text-zinc-500 mt-1">
            Theo dõi chính xác mức độ lưu kho, cảnh báo thiếu hụt và nhật ký nhập xuất hàng hóa
          </p>
        </div>

        <button
          onClick={fetchInventory}
          disabled={loading}
          className="self-start sm:self-auto flex items-center gap-2 px-5 py-2.5 rounded-full border border-black/10 bg-white hover:bg-zinc-50 text-[#0B0B0D] text-xs font-bold uppercase tracking-wider shadow-xs transition hover:border-[#C6A77B]/40 cursor-pointer disabled:opacity-50"
        >
          <RefreshCw className={`w-3.5 h-3.5 text-[#C6A77B] ${loading ? 'animate-spin' : ''}`} />
          <span>Làm mới tồn kho</span>
        </button>
      </div>

      {/* Low Stock Warning Alert if any */}
      {lowStockList.length > 0 && (
        <div className="p-5 rounded-3xl bg-amber-500/10 border border-amber-500/30 text-amber-900 text-xs flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-amber-500/20 flex items-center justify-center text-amber-700 shrink-0">
              <AlertTriangle className="w-5 h-5" />
            </div>
            <div>
              <p className="font-extrabold text-sm">Cảnh báo: Có {lowStockList.length} sản phẩm sắp hết hàng!</p>
              <p className="text-[11px] text-amber-800 mt-0.5">Vui lòng lên kế hoạch nhập hàng từ xưởng để không gián đoạn cung ứng.</p>
            </div>
          </div>
        </div>
      )}

      {/* Stock Table */}
      <div className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-16 text-center flex flex-col items-center justify-center gap-3 text-zinc-400">
            <Loader2 className="w-7 h-7 animate-spin text-[#C6A77B]" />
            <span className="text-xs font-medium">Đang tải dữ liệu tồn kho...</span>
          </div>
        ) : products.length === 0 ? (
          <div className="p-16 text-center text-zinc-400 text-xs">
            Chưa có dữ liệu tồn kho nào trong hệ thống.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] text-zinc-600 font-bold uppercase tracking-wider text-[10px] border-b border-black/5">
                <tr>
                  <th className="py-3.5 px-5">Mã SP</th>
                  <th className="py-3.5 px-5">Tên sản phẩm</th>
                  <th className="py-3.5 px-5">Tồn kho hiện tại</th>
                  <th className="py-3.5 px-5">Ngưỡng an toàn</th>
                  <th className="py-3.5 px-5 text-right">Thao tác kho</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5 text-[#0B0B0D]">
                {paginatedProducts.map((p) => {
                  const isLow = (p.quantity || 0) <= 5;

                  return (
                    <tr key={p.id} className="hover:bg-[#F8F7F4]/50 transition-colors">
                      <td className="py-3.5 px-5 font-mono font-bold text-[#0B0B0D]">
                        #{p.id}
                      </td>
                      <td className="py-3.5 px-5 font-bold text-[#0B0B0D]">
                        {p.name}
                      </td>
                      <td className="py-3.5 px-5">
                        <div className="flex flex-col gap-1">
                          <span
                            className={`inline-block w-fit px-3 py-1 rounded-full font-bold text-[10px] uppercase tracking-wider ${
                              isLow
                                ? 'bg-rose-50 text-rose-800 border border-rose-200'
                                : 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                            }`}
                          >
                            {p.quantity || 0} chiếc
                          </span>
                          {(p.quantity || 0) > 0 && (() => {
                            const stock = calculateProductSizeStock(p);
                            return (
                              <div className="text-[10px] text-zinc-500 font-mono tracking-tight flex items-center gap-1">
                                <span>S:{stock.S}</span>
                                <span className="text-zinc-300">·</span>
                                <span>M:{stock.M}</span>
                                <span className="text-zinc-300">·</span>
                                <span>L:{stock.L}</span>
                                <span className="text-zinc-300">·</span>
                                <span>XL:{stock.XL}</span>
                              </div>
                            );
                          })()}
                        </div>
                      </td>
                      <td className="py-3.5 px-5 text-zinc-400 font-mono">
                        5 chiếc
                      </td>
                      <td className="py-3.5 px-5 text-right">
                        <div className="flex items-center justify-end gap-2">
                          <button
                            onClick={() => handleOpenAction(p, 'stock-in')}
                            title="Nhập thêm hàng"
                            className="px-3 py-1.5 rounded-full bg-emerald-50 hover:bg-emerald-100 text-emerald-800 border border-emerald-200 font-bold text-[11px] flex items-center gap-1 transition cursor-pointer"
                          >
                            <ArrowDownRight className="w-3.5 h-3.5" />
                            <span>Nhập kho</span>
                          </button>

                          <button
                            onClick={() => handleOpenAction(p, 'stock-out')}
                            title="Xuất kho"
                            className="px-3 py-1.5 rounded-full bg-amber-50 hover:bg-amber-100 text-amber-800 border border-amber-200 font-bold text-[11px] flex items-center gap-1 transition cursor-pointer"
                          >
                            <ArrowUpRight className="w-3.5 h-3.5" />
                            <span>Xuất kho</span>
                          </button>

                          <button
                            onClick={() => handleOpenAction(p, 'history')}
                            title="Xem lịch sử biến động"
                            className="p-1.5 rounded-full text-zinc-500 hover:text-[#0B0B0D] hover:bg-zinc-100 transition cursor-pointer"
                          >
                            <History className="w-4 h-4 text-[#C6A77B]" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
      <AdminPagination
        totalItems={products.length}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {/* Modal Stock In / Out / History */}
      {selectedProduct && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-lg bg-white rounded-3xl p-7 shadow-2xl space-y-5 border border-black/10">
            <div className="flex items-center justify-between pb-3 border-b border-black/5">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center">
                  <Boxes className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-base font-extrabold text-[#0B0B0D] tracking-tight">
                    {modalType === 'stock-in'
                      ? 'Nhập Kho Bổ Sung'
                      : modalType === 'stock-out'
                      ? 'Xuất Kho Điều Chuyển'
                      : 'Lịch Sử Biến Động Kho'}
                  </h3>
                  <p className="text-[11px] text-zinc-500 truncate max-w-xs">{selectedProduct.name}</p>
                </div>
              </div>
              <button
                onClick={() => setSelectedProduct(null)}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-400 hover:text-zinc-700 transition"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {modalType === 'history' ? (
              <div className="space-y-3">
                <h4 className="text-xs font-bold text-zinc-600 uppercase tracking-wider">
                  Nhật ký giao dịch kho gần nhất
                </h4>
                {transactions.length === 0 ? (
                  <p className="text-xs text-zinc-400 py-8 text-center">Chưa có bản ghi giao dịch nào cho sản phẩm này.</p>
                ) : (
                  <div className="divide-y divide-black/5 max-h-60 overflow-y-auto pr-1">
                    {transactions.map((t, idx) => (
                      <div key={idx} className="py-2.5 flex items-center justify-between text-xs">
                        <div>
                          <p className="font-bold text-[#0B0B0D]">{t.transactionType || t.type}</p>
                          <p className="text-[11px] text-zinc-500">{t.reason || 'Không có ghi chú'}</p>
                        </div>
                        <div className="text-right">
                          <span className="font-mono font-bold text-[#0B0B0D]">
                            {t.quantityChange > 0 ? `+${t.quantityChange}` : t.quantityChange}
                          </span>
                          <p className="text-[10px] text-zinc-400">{t.createdAt ? new Date(t.createdAt).toLocaleDateString('vi-VN') : ''}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
                <div className="pt-2 text-right">
                  <button
                    onClick={() => setSelectedProduct(null)}
                    className="px-5 py-2 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider"
                  >
                    Đóng
                  </button>
                </div>
              </div>
            ) : (
              <form onSubmit={handleExecuteAction} className="space-y-4 text-xs">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Số lượng {modalType === 'stock-in' ? 'nhập thêm' : 'xuất ra'} (chiếc)
                  </label>
                  <input
                    type="number"
                    min="1"
                    value={quantity}
                    onChange={(e) => setQuantity(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Lý do / Căn cứ chứng từ
                  </label>
                  <input
                    type="text"
                    value={reason}
                    onChange={(e) => setReason(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                </div>

                <div className="flex justify-end gap-2.5 pt-4 border-t border-black/5">
                  <button
                    type="button"
                    onClick={() => setSelectedProduct(null)}
                    className="px-5 py-2.5 rounded-full border border-black/10 text-zinc-700 hover:bg-zinc-50 font-bold uppercase tracking-wider text-[11px]"
                  >
                    Hủy
                  </button>
                  <button
                    type="submit"
                    disabled={submitting}
                    className="px-6 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-[#C6A77B] font-bold uppercase tracking-wider text-[11px] flex items-center gap-2 shadow-lg disabled:opacity-50"
                  >
                    {submitting && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                    <span>{submitting ? 'Đang thực hiện...' : 'Xác nhận kho'}</span>
                  </button>
                </div>
              </form>
            )}
          </div>
        </div>
      )}

    </div>
  );
};
