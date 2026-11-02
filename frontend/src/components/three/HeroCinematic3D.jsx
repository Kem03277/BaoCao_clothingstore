import React, { useRef, useState } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { Float, OrbitControls, Sparkles, MeshDistortMaterial } from '@react-three/drei';
import * as THREE from 'three';
import {
  Eye, RotateCw, Palette, Sparkles as SparklesIcon,
  Maximize2, Minimize2, Image as ImageIcon, ChevronRight, Check
} from 'lucide-react';

// Materials presets for luxury fashion with corresponding real-world editorial looks
const MATERIAL_PRESETS = {
  gold: {
    id: 'gold',
    name: 'Lụa Vàng Hoàng Gia',
    tag: 'Royal Gold Silk',
    color: '#D4AF37',
    metalness: 0.88,
    roughness: 0.18,
    clearcoat: 1.0,
    clearcoatRoughness: 0.1,
    distort: 0.35,
    speed: 2.2,
    lightColor: '#FFE7B3',
    lookImage: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Đầm Lụa Hoàng Gia Signature 2026',
    lookPrice: '2.450.000₫',
    lookFabric: '100% Tơ tằm dệt kim sa vàng thủ công',
    lookBadge: 'Capsule Look 01',
  },
  obsidian: {
    id: 'obsidian',
    name: 'Nhung Đen Obsidian',
    tag: 'Obsidian Velvet',
    color: '#16161A',
    metalness: 0.5,
    roughness: 0.7,
    clearcoat: 0.8,
    clearcoatRoughness: 0.3,
    distort: 0.28,
    speed: 1.8,
    lightColor: '#C6A77B',
    lookImage: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Măng Tô Dạ Yến Obsidian Trench',
    lookPrice: '3.190.000₫',
    lookFabric: 'Nhung tuyết Ý phối lót lụa tơ tằm',
    lookBadge: 'Capsule Look 02',
  },
  emerald: {
    id: 'emerald',
    name: 'Lụa Ngọc Lục Bảo',
    tag: 'Emerald Satin',
    color: '#0E4438',
    metalness: 0.75,
    roughness: 0.22,
    clearcoat: 1.0,
    clearcoatRoughness: 0.15,
    distort: 0.32,
    speed: 2.0,
    lightColor: '#80E5B5',
    lookImage: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Đầm Dạ Hội Satin Emerald Draped',
    lookPrice: '2.850.000₫',
    lookFabric: 'Satin lụa tơ tự nhiên co giãn 4 chiều',
    lookBadge: 'Capsule Look 03',
  },
  platinum: {
    id: 'platinum',
    name: 'Satin Bạch Kim',
    tag: 'Platinum Glacier',
    color: '#EAE6DF',
    metalness: 0.92,
    roughness: 0.15,
    clearcoat: 1.0,
    clearcoatRoughness: 0.08,
    distort: 0.3,
    speed: 2.5,
    lightColor: '#FFFFFF',
    lookImage: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
    lookTitle: 'Blazer Tailored Bạch Kim Glacier',
    lookPrice: '1.980.000₫',
    lookFabric: 'Sợi dệt kim sa ánh bạc dập nổi',
    lookBadge: 'Capsule Look 04',
  },
};

/**
 * Interactive 3D Haute Couture Silk Ribbon / Sculptural Fabric
 */
