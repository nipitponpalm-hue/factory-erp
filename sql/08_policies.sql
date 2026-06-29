-- ===== RLS POLICIES (allow all — no auth yet) =====

do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public'
  loop
    execute format('alter table %I enable row level security', t);
    execute format(
      'create policy "allow_all_%I" on %I for all using (true) with check (true)', t, t
    );
  end loop;
end $$;
