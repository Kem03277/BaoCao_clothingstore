import React, { useRef, useState } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { Float, OrbitControls, Sparkles, ContactShadows, MeshDistortMaterial, Html } from '@react-three/drei';
import * as THREE from 'three';
import {
  Sparkles as SparklesIcon, RotateCw, ZoomIn, Info,
  CheckCircle2, Compass, Layers, ShieldCheck, ArrowRight, Image as ImageIcon
} from 'lucide-react';

const SHOWROOM_MATERIALS = {
  champagne: {
    id: 'champagne',
    name: 'Champagne Couture Silk',
    label: 'Lụa Sâm Panh Hoàng Gia',
    accent: '#C6A77B',
    bodyColor: '#1A1815',
    trimColor: '#E2CEAE',
    roughness: 0.25,
    metalness: 0.85,
    tag: 'Haute Horlogerie Grade',
    lookImage: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Vest Lụa Champagne Haute Couture',
    lookPrice: '2.890.000₫',
    modelStats: 'Mẫu cao 1m78 · Mặc size M',
  },
  obsidian: {
    id: 'obsidian',
    name: 'Obsidian Velvet Tailoring',
    label: 'Nhung Đen Dạ Yến',
    accent: '#8A8A8A',
    bodyColor: '#0E0E10',
    trimColor: '#C6A77B',
    roughness: 0.65,
    metalness: 0.35,
    tag: 'Black Tie Signature',
    lookImage: 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Obsidian Velvet Trench Coat 2026',
    lookPrice: '3.450.000₫',
    modelStats: 'Mẫu cao 1m82 · Mặc size L',
  },
  emerald: {
    id: 'emerald',
    name: 'Imperial Emerald Satin',
    label: 'Lụa Ngọc Lục Bảo',
    accent: '#10B981',
    bodyColor: '#092B22',
    trimColor: '#E5D2B8',
    roughness: 0.22,
    metalness: 0.78,
    tag: 'Collector Capsule',
    lookImage: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Đầm Dạ Hội Satin Ngọc Lục Bảo',
    lookPrice: '3.120.000₫',
    modelStats: 'Mẫu cao 1m75 · Mặc size S',
  },
  burgundy: {
    id: 'burgundy',
    name: 'Burgundy Royal Wool',
    label: 'Len Dạ Đỏ Bordeaux',
    accent: '#F43F5E',
    bodyColor: '#360E18',
    trimColor: '#E2CEAE',
    roughness: 0.45,
    metalness: 0.5,
    tag: 'Heritage Merino 2026',
    lookImage: 'https://images.unsplash.com/photo-1584273143981-41c073dfe8f8?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Áo Khoác Dạ Merino Burgundy',
    lookPrice: '2.780.000₫',
    modelStats: 'Mẫu cao 1m80 · Mặc size M',
  },
};

const HOTSPOTS = [
  {
    id: 'collar',
    position: [0, 1.25, 0.22],
    title: 'Cổ Áo Ve Kép Cắt May 3D',
    detail: 'Đường cắt may định hình bằng công nghệ 3D Ergonomic, ôm vừa vặn và giữ phom chuẩn mực.',
  },
  {
    id: 'buttons',
    position: [0, 0.35, 0.22],
    title: 'Khuy Áo Kim Loại Chạm Khắc',
    detail: 'Hợp kim nguyên khối mạ vàng champagne 18K, khắc laser vi mô logo thương hiệu độc bản.',
  },
  {
    id: 'fabric',
    position: [-0.65, -0.2, 0.22],
    title: 'Sợi Dệt Tự Nhiên Thượng Hạng',
    detail: '100% sợi dệt tự nhiên chuẩn OEKO-TEX Standard 100, thoáng khí và thân thiện với làn da.',
  },
];

/**
 * 3D High-Fashion Mannequin / Exhibition Showcase Card
 */
