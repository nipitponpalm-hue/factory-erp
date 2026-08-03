-- ===== REQUIRES_PROCESSING (สินค้าซื้อมาขายไป vs วัตถุดิบที่ต้องแปรรูป) =====
-- true (default)  = ต้องผ่านคัด/รีแพ็คก่อนถึงจ่ายได้ (เช่น ผัก/ผลไม้)
-- false           = พร้อมจ่ายได้ทันทีหลัง QC ผ่าน ไม่ต้องผ่านคัด/รีแพ็ค (เช่น สินค้าซื้อมาขายไป)

alter table materials add column if not exists requires_processing boolean default true;
