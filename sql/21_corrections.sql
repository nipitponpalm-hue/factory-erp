-- ===== ระบบแก้ไข/ยกเลิกรายการที่ลงข้อมูลผิด =====
-- หลักการ: ไม่ลบประวัติเดิม ใช้การ "บันทึกรายการล้าง" (reversal) แทน
-- ทุกอย่างที่เคยเกิดขึ้นยังคงอยู่ในระบบ ตรวจสอบย้อนหลังได้ครบ

-- QC: เก็บสถานะยกเลิกไว้กับ record เดิม (ไม่ลบทิ้ง)
alter table qc_records add column if not exists voided_at timestamptz;
alter table qc_records add column if not exists void_reason text;
alter table qc_records add column if not exists voided_by text;

-- Stock adjustment: รองรับปรับเพิ่มสต็อกได้ด้วย ไม่ใช่แค่ลดอย่างเดียว
alter table stock_adjustments add column if not exists direction text not null default 'out'; -- out = ลดสต็อก, in = เพิ่มสต็อก

-- Dispatch: รองรับรับคืนสินค้าเป็นรายการ (คืนสต็อกกลับ lot เดิม)
alter table dispatch_items add column if not exists returned_qty numeric not null default 0;
alter table dispatch_items add column if not exists return_reason text;
alter table dispatch_items add column if not exists returned_at timestamptz;
alter table dispatch_items add column if not exists returned_by text;

-- production_orders.status / repack_orders.status เป็น text อยู่แล้ว ใช้ค่า 'cancelled' ได้เลยไม่ต้องแก้ schema
-- rm_lots.status / fg_lots.status เป็น text อยู่แล้ว ใช้ค่า 'cancelled' สำหรับ lot ที่ถูกยกเลิกได้เลย
