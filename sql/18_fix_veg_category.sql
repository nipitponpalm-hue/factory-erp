-- ===== แก้ไขข้อมูล: วัตถุดิบที่หมวดหมู่เขียนเป็น "VEG" (ตัวพิมพ์ใหญ่/ไม่ตรง code) ให้เป็น 'veg' =====
-- code มาตรฐานของหมวด "ผัก/ผลไม้" คือ veg (ตัวพิมพ์เล็ก) ตามตาราง categories

update materials
set category = 'veg'
where category ilike 'veg'
  and category <> 'veg';

-- เผื่อกรณีพิมพ์เป็นคำเต็มภาษาอังกฤษ/มีช่องว่างเกิน
update materials
set category = 'veg'
where trim(lower(category)) in ('vegetable','vegetables','veg.','veg ')
  and category <> 'veg';

-- ตรวจสอบผลลัพธ์: ดูว่ายังมีค่าที่ไม่ตรงกับ categories.code ตัวไหนอยู่บ้าง
select category, count(*)
from materials
where category not in (select code from categories)
group by category;
