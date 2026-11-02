import axiosClient from './axiosClient';

export const storeInformationApi = {
  get: () => axiosClient.get('/api/store-information'),
};
