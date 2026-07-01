-- ===== REPACK / SORT ORDERS =====
-- กระบวนการคัด/รีแพ็ค: RM → RM (SKU เดิม, qty น้อยลง)

create table repack_orders (
  id           uuid primary key default gen_random_uuid(),
  rp_number    text unique not null,
  operator     text,
  repack_date  date not null,
  note         text,
  status       text default 'completed',
  created_at   timestamptz default now()
);

create table repack_inputs (
  id        uuid primary key default gen_random_uuid(),
  rp_id     uuid references repack_orders on delete cascade,
  lot_id    uuid references rm_lots,
  qty_used  numeric not null,
  unit      text
);

create table repack_outputs (
  id           uuid primary key default gen_random_uuid(),
  rp_id        uuid references repack_orders on delete cascade,
  material_id  uuid references materials,
  qty_output   numeric not null,
  unit         text,
  new_lot_id   uuid references rm_lots
);
