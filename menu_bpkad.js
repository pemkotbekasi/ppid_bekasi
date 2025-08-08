const axios = require('axios');
const { parse } = require('node-html-parser');

// Fungsi rekursif buat ambil struktur pohon
function buildMenuTree(ulElement) {
  const items = [];

  ulElement.querySelectorAll(':scope > li').forEach(li => {
    const a = li.querySelector(':scope > a');
    const name = a?.querySelector('.hide-on-collapse')?.text.trim();
    const href = a?.getAttribute('href') || '#';

    if (name) {
      const item = { name, href };

      const nestedUl = li.querySelector(':scope > ul.main-menu__dropdown');
      if (nestedUl) {
        item.children = buildMenuTree(nestedUl);
      }

      items.push(item);
    }
  });

  return items;
}

(async () => {
  try {
    const res = await axios.get('https://bpkad.bekasikota.go.id/pages/visi-dan-misi', {
      headers: {
        // Cookie: 'HttpOnly; aksara_yoBd3m6XSBiljZdR=93f02sppdojiru5k5h38kk9qpg9i5n8b'
      }
    });

    const root = parse(res.data);
    const allMenus = root.querySelectorAll('li.main-menu__nav_sub.dropdown');

    // Temukan menu utama "Dokumen"
    const dokumenMenu = allMenus.find(li => {
      const span = li.querySelector('span.hide-on-collapse');
      return span && span.text.trim() === 'Dokumen';
    });

    if (!dokumenMenu) {
      console.log('Menu "Dokumen" tidak ditemukan.');
      return;
    }

    const submenu = dokumenMenu.querySelector('ul.main-menu__dropdown');
    const tree = buildMenuTree(submenu);

    // Cetak struktur JSON-nya
    console.dir(tree, { depth: null });

    // Kalau mau simpan ke file:
    const fs = require('fs');
    fs.writeFileSync('output/menu_dokumen.json', JSON.stringify(tree, null, 2));

  } catch (err) {
    console.error('Gagal:', err.message);
  }
})();
