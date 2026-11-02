/**
 * Tiện ích tính toán phân bổ số lượng tồn kho theo kích cỡ (Size Stock Breakdown).
 * Đảm bảo tổng số lượng từng size luôn khớp 100% với product.quantity.
 */

export const SIZES = ['S', 'M', 'L', 'XL'];

/**
 * Tính toán số lượng tồn kho của từng size cho một sản phẩm.
 * @param {Object} product Sản phẩm có thuộc tính id và quantity
 * @returns {Record<'S'|'M'|'L'|'XL', number>} Object chứa số lượng mỗi size
 */
export const calculateProductSizeStock = (product) => {
  if (!product) return { S: 0, M: 0, L: 0, XL: 0 };

  // Nếu sản phẩm đã có dữ liệu phân bổ cụ thể từ backend
  if (product.sizeStock && typeof product.sizeStock === 'object') {
    return product.sizeStock;
  }
  if (product.sizeQuantities && typeof product.sizeQuantities === 'object') {
    return product.sizeQuantities;
  }

  const total = Math.max(0, parseInt(product.quantity, 10) || 0);
  if (total === 0) {
    return { S: 0, M: 0, L: 0, XL: 0 };
  }

  // Trường hợp số lượng ít (1 - 3 chiếc), ưu tiên các size phổ biến M, L
  if (total <= 3) {
    const priority = ['M', 'L', 'S', 'XL'];
    const res = { S: 0, M: 0, L: 0, XL: 0 };
    for (let i = 0; i < total; i++) {
      res[priority[i % priority.length]] += 1;
    }
    return res;
  }

  // Tỷ lệ phân bổ thời trang thực tế: M (36%), L (28%), S (20%), XL (16%)
  // Sử dụng product.id làm seed để số lượng mỗi sản phẩm luôn cố định, nhất quán
  const id = Number(product.id || 1);
  const sWeight = 20 + ((id * 3) % 7);
  const mWeight = 36 + ((id * 5) % 9);
  const lWeight = 28 + ((id * 2) % 7);
  const xlWeight = 16 + ((id * 7) % 5);
  const totalWeight = sWeight + mWeight + lWeight + xlWeight;

  let s = Math.floor((total * sWeight) / totalWeight);
  let m = Math.floor((total * mWeight) / totalWeight);
  let l = Math.floor((total * lWeight) / totalWeight);
  let xl = Math.floor((total * xlWeight) / totalWeight);

  let remainder = total - (s + m + l + xl);
  const order = ['M', 'L', 'S', 'XL'];
  let idx = 0;
  while (remainder > 0) {
    if (order[idx] === 'M') m++;
    else if (order[idx] === 'L') l++;
    else if (order[idx] === 'S') s++;
    else if (order[idx] === 'XL') xl++;
    remainder--;
    idx = (idx + 1) % order.length;
  }

  return { S: s, M: m, L: l, XL: xl };
};

