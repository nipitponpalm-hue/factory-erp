-- ===== PRODUCTION =====

create table production_orders (
  id              uuid primary key default gen_random_uuid(),
  po_number       text unique not null,
  product_id      uuid references products,
  planned_qty     numeric,
  actual_qty      numeric,
  unit            text,
  planned_date    date,
  started_at      timestamptz,
  completed_at    timestamptz,
  operator        text,
  status          text default 'planned',  -- planned, in_progress, completed, cancelled
  note            text,
  created_at      timestamptz default now()
);

alter table fg_lots
  add constraint fg_lots_po_fk
  foreign key (po_id) references production_orders;

alter table issue_orders
  add constraint issue_orders_po_fk
  foreign key (po_id) references production_orders;

create table production_inputs (
  id          uuid primary key default gen_random_uuid(),
  po_id       uuid references production_orders on delete cascade,
  lot_id      uuid references rm_lots,
  qty_used    numeric not null,
  unit        text not null
);

create table production_outputs (
  id            uuid primary key default gen_random_uuid(),
  po_id         uuid references production_orders on delete cascade,
  fg_lot_id     uuid references fg_lots,
  qty_produced  numeric not null,
  unit          text not null
);
