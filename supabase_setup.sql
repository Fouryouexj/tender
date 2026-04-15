-- ══════════════════════════════════════════════════════
--  IMOTH TENDERS TRACKER — Supabase Database Setup
--  Run this in: Supabase Dashboard → SQL Editor → New query
-- ══════════════════════════════════════════════════════


-- 1. TENDERS TABLE
-- ──────────────────────────────────────────────────────
create table if not exists tenders (
  id          uuid primary key default gen_random_uuid(),
  pe_name     text not null,
  title       text not null,
  category    text not null default 'Comprehensive/Other',
  end_date    text not null,
  days_left   integer not null default 0,
  marketer    text not null default '',
  ad_status   text not null default '',
  notes       text not null default '',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Auto-update updated_at on every row change
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists tenders_updated_at on tenders;
create trigger tenders_updated_at
  before update on tenders
  for each row execute function set_updated_at();


-- 2. PROFILES TABLE
-- ──────────────────────────────────────────────────────
create table if not exists profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text not null,
  full_name   text not null default '',
  role        text not null default 'user',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Auto-update updated_at on profiles
drop trigger if exists profiles_updated_at on profiles;
create trigger profiles_updated_at
  before update on profiles
  for each row execute function set_updated_at();


-- 3. AUDIT LOG TABLE
-- ──────────────────────────────────────────────────────
create table if not exists audit_log (
  id              uuid primary key default gen_random_uuid(),
  user_email      text not null default '',
  user_name       text not null default '',
  action          text not null,   -- 'created' | 'updated' | 'deleted'
  tender_id       uuid,
  tender_pe_name  text not null default '',
  tender_title    text not null default '',
  changes         jsonb not null default '{}',
  created_at      timestamptz not null default now()
);


-- 3. ROW LEVEL SECURITY (RLS)
-- All authenticated users can do everything (employer's instruction)
-- ──────────────────────────────────────────────────────
alter table tenders enable row level security;
alter table profiles enable row level security;
alter table audit_log enable row level security;

-- Profiles: users can read all profiles, but only update their own
drop policy if exists "users read all profiles" on profiles;
create policy "users read all profiles"
  on profiles for select
  to authenticated
  using (true);

drop policy if exists "users update own profile" on profiles;
create policy "users update own profile"
  on profiles for all
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "users insert profiles" on profiles;
create policy "users insert profiles"
  on profiles for insert
  to authenticated
  with check (true);

-- Tenders: any authenticated user can select, insert, update, delete
drop policy if exists "authenticated full access tenders" on tenders;
create policy "authenticated full access tenders"
  on tenders for all
  to authenticated
  using (true)
  with check (true);

-- Audit log: any authenticated user can select and insert (no delete/update needed)
drop policy if exists "authenticated read audit" on audit_log;
create policy "authenticated read audit"
  on audit_log for select
  to authenticated
  using (true);

drop policy if exists "authenticated insert audit" on audit_log;
create policy "authenticated insert audit"
  on audit_log for insert
  to authenticated
  with check (true);


-- 4. REALTIME
-- ──────────────────────────────────────────────────────
-- Enable realtime on the tenders table so all browsers
-- update live when any user makes a change.
-- Go to: Supabase Dashboard → Database → Replication
-- and toggle ON the "tenders" table under supabase_realtime.
-- (Cannot be done via SQL — must be done in the dashboard.)


-- 5. INDEXES (for performance)
-- ──────────────────────────────────────────────────────
create index if not exists idx_tenders_days_left on tenders(days_left);
create index if not exists idx_tenders_category on tenders(category);
create index if not exists idx_tenders_marketer on tenders(marketer);
create index if not exists idx_profiles_email on profiles(email);
create index if not exists idx_audit_created_at on audit_log(created_at desc);


-- ══════════════════════════════════════════════════════
--  DONE! Now:
--  1. Open imoth_tenders_v3.html in your browser
--  2. Paste your Supabase URL and anon key at the top
--  3. Log in with an account you create in Supabase Auth
--  4. Open browser console and type: seedDB()
--     This loads all 173 tenders into the database (once only)
-- ══════════════════════════════════════════════════════
