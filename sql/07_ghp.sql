-- ===== GHP / QC =====

create table qc_records (
  id              uuid primary key default gen_random_uuid(),
  rm_lot_id       uuid references rm_lots,
  ro_item_id      uuid references receive_items,
  operator        text not null,
  inspect_date    timestamptz default now(),
  result          text not null,  -- passed, failed, on_hold
  temp_actual     numeric,
  appearance      text,
  note            text,
  created_at      timestamptz default now()
);

create table cleaning_records (
  id            uuid primary key default gen_random_uuid(),
  area          text not null,
  operator      text not null,
  cleaned_at    timestamptz default now(),
  method        text,
  chemical      text,
  verified_by   text,
  note          text
);

create table temperature_records (
  id            uuid primary key default gen_random_uuid(),
  location      text not null,
  operator      text not null,
  recorded_at   timestamptz default now(),
  temp_value    numeric not null,
  is_in_range   boolean,
  note          text
);
