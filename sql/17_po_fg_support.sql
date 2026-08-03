-- ===== รองรับเปิด PO / รับสินค้า สำหรับสินค้าสำเร็จรูป (FG) ที่ซื้อมาโดยตรง =====
-- เช่น พริกเด็ดขั้วที่บางครั้งซื้อสำเร็จมาแทนที่จะผลิตเอง

-- po_items และ receive_items รองรับได้ทั้งวัตถุดิบ (material_id) และสินค้าสำเร็จรูป (product_id)
-- มีค่าใดค่าหนึ่งเท่านั้นในแต่ละแถว
alter table po_items add column if not exists product_id uuid references products;
alter table receive_items add column if not exists product_id uuid references products;

-- fg_lots ต้องรองรับ QC ก่อนเข้าสต็อกได้ (เหมือน rm_lots)
alter table fg_lots add column if not exists supplier_id uuid references suppliers;
alter table fg_lots add column if not exists supplier_lot text;
alter table fg_lots add column if not exists mfg_date date;
alter table fg_lots add column if not exists ro_item_id uuid references receive_items;
alter table fg_lots add column if not exists purchase_order_id uuid references purchase_orders;
-- status รองรับค่าเพิ่ม: qc_pending (เดิมมีแค่ available, on_hold, depleted)

-- qc_records รองรับตรวจ FG lot ที่ซื้อมาโดยตรงด้วย (rm_lot_id เดิมก็ nullable อยู่แล้ว)
alter table qc_records add column if not exists fg_lot_id uuid references fg_lots;
