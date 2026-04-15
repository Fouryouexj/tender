-- ══════════════════════════════════════════════════════
--  IMOTH TENDERS — SQL PATCH for user signup flow
--  Run this in Supabase SQL Editor if you already ran
--  the original supabase_setup.sql
-- ══════════════════════════════════════════════════════

-- Allow any authenticated user to insert a profile
-- (needed because signUp creates the auth user first,
-- then we immediately upsert their profile row)
drop policy if exists "users insert profiles" on profiles;
create policy "users insert profiles"
  on profiles for insert
  to authenticated
  with check (true);

-- Also allow service inserts during signup (anon role for the brief window)
drop policy if exists "anon insert own profile" on profiles;
create policy "anon insert own profile"
  on profiles for insert
  to anon
  with check (true);

-- ══════════════════════════════════════════════════════
--  IMPORTANT: Disable email confirmation in Supabase
--  so new users can sign in immediately after being added.
--
--  Go to: Supabase Dashboard
--    → Authentication
--    → Providers
--    → Email
--    → Toggle OFF "Confirm email"
--    → Save
--
--  Without this, new users must click a confirmation
--  link before they can sign in.
-- ══════════════════════════════════════════════════════