import React, { useState, useEffect } from 'react';
import {
  User, MapPin, Lock, Plus, Trash2, Edit2, Check, X,
  Camera, Save, ChevronRight, Phone, Mail, Sparkles, Shield
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { addressApi, authApi } from '../api';

const AddressCard = ({ addr, onEdit, onDelete }) => (
  <div className="bg-white border border-black/5 rounded-2xl p-4 flex items-start justify-between gap-3 hover:shadow-md transition">
    <div className="flex items-start gap-3">
      <div className="w-10 h-10 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center shrink-0">
        <MapPin className="w-4 h-4" />
      </div>
      <div>
        <p className="text-sm font-bold text-[#0B0B0D]">{addr.recipientName}</p>
        <p className="text-xs text-zinc-500 mt-0.5">{addr.phone}</p>
        <p className="text-xs text-zinc-600 mt-1 leading-relaxed">
          {addr.addressLine}, {addr.province}
        </p>
      </div>
    </div>
    <div className="flex gap-1 shrink-0">
      <button
        onClick={() => onEdit(addr)}
        className="p-2 rounded-xl text-zinc-400 hover:text-black hover:bg-zinc-100 transition"
        title="Chỉnh sửa"
      >
        <Edit2 className="w-3.5 h-3.5" />
      </button>
      <button
        onClick={() => onDelete(addr.id)}
        className="p-2 rounded-xl text-zinc-400 hover:text-rose-600 hover:bg-rose-50 transition"
        title="Xóa địa chỉ"
      >
        <Trash2 className="w-3.5 h-3.5" />
      </button>
    </div>
  </div>
);

const AddressModal = ({ addr, onSave, onClose }) => {
  const [form, setForm] = useState({
    recipientName: addr?.recipientName || '',
    phone: addr?.phone || '',
    province: addr?.province || 'TP. Hồ Chí Minh',
    addressLine: addr?.addressLine || '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      if (addr?.id) {
        await addressApi.update(addr.id, form);
      } else {
        await addressApi.create(form);
      }
      onSave();
    } catch (err) {
      setError(err?.data?.message || 'Lưu địa chỉ thất bại');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md p-6 border border-black/10">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-bold text-base text-[#0B0B0D]">
            {addr?.id ? 'Chỉnh Sửa Địa Chỉ' : 'Thêm Địa Chỉ Mới'}
          </h3>
          <button onClick={onClose} className="p-2 rounded-full hover:bg-zinc-100 text-zinc-500">
            <X className="w-4 h-4" />
          </button>
        </div>

        {error && (
          <div className="mb-3 p-3 rounded-xl bg-rose-50 text-rose-700 text-xs">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-3">
          <div>
            <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
              Tên người nhận
            </label>
            <input
              type="text"
              value={form.recipientName}
              onChange={(e) => setForm((p) => ({ ...p, recipientName: e.target.value }))}
              required
              className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
            />
          </div>

          <div>
            <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
              Số điện thoại
            </label>
            <input
              type="tel"
              value={form.phone}
              onChange={(e) => setForm((p) => ({ ...p, phone: e.target.value }))}
              required
              className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
            />
          </div>

          <div>
            <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
              Tỉnh / Thành phố
            </label>
            <input
              type="text"
              value={form.province}
              onChange={(e) => setForm((p) => ({ ...p, province: e.target.value }))}
              required
              className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
            />
          </div>

          <div>
            <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1">
              Địa chỉ cụ thể
            </label>
            <input
              type="text"
              value={form.addressLine}
              onChange={(e) => setForm((p) => ({ ...p, addressLine: e.target.value }))}
              required
              className="w-full px-3.5 py-2.5 rounded-xl border border-zinc-200 text-xs focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
            />
          </div>

          <div className="flex gap-3 pt-3">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-zinc-200 text-xs font-bold text-zinc-600 hover:bg-zinc-50"
            >
              Hủy
            </button>
            <button
              type="submit"
              disabled={loading}
              className="flex-1 py-2.5 rounded-xl bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider hover:bg-black transition disabled:opacity-50"
            >
              {loading ? 'Đang lưu...' : 'Lưu thông tin'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export const ProfilePage = ({ onNavigateLogin }) => {
  const { user, isAuthenticated, setUser } = useAuth();

  const [activeTab, setActiveTab] = useState('info');
  const [addresses, setAddresses] = useState([]);
  const [addrLoading, setAddrLoading] = useState(false);
  const [addrModal, setAddrModal] = useState(null);

  // Profile form
  const [profileForm, setProfileForm] = useState({
    fullName: user?.fullName || '',
    phone: user?.phone || '',
  });
  const [profileLoading, setProfileLoading] = useState(false);
  const [profileMsg, setProfileMsg] = useState(null);

  // Avatar upload
  const [avatarLoading, setAvatarLoading] = useState(false);

  // Password form
  const [passForm, setPassForm] = useState({ currentPassword: '', newPassword: '', confirmPassword: '' });
  const [passLoading, setPassLoading] = useState(false);
  const [passMsg, setPassMsg] = useState(null);

  useEffect(() => {
    if (isAuthenticated && activeTab === 'address') {
      loadAddresses();
    }
  }, [isAuthenticated, activeTab]);

  const loadAddresses = async () => {
    setAddrLoading(true);
    try {
      const data = await addressApi.getAll();
      setAddresses(data || []);
    } catch {
      setAddresses([]);
    } finally {
      setAddrLoading(false);
    }
  };

  const handleDeleteAddress = async (id) => {
    if (!confirm('Bạn có chắc muốn xóa địa chỉ này?')) return;
    try {
      await addressApi.delete(id);
      loadAddresses();
    } catch {
      alert('Không thể xóa địa chỉ lúc này');
    }
  };

  const handleUpdateProfile = async (e) => {
    e.preventDefault();
    setProfileLoading(true);
    setProfileMsg(null);
    try {
      const updated = await authApi.updateProfile(profileForm);
      setUser(updated);
      setProfileMsg({ type: 'success', text: 'Cập nhật thông tin cá nhân thành công!' });
    } catch (err) {
      setProfileMsg({ type: 'error', text: err?.data?.message || 'Cập nhật thất bại' });
    } finally {
      setProfileLoading(false);
    }
  };

  const handleAvatarChange = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setAvatarLoading(true);
    try {
      const updated = await authApi.updateOwnAvatar(file);
      setUser(updated);
      setProfileMsg({ type: 'success', text: 'Cập nhật ảnh đại diện thành công!' });
    } catch (err) {
      alert(err?.data?.message || 'Không thể tải ảnh lên');
    } finally {
      setAvatarLoading(false);
    }
  };

  const handleChangePassword = async (e) => {
    e.preventDefault();
    if (passForm.newPassword !== passForm.confirmPassword) {
      setPassMsg({ type: 'error', text: 'Mật khẩu xác nhận không trùng khớp' });
      return;
    }
    setPassLoading(true);
    setPassMsg(null);
    try {
      await authApi.changePassword({
        currentPassword: passForm.currentPassword,
        newPassword: passForm.newPassword,
      });
      setPassMsg({ type: 'success', text: 'Đổi mật khẩu thành công!' });
      setPassForm({ currentPassword: '', newPassword: '', confirmPassword: '' });
    } catch (err) {
      setPassMsg({ type: 'error', text: err?.data?.message || 'Đổi mật khẩu thất bại' });
    } finally {
      setPassLoading(false);
    }
  };

  if (!isAuthenticated) {
    return (
      <div className="max-w-md mx-auto px-4 py-20 text-center space-y-4">
        <div className="w-16 h-16 rounded-full bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center mx-auto shadow-xl">
          <User className="w-8 h-8" />
        </div>
        <h2 className="text-2xl font-bold tracking-tight text-[#0B0B0D]">Vui lòng đăng nhập</h2>
        <p className="text-xs text-zinc-500">
          Đăng nhập tài khoản để quản lý thông tin, địa chỉ nhận hàng và mật khẩu.
        </p>
        <button
          onClick={onNavigateLogin}
          className="mt-4 px-8 py-3.5 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-widest hover:bg-black transition"
        >
          Đăng nhập ngay
        </button>
      </div>
    );
  }

  const tabs = [
    { id: 'info', label: 'Thông tin cá nhân', icon: User },
    { id: 'address', label: 'Sổ địa chỉ', icon: MapPin },
    { id: 'password', label: 'Bảo mật & Mật khẩu', icon: Lock },
  ];

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      
      {/* Profile Header Card */}
      <div className="bg-white rounded-3xl p-6 sm:p-8 border border-black/5 shadow-sm flex flex-col sm:flex-row items-center gap-6">
        <div className="relative group">
          <div className="w-24 h-24 rounded-2xl overflow-hidden bg-[#F8F7F4] border-2 border-[#C6A77B] shadow-md flex items-center justify-center">
            {user?.avatarUrl ? (
              <img src={user.avatarUrl} alt={user.fullName} className="w-full h-full object-cover" />
            ) : (
              <span className="text-3xl font-extrabold text-[#C6A77B]">
                {user?.fullName?.charAt(0) || 'U'}
              </span>
            )}
          </div>
          <label className="absolute -bottom-2 -right-2 p-2 rounded-xl bg-[#0B0B0D] text-white hover:bg-black transition shadow-lg cursor-pointer">
            <Camera className="w-4 h-4 text-[#C6A77B]" />
            <input
              type="file"
              accept="image/*"
              onChange={handleAvatarChange}
              disabled={avatarLoading}
              className="hidden"
            />
          </label>
        </div>

        <div className="text-center sm:text-left flex-1">
          <div className="flex flex-col sm:flex-row sm:items-center gap-2">
            <h1 className="text-2xl font-bold tracking-tight text-[#0B0B0D]">
              {user?.fullName || 'Khách Hàng'}
            </h1>
            <span className="inline-block px-2.5 py-0.5 rounded-full bg-[#C6A77B]/15 text-[#C6A77B] text-[10px] font-bold uppercase tracking-widest self-center sm:self-auto">
              {user?.roleCode || 'MEMBER'}
            </span>
          </div>
          <p className="text-xs text-zinc-500 mt-1 flex items-center justify-center sm:justify-start gap-1.5">
            <Mail className="w-3.5 h-3.5 text-[#C6A77B]" />
            {user?.email}
          </p>
          {user?.phone && (
            <p className="text-xs text-zinc-500 mt-0.5 flex items-center justify-center sm:justify-start gap-1.5">
              <Phone className="w-3.5 h-3.5 text-[#C6A77B]" />
              {user?.phone}
            </p>
          )}
        </div>
      </div>

      {/* Main Tabs and Content */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-8 items-start">
        
        {/* Tab Navigator */}
        <div className="md:col-span-4 bg-white rounded-3xl p-3 border border-black/5 shadow-sm space-y-1">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl text-xs font-bold uppercase tracking-wider transition ${
                activeTab === tab.id
                  ? 'bg-[#0B0B0D] text-white shadow-md'
                  : 'text-zinc-600 hover:bg-zinc-100 hover:text-black'
              }`}
            >
              <tab.icon className={`w-4 h-4 ${activeTab === tab.id ? 'text-[#C6A77B]' : ''}`} />
              <span>{tab.label}</span>
              {activeTab === tab.id && <ChevronRight className="w-3.5 h-3.5 ml-auto" />}
            </button>
          ))}
        </div>

        {/* Tab Panel */}
        <div className="md:col-span-8 bg-white rounded-3xl p-6 sm:p-8 border border-black/5 shadow-sm">
          
          {/* Info Tab */}
          {activeTab === 'info' && (
            <div className="space-y-6">
              <h2 className="text-lg font-bold text-[#0B0B0D]">
                Cập Nhật Thông Tin Cá Nhân
              </h2>

              {profileMsg && (
                <div
                  className={`p-3 rounded-2xl text-xs font-medium ${
                    profileMsg.type === 'success'
                      ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                      : 'bg-rose-50 text-rose-700 border border-rose-200'
                  }`}
                >
                  {profileMsg.text}
                </div>
              )}

              <form onSubmit={handleUpdateProfile} className="space-y-4">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Họ và tên
                  </label>
                  <input
                    type="text"
                    value={profileForm.fullName}
                    onChange={(e) => setProfileForm((f) => ({ ...f, fullName: e.target.value }))}
                    required
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Địa chỉ Email (Cố định theo tài khoản)
                  </label>
                  <input
                    type="email"
                    value={user?.email || ''}
                    disabled
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-100 text-xs sm:text-sm bg-zinc-50 text-zinc-400 cursor-not-allowed"
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Số điện thoại
                  </label>
                  <input
                    type="tel"
                    value={profileForm.phone}
                    onChange={(e) => setProfileForm((f) => ({ ...f, phone: e.target.value }))}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>

                <button
                  type="submit"
                  disabled={profileLoading}
                  className="px-8 py-3 rounded-full bg-[#0B0B0D] hover:bg-black text-white text-xs font-bold uppercase tracking-widest transition flex items-center gap-2 shadow-lg disabled:opacity-50"
                >
                  {profileLoading ? 'Đang lưu...' : 'Lưu thay đổi'}
                </button>
              </form>
            </div>
          )}

          {/* Address Tab */}
          {activeTab === 'address' && (
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-bold text-[#0B0B0D]">
                  Sổ Địa Chỉ Giao Hàng
                </h2>
                <button
                  onClick={() => setAddrModal({})}
                  className="px-4 py-2 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider hover:bg-black transition flex items-center gap-1.5"
                >
                  <Plus className="w-3.5 h-3.5 text-[#C6A77B]" />
                  Thêm mới
                </button>
              </div>

              {addrLoading ? (
                <div className="space-y-3">
                  <div className="h-16 rounded-2xl bg-zinc-100 animate-pulse" />
                </div>
              ) : addresses.length === 0 ? (
                <div className="text-center py-10 border-2 border-dashed border-zinc-200 rounded-3xl p-6">
                  <MapPin className="w-10 h-10 text-zinc-300 mx-auto mb-2" />
                  <p className="text-xs text-zinc-500 font-medium">Bạn chưa lưu địa chỉ nào</p>
                  <button
                    onClick={() => setAddrModal({})}
                    className="mt-3 px-5 py-2 rounded-full bg-[#0B0B0D] text-white text-xs font-bold uppercase tracking-wider hover:bg-black transition"
                  >
                    Thêm địa chỉ ngay
                  </button>
                </div>
              ) : (
                <div className="space-y-3">
                  {addresses.map((addr) => (
                    <AddressCard
                      key={addr.id}
                      addr={addr}
                      onEdit={(a) => setAddrModal(a)}
                      onDelete={handleDeleteAddress}
                    />
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Password Tab */}
          {activeTab === 'password' && (
            <div className="space-y-6">
              <h2 className="text-lg font-bold text-[#0B0B0D]">
                Thay Đổi Mật Khẩu
              </h2>

              {passMsg && (
                <div
                  className={`p-3 rounded-2xl text-xs font-medium ${
                    passMsg.type === 'success'
                      ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                      : 'bg-rose-50 text-rose-700 border border-rose-200'
                  }`}
                >
                  {passMsg.text}
                </div>
              )}

              <form onSubmit={handleChangePassword} className="space-y-4 max-w-sm">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Mật khẩu hiện tại
                  </label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    value={passForm.currentPassword}
                    onChange={(e) => setPassForm((p) => ({ ...p, currentPassword: e.target.value }))}
                    required
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Mật khẩu mới
                  </label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    value={passForm.newPassword}
                    onChange={(e) => setPassForm((p) => ({ ...p, newPassword: e.target.value }))}
                    required
                    minLength={6}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Xác nhận mật khẩu mới
                  </label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    value={passForm.confirmPassword}
                    onChange={(e) => setPassForm((p) => ({ ...p, confirmPassword: e.target.value }))}
                    required
                    minLength={6}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  />
                </div>

                <button
                  type="submit"
                  disabled={passLoading}
                  className="px-8 py-3 rounded-full bg-[#0B0B0D] hover:bg-black text-white text-xs font-bold uppercase tracking-widest transition flex items-center gap-2 shadow-lg disabled:opacity-50"
                >
                  {passLoading ? 'Đang cập nhật...' : 'Cập nhật mật khẩu'}
                </button>
              </form>
            </div>
          )}

        </div>

      </div>

      {/* Address Form Modal */}
      {addrModal !== null && (
        <AddressModal
          addr={addrModal}
          onSave={() => {
            setAddrModal(null);
            loadAddresses();
          }}
          onClose={() => setAddrModal(null)}
        />
      )}

    </div>
  );
};
