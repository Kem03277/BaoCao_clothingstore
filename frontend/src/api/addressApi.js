import axiosClient from './axiosClient';

export const addressApi = {
  // Lấy danh sách địa chỉ của user hiện tại: GET /api/addresses
  getAll: () => axiosClient.get('/api/addresses'),

  // Chi tiết địa chỉ: GET /api/addresses/{id}
  getById: (id) => axiosClient.get(`/api/addresses/${id}`),

  // Tạo mới địa chỉ: POST /api/addresses
  create: (data) => axiosClient.post('/api/addresses', data),

  // Cập nhật địa chỉ: PUT /api/addresses/{id}
  update: (id, data) => axiosClient.put(`/api/addresses/${id}`, data),

  // Xóa địa chỉ: DELETE /api/addresses/{id}
  delete: (id) => axiosClient.delete(`/api/addresses/${id}`),
};
