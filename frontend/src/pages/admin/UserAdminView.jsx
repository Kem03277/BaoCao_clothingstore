import React, { useCallback, useEffect, useRef, useState } from 'react';
import { Lock, Unlock, Search, CheckCircle, AlertCircle, Loader2, RefreshCw, X, Shield, Sparkles, Upload, Eye, UserRound, Mail, Phone, CalendarDays } from 'lucide-react';
import { customerApi } from '../../api';
import { AdminPagination } from './AdminPagination';
import { useAdminNotification, AdminToast } from '../../context/AdminNotificationContext';

export const UserAdminView = () => {
  const { showConfirm } = useAdminNotification();
  const [users, setUsers] = useState([]);
  const [totalItems, setTotalItems] = useState(0);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [updatingId, setUpdatingId] = useState(null);
  const [uploadingAvatarId, setUploadingAvatarId] = useState(null);
  const [feedback, setFeedback] = useState(null);
  const [selectedUser, setSelectedUser] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [detailError, setDetailError] = useState('');
  const requestSequence = useRef(0);

  const fetchUsers = useCallback(async (page) => {
    const pageIndex = typeof page === 'number' ? page : Math.max(0, currentPage - 1);
    const requestId = ++requestSequence.current;
    setLoading(true);
    try {
      const result = await customerApi.getUsersPage({
        keyword: search.trim() || undefined,
        page: pageIndex,
        size: pageSize,
      });
      if (requestId === requestSequence.current) {
        setUsers(result.content || []);
        setTotalItems(result.totalElements || 0);
      }
    } catch (err) {
      if (requestId === requestSequence.current) {
        setFeedback({ type: 'error', message: 'Lỗi tải danh sách người dùng: ' + err.message });
      }
    } finally {
      if (requestId === requestSequence.current) setLoading(false);
    }
  }, [currentPage, search]);

  useEffect(() => {
    const timer = setTimeout(() => fetchUsers(), 250);
    return () => clearTimeout(timer);
  }, [fetchUsers]);

  const handleToggleStatus = async (user) => {
    const newStatus = user.status === 'ACTIVE' ? 'LOCKED' : 'ACTIVE';
    const isLocking = newStatus === 'LOCKED';
    const actionLabel = isLocking ? 'khóa' : 'mở khóa';

    const confirmed = await showConfirm({
      title: `${isLocking ? 'Khóa' : 'Mở khóa'} tài khoản người dùng`,
      message: `Bạn có chắc chắn muốn ${actionLabel} tài khoản "${user.fullName || user.email}"?`,
      type: isLocking ? 'danger' : 'info',
      confirmText: isLocking ? 'Khóa tài khoản' : 'Mở khóa',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;

    setUpdatingId(user.id);
    try {
      await customerApi.updateUserStatus(user.id, newStatus);
      setFeedback({ type: 'success', message: `Đã ${actionLabel} tài khoản thành công` });
      fetchUsers();
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi cập nhật trạng thái: ' + err.message });
    } finally {
      setUpdatingId(null);
    }
  };

  const handleUploadAvatar = async (user, file) => {
    if (!file) return;

    setUploadingAvatarId(user.id);
    try {
      const updatedUser = await customerApi.updateUserAvatar(user.id, file);
      setUsers((currentUsers) => currentUsers.map((currentUser) => (
        currentUser.id === user.id
          ? { ...currentUser, avatarUrl: updatedUser.avatarUrl }
          : currentUser
      )));
      setFeedback({ type: 'success', message: `Đã cập nhật ảnh đại diện cho ${user.fullName || user.email}` });
    } catch (err) {
      setFeedback({ type: 'error', message: 'Lỗi tải ảnh đại diện: ' + (err.message || 'Vui lòng thử lại') });
    } finally {
      setUploadingAvatarId(null);
    }
  };

  const handleViewDetails = async (user) => {
    setSelectedUser(null);
    setDetailError('');
    setDetailLoading(true);
    try {
      setSelectedUser(await customerApi.getUserById(user.id));
    } catch (err) {
      setDetailError(`Không thể tải chi tiết người dùng: ${err.message || 'Vui lòng thử lại.'}`);
    } finally {
      setDetailLoading(false);
    }
  };

  const formatCreatedAt = (value) => {
    if (!value) return 'Chưa có thông tin';
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? 'Chưa có thông tin' : date.toLocaleString('vi-VN');
  };

  const totalPages = Math.max(1, Math.ceil(totalItems / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedUsers = users;

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Toast Feedback */}
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Phân quyền & Khách hàng</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Quản Lý Khách Hàng & Tài Khoản
          </h2>
          <p className="text-xs text-zinc-500 mt-1">
            Theo dõi danh sách khách hàng VIP, nhân sự vận hành và kiểm soát quyền truy cập hệ thống
          </p>
        </div>

        <button
          onClick={() => fetchUsers()}
          disabled={loading}
          className="self-start sm:self-auto flex items-center gap-2 px-5 py-2.5 rounded-full border border-black/10 bg-white hover:bg-zinc-50 text-[#0B0B0D] text-xs font-bold uppercase tracking-wider shadow-xs transition hover:border-[#C6A77B]/40 cursor-pointer disabled:opacity-50"
        >
          <RefreshCw className={`w-3.5 h-3.5 text-[#C6A77B] ${loading ? 'animate-spin' : ''}`} />
          <span>Tải lại</span>
        </button>
      </div>

      {/* Search Bar */}
      <div className="bg-white p-4 rounded-3xl border border-black/5 shadow-sm">
        <div className="relative w-full sm:w-96">
          <Search className="w-4 h-4 absolute left-3.5 top-3 text-zinc-400" />
          <input
            type="text"
            placeholder="Tìm theo họ tên, email hoặc số điện thoại..."
            value={search}
            onChange={(e) => { setSearch(e.target.value); setCurrentPage(1); }}
            className="w-full pl-10 pr-4 py-2.5 text-xs rounded-full border border-zinc-200 bg-[#F8F7F4] focus:bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition"
          />
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-16 text-center flex flex-col items-center justify-center gap-3 text-zinc-400">
            <Loader2 className="w-7 h-7 animate-spin text-[#C6A77B]" />
            <span className="text-xs font-medium">Đang tải danh sách tài khoản...</span>
          </div>
        ) : users.length === 0 ? (
          <div className="p-16 text-center text-zinc-400 text-xs">
            Không tìm thấy tài khoản người dùng nào phù hợp.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] text-zinc-600 font-bold uppercase tracking-wider text-[10px] border-b border-black/5">
                <tr>
                  <th className="py-3.5 px-5">Tài khoản</th>
                  <th className="py-3.5 px-5">Email liên hệ</th>
                  <th className="py-3.5 px-5">Số điện thoại</th>
                  <th className="py-3.5 px-5">Vai trò</th>
                  <th className="py-3.5 px-5">Trạng thái</th>
                  <th className="py-3.5 px-5 text-right">Thao tác</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5 text-[#0B0B0D]">
                {paginatedUsers.map((u) => {
                  const isAdminRole = u.roleCode === 'ROLE_ADMIN' || u.roleCode === 'ADMIN';
                  const isStaffRole = u.roleCode === 'ROLE_STAFF' || u.roleCode === 'STAFF';
                  const isLocked = u.status === 'LOCKED' || u.status === 'INACTIVE';

                  return (
                    <tr key={u.id} className="hover:bg-[#F8F7F4]/50 transition-colors">
                      <td className="py-3.5 px-5">
                        <div className="flex items-center gap-3">
                          <div className="relative shrink-0">
                            {u.avatarUrl ? (
                              <img src={u.avatarUrl} alt={u.fullName} className="w-10 h-10 rounded-xl object-cover border border-black/10" />
                            ) : (
                              <div className="w-10 h-10 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center font-bold text-xs shadow-2xs">
                                {u.fullName?.charAt(0) || 'U'}
                              </div>
                            )}
                            <label
                              title={`Tải ảnh đại diện cho ${u.fullName || u.email}`}
                              className={`absolute -right-1 -bottom-1 w-5 h-5 flex items-center justify-center rounded-full border-2 border-white bg-[#C6A77B] text-[#0B0B0D] hover:bg-[#b99768] transition cursor-pointer ${uploadingAvatarId === u.id ? 'opacity-70' : ''}`}
                            >
                              {uploadingAvatarId === u.id ? (
                                <Loader2 className="w-4 h-4 animate-spin" />
                              ) : (
                                <Upload className="w-4 h-4" />
                              )}
                              <input
                                type="file"
                                accept="image/jpeg,image/png,image/webp"
                                className="sr-only"
                                aria-label={`Tải ảnh đại diện cho ${u.fullName || u.email}`}
                                disabled={uploadingAvatarId === u.id}
                                onChange={(event) => {
                                  handleUploadAvatar(u, event.target.files?.[0]);
                                  event.target.value = '';
                                }}
                              />
                            </label>
                          </div>
                          <div>
                            <p className="font-bold text-[#0B0B0D]">{u.fullName || 'Khách hàng'}</p>
                            <p className="text-[10px] text-zinc-400 font-mono">ID #{u.id}</p>
                          </div>
                        </div>
                      </td>

                      <td className="py-3.5 px-5 text-zinc-600 font-mono">
                        {u.email}
                      </td>

                      <td className="py-3.5 px-5 text-zinc-600 font-mono">
                        {u.phone || 'Chưa cung cấp'}
                      </td>

                      <td className="py-3.5 px-5">
                        <span
                          className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${
                            isAdminRole
                              ? 'bg-[#0B0B0D] text-[#C6A77B] border border-[#C6A77B]/30'
                              : isStaffRole
                              ? 'bg-amber-50 text-amber-800 border border-amber-200'
                              : 'bg-zinc-100 text-zinc-700'
                          }`}
                        >
                          {isAdminRole && <Shield className="w-3 h-3 text-[#C6A77B]" />}
                          {u.roleCode || 'ROLE_CUSTOMER'}
                        </span>
                      </td>

                      <td className="py-3.5 px-5">
                        {isLocked ? (
                          <span className="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-rose-50 text-rose-800 border border-rose-200">
                            Đã khóa
                          </span>
                        ) : (
                          <span className="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-800 border border-emerald-200">
                            Hoạt động
                          </span>
                        )}
                      </td>

                      <td className="py-3.5 px-5 text-right">
                        <div className="flex items-center justify-end gap-2">
                          <button
                            type="button"
                            onClick={() => handleViewDetails(u)}
                            className="px-3.5 py-1.5 rounded-full text-[11px] font-bold uppercase tracking-wider transition flex items-center gap-1.5 border border-[#C6A77B]/40 text-[#8A653B] bg-[#C6A77B]/10 hover:bg-[#C6A77B]/20"
                            aria-label={`Xem chi tiết ${u.fullName || u.email}`}
                          >
                            <Eye className="w-3 h-3" />
                            <span>Chi tiết</span>
                          </button>
                          {!isAdminRole && (
                            <button
                              onClick={() => handleToggleStatus(u)}
                              disabled={updatingId === u.id}
                              className={`px-3.5 py-1.5 rounded-full text-[11px] font-bold uppercase tracking-wider transition flex items-center gap-1.5 cursor-pointer ${
                                isLocked
                                  ? 'bg-emerald-50 text-emerald-800 hover:bg-emerald-100 border border-emerald-200'
                                  : 'bg-rose-50 text-rose-800 hover:bg-rose-100 border border-rose-200'
                              }`}
                            >
                              {updatingId === u.id ? (
                                <Loader2 className="w-3 h-3 animate-spin" />
                              ) : isLocked ? (
                                <Unlock className="w-3 h-3" />
                              ) : (
                                <Lock className="w-3 h-3" />
                              )}
                              <span>{isLocked ? 'Mở khóa' : 'Khóa'}</span>
                            </button>
                          )}
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
        totalItems={totalItems}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {(detailLoading || detailError || selectedUser) && (
        <div
          className="fixed inset-0 z-[70] flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm"
          role="presentation"
          onMouseDown={(event) => {
            if (event.target === event.currentTarget && !detailLoading) {
              setSelectedUser(null);
              setDetailError('');
            }
          }}
        >
          <section
            role="dialog"
            aria-modal="true"
            aria-labelledby="user-detail-title"
            className="w-full max-w-lg overflow-hidden rounded-3xl border border-black/10 bg-white shadow-2xl"
          >
            <header className="flex items-center justify-between border-b border-black/5 px-6 py-5">
              <div>
                <p className="text-[10px] font-bold uppercase tracking-[0.2em] text-[#A57E4F]">Tài khoản người dùng</p>
                <h3 id="user-detail-title" className="mt-1 text-lg font-extrabold text-[#0B0B0D]">Chi tiết người dùng</h3>
              </div>
              <button
                type="button"
                onClick={() => {
                  setSelectedUser(null);
                  setDetailError('');
                }}
                disabled={detailLoading}
                className="rounded-full p-2 text-zinc-400 transition hover:bg-zinc-100 hover:text-zinc-700 disabled:opacity-50"
                aria-label="Đóng chi tiết người dùng"
              >
                <X className="h-5 w-5" />
              </button>
            </header>

            {detailLoading ? (
              <div className="flex items-center justify-center gap-3 p-12 text-sm text-zinc-500">
                <Loader2 className="h-5 w-5 animate-spin text-[#A57E4F]" />
                Đang tải thông tin người dùng...
              </div>
            ) : detailError ? (
              <p className="p-6 text-sm text-rose-700" role="alert">{detailError}</p>
            ) : selectedUser && (
              <div className="space-y-5 p-6">
                <div className="flex items-center gap-4 rounded-2xl bg-[#F8F7F4] p-4">
                  {selectedUser.avatarUrl ? (
                    <img src={selectedUser.avatarUrl} alt="" className="h-14 w-14 rounded-2xl border border-black/10 object-cover" />
                  ) : (
                    <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#0B0B0D] text-[#C6A77B]">
                      <UserRound className="h-6 w-6" />
                    </div>
                  )}
                  <div className="min-w-0">
                    <p className="truncate text-base font-bold text-[#0B0B0D]">{selectedUser.fullName || 'Chưa cập nhật họ tên'}</p>
                    <p className="mt-1 text-xs font-mono text-zinc-500">ID #{selectedUser.id}</p>
                  </div>
                </div>

                <dl className="grid gap-4 sm:grid-cols-2">
                  <div className="rounded-xl border border-black/5 p-3.5">
                    <dt className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-wider text-zinc-400">
                      <Mail className="h-3.5 w-3.5" /> Email
                    </dt>
                    <dd className="mt-2 break-all text-sm text-zinc-800">{selectedUser.email || 'Chưa cung cấp'}</dd>
                  </div>
                  <div className="rounded-xl border border-black/5 p-3.5">
                    <dt className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-wider text-zinc-400">
                      <Phone className="h-3.5 w-3.5" /> Số điện thoại
                    </dt>
                    <dd className="mt-2 text-sm text-zinc-800">{selectedUser.phone || 'Chưa cung cấp'}</dd>
                  </div>
                  <div className="rounded-xl border border-black/5 p-3.5">
                    <dt className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-wider text-zinc-400">
                      <Shield className="h-3.5 w-3.5" /> Vai trò
                    </dt>
                    <dd className="mt-2 text-sm text-zinc-800">{selectedUser.roleName || selectedUser.roleCode || 'Chưa xác định'}</dd>
                  </div>
                  <div className="rounded-xl border border-black/5 p-3.5">
                    <dt className="text-[10px] font-bold uppercase tracking-wider text-zinc-400">Trạng thái</dt>
                    <dd className="mt-2 text-sm font-semibold text-zinc-800">
                      {selectedUser.status === 'ACTIVE' ? 'Đang hoạt động' : selectedUser.status === 'LOCKED' ? 'Đã khóa' : selectedUser.status || 'Chưa xác định'}
                    </dd>
                  </div>
                  <div className="rounded-xl border border-black/5 p-3.5 sm:col-span-2">
                    <dt className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-wider text-zinc-400">
                      <CalendarDays className="h-3.5 w-3.5" /> Ngày tạo tài khoản
                    </dt>
                    <dd className="mt-2 text-sm text-zinc-800">{formatCreatedAt(selectedUser.createdAt)}</dd>
                  </div>
                </dl>
              </div>
            )}
          </section>
        </div>
      )}

    </div>
  );
};
