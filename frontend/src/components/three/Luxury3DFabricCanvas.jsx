import React, { useRef, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { Float, MeshDistortMaterial, Sphere, Sparkles } from '@react-three/drei';
import * as THREE from 'three';

/**
 * 3D Luxury Fashion Silk / Floating Sculptural Ribbon Element
 * Recreating high-end Awwwards-style luxury motion aesthetics.
 */
function LuxurySculpture({ mouse }) {
  const meshRef = useRef();
  const innerRef = useRef();

  useFrame((state, delta) => {
    if (meshRef.current) {
      // Gentle natural breathing rotation
      meshRef.current.rotation.x += delta * 0.25;
      meshRef.current.rotation.y += delta * 0.35;

      // Mouse influence for depth and interactive feel
      const targetX = (state.pointer.x * Math.PI) / 6;
      const targetY = (state.pointer.y * Math.PI) / 6;
      meshRef.current.rotation.x = THREE.MathUtils.lerp(meshRef.current.rotation.x, targetY, 0.05);
      meshRef.current.rotation.y = THREE.MathUtils.lerp(meshRef.current.rotation.y, targetX, 0.05);
    }

    if (innerRef.current) {
      innerRef.current.rotation.y -= delta * 0.4;
      innerRef.current.rotation.z += delta * 0.2;
    }
  });

  return (
    <group position={[0, 0, 0]}>
      {/* Outer Floating Silk Geometry */}
      <Float speed={2.5} rotationIntensity={0.8} floatIntensity={1.2}>
        <mesh ref={meshRef} scale={1.4}>
          <torusKnotGeometry args={[1, 0.32, 128, 32, 2, 3]} />
          <MeshDistortMaterial
            color="#D4AF37"
            roughness={0.15}
            metalness={0.85}
            distort={0.25}
            speed={2}
            clearcoat={1}
            clearcoatRoughness={0.1}
          />
        </mesh>
      </Float>

      {/* Inner Champagne Glow Orb */}
      <Float speed={3.2} rotationIntensity={1.2} floatIntensity={1.5}>
        <mesh ref={innerRef} scale={0.75}>
          <octahedronGeometry args={[1, 2]} />
          <meshStandardMaterial
            color="#FAF5EE"
            roughness={0.3}
            metalness={0.9}
            wireframe={true}
            transparent={true}
            opacity={0.35}
          />
        </mesh>
      </Float>

      {/* Floating subtle champagne stardust */}
      <Sparkles count={40} scale={5} size={2.5} speed={0.4} opacity={0.6} color="#E8C78B" />
    </group>
  );
}

export const Luxury3DFabricCanvas = ({ className = '' }) => {
  return (
    <div className={`relative w-full h-full pointer-events-auto ${className}`}>
      <Canvas
        camera={{ position: [0, 0, 4.2], fov: 45 }}
        dpr={[1, 1.5]}
        gl={{ antialias: true, alpha: true, powerPreference: 'high-performance' }}
      >
        <ambientLight intensity={0.7} />
        <directionalLight position={[5, 6, 4]} intensity={1.5} color="#FFEAC5" />
        <pointLight position={[-4, -3, -2]} intensity={0.8} color="#C6A77B" />
        <pointLight position={[3, -2, 2]} intensity={1} color="#E8C78B" />
        
        <LuxurySculpture />
      </Canvas>
    </div>
  );
};
