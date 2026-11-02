import axiosClient from './axiosClient';

const cleanPageParam = (params = {}) => {
  const clean = { ...params };
  if (clean.page !== undefined && typeof clean.page !== 'number') {
    const parsed = Number.parseInt(clean.page, 10);
    clean.page = Number.isNaN(parsed) ? 0 : parsed;
  }
  return clean;
};

export const customerApi = {
  getAllUsers: () => axiosClient.get('/api/admin/users'),
  getUsersPage: (params = {}) => axiosClient.get('/api/admin/users/page', { params: cleanPageParam(params) }),
  getUserById: (id) => axiosClient.get(`/api/admin/users/${id}`),
  updateUserStatus: (id, status) => axiosClient.put(`/api/admin/users/${id}/status`, { status }),
  updateUserAvatar: (id, file) => {
    const formData = new FormData();
    formData.append('file', file);
    return axiosClient.post(`/api/admin/users/${id}/avatar`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
};

export const inventoryApi = {
  findByProduct: (productId) => axiosClient.get(`/api/inventory/product/${productId}`),
  create: (data) => axiosClient.post('/api/inventory', data),
  findLowStock: () => axiosClient.get('/api/inventory/low-stock'),
  findTransactions: (productId) => axiosClient.get(`/api/inventory/${productId}/transactions`),
  stockIn: (productId, data) => axiosClient.post(`/api/inventory/${productId}/stock-in`, data),
  stockOut: (productId, data) => axiosClient.post(`/api/inventory/${productId}/stock-out`, data),
  adjustment: (productId, data) => axiosClient.post(`/api/inventory/${productId}/adjustment`, data),
};
