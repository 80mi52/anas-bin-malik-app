# মাদ্রাসা আনাস বিন মালেক (রাঃ) — Android অ্যাপ প্রজেক্ট

এটি APK নয়; এটি Android APK তৈরির জন্য প্রস্তুত করা Capacitor project source। এই পরিবেশে Android SDK/Gradle build tools নেই, তাই এখান থেকে APK compile ও test করা যায়নি।

## কী আছে
- আগের QR scanner web app `www/index.html`
- Capacitor Android project configuration
- Supabase policy/setup reference files
- Android app ID: `bd.madrasa.anasbinmalik.attendance`

## APK তৈরির জন্য প্রয়োজন
1. কম্পিউটারে Node.js LTS ও Android Studio ইনস্টল করুন।
2. এই ZIP extract করে project folder-এ terminal খুলুন।
3. চালান:
   ```bash
   npm install
   npx cap add android
   npx cap sync android
   npx cap open android
   ```
4. Android Studio SDK/Gradle setup শেষ হলে Build > Build APK(s) নির্বাচন করুন।
5. APK সাধারণত `android/app/build/outputs/apk/debug/app-debug.apk`-এ তৈরি হবে।

## গুরুত্বপূর্ণ নিরাপত্তা/পরীক্ষা
- `www/index.html`-এ Supabase Project URL ও Publishable key অ্যাডমিন সংযোগ ফর্মে ব্যবহারকারী নিজে বসাবেন। Secret/service_role key কখনো অ্যাপে রাখবেন না।
- বাস্তব ছাত্রের তথ্য ব্যবহারের আগে Supabase RLS policies পরীক্ষা করুন।
- QR camera scan, photo upload, Android camera permission এবং attendance insert ডিভাইসে পরীক্ষা করতে হবে।
- এই source ZIP-কে ইনস্টলযোগ্য APK বলে গণ্য করবেন না; APK এখনো compile/test হয়নি।

## শুধু Android মোবাইল দিয়ে APK বানানো
`BUILD_APK_FROM_ANDROID_BN.txt` ফাইলের ধাপগুলো অনুসরণ করুন। এই ZIP-এ GitHub Actions workflow যোগ করা আছে; GitHub-এ source ফাইল আপলোড করলে cloud-এ debug APK তৈরি হবে। এটি সরাসরি APK নয়।
