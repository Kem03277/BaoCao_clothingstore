import axiosClient from './axiosClient';

export const couponApi = {
  validate: (code, items) => axiosClient.post('/api/coupons/validate', { code, items }),
  getAll: () => axiosClient.get('/api/admin/coupons'),
  getTrash: () => axiosClient.get('/api/admin/coupons/trash'),
  getById: (id) => axiosClient.get(`/api/admin/coupons/${id}`),
  create: (data) => axiosClient.post('/api/admin/coupons', data),
  update: (id, data) => axiosClient.put(`/api/admin/coupons/${id}`, data),
  updateStatus: (id, status) => axiosClient.patch(`/api/admin/coupons/${id}/status`, { status }),
  delete: (id) => axiosClient.delete(`/api/admin/coupons/${id}`),
  restore: (id) => axiosClient.post(`/api/admin/coupons/trash/${id}/restore`),
  restoreAll: () => axiosClient.post('/api/admin/coupons/trash/restore-all'),
  deletePermanently: (id) => axiosClient.delete(`/api/admin/coupons/trash/${id}`),

  // Danh mục áp dụng
  getCategories: (id) => axiosClient.get(`/api/admin/coupons/${id}/categories`),
  addCategory: (id, targetId) => axiosClient.post(`/api/admin/coupons/${id}/categories`, { targetId }),
  removeCategory: (id, categoryId) => axiosClient.delete(`/api/admin/coupons/${id}/categories/${categoryId}`),

  // Sản phẩm áp dụng
  getProducts: (id) => axiosClient.get(`/api/admin/coupons/${id}/products`),
  addProduct: (id, targetId) => axiosClient.post(`/api/admin/coupons/${id}/products`, { targetId }),
  removeProduct: (id, productId) => axiosClient.delete(`/api/admin/coupons/${id}/products/${productId}`),
};
