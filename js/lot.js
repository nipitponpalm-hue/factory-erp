// Auto Lot Number Generator
// Format: PREFIX + yymmdd (พ.ศ.) + 3-digit seq
// e.g. RM260629001, FG260629001, PO260629001

async function generateLotNumber(prefix) {
  const now = new Date();
  const yy = String((now.getFullYear() + 543) % 100).padStart(2, '0');
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const dd = String(now.getDate()).padStart(2, '0');
  const dateStr = `${yy}${mm}${dd}`;

  const { data, error } = await db.rpc('increment_lot_seq', {
    p_prefix: prefix,
    p_date_str: dateStr
  });

  if (error) throw error;
  const seq = String(data).padStart(3, '0');
  return `${prefix}${dateStr}${seq}`;
}