function FashionSculpture3D({ activeMaterial, onSelectHotspot, activeHotspotId }) {
  const groupRef = useRef();
  const mat = SHOWROOM_MATERIALS[activeMaterial] || SHOWROOM_MATERIALS.champagne;

  useFrame((state, delta) => {
    if (groupRef.current) {
      // Gentle natural breathing
      const t = state.clock.getElapsedTime();
      groupRef.current.position.y = Math.sin(t * 1.2) * 0.05;
    }
  });

  return (
    <group ref={groupRef} position={[0, -0.2, 0]}>
      {/* Studio Floating Pedestal */}
      <mesh position={[0, -1.5, 0]} receiveShadow>
        <cylinderGeometry args={[2.2, 2.4, 0.25, 64]} />
        <meshStandardMaterial color="#141416" roughness={0.3} metalness={0.8} />
      </mesh>

      {/* Radiant Golden Circular Edge */}
      <mesh position={[0, -1.36, 0]}>
        <ringGeometry args={[2.1, 2.18, 64]} />
        <meshStandardMaterial
          color={mat.trimColor}
          emissive={mat.trimColor}
          emissiveIntensity={0.35}
          side={THREE.DoubleSide}
        />
      </mesh>

      {/* Central 3D Display Totem & Fashion Model Illustration */}
      <group position={[0, 0.2, 0]}>
        {/* Support Pillar connecting to podium */}
        <mesh position={[0, -0.7, 0]}>
          <cylinderGeometry args={[0.04, 0.04, 1.2, 32]} />
          <meshStandardMaterial color={mat.trimColor} metalness={0.9} roughness={0.2} />
        </mesh>

        {/* 3D Physical Display Bevel Frame (Backing) */}
        <mesh position={[0, 0.35, -0.04]} castShadow receiveShadow>
          <boxGeometry args={[1.76, 2.46, 0.08]} />
          <meshPhysicalMaterial
            color="#141416"
            roughness={0.35}
            metalness={0.8}
            clearcoat={1.0}
            clearcoatRoughness={0.15}
          />
        </mesh>

        {/* 3D Gold Trim Bevel */}
        <mesh position={[0, 0.35, -0.02]}>
          <boxGeometry args={[1.82, 2.52, 0.04]} />
          <meshStandardMaterial
            color={mat.trimColor}
            metalness={0.95}
            roughness={0.15}
            emissive={mat.trimColor}
            emissiveIntensity={0.2}
          />
        </mesh>

        {/* High-Resolution Fashion Model Illustration directly in 3D rotating stage */}
        <Html
          transform
          center
          position={[0, 0.35, 0.05]}
          distanceFactor={2.7}
        >
          <div
            className="w-[300px] rounded-2xl overflow-hidden bg-[#121214] border-2 shadow-2xl p-2 select-none pointer-events-auto transition-all duration-500"
            style={{
              borderColor: mat.trimColor,
              boxShadow: `0 25px 60px rgba(0,0,0,0.85), 0 0 35px ${mat.trimColor}40`,
            }}
          >
            <div className="relative aspect-[3/4] rounded-xl overflow-hidden group">
              <img
                src={mat.lookImage}
                alt={mat.lookTitle}
                className="w-full h-full object-cover object-top transition-transform duration-700 group-hover:scale-105"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/25 to-transparent flex flex-col justify-end p-4">
                <span className="text-[10px] font-bold uppercase tracking-widest px-2.5 py-1 rounded-full bg-white/20 backdrop-blur-md text-white border border-white/20 w-max mb-1.5 font-mono">
                  {mat.tag}
                </span>
                <h3 className="text-base font-bold text-white leading-snug drop-shadow-md">
                  {mat.lookTitle}
                </h3>
                <div className="flex items-center justify-between mt-2 pt-2 border-t border-white/15">
                  <span className="text-xs text-zinc-300 font-sans">{mat.modelStats}</span>
                  <span className="text-sm font-bold text-[#E2CEAE]">{mat.lookPrice}</span>
                </div>
              </div>
            </div>
          </div>
        </Html>

        {/* Floating Kinetic Silk Sash that flows around the illustration */}
        <Float speed={2.5} rotationIntensity={0.8} floatIntensity={1.2}>
          <mesh position={[0, 0.35, 0]} scale={1.3}>
            <torusGeometry args={[1.35, 0.06, 16, 100]} />
            <MeshDistortMaterial
              color={mat.trimColor}
              distort={0.4}
              speed={2.2}
              roughness={0.2}
              metalness={0.8}
            />
          </mesh>
        </Float>

        {/* Floating Gold Ring Orbit */}
        <Float speed={1.8} rotationIntensity={0.6} floatIntensity={0.9}>
          <mesh position={[0, 0.35, 0]} rotation={[1.1, 0.4, 0.2]} scale={1.35}>
            <torusGeometry args={[1.4, 0.025, 16, 100]} />
            <meshStandardMaterial
              color={mat.trimColor}
              roughness={0.15}
              metalness={0.95}
              emissive={mat.trimColor}
              emissiveIntensity={0.25}
            />
          </mesh>
        </Float>
      </group>

      {/* Interactive 3D Hotspot Markers */}
      {HOTSPOTS.map((hotspot) => {
        const isSelected = activeHotspotId === hotspot.id;
        return (
          <group
            key={hotspot.id}
            position={hotspot.position}
            onClick={(e) => {
              e.stopPropagation();
              onSelectHotspot(hotspot);
            }}
          >
            {/* Glowing outer beacon sphere */}
            <mesh scale={isSelected ? 1.4 : 1.0}>
              <sphereGeometry args={[0.09, 16, 16]} />
              <meshBasicMaterial
                color={isSelected ? '#FFFFFF' : '#C6A77B'}
                wireframe={true}
              />
            </mesh>
            {/* Core dot */}
            <mesh scale={isSelected ? 1.2 : 0.8}>
              <sphereGeometry args={[0.05, 16, 16]} />
              <meshStandardMaterial
                color={isSelected ? '#E2CEAE' : '#D4AF37'}
                emissive="#C6A77B"
                emissiveIntensity={1.5}
              />
            </mesh>
          </group>
        );
      })}

      {/* Ground Contact Shadow */}
      <ContactShadows
        position={[0, -1.48, 0]}
        opacity={0.75}
        scale={6}
        blur={2.5}
        far={4}
        color="#000000"
      />

      {/* Floating Micro-sparkles */}
      <Sparkles count={45} scale={4.5} size={2.5} speed={0.5} opacity={0.65} color={mat.trimColor} />
    </group>
  );
}

