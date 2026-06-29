// FIFO Suggestion Engine
// รับ materialId + qtyNeeded → return แผน lot split

async function suggestFifo(materialId, qtyNeeded) {
  const { data: lots, error } = await db
    .from('rm_lots')
    .select('id, lot_number, receive_date, exp_date, unit, rm_stock(qty_on_hand)')
    .eq('material_id', materialId)
    .eq('status', 'available')
    .order('receive_date', { ascending: true })
    .order('lot_number', { ascending: true });

  if (error) throw error;

  const available = lots.filter(l => l.rm_stock && l.rm_stock.qty_on_hand > 0);
  let remaining = qtyNeeded;
  const plan = [];

  for (const lot of available) {
    if (remaining <= 0) break;
    const take = Math.min(lot.rm_stock.qty_on_hand, remaining);
    plan.push({
      lot_id:     lot.id,
      lot_number: lot.lot_number,
      qty:        take,
      qty_on_hand: lot.rm_stock.qty_on_hand,
      exp_date:   lot.exp_date,
      is_fifo:    true
    });
    remaining -= take;
  }

  return { plan, shortage: Math.max(0, remaining) };
}
