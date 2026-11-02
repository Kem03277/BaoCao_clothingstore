import axiosClient from './axiosClient';

export const categoryApi = {
  getAll: () => axiosClient.get('/api/categories'),
  getById: (id) => axiosClient.get(`/api/categories/${id}`),
  create: (data) => axiosClient.post('/api/categories', data),
  update: (id, data) => axiosClient.put(`/api/categories/${id}`, data),
  delete: (id) => axiosClient.delete(`/api/categories/${id}`),
  getTrash: () => axiosClient.get('/api/categories/trash'),
  restore: (id) => axiosClient.post(`/api/categories/trash/${id}/restore`),
  restoreAll: () => axiosClient.post('/api/categories/trash/restore-all'),
  deletePermanently: (id) => axiosClient.delete(`/api/categories/trash/${id}`),
};

export const brandApi = {
  getAll: () => axiosClient.get('/api/brands'),
  getById: (id) => axiosClient.get(`/api/brands/${id}`),
  getAllForManagement: () => axiosClient.get('/api/brands/manage'),
  create: (data) => axiosClient.post('/api/brands', data),
  update: (id, data) => axiosClient.put(`/api/brands/${id}`, data),
  delete: (id) => axiosClient.delete(`/api/brands/${id}`),
  getTrash: () => axiosClient.get('/api/brands/trash'),
  restore: (id) => axiosClient.post(`/api/brands/trash/${id}/restore`),
  restoreAll: () => axiosClient.post('/api/brands/trash/restore-all'),
  deletePermanently: (id) => axiosClient.delete(`/api/brands/trash/${id}`),
};

export const postApi = {
  getAll: () => axiosClient.get('/api/posts'),
  getById: (id) => axiosClient.get(`/api/posts/${id}`),
  getAllForManagement: (status = 'ALL') => (
    axiosClient.get('/api/posts/manage', { params: { status } })
  ),
  getTrash: () => axiosClient.get('/api/posts/manage/trash'),
  getByIdForManagement: (id) => axiosClient.get(`/api/posts/manage/${id}`),
  create: (data) => axiosClient.post('/api/posts', data),
  update: (id, data) => axiosClient.put(`/api/posts/${id}`, data),
  delete: (id) => axiosClient.delete(`/api/posts/${id}`),
  restore: (id) => axiosClient.post(`/api/posts/manage/trash/${id}/restore`),
  restoreAll: () => axiosClient.post('/api/posts/manage/trash/restore-all'),
  deletePermanently: (id) => axiosClient.delete(`/api/posts/manage/trash/${id}`),
  uploadThumbnail: (file) => {
    const formData = new FormData();
    formData.append('file', file);
    return axiosClient.post('/api/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
};

export const postCategoryApi = {
  getAll: () => axiosClient.get('/api/post-categories'),
};
