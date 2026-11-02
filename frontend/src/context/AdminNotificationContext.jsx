import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { CheckCircle, AlertTriangle, AlertCircle, Info, X, HelpCircle } from 'lucide-react';

const AdminNotificationContext = createContext(null);

export const AdminNotificationProvider = ({ children }) => {
  const [toasts, setToasts] = useState([]);
  const [confirmModal, setConfirmModal] = useState(null);

  const removeToast = useCallback((id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const showToast = useCallback((type, message, title) => {
    if (!message) return;
    const id = Date.now() + Math.random();
    setToasts((prev) => [...prev, { id, type, message, title }]);
    setTimeout(() => {
      removeToast(id);
    }, 4500);
  }, [removeToast]);

  const notifySuccess = useCallback((message, title = 'Thành công') => {
    showToast('success', message, title);
  }, [showToast]);

  const notifyError = useCallback((message, title = 'Có lỗi xảy ra') => {
    showToast('error', message, title);
  }, [showToast]);

  const notifyWarning = useCallback((message, title = 'Lưu ý') => {
    showToast('warning', message, title);
  }, [showToast]);

  const showConfirm = useCallback(({
    title = 'Xác nhận thao tác',
    message = 'Bạn có chắc chắn muốn thực hiện thao tác này?',
    type = 'danger', // 'danger' | 'warning' | 'info'
    confirmText = 'Xác nhận',
    cancelText = 'Hủy bỏ',
  }) => {
    return new Promise((resolve) => {
      setConfirmModal({
        title,
        message,
        type,
        confirmText,
        cancelText,
        resolve: (val) => {
          setConfirmModal(null);
          resolve(val);
        },
      });
    });
  }, []);

  // Keyboard shortcut to close confirm modal on Escape
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Escape' && confirmModal) {
        confirmModal.resolve(false);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [confirmModal]);

  return (
    <AdminNotificationContext.Provider
      value={{
        showToast,
        notifySuccess,
        notifyError,
        notifyWarning,
        showConfirm,
      }}
    >
      {children}

      {/* Floating Toast notifications container (Fixed bottom-right) */}
      <div className="fixed bottom-6 right-6 z-[9998] flex flex-col-reverse gap-2.5 max-w-sm w-[calc(100vw-3rem)] pointer-events-none">
        {toasts.map((toast) => (
          <div
            key={toast.id}
            className={`pointer-events-auto p-4 rounded-2xl shadow-2xl border flex items-start gap-3 backdrop-blur-md animate-in slide-in-from-bottom-3 fade-in duration-300 transition-all ${
              toast.type === 'success'
                ? 'bg-[#0B0B0D]/95 text-white border-[#C6A77B]/40 shadow-black/30'
                : toast.type === 'warning'
                ? 'bg-[#181408]/95 text-amber-100 border-amber-800/80 shadow-amber-950/40'
                : 'bg-[#18080a]/95 text-rose-100 border-rose-800/80 shadow-rose-950/40'
            }`}
          >
            <div className="p-1 shrink-0 mt-0.5">
              {toast.type === 'success' ? (
                <div className="w-6 h-6 rounded-full bg-[#C6A77B]/20 text-[#C6A77B] flex items-center justify-center">
                  <CheckCircle className="w-4 h-4" />
                </div>
              ) : toast.type === 'warning' ? (
                <div className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-400 flex items-center justify-center">
                  <AlertTriangle className="w-4 h-4" />
                </div>
              ) : (
                <div className="w-6 h-6 rounded-full bg-rose-500/20 text-rose-400 flex items-center justify-center">
                  <AlertCircle className="w-4 h-4" />
                </div>
              )}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-xs font-bold uppercase tracking-wider text-[#C6A77B]">
                {toast.title || (toast.type === 'success' ? 'Thành công' : toast.type === 'warning' ? 'Lưu ý' : 'Thông báo lỗi')}
              </p>
              <p className="text-xs text-zinc-300 mt-1 leading-relaxed break-words">
                {toast.message}
              </p>
            </div>
            <button
              type="button"
              onClick={() => removeToast(toast.id)}
              className="text-zinc-400 hover:text-white p-1 rounded-lg transition shrink-0 cursor-pointer"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        ))}
      </div>

      {/* Confirmation Modal */}
      {confirmModal && (
        <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div
            className="fixed inset-0"
            onClick={() => confirmModal.resolve(false)}
          />
          <div className="relative w-full max-w-md bg-white dark:bg-[#141416] rounded-3xl p-6 sm:p-7 shadow-2xl border border-black/10 dark:border-white/10 z-10 space-y-5 text-center animate-in zoom-in-95 duration-200">
            {/* Icon badge */}
            <div
              className={`w-14 h-14 rounded-2xl mx-auto flex items-center justify-center border shadow-sm ${
                confirmModal.type === 'danger'
                  ? 'bg-rose-50 dark:bg-rose-950/40 text-rose-600 dark:text-rose-400 border-rose-100 dark:border-rose-900/50'
                  : confirmModal.type === 'warning'
                  ? 'bg-amber-50 dark:bg-amber-950/40 text-amber-600 dark:text-amber-400 border-amber-100 dark:border-amber-900/50'
                  : 'bg-[#C6A77B]/15 text-[#8A653B] dark:text-[#C6A77B] border-[#C6A77B]/30'
              }`}
            >
              {confirmModal.type === 'danger' ? (
                <AlertTriangle className="w-7 h-7" />
              ) : confirmModal.type === 'warning' ? (
                <AlertCircle className="w-7 h-7" />
              ) : (
                <HelpCircle className="w-7 h-7" />
              )}
            </div>

            {/* Title & message */}
            <div className="space-y-1.5">
              <h3 className="text-xl font-extrabold text-[#0B0B0D] dark:text-white tracking-tight">
                {confirmModal.title}
              </h3>
              <p className="text-xs text-zinc-500 dark:text-zinc-400 leading-relaxed max-w-sm mx-auto">
                {confirmModal.message}
              </p>
            </div>

            {/* Buttons */}
            <div className="flex gap-3 pt-2">
              <button
                type="button"
                onClick={() => confirmModal.resolve(false)}
                className="flex-1 py-3 rounded-full border border-zinc-200 dark:border-zinc-700 text-zinc-700 dark:text-zinc-300 hover:bg-zinc-100 dark:hover:bg-zinc-800 text-xs font-bold uppercase tracking-wider transition cursor-pointer"
              >
                {confirmModal.cancelText}
              </button>
              <button
                type="button"
                onClick={() => confirmModal.resolve(true)}
                className={`flex-1 py-3 rounded-full text-white text-xs font-bold uppercase tracking-wider transition shadow-lg cursor-pointer ${
                  confirmModal.type === 'danger'
                    ? 'bg-rose-600 hover:bg-rose-700 shadow-rose-600/25'
                    : confirmModal.type === 'warning'
                    ? 'bg-amber-600 hover:bg-amber-700 shadow-amber-600/25'
                    : 'bg-[#0B0B0D] hover:bg-black text-[#C6A77B] shadow-black/25'
                }`}
              >
                {confirmModal.confirmText}
              </button>
            </div>
          </div>
        </div>
      )}
    </AdminNotificationContext.Provider>
  );
};

export const useAdminNotification = () => {
  const context = useContext(AdminNotificationContext);
  if (!context) {
    // Fallback if rendered outside provider
    return {
      showToast: (type, msg) => console.log(`[Toast ${type}]: ${msg}`),
      notifySuccess: (msg) => console.log(`[Success]: ${msg}`),
      notifyError: (msg) => console.error(`[Error]: ${msg}`),
      notifyWarning: (msg) => console.warn(`[Warning]: ${msg}`),
      showConfirm: async () => window.confirm('Xác nhận thao tác?'),
    };
  }
  return context;
};

/**
 * Reusable standalone Toast component that floats at fixed top-right.
 * Used for views with local `[feedback, setFeedback]` state to replace ugly inline banners.
 */
export const AdminToast = ({ feedback, onClose }) => {
  useEffect(() => {
    if (!feedback) return;
    const timer = setTimeout(() => {
      onClose?.();
    }, 4500);
    return () => clearTimeout(timer);
  }, [feedback, onClose]);

  if (!feedback) return null;

  const isSuccess = feedback.type === 'success';
  const isWarning = feedback.type === 'warning';

  return (
    <div className="fixed bottom-6 right-6 z-[9998] max-w-sm w-[calc(100vw-3rem)] animate-in slide-in-from-bottom-4 fade-in duration-300">
      <div
        className={`p-4 rounded-2xl shadow-2xl border flex items-start gap-3 backdrop-blur-md transition-all ${
          isSuccess
            ? 'bg-[#0B0B0D]/95 text-white border-[#C6A77B]/40 shadow-black/30'
            : isWarning
            ? 'bg-[#181408]/95 text-amber-100 border-amber-800/80 shadow-amber-950/40'
            : 'bg-[#18080a]/95 text-rose-100 border-rose-800/80 shadow-rose-950/40'
        }`}
      >
        <div className="p-1 shrink-0 mt-0.5">
          {isSuccess ? (
            <div className="w-6 h-6 rounded-full bg-[#C6A77B]/20 text-[#C6A77B] flex items-center justify-center">
              <CheckCircle className="w-4 h-4" />
            </div>
          ) : isWarning ? (
            <div className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-400 flex items-center justify-center">
              <AlertTriangle className="w-4 h-4" />
            </div>
          ) : (
            <div className="w-6 h-6 rounded-full bg-rose-500/20 text-rose-400 flex items-center justify-center">
              <AlertCircle className="w-4 h-4" />
            </div>
          )}
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-xs font-bold uppercase tracking-wider text-[#C6A77B]">
            {isSuccess ? 'Thành công' : isWarning ? 'Lưu ý' : 'Thông báo lỗi'}
          </p>
          <p className="text-xs text-zinc-300 mt-1 leading-relaxed break-words">
            {feedback.message}
          </p>
        </div>
        <button
          type="button"
          onClick={() => onClose?.()}
          className="text-zinc-400 hover:text-white p-1 rounded-lg transition shrink-0 cursor-pointer"
        >
          <X className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};

