import React, { useRef, useState, useEffect, Suspense } from 'react';
import { Canvas, useFrame, useThree } from '@react-three/fiber';
import { ContactShadows, Sparkles, OrbitControls, Environment } from '@react-three/drei';
import * as THREE from 'three';
import { useGSAP } from '@gsap/react';
import { gsap, ScrollTrigger } from '../../lib/gsap';
import {
  Sparkles as SparklesIcon, CheckCircle2, ShieldCheck,
  ArrowRight, RotateCw, ZoomIn, Compass, Palette, Eye, RotateCcw
} from 'lucide-react';
import { ShirtModel } from '../three/ShirtModel';

/**
 * 5 Calibrated Fabric Colors with Tailored Sheen and Descriptions
 * - Noir Obsidian: Deep black with soft dark heather gray fuzz
 * - Champagne Gold: Royal golden yellow with warm peach-skin halo
 * - Midnight Navy: Deep imperial navy with rich luster
 * - Bordeaux Royale: Rich wine red with velvet halo
 * - Pure Pearl Silk: Unbleached ivory calibrated to prevent highlight blowouts
 */
export const COLOR_SWATCHES = [
  {
    id: 'obsidian',
    name: 'NOIR OBSIDIAN',
    vietnamese: 'Đen Tuyền Nguyên Khối',
    color: '#121215',
    sheen: '#28282D',
    swatch: '#141418',
    fabricDesc: 'Sợi Cotton Ai Cập chải kỹ 290 GSM · Nhuộm đen sâu phản quang dịu',
  },
  {
    id: 'champagne',
    name: 'CHAMPAGNE GOLD',
    vietnamese: 'Vàng Champagne Vương Giả',
    color: '#BA976B',
    sheen: '#FAF2E6',
    swatch: '#BA976B',
    fabricDesc: 'Sợi bông sợi dài nhuộm vàng Champagne · Ánh sáng mờ xơ vải ấm áp',
  },
  {
    id: 'navy',
    name: 'MIDNIGHT NAVY',
    vietnamese: 'Xanh Navy Hoàng Gia',
    color: '#131A28',
    sheen: '#2C3E61',
    swatch: '#1A2536',
    fabricDesc: 'Dệt thoi nhuộm chàm sâu thẳm · Giữ độ bóng tự nhiên của sợi cotton',
  },
  {
    id: 'bordeaux',
    name: 'BORDEAUX ROYALE',
    vietnamese: 'Đỏ Rượu Bordeaux',
    color: '#321118',
    sheen: '#61212E',
    swatch: '#4A1823',
    fabricDesc: 'Sắc đỏ rượu quý phái · Hiệu ứng Peach-skin mềm mại như nhung',
  },
  {
    id: 'pearl',
    name: 'PURE PEARL SILK',
    vietnamese: 'Trắng Ngọc Trai Lụa',
    color: '#C4BDAE',
    sheen: '#ACA495',
    swatch: '#E8E3DA',
    fabricDesc: 'Sợi bông mộc tự nhiên không tẩy clo · Độ sáng cân bằng không chói lóa',
  },
];

const STAGES = [
  {
    step: '01',
    title: 'Cắt May 3D Ergonomic',
    headline: 'Đường Phom Chuẩn Mực Bespoke',
    desc: 'Cấu trúc ve áo kép định hình bằng mô phỏng kỹ thuật số 3D, ôm trọn bờ vai và tạo phom đứng sang trọng mà vẫn thoải mái tối đa khi cử động.',
    image: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?auto=format&fit=crop&w=900&q=80',
    rotationY: 0,
    badge: 'Stage 01 · 3D Drafting',
  },
  {
    step: '02',
    title: 'Khuy Áo Chạm Khắc Laser',
    headline: 'Hợp Kim Mạ Vàng Champagne 18K',
    desc: 'Nguyên khối hợp kim chống oxy hóa được phay CNC chuẩn vi mô, khắc chìm biểu tượng độc bản của ClothingStore Atelier.',
    image: 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?auto=format&fit=crop&w=900&q=80',
    rotationY: Math.PI * 0.45,
    badge: 'Stage 02 · Laser Detailing',
  },
  {
    step: '03',
    title: 'Sợi Dệt Tự Nhiên Thượng Hạng',
    headline: 'Tiêu Chuẩn OEKO-TEX Standard 100',
    desc: 'Lụa tơ tằm Mulberry kết hợp sợi bông Ai Cập chải kỹ, đem lại khả năng điều hòa thân nhiệt tự nhiên và êm dịu trên làn da.',
    image: 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?auto=format&fit=crop&w=900&q=80',
    rotationY: Math.PI * 0.95,
    badge: 'Stage 03 · Pure Fabric',
  },
  {
    step: '04',
    title: 'Hoàn Thiện Tác Phẩm',
    headline: 'Tôn Vinh Bản Lĩnh & Khí Chất',
    desc: 'Không chạy theo xu hướng nhất thời, mỗi mẫu thiết kế được sinh ra để trở thành di sản bền bỉ cùng năm tháng trong tủ đồ của bạn.',
    image: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=900&q=80',
    rotationY: Math.PI * 1.5,
    badge: 'Stage 04 · Final Silhouette',
  },
];