function FloatingFashionSculpture({ activeMaterial, interactive = true }) {
  const meshRef = useRef();
  const innerRingRef = useRef();
  const auraRef = useRef();

  useFrame((state, delta) => {
    // Smooth natural floating and breathing
    if (meshRef.current) {
      meshRef.current.rotation.x += delta * 0.3;
      meshRef.current.rotation.y += delta * 0.4;

      if (interactive) {
        // Inertial follow pointer
        const targetX = (state.pointer.x * Math.PI) / 5;
        const targetY = (state.pointer.y * Math.PI) / 5;
        meshRef.current.rotation.x = THREE.MathUtils.lerp(meshRef.current.rotation.x, targetY, 0.06);
        meshRef.current.rotation.y = THREE.MathUtils.lerp(meshRef.current.rotation.y, targetX, 0.06);
      }
    }

    if (innerRingRef.current) {
      innerRingRef.current.rotation.y -= delta * 0.5;
      innerRingRef.current.rotation.z += delta * 0.25;
    }

    if (auraRef.current) {
      auraRef.current.rotation.z += delta * 0.2;
    }
  });

  const mat = MATERIAL_PRESETS[activeMaterial] || MATERIAL_PRESETS.gold;

  return (
    <group position={[0, 0, 0]}>
      {/* Main Silk Torus Sculpture */}
      <Float speed={2.8} rotationIntensity={0.6} floatIntensity={1.4}>
        <mesh ref={meshRef} scale={1.35}>
          <torusKnotGeometry args={[1, 0.32, 160, 48, 2, 3]} />
          <MeshDistortMaterial
            color={mat.color}
            roughness={mat.roughness}
            metalness={mat.metalness}
            distort={mat.distort}
            speed={mat.speed}
            clearcoat={mat.clearcoat}
            clearcoatRoughness={mat.clearcoatRoughness}
          />
        </mesh>
      </Float>

      {/* Internal Delicate Gold Cage / Core */}
      <Float speed={3.4} rotationIntensity={1.2} floatIntensity={1.6}>
        <mesh ref={innerRingRef} scale={0.78}>
          <octahedronGeometry args={[1, 2]} />
          <meshStandardMaterial
            color="#FFFFFF"
            roughness={0.2}
            metalness={0.9}
            wireframe={true}
            transparent={true}
            opacity={0.45}
          />
        </mesh>
      </Float>

      {/* Orbiting Ring with Fine Metallic Trim */}
      <Float speed={2} rotationIntensity={0.8} floatIntensity={0.8}>
        <mesh ref={auraRef} scale={1.85} rotation={[Math.PI / 3, 0, 0]}>
          <torusGeometry args={[1, 0.02, 16, 100]} />
          <meshStandardMaterial
            color="#C6A77B"
            roughness={0.2}
            metalness={0.95}
            emissive="#C6A77B"
            emissiveIntensity={0.2}
          />
        </mesh>
      </Float>

      {/* Floating Stardust Particles */}
      <Sparkles
        count={55}
        scale={5.5}
        size={3}
        speed={0.45}
        opacity={0.7}
        color={mat.lightColor}
      />
    </group>
  );
}

/**
 * Undulating Haute Couture Silk Wave Backdrop Mesh
 */
function SilkWaveBackdrop({ activeMaterial }) {
  const waveRef = useRef();
  const mat = MATERIAL_PRESETS[activeMaterial] || MATERIAL_PRESETS.gold;

  useFrame((state, delta) => {
    if (waveRef.current) {
      waveRef.current.rotation.z += delta * 0.05;
      const t = state.clock.getElapsedTime();
      waveRef.current.position.y = -1.8 + Math.sin(t * 0.8) * 0.15;
    }
  });

  return (
    <mesh ref={waveRef} position={[0, -1.8, -1.5]} rotation={[-Math.PI / 3, 0, 0]} scale={2.8}>
      <planeGeometry args={[4, 4, 32, 32]} />
      <MeshDistortMaterial
        color={mat.color}
        distort={0.4}
        speed={1.5}
        roughness={0.3}
        metalness={0.7}
        wireframe={true}
        transparent={true}
        opacity={0.18}
      />
    </mesh>
  );
}

