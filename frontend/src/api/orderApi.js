import axiosClient from './axiosClient';

const cleanPageParam = (params = {}) => {
  const clean = { ...params };
  if (clean.page !== undefined && typeof clean.page !== 'number') {
    const parsed = Number.parseInt(clean.page, 10);
    clean.page = Number.isNaN(parsed) ? 0 : parsed;
  }
  return clean;
};

export const orderApi = {
  // Lọc danh sách đơn hàng admin: GET /api/admin/orders?status=...&from=...&to=...
  getOrders: (params = {}) => {
    return axiosClient.get('/api/admin/orders', { params: cleanPageParam(params) });
  },
  getOrdersPage: (params = {}) => {
    return axiosClient.get('/api/admin/orders/page', { params: cleanPageParam(params) });
  },

  // Chi tiết đơn hàng: GET /api/admin/orders/{id}
  getOrderById: (id) => {
    return axiosClient.get(`/api/admin/orders/${id}`);
  },

  // Đổi trạng thái đơn: PUT /api/admin/orders/{id}/status
  updateStatus: (id, status) => {
    return axiosClient.put(`/api/admin/orders/${id}/status`, { status });
  },

  // Hủy đơn hàng: PUT /api/admin/orders/{id}/cancel
  cancelOrder: (id) => {
    return axiosClient.put(`/api/admin/orders/${id}/cancel`);
  },
};