/**
 * Camera Zoom Controller triggered by 3D Hotspot clicks
 */
function CameraHotspotController({ activeHotspot, controlsRef }) {
  const { camera } = useThree();

  useEffect(() => {
    if (!controlsRef.current) return;

    if (activeHotspot === '1') {
      // Zoom into Collar detail
      gsap.to(camera.position, {
        x: 0,
        y: 0.52,
        z: 2.1,
        duration: 1.1,
        ease: 'power3.out',
      });
      gsap.to(controlsRef.current.target, {
        x: 0,
        y: 0.38,
        z: 0,
        duration: 1.1,
        ease: 'power3.out',
      });
    } else if (activeHotspot === '2') {
      // Zoom into Shoulder / Seam detail
      gsap.to(camera.position, {
        x: 0.8,
        y: 0.28,
        z: 2.2,
        duration: 1.1,
        ease: 'power3.out',
      });
      gsap.to(controlsRef.current.target, {
        x: 0.35,
        y: 0.16,
        z: 0,
        duration: 1.1,
        ease: 'power3.out',
      });
    } else if (activeHotspot === '3') {
      // Zoom into Bottom Hem stitch
      gsap.to(camera.position, {
        x: 0,
        y: -0.65,
        z: 2.3,
        duration: 1.1,
        ease: 'power3.out',
      });
      gsap.to(controlsRef.current.target, {
        x: 0,
        y: -0.52,
        z: 0,
        duration: 1.1,
        ease: 'power3.out',
      });
    } else {
      // Reset to default studio overview
      gsap.to(camera.position, {
        x: 0,
        y: 0.4,
        z: 4.2,
        duration: 1.0,
        ease: 'power3.out',
      });
      gsap.to(controlsRef.current.target, {
        x: 0,
        y: 0,
        z: 0,
        duration: 1.0,
        ease: 'power3.out',
      });
    }
  }, [activeHotspot, camera, controlsRef]);

  return null;
}

/**
 * 3D Model with smooth rotation interpolation between stages and mirror pedestal
 */
