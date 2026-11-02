import React, { createContext, useContext, useState, useEffect } from 'react';
import { storeInformationApi } from '../api';

const CartContext = createContext();

export const DEFAULT_STORE_INFORMATION = {
  paymentMethods: ['COD', 'VNPAY'],
  paymentStatuses: ['PENDING', 'COMPLETED', 'FAILED'],
  shippingCarriers: ['Giao Hàng Nhanh', 'Viettel Post'],
  shippingStatuses: ['PENDING', 'SHIPPED', 'DELIVERED'],
  shippingFee: 30000,
  freeShippingThreshold: 500000,
};

export const CartProvider = ({ children }) => {
  const [cartItems, setCartItems] = useState(() => {
    try {
      const saved = localStorage.getItem('cart');
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  const [appliedCoupon, setAppliedCoupon] = useState(null);
  const [isCartOpen, setIsCartOpen] = useState(false);
  const [cartNotification, setCartNotification] = useState(null);
  const [storeInformation, setStoreInformation] = useState(DEFAULT_STORE_INFORMATION);
  const [storeInformationError, setStoreInformationError] = useState('');
  const [storeInformationLoading, setStoreInformationLoading] = useState(true);

  useEffect(() => {
    let active = true;
    storeInformationApi.get()
      .then((information) => {
        if (active && information) {
          setStoreInformation({
            ...DEFAULT_STORE_INFORMATION,
            ...information,
            shippingFee: information.shippingFee != null ? Number(information.shippingFee) : DEFAULT_STORE_INFORMATION.shippingFee,
            freeShippingThreshold: information.freeShippingThreshold != null ? Number(information.freeShippingThreshold) : DEFAULT_STORE_INFORMATION.freeShippingThreshold,
          });
        }
      })
      .catch((error) => {
        console.warn('Store information API offline or error, using default shipping settings:', error);
      })
      .finally(() => {
        if (active) setStoreInformationLoading(false);
      });
    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    localStorage.setItem('cart', JSON.stringify(cartItems));
  }, [cartItems]);

  const addToCart = (product, quantity = 1, selectedSize = 'M', options = {}) => {
    setCartItems((prevItems) => {
      const itemKey = `${product.id}_${selectedSize}`;
      const existing = prevItems.find((item) => item.key === itemKey);

      if (existing) {
        return prevItems.map((item) =>
          item.key === itemKey
            ? { ...item, quantity: item.quantity + quantity }
            : item
        );
      }

      return [
        ...prevItems,
        {
          key: itemKey,
          id: product.id,
          name: product.name,
          price: product.price,
          image: product.mainImageUrl || (product.additionalImageUrls?.[0]) || 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500',
          size: selectedSize,
          quantity,
        },
      ];
    });
    if (options.openCart !== false) {
      setIsCartOpen(true);
    }
    if (options.showNotification) {
      setCartNotification((current) => ({
        id: (current?.id || 0) + 1,
        productName: product.name,
      }));
    }
  };

  const updateQuantity = (key, quantity) => {
    if (quantity <= 0) {
      removeFromCart(key);
      return;
    }
    setCartItems((prev) =>
      prev.map((item) => (item.key === key ? { ...item, quantity } : item))
    );
  };

  const updateCartItem = (key, size, quantity) => {
    setCartItems((prevItems) => {
      const currentItem = prevItems.find((item) => item.key === key);
      if (!currentItem) return prevItems;

      const nextKey = `${currentItem.id}_${size}`;
      const matchingItem = prevItems.find((item) => item.key === nextKey && item.key !== key);
      const updatedItem = {
        ...(matchingItem || currentItem),
        key: nextKey,
        size,
        quantity: quantity + (matchingItem?.quantity || 0),
      };

      return [
        ...prevItems.filter((item) => item.key !== key && item.key !== nextKey),
        updatedItem,
      ];
    });
  };

  const removeFromCart = (key) => {
    setCartItems((prev) => prev.filter((item) => item.key !== key));
  };

  const clearCart = () => {
    setCartItems([]);
    setAppliedCoupon(null);
  };

  const subtotal = cartItems.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  const calculateDiscount = () => {
    if (!appliedCoupon) return 0;
    if (['PERCENT', 'PERCENTAGE'].includes(appliedCoupon.discountType?.toUpperCase())) {
      const eligibleProductIds = appliedCoupon.eligibleProductIds;
      const eligibleSubtotal = Array.isArray(eligibleProductIds)
        ? cartItems.reduce(
            (sum, item) => eligibleProductIds.includes(item.id)
              ? sum + item.price * item.quantity
              : sum,
            0
          )
        : subtotal;
      const discount = (eligibleSubtotal * appliedCoupon.discountValue) / 100;
      return appliedCoupon.maxDiscount
        ? Math.min(discount, appliedCoupon.maxDiscount)
        : discount;
    }
    return 0;
  };

  const discountAmount = calculateDiscount();
  const effectiveStoreInfo = storeInformation || DEFAULT_STORE_INFORMATION;
  const shippingFee = subtotal === 0
    ? 0
    : subtotal >= Number(effectiveStoreInfo.freeShippingThreshold || 500000)
      ? 0
      : Number(effectiveStoreInfo.shippingFee ?? 30000);
  const totalAmount = Math.max(0, subtotal - discountAmount + shippingFee);

  return (
    <CartContext.Provider
      value={{
        cartItems,
        isCartOpen,
        setIsCartOpen,
        cartNotification,
        dismissCartNotification: () => setCartNotification(null),
        addToCart,
        updateQuantity,
        updateCartItem,
        removeFromCart,
        clearCart,
        subtotal,
        discountAmount,
        shippingFee,
        storeInformation,
        storeInformationError,
        storeInformationLoading,
        totalAmount,
        appliedCoupon,
        setAppliedCoupon,
        itemCount: cartItems.reduce((total, item) => total + item.quantity, 0),
      }}
    >
      {children}
    </CartContext.Provider>
  );
};

export const useCart = () => useContext(CartContext);
