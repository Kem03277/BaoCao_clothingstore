import axiosClient from './axiosClient';

export const dashboardApi = {
  // Doanh thu theo khoảng ngày: GET /api/admin/dashboard/revenue?from=YYYY-MM-DD&to=YYYY-MM-DD
  getRevenue: (from, to) => {
    return axiosClient.get('/api/admin/dashboard/revenue', { params: { from, to } });
  },

  // Doanh thu từng ngày: GET /api/admin/dashboard/revenue/by-day?from=YYYY-MM-DD&to=YYYY-MM-DD
  getDailyRevenue: (from, to) => {
    return axiosClient.get('/api/admin/dashboard/revenue/by-day', { params: { from, to } });
  },

  // Số lượng đơn hàng theo trạng thái: GET /api/admin/dashboard/orders-by-status
  getOrderCounts: () => {
    return axiosClient.get('/api/admin/dashboard/orders-by-status');
  },

  // Top sản phẩm bán chạy: GET /api/admin/dashboard/top-products?limit=N
  getTopProducts: (limit = 10) => {
    return axiosClient.get('/api/admin/dashboard/top-products', { params: { limit } });
  },
};