function ShowcaseStageModel({
  activeStage,
  colorConfig,
  showHotspots,
  activeHotspot,
  onHotspotClick,
}) {
  const modelRef = useRef();
  const targetRotation = STAGES[activeStage]?.rotationY || 0;

  useFrame((state, delta) => {
    if (!modelRef.current) return;
    // Smooth damp towards target rotation of current stage
    modelRef.current.rotation.y = THREE.MathUtils.damp(
      modelRef.current.rotation.y,
      targetRotation,
      2.5,
      delta
    );
  });

  return (
    <group ref={modelRef}>
      {/* Studio Circular Mirror Pedestal (High-reflectivity Obsidian Stone) */}
      <mesh position={[0, -1.35, 0]} receiveShadow>
        <cylinderGeometry args={[2.0, 2.2, 0.22, 64]} />
        <meshStandardMaterial color="#0B0B0E" roughness={0.18} metalness={0.7} />
      </mesh>

      {/* Radiant Golden Trim Ring (Highlight running around pedestal) */}
      <mesh position={[0, -1.23, 0]} rotation={[-Math.PI / 2, 0, 0]}>
        <ringGeometry args={[1.92, 1.99, 64]} />
        <meshStandardMaterial
          color="#C6A77B"
          emissive="#C6A77B"
          emissiveIntensity={0.65}
          roughness={0.2}
          metalness={0.95}
          side={THREE.DoubleSide}
        />
      </mesh>

      {/* Dark Reflective Runway Top Surface */}
      <mesh position={[0, -1.22, 0]} rotation={[-Math.PI / 2, 0, 0]}>
        <circleGeometry args={[1.9, 64]} />
        <meshStandardMaterial
          color="#070709"
          roughness={0.2}
          metalness={0.8}
        />
      </mesh>

      {/* Authentic Real 3D Garment Form with Physical Sheen & Hotspots */}
      <group position={[0, 0.38, 0]}>
        <ShirtModel
          materialColor={colorConfig.color}
          sheenColor={colorConfig.sheen}
          interactive={false}
          scale={1.12}
          showHotspots={showHotspots}
          activeHotspot={activeHotspot}
          onHotspotClick={onHotspotClick}
        />
      </group>
    </group>
  );
}

