-- ===== ADD po_date TO purchase_orders =====
-- ให้กำหนดวันที่สั่งซื้อเองได้ (แยกจาก created_at ซึ่งเป็นเวลาที่บันทึกเข้าระบบ)

alter table purchase_orders add column if not exists po_date date not null default current_date;
