import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || import.meta.env.VITE_API_URL || '';

const axiosClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 15000,
});

const authTokenSnapshotKey = '__authTokenSnapshot';
const publicAuthEndpoints = new Set([
  '/api/auth/login',
  '/api/admin/login',
  '/api/auth/register',
]);

<<<<<<< HEAD
=======

>>>>>>> d604981 (HoanThanh)
axiosClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    const requestPath = config.url?.split('?')[0].replace(/\/+$/, '');
    const isPublicRequest = requestPath === '/api/store-information'
      || publicAuthEndpoints.has(requestPath);

    if (token && !isPublicRequest) {
      config[authTokenSnapshotKey] = token;
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => Promise.reject(error)
);

axiosClient.interceptors.response.use(
  (response) => response.data,
  (error) => {
    const status = error.response ? error.response.status : null;
    const message = error.response?.data?.message || error.message || 'Lỗi kết nối máy chủ';

    const requestToken = error.config?.[authTokenSnapshotKey];
    if (status === 401 && requestToken && localStorage.getItem('token') === requestToken && !error.config?.url?.includes('/api/payments/vnpay/status')) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.dispatchEvent(new Event('auth:unauthorized'));
    }

    return Promise.reject({
      status,
      message,
      data: error.response?.data,
    });
  }
);

export default axiosClient;
