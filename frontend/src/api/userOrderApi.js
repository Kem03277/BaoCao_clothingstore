import axiosClient from './axiosClient';

export const userOrderApi = {
  // Tạo đơn hàng mới: POST /api/orders
  createOrder: (data) => axiosClient.post('/api/orders', data),

  // Lấy lịch sử đơn hàng của user hiện tại: GET /api/orders/my
  getMyOrders: () => axiosClient.get('/api/orders/my'),

  // Chi tiết đơn hàng của user: GET /api/orders/my/{id}
  getMyOrderById: (id) => axiosClient.get(`/api/orders/my/${id}`),

  // Hủy đơn hàng (nếu đơn chưa xử lý): PUT /api/orders/my/{id}/cancel
  cancelMyOrder: (id) => axiosClient.put(`/api/orders/my/${id}/cancel`),
};
