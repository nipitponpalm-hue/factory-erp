-- ===== รองรับตัดสต็อกสินค้าสำเร็จรูป (FG) เหมือนวัตถุดิบ (RM) =====

alter table stock_adjustments alter column lot_id drop not null;
alter table stock_adjustments add column if not exists fg_lot_id uuid references fg_lots;
