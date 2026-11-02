const fs = require('fs');

const prodPage = fs.readFileSync('d:/THLTW_ThoxThang_24D_temp-main/frontend/src/app/(shop)/products/page.jsx', 'utf8');
const lines = prodPage.split('\n');
console.log('Top 40 lines:');
console.log(lines.slice(0, 40).join('\n'));

console.log('Lines 80-150:');
console.log(lines.slice(80, 150).join('\n'));
