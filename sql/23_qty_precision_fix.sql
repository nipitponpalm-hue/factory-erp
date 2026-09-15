-- แก้ปัญหา: บางรายการแสดงผล "0.05 เหลือ" แต่พอจ่ายออก/ตัดสต็อกกลับบอกว่าไม่พอ/เกินจำนวนจริง
-- สาเหตุ: ทุกครั้งที่ระบบคำนวณยอดคงเหลือใหม่ (เช่น รับเข้า - จ่ายออก) ด้วย JavaScript
-- ตัวเลขทศนิยมจะคลาดเคลื่อนเล็กน้อยจากธรรมชาติของ floating point เช่น 0.3 - 0.25
-- ได้ 0.049999999999999996 ไม่ใช่ 0.05 พอดี แล้วค่าที่คลาดเคลื่อนนี้ถูกบันทึกจริงและ
-- สะสมเพิ่มขึ้นทุกธุรกรรม จนกระทั่งการเทียบจำนวนที่ขอกับจำนวนคงเหลือผิดพลาด
-- (โค้ดฝั่งแอปแก้ให้ปัดเศษทุกครั้งที่คำนวณ+บันทึกแล้ว ส่วนนี้คือการล้างค่าที่คลาดเคลื่อนสะสมอยู่ก่อนหน้า)

update rm_stock set qty_on_hand = round(qty_on_hand::numeric, 3);
update fg_stock set qty_on_hand = round(qty_on_hand::numeric, 3);
update rm_lots set initial_qty = round(initial_qty::numeric, 3);
update fg_lots set initial_qty = round(initial_qty::numeric, 3);
update po_items set qty_received = round(qty_received::numeric, 3);
