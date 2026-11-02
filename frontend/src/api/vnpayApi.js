import axiosClient from './axiosClient';

export const vnpayApi = {
  createPayment: (data) => axiosClient.post('/api/payments/vnpay/create', data),
  retryPayment: (orderCode) => axiosClient.post('/api/payments/vnpay/retry', null, {
    params: { orderCode },
  }),
  getStatus: (orderCode) => axiosClient.get('/api/payments/vnpay/status', {
    params: { orderCode },
  }),
  confirmTransfer: (orderCode) => axiosClient.post('/api/payments/vnpay/confirm-transfer', null, {
    params: { orderCode },
  }),
};
