-- ===== DISPATCH =====

create table dispatch_orders (
  id            uuid primary key default gen_random_uuid(),
  do_number     text unique not null,
  customer_id   uuid references customers,
  dispatch_date date not null,
  operator      text not null,
  vehicle_no    text,
  note          text,
  status        text default 'draft',  -- draft, confirmed
  created_at    timestamptz default now()
);

create table dispatch_items (
  id            uuid primary key default gen_random_uuid(),
  do_id         uuid references dispatch_orders on delete cascade,
  fg_lot_id     uuid references fg_lots,
  qty           numeric not null,
  unit          text not null
);
