import React, { useEffect, useRef, useState } from 'react';
import {
  Package,
  Trash2,
  Edit,
  Upload,
  RotateCcw,
  Search,
  CheckCircle,
  AlertCircle,
  Loader2,
  X,
  Image as ImageIcon,
  ImagePlus,
  Sparkles,
  Link as LinkIcon,
} from 'lucide-react';
import { productApi, categoryApi, brandApi } from '../../api';
import { AdminPagination } from './AdminPagination';
import { useAdminNotification, AdminToast } from '../../context/AdminNotificationContext';
import { calculateProductSizeStock } from '../../lib/sizeStock';

export const ProductAdminView = () => {
  const { showConfirm } = useAdminNotification();
  const [activeTab, setActiveTab] = useState('active'); // 'active' or 'trash'
  const [products, setProducts] = useState([]);
  const [trashProducts, setTrashProducts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 10;
  const [loading, setLoading] = useState(true);
  const [totalItems, setTotalItems] = useState(0);
  const [activeProductTotal, setActiveProductTotal] = useState(0);
  const [trashTotal, setTrashTotal] = useState(0);
  const fetchRequestId = useRef(0);

  // Modal Create state
  const [creatingProduct, setCreatingProduct] = useState(false);
  const [createForm, setCreateForm] = useState({
    name: '',
    price: '',
    quantity: '50',
    description: '',
    categoryId: '',
    brandId: '',
    gender: 'UNISEX',
    tag: 'new',
    imageUrl: '',
  });
  const [createMainFile, setCreateMainFile] = useState(null);
  const [createMainPreview, setCreateMainPreview] = useState(null);
  const [createAdditionalFiles, setCreateAdditionalFiles] = useState([]);
  const [createAdditionalPreviews, setCreateAdditionalPreviews] = useState([]);

  // Modal edit state
  const [editingProduct, setEditingProduct] = useState(null);
  const [editForm, setEditForm] = useState({
    name: '',
    price: 0,
    quantity: 0,
    description: '',
    categoryId: '',
    brandId: '',
    gender: 'UNISEX',
    tag: '',
  });

  const [submitting, setSubmitting] = useState(false);
  const [uploadingImageId, setUploadingImageId] = useState(null);
  const [managingImagesProduct, setManagingImagesProduct] = useState(null);
  const [productImages, setProductImages] = useState([]);
  const [loadingProductImages, setLoadingProductImages] = useState(false);
  const [savingProductImages, setSavingProductImages] = useState(false);
  const [feedback, setFeedback] = useState(null);
  const [trashCountIncreased, setTrashCountIncreased] = useState(false);

  const fetchProducts = async (page = currentPage, keyword = search) => {
    const requestId = ++fetchRequestId.current;
    setLoading(true);
    try {
      const result = await productApi.getManagementPage({
        page: page - 1,
        size: pageSize,
        keyword: keyword.trim() || undefined,
      });
      if (requestId === fetchRequestId.current) {
        const lastPage = Math.max(1, result.totalPages || 1);
        if (page > lastPage) {
          setCurrentPage(lastPage);
          return;
        }
        setProducts(result?.content || []);
        setTotalItems(result?.totalElements || 0);
        setActiveProductTotal(result?.totalElements || 0);
      }
    } catch (err) {
      if (requestId === fetchRequestId.current) {
        showFeedback('error', 'Lỗi tải danh sách sản phẩm: ' + err.message);
      }
    } finally {
      if (requestId === fetchRequestId.current) setLoading(false);
    }
  };

  const fetchTrash = async (page = currentPage, keyword = search) => {
    const requestId = ++fetchRequestId.current;
    setLoading(true);
    try {
      const result = await productApi.getManagementPage({
        deleted: true,
        page: page - 1,
        size: pageSize,
        keyword: keyword.trim() || undefined,
      });
      if (requestId === fetchRequestId.current) {
        const lastPage = Math.max(1, result.totalPages || 1);
        if (page > lastPage) {
          setCurrentPage(lastPage);
          return;
        }
        setTrashProducts(result?.content || []);
        setTotalItems(result?.totalElements || 0);
        setTrashTotal(result?.totalElements || 0);
      }
    } catch (err) {
      if (requestId === fetchRequestId.current) {
        showFeedback('error', 'Lỗi tải thùng rác: ' + err.message);
      }
    } finally {
      if (requestId === fetchRequestId.current) setLoading(false);
    }
  };

  useEffect(() => {
    let isMounted = true;
    Promise.allSettled([
      categoryApi.getAll(),
      brandApi.getAll(),
      productApi.getManagementPage({ page: 0, size: 1 }),
      productApi.getManagementPage({ deleted: true, page: 0, size: 1 }),
    ]).then(([categoriesResult, brandsResult, activeResult, trashResult]) => {
      if (!isMounted) return;
      if (categoriesResult.status === 'fulfilled') setCategories(categoriesResult.value || []);
      if (brandsResult.status === 'fulfilled') setBrands(brandsResult.value || []);
      if (activeResult.status === 'fulfilled') setActiveProductTotal(activeResult.value.totalElements || 0);
      if (trashResult.status === 'fulfilled') setTrashTotal(trashResult.value.totalElements || 0);
    });
    return () => {
      isMounted = false;
    };
  }, []);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      if (activeTab === 'active') fetchProducts();
      else fetchTrash();
    }, search ? 250 : 0);
    return () => {
      window.clearTimeout(timer);
      fetchRequestId.current += 1;
    };
  }, [activeTab, currentPage, search]);

  function showFeedback(type, message) {
    setFeedback({ type, message });
    setTimeout(() => setFeedback(null), 3500);
  }

  // Reset Create Form
  const resetCreateForm = () => {
    setCreateForm({
      name: '',
      price: '',
      quantity: '50',
      description: '',
      categoryId: categories[0]?.id ? String(categories[0].id) : '',
      brandId: brands[0]?.id ? String(brands[0].id) : '',
      gender: 'UNISEX',
      tag: 'new',
      imageUrl: '',
    });
    setCreateMainFile(null);
    setCreateMainPreview(null);
    setCreateAdditionalFiles([]);
    setCreateAdditionalPreviews([]);
  };

  const handleOpenCreate = () => {
    resetCreateForm();
    if (categories.length > 0) {
      setCreateForm((prev) => ({
        ...prev,
        categoryId: String(categories[0].id),
        brandId: brands.length > 0 ? String(brands[0].id) : '',
      }));
    }
    setCreatingProduct(true);
  };

  const handleSelectMainImage = (file) => {
    if (!file) return;
    setCreateMainFile(file);
    const previewUrl = URL.createObjectURL(file);
    setCreateMainPreview(previewUrl);
  };

  const handleSelectAdditionalImages = (files) => {
    if (!files || !files.length) return;
    const newFiles = Array.from(files);
    const newPreviews = newFiles.map((file) => ({
      file,
      url: URL.createObjectURL(file),
    }));
    setCreateAdditionalFiles((prev) => [...prev, ...newFiles]);
    setCreateAdditionalPreviews((prev) => [...prev, ...newPreviews]);
  };

  const handleRemoveAdditionalPreview = (index) => {
    setCreateAdditionalFiles((prev) => prev.filter((_, i) => i !== index));
    setCreateAdditionalPreviews((prev) => prev.filter((_, i) => i !== index));
  };

  const handleSaveCreate = async (e) => {
    e.preventDefault();
    if (!createForm.name.trim()) {
      showFeedback('error', 'Vui lòng nhập tên sản phẩm');
      return;
    }
    const priceNum = parseFloat(createForm.price);
    if (isNaN(priceNum) || priceNum <= 0) {
      showFeedback('error', 'Giá bán niêm yết phải lớn hơn 0');
      return;
    }
    const catIdNum = parseInt(createForm.categoryId);
    if (!catIdNum) {
      showFeedback('error', 'Vui lòng chọn danh mục cho sản phẩm');
      return;
    }

    setSubmitting(true);
    try {
      // 1. Tạo bản ghi sản phẩm
      const created = await productApi.create({
        name: createForm.name.trim(),
        price: priceNum,
        quantity: parseInt(createForm.quantity) || 0,
        description: createForm.description.trim(),
        categoryId: catIdNum,
        brandId: createForm.brandId ? parseInt(createForm.brandId) : null,
        gender: createForm.gender || 'UNISEX',
        tag: createForm.tag || null,
        imageUrl: createForm.imageUrl ? createForm.imageUrl.trim() : null,
      });

      const newId = created?.id;

      // 2. Upload file ảnh chính (nếu có chọn từ máy tính)
      if (createMainFile && newId) {
        try {
          await productApi.updateMainImage(newId, createMainFile);
        } catch (imgErr) {
          console.warn('Lỗi tải ảnh chính:', imgErr);
        }
      }

      // 3. Upload các file ảnh phụ (nếu có)
      if (createAdditionalFiles.length > 0 && newId) {
        try {
          await productApi.addImages(newId, createAdditionalFiles);
        } catch (imgErr) {
          console.warn('Lỗi tải ảnh phụ:', imgErr);
        }
      }

      showFeedback('success', `Đã tạo sản phẩm "${createForm.name}" thành công!`);
      setCreatingProduct(false);
      resetCreateForm();
      await fetchProducts();
    } catch (err) {
      const msg = err.response?.data?.message || err.message || 'Không thể tạo sản phẩm';
      showFeedback('error', 'Lỗi khi tạo sản phẩm: ' + msg);
    } finally {
      setSubmitting(false);
    }
  };

  const handleOpenEdit = (p) => {
    setEditingProduct(p);
    setEditForm({
      name: p.name || '',
      price: p.price || 0,
      quantity: p.quantity || 0,
      description: p.description || '',
      categoryId: p.categoryId ? String(p.categoryId) : '',
      brandId: p.brandId ? String(p.brandId) : '',
      gender: p.gender || 'UNISEX',
      tag: p.tag || '',
    });
  };

  const handleSaveEdit = async (e) => {
    e.preventDefault();
    if (!editingProduct) return;

    const price = Number(editForm.price);
    const quantity = Number(editForm.quantity);
    const categoryId = Number(editForm.categoryId);
    if (!Number.isFinite(price) || price < 1000) {
      showFeedback('error', 'Giá bán phải từ 1.000 VNĐ trở lên');
      return;
    }
    if (!Number.isInteger(quantity) || quantity < 0) {
      showFeedback('error', 'Số lượng tồn kho phải là số nguyên từ 0 trở lên');
      return;
    }
    if (!Number.isInteger(categoryId) || categoryId <= 0) {
      showFeedback('error', 'Vui lòng chọn danh mục cho sản phẩm');
      return;
    }

    setSubmitting(true);
    try {
      await productApi.update(editingProduct.id, {
        name: editForm.name.trim(),
        price,
        quantity,
        description: editForm.description,
        categoryId,
        brandId: editForm.brandId ? parseInt(editForm.brandId) : null,
        gender: editForm.gender || 'UNISEX',
        tag: editForm.tag || null,
      });
      showFeedback('success', `Đã cập nhật sản phẩm "${editForm.name}" thành công!`);
      setEditingProduct(null);
      fetchProducts();
    } catch (err) {
      showFeedback('error', 'Lỗi khi cập nhật sản phẩm: ' + (err.message || ''));
    } finally {
      setSubmitting(false);
    }
  };

  const handleUploadMainImage = async (productId, file) => {
    if (!file) return;
    setUploadingImageId(productId);
    try {
      await productApi.updateMainImage(productId, file);
      showFeedback('success', 'Upload ảnh sản phẩm thành công!');
      fetchProducts();
    } catch (err) {
      showFeedback('error', 'Lỗi upload ảnh: ' + (err.message || ''));
    } finally {
      setUploadingImageId(null);
    }
  };

  const loadProductImages = async (productId) => {
    setLoadingProductImages(true);
    try {
      const images = await productApi.getImages(productId);
      setProductImages(images || []);
    } catch (err) {
      showFeedback('error', 'Lỗi tải ảnh phụ: ' + (err.message || ''));
    } finally {
      setLoadingProductImages(false);
    }
  };

  const handleOpenImages = (product) => {
    setManagingImagesProduct(product);
    setProductImages([]);
    loadProductImages(product.id);
  };

  const handleAddAdditionalImages = async (files) => {
    if (!managingImagesProduct || !files.length) return;
    setSavingProductImages(true);
    try {
      await productApi.addImages(managingImagesProduct.id, files);
      await loadProductImages(managingImagesProduct.id);
      showFeedback('success', `Đã tải lên ${files.length} ảnh phụ.`);
    } catch (err) {
      showFeedback('error', 'Lỗi tải ảnh phụ: ' + (err.message || ''));
    } finally {
      setSavingProductImages(false);
    }
  };

  const handleReplaceAdditionalImage = async (imageId, file) => {
    if (!managingImagesProduct || !file) return;
    setSavingProductImages(true);
    try {
      await productApi.updateImage(managingImagesProduct.id, imageId, file);
      await loadProductImages(managingImagesProduct.id);
      showFeedback('success', 'Đã cập nhật ảnh phụ.');
    } catch (err) {
      showFeedback('error', 'Lỗi cập nhật ảnh phụ: ' + (err.message || ''));
    } finally {
      setSavingProductImages(false);
    }
  };

  const handleDeleteAdditionalImage = async (imageId) => {
    if (!managingImagesProduct) return;
    const confirmed = await showConfirm({
      title: 'Xóa ảnh phụ',
      message: 'Bạn có chắc chắn muốn xóa ảnh phụ này khỏi sản phẩm không?',
      type: 'danger',
      confirmText: 'Xóa ảnh',
      cancelText: 'Giữ lại',
    });
    if (!confirmed) return;
    setSavingProductImages(true);
    try {
      await productApi.deleteImage(managingImagesProduct.id, imageId);
      await loadProductImages(managingImagesProduct.id);
      showFeedback('success', 'Đã xóa ảnh phụ.');
    } catch (err) {
      showFeedback('error', 'Lỗi xóa ảnh phụ: ' + (err.message || ''));
    } finally {
      setSavingProductImages(false);
    }
  };

  const handleDelete = async (product) => {
    const confirmed = await showConfirm({
      title: 'Chuyển vào thùng rác',
      message: `Bạn có chắc muốn chuyển sản phẩm "${product.name}" vào thùng rác không?`,
      type: 'warning',
      confirmText: 'Chuyển vào thùng rác',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await productApi.delete(product.id);
      setActiveProductTotal((current) => Math.max(0, current - 1));
      setTrashTotal((current) => current + 1);
      setTrashCountIncreased(true);
      setTimeout(() => setTrashCountIncreased(false), 3500);
      showFeedback('success', 'Đã chuyển sản phẩm vào thùng rác (xóa mềm) thành công!');
      if (products.length === 1 && currentPage > 1) setCurrentPage((page) => page - 1);
      else fetchProducts();
    } catch (err) {
      showFeedback('error', 'Lỗi khi xóa: ' + (err.message || ''));
    }
  };

  const handleDeletePermanent = async (id) => {
    const confirmed = await showConfirm({
      title: 'Xóa vĩnh viễn sản phẩm',
      message: 'CẢNH BÁO: Thao tác này không thể hoàn tác! Bạn có chắc chắn muốn xóa vĩnh viễn sản phẩm này khỏi cơ sở dữ liệu?',
      type: 'danger',
      confirmText: 'Xóa vĩnh viễn',
      cancelText: 'Hủy',
    });
    if (!confirmed) return;
    try {
      await productApi.deletePermanently(id);
      setTrashTotal((current) => Math.max(0, current - 1));
      showFeedback('success', 'Đã xóa vĩnh viễn sản phẩm');
      if (trashProducts.length === 1 && currentPage > 1) setCurrentPage((page) => page - 1);
      else fetchTrash();
    } catch (err) {
      showFeedback('error', 'Lỗi khi xóa vĩnh viễn: ' + (err.message || ''));
    }
  };

  const handleRestore = async (product) => {
    try {
      await productApi.restore(product.id);
      setTrashTotal((current) => Math.max(0, current - 1));
      setActiveProductTotal((current) => current + 1);
      showFeedback('success', `Đã khôi phục sản phẩm "${product.name}" thành công!`);
      if (activeTab === 'trash') {
        if (trashProducts.length === 1 && currentPage > 1) setCurrentPage((page) => page - 1);
        else fetchTrash();
      } else {
        fetchProducts();
      }
    } catch (err) {
      showFeedback('error', 'Lỗi khi khôi phục sản phẩm: ' + (err.message || ''));
    }
  };

  const handleRestoreAll = async () => {
    const confirmed = await showConfirm({
      title: 'Khôi phục toàn bộ thùng rác',
      message: 'Bạn có chắc chắn muốn khôi phục toàn bộ sản phẩm đang có trong thùng rác không?',
      type: 'info',
      confirmText: 'Khôi phục tất cả',
      cancelText: 'Hủy bỏ',
    });
    if (!confirmed) return;
    try {
      await productApi.restoreAll();
      setTrashProducts([]);
      setTrashTotal(0);
      showFeedback('success', 'Đã khôi phục toàn bộ sản phẩm trong thùng rác!');
      fetchTrash(1);
      setCurrentPage(1);
    } catch (err) {
      showFeedback('error', 'Lỗi khi khôi phục: ' + (err.message || ''));
    }
  };

  const filteredProducts = activeTab === 'active' ? products : trashProducts;
  const totalPages = Math.max(1, Math.ceil(totalItems / pageSize));
  const safePage = Math.min(currentPage, totalPages);
  const paginatedProducts = filteredProducts;

  const formatVND = (amount) =>
    new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0);

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      {/* Toast Alert */}
      <AdminToast feedback={feedback} onClose={() => setFeedback(null)} />

      {/* Header & Tabs */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-black/5 pb-6">
        <div>
          <div className="inline-flex items-center gap-2 text-[10px] uppercase tracking-[0.25em] font-bold text-[#C6A77B] mb-1">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Danh mục sản phẩm</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D]">
            Quản Lý Sản Phẩm
          </h2>
          <p className="text-xs text-zinc-500 mt-1">
            Quản lý thông tin chi tiết, hình ảnh minh họa, giá bán và trạng thái tồn kho
          </p>
        </div>

        {/* Actions & Tabs */}
        <div className="flex items-center gap-3 flex-wrap">

          {/* Tabs */}
          <div className="flex items-center gap-1.5 p-1.5 bg-black/5 rounded-full">
            <button
              onClick={() => {
                setActiveTab('active');
                setCurrentPage(1);
              }}
              className={`px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider transition-all duration-200 flex items-center gap-2 cursor-pointer ${activeTab === 'active'
                ? 'bg-[#0B0B0D] text-[#C6A77B] shadow-md'
                : 'text-zinc-600 hover:text-[#0B0B0D]'
                }`}
            >
              <Package className="w-3.5 h-3.5" />
              <span>Đang bán ({activeProductTotal})</span>
            </button>

            <button
              onClick={() => {
                setActiveTab('trash');
                setCurrentPage(1);
              }}
              className={`px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider transition-all duration-200 flex items-center gap-2 cursor-pointer ${activeTab === 'trash'
                ? 'bg-rose-600 text-white shadow-md'
                : 'text-zinc-600 hover:text-rose-600'
                }`}
            >
              <Trash2 className="w-3.5 h-3.5" />
              <span>
                Thùng rác (
                <span className={trashCountIncreased ? 'font-extrabold text-rose-700' : ''}>
                  {trashTotal}
                </span>
                )
              </span>
            </button>
          </div>
        </div>
      </div>

      {/* Filter and Action Bar */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-3 bg-white p-4 rounded-3xl border border-black/5 shadow-sm">
        <div className="relative w-full sm:w-96">
          <Search className="w-4 h-4 absolute left-3.5 top-3 text-zinc-400" />
          <input
            type="text"
            placeholder="Tìm theo tên sản phẩm hoặc từ khóa..."
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
              setCurrentPage(1);
            }}
            className="w-full pl-10 pr-4 py-2.5 text-xs rounded-full border border-zinc-200 bg-[#F8F7F4] focus:bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition"
          />
        </div>

        <div className="flex items-center gap-2.5 w-full sm:w-auto justify-end">
          {activeTab === 'active' && (
            <button
              onClick={handleOpenCreate}
              className="flex items-center gap-2 px-4 py-2.5 rounded-full bg-[#C6A77B]/15 hover:bg-[#C6A77B]/25 text-[#0B0B0D] text-xs font-bold uppercase tracking-wider transition cursor-pointer border border-[#C6A77B]/30"
            >
              <span>Tạo sản phẩm</span>
            </button>
          )}

          {activeTab === 'trash' && trashTotal > 0 && (
            <button
              onClick={handleRestoreAll}
              className="flex items-center gap-2 px-5 py-2.5 rounded-full bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold uppercase tracking-wider shadow-sm transition cursor-pointer"
            >
              <RotateCcw className="w-3.5 h-3.5" />
              <span>Khôi phục tất cả</span>
            </button>
          )}
        </div>
      </div>

      {/* Product Table */}
      <div className="bg-white rounded-3xl border border-black/5 shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-16 text-center flex flex-col items-center justify-center gap-3 text-zinc-400">
            <Loader2 className="w-7 h-7 animate-spin text-[#C6A77B]" />
            <span className="text-xs font-medium">Đang tải dữ liệu sản phẩm...</span>
          </div>
        ) : filteredProducts.length === 0 ? (
          <div className="p-16 text-center text-zinc-400 text-xs">
            {activeTab === 'active' ? 'Không tìm thấy sản phẩm nào đang bán.' : 'Thùng rác trống.'}
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-[#F8F7F4] text-zinc-600 font-bold uppercase tracking-wider text-[10px] border-b border-black/5">
                <tr>
                  <th className="py-3.5 px-5">Ảnh</th>
                  <th className="py-3.5 px-5">Tên sản phẩm</th>
                  <th className="py-3.5 px-5">Giá bán niêm yết</th>
                  <th className="py-3.5 px-5">Tồn kho</th>
                  <th className="py-3.5 px-5">Ảnh chính</th>
                  <th className="py-3.5 px-5">Ảnh phụ</th>
                  <th className="py-3.5 px-5 text-right">Thao tác</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-black/5 text-[#0B0B0D]">
                {paginatedProducts.map((p) => {
                  const img =
                    p.mainImageUrl ||
                    p.additionalImageUrls?.[0] ||
                    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200';

                  const categoryObj = categories.find((c) => c.id === p.categoryId);
                  const brandObj = brands.find((b) => b.id === p.brandId);

                  return (
                    <tr key={p.id} className="hover:bg-[#F8F7F4]/50 transition-colors">
                      {/* Image Thumbnail */}
                      <td className="py-3 px-5">
                        <div className="w-12 h-14 rounded-xl overflow-hidden bg-zinc-100 border border-black/10 shrink-0">
                          <img
                            src={img}
                            alt={p.name}
                            className="w-full h-full object-cover"
                            onError={(e) => {
                              e.target.src =
                                'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200';
                            }}
                          />
                        </div>
                      </td>

                      {/* Name, Category & Desc */}
                      <td className="py-3 px-5 max-w-xs">
                        <div className="flex items-center gap-1.5 flex-wrap mb-0.5">
                          {p.tag && (
                            <span className="px-1.5 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider bg-[#0B0B0D] text-[#C6A77B]">
                              {p.tag}
                            </span>
                          )}
                          {categoryObj && (
                            <span className="px-1.5 py-0.5 rounded text-[9px] font-semibold bg-zinc-100 text-zinc-600">
                              {categoryObj.name}
                            </span>
                          )}
                          {brandObj && (
                            <span className="px-1.5 py-0.5 rounded text-[9px] font-semibold bg-amber-50 text-amber-800 border border-amber-200">
                              {brandObj.name}
                            </span>
                          )}
                        </div>
                        <p className="font-bold text-[#0B0B0D] truncate text-xs">{p.name}</p>
                        <p className="text-[11px] text-zinc-400 font-normal line-clamp-1 mt-0.5">
                          {p.description || 'Chưa có mô tả chi tiết'}
                        </p>
                      </td>

                      {/* Price */}
                      <td className="py-3 px-5 font-extrabold text-[#0B0B0D] font-mono">
                        {formatVND(p.price)}
                      </td>

                      {/* Quantity */}
                      <td className="py-3 px-5">
                        <div className="flex flex-col gap-1">
                          <span
                            className={`inline-block w-fit px-2.5 py-1 rounded-full font-bold text-[10px] uppercase tracking-wider ${p.quantity > 5
                              ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                              : p.quantity > 0
                                ? 'bg-amber-50 text-amber-800 border border-amber-200'
                                : 'bg-rose-50 text-rose-800 border border-rose-200'
                              }`}
                          >
                            {p.quantity} chiếc
                          </span>
                          {p.quantity > 0 && (() => {
                            const stock = calculateProductSizeStock(p);
                            return (
                              <div className="text-[10px] text-zinc-500 font-mono tracking-tight flex items-center gap-1">
                                <span>S:{stock.S}</span>
                                <span className="text-zinc-300">·</span>
                                <span>M:{stock.M}</span>
                                <span className="text-zinc-300">·</span>
                                <span>L:{stock.L}</span>
                                <span className="text-zinc-300">·</span>
                                <span>XL:{stock.XL}</span>
                              </div>
                            );
                          })()}
                        </div>
                      </td>

                      {/* Main Image Upload Trigger */}
                      <td className="py-3 px-5">
                        {activeTab === 'active' && (
                          <label className="cursor-pointer inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-zinc-100 hover:bg-zinc-200 text-[#0B0B0D] font-bold text-[11px] transition">
                            {uploadingImageId === p.id ? (
                              <Loader2 className="w-3.5 h-3.5 animate-spin text-[#C6A77B]" />
                            ) : (
                              <Upload className="w-3.5 h-3.5 text-[#C6A77B]" />
                            )}
                            <span>{uploadingImageId === p.id ? 'Đang tải...' : 'Đổi ảnh'}</span>
                            <input
                              type="file"
                              accept="image/*"
                              className="hidden"
                              onChange={(e) => handleUploadMainImage(p.id, e.target.files?.[0])}
                            />
                          </label>
                        )}
                      </td>

                      {/* Additional Image Management */}
                      <td className="py-3 px-5">
                        {activeTab === 'active' && (
                          <button
                            type="button"
                            onClick={() => handleOpenImages(p)}
                            className="cursor-pointer inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[#C6A77B]/15 hover:bg-[#C6A77B]/25 text-[#0B0B0D] font-bold text-[11px] transition"
                          >
                            <ImagePlus className="w-3.5 h-3.5 text-[#A98756]" />
                            <span>Quản lý ảnh</span>
                          </button>
                        )}
                      </td>

                      {/* Actions */}
                      <td className="py-3 px-5 text-right">
                        {activeTab === 'active' ? (
                          <div className="flex items-center justify-end gap-1.5">
                            <button
                              onClick={() => handleOpenEdit(p)}
                              title="Sửa thông tin sản phẩm"
                              className="p-2 rounded-xl text-zinc-600 hover:text-[#0B0B0D] hover:bg-[#C6A77B]/15 transition cursor-pointer"
                            >
                              <Edit className="w-4 h-4 text-[#C6A77B]" />
                            </button>
                            <button
                              onClick={() => handleDelete(p)}
                              title="Chuyển vào thùng rác"
                              className="p-2 rounded-xl text-zinc-400 hover:text-rose-600 hover:bg-rose-50 transition cursor-pointer"
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </div>
                        ) : (
                          <div className="flex items-center justify-end gap-2">
                            <button
                              onClick={() => handleRestore(p)}
                              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-emerald-50 text-emerald-700 hover:bg-emerald-100 border border-emerald-200 font-bold transition text-[11px] cursor-pointer"
                            >
                              <RotateCcw className="w-3 h-3" />
                              Khôi phục
                            </button>
                            <button
                              onClick={() => handleDeletePermanent(p.id)}
                              className="px-3 py-1.5 rounded-full bg-rose-50 text-rose-600 hover:bg-rose-100 border border-rose-200 font-bold transition text-[11px] cursor-pointer"
                            >
                              Xóa vĩnh viễn
                            </button>
                          </div>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <AdminPagination
        totalItems={totalItems}
        currentPage={safePage}
        pageSize={pageSize}
        onPageChange={setCurrentPage}
      />

      {/* ================= MODAL TẠO SẢN PHẨM MỚI ================= */}
      {creatingProduct && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-2xl max-h-[92vh] overflow-y-auto bg-white rounded-3xl p-6 sm:p-8 shadow-2xl border border-black/10">
            {/* Modal Header */}
            <div className="flex items-start justify-between pb-4 border-b border-black/5">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center shadow-md">
                  <Package className="w-5 h-5" />
                </div>
                <div>
                  <div className="inline-flex items-center gap-1.5 text-[10px] uppercase tracking-[0.2em] font-bold text-[#C6A77B]">
                    <Sparkles className="w-3 h-3" />
                    <span>Bộ Sưu Tập Mới</span>
                  </div>
                  <h3 className="text-xl font-extrabold text-[#0B0B0D] tracking-tight">
                    Thêm Sản Phẩm Mới
                  </h3>
                </div>
              </div>
              <button
                onClick={() => setCreatingProduct(false)}
                className="p-2 rounded-full hover:bg-zinc-100 text-zinc-400 hover:text-zinc-700 transition cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Create Form */}
            <form onSubmit={handleSaveCreate} className="space-y-5 text-xs mt-5">
              {/* Row 1: Tên sản phẩm */}
              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Tên sản phẩm <span className="text-rose-500">*</span>
                </label>
                <input
                  type="text"
                  placeholder="VD: Đầm Dạ Hội Lụa Tơ Tằm Cúp Ngực Sang Trọng..."
                  value={createForm.name}
                  onChange={(e) => setCreateForm({ ...createForm, name: e.target.value })}
                  className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs"
                  required
                />
              </div>

              {/* Row 2: Danh mục, Thương hiệu, Giới tính */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Danh mục <span className="text-rose-500">*</span>
                  </label>
                  <select
                    value={createForm.categoryId}
                    onChange={(e) => setCreateForm({ ...createForm, categoryId: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs"
                    required
                  >
                    <option value="">-- Chọn danh mục --</option>
                    {categories.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Thương hiệu
                  </label>
                  <select
                    value={createForm.brandId}
                    onChange={(e) => setCreateForm({ ...createForm, brandId: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs"
                  >
                    <option value="">-- Không có / Tự do --</option>
                    {brands.map((b) => (
                      <option key={b.id} value={b.id}>
                        {b.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Phân loại giới tính
                  </label>
                  <select
                    value={createForm.gender}
                    onChange={(e) => setCreateForm({ ...createForm, gender: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs"
                  >
                    <option value="UNISEX">Unisex (Tất cả)</option>
                    <option value="FEMALE">Thời trang Nữ</option>
                    <option value="MALE">Thời trang Nam</option>
                  </select>
                </div>
              </div>

              {/* Row 3: Giá bán, Tồn kho, Tag */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Giá bán niêm yết (VNĐ) <span className="text-rose-500">*</span>
                  </label>
                  <input
                    type="number"
                    step="1000"
                    min="1000"
                    placeholder="VD: 450000"
                    value={createForm.price}
                    onChange={(e) => setCreateForm({ ...createForm, price: e.target.value })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs font-mono"
                    required
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Số lượng tồn kho <span className="text-rose-500">*</span>
                  </label>
                  <input
                    type="number"
                    min="0"
                    placeholder="VD: 50"
                    value={createForm.quantity}
                    onChange={(e) => setCreateForm({ ...createForm, quantity: e.target.value })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs"
                    required
                  />
                  {parseInt(createForm.quantity, 10) > 0 && (() => {
                    const preview = calculateProductSizeStock({ id: 1, quantity: createForm.quantity });
                    return (
                      <div className="mt-1 text-[10px] text-zinc-500 font-mono tracking-tight">
                        Phân bổ: S:{preview.S} · M:{preview.M} · L:{preview.L} · XL:{preview.XL}
                      </div>
                    );
                  })()}
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Nhãn nổi bật (Tag)
                  </label>
                  <select
                    value={createForm.tag}
                    onChange={(e) => setCreateForm({ ...createForm, tag: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B] transition text-xs"
                  >
                    <option value="">Không gắn nhãn</option>
                    <option value="new">Hàng mới về (NEW)</option>
                    <option value="hot">Bán chạy nhất (HOT)</option>
                    <option value="sale">Khuyến mãi (SALE)</option>
                  </select>
                </div>
              </div>

              {/* Row 4: Hình ảnh chính (Tải file hoặc dán URL) */}
              <div className="p-4 rounded-2xl bg-[#F8F7F4] border border-black/5 space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-[11px] font-bold text-zinc-800 uppercase tracking-wider flex items-center gap-1.5">
                    <ImageIcon className="w-3.5 h-3.5 text-[#C6A77B]" />
                    Ảnh chính của sản phẩm
                  </span>
                  <span className="text-[10px] text-zinc-400">Chọn tệp ảnh hoặc dán URL</span>
                </div>

                <div className="flex flex-col sm:flex-row items-center gap-4">
                  {/* Image Preview */}
                  <div className="w-20 h-24 rounded-xl overflow-hidden bg-white border border-black/10 shrink-0 flex items-center justify-center">
                    {createMainPreview || createForm.imageUrl ? (
                      <img
                        src={createMainPreview || createForm.imageUrl}
                        alt="Preview"
                        className="w-full h-full object-cover"
                        onError={(e) => {
                          e.target.src =
                            'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=200';
                        }}
                      />
                    ) : (
                      <div className="text-center p-2 text-zinc-300">
                        <ImageIcon className="w-6 h-6 mx-auto mb-1" />
                        <span className="text-[9px]">Chưa có</span>
                      </div>
                    )}
                  </div>

                  {/* Upload Controls */}
                  <div className="flex-1 space-y-2 w-full">
                    <div className="flex items-center gap-2">
                      <label className="cursor-pointer inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-white hover:bg-zinc-100 border border-zinc-200 text-[#0B0B0D] font-bold text-xs transition shadow-sm">
                        <Upload className="w-3.5 h-3.5 text-[#C6A77B]" />
                        <span>{createMainFile ? 'Đổi tệp ảnh' : 'Tải ảnh từ máy'}</span>
                        <input
                          type="file"
                          accept="image/jpeg,image/png,image/webp"
                          className="hidden"
                          onChange={(e) => handleSelectMainImage(e.target.files?.[0])}
                        />
                      </label>
                      {createMainFile && (
                        <span className="text-[11px] text-emerald-600 font-semibold truncate">
                          ✓ Đã chọn: {createMainFile.name}
                        </span>
                      )}
                    </div>

                    <div className="relative">
                      <LinkIcon className="w-3.5 h-3.5 absolute left-3 top-2.5 text-zinc-400" />
                      <input
                        type="url"
                        placeholder="Hoặc dán URL ảnh trực tiếp (https://...)"
                        value={createForm.imageUrl}
                        onChange={(e) => setCreateForm({ ...createForm, imageUrl: e.target.value })}
                        className="w-full pl-8 pr-3 py-1.5 text-xs rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                      />
                    </div>
                  </div>
                </div>
              </div>

              {/* Row 5: Ảnh phụ bổ sung (Tùy chọn) */}
              <div className="p-4 rounded-2xl bg-[#F8F7F4] border border-black/5 space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-[11px] font-bold text-zinc-800 uppercase tracking-wider flex items-center gap-1.5">
                    <ImagePlus className="w-3.5 h-3.5 text-[#C6A77B]" />
                    Ảnh phụ chi tiết (Tùy chọn)
                  </span>
                  <label className="cursor-pointer inline-flex items-center gap-1 text-[11px] font-bold text-[#A98756] hover:underline">
                    <span>Chọn nhiều ảnh</span>
                    <input
                      type="file"
                      accept="image/jpeg,image/png,image/webp"
                      multiple
                      className="hidden"
                      onChange={(e) => handleSelectAdditionalImages(e.target.files)}
                    />
                  </label>
                </div>

                {createAdditionalPreviews.length > 0 ? (
                  <div className="flex items-center gap-2.5 overflow-x-auto py-1">
                    {createAdditionalPreviews.map((item, idx) => (
                      <div
                        key={idx}
                        className="relative w-16 h-20 rounded-xl overflow-hidden bg-white border border-black/10 shrink-0 group"
                      >
                        <img src={item.url} alt={`Ảnh phụ ${idx + 1}`} className="w-full h-full object-cover" />
                        <button
                          type="button"
                          onClick={() => handleRemoveAdditionalPreview(idx)}
                          className="absolute top-1 right-1 p-1 rounded-full bg-black/70 hover:bg-rose-600 text-white transition cursor-pointer"
                        >
                          <X className="w-2.5 h-2.5" />
                        </button>
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="text-[11px] text-zinc-400 italic">
                    Chưa có ảnh phụ nào được chọn. Bạn có thể chọn nhiều ảnh hoặc thêm sau trong mục Quản lý ảnh.
                  </p>
                )}
              </div>

              {/* Row 6: Mô tả sản phẩm */}
              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Mô tả sản phẩm
                </label>
                <textarea
                  rows="3"
                  placeholder="Mô tả phong cách thiết kế, chất liệu vải, kiểu dáng, hướng dẫn bảo quản..."
                  value={createForm.description}
                  onChange={(e) => setCreateForm({ ...createForm, description: e.target.value })}
                  className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] resize-none text-xs"
                ></textarea>
              </div>

              {/* Actions Footer */}
              <div className="flex justify-end gap-2.5 pt-4 border-t border-black/5">
                <button
                  type="button"
                  onClick={() => setCreatingProduct(false)}
                  className="px-5 py-2.5 rounded-full border border-black/10 text-zinc-700 hover:bg-zinc-50 font-bold uppercase tracking-wider text-[11px] cursor-pointer"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={submitting}
                  className="px-6 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-[#C6A77B] hover:text-[#e4c9a4] font-bold uppercase tracking-wider text-[11px] flex items-center gap-2 shadow-lg disabled:opacity-50 cursor-pointer"
                >
                  {submitting && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  <span>{submitting ? 'Đang tạo...' : 'Tạo sản phẩm ngay'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ================= MODAL QUẢN LÝ ẢNH PHỤ ================= */}
      {managingImagesProduct && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <div className="w-full max-w-3xl max-h-[90vh] overflow-y-auto bg-white rounded-3xl p-6 sm:p-8 shadow-2xl border border-black/10">
            <div className="flex items-start justify-between gap-4 pb-4 border-b border-black/5">
              <div>
                <div className="flex items-center gap-2 text-[#A98756] mb-1">
                  <ImageIcon className="w-4 h-4" />
                  <span className="text-[10px] uppercase tracking-[0.2em] font-bold">Thư viện sản phẩm</span>
                </div>
                <h3 className="text-lg font-extrabold text-[#0B0B0D]">
                  Quản lý ảnh phụ · {managingImagesProduct.name}
                </h3>
                <p className="text-xs text-zinc-500 mt-1">
                  Có thể tải lên nhiều ảnh, thay ảnh hoặc xóa từng ảnh.
                </p>
              </div>
              <button
                type="button"
                onClick={() => setManagingImagesProduct(null)}
                className="p-2 rounded-full hover:bg-zinc-100 text-zinc-500 cursor-pointer"
                aria-label="Đóng quản lý ảnh phụ"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <label
              className={`mt-5 cursor-pointer inline-flex items-center gap-2 px-4 py-2.5 rounded-full bg-[#0B0B0D] text-[#C6A77B] text-xs font-bold hover:bg-black transition ${savingProductImages ? 'opacity-60 pointer-events-none' : ''
                }`}
            >
              {savingProductImages ? (
                <Loader2 className="w-4 h-4 animate-spin" />
              ) : (
                <Upload className="w-4 h-4" />
              )}
              <span>{savingProductImages ? 'Đang xử lý...' : 'Tải lên nhiều ảnh phụ'}</span>
              <input
                type="file"
                accept="image/jpeg,image/png,image/webp"
                multiple
                className="hidden"
                disabled={savingProductImages}
                onChange={(event) => {
                  handleAddAdditionalImages(Array.from(event.target.files || []));
                  event.target.value = '';
                }}
              />
            </label>

            {loadingProductImages ? (
              <div className="py-14 flex items-center justify-center gap-2 text-zinc-500 text-sm">
                <Loader2 className="w-5 h-5 animate-spin text-[#C6A77B]" />
                Đang tải danh sách ảnh...
              </div>
            ) : productImages.length === 0 ? (
              <div className="mt-5 rounded-2xl border border-dashed border-zinc-300 py-12 text-center text-sm text-zinc-500">
                <ImageIcon className="w-8 h-8 mx-auto mb-2 text-zinc-300" />
                Sản phẩm chưa có ảnh phụ. Hãy tải lên một hoặc nhiều ảnh.
              </div>
            ) : (
              <div className="mt-5 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
                {productImages.map((image) => (
                  <div key={image.id} className="rounded-2xl border border-black/10 bg-[#F8F7F4] p-2.5">
                    <div className="aspect-[4/5] rounded-xl overflow-hidden bg-white">
                      <img
                        src={image.imageUrl}
                        alt={image.altText || managingImagesProduct.name}
                        className="w-full h-full object-cover"
                      />
                    </div>
                    <div className="mt-2.5 flex items-center justify-between gap-2">
                      <label
                        className={`cursor-pointer inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-full bg-white hover:bg-zinc-100 text-[11px] font-bold ${savingProductImages ? 'opacity-60 pointer-events-none' : ''
                          }`}
                      >
                        <Edit className="w-3.5 h-3.5 text-[#A98756]" />
                        <span>Sửa ảnh</span>
                        <input
                          type="file"
                          accept="image/jpeg,image/png,image/webp"
                          className="hidden"
                          disabled={savingProductImages}
                          onChange={(event) => {
                            handleReplaceAdditionalImage(image.id, event.target.files?.[0]);
                            event.target.value = '';
                          }}
                        />
                      </label>
                      <button
                        type="button"
                        onClick={() => handleDeleteAdditionalImage(image.id)}
                        disabled={savingProductImages}
                        title="Xóa ảnh phụ"
                        className="p-2 rounded-full text-zinc-400 hover:text-rose-600 hover:bg-rose-50 disabled:opacity-50 cursor-pointer"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      )}

      {/* ================= MODAL CHỈNH SỬA SẢN PHẨM ================= */}
      {editingProduct && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-lg bg-white rounded-3xl p-7 shadow-2xl space-y-5 border border-black/10">
            <div className="flex items-center justify-between pb-3 border-b border-black/5">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-xl bg-[#0B0B0D] text-[#C6A77B] flex items-center justify-center">
                  <Edit className="w-4 h-4" />
                </div>
                <h3 className="text-base font-extrabold text-[#0B0B0D] tracking-tight">
                  Chỉnh Sửa Sản Phẩm #{editingProduct.id}
                </h3>
              </div>
              <button
                onClick={() => setEditingProduct(null)}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-400 hover:text-zinc-700 transition cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSaveEdit} className="space-y-4 text-xs">
              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Tên sản phẩm
                </label>
                <input
                  type="text"
                  value={editForm.name}
                  onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                  className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Danh mục
                  </label>
                  <select
                    value={editForm.categoryId}
                    onChange={(e) => setEditForm({ ...editForm, categoryId: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  >
                    <option value="">-- Chọn danh mục --</option>
                    {categories.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Thương hiệu
                  </label>
                  <select
                    value={editForm.brandId}
                    onChange={(e) => setEditForm({ ...editForm, brandId: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  >
                    <option value="">-- Không có --</option>
                    {brands.map((b) => (
                      <option key={b.id} value={b.id}>
                        {b.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Giá bán niêm yết (VNĐ)
                  </label>
                  <input
                    type="number"
                    step="1000"
                    min="1000"
                    value={editForm.price}
                    onChange={(e) => setEditForm({ ...editForm, price: e.target.value })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Số lượng tồn kho
                  </label>
                  <input
                    type="number"
                    min="0"
                    step="1"
                    value={editForm.quantity}
                    onChange={(e) => setEditForm({ ...editForm, quantity: e.target.value })}
                    className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                    required
                  />
                  {parseInt(editForm.quantity, 10) > 0 && (() => {
                    const preview = calculateProductSizeStock({ id: editingProduct?.id || 1, quantity: editForm.quantity });
                    return (
                      <div className="mt-1 text-[10px] text-zinc-500 font-mono tracking-tight">
                        Phân bổ: S:{preview.S} · M:{preview.M} · L:{preview.L} · XL:{preview.XL}
                      </div>
                    );
                  })()}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Giới tính
                  </label>
                  <select
                    value={editForm.gender}
                    onChange={(e) => setEditForm({ ...editForm, gender: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  >
                    <option value="UNISEX">Unisex</option>
                    <option value="FEMALE">Nữ</option>
                    <option value="MALE">Nam</option>
                  </select>
                </div>

                <div>
                  <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                    Nhãn nổi bật (Tag)
                  </label>
                  <select
                    value={editForm.tag}
                    onChange={(e) => setEditForm({ ...editForm, tag: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-xl border border-zinc-200 bg-white focus:outline-none focus:ring-1 focus:ring-[#C6A77B]"
                  >
                    <option value="">Không có</option>
                    <option value="new">Hàng mới (NEW)</option>
                    <option value="hot">Bán chạy (HOT)</option>
                    <option value="sale">Khuyến mãi (SALE)</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-zinc-700 uppercase tracking-wider mb-1.5">
                  Mô tả sản phẩm
                </label>
                <textarea
                  rows="3"
                  value={editForm.description}
                  onChange={(e) => setEditForm({ ...editForm, description: e.target.value })}
                  className="w-full px-4 py-2.5 rounded-xl border border-zinc-200 focus:outline-none focus:ring-1 focus:ring-[#C6A77B] resize-none"
                ></textarea>
              </div>

              <div className="flex justify-end gap-2.5 pt-4 border-t border-black/5">
                <button
                  type="button"
                  onClick={() => setEditingProduct(null)}
                  className="px-5 py-2.5 rounded-full border border-black/10 text-zinc-700 hover:bg-zinc-50 font-bold uppercase tracking-wider text-[11px] cursor-pointer"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={submitting}
                  className="px-6 py-2.5 rounded-full bg-[#0B0B0D] hover:bg-black text-white font-bold uppercase tracking-wider text-[11px] flex items-center gap-2 shadow-lg disabled:opacity-50 cursor-pointer"
                >
                  {submitting && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
                  <span>{submitting ? 'Đang lưu...' : 'Lưu thay đổi'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
