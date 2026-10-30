-- অভিভাবক প্যানেল: মাদ্রাসা আনাস বিন মালেক (রাঃ)
-- Supabase SQL Editor-এ একবারে পুরো SQL চালান।
-- প্রত্যেক অভিভাবকের জন্য Authentication > Users-এ ইমেইল/পাসওয়ার্ড অ্যাকাউন্ট তৈরি করুন।
-- নিচের INSERT-এ অভিভাবকের ইমেইল ও ছাত্রের Student ID বসিয়ে আলাদাভাবে চালান।

CREATE TABLE IF NOT EXISTS public.guardian_accounts (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  student_id bigint NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.guardian_accounts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS anm_guardian_self_read ON public.guardian_accounts;
CREATE POLICY anm_guardian_self_read ON public.guardian_accounts
  FOR SELECT TO authenticated USING (user_id = auth.uid());

DROP POLICY IF EXISTS anm_guardian_admin_all ON public.guardian_accounts;
CREATE POLICY anm_guardian_admin_all ON public.guardian_accounts
  FOR ALL TO authenticated
  USING (public.is_madrasa_admin())
  WITH CHECK (public.is_madrasa_admin());

-- অভিভাবক কেবল নিজের সঙ্গে যুক্ত ছাত্রের তথ্য পড়তে পারবেন।
DROP POLICY IF EXISTS anm_guardian_linked_student_read ON public.students;
CREATE POLICY anm_guardian_linked_student_read ON public.students
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.guardian_accounts ga
    WHERE ga.user_id = auth.uid() AND ga.student_id = students.id
  ));

-- অভিভাবক কেবল নিজের সন্তানের হাজিরা দেখতে পারবেন।
DROP POLICY IF EXISTS anm_guardian_linked_attendance_read ON public.student_attendance;
CREATE POLICY anm_guardian_linked_attendance_read ON public.student_attendance
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.guardian_accounts ga
    WHERE ga.user_id = auth.uid() AND ga.student_id = student_attendance.student_id
  ));

-- অভিভাবক অ্যাকাউন্টকে admin/teacher profile দেওয়া হবে না।
-- উদাহরণ (নিজের তথ্য বসিয়ে চালান):
-- INSERT INTO public.guardian_accounts(user_id, student_id)
-- SELECT u.id, s.id
-- FROM auth.users u
-- JOIN public.students s ON s.student_code = 'ANM-12345678-12'
-- WHERE u.email = 'guardian@example.com'
-- ON CONFLICT (user_id) DO UPDATE SET student_id = EXCLUDED.student_id;

-- যাচাই: নিচের SELECT-এ অভিভাবকের ইমেইল ও ছাত্রের আইডি/নাম দেখুন।
-- SELECT u.email, s.student_code, s.full_name
-- FROM public.guardian_accounts ga
-- JOIN auth.users u ON u.id=ga.user_id
-- JOIN public.students s ON s.id=ga.student_id;
