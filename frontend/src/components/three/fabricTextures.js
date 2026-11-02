import * as THREE from 'three';

/**
 * Procedural PBR Fabric Texture Generator for 290 GSM Combed Cotton Jersey
 * Generates seamless high-resolution Normal, Roughness, Rib Knit, and Neck Label maps
 * without any external network dependencies or CORS issues.
 */

// Cached instances to avoid re-generating on re-renders
let cachedJerseyNormal = null;
let cachedJerseyRoughness = null;
let cachedRibNormal = null;
let cachedNeckLabel = null;

/**
 * 1. Single Jersey Knit Normal Map
 * Accurately models interlocking V-shaped yarn loops of cotton t-shirt fabric
 */
export function getJerseyNormalTexture() {
  if (cachedJerseyNormal) return cachedJerseyNormal;

  const size = 512;
  const canvas = document.createElement('canvas');
  canvas.width = size;
  canvas.height = size;
  const ctx = canvas.getContext('2d');
  const imgData = ctx.createImageData(size, size);
  const data = imgData.data;

  // Stitches per repeat tile
  const stitchesX = 16;
  const stitchesY = 16;
  const stitchW = size / stitchesX;
  const stitchH = size / stitchesY;

  // Generate height field
  const heights = new Float32Array(size * size);
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const u = (x % stitchW) / stitchW;
      const v = (y % stitchH) / stitchH;

      // V-shaped knit loop geometry
      const dx = (u - 0.5) * 2.0;
      const dy = v;
      // Loop arch and legs
      const loop = Math.cos(dx * Math.PI) * Math.sin(dy * Math.PI);
      const crossThread = Math.sin(u * Math.PI * 2.0) * 0.15;
      // Subtle micro-fiber noise
      const microNoise = ((x * 17 + y * 31) % 19) / 190.0;

      heights[y * size + x] = Math.max(0, loop + crossThread + microNoise);
    }
  }

  // Sobel filter to calculate normals from height field
  const normalScale = 2.4;
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const left = heights[y * size + ((x - 1 + size) % size)];
      const right = heights[y * size + ((x + 1) % size)];
      const up = heights[((y - 1 + size) % size) * size + x];
      const down = heights[((y + 1) % size) * size + x];

      let nx = (left - right) * normalScale;
      let ny = (up - down) * normalScale;
      let nz = 1.0;

      const len = Math.sqrt(nx * nx + ny * ny + nz * nz);
      nx /= len;
      ny /= len;
      nz /= len;

      const idx = (y * size + x) * 4;
      data[idx] = Math.floor((nx * 0.5 + 0.5) * 255);
      data[idx + 1] = Math.floor((ny * 0.5 + 0.5) * 255);
      data[idx + 2] = Math.floor((nz * 0.5 + 0.5) * 255);
      data[idx + 3] = 255;
    }
  }

  ctx.putImageData(imgData, 0, 0);

  const texture = new THREE.CanvasTexture(canvas);
  texture.wrapS = THREE.RepeatWrapping;
  texture.wrapT = THREE.RepeatWrapping;
  texture.repeat.set(54, 54); // Microscopic thread frequency across garment UV
  texture.colorSpace = THREE.NoColorSpace; // Normal map is scalar data!
  texture.generateMipmaps = true;
  texture.minFilter = THREE.LinearMipmapLinearFilter;
  texture.magFilter = THREE.LinearFilter;
  texture.needsUpdate = true;

  cachedJerseyNormal = texture;
  return texture;
}

/**
 * 2. Jersey Fabric Roughness & Micro-AO Map
 * Mimics high-roughness cotton (0.88 - 0.95) with microscopic yarn shadow crevices
 */
export function getJerseyRoughnessTexture() {
  if (cachedJerseyRoughness) return cachedJerseyRoughness;

  const size = 512;
  const canvas = document.createElement('canvas');
  canvas.width = size;
  canvas.height = size;
  const ctx = canvas.getContext('2d');
  const imgData = ctx.createImageData(size, size);
  const data = imgData.data;

  const stitchesX = 16;
  const stitchesY = 16;
  const stitchW = size / stitchesX;
  const stitchH = size / stitchesY;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const u = (x % stitchW) / stitchW;
      const v = (y % stitchH) / stitchH;
      const centerDist = Math.hypot(u - 0.5, v - 0.5);

      // Deep matte valley vs yarn peak
      const val = Math.floor(220 + (1.0 - centerDist) * 30 + Math.random() * 5);
      const idx = (y * size + x) * 4;
      data[idx] = val;
      data[idx + 1] = val;
      data[idx + 2] = val;
      data[idx + 3] = 255;
    }
  }

  ctx.putImageData(imgData, 0, 0);

  const texture = new THREE.CanvasTexture(canvas);
  texture.wrapS = THREE.RepeatWrapping;
  texture.wrapT = THREE.RepeatWrapping;
  texture.repeat.set(54, 54);
  texture.colorSpace = THREE.NoColorSpace;
  texture.generateMipmaps = true;
  texture.needsUpdate = true;

  cachedJerseyRoughness = texture;
  return texture;
}