export const Showcase3D = ({ onNavigateShop }) => {
  const containerRef = useRef(null);
  const controlsRef = useRef(null);
  const idleTimerRef = useRef(null);

  const [activeStage, setActiveStage] = useState(0);
  const [autoRotate, setAutoRotate] = useState(false);
  const [activeColor, setActiveColor] = useState(COLOR_SWATCHES[0]);
  const [showHotspots, setShowHotspots] = useState(true);
  const [activeHotspot, setActiveHotspot] = useState(null);

  // Resume auto-rotate after 3 seconds of user inactivity
  const handleControlStart = () => {
    if (idleTimerRef.current) clearTimeout(idleTimerRef.current);
  };

  const handleControlEnd = () => {
    if (idleTimerRef.current) clearTimeout(idleTimerRef.current);
    idleTimerRef.current = setTimeout(() => {
      // Auto-resume subtle rotation after 3s idle if no zoomed hotspot
      if (!activeHotspot) {
        setAutoRotate(true);
      }
    }, 3000);
  };

  // ScrollTrigger linked entrance and stage progression without scroll hijacking / pinning
  useGSAP(
    () => {
      const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      if (prefersReducedMotion) return;

      // Entrance animation
      gsap.fromTo(
        '.showcase-reveal',
        { y: 50, opacity: 0 },
        {
          y: 0,
          opacity: 1,
          duration: 1,
          stagger: 0.12,
          ease: 'power3.out',
          scrollTrigger: {
            trigger: containerRef.current,
            start: 'top 75%',
            once: true,
          },
        }
      );
    },
    { scope: containerRef }
  );

  const stage = STAGES[activeStage];

  return (
    <section
      id="showroom-3d"
      ref={containerRef}
      className="relative bg-[#F8F7F4] dark:bg-[#09090B] text-[#0B0B0D] dark:text-white py-24 sm:py-32 overflow-hidden border-t border-black/5 dark:border-white/5 z-10 transition-colors duration-500"
      aria-label="3D Interactive Showcase"
    >
      {/* Background Subtle Ambience */}
      <div className="absolute top-1/3 left-1/4 w-[500px] h-[500px] rounded-full blur-[160px] pointer-events-none bg-[#C6A77B]/5" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Top Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-16">
          <div className="space-y-3 showcase-reveal">
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/5 dark:bg-white/10 border border-[#C6A77B]/30 backdrop-blur-md">
              <SparklesIcon className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
                Interactive 3D Showroom
              </span>
            </div>
            <h2 className="text-3xl sm:text-5xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-white">
              BEYOND <span className="font-serif italic font-light text-[#C6A77B]">FASHION</span>
            </h2>
            <p className="text-xs sm:text-sm text-zinc-600 dark:text-zinc-400 max-w-xl font-sans leading-relaxed">
              Khám phá giải phẫu chi tiết cấu trúc may đo Haute Couture qua 4 giai đoạn hoàn thiện phom dáng và chất liệu.
            </p>
          </div>

          {/* Quick Action Buttons */}
          <div className="flex items-center gap-2.5 flex-wrap showcase-reveal">
            <button
              onClick={() => setAutoRotate(!autoRotate)}
              className={`px-4 py-2.5 rounded-full text-xs font-bold uppercase tracking-wider flex items-center gap-2 border transition cursor-pointer ${
                autoRotate
                  ? 'bg-[#C6A77B] text-[#0B0B0D] border-[#C6A77B]'
                  : 'bg-black/5 dark:bg-white/10 text-[#0B0B0D] dark:text-white border-black/10 dark:border-white/20 hover:bg-black/10 dark:hover:bg-white/20'
              }`}
            >
              <RotateCw className={`w-3.5 h-3.5 ${autoRotate ? 'animate-spin' : ''}`} />
              <span>{autoRotate ? 'Tự động xoay: BẬT' : 'Xoay 360°'}</span>
            </button>

            <button
              onClick={() => setShowHotspots(!showHotspots)}
              className={`px-4 py-2.5 rounded-full text-xs font-bold uppercase tracking-wider flex items-center gap-2 border transition cursor-pointer ${
                showHotspots
                  ? 'bg-[#C6A77B] text-[#0B0B0D] border-[#C6A77B]'
                  : 'bg-black/5 dark:bg-white/10 text-[#0B0B0D] dark:text-white border-black/10 dark:border-white/20 hover:bg-black/10 dark:hover:bg-white/20'
              }`}
            >
              <Compass className="w-3.5 h-3.5" />
              <span>{showHotspots ? 'Điểm kỹ thuật: BẬT' : 'Điểm kỹ thuật: TẮT'}</span>
            </button>

            <button
              onClick={onNavigateShop}
              className="px-6 py-2.5 rounded-full bg-[#0B0B0D] dark:bg-white text-white dark:text-[#0B0B0D] hover:bg-[#C6A77B] dark:hover:bg-[#C6A77B] text-xs font-bold uppercase tracking-wider transition flex items-center gap-1.5 cursor-pointer shadow-lg"
            >
              <span>Xem BST</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>

        {/* Studio Grid: 5 cols Left Info + 7 cols Right 3D Stage */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
          
          {/* Left Column: Insight Cards & Stage Navigation (5 cols) */}
          <div className="lg:col-span-5 space-y-6 showcase-reveal">
            
            {/* Stage Selector Tabs */}
            <div className="grid grid-cols-4 gap-2 p-1.5 rounded-2xl bg-black/5 dark:bg-white/5 border border-black/10 dark:border-white/10">
              {STAGES.map((s, idx) => {
                const isSelected = activeStage === idx;
                return (
                  <button
                    key={s.step}
                    onClick={() => setActiveStage(idx)}
                    className={`py-2 px-1 rounded-xl text-center transition-all cursor-pointer ${
                      isSelected
                        ? 'bg-[#C6A77B] text-[#0B0B0D] font-bold shadow-md'
                        : 'text-zinc-500 dark:text-zinc-400 hover:text-[#0B0B0D] dark:hover:text-white hover:bg-black/5 dark:hover:bg-white/5'
                    }`}
                  >
                    <span className="text-[11px] font-mono block">STAGE {s.step}</span>
                  </button>
                );
              })}
            </div>

            {/* Active Stage Information Card */}
            <div className="p-6 sm:p-8 rounded-3xl bg-white dark:bg-[#141417] border border-black/10 dark:border-white/10 shadow-xl dark:shadow-2xl space-y-4 transition-all duration-500">
              <span className="text-[10px] font-mono font-bold uppercase tracking-widest px-3 py-1 rounded-full bg-black/5 dark:bg-white/10 text-[#C6A77B] border border-black/10 dark:border-white/15 w-max inline-block">
                {stage.badge}
              </span>

              <div className="space-y-1">
                <p className="text-xs font-mono uppercase text-[#9E8254] dark:text-[#E2CEAE] tracking-wider">
                  {stage.title}
                </p>
                <h3 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#0B0B0D] dark:text-white leading-tight">
                  {stage.headline}
                </h3>
              </div>

              <p className="text-xs sm:text-sm text-zinc-600 dark:text-zinc-300 font-sans leading-relaxed">
                {stage.desc}
              </p>

              {/* Stage Visual Thumbnail */}
              {stage.image && (
                <div className="relative w-full h-36 sm:h-44 rounded-2xl overflow-hidden border border-black/10 dark:border-white/10 my-3 group">
                  <img
                    key={stage.step}
                    src={stage.image}
                    alt={stage.headline}
                    className="w-full h-full object-cover transition-all duration-700 group-hover:scale-105"
                    loading="lazy"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent opacity-60" />
                  <div className="absolute bottom-2.5 left-3 px-2.5 py-0.5 rounded-full bg-black/60 backdrop-blur-md border border-white/10 text-[10px] font-mono uppercase tracking-wider text-[#C6A77B]">
                    Tư liệu thực tế · {stage.step}
                  </div>
                </div>
              )}

              {/* Technical Certifications */}
              <div className="pt-4 border-t border-black/5 dark:border-white/10 grid grid-cols-2 gap-3 text-xs text-zinc-600 dark:text-zinc-400">
                <div className="flex items-center gap-2">
                  <ShieldCheck className="w-4 h-4 text-[#C6A77B] shrink-0" />
                  <span>OEKO-TEX 100</span>
                </div>
                <div className="flex items-center gap-2">
                  <Compass className="w-4 h-4 text-[#C6A77B] shrink-0" />
                  <span>Bespoke 3D Cut</span>
                </div>
              </div>
            </div>

            <button
              onClick={onNavigateShop}
              className="w-full py-4 rounded-2xl bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] text-[#0B0B0D] font-bold text-xs uppercase tracking-widest shadow-xl hover:scale-[1.02] transition-all duration-300 flex items-center justify-center gap-2 cursor-pointer"
            >
              <span>Trải Nghiệm Mua Sắm Ngay</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>

          {/* Right Column: 3D Studio Stage (7 cols) */}
          <div className="lg:col-span-7 h-[500px] sm:h-[620px] relative rounded-3xl overflow-hidden border border-black/10 dark:border-white/10 bg-radial-[at_center] from-[#1A1A1E] via-[#0E0E10] to-[#070709] shadow-2xl flex flex-col justify-between showcase-reveal">
            
            {/* Top Toolbar Overlay */}
            <div className="relative z-10 p-5 flex items-center justify-between pointer-events-none">
              <div className="flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-[#C6A77B] animate-pulse" />
                <span className="text-xs font-bold uppercase tracking-wider text-white/90">
                  Mô Hình Phom May Đo 3D Studio
                </span>
              </div>
              <span className="text-[11px] font-mono text-zinc-400 bg-black/60 px-3 py-1 rounded-full border border-white/10">
                Kéo chuột để xoay 360° · Lăn chuột để zoom
              </span>
            </div>

            {/* Floating Luxury Color Swatches */}
            <div className="absolute top-16 right-5 z-20 flex flex-col items-end gap-1.5 pointer-events-auto">
              <span className="text-[10px] font-mono uppercase tracking-wider text-zinc-300 flex items-center gap-1.5 bg-black/70 px-2.5 py-0.5 rounded-full border border-white/10 backdrop-blur-md">
                <Palette className="w-3 h-3 text-[#C6A77B]" />
                {activeColor.name}
              </span>
              <div className="flex items-center gap-2 p-1.5 rounded-full bg-black/80 backdrop-blur-md border border-white/15 shadow-2xl">
                {COLOR_SWATCHES.map((swatch) => {
                  const isSelected = activeColor.id === swatch.id;
                  return (
                    <button
                      key={swatch.id}
                      onClick={() => setActiveColor(swatch)}
                      className={`w-6 h-6 rounded-full transition-all cursor-pointer relative flex items-center justify-center ${
                        isSelected
                          ? 'scale-120 ring-2 ring-[#C6A77B] ring-offset-2 ring-offset-black'
                          : 'hover:scale-110 opacity-75 hover:opacity-100'
                      }`}
                      style={{ backgroundColor: swatch.swatch }}
                      title={`${swatch.name} - ${swatch.vietnamese}`}
                    >
                      {isSelected && <span className="w-1.5 h-1.5 rounded-full bg-[#C6A77B]" />}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Camera Zoom Active Hotspot Reset Badge */}
            {activeHotspot && (
              <div className="absolute top-16 left-5 z-20 pointer-events-auto">
                <button
                  onClick={() => setActiveHotspot(null)}
                  className="px-3.5 py-1.5 rounded-full bg-[#C6A77B] text-[#0B0B0D] text-xs font-bold uppercase tracking-wider flex items-center gap-2 shadow-2xl hover:bg-white transition cursor-pointer"
                >
                  <RotateCcw className="w-3.5 h-3.5" />
                  <span>Đặt Lại Góc Nhìn Tổng Thể</span>
                </button>
              </div>
            )}

            {/* 3D Canvas */}
            <div className="absolute inset-0 z-0">
              <Canvas
                camera={{ position: [0, 0.4, 4.2], fov: 42 }}
                dpr={Math.min(window.devicePixelRatio || 1, 2)}
                gl={{
                  antialias: true,
                  alpha: true,
                  powerPreference: 'high-performance',
                  toneMapping: THREE.ACESFilmicToneMapping,
                  toneMappingExposure: 1.0,
                }}
              >
                {/* Image-Based Lighting for high dynamic range velvet & metal reflections */}
                <Environment preset="city" environmentIntensity={0.4} />

                {/* Ambient Light */}
                <ambientLight intensity={0.5} />

                {/* Softbox Key Light 45° Left */}
                <directionalLight position={[5, 6, 4]} intensity={1.5} color="#FFF5EB" castShadow />

                {/* Champagne Fill Light Right */}
                <directionalLight position={[-5, 3, 2]} intensity={0.8} color="#C6A77B" />
                
                {/* High-Fashion Rim Backlight to contour shoulders & sleeves */}
                <directionalLight position={[0, 4, -4.5]} intensity={1.8} color="#FFE8C2" />
                
                {/* Floor Upward Reflection Light */}
                <pointLight position={[0, -1, 3]} intensity={0.7} color="#FFE5B4" />

                <Suspense fallback={null}>
                  <ShowcaseStageModel
                    activeStage={activeStage}
                    colorConfig={activeColor}
                    showHotspots={showHotspots}
                    activeHotspot={activeHotspot}
                    onHotspotClick={(id) => setActiveHotspot(activeHotspot === id ? null : id)}
                  />
                </Suspense>

                {/* Dynamic Camera Flying Controller */}
                <CameraHotspotController
                  activeHotspot={activeHotspot}
                  controlsRef={controlsRef}
                />

                <OrbitControls
                  ref={controlsRef}
                  makeDefault
                  autoRotate={autoRotate && !activeHotspot}
                  autoRotateSpeed={1.2}
                  enableZoom={true}
                  minDistance={1.8}
                  maxDistance={6.0}
                  minPolarAngle={Math.PI / 4}
                  maxPolarAngle={Math.PI / 1.75}
                  onStart={handleControlStart}
                  onEnd={handleControlEnd}
                />

                <ContactShadows
                  position={[0, -1.34, 0]}
                  opacity={0.75}
                  scale={5.5}
                  blur={2.4}
                  far={3.5}
                  color="#000000"
                />

                <Sparkles count={40} scale={4.5} size={2.0} speed={0.4} opacity={0.5} color="#C6A77B" />
              </Canvas>
            </div>

            {/* Bottom Status Ribbon (Live-synced with active fabric color) */}
            <div className="relative z-10 p-5 flex flex-wrap items-center justify-between gap-3 bg-gradient-to-t from-black/85 via-black/45 to-transparent pointer-events-none">
              <div className="flex items-center gap-3 text-xs text-zinc-300 font-sans flex-wrap">
                <span className="font-mono text-[#E2CEAE] font-bold">{activeColor.name}</span>
                <span>·</span>
                <span>{activeColor.fabricDesc}</span>
              </div>

              <div className="text-[11px] font-mono text-[#E2CEAE] flex items-center gap-1.5">
                <span className="w-1.5 h-1.5 rounded-full bg-[#C6A77B]" />
                <span>PBR Single Jersey · ACES Filmic</span>
              </div>
            </div>

          </div>

        </div>

      </div>
    </section>
  );
};
