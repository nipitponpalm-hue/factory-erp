-- ===== STOCK ADJUSTMENTS (ตัดสต็อก / write-off) =====
-- ใช้ตัดสต็อก RM ออกจากระบบพร้อมเหตุผล เช่น มอบให้, เน่าเสีย, สูญหาย

create table stock_adjustments (
  id          uuid primary key default gen_random_uuid(),
  adj_number  text unique not null,
  lot_id      uuid references rm_lots not null,
  qty         numeric not null,            -- จำนวนที่ตัดออก (บวกเสมอ)
  unit        text,
  reason      text not null,               -- giveaway | spoilage | lost | other
  note        text,
  operator    text,
  adj_date    date not null default current_date,
  created_at  timestamptz default now()
);

-- เก็บส่วนเกินจาก PO ใน receive_items แบบมีโครงสร้าง (แทนการฝังใน note)
alter table receive_items add column if not exists qty_over numeric default 0;
