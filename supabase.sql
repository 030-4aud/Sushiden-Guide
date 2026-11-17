-- Supabase SQL Editor에서 실행. RLS 정책이 보안을 담당합니다.
create table if not exists public.posts (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 author text not null,
 category text not null check (category in ('첫 출근 후기','업무 꿀팁','실수 경험','질문 있어요','자유 이야기')),
 title text not null check (char_length(title) between 2 and 100),
 body text not null check (char_length(body) between 5 and 10000),
 created_at timestamptz not null default now()
);
create table if not exists public.comments (
 id uuid primary key default gen_random_uuid(),
 post_id uuid not null references public.posts(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 author text not null,
 body text not null check (char_length(body) between 1 and 2000),
 created_at timestamptz not null default now()
);
create table if not exists public.inquiries (
 id uuid primary key default gen_random_uuid(),
 name text not null check (char_length(name) between 1 and 60),
 email text not null check (char_length(email) between 3 and 150),
 message text not null check (char_length(message) between 1 and 3000),
 created_at timestamptz not null default now()
);
alter table public.posts enable row level security;
alter table public.comments enable row level security;
alter table public.inquiries enable row level security;
create policy "Read posts" on public.posts for select to anon,authenticated using (true);
create policy "Insert own posts" on public.posts for insert to authenticated with check (auth.uid() = user_id);
create policy "Update own posts" on public.posts for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Delete own posts" on public.posts for delete to authenticated using (auth.uid() = user_id);
create policy "Read comments" on public.comments for select to anon,authenticated using (true);
create policy "Insert own comments" on public.comments for insert to authenticated with check (auth.uid() = user_id);
create policy "Delete own comments" on public.comments for delete to authenticated using (auth.uid() = user_id);
-- 공개 문의 양식은 남용 방지를 위해 로그인 사용자만 DB에 삽입하도록 제한합니다.
-- 익명 문의가 필요하면 CAPTCHA + 서버리스 함수/메일 서비스로 변경하세요.
create policy "Insert inquiry authenticated" on public.inquiries for insert to authenticated with check (true);
-- 문의 내용은 브라우저에서 조회할 수 없습니다. Supabase 관리자 화면에서만 확인합니다.