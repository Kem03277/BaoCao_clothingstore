import React, { useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { OrbitControls, Float, MeshReflectorMaterial, Cylinder, Box } from '@react-three/drei';
import * as THREE from 'three';

function FashionItemPreview({ productName = 'Sản phẩm thời trang' }) {
  const itemGroup = useRef();

  useFrame((_, delta) => {
    if (itemGroup.current) {
      itemGroup.current.rotation.y += delta * 0.4;
    }
  });

  return (
    <group position={[0, -0.4, 0]}>
      {/* Studio Luxury Pedestal */}
      <mesh position={[0, -0.2, 0]} receiveShadow>
        <cylinderGeometry args={[1.5, 1.6, 0.4, 64]} />
        <meshStandardMaterial
          color="#161618"
          roughness={0.2}
          metalness={0.8}
        />
      </mesh>

      {/* Gold Trim Ring */}
      <mesh position={[0, 0.01, 0]}>
        <ringGeometry args={[1.42, 1.49, 64]} />
        <meshStandardMaterial
          color="#C6A77B"
          metalness={0.9}
          roughness={0.2}
          side={THREE.DoubleSide}
        />
      </mesh>

      {/* Floating Fashion Showcase Element */}
      <group ref={itemGroup} position={[0, 1.1, 0]}>
        <Float speed={2} rotationIntensity={0.3} floatIntensity={0.5}>
          {/* Stylized Modern Fashion Silhouette Cube / Showcase Form */}
          <mesh castShadow>
            <boxGeometry args={[0.9, 1.2, 0.4]} />
            <meshPhysicalMaterial
              color="#222226"
              roughness={0.35}
              metalness={0.2}
              clearcoat={0.6}
              clearcoatRoughness={0.2}
            />
          </mesh>

          {/* Accent Ribbon Detail */}
          <mesh position={[0, 0, 0.21]}>
            <planeGeometry args={[0.8, 0.08]} />
            <meshStandardMaterial color="#C6A77B" metalness={0.9} roughness={0.1} />
          </mesh>
          <mesh position={[0, -0.2, 0.21]}>
            <planeGeometry args={[0.5, 0.04]} />
            <meshStandardMaterial color="#FAF5EE" metalness={0.5} roughness={0.2} />
          </mesh>
        </Float>
      </group>
    </group>
  );
}

export const Product3DViewer = ({ productName }) => {
  return (
    <div className="relative w-full h-full min-h-[320px] bg-gradient-to-b from-[#18181B] to-[#0B0B0D] rounded-2xl overflow-hidden flex flex-col justify-between p-4">
      <div className="flex items-center justify-between z-10">
        <span className="text-[11px] uppercase tracking-widest font-semibold px-2.5 py-1 rounded-full bg-white/10 text-[#C6A77B] backdrop-blur-md border border-[#C6A77B]/20">
          3D Studio View
        </span>
        <span className="text-[11px] text-zinc-400">Kéo xoay 360°</span>
      </div>

      <div className="absolute inset-0">
        <Canvas
          camera={{ position: [0, 1.4, 3.6], fov: 45 }}
          dpr={[1, 1.5]}
          gl={{ antialias: true, alpha: true }}
        >
          <ambientLight intensity={0.8} />
          <directionalLight position={[4, 5, 3]} intensity={1.5} color="#FFFFFF" castShadow />
          <spotLight position={[-3, 4, -2]} intensity={1.2} color="#C6A77B" />
          <pointLight position={[0, -1, 2]} intensity={0.5} color="#FFEAC5" />

          <FashionItemPreview productName={productName} />
          <OrbitControls
            enableZoom={false}
            enablePan={false}
            minPolarAngle={Math.PI / 4}
            maxPolarAngle={Math.PI / 2.1}
          />
        </Canvas>
      </div>

      <div className="z-10 text-center">
        <p className="text-xs text-zinc-400 font-medium">Trải nghiệm tương tác 3D Studio</p>
      </div>
    </div>
  );
};
