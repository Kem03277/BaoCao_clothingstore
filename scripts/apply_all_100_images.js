const fs = require('fs');
const path = require('path');

// 100 completely UNIQUE Unsplash photo IDs for primary images
const priIds = [
  // 1-10: Áo thun
  '1521572267360-ee0c2909d518',
  '1503342217505-b0a15ec3261c',
  '1534528741775-53994a69daeb',
  '1581655353564-df123a1eb820',
  '1515886657613-9f3515b0c78f',
  '1521572163474-6864f9cf17ab',
  '1618354691373-d851c5c3a990',
  '1485968579580-b6d095142e6e',
  '1523381210434-271e8be1f52b',
  '1583496661160-fb5886a0aaaa',

  // 11-20: Áo sơ mi
  '1596755094514-f87e34085b2c',
  '1598033129183-c4f50c736f10',
  '1607345366928-199ea26cfe3e',
  '1507679799987-c73779587ccf',
  '1589902860314-e910697dea18',
  '1620012253295-c15c429fcc71',
  '1551803091-e20673f15770',
  '1512436991641-6745cdb1723f',
  '1564257631407-4deb1299042b',
  '1598032895397-b9472444bf93',

  // 21-30: Áo polo
  '1625910513413-7e44a4ebdafc',
  '1586363104862-3a5e2ab60d99',
  '1594938298603-c8148c4dae35',
  '1617137984095-74e4e5e3613f',
  '1506794778202-cad84cf45f1d',
  '1529139574466-a303027c1d8b',
  '1576566588028-4147f3842f27',
  '1583743814966-8936f5b7be1a',
  '1552374196-1ab2a1c593e8',
  '1509631179647-0177331693ae',

  // 31-40: Áo khoác
  '1551028719-00167b16eac5',
  '1434389677669-e08b4cac3105',
  '1591047139829-d91aecb6caea',
  '1539533018447-63fcce2678e3',
  '1593030761757-71fae45fa0e7',
  '1576995853123-5a10305d93c0',
  '1548624149-f9b2eb85f164',
  '1544923246-77307dd654cb',
  '1521223890158-f9f7c3d5d504',
  '1548883354-7622d03aca27',

  // 41-50: Áo hoodie & Sweatshirt
  '1556905055-8f358a7a47b2',
  '1556821840-3a63f95609a7',
  '1485230895905-ec40ba36b9bc',
  '1509967419530-da38b4704bc6',
  '1578632767115-351597cf2477',
  '1496747611176-843222e1e57c',
  '1554412933-514a83d2f3c8',
  '1516257984-b1b4d707412e',
  '1606760227091-3dd870d97f1d',
  '1584273143981-41c073dfe8f8',

  // 51-60: Quần jeans
  '1541099649105-f69ad21f3246',
  '1584370848010-d7fe6bc767ec',
  '1542272604-787c3835535d',
  '1604176354204-9268737828e4',
  '1508427953056-b00b8d78ebf5',
  '1582552938357-32b906df40cb',
  '1475178626620-a4d074967452',
  '1506630448388-4e683c67ddb0',
  '1489987707025-afc232f7ea0f',
  '1516826957135-700dedea698c',

  // 61-70: Quần kaki
  '1473966968600-fa801b869a1a',
  '1624378439575-d8705ad7ae80',
  '1517445312882-bc9910d016b7',
  '1490481651871-ab68de25d43d',
  '1522335789203-aabd1fc54bc9',
  '1516914943479-89db7d9ae7f2',
  '1483985988355-763728e1935b',
  '1523398002811-999ca8dec234',
  '1487222477894-8943e31ef7b2',
  '1514327605112-b887c0e61c0a',

  // 71-80: Quần short
  '1591195853828-11db59a44f6b',
  '1565084888279-aca607ecce0c',
  '1562157873-818bc0726f68',
  '1591195856475-472d8a07c31d',
  '1550614000-4895a10e1bfd',
  '1506152983158-b4a74a01c721',
  '1519741497674-611481863552',
  '1503342394128-c104d54dba01',
  '1529720317453-c8da503f2051',
  '1516762689617-e1cffcef479d',

  // 81-90: Quần tây
  '1492562080023-ab3db95bfbce',
  '1550639525-c97d455acf70',
  '1479064555552-3ce4979f8908',
  '1508296695146-257a814070b4',
  '1489980556514-2797052a5782',
  '1519085360753-af0119f7cbe7',
  '1504198453319-5ce911bafc46',
  '1525507119028-ed4c629a60a3',
  '1504593811423-6dd665756598',
  '1490114538077-ac7f12197170',

  // 91-100: Váy & Đầm
  '1582142306909-195724d33ffc',
  '1595777457583-95e059d581b8',
  '1515372039744-b8f02a3ae446',
  '1566174053879-31528523f8ae',
  '1539109136881-3be0616acf4b',
  '1612336307429-8a898d10e223',
  '1502716119720-b23a93e5fe1b',
  '1572804013309-59a88b7e92f1',
  '1492707892479-7bc8d5a4ee93',
  '1525450824786-227cbef70703'
];

