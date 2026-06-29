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
