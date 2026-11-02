import React, { useRef, useMemo, useEffect } from 'react';
import { useFrame } from '@react-three/fiber';
import { useGLTF, Html } from '@react-three/drei';
import * as THREE from 'three';
import { gsap } from 'gsap';
import {
  getJerseyNormalTexture,
  getJerseyRoughnessTexture,
  getRibKnitNormalTexture,
  getNeckLabelTexture,
} from './fabricTextures';

/**
 * Interactive 3D Hotspot Pin that pulses and triggers camera zoom
 */
function HotspotBeacon({ position, id, title, subtitle, onSelect, isActive }) {
  return (
    <group position={position}>
      <Html center zIndexRange={[120, 0]}>
        <div className="relative group select-none pointer-events-auto">
          {/* Glowing Beacon Button */}
          <button
            onClick={() => onSelect(id)}
            className={`relative w-7 h-7 flex items-center justify-center cursor-pointer transition-all duration-300 hover:scale-125 focus:outline-none ${
              isActive ? 'scale-125' : ''
            }`}
            aria-label={title}
          >
            <span className="absolute inset-0 rounded-full bg-[#C6A77B] opacity-75 animate-ping" />
            <span className="w-4 h-4 rounded-full bg-gradient-to-tr from-[#9E7D4E] to-[#FAF1E3] border border-white shadow-[0_0_15px_rgba(198,167,123,0.9)] flex items-center justify-center text-[9px] font-extrabold text-black font-mono">
              {id}
            </span>
          </button>

          {/* Floating Tooltip Card */}
          <div
            className={`absolute bottom-full mb-2 w-56 max-w-[calc(100vw-2rem)] p-3.5 rounded-2xl bg-[#121216]/95 backdrop-blur-md border border-[#C6A77B]/50 shadow-[0_10px_30px_rgba(0,0,0,0.8)] transition-all duration-300 pointer-events-none ${
              id === '2' ? 'right-0' : 'left-1/2 -translate-x-1/2'
            } ${
              isActive
                ? 'opacity-100 scale-100 translate-y-0'
                : 'opacity-0 scale-95 translate-y-2 group-hover:opacity-100 group-hover:scale-100 group-hover:translate-y-0'
            }`}
          >
            <div className="flex items-center gap-1.5 mb-1">
              <span className="w-1.5 h-1.5 rounded-full bg-[#C6A77B] animate-pulse" />
              <span className="text-[10px] font-mono uppercase font-bold text-[#C6A77B] tracking-wider">
                {title}
              </span>
            </div>
            <p className="text-[11px] text-zinc-300 font-sans leading-relaxed">
              {subtitle}
            </p>
            <div className="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-[#121216]/95" />
          </div>
        </div>
      </Html>
    </group>
  );
}

/**
 * Photorealistic 290 GSM Cotton Garment Model
 * - MeshPhysicalMaterial with cotton sheen (1.0) and custom peach-skin fuzz Fresnel
 * - Procedural PBR Single Jersey Knit normal map & roughness map
 * - 2x2 Rib knit contoured collar with realistic thickness
 * - Inner damask woven brand label ("CLOTHINGSTORE ATELIER")
 * - Double-stitched hem and cuff details
 */