export const HeroCinematic3D = ({ className = '' }) => {
  const [activeMaterial, setActiveMaterial] = useState('gold');
  const [allowOrbit, setAllowOrbit] = useState(false);
  const [showLookbookCard, setShowLookbookCard] = useState(true);

  const mat = MATERIAL_PRESETS[activeMaterial];

  return (
    <div className={`relative w-full h-[520px] sm:h-[580px] lg:h-[640px] rounded-3xl overflow-hidden border border-white/15 shadow-2xl bg-gradient-to-b from-[#141416]/90 via-[#0B0B0D]/95 to-[#0B0B0D] ${className}`}>
      
      {/* 3D Canvas Layer */}
      <div className="absolute inset-0 z-0">
        <Canvas
          camera={{ position: [0, 0, 4.4], fov: 46 }}
          dpr={[1, 2]}
          gl={{
            antialias: true,
            alpha: true,
            powerPreference: 'high-performance',
          }}
        >
          <ambientLight intensity={0.9} />
          <directionalLight position={[5, 6, 4]} intensity={2.2} color={mat.lightColor} />
          <directionalLight position={[-5, -4, -2]} intensity={1.2} color="#C6A77B" />
          <pointLight position={[0, 3, 2]} intensity={1.5} color={mat.lightColor} />
          <pointLight position={[-3, -2, 2]} intensity={1.2} color="#E8C78B" />

          <SilkWaveBackdrop activeMaterial={activeMaterial} />
          <FloatingFashionSculpture activeMaterial={activeMaterial} interactive={!allowOrbit} />

          {allowOrbit && (
            <OrbitControls
              enableZoom={false}
              enablePan={false}
              autoRotate={true}
              autoRotateSpeed={1.5}
              maxPolarAngle={Math.PI / 1.7}
              minPolarAngle={Math.PI / 3}
            />
          )}
        </Canvas>
      </div>

      {/* Top Floating Badges & Controls */}
      <div className="relative z-10 p-5 flex items-center justify-between pointer-events-none">
        <div className="flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-black/60 backdrop-blur-md border border-[#C6A77B]/30 shadow-lg pointer-events-auto">
          <SparklesIcon className="w-3.5 h-3.5 text-[#C6A77B] animate-spin-slow" />
          <span className="text-[10px] font-bold tracking-[0.2em] uppercase text-[#E2CEAE] font-mono">
            Three.js Haute Couture Engine
          </span>
        </div>

        <div className="flex items-center gap-2 pointer-events-auto">
          <button
            onClick={() => setShowLookbookCard(!showLookbookCard)}
            className="px-3 py-1.5 rounded-full text-xs font-semibold flex items-center gap-1.5 backdrop-blur-md bg-black/50 text-white/90 border border-white/15 hover:bg-black/80 transition cursor-pointer"
            title={showLookbookCard ? 'Ẩn ảnh minh họa' : 'Hiện ảnh minh họa'}
          >
            <ImageIcon className="w-3.5 h-3.5 text-[#C6A77B]" />
            <span className="hidden sm:inline">{showLookbookCard ? 'Ảnh minh họa' : 'Xem minh họa'}</span>
          </button>

          <button
            onClick={() => setAllowOrbit(!allowOrbit)}
            className={`px-3 py-1.5 rounded-full text-xs font-semibold flex items-center gap-1.5 backdrop-blur-md border transition cursor-pointer ${
              allowOrbit
                ? 'bg-[#C6A77B] text-[#0B0B0D] border-[#C6A77B] shadow-lg shadow-[#C6A77B]/20'
                : 'bg-black/50 text-white/80 border-white/15 hover:bg-black/80 hover:text-white'
            }`}
            title="Bật/Tắt xoay 360° tự do bằng chuột"
          >
            <RotateCw className={`w-3.5 h-3.5 ${allowOrbit ? 'animate-spin' : ''}`} />
            <span>{allowOrbit ? 'Xoay: Bật' : 'Kéo xoay 360°'}</span>
          </button>
        </div>
      </div>

      {/* ── FLOATING ILLUSTRATED EDITORIAL CAPSULE CARD ── */}
      {showLookbookCard && (
        <div className="absolute top-20 right-5 z-20 w-52 sm:w-60 rounded-3xl overflow-hidden shadow-2xl bg-black/60 backdrop-blur-xl border border-white/20 p-2.5 transition-all duration-300 animate-in fade-in slide-in-from-right-4">
          <div className="relative aspect-[3/4] w-full rounded-2xl overflow-hidden group">
            <img
              src={mat.lookImage}
              alt={mat.lookTitle}
              className="w-full h-full object-cover object-center group-hover:scale-108 transition-transform duration-700"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/20 to-transparent pointer-events-none" />

            {/* Top Badge */}
            <div className="absolute top-2.5 left-2.5 right-2.5 flex items-center justify-between">
              <span className="text-[9px] font-bold tracking-widest uppercase px-2 py-0.5 rounded-full bg-black/60 backdrop-blur-md text-[#C6A77B] border border-[#C6A77B]/30">
                {mat.lookBadge}
              </span>
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping" />
            </div>

            {/* Bottom Info on Image */}
            <div className="absolute bottom-2.5 left-2.5 right-2.5 text-left">
              <span className="text-[9px] uppercase tracking-widest text-[#E2CEAE] font-bold block">
                Hình Ảnh Minh Họa Thực Tế
              </span>
              <p className="text-xs font-bold text-white line-clamp-1 mt-0.5">
                {mat.lookTitle}
              </p>
              <div className="flex items-center justify-between mt-1 text-[11px]">
                <span className="font-bold text-[#C6A77B]">{mat.lookPrice}</span>
                <span className="text-[10px] text-zinc-300">BST 2026</span>
              </div>
            </div>
          </div>

          <div className="pt-2 px-1 text-[10px] text-zinc-400 flex items-center justify-between">
            <span className="truncate">{mat.lookFabric}</span>
          </div>
        </div>
      )}

      {/* Floating Center Interaction Prompt */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none z-10">
        <div className="opacity-0 hover:opacity-100 transition-opacity duration-300">
          <span className="text-[11px] font-bold tracking-widest uppercase px-4 py-2 rounded-full bg-black/70 backdrop-blur-md text-white/90 border border-white/20">
            Di chuyển chuột để uốn lượn sợi vải 3D
          </span>
        </div>
      </div>

      {/* Bottom Material Selector Control Bar */}
      <div className="absolute bottom-5 left-5 right-5 z-20 flex flex-col sm:flex-row items-center justify-between gap-3 p-3.5 rounded-2xl bg-black/75 backdrop-blur-xl border border-white/15 shadow-2xl">
        <div className="flex items-center gap-2">
          <Palette className="w-4 h-4 text-[#C6A77B]" />
          <div>
            <p className="text-[11px] font-bold text-white tracking-wide uppercase">
              {mat.name}
            </p>
            <p className="text-[9px] text-[#C6A77B] tracking-widest uppercase font-mono">
              {mat.tag} · Mô phỏng vật lý 3D &amp; Ảnh minh họa
            </p>
          </div>
        </div>

        {/* Preset Selector Buttons */}
        <div className="flex items-center gap-1.5 flex-wrap">
          {Object.values(MATERIAL_PRESETS).map((preset) => {
            const isSelected = activeMaterial === preset.id;
            return (
              <button
                key={preset.id}
                onClick={() => setActiveMaterial(preset.id)}
                className={`px-3 py-1.5 rounded-xl text-[10px] font-bold uppercase tracking-wider transition-all cursor-pointer flex items-center gap-1.5 ${
                  isSelected
                    ? 'bg-[#C6A77B] text-[#0B0B0D] shadow-md scale-105'
                    : 'bg-white/5 hover:bg-white/10 text-zinc-300 border border-white/10'
                }`}
                title={preset.name}
              >
                <span
                  className="w-2.5 h-2.5 rounded-full border border-white/30"
                  style={{ backgroundColor: preset.color }}
                />
                <span>{preset.name.split(' ')[1] || preset.name}</span>
              </button>
            );
          })}
        </div>
      </div>

    </div>
  );
};