export const Atelier3DShowroom = ({ onNavigateShop }) => {
  const [activeMaterial, setActiveMaterial] = useState('champagne');
  const [selectedHotspot, setSelectedHotspot] = useState(HOTSPOTS[0]);
  const [autoRotate, setAutoRotate] = useState(true);

  const mat = SHOWROOM_MATERIALS[activeMaterial];

  return (
    <section className="py-24 bg-[#0B0B0D] text-white relative overflow-hidden border-y border-white/10">
      
      {/* Background Decorative Ambient Flares */}
      <div className="absolute top-0 right-1/4 w-[500px] h-[500px] bg-[#C6A77B]/10 rounded-full blur-[140px] pointer-events-none" />
      <div className="absolute bottom-0 left-1/4 w-[500px] h-[500px] bg-[#C6A77B]/5 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Heading */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12">
          <div className="space-y-3">
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 border border-[#C6A77B]/30 backdrop-blur-md">
              <SparklesIcon className="w-3.5 h-3.5 text-[#C6A77B]" />
              <span className="text-[11px] font-bold uppercase tracking-[0.25em] text-[#C6A77B] font-mono">
                Section 3D · Interactive Experience
              </span>
            </div>
            <h2 className="text-3xl sm:text-5xl font-extrabold tracking-tight">
              BEYOND <span className="text-[#C6A77B] italic font-serif">FASHION</span>
            </h2>
            <p className="text-sm text-zinc-300 max-w-xl font-sans leading-relaxed">
              Thời trang không chỉ là trang phục. Đó là cách bạn thể hiện bản thân. Trực tiếp xoay 360°, chạm vào cấu trúc dệt may kỹ thuật số và chuyển đổi chất liệu theo thời gian thực kết hợp cùng người mẫu thực tế.
            </p>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={() => setAutoRotate(!autoRotate)}
              className={`px-4 py-2.5 rounded-full text-xs font-bold uppercase tracking-wider flex items-center gap-2 border transition cursor-pointer ${
                autoRotate
                  ? 'bg-[#C6A77B] text-[#0B0B0D] border-[#C6A77B]'
                  : 'bg-white/10 text-white border-white/20 hover:bg-white/20'
              }`}
            >
              <RotateCw className={`w-3.5 h-3.5 ${autoRotate ? 'animate-spin' : ''}`} />
              <span>{autoRotate ? 'Tự động xoay: BẬT' : 'Tự do xoay 360°'}</span>
            </button>

            <button
              onClick={onNavigateShop}
              className="px-5 py-2.5 rounded-full bg-white text-[#0B0B0D] hover:bg-zinc-200 text-xs font-bold uppercase tracking-wider flex items-center gap-1.5 transition cursor-pointer"
            >
              <span>Mua BST</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>

        {/* 3D Interactive Stage + Control Deck Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-stretch">
          
          {/* Main 3D Stage (7 cols) */}
          <div className="lg:col-span-7 relative min-h-[520px] sm:min-h-[600px] rounded-3xl overflow-hidden border border-white/15 bg-radial-[at_center] from-[#1A1A1E] via-[#0E0E10] to-[#070709] shadow-2xl flex flex-col justify-between">
            
            {/* Top Toolbar overlay */}
            <div className="relative z-10 p-5 flex items-center justify-between pointer-events-none">
              <div className="flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse" />
                <span className="text-xs font-bold uppercase tracking-wider text-white/90">
                  Trưng Bày Mẫu Thời Trang 3D Thực Tế
                </span>
              </div>
              <span className="text-[11px] font-mono text-zinc-400 bg-black/50 px-3 py-1 rounded-full border border-white/10">
                Kéo chuột để xoay 360° · Lăn chuột để phóng to
              </span>
            </div>

            {/* Canvas Container */}
            <div className="absolute inset-0 z-0">
              <Canvas
                camera={{ position: [0, 1.2, 4.6], fov: 45 }}
                dpr={[1, 2]}
                gl={{ antialias: true, alpha: true, powerPreference: 'high-performance' }}
              >
                <ambientLight intensity={1.1} />
                <directionalLight position={[5, 7, 5]} intensity={2.4} color="#FFF2DB" />
                <directionalLight position={[-5, 3, -3]} intensity={1.2} color="#C6A77B" />
                <pointLight position={[0, -1, 3]} intensity={1.0} color="#FFE5B4" />

                <FashionSculpture3D
                  activeMaterial={activeMaterial}
                  onSelectHotspot={(hotspot) => setSelectedHotspot(hotspot)}
                  activeHotspotId={selectedHotspot?.id}
                />

                <OrbitControls
                  makeDefault
                  autoRotate={autoRotate}
                  autoRotateSpeed={1.2}
                  enableZoom={true}
                  minDistance={2.5}
                  maxDistance={6.5}
                  minPolarAngle={Math.PI / 4}
                  maxPolarAngle={Math.PI / 1.8}
                />
              </Canvas>
            </div>

            {/* Bottom Status Ribbon */}
            <div className="relative z-10 p-5 flex flex-wrap items-center justify-between gap-3 bg-gradient-to-t from-black/80 via-black/40 to-transparent pointer-events-none">
              <div className="flex items-center gap-4 text-xs text-zinc-300">
                <div className="flex items-center gap-1.5">
                  <ShieldCheck className="w-4 h-4 text-[#C6A77B]" />
                  <span>Vải dệt nguyên bản</span>
                </div>
                <span>·</span>
                <div className="flex items-center gap-1.5">
                  <Layers className="w-4 h-4 text-[#C6A77B]" />
                  <span>Định lượng: 290 GSM</span>
                </div>
                <span>·</span>
                <div className="flex items-center gap-1.5">
                  <Compass className="w-4 h-4 text-[#C6A77B]" />
                  <span>Cắt may 3D Ergonomic</span>
                </div>
              </div>

              <div className="text-[11px] font-mono text-[#E2CEAE]">
                Render: WebGL 2.0 / PBR Shading
              </div>
            </div>

          </div>

          {/* Interactive Inspector Sidebar & Illustrated Photo Card (5 cols) */}
          <div className="lg:col-span-5 flex flex-col justify-between gap-5">
            
            {/* 1. Material Selector Card */}
            <div className="p-5 rounded-3xl bg-[#141416] border border-white/10 shadow-xl space-y-3">
              <div className="flex items-center justify-between">
                <h3 className="text-xs font-bold uppercase tracking-wider text-white flex items-center gap-2">
                  <SparklesIcon className="w-4 h-4 text-[#C6A77B]" />
                  Chất Liệu Thiết Kế (Fabric)
                </h3>
                <span className="text-[10px] font-mono text-[#C6A77B] uppercase">
                  {mat.tag}
                </span>
              </div>

              <div className="grid grid-cols-2 gap-2">
                {Object.values(SHOWROOM_MATERIALS).map((item) => {
                  const isSelected = activeMaterial === item.id;
                  return (
                    <button
                      key={item.id}
                      onClick={() => setActiveMaterial(item.id)}
                      className={`p-2.5 rounded-2xl border text-left transition-all cursor-pointer ${
                        isSelected
                          ? 'border-[#C6A77B] bg-[#C6A77B]/15 shadow-md shadow-[#C6A77B]/10 scale-[1.02]'
                          : 'border-white/10 bg-white/5 hover:bg-white/10'
                      }`}
                    >
                      <div className="flex items-center gap-2 mb-1">
                        <span
                          className="w-3 h-3 rounded-full border border-white/30 shrink-0"
                          style={{ backgroundColor: item.accent }}
                        />
                        <span className="text-xs font-bold text-white truncate">
                          {item.name.split(' ')[0]}
                        </span>
                      </div>
                      <p className="text-[10px] text-zinc-400 line-clamp-1">{item.label}</p>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* 2. REAL-WORLD ILLUSTRATION PHOTO CARD (HÌNH ẢNH MINH HỌA THỰC TẾ) */}
            <div className="p-4 rounded-3xl bg-[#141416] border border-white/10 shadow-xl flex gap-4 items-center">
              <div className="relative w-28 h-36 rounded-2xl overflow-hidden shrink-0 border border-white/15 shadow-md">
                <img
                  src={mat.lookImage}
                  alt={mat.lookTitle}
                  className="w-full h-full object-cover object-center hover:scale-110 transition-transform duration-500"
                />
                <span className="absolute bottom-1.5 left-1.5 px-2 py-0.5 rounded-full bg-black/70 backdrop-blur-md text-[9px] font-bold text-[#C6A77B] uppercase">
                  Lookbook
                </span>
              </div>

              <div className="space-y-1.5 flex-1 min-w-0">
                <div className="inline-flex items-center gap-1.5 text-[10px] uppercase font-bold text-[#C6A77B]">
                  <ImageIcon className="w-3 h-3" />
                  <span>Hình Ảnh Minh Họa Thực Tế</span>
                </div>
                <h4 className="text-sm font-bold text-white truncate">
                  {mat.lookTitle}
                </h4>
                <p className="text-xs font-bold text-[#E2CEAE]">
                  {mat.lookPrice}
                </p>
                <p className="text-[11px] text-zinc-400">
                  {mat.modelStats}
                </p>
              </div>
            </div>

            {/* 3. Hotspot Detail Inspector Card */}
            <div className="p-5 rounded-3xl bg-[#141416] border border-white/10 shadow-xl space-y-3">
              <div>
                <div className="flex items-center gap-2 text-xs font-bold text-[#C6A77B] uppercase tracking-wider mb-1.5">
                  <Info className="w-3.5 h-3.5" />
                  Điểm Nhấn Chi Tiết Kỹ Thuật
                </div>
                
                {selectedHotspot && (
                  <div className="space-y-1">
                    <h5 className="text-sm font-extrabold text-white">
                      {selectedHotspot.title}
                    </h5>
                    <p className="text-xs text-zinc-300 leading-relaxed font-sans">
                      {selectedHotspot.detail}
                    </p>
                  </div>
                )}

                {/* Hotspot quick switch chips */}
                <div className="flex flex-wrap gap-1.5 pt-2">
                  {HOTSPOTS.map((h) => (
                    <button
                      key={h.id}
                      onClick={() => setSelectedHotspot(h)}
                      className={`px-2.5 py-1 rounded-full text-[10px] font-semibold border transition cursor-pointer ${
                        selectedHotspot?.id === h.id
                          ? 'bg-[#C6A77B] text-[#0B0B0D] border-[#C6A77B]'
                          : 'bg-white/5 text-zinc-300 border-white/10 hover:bg-white/10'
                      }`}
                    >
                      {h.title.split(' ')[0]} {h.title.split(' ')[1]}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            {/* 4. Action Callout */}
            <button
              onClick={onNavigateShop}
              className="w-full py-3.5 px-6 rounded-2xl bg-gradient-to-r from-[#C6A77B] via-[#E2CEAE] to-[#C6A77B] hover:opacity-95 text-[#0B0B0D] font-bold text-xs uppercase tracking-[0.2em] shadow-xl transition-all duration-300 flex items-center justify-center gap-2 cursor-pointer"
            >
              <span>Xem Các Mẫu Áp Dụng Chất Liệu Này</span>
              <ArrowRight className="w-4 h-4" />
            </button>

          </div>

        </div>

      </div>
    </section>
  );
};
