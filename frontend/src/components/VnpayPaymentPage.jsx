import React, { useEffect, useRef, useState } from "react";
import {
  AlertCircle,
  CheckCircle,
  Clock3,
  ExternalLink,
  QrCode,
  Copy,
  Check,
  Building2,
  User,
  CreditCard,
  FileText,
  Loader2,
  ShieldCheck,
} from "lucide-react";
import { vnpayApi } from "../api/vnpayApi";

const formatVND = (amount) =>
  new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(
    amount || 0,
  );

const formatRemaining = (milliseconds) => {
  const totalSeconds = Math.ceil(milliseconds / 1000);
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
};

// Cấu hình thông tin nhận chuyển khoản MBBank
const BANK_INFO = {
  bankName: "MBBank (Ngân hàng TMCP Quân Đội)",
  bankCode: "MB",
  accountNo: "0377974947",
  accountName: "PHAM DONG",
};

export const VnpayPaymentPage = ({
  orderCode,
  session,
  onPaid,
  onContinue,
}) => {
  const [paymentStatus, setPaymentStatus] = useState("PENDING");
  const [paymentAmount, setPaymentAmount] = useState(session?.amount || 0);
  const [statusExpiresAt, setStatusExpiresAt] = useState(null);
  const [remaining, setRemaining] = useState(15 * 60 * 1000);
  const [statusError, setStatusError] = useState("");
  const [copiedField, setCopiedField] = useState(null);
  const [confirming, setConfirming] = useState(false);
  const [confirmError, setConfirmError] = useState("");
  const [qrLoadedError, setQrLoadedError] = useState(false);

  const handledPaidRef = useRef(false);
  const onPaidRef = useRef(onPaid);
  const targetOrderCode = session?.orderCode || orderCode;

  onPaidRef.current = onPaid;

  useEffect(() => {
    const expiresAtValue = session?.expiresAt || statusExpiresAt;
    if (!expiresAtValue) return undefined;
    const expiresAt = new Date(expiresAtValue).getTime();
    const updateRemaining = () =>
      setRemaining(Math.max(0, expiresAt - Date.now()));
    updateRemaining();
    const timer = window.setInterval(updateRemaining, 1000);
    return () => window.clearInterval(timer);
  }, [session?.expiresAt, statusExpiresAt]);

  useEffect(() => {
    if (!targetOrderCode) {
      setStatusError("Thiếu mã đơn hàng để kiểm tra thanh toán.");
      return undefined;
    }

    let active = true;
    let timer;
    const checkStatus = async () => {
      try {
        const status = await vnpayApi.getStatus(targetOrderCode);
        if (!active) return;
        setPaymentStatus(status.paymentStatus);
        setPaymentAmount(status.amount);
        setStatusExpiresAt(status.expiresAt);
        setStatusError("");
        if (status.paymentStatus === "PAID" && !handledPaidRef.current) {
          handledPaidRef.current = true;
          onPaidRef.current?.();
        }
        if (status.paymentStatus === "PENDING") {
          timer = window.setTimeout(checkStatus, 3000);
        }
      } catch (error) {
        if (!active) return;
        setStatusError(
          error?.message || "Không thể kiểm tra trạng thái thanh toán.",
        );
        timer = window.setTimeout(checkStatus, 5000);
      }
    };

    checkStatus();
    return () => {
      active = false;
      window.clearTimeout(timer);
    };
  }, [targetOrderCode]);

  const handleCopy = (text, fieldName) => {
    if (!text) return;
    if (navigator?.clipboard?.writeText) {
      navigator.clipboard.writeText(String(text));
    }
    setCopiedField(fieldName);
    setTimeout(() => setCopiedField(null), 2000);
  };

  const handleConfirmTransfer = async () => {
    if (confirming || paymentStatus === "PAID") return;
    setConfirming(true);
    setConfirmError("");
    try {
      await vnpayApi.confirmTransfer(targetOrderCode);
      setPaymentStatus("PAID");
      handledPaidRef.current = true;
      onPaidRef.current?.();
    } catch (err) {
      setConfirmError(
        err?.response?.data?.message ||
          err?.message ||
          "Không thể xác nhận giao dịch lúc này. Vui lòng thử lại.",
      );
    } finally {
      setConfirming(false);
    }
  };

  const isPaid = paymentStatus === "PAID";
  const isFinalFailure =
    paymentStatus === "FAILED" || paymentStatus === "EXPIRED";
  const isExpiredLocally = remaining <= 0 && paymentStatus === "PENDING";

  // Link ảnh VietQR chính thức có sẵn logo MBBank và khung thanh toán Napas
  const vietQrImageUrl = `https://img.vietqr.io/image/${BANK_INFO.bankCode}-${BANK_INFO.accountNo}-compact2.png?amount=${paymentAmount}&addInfo=${encodeURIComponent(targetOrderCode || "")}&accountName=${encodeURIComponent(BANK_INFO.accountName)}`;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <section className="overflow-hidden rounded-3xl border border-black/5 bg-white shadow-2xl dark:border-white/10 dark:bg-[#141416]">
        
        {/* Header */}
        <div className="bg-gradient-to-r from-[#0B0B0D] via-[#161619] to-[#221F1B] px-6 py-6 text-white sm:px-8 border-b border-[#C6A77B]/20">
          <div className="flex items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              {isPaid ? (
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">
                  <CheckCircle className="h-6 w-6" />
                </div>
              ) : (
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[#C6A77B]/20 text-[#C6A77B] border border-[#C6A77B]/30">
                  <QrCode className="h-6 w-6" />
                </div>
              )}
              <div>
                <p className="text-xs font-bold uppercase tracking-[0.2em] text-[#C6A77B]">
                  Thanh toán Chuyển khoản MBBank / VNPay
                </p>
                <h1 className="mt-0.5 text-xl font-extrabold tracking-tight">
                  {isPaid
                    ? "Giao dịch đã thanh toán thành công"
                    : isFinalFailure
                      ? "Giao dịch chưa hoàn tất"
                      : "Quét mã VietQR để thanh toán"}
                </h1>
              </div>
            </div>

            {/* Countdown timer badge */}
            {!isPaid && !isFinalFailure && (
              <div className="hidden sm:flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 text-xs font-mono border border-white/10">
                <Clock3 className="w-3.5 h-3.5 text-[#C6A77B]" />
                <span>{formatRemaining(remaining)}</span>
              </div>
            )}
          </div>
        </div>

        {/* Body Container */}
        <div className="grid gap-8 p-6 sm:p-8 lg:grid-cols-[1.1fr_1fr] items-start">
          
          {/* Left: Thông tin thanh toán chi tiết & Hướng dẫn */}
          <div className="space-y-4">
            
            {/* Status alerts */}
            {isPaid ? (
              <div
                role="status"
                className="flex items-start gap-3 rounded-2xl border border-emerald-200 bg-emerald-50 p-4 text-sm font-medium text-emerald-800 animate-in fade-in duration-300"
              >
                <CheckCircle className="mt-0.5 h-5 w-5 shrink-0 text-emerald-600" />
                <div>
                  <p className="font-bold text-emerald-900">Giao dịch thành công!</p>
                  <p className="text-xs mt-0.5 text-emerald-700">
                    Hệ thống đã xác nhận thanh toán đơn hàng. Chúng tôi đang đóng gói và chuẩn bị gửi hàng cho bạn.
                  </p>
                </div>
              </div>
            ) : isFinalFailure ? (
              <div
                role="alert"
                className="flex items-start gap-2.5 rounded-2xl border border-rose-200 bg-rose-50 p-4 text-sm font-medium text-rose-700"
              >
                <AlertCircle className="mt-0.5 h-5 w-5 shrink-0" />
                <span>
                  {paymentStatus === "EXPIRED"
                    ? "Đơn thanh toán đã hết thời gian hiệu lực."
                    : "Giao dịch chưa được xác nhận thành công."}
                </span>
              </div>
            ) : (
              <div className="flex items-start gap-2.5 rounded-2xl border border-[#C6A77B]/30 bg-[#C6A77B]/10 p-3.5 text-xs leading-relaxed text-zinc-700 dark:text-zinc-200">
                <Clock3 className="mt-0.5 h-4 w-4 shrink-0 text-[#A88452]" />
                <div>
                  Hoàn tất chuyển khoản trong{" "}
                  <strong className="font-mono text-[#A88452] dark:text-[#E2CEAE] font-bold">
                    {formatRemaining(remaining)}
                  </strong>
                  . Vui lòng nhập đúng nội dung chuyển khoản để đơn hàng được duyệt tự động.
                </div>
              </div>
            )}

            {/* Thẻ thông tin tài khoản ngân hàng MBBank */}
            <div className="rounded-2xl border border-zinc-200/80 bg-zinc-50/70 p-5 dark:border-white/10 dark:bg-white/[0.03] space-y-3.5">
              <div className="flex items-center justify-between pb-2 border-b border-zinc-200/60 dark:border-white/10">
                <span className="text-xs font-extrabold uppercase tracking-wider text-zinc-600 dark:text-zinc-300 flex items-center gap-1.5">
                  <Building2 className="w-4 h-4 text-[#C6A77B]" />
                  Tài khoản người nhận
                </span>
                <span className="text-[10px] px-2 py-0.5 rounded-full bg-blue-50 text-blue-700 font-bold border border-blue-200">
                  MBBank 24/7
                </span>
              </div>

              {/* Ngân hàng */}
              <div className="flex items-center justify-between text-xs">
                <span className="text-zinc-500 dark:text-zinc-400">Ngân hàng:</span>
                <span className="font-bold text-[#0B0B0D] dark:text-white text-right">
                  {BANK_INFO.bankName}
                </span>
              </div>

              {/* Số tài khoản */}
              <div className="flex items-center justify-between text-xs">
                <span className="text-zinc-500 dark:text-zinc-400 flex items-center gap-1">
                  <CreditCard className="w-3.5 h-3.5 text-zinc-400" />
                  Số tài khoản:
                </span>
                <div className="flex items-center gap-1.5">
                  <span className="font-mono font-extrabold text-sm text-[#0B0B0D] dark:text-white tracking-wider">
                    {BANK_INFO.accountNo}
                  </span>
                  <button
                    type="button"
                    onClick={() => handleCopy(BANK_INFO.accountNo, "accountNo")}
                    className="p-1 rounded-lg hover:bg-zinc-200 dark:hover:bg-white/10 text-zinc-600 dark:text-zinc-300 transition"
                    title="Sao chép số tài khoản"
                  >
                    {copiedField === "accountNo" ? (
                      <Check className="w-3.5 h-3.5 text-emerald-600" />
                    ) : (
                      <Copy className="w-3.5 h-3.5" />
                    )}
                  </button>
                </div>
              </div>

              {/* Tên chủ tài khoản */}
              <div className="flex items-center justify-between text-xs">
                <span className="text-zinc-500 dark:text-zinc-400 flex items-center gap-1">
                  <User className="w-3.5 h-3.5 text-zinc-400" />
                  Chủ tài khoản:
                </span>
                <div className="flex items-center gap-1.5">
                  <span className="font-extrabold text-[#0B0B0D] dark:text-white uppercase">
                    {BANK_INFO.accountName}
                  </span>
                  <button
                    type="button"
                    onClick={() => handleCopy(BANK_INFO.accountName, "accountName")}
                    className="p-1 rounded-lg hover:bg-zinc-200 dark:hover:bg-white/10 text-zinc-600 dark:text-zinc-300 transition"
                    title="Sao chép tên chủ tài khoản"
                  >
                    {copiedField === "accountName" ? (
                      <Check className="w-3.5 h-3.5 text-emerald-600" />
                    ) : (
                      <Copy className="w-3.5 h-3.5" />
                    )}
                  </button>
                </div>
              </div>

              {/* Số tiền cần thanh toán */}
              <div className="flex items-center justify-between text-xs pt-1 border-t border-dashed border-zinc-200 dark:border-white/10">
                <span className="text-zinc-500 dark:text-zinc-400">Số tiền thanh toán:</span>
                <div className="flex items-center gap-1.5">
                  <span className="text-lg font-black text-[#A88452] dark:text-[#E2CEAE] font-mono">
                    {formatVND(paymentAmount)}
                  </span>
                  <button
                    type="button"
                    onClick={() => handleCopy(paymentAmount, "amount")}
                    className="p-1 rounded-lg hover:bg-zinc-200 dark:hover:bg-white/10 text-zinc-600 dark:text-zinc-300 transition"
                    title="Sao chép số tiền"
                  >
                    {copiedField === "amount" ? (
                      <Check className="w-3.5 h-3.5 text-emerald-600" />
                    ) : (
                      <Copy className="w-3.5 h-3.5" />
                    )}
                  </button>
                </div>
              </div>

              {/* Nội dung chuyển khoản */}
              <div className="flex items-center justify-between text-xs p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/20">
                <div className="min-w-0">
                  <span className="text-[10px] uppercase font-bold text-amber-800 dark:text-amber-300 block">
                    Nội dung chuyển khoản (Bắt buộc):
                  </span>
                  <span className="font-mono font-extrabold text-sm text-[#0B0B0D] dark:text-white truncate block">
                    {targetOrderCode || "—"}
                  </span>
                </div>
                <button
                  type="button"
                  onClick={() => handleCopy(targetOrderCode, "orderCode")}
                  className="px-2.5 py-1 rounded-lg bg-white dark:bg-black text-[#0B0B0D] dark:text-white font-bold text-xs flex items-center gap-1 shadow-sm border border-black/10 dark:border-white/20 hover:bg-zinc-100 transition shrink-0 cursor-pointer"
                >
                  {copiedField === "orderCode" ? (
                    <>
                      <Check className="w-3 h-3 text-emerald-600" />
                      <span className="text-[11px] text-emerald-600">Đã chép</span>
                    </>
                  ) : (
                    <>
                      <Copy className="w-3 h-3" />
                      <span className="text-[11px]">Sao chép</span>
                    </>
                  )}
                </button>
              </div>
            </div>

            {/* Confirm Transfer Action Button */}
            {!isPaid && !isFinalFailure && (
              <div className="space-y-2 pt-1">
                {confirmError && (
                  <p className="text-xs text-rose-600 font-semibold">{confirmError}</p>
                )}
                <button
                  type="button"
                  onClick={handleConfirmTransfer}
                  disabled={confirming}
                  className="w-full py-3.5 px-6 rounded-2xl bg-[#0B0B0D] hover:bg-black text-[#C6A77B] hover:text-[#e4c9a4] font-extrabold text-xs uppercase tracking-widest flex items-center justify-center gap-2 shadow-xl transition disabled:opacity-60 cursor-pointer"
                >
                  {confirming ? (
                    <>
                      <Loader2 className="w-4 h-4 animate-spin text-[#C6A77B]" />
                      <span>Đang xác nhận giao dịch...</span>
                    </>
                  ) : (
                    <>
                      <ShieldCheck className="w-4 h-4 text-[#C6A77B]" />
                      <span>Tôi đã chuyển khoản thành công</span>
                    </>
                  )}
                </button>
                <p className="text-[11px] text-center text-zinc-400">
                  Nhấn xác nhận sau khi bạn đã thực hiện chuyển tiền thành công trên ứng dụng ngân hàng.
                </p>
              </div>
            )}

            {/* Optional gateway link */}
            {session?.paymentUrl &&
              !isPaid &&
              !isFinalFailure &&
              !isExpiredLocally && (
                <div className="pt-2 text-center">
                  <a
                    href={session.paymentUrl}
                    target="_blank"
                    rel="noreferrer"
                    className="inline-flex items-center gap-1.5 text-xs font-semibold text-zinc-500 hover:text-[#0B0B0D] dark:hover:text-white underline transition"
                  >
                    <ExternalLink className="h-3.5 w-3.5" />
                    Hoặc mở giao diện cổng thanh toán VNPay
                  </a>
                </div>
              )}
          </div>

          {/* Right: Mã QR VietQR MBBank chính thức */}
          <div className="flex flex-col items-center justify-center p-6 rounded-3xl bg-zinc-50 dark:bg-white/[0.02] border border-black/5 dark:border-white/10 text-center">
            <div className="mb-3">
              <span className="text-[11px] font-extrabold uppercase tracking-wider text-[#A88452] dark:text-[#E2CEAE]">
                Mã VietQR Tự Động
              </span>
              <p className="text-xs text-zinc-500 dark:text-zinc-400 mt-0.5">
                Mở app ngân hàng bất kỳ để quét mã
              </p>
            </div>

            <div className="relative rounded-2xl overflow-hidden border-2 border-[#C6A77B]/30 bg-white p-2.5 shadow-lg">
              <img
                src={qrLoadedError && session?.qrCodeDataUrl ? session.qrCodeDataUrl : vietQrImageUrl}
                alt="Mã QR thanh toán MBBank"
                onError={() => {
                  if (!qrLoadedError) setQrLoadedError(true);
                }}
                className="w-64 h-64 sm:w-72 sm:h-72 object-contain"
              />
            </div>

            <div className="mt-3.5 text-center">
              <p className="text-xs font-bold text-[#0B0B0D] dark:text-white">
                MBBank · {BANK_INFO.accountNo}
              </p>
              <p className="text-[11px] font-semibold text-zinc-400 uppercase mt-0.5">
                {BANK_INFO.accountName}
              </p>
              <p className="text-[10px] text-zinc-400 mt-2 max-w-xs leading-relaxed">
                Quét mã trên sẽ tự động điền đúng Số tài khoản, Tên người nhận và Số tiền.
              </p>
            </div>
          </div>
        </div>

        {/* Footer Navigation */}
        <div className="border-t border-black/5 px-6 py-4 flex items-center justify-between dark:border-white/10 sm:px-8 bg-zinc-50/50 dark:bg-white/[0.02]">
          <span className="text-xs text-zinc-400">
            Cần hỗ trợ thanh toán? Liên hệ hotline atelier
          </span>
          <button
            type="button"
            onClick={onContinue}
            className="rounded-full bg-[#C6A77B] px-6 py-2.5 text-xs font-bold uppercase tracking-wider text-[#0B0B0D] transition hover:bg-[#D8BB91] cursor-pointer shadow-md"
          >
            {isPaid ? "Xem chi tiết đơn hàng" : "Quay lại lịch sử đơn hàng"}
          </button>
        </div>
      </section>
    </div>
  );
};
