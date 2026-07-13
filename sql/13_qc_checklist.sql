-- ===== QC CHECKLIST (กายภาพ/ชีวภาพ/เคมี/ขนส่ง) =====
-- checklist: เกณฑ์ที่ตรวจได้ทันที (กายภาพ+ชีวภาพ+ขนส่ง) เก็บเป็น JSON { key: true/false }
-- true = ปกติ/ไม่พบปัญหา, false = พบปัญหา
--
-- สารเคมีตกค้าง แยกออกมาต่างหาก เพราะไม่ต้องรอผลก่อนรับ/ผลิต (non-blocking)
-- chemical_status: pending (รอผล) | passed (ผ่าน) | failed (ไม่ผ่าน)

alter table qc_records add column if not exists checklist jsonb;
alter table qc_records add column if not exists chemical_status text default 'pending';
alter table qc_records add column if not exists chemical_note text;
alter table qc_records add column if not exists chemical_checked_at timestamptz;
alter table qc_records add column if not exists chemical_checked_by text;
