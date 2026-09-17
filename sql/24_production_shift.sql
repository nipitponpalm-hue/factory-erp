-- เปลี่ยนช่องกรอกวันเวลาผลิตด้านบนของหน้าผลิต จากพิมพ์เวลาเป๊ะๆ เป็นเลือกวันที่ + ติ๊กกะ (เช้า/บ่าย/ดึก)
alter table production_orders add column if not exists shift text;