/**
 * 3. 2x2 Rib Collar Normal Texture
 * High-elastic vertical ribbing cords found on premium t-shirt neckbands
 */
export function getRibKnitNormalTexture() {
  if (cachedRibNormal) return cachedRibNormal;

  const size = 256;
  const canvas = document.createElement('canvas');
  canvas.width = size;
  canvas.height = size;
  const ctx = canvas.getContext('2d');
  const imgData = ctx.createImageData(size, size);
  const data = imgData.data;

  const ribCount = 32;
  const ribWidth = size / ribCount;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const u = (x % ribWidth) / ribWidth;
      // Prominent vertical convex ridge
      const slope = Math.cos(u * Math.PI * 2.0);
      let nx = -slope * 0.7;
      let ny = 0.0;
      let nz = Math.sqrt(Math.max(0, 1.0 - nx * nx));

      const idx = (y * size + x) * 4;
      data[idx] = Math.floor((nx * 0.5 + 0.5) * 255);
      data[idx + 1] = Math.floor((ny * 0.5 + 0.5) * 255);
      data[idx + 2] = Math.floor((nz * 0.5 + 0.5) * 255);
      data[idx + 3] = 255;
    }
  }

  ctx.putImageData(imgData, 0, 0);

  const texture = new THREE.CanvasTexture(canvas);
  texture.wrapS = THREE.RepeatWrapping;
  texture.wrapT = THREE.RepeatWrapping;
  texture.repeat.set(24, 6);
  texture.colorSpace = THREE.NoColorSpace;
  texture.needsUpdate = true;

  cachedRibNormal = texture;
  return texture;
}

/**
 * 4. Luxury Inner Woven Neck Label Texture
 * Brand insignia woven in champagne gold metallic thread on black damask ribbon
 */
export function getNeckLabelTexture() {
  if (cachedNeckLabel) return cachedNeckLabel;

  const canvas = document.createElement('canvas');
  canvas.width = 512;
  canvas.height = 256;
  const ctx = canvas.getContext('2d');

  // Black Damask Satin Background
  ctx.fillStyle = '#111114';
  ctx.fillRect(0, 0, 512, 256);

  // Subtle woven diagonal weave lines
  ctx.strokeStyle = '#1A1A1E';
  ctx.lineWidth = 1;
  for (let i = -256; i < 512 + 256; i += 4) {
    ctx.beginPath();
    ctx.moveTo(i, 0);
    ctx.lineTo(i + 256, 256);
    ctx.stroke();
  }

  // Champagne Gold Double Embroidery Border
  ctx.strokeStyle = '#C6A77B';
  ctx.lineWidth = 2.5;
  ctx.strokeRect(16, 16, 512 - 32, 256 - 32);
  ctx.strokeStyle = '#8F7550';
  ctx.lineWidth = 1;
  ctx.strokeRect(22, 22, 512 - 44, 256 - 44);

  // Brand Header
  ctx.fillStyle = '#E5D2B8';
  ctx.font = 'bold 26px "Playfair Display", Georgia, serif';
  ctx.textAlign = 'center';
  ctx.letterSpacing = '6px';
  ctx.fillText('CLOTHINGSTORE', 256, 75);

  ctx.fillStyle = '#C6A77B';
  ctx.font = '600 13px "Courier New", monospace';
  ctx.letterSpacing = '8px';
  ctx.fillText('ATELIER DE COUTURE', 256, 105);

  // Divider Line
  ctx.strokeStyle = '#C6A77B';
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(120, 122);
  ctx.lineTo(392, 122);
  ctx.stroke();

  // Specs & Fabric Grade
  ctx.fillStyle = '#A1A1AA';
  ctx.font = '12px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif';
  ctx.letterSpacing = '2px';
  ctx.fillText('100% COMBED COTTON · 290 GSM', 256, 150);
  ctx.fillText('ERGONOMIC BESPOKE FIT · LOT 04', 256, 172);

  // Size Tag
  ctx.fillStyle = '#FFFFFF';
  ctx.font = 'bold 18px "Courier New", monospace';
  ctx.fillText('SIZE  L', 256, 212);

  const texture = new THREE.CanvasTexture(canvas);
  texture.colorSpace = THREE.SRGBColorSpace; // Color texture must be sRGB!
  texture.needsUpdate = true;

  cachedNeckLabel = texture;
  return texture;
}