// 100 matching detail IDs
const detIds = [
  '1583743814966-8936f5b7be1a', '1576566588028-4147f3842f27', '1529139574466-a303027c1d8b', '1506794778202-cad84cf45f1d', '1485230895905-ec40ba36b9bc',
  '1527719327859-c6ce80353573', '1562157873-818bc0726f68', '1554412933-514a83d2f3c8', '1489987707025-afc232f7ea0f', '1534447677768-be436bb09401',
  '1602810318383-e386cc2a3ccf', '1564257631407-4deb1299042b', '1620012253295-c15c429fcc71', '1512436991641-6745cdb1723f', '1551803091-e20673f15770',
  '1598032895397-b9472444bf93', '1589902860314-e910697dea18', '1489987707025-afc232f7ea0f', '1598033129183-c4f50c736f10', '1607345366928-199ea26cfe3e',
  '1586363104862-3a5e2ab60d99', '1625910513413-7e44a4ebdafc', '1503342217505-b0a15ec3261c', '1581655353564-df123a1eb820', '1617137984095-74e4e5e3613f',
  '1515886657613-9f3515b0c78f', '1506794778202-cad84cf45f1d', '1523381210434-271e8be1f52b', '1617137984095-74e4e5e3613f', '1586363104862-3a5e2ab60d99',
  '1591047139829-d91aecb6caea', '1539533018447-63fcce2678e3', '1551028719-00167b16eac5', '1502716119720-b23a93e5fe1b', '1507679799987-c73779587ccf',
  '1542272604-787c3835535d', '1539533018447-63fcce2678e3', '1551028719-00167b16eac5', '1551028719-00167b16eac5', '1591047139829-d91aecb6caea',
  '1556821840-3a63f95609a7', '1556905055-8f358a7a47b2', '1556821840-3a63f95609a7', '1556905055-8f358a7a47b2', '1556821840-3a63f95609a7',
  '1515886657613-9f3515b0c78f', '1509631179647-0177331693ae', '1556905055-8f358a7a47b2', '1509631179647-0177331693ae', '1578632767115-351597cf2477',
  '1542272604-787c3835535d', '1541099649105-f69ad21f3246', '1584370848010-d7fe6bc767ec', '1541099649105-f69ad21f3246', '1584370848010-d7fe6bc767ec',
  '1542272604-787c3835535d', '1604176354204-9268737828e4', '1584370848010-d7fe6bc767ec', '1541099649105-f69ad21f3246', '1516257984-b1b4d707412e',
  '1624378439575-d8705ad7ae80', '1473966968600-fa801b869a1a', '1473966968600-fa801b869a1a', '1473966968600-fa801b869a1a', '1509631179647-0177331693ae',
  '1517445312882-bc9910d016b7', '1624378439575-d8705ad7ae80', '1509631179647-0177331693ae', '1517445312882-bc9910d016b7', '1473966968600-fa801b869a1a',
  '1565084888279-aca607ecce0c', '1591195853828-11db59a44f6b', '1591195853828-11db59a44f6b', '1591195853828-11db59a44f6b', '1508427953056-b00b8d78ebf5',
  '1591195853828-11db59a44f6b', '1565084888279-aca607ecce0c', '1550614000-4895a10e1bfd', '1591195853828-11db59a44f6b', '1562157873-818bc0726f68',
  '1507679799987-c73779587ccf', '1594938298603-c8148c4dae35', '1594938298603-c8148c4dae35', '1509631179647-0177331693ae', '1624378439575-d8705ad7ae80',
  '1551803091-e20673f15770', '1594938298603-c8148c4dae35', '1509631179647-0177331693ae', '1594938298603-c8148c4dae35', '1593030761757-71fae45fa0e7',
  '1550614000-4895a10e1bfd', '1566174053879-31528523f8ae', '1582142306909-195724d33ffc', '1572804013309-59a88b7e92f1', '1582142306909-195724d33ffc',
  '1595777457583-95e059d581b8', '1541099649105-f69ad21f3246', '1612336307429-8a898d10e223', '1539533018447-63fcce2678e3', '1591047139829-d91aecb6caea'
];

