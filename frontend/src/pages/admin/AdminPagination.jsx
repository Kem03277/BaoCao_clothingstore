import React from 'react';
import './AdminPagination.css';

export const AdminPagination = ({
  totalItems,
  currentPage,
  pageSize,
  onPageChange,
}) => {
  if (!totalItems) return null;

  const totalPages = Math.ceil(totalItems / pageSize);
  const startPage = Math.max(1, Math.min(currentPage - 2, totalPages - 4));
  const pages = Array.from({ length: Math.min(totalPages, 5) }, (_, index) => startPage + index);

  return (
    <div className="admin-pagination-bar">
      {totalPages > 1 && (
        <nav aria-label="Phân trang danh sách">
          <ul className="pagination admin-pagination">
            <li className={`page-item ${currentPage === 1 ? 'disabled' : ''}`}>
              <button type="button" className="page-link" onClick={() => onPageChange(1)} disabled={currentPage === 1} aria-label="Trang đầu">«</button>
            </li>
            <li className={`page-item ${currentPage === 1 ? 'disabled' : ''}`}>
              <button type="button" className="page-link" onClick={() => onPageChange(currentPage - 1)} disabled={currentPage === 1} aria-label="Trang trước">‹</button>
            </li>
            {pages.map((page) => (
              <li key={page} className={`page-item ${currentPage === page ? 'active' : ''}`}>
                <button
                  type="button"
                  className="page-link"
                  onClick={() => onPageChange(page)}
                  aria-current={currentPage === page ? 'page' : undefined}
                >
                  {page}
                </button>
              </li>
            ))}
            <li className={`page-item ${currentPage === totalPages ? 'disabled' : ''}`}>
              <button type="button" className="page-link" onClick={() => onPageChange(currentPage + 1)} disabled={currentPage === totalPages} aria-label="Trang tiếp">›</button>
            </li>
            <li className={`page-item ${currentPage === totalPages ? 'disabled' : ''}`}>
              <button type="button" className="page-link" onClick={() => onPageChange(totalPages)} disabled={currentPage === totalPages} aria-label="Trang cuối">»</button>
            </li>
          </ul>
        </nav>
      )}
    </div>
  );
};
