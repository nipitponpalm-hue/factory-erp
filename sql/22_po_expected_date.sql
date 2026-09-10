-- เพิ่มวันที่คาดว่าจะได้รับสินค้าใน PO เพื่อให้หน้ารับสินค้าเรียงลำดับ PO ที่รอรับตามวันที่ได้
alter table purchase_orders add column if not exists expected_date date;
