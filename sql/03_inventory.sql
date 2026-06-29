-- ===== INVENTORY (LOT-BASED) =====

create table rm_lots (
  id            uuid primary key default gen_random_uuid(),
  lot_number    text unique not null,
  material_id   uuid references materials,
  ro_item_id    uuid references receive_items,
  supplier_id   uuid references suppliers,
  supplier_lot  text,
  receive_date  date not null,
  exp_date      date,
  initial_qty   numeric not null,
  unit          text not null,
  status        text default 'qc_pending',  -- qc_pending, available, on_hold, depleted, expired
  created_at    timestamptz default now()
);

create table rm_stock (
  lot_id        uuid primary key references rm_lots,
  qty_on_hand   numeric default 0,
  updated_at    timestamptz default now()
);

create table rm_transactions (
  id            uuid primary key default gen_random_uuid(),
  lot_id        uuid references rm_lots,
  txn_type      text not null,  -- receive, issue, adjust, return, waste
  qty           numeric not null,
  ref_id        uuid,
  ref_type      text,
  operator      text,
  note          text,
  created_at    timestamptz default now()
);

create table fg_lots (
  id            uuid primary key default gen_random_uuid(),
  lot_number    text unique not null,
  product_id    uuid references products,
  po_id         uuid,
  produced_date date not null,
  exp_date      date,
  initial_qty   numeric not null,
  unit          text not null,
  status        text default 'available',  -- available, on_hold, depleted
  created_at    timestamptz default now()
);

create table fg_stock (
  fg_lot_id     uuid primary key references fg_lots,
  qty_on_hand   numeric default 0,
  updated_at    timestamptz default now()
);

create table fg_transactions (
  id            uuid primary key default gen_random_uuid(),
  fg_lot_id     uuid references fg_lots,
  txn_type      text not null,  -- produced, dispatched, adjust, return
  qty           numeric not null,
  ref_id        uuid,
  ref_type      text,
  operator      text,
  note          text,
  created_at    timestamptz default now()
);
