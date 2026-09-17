// ===== Shared Utilities =====

function fmtDate(iso) {
  if (!iso) return '-';
  const d = new Date(iso);
  if (isNaN(d)) return iso;
  return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear() + 543}`;
}

function fmtDT(iso) {
  if (!iso) return '-';
  const d = new Date(iso);
  if (isNaN(d)) return iso;
  const pad = n => String(n).padStart(2, '0');
  return `${pad(d.getDate())}/${pad(d.getMonth()+1)}/${d.getFullYear()+543} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function fmtQty(n) {
  return Number(n).toLocaleString('th-TH', { minimumFractionDigits: 0, maximumFractionDigits: 3 });
}

// ปัดเศษจำนวนสต็อกก่อนบันทึกลง DB — กัน floating point คลาดเคลื่อนสะสม
// (เช่น 0.3 - 0.25 ใน JS ได้ 0.04999999999999999 ไม่ใช่ 0.05 พอดี ถ้าไม่ปัด ค่าที่คลาดเคลื่อนนี้จะถูกบันทึกจริงและสะสมไปเรื่อยๆ)
function roundQty(n, dp = 3) {
  const f = 10 ** dp;
  return Math.round((Number(n) + Number.EPSILON) * f) / f;
}

// เทียบว่า qty ที่ขอเกินจำนวนคงเหลือจริงหรือไม่ โดยยอมรับความคลาดเคลื่อนเล็กน้อยจาก floating point
function qtyExceeds(requested, available, eps = 1e-6) {
  return Number(requested) > Number(available) + eps;
}

// ป้ายบอกที่มาของ RM lot: รับเข้าตรง หรือผ่านการคัด/รีแพ็คมา (ใช้ตอนเลือก lot ไปผลิต/คัด/จ่าย)
function lotOriginBadgeRM(l) {
  return l.is_processed
    ? `<span style="font-size:11px;background:var(--green-soft);color:var(--green-deep);border-radius:4px;padding:1px 6px;margin-left:6px;font-weight:600;">✂️ คัด/รีแพ็ค ${fmtDate(l.receive_date)}</span>`
    : `<span style="font-size:11px;background:#EDE9DD;color:var(--ink-deep);border-radius:4px;padding:1px 6px;margin-left:6px;font-weight:600;">📥 รับเข้า ${fmtDate(l.receive_date)}</span>`;
}
// ป้ายบอกที่มาของ FG lot: ผลิตเอง หรือซื้อสำเร็จรูปมาโดยตรง
function lotOriginBadgeFG(l) {
  return l.po_id
    ? `<span style="font-size:11px;background:#DBEAFE;color:#1E40AF;border-radius:4px;padding:1px 6px;margin-left:6px;font-weight:600;">🏭 ผลิต ${fmtDate(l.produced_date)}</span>`
    : `<span style="font-size:11px;background:#EDE9DD;color:var(--ink-deep);border-radius:4px;padding:1px 6px;margin-left:6px;font-weight:600;">📥 รับเข้า ${fmtDate(l.produced_date)}</span>`;
}

function toLocalInput(d = new Date()) {
  const pad = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function toDateInput(d = new Date()) {
  const pad = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
}

function showToast(msg, type = 'success') {
  const t = document.getElementById('toast');
  if (!t) return;
  t.textContent = msg;
  t.className = `toast show ${type}`;
  clearTimeout(t._timer);
  t._timer = setTimeout(() => t.classList.remove('show'), 2800);
}

function showLoading(show) {
  const el = document.getElementById('loadingOverlay');
  if (el) el.style.display = show ? 'flex' : 'none';
}

// Combobox generic setup
function setupCombo({ inputEl, listEl, getItems, renderItem, onSelect, onQueryChange }) {
  let activeIndex = -1;
  function open(items) {
    listEl.innerHTML = items.length
      ? items.map((it, i) => renderItem(it, i)).join('')
      : '<div class="combo-empty">ไม่พบรายการ</div>';
    listEl.style.display = 'block';
    activeIndex = -1;
  }
  function close() { listEl.style.display = 'none'; activeIndex = -1; }
  inputEl.addEventListener('focus', () => open(getItems(inputEl.value)));
  inputEl.addEventListener('input', () => { if (onQueryChange) onQueryChange(); open(getItems(inputEl.value)); });
  inputEl.addEventListener('keydown', e => {
    const items = listEl.querySelectorAll('.combo-item');
    if (e.key === 'ArrowDown') { e.preventDefault(); activeIndex = Math.min(activeIndex + 1, items.length - 1); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); activeIndex = Math.max(activeIndex - 1, 0); }
    else if (e.key === 'Enter') { e.preventDefault(); if (activeIndex >= 0 && items[activeIndex]) items[activeIndex].click(); return; }
    else if (e.key === 'Escape') { close(); return; }
    else return;
    items.forEach((el, i) => el.classList.toggle('active', i === activeIndex));
    if (items[activeIndex]) items[activeIndex].scrollIntoView({ block: 'nearest' });
  });
  document.addEventListener('click', e => {
    if (!inputEl.contains(e.target) && !listEl.contains(e.target)) close();
  });
  listEl.addEventListener('click', e => {
    const row = e.target.closest('.combo-item');
    if (!row) return;
    onSelect(getItems(inputEl.value)[Number(row.dataset.idx)]);
    close();
  });
  return { close };
}

// ===== PWA SERVICE WORKER =====
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(() => {});
  });
}

// ===== MOBILE NAV (auto-injected on every page) =====
function initMobileNav() {
  const sidebar = document.querySelector('.sidebar');
  if (!sidebar || document.querySelector('.mobile-topbar')) return;

  // หา title จาก page-title หรือ brand
  const brandTitle = document.querySelector('.sidebar-brand h1')?.textContent || 'Factory ERP';

  // topbar
  const topbar = document.createElement('div');
  topbar.className = 'mobile-topbar';
  topbar.innerHTML = `
    <button class="hamburger" aria-label="เมนู"><span></span><span></span><span></span></button>
    <div class="mt-title">${brandTitle}</div>`;
  document.body.insertBefore(topbar, document.body.firstChild);

  // backdrop
  const backdrop = document.createElement('div');
  backdrop.className = 'nav-backdrop';
  document.body.appendChild(backdrop);

  function open()  { sidebar.classList.add('open');  backdrop.classList.add('show'); }
  function close() { sidebar.classList.remove('open'); backdrop.classList.remove('show'); }

  topbar.querySelector('.hamburger').addEventListener('click', () => {
    sidebar.classList.contains('open') ? close() : open();
  });
  backdrop.addEventListener('click', close);
  // ปิดเมนูเมื่อคลิกลิงก์
  sidebar.querySelectorAll('.nav-item').forEach(a => a.addEventListener('click', close));
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initMobileNav);
} else {
  initMobileNav();
}

// Export to Excel helper
function exportExcel(wsData, sheetName, filename) {
  const ws = XLSX.utils.aoa_to_sheet(wsData);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, sheetName);
  const buf = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
  const blob = new Blob([buf], { type: 'application/octet-stream' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url; a.download = filename;
  document.body.appendChild(a); a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}
