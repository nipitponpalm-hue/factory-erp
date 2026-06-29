-- ===== RECEIVING =====

create table receive_orders (
  id            uuid primary key default gen_random_uuid(),
  ro_number     text unique not null,
  supplier_id   uuid references suppliers,
  receive_date  date not null,
  operator      text not null,
  vehicle_no    text,
  note          text,
  status        text default 'draft',  -- draft, confirmed
  created_at    timestamptz default now()
);

create table receive_items (
  id            uuid primary key default gen_random_uuid(),
  ro_id         uuid references receive_orders on delete cascade,
  material_id   uuid references materials,
  qty           numeric not null,
  unit          text not null,
  supplier_lot  text,
  mfg_date      date,
  exp_date      date,
  note          text
);
