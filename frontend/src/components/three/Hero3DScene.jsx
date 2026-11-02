import React, { Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { ContactShadows, Sparkles } from '@react-three/drei';
import { ShirtModel } from './ShirtModel';

const Hero3DScene = () => (
  <Canvas
    camera={{ position: [0, 0.4, 4.2], fov: 45 }}
    dpr={[1, 1.5]}
    gl={{ antialias: true, alpha: true, powerPreference: 'high-performance' }}
  >
    <ambientLight intensity={1.2} />
    <directionalLight position={[5, 8, 5]} intensity={2.6} color="#FFF2DB" />
    <directionalLight position={[-5, 3, -4]} intensity={1.4} color="#C6A77B" />
    <pointLight position={[0, -1, 3]} intensity={1.2} color="#FFE5B4" />

    <Suspense fallback={null}>
      <ShirtModel
        materialColor="#161619"
        accentColor="#C6A77B"
        interactive
        scale={1.05}
      />
    </Suspense>

    <ContactShadows
      position={[0, -1.8, 0]}
      opacity={0.65}
      scale={5}
      blur={2.2}
      far={4}
      color="#000000"
    />

    <Sparkles
      count={35}
      scale={4.5}
      size={2}
      speed={0.4}
      opacity={0.5}
      color="#C6A77B"
    />
  </Canvas>
);

export default Hero3DScene;
