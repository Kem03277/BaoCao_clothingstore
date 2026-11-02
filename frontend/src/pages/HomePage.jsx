import React, { lazy, Suspense, useEffect, useRef, useState } from "react";
import { useLenis } from "../hooks/useLenis";
import { Header } from "../components/home/Header";
import { Hero } from "../components/home/Hero";
import { Marquee } from "../components/home/Marquee";
import { FeaturedCollection } from "../components/home/FeaturedCollection";
import { Categories } from "../components/home/Categories";
import { BrandShowcase } from "../components/home/BrandShowcase";
import { Lookbook } from "../components/home/Lookbook";
import { Footer } from "../components/home/Footer";
import { productApi } from "../api";

const Showcase3D = lazy(() => import("../components/home/Showcase3D").then((module) => ({
  default: module.Showcase3D,
})));

const DeferredShowcase3D = ({ onNavigateShop }) => {
  const sectionRef = useRef(null);
  const [shouldLoad, setShouldLoad] = useState(false);

  useEffect(() => {
    if (!sectionRef.current || !("IntersectionObserver" in window)) {
      setShouldLoad(true);
      return undefined;
    }

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setShouldLoad(true);
          observer.disconnect();
        }
      },
      { rootMargin: "700px 0px" }
    );
    observer.observe(sectionRef.current);
    return () => observer.disconnect();
  }, []);

  return (
    <div ref={sectionRef} className="min-h-[900px]">
      {shouldLoad && (
        <Suspense fallback={<div className="min-h-[900px]" aria-hidden="true" />}>
          <Showcase3D onNavigateShop={onNavigateShop} />
        </Suspense>
      )}
    </div>
  );
};

/**
 * MASTER HOMEPAGE — CLOTHINGSTORE 3D CINEMATIC EDITORIAL
 * Architectural stack: React + Vite + TailwindCSS + Three.js / R3F + GSAP + ScrollTrigger + Lenis
 * Follows the approved ten-site standard (Nike × Zara × Apple × Awwwards).
 */
export const HomePage = ({
  onNavigateShop,
  onNavigateLogin,
  onNavigateProfile,
  onNavigateOrders,
  onNavigateAdmin,

  onSelectProduct,
  onSelectCategory,
}) => {
  const [featuredProducts, setFeaturedProducts] = useState([]);

  // 1. Initialize Lenis Smooth Scroll synchronized with GSAP ScrollTrigger
  useLenis(true);

  // 2. Fetch real products from Spring Boot REST API
  useEffect(() => {
    let isMounted = true;

    const fetchProducts = async () => {
      try {
        const featuredRes = await productApi.getFeatured();
        const prods = Array.isArray(featuredRes)
          ? featuredRes
          : featuredRes?.content || [];
        if (isMounted) {
          setFeaturedProducts(prods);
        }
      } catch (err) {
        console.error("Lỗi khi tải danh sách sản phẩm:", err);
        if (isMounted) {
          setFeaturedProducts([]);
        }
      }
    };

    fetchProducts();

    return () => {
      isMounted = false;
    };
  }, []);

  return (
    <div className="relative min-h-screen bg-[#F8F7F4] dark:bg-[#09090B] text-[#171717] dark:text-[#EDEDED] selection:bg-[#C6A77B] selection:text-[#0B0B0D] overflow-x-hidden transition-colors duration-500">
      {/* ── Header / Navigation (Fixed, Smart Hide/Reveal on Scroll, Fullscreen Menu) ── */}
      <Header
        onNavigateShop={onNavigateShop}
        onNavigateLogin={onNavigateLogin}
        onNavigateProfile={onNavigateProfile}
        onNavigateOrders={onNavigateOrders}
        onNavigateAdmin={onNavigateAdmin}
        onSelectCategory={onSelectCategory}
      />
      {/* ── B. Hero (Full-Screen 3D R3F Canvas + Split Headline Reveal) ── */}
      <Hero onNavigateShop={onNavigateShop} />
      {/* ── C. Marquee (Infinite Horizontal Scroll with Dynamic Velocity) ── */}
      <Marquee />
      {/* ── D. Featured Collection (ScrollTrigger Pinned Horizontal Slider) ── */}
      <FeaturedCollection
        products={featuredProducts}
        onSelectProduct={onSelectProduct}
        onNavigateShop={onNavigateShop}
      />
      {/* ── E. Showcase 3D Scrollytelling (Pinned Section Scrubbing 4 Architectural Stages) ── */}
      <DeferredShowcase3D onNavigateShop={onNavigateShop} />
      {/* ── F. Categories (Asymmetric Editorial Grid for Men / Women / Accessories) ── */}
      <Categories
        onSelectCategory={onSelectCategory}
        onNavigateShop={onNavigateShop}
      />
      <BrandShowcase />
      {/* ── G. Lookbook / Editorial (Full-Bleed Photographic Composition & Parallax) ── */}
      <Lookbook onNavigateShop={onNavigateShop} />
      {/* ── H. Newsletter + Footer (Giant Watermark Typography & Concierge Links) ── */}
      <Footer
        onNavigateShop={onNavigateShop}
        onSelectCategory={onSelectCategory}
      />
    </div>
  );
};
