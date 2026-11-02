import axiosClient from './axiosClient';

export const productApi = {
  // Lấy danh sách sản phẩm với bộ lọc: GET /api/products
  getAll: (params = {}) => {
    return axiosClient.get('/api/products', { params });
  },

  getPage: (params = {}) => axiosClient.get('/api/products/page', { params }),

  getManagementPage: (params = {}) => axiosClient.get('/api/products/manage/page', { params }),

  getAllPages: async (params = {}, pageSize = 100) => {
    const products = [];
    let page = 0;
    let batch;

    do {
      batch = await axiosClient.get('/api/products', {
        params: { ...params, page, size: pageSize },
      });
      products.push(...(batch || []));
      page += 1;
    } while (batch?.length === pageSize);

    return products;
  },

  // Tìm kiếm sản phẩm: GET /api/products/search
  search: (params = {}) => {
    return axiosClient.get('/api/products/search', { params });
  },

  // Sản phẩm nổi bật: GET /api/products/featured
  getFeatured: () => {
    return axiosClient.get('/api/products/featured');
  },

  // Chi tiết sản phẩm: GET /api/products/{id}
  getById: (id) => {
    return axiosClient.get(`/api/products/${id}`);
  },

  // Tạo mới sản phẩm: POST /api/products
  create: (productData) => {
    return axiosClient.post('/api/products', productData);
  },

  // Cập nhật sản phẩm: PUT /api/products/{id}
  update: (id, productData) => {
    return axiosClient.put(`/api/products/${id}`, productData);
  },

  // Cập nhật ảnh chính: POST /api/products/{id}/main-image
  updateMainImage: (id, file) => {
    const formData = new FormData();
    formData.append('file', file);
    return axiosClient.post(`/api/products/${id}/main-image`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  // Thêm ảnh bổ sung: POST /api/products/{id}/images
  addImages: (id, files) => {
    const formData = new FormData();
    files.forEach((file) => formData.append('files', file));
    return axiosClient.post(`/api/products/${id}/images`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  getImages: (id) => axiosClient.get(`/api/products/${id}/images`),

  updateImage: (productId, imageId, file) => {
    const formData = new FormData();
    formData.append('file', file);
    return axiosClient.put(`/api/products/${productId}/images/${imageId}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  deleteImage: (productId, imageId) => (
    axiosClient.delete(`/api/products/${productId}/images/${imageId}`)
  ),

  // Xóa mềm sản phẩm (vào thùng rác): DELETE /api/products/{id}
  delete: (id) => {
    return axiosClient.delete(`/api/products/${id}`);
  },

  // Danh sách thùng rác: GET /api/products/trash
  getTrash: () => {
    return axiosClient.get('/api/products/trash');
  },

  // Xóa vĩnh viễn: DELETE /api/products/trash/{id}
  deletePermanently: (id) => {
    return axiosClient.delete(`/api/products/trash/${id}`);
  },

  // Khôi phục một sản phẩm từ thùng rác: POST /api/products/trash/{id}/restore
  restore: (id) => {
    return axiosClient.post(`/api/products/trash/${id}/restore`);
  },

  // Khôi phục tất cả thùng rác: POST /api/products/trash/restore-all
  restoreAll: () => {
    return axiosClient.post('/api/products/trash/restore-all');
  },
};
