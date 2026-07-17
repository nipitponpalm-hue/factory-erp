-- ===== REPACK GRADE (คัดหลายเกรดต่อครั้ง — SKU เดิม) =====
-- เกรดที่คัดออกไม่ใช่ของเสียเสมอไป อาจขายได้กับลูกค้าคนละกลุ่ม
-- เก็บ "เกรด" เป็น attribute ที่ตัว Lot/Output ไม่แยก SKU

alter table rm_lots add column if not exists grade text;
alter table repack_outputs add column if not exists grade text;
