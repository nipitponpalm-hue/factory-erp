-- ===== ADD is_processed TO rm_lots =====
-- RM lots จากการรับสินค้า: is_processed = false (ยังไม่ผ่านกระบวนการ)
-- RM lots จาก repack/sort output: is_processed = true (ผ่านแล้ว จ่ายได้)

alter table rm_lots add column if not exists is_processed boolean not null default false;

-- lots ที่มาจาก repack_outputs ให้ mark เป็น processed ทันที (retroactive)
update rm_lots
set is_processed = true
where id in (select new_lot_id from repack_outputs where new_lot_id is not null);
