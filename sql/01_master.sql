-- ===== MASTER DATA =====

create table suppliers (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,
  name        text not null,
  contact     text,
  phone       text,
  address     text,
  is_active   boolean default true,
  created_at  timestamptz default now()
);

create table customers (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,
  name        text not null,
  contact     text,
  phone       text,
  address     text,
  is_active   boolean default true,
  created_at  timestamptz default now()
);

create table materials (
  id               uuid primary key default gen_random_uuid(),
  sku              text unique not null,
  name             text not null,
  category         text not null,
  unit             text not null,
  min_stock        numeric default 0,
  shelf_life_days  int,
  storage_note     text,
  is_active        boolean default true,
  created_at       timestamptz default now()
);

create table products (
  id               uuid primary key default gen_random_uuid(),
  sku              text unique not null,
  name             text not null,
  category         text not null,
  unit             text not null,
  shelf_life_days  int,
  is_active        boolean default true,
  created_at       timestamptz default now()
);

create table operators (
  id          uuid primary key default gen_random_uuid(),
  name        text unique not null,
  department  text,
  is_active   boolean default true
);

create table lot_sequences (
  prefix      text not null,
  date_str    text not null,
  last_seq    int default 0,
  primary key (prefix, date_str)
);

create or replace function increment_lot_seq(p_prefix text, p_date_str text)
returns int language plpgsql as $$
declare v_seq int;
begin
  insert into lot_sequences (prefix, date_str, last_seq)
  values (p_prefix, p_date_str, 1)
  on conflict (prefix, date_str)
  do update set last_seq = lot_sequences.last_seq + 1
  returning last_seq into v_seq;
  return v_seq;
end;
$$;