function buildUrl(id) {
  return `https://images.unsplash.com/photo-${id}?w=800&auto=format&fit=crop&q=80`;
}

// 1. Validate
console.log('Validating priIds length:', priIds.length);
console.log('Validating unique priIds:', new Set(priIds).size);
console.log('Validating detIds length:', detIds.length);

const seedFile = path.join(__dirname, '..', 'src', 'main', 'resources', 'seed_clothingstore.sql');
let content = fs.readFileSync(seedFile, 'utf8');

// 2. Extract exact product names from seed
const lines = content.split('\n');
const priLineIndices = [];
lines.forEach((l, i) => {
  if (l.includes("Ảnh chính', 1")) {
    priLineIndices.push(i);
  }
});

console.log('Found priLine indices in seed:', priLineIndices.length);

if (priLineIndices.length !== 100) {
  console.error('ERROR: Could not find 100 primary image lines in seed!');
  process.exit(1);
}

const updateStatements = [
  '-- ======================================================================',
  '-- SCRIPT CẬP NHẬT 100 ẢNH KHÔNG TRÙNG LẶP CHO CLOTHING STORE',
  '-- Chạy script này trong phpMyAdmin hoặc MySQL Workbench để cập nhật ngay DB hiện tại',
  '-- ======================================================================',
  'USE clothingstore;',
  ''
];

// For each product index (0 to 99):
priLineIndices.forEach((lineIdx, i) => {
  const priLine = lines[lineIdx];
  const detLine = lines[lineIdx + 4]; // The detail line is 4 lines below:
  // lineIdx: SELECT p.id, '<URL>', '<Name> - Ảnh chính', 1
  // lineIdx+1: FROM products p WHERE ...
  // lineIdx+2: AND NOT EXISTS ...
  // lineIdx+3: INSERT INTO product_images ...
  // lineIdx+4: SELECT p.id, '<URL>', '<Name> - Ảnh chi tiết', 0

  const mName = priLine.match(/', '([^']+?) - Ảnh chính', 1/);
  if (!mName) {
    console.error(`Could not match product name at line ${lineIdx + 1}: ${priLine}`);
    process.exit(1);
  }
  const prodName = mName[1];
  const priUrl = buildUrl(priIds[i]);
  const detUrl = buildUrl(detIds[i]);

  // Replace URL in priLine
  lines[lineIdx] = priLine.replace(/'https:\/\/images\.unsplash\.com\/photo-[^']+'/, `'${priUrl}'`);

  // Replace URL in detLine
  if (detLine && detLine.includes("Ảnh chi tiết', 0")) {
    lines[lineIdx + 4] = detLine.replace(/'https:\/\/images\.unsplash\.com\/photo-[^']+'/, `'${detUrl}'`);
  } else {
    // Search nearby lines for the detail line
    for (let offset = 1; offset <= 6; offset++) {
      if (lines[lineIdx + offset] && lines[lineIdx + offset].includes("Ảnh chi tiết', 0")) {
        lines[lineIdx + offset] = lines[lineIdx + offset].replace(/'https:\/\/images\.unsplash\.com\/photo-[^']+'/, `'${detUrl}'`);
        break;
      }
    }
  }

  updateStatements.push(`-- Product #${i + 1}: ${prodName}`);
  updateStatements.push(`UPDATE product_images SET image_url = '${priUrl}' WHERE product_id = ${i + 1} AND is_primary = 1;`);
  updateStatements.push(`UPDATE product_images SET image_url = '${detUrl}' WHERE product_id = ${i + 1} AND is_primary = 0;`);
  updateStatements.push('');
});

// Reassemble and write
const newContent = lines.join('\n');
fs.writeFileSync(seedFile, newContent, 'utf8');
console.log(`Saved updated seed file: ${seedFile}`);

// Target file
const targetFile = path.join(__dirname, '..', 'target', 'classes', 'seed_clothingstore.sql');
if (fs.existsSync(targetFile)) {
  fs.writeFileSync(targetFile, newContent, 'utf8');
  console.log(`Saved updated target file: ${targetFile}`);
}

// Update script in src/main/resources and root
const updateFile = path.join(__dirname, '..', 'src', 'main', 'resources', 'update_product_images.sql');
fs.writeFileSync(updateFile, updateStatements.join('\n'), 'utf8');
console.log(`Saved update script: ${updateFile}`);

const rootUpdateFile = path.join(__dirname, '..', 'update_product_images.sql');
fs.writeFileSync(rootUpdateFile, updateStatements.join('\n'), 'utf8');
console.log(`Saved root update script: ${rootUpdateFile}`);
