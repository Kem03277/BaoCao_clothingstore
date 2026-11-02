import axiosClient from './axiosClient';

export const authApi = {
  // Đăng ký tài khoản: POST /api/auth/register
  register: (data) => axiosClient.post('/api/auth/register', data),

  // Đăng nhập khách hàng: POST /api/auth/login
  login: (credentials) => {
    return axiosClient.post('/api/auth/login', credentials);
  },

  // Đăng nhập quản trị viên / nhân viên: POST /api/admin/login
  adminLogin: (credentials) => {
    return axiosClient.post('/api/admin/login', credentials);
  },

  logout: () => axiosClient.post('/api/auth/logout'),

  // Lấy thông tin user hiện tại: GET /api/auth/me
  getCurrentUser: () => {
    return axiosClient.get('/api/auth/me');
  },

  // Cập nhật thông tin cá nhân: PUT /api/auth/me
  updateProfile: (data) => axiosClient.put('/api/auth/me', data),

  // Đổi mật khẩu: PUT /api/auth/change-password
  changePassword: (data) => {
    return axiosClient.put('/api/auth/change-password', data);
  },

  // Đổi mật khẩu quản trị: PUT /api/admin/change-password
  adminChangePassword: (data) => {
    return axiosClient.put('/api/admin/change-password', data);
  },

  // Cập nhật avatar cá nhân: POST /api/auth/me/avatar
  updateOwnAvatar: (file) => {
    const formData = new FormData();
    formData.append('file', file);
    return axiosClient.post('/api/auth/me/avatar', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
};