export const ShirtModel = ({
  materialColor = '#131316',
  sheenColor = '#28282D',
  scale = 1.0,
  showHotspots = true,
  activeHotspot = null,
  onHotspotClick = () => {},
  interactive = true,
}) => {
  const groupRef = useRef();
  const materialRef = useRef();
  const ribMaterialRef = useRef();
  const { nodes } = useGLTF('/models/shirt_baked.glb');

  // Load procedural PBR texture suite
  const jerseyNormal = useMemo(() => getJerseyNormalTexture(), []);
  const jerseyRoughness = useMemo(() => getJerseyRoughnessTexture(), []);
  const ribNormal = useMemo(() => getRibKnitNormalTexture(), []);
  const neckLabel = useMemo(() => getNeckLabelTexture(), []);

  // Micro-fuzz Fresnel shader custom uniforms
  const customShaderUniforms = useMemo(() => ({
    uFuzzColor: { value: new THREE.Color(sheenColor) },
    uFuzzStrength: { value: 0.45 },
  }), []);

  // Update fuzz color whenever sheen color changes
  useEffect(() => {
    if (customShaderUniforms.uFuzzColor) {
      gsap.to(customShaderUniforms.uFuzzColor.value, {
        r: new THREE.Color(sheenColor).r,
        g: new THREE.Color(sheenColor).g,
        b: new THREE.Color(sheenColor).b,
        duration: 0.6,
        ease: 'power2.out',
      });
    }
  }, [sheenColor, customShaderUniforms]);

  // Smooth color tweening when color changes
  useEffect(() => {
    if (materialRef.current) {
      gsap.to(materialRef.current.color, {
        r: new THREE.Color(materialColor).r,
        g: new THREE.Color(materialColor).g,
        b: new THREE.Color(materialColor).b,
        duration: 0.6,
        ease: 'power2.out',
      });
      gsap.to(materialRef.current.sheenColor, {
        r: new THREE.Color(sheenColor).r,
        g: new THREE.Color(sheenColor).g,
        b: new THREE.Color(sheenColor).b,
        duration: 0.6,
        ease: 'power2.out',
      });
    }
  }, [materialColor, sheenColor]);

  // Handle cotton micro-fuzz via onBeforeCompile
  const handleBeforeCompile = (shader) => {
    shader.uniforms.uFuzzColor = customShaderUniforms.uFuzzColor;
    shader.uniforms.uFuzzStrength = customShaderUniforms.uFuzzStrength;

    // Inject view-space normal and view position calculation
    shader.fragmentShader = `
      uniform vec3 uFuzzColor;
      uniform float uFuzzStrength;
    ` + shader.fragmentShader;

    // Inject edge peach-skin fuzz calculation before output
    shader.fragmentShader = shader.fragmentShader.replace(
      '#include <dithering_fragment>',
      `
      #include <dithering_fragment>
      // Glancing-angle peach-skin cotton micro-fuzz
      vec3 viewDir = normalize(vViewPosition);
      float NdotV = clamp(dot(-viewDir, normal), 0.0, 1.0);
      float fuzzFresnel = pow(1.0 - NdotV, 3.2);
      gl_FragColor.rgb += uFuzzColor * (fuzzFresnel * uFuzzStrength);
      `
    );
  };

  useFrame((state, delta) => {
    const t = state.clock.getElapsedTime();

    if (groupRef.current) {
      // Subtle float suspension (float ±0.03 as specified)
      groupRef.current.position.y = Math.sin(t * 1.4) * 0.03 - 0.15;

      // Pointer interaction when in interactive mode
      if (interactive) {
        const targetRotY = state.pointer.x * 0.35;
        const targetRotX = -state.pointer.y * 0.2;
        groupRef.current.rotation.y = THREE.MathUtils.damp(groupRef.current.rotation.y, targetRotY, 3, delta);
        groupRef.current.rotation.x = THREE.MathUtils.damp(groupRef.current.rotation.x, targetRotX, 3, delta);
      }
    }
  });

  return (
    <group ref={groupRef} scale={scale * 3.6} position={[0, -0.15, 0]} dispose={null}>
      
      {/* ── 1. Main T-Shirt Body Mesh (Heavyweight 290 GSM Cotton Jersey) ── */}
      <mesh
        castShadow
        receiveShadow
        geometry={nodes.T_Shirt_male.geometry}
      >
        <meshPhysicalMaterial
          ref={materialRef}
          color={materialColor}
          roughness={0.9}
          metalness={0.0}
          sheen={1.0}
          sheenRoughness={0.5}
          sheenColor={sheenColor}
          normalMap={jerseyNormal}
          normalScale={new THREE.Vector2(0.8, 0.8)}
          roughnessMap={jerseyRoughness}
          side={THREE.DoubleSide}
          onBeforeCompile={handleBeforeCompile}
        />

      </mesh>

      {/* ── 2. Inner Damask Woven Brand Label ("CLOTHINGSTORE ATELIER") ── */}
      {/* Subtle brand tag inside collar, visible when rotating to view back of shirt */}
      <mesh position={[0, 0.21, -0.065]} rotation={[0.2, Math.PI, 0]}>
        <planeGeometry args={[0.075, 0.038]} />
        <meshStandardMaterial
          map={neckLabel}
          roughness={0.5}
          metalness={0.1}
          side={THREE.FrontSide}
        />
      </mesh>

      {/* ── 5. Interactive 3D Haute Couture Hotspot Annotations ── */}
      {showHotspots && (
        <group>
          {/* Hotspot 1: Collar */}
          <HotspotBeacon
            position={[0, 0.25, 0.13]}
            id="1"
            title="Cổ Bo Gân 2x2"
            subtitle="Dệt gân kép đàn hồi cao, gia cố chống giãn form và giữ nếp phẳng phiu tuyệt đối sau 100 lần giặt."
            onSelect={onHotspotClick}
            isActive={activeHotspot === '1'}
          />

          {/* Hotspot 2: Ergonomic Shoulder & Armhole Seam */}
          <HotspotBeacon
            position={[0.22, 0.12, 0.1]}
            id="2"
            title="May Đôi Kim Gia Cố"
            subtitle="Đường may vai và nách gia cố bằng chỉ dệt Coats Epic chuẩn Haute Couture, không gây cộm ngứa."
            onSelect={onHotspotClick}
            isActive={activeHotspot === '2'}
          />

          {/* Hotspot 3: Hem & Fabric Grade */}
          <HotspotBeacon
            position={[0, -0.32, 0.15]}
            id="3"
            title="Cotton 290 GSM"
            subtitle="Sợi bông Ai Cập chải kỹ dệt Single Jersey định lượng 290 GSM dày dặn, đứng phom và thoáng khí tự nhiên."
            onSelect={onHotspotClick}
            isActive={activeHotspot === '3'}
          />
        </group>
      )}
    </group>
  );
};

useGLTF.preload('/models/shirt_baked.glb');
