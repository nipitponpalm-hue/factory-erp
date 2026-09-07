-- ===== รองรับใช้ FG lot เป็นวัตถุดิบตั้งต้นในการผลิต FG อีกที =====
-- เช่น เอา FG บรรจุถุงใหญ่ มาแบ่งบรรจุเป็น FG ถุงเล็ก (คนละ SKU หรือ SKU เดิมก็ได้)

alter table production_inputs add column if not exists fg_lot_id uuid references fg_lots;
