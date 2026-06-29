-- ===== ISSUE TO PRODUCTION =====

create table issue_orders (
  id            uuid primary key default gen_random_uuid(),
  io_number     text unique not null,
  po_id         uuid,
  operator      text not null,
  issue_date    timestamptz default now(),
  status        text default 'draft',  -- draft, issued
  note          text,
  created_at    timestamptz default now()
);

create table issue_items (
  id              uuid primary key default gen_random_uuid(),
  io_id           uuid references issue_orders on delete cascade,
  lot_id          uuid references rm_lots,
  qty_issued      numeric not null,
  is_fifo         boolean default true,
  override_reason text,
  created_at      timestamptz default now()
);
