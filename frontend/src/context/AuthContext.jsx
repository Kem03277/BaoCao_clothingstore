import React, { createContext, useContext, useState, useEffect } from 'react';
import { authApi } from '../api';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(() => {
    try {
      const stored = localStorage.getItem('user');
      return stored ? JSON.parse(stored) : null;
    } catch {
      return null;
    }
  });
  const [token, setToken] = useState(() => localStorage.getItem('token') || '');
  const [loading, setLoading] = useState(true);
  const [authMessage, setAuthMessage] = useState(null);

  const roleUpper = user?.roleCode?.toUpperCase() || '';
  const isAdmin = roleUpper === 'ADMIN' || roleUpper === 'ROLE_ADMIN';
  const isStaff = roleUpper === 'STAFF' || roleUpper === 'ROLE_STAFF';
  const hasManagementAccess = isAdmin || isStaff;

  // Kiểm tra token khi khởi động
  useEffect(() => {
    let isCurrentRequest = true;
    const tokenToVerify = token;

    const fetchMe = async () => {
      if (tokenToVerify && tokenToVerify !== 'demo-admin-token') {
        try {
          const freshUser = await authApi.getCurrentUser();
          if (!isCurrentRequest || localStorage.getItem('token') !== tokenToVerify) return;
          setUser(freshUser);
          localStorage.setItem('user', JSON.stringify(freshUser));
        } catch (error) {
          if (!isCurrentRequest || localStorage.getItem('token') !== tokenToVerify) return;
          if (error.status === 401) {
            logout('Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.', false);
          }
        }
      }
      if (isCurrentRequest) setLoading(false);
    };

    fetchMe();
    return () => {
      isCurrentRequest = false;
    };
  }, [token]);

  useEffect(() => {
    const handleUnauthorized = () => {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      setToken('');
      setUser(null);
      setAuthMessage({ type: 'info', text: 'Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.' });
    };

    window.addEventListener('auth:unauthorized', handleUnauthorized);
    return () => window.removeEventListener('auth:unauthorized', handleUnauthorized);
  }, []);

  const login = async (email, password, isAdminPortal = true) => {
    try {
      const response = isAdminPortal
        ? await authApi.adminLogin({ email, password })
        : await authApi.login({ email, password });

      const authToken = response.accessToken;
      const authUser = response.user;

      localStorage.setItem('token', authToken);
      localStorage.setItem('user', JSON.stringify(authUser));
      setToken(authToken);
      setUser(authUser);
      setAuthMessage({ type: 'success', text: `Chào mừng trở lại, ${authUser.fullName || 'Admin'}!` });
      return { success: true, user: authUser };
    } catch (error) {
      const msg = error.data?.message || error.message || 'Email hoặc mật khẩu không chính xác';
      return {
        success: false,
        message: msg,
      };
    }
  };

  // Xem trước chế độ demo không cần mật khẩu
  const loginAsDemo = () => {
    const demoUser = {
      id: 1,
      fullName: 'Quản Trị Viên (Demo)',
      email: 'admin@clothingstore.com',
      roleCode: 'ADMIN',
      status: 'ACTIVE',
    };
    const demoToken = 'demo-admin-token';
    localStorage.setItem('token', demoToken);
    localStorage.setItem('user', JSON.stringify(demoUser));
    setToken(demoToken);
    setUser(demoUser);
    setAuthMessage({ type: 'success', text: 'Đã vào giao diện Quản trị chế độ xem trước!' });
  };

  async function logout(
    notice = 'Đã đăng xuất khỏi hệ thống thành công',
    revokeServerSession = true,
  ) {
    const currentToken = localStorage.getItem('token');
    let revocationError = null;
    if (revokeServerSession && currentToken && currentToken !== 'demo-admin-token') {
      try {
        await authApi.logout();
      } catch (error) {
        revocationError = error;
      }
    }
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setToken('');
    setUser(null);
    if (revocationError) {
      setAuthMessage({
        type: 'error',
        text: 'Đã đăng xuất trên thiết bị này nhưng không thể thu hồi phiên trên máy chủ. Hãy kiểm tra kết nối.',
      });
    } else if (notice) {
      setAuthMessage({ type: 'info', text: notice });
    }
  }

  const changeAdminPassword = async (currentPassword, newPassword) => {
    try {
      await authApi.adminChangePassword({ currentPassword, newPassword });
      return { success: true };
    } catch (error) {
      return {
        success: false,
        message: error.data?.message || error.message || 'Đổi mật khẩu thất bại',
      };
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        isAuthenticated: !!token && !!user,
        isAdmin,
        isStaff,
        hasManagementAccess,
        loading,
        authMessage,
        setAuthMessage,
        login,
        loginAsDemo,
        logout,
        changeAdminPassword,
        setUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  return context || {};
};
