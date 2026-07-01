-- ===== PURCHASE ORDERS =====

create table purchase_orders (
  id           uuid primary key default gen_random_uuid(),
  po_number    text,                          -- เลขจาก Express (optional)
  internal_ref text unique not null,          -- เลขอ้างอิงภายใน auto-gen
  supplier_id  uuid references suppliers,
  status       text default 'open',           -- open, partial, closed
  note         text,
  created_by   text,
  created_at   timestamptz default now(),
  closed_at    timestamptz
);

create table po_items (
  id           uuid primary key default gen_random_uuid(),
  po_id        uuid references purchase_orders on delete cascade,
  material_id  uuid references materials,
  qty_ordered  numeric not null,
  qty_received numeric default 0,
  unit         text not null
);

-- เพิ่ม po_id ใน receive_orders
alter table receive_orders add column if not exists po_id uuid references purchase_orders;
