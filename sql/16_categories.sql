-- ===== CATEGORIES (จัดการหมวดหมู่วัตถุดิบ/สินค้าเอง แทนการ hardcode) =====

create table categories (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,   -- ใช้เป็นค่าที่เก็บใน materials.category / products.category
  label       text not null,          -- ชื่อแสดงผลภาษาไทย
  sort_order  int default 0,
  is_active   boolean default true,
  created_at  timestamptz default now()
);

-- seed หมวดหมู่ที่มีอยู่แล้วในระบบ (รวมของ 3 ไฟล์ที่เคย hardcode ไว้ไม่ตรงกัน)
insert into categories (code, label, sort_order) values
  ('veg',       'ผัก/ผลไม้',     1),
  ('fresh',     'อาหารสด',       2),
  ('dry',       'ของแห้ง',       3),
  ('spice',     'เครื่องปรุง',   4),
  ('drink',     'เครื่องดื่ม',   5),
  ('processed', 'อาหารแปรรูป',  6),
  ('frozen',    'แช่แข็ง',       7),
  ('pack',      'บรรจุภัณฑ์',   8),
  ('other',     'อื่นๆ',         9)
on conflict (code) do nothing;
