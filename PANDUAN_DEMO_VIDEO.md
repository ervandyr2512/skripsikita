# 🎥 Panduan Demonstrasi Video + Narasi Lengkap
## SkripsiKita — Flutter Widgets Assignment (Sesi 6)

---

## 📋 Persiapan Sebelum Recording

### Setup Teknis
1. **Buka 2 aplikasi sekaligus** (split-screen disarankan):
   - **Kiri:** VS Code / Android Studio (untuk menunjukkan kode)
   - **Kanan:** Emulator / device fisik (untuk demo aplikasi)
2. **Jalankan aplikasi:**
   ```bash
   cd /Users/ervandyrangganata/Downloads/skripsikita
   flutter run
   ```
3. **Software perekam:** OBS Studio, QuickTime, atau Loom
4. **Mic:** pakai earphone berbawaan/headset untuk audio jernih
5. **Durasi target:** 10–15 menit total

### File yang Wajib Disiapkan untuk Ditunjukkan
| Section | File Path |
|---------|-----------|
| Routing (GoRouter) | `lib/core/router/app_router.dart` |
| Navigator (MaterialPageRoute) | `lib/features/profile/profile_screen.dart` (baris menu Edit Profil) |
| Form (Login) | `lib/features/auth/login_screen.dart` |
| Form (Add Milestone) | `lib/features/timeline/add_milestone_screen.dart` |
| Widget kompleks | `lib/features/dashboard/dashboard_screen.dart` |
| Widget animasi | `lib/features/splash/splash_screen.dart` |
| State management | `lib/state/app_state.dart` |

---

## 🗂️ Struktur Video (5 Bagian)

| Bagian | Durasi | Topik |
|--------|--------|-------|
| 1. Intro | 1 menit | Pengenalan diri & aplikasi |
| 2. Demo Aplikasi | 5 menit | Walk-through fitur end-to-end |
| 3. Flutter Widgets | 3 menit | Penjelasan widget yang dipakai |
| 4. Navigation | 3 menit | GoRouter & MaterialPageNavigator |
| 5. Form | 2 menit | Form validation & best practice |
| 6. Penutup | 30 detik | Kesimpulan & ucapan terima kasih |

---

# 📝 NARASI LENGKAP (Read Aloud Script)

> **Catatan:** Tanda `[AKSI: ...]` = apa yang harus kamu lakukan saat membaca narasi.
> Tanda `[TUNJUKKAN KODE: ...]` = file yang harus kamu klik di IDE.

---

## 🎬 BAGIAN 1 — INTRO (≈ 1 menit)

[AKSI: Tunjukkan splash screen aplikasi]

> "Halo semuanya, perkenalkan saya **Ervandy Rangganata** dari mata kuliah Mobile Application Development.
>
> Di video ini, saya akan mendemonstrasikan aplikasi yang saya bangun untuk **Sesi 6: Flutter Widgets Assignment**. Nama aplikasinya adalah **SkripsiKita** — sebuah pendamping cerdas untuk perjalanan skripsi mahasiswa Indonesia.
>
> Aplikasi ini saya kembangkan dari proposal AFL 1 dan mengintegrasikan empat aspek penting: **manajemen progres skripsi, komunikasi bimbingan dengan dosen, manajemen referensi jurnal, dan kesejahteraan mental mahasiswa**.
>
> Dalam video ini saya akan menunjukkan tiga hal sesuai instruksi assignment:
>
> 1. **Penggunaan berbagai Flutter widgets**
> 2. **Page navigation** menggunakan **GoRouter** dan **MaterialPageNavigator**
> 3. **Flutter form** lengkap dengan validation
>
> Mari kita mulai dengan demo aplikasinya."

---

## 🎬 BAGIAN 2 — DEMO APLIKASI (≈ 5 menit)

### 2.1 — Splash & Onboarding (30 detik)

[AKSI: Restart aplikasi atau clear data dulu agar onboarding muncul. Atau langsung tunjukkan ulang flow-nya]

> "Ketika aplikasi dijalankan pertama kali, pengguna akan disambut oleh **splash screen** dengan animasi gradient dan logo yang menggunakan `ScaleTransition` dan `FadeTransition`.
>
> [AKSI: tunggu splash, lalu masuk onboarding]
>
> Setelah itu, pengguna masuk ke **onboarding** sebanyak empat halaman yang dibangun dengan `PageView`. Setiap halaman menampilkan satu fitur utama: timeline skripsi, bimbingan, manajemen referensi, dan komunitas squad. Ada indikator dots di bawah yang otomatis berubah saat saya swipe."

[AKSI: swipe halaman onboarding dari kanan ke kiri, tunjukkan dots indicator berubah]

### 2.2 — Login Screen (30 detik)

> "Sekarang masuk ke **login screen**. Form sudah otomatis terisi data demo. Saya akan tunjukkan validasinya."

[AKSI: kosongkan field email, klik Masuk]

> "Lihat, validator langsung memunculkan pesan error 'Email wajib diisi'. Begitu juga jika format email salah atau password kurang dari 6 karakter."

[AKSI: isi kembali email, klik mata untuk toggle password visibility]

> "Ada juga toggle untuk lihat/sembunyikan password menggunakan `IconButton` di `suffixIcon`."

[AKSI: klik Masuk, tunggu loading]

> "Saat tombol Masuk diklik, muncul `CircularProgressIndicator` selama proses simulasi login."

### 2.3 — Dashboard / Beranda (45 detik)

[AKSI: Sampai di halaman dashboard]

> "Inilah **dashboard utama** aplikasi. Di sini ada beberapa komponen visual penting:
>
> - **Hero card biru** yang menampilkan target tanggal sidang dan progress bar keseluruhan
> - **Tiga stat card** kecil yang menunjukkan milestone, referensi, dan rata-rata mood
> - **Quick actions** dengan empat tombol untuk akses cepat
> - **Daftar milestone berikutnya** dan **wellness card**
>
> Semua card ini menggunakan `Card`, `Container` dengan `BoxDecoration` gradient, dan `Row` / `Column` untuk layout."

[AKSI: scroll ke bawah, lalu pull-to-refresh]

> "Saya juga menambahkan `RefreshIndicator` — saat saya tarik ke bawah, aplikasi melakukan refresh."

### 2.4 — Timeline & Add Milestone (1 menit)

[AKSI: Tap tab Timeline]

> "Mari ke tab **Timeline**. Di sini saya bisa melihat semua milestone skripsi saya. Ada progress bar untuk setiap BAB dari 1 sampai 5."

[AKSI: Klik salah satu chip filter, misalnya BAB 2]

> "Saya pakai `ChoiceChip` untuk filter — kalau saya pilih BAB 2, daftarnya akan terfilter otomatis."

[AKSI: Swipe satu milestone ke kiri, tapi batalkan]

> "Setiap milestone bisa di-swipe ke kiri untuk dihapus. Saya pakai widget `Dismissible` dan menambahkan `AlertDialog` konfirmasi sebelum benar-benar dihapus."

[AKSI: Tap tombol Tambah / FAB]

> "Sekarang saya klik tombol **Tambah** di kanan bawah untuk membuka form penambahan milestone."

[AKSI: Demo form Add Milestone]

> "Di form ini ada beberapa input berbeda:
> - `TextFormField` untuk judul dan deskripsi
> - `ChoiceChip` row untuk memilih BAB
> - `InkWell` yang membuka `showDatePicker` untuk tenggat
> - `SegmentedButton` untuk prioritas tinggi, sedang, atau rendah
>
> Semua field punya validator. Mari coba submit tanpa mengisi..."

[AKSI: Klik Simpan tanpa isi, tunjukkan error muncul]

> "Validator langsung muncul. Saya isi dengan benar..."

[AKSI: Isi semua field, pilih tanggal dari date picker, simpan]

> "Milestone berhasil ditambahkan, SnackBar muncul sebagai konfirmasi."

### 2.5 — Bimbingan & Schedule (1 menit)

[AKSI: Tap tab Bimbingan]

> "Berikutnya tab **Bimbingan**. Halaman ini punya `TabBar` dengan dua tab: 'Akan Datang' dan 'Riwayat'."

[AKSI: Klik tab Riwayat lalu balik ke Akan Datang]

> "Setiap kartu bimbingan menampilkan tanggal, waktu, dan agenda. Kalau saya tap..."

[AKSI: Tap satu bimbingan]

> "...muncul `showModalBottomSheet` dengan detail lengkap, termasuk text field untuk catatan bimbingan."

[AKSI: Tutup bottom sheet, klik FAB Jadwal Baru]

> "Untuk menjadwalkan bimbingan baru, saya klik FAB. Lihat — di sini saya bisa pilih tanggal dengan date picker, lalu pilih slot waktu yang tersedia dari dosen — slot-nya direpresentasikan sebagai chip yang bisa diklik. Durasi juga bisa dipilih: 15, 30, 45, atau 60 menit."

### 2.6 — Referensi (45 detik)

[AKSI: Tap tab Referensi]

> "Di tab **Referensi** ada fitur pencarian dengan `TextField`. Saya ketik 'consumer'..."

[AKSI: Ketik di search box]

> "Daftar langsung terfilter berdasarkan judul atau penulis."

[AKSI: Tap satu referensi]

> "Saat saya tap satu referensi, muncul `DraggableScrollableSheet` yang bisa ditarik naik atau turun. Di dalamnya ada ringkasan, sitasi APA yang bisa di-copy ke clipboard, dan tombol untuk membuka PDF."

[AKSI: Tutup sheet, klik FAB Unggah]

> "Untuk menambah referensi baru, ada form lengkap dengan area upload PDF yang menggunakan `GestureDetector` dan visual dashed border."

### 2.7 — Squad & Wellness (45 detik)

[AKSI: Tap tab Squad]

> "Tab **Squad** adalah fitur komunitas. Di sini saya bisa lihat anggota squad saya, status check-in mereka hari ini, dan activity feed."

[AKSI: Ketik di field daily check-in]

> "Ada form check-in harian — saya tulis target hari ini, klik check-in, dan kartunya berubah menggunakan `AnimatedSwitcher` yang animasinya smooth."

[AKSI: Kembali ke dashboard, klik wellness card]

> "Sekarang saya ke **Wellness Corner**. Di sini saya bisa pilih mood hari ini dengan emoji selector..."

[AKSI: Pilih emoji, klik Catat Mood]

> "Mood tersimpan. Saya bisa lihat grafik trennya..."

[AKSI: Klik icon chart di app bar]

> "...dalam bentuk `LineChart` dari package `fl_chart`. Ini menunjukkan tren mood 14 hari terakhir."

### 2.8 — SkripsiBot (30 detik)

[AKSI: Kembali ke dashboard, klik SkripsiBot di quick actions]

> "Terakhir, **SkripsiBot AI Assistant**. Ini adalah chat interface lengkap dengan quick prompts. Saya tap salah satu suggestion..."

[AKSI: Tap quick prompt]

> "...dan bot membalas dengan jawaban relevan. Pesan ditampilkan dengan bubble berbeda untuk user dan bot."

---

## 🎬 BAGIAN 3 — FLUTTER WIDGETS (≈ 3 menit)

[AKSI: Buka IDE / VS Code]

> "Sekarang mari kita lihat ke kode. Aplikasi ini total memiliki **25 file Dart dengan sekitar 6.400 baris kode**, terbagi dalam arsitektur **feature-first**.
>
> Saya akan jelaskan widget Flutter yang saya gunakan."

### 3.1 — Layout Widgets

[TUNJUKKAN KODE: `lib/features/dashboard/dashboard_screen.dart`, scroll ke method `build`]

> "Yang paling fundamental adalah **layout widgets**. Lihat di dashboard screen ini, struktur dasarnya adalah:
>
> - `Scaffold` sebagai container utama dengan AppBar, body, dan FAB
> - `SafeArea` agar konten tidak ketutup status bar
> - `ListView` untuk scrollable content
> - `Column` dan `Row` untuk arranging widget vertikal dan horizontal
> - `Expanded` untuk membagi ruang secara proporsional
> - `Padding` dan `Container` untuk spacing dan styling
>
> Untuk responsive layout, saya banyak pakai `Expanded` dan `SizedBox` untuk spacing yang konsisten."

### 3.2 — Material Widgets

[TUNJUKKAN KODE: `lib/features/timeline/timeline_screen.dart`]

> "Untuk widget Material Design, saya pakai banyak komponen:
>
> - `AppBar` dengan custom action button di kanan
> - `Card` dengan border radius dan border tipis sebagai container utama
> - `FloatingActionButton.extended` di kanan bawah
> - `ChoiceChip` untuk filter BAB
> - `LinearProgressIndicator` untuk progress bar per BAB
> - `Dismissible` untuk swipe-to-delete
> - `AlertDialog` untuk konfirmasi"

### 3.3 — Interactive & Animated Widgets

[TUNJUKKAN KODE: `lib/features/splash/splash_screen.dart`]

> "Di splash screen, saya pakai `AnimationController` yang dikombinasikan dengan `ScaleTransition` dan `FadeTransition`. Ada `Curves.elasticOut` agar logo terlihat 'bouncing' saat muncul.
>
> Untuk interaksi, saya pakai `InkWell` daripada `GestureDetector` karena `InkWell` memberikan ripple effect material design yang lebih native."

### 3.4 — Theme & Typography

[TUNJUKKAN KODE: `lib/core/theme/app_theme.dart`]

> "Untuk styling konsisten, saya pakai `ThemeData` dengan Material 3 enabled. Font default-nya Google Fonts **Plus Jakarta Sans**. Saya define color palette di `app_constants.dart` lengkap dengan 5 jenis gradient yang bisa dipakai ulang.
>
> Pendekatan ini mengikuti prinsip **Design Thinking** dari Sesi 2 — komponen yang konsisten dan reusable."

---

## 🎬 BAGIAN 4 — PAGE NAVIGATION (≈ 3 menit)

[TUNJUKKAN KODE: `lib/core/router/app_router.dart`]

### 4.1 — GoRouter (Primary Navigation)

> "Untuk navigasi utama, saya pakai **GoRouter** — sebuah declarative router yang sangat populer di Flutter modern.
>
> Lihat file `app_router.dart` ini. Saya define `GoRouter` dengan beberapa konsep penting:
>
> **Pertama**, `initialLocation: '/splash'` — aplikasi selalu mulai dari splash screen.
>
> **Kedua**, ada `redirect` function — ini fungsi guard yang dijalankan setiap kali rute berubah. Kalau user belum onboarding, dia akan dipaksa ke `/onboarding`. Kalau belum login, dia akan dipaksa ke `/login`. Ini pattern yang sangat clean.
>
> **Ketiga**, ada `ShellRoute` — ini fitur powerful dari GoRouter. ShellRoute membungkus halaman-halaman utama (home, timeline, bimbingan, references, squad) dengan satu shell yang berisi **bottom navigation bar**. Jadi bottom nav-nya tetap, hanya isinya yang berganti.
>
> **Keempat**, untuk berpindah halaman, saya pakai `context.go('/timeline')` untuk navigasi level utama, atau `context.push('/add-milestone')` untuk push halaman baru yang bisa di-pop kembali."

[TUNJUKKAN KODE: `lib/features/dashboard/dashboard_screen.dart`, cari `context.push` atau `context.go`]

> "Lihat di sini saat saya klik quick action 'Tambah Milestone', saya panggil `context.push('/add-milestone')`. Dan saat di add milestone screen saya panggil `context.pop()` untuk kembali."

### 4.2 — MaterialPageNavigator (Sub-Navigation)

[TUNJUKKAN KODE: `lib/features/profile/profile_screen.dart`, cari menu Edit Profil]

> "Selain GoRouter, saya juga mendemonstrasikan **MaterialPageNavigator** — yaitu cara klasik Flutter navigasi pakai `Navigator.push` dengan `MaterialPageRoute`.
>
> Saya gunakan ini di halaman Profile, untuk navigasi ke 'Edit Profil'. Lihat kodenya:
>
> ```dart
> Navigator.of(context).push(
>   MaterialPageRoute(
>     builder: (_) => const EditProfileScreen(),
>     fullscreenDialog: false,
>   ),
> );
> ```
>
> **Perbedaan utama** antara GoRouter dan MaterialPageRoute:
>
> - **GoRouter** menggunakan URL-based routing, cocok untuk deep linking dan navigasi level tinggi. Routes-nya didefinisikan terpusat di satu tempat.
> - **MaterialPageNavigator** lebih imperative dan cocok untuk one-off navigation seperti membuka editor, viewer, atau modal full-screen yang tidak perlu URL.
>
> Pendekatan **hybrid** ini adalah best practice di banyak aplikasi production."

[AKSI: kembali ke emulator, demo Profile → Edit Profil]

> "Mari demo. Saya buka tab Profile, scroll ke menu Edit Profil, klik... dan halaman terbuka dengan animasi slide khas iOS/Android. Tombol back juga otomatis muncul karena di-push dengan Navigator standar."

### 4.3 — Navigator API Lain

[Sambil masih di profile/dashboard]

> "Beberapa navigasi lain yang saya pakai dengan Navigator API:
>
> - `showModalBottomSheet` untuk detail milestone, referensi, dan bimbingan
> - `showDialog` untuk konfirmasi logout dan delete
> - `showDatePicker` untuk pilih tanggal
> - `showAboutDialog` untuk halaman About
>
> Semua ini di belakang layar menggunakan `Navigator` Flutter — sehingga back gesture tetap berfungsi."

---

## 🎬 BAGIAN 5 — FLUTTER FORM (≈ 2 menit)

[TUNJUKKAN KODE: `lib/features/auth/login_screen.dart`]

### 5.1 — Anatomi Form

> "Sekarang ke materi terakhir: **Flutter Form**. Saya akan ambil contoh dari login screen.
>
> Setiap form di aplikasi ini saya bangun dengan tiga komponen kunci:
>
> **Pertama**, `Form` widget dengan `GlobalKey<FormState>` — key ini memungkinkan saya memanggil `validate()` dari luar.
>
> **Kedua**, `TextFormField` — versi form-aware dari `TextField`. Yang membedakan dari TextField biasa adalah dia bisa punya `validator` yang dipanggil otomatis saat `validate()` di-trigger.
>
> **Ketiga**, `TextEditingController` untuk membaca dan mengontrol nilai field-nya. Penting: controller harus di-`dispose` di method `dispose()` agar tidak memory leak."

### 5.2 — Validator Logic

[TUNJUKKAN KODE: `lib/features/auth/login_screen.dart`, cari validator]

> "Lihat validator di field password ini:
>
> ```dart
> validator: (v) {
>   if (v == null || v.isEmpty) return 'Password wajib diisi';
>   if (v.length < 6) return 'Password minimal 6 karakter';
>   return null;
> }
> ```
>
> Konvensinya: kembalikan `null` jika valid, atau pesan error jika tidak. Saat `_formKey.currentState!.validate()` dipanggil, semua field divalidasi dan UI otomatis menampilkan error."

### 5.3 — Form Lebih Kompleks: Multi-Step Register

[TUNJUKKAN KODE: `lib/features/auth/register_screen.dart`]

> "Untuk form yang lebih kompleks, saya buat **multi-step form** di register screen. Ada dua langkah:
>
> - **Langkah 1**: nama, email, password, konfirmasi password
> - **Langkah 2**: NIM, program studi (`DropdownButtonFormField`), semester (`Slider`), target sidang (`showDatePicker`), dan checkbox setuju S&K
>
> Kalau langkah 1 tidak valid, user tidak bisa lanjut ke langkah 2. Saya pakai `_currentStep` state untuk kontrol step indicator di atas."

### 5.4 — Form dengan Custom Input

[TUNJUKKAN KODE: `lib/features/timeline/add_milestone_screen.dart`]

> "Di form Add Milestone, saya gabungkan beberapa jenis input non-standar:
>
> - `ChoiceChip` untuk pilih BAB — bukan dropdown, lebih cepat tap
> - `InkWell` yang membuka `showDatePicker` — agar feel-nya native
> - `SegmentedButton` untuk prioritas — modern dan compact
>
> Semua ini di-state-management secara lokal di `StatefulWidget` dengan `setState`, lalu saat tombol Simpan diklik, data dikirim ke `AppState` global via Provider."

[AKSI: kembali ke emulator, demo form Add Milestone end-to-end]

> "Mari saya tunjukkan sekali lagi flow form-nya di aplikasi. Saya klik Tambah Milestone... isi judul, pilih BAB 2, tulis deskripsi, pilih tanggal dari date picker... dan klik Simpan. SnackBar muncul, halaman tertutup, dan milestone baru langsung muncul di list."

---

## 🎬 BAGIAN 6 — PENUTUP (≈ 30 detik)

[AKSI: Kembali ke dashboard, slow zoom ke aplikasi]

> "Itulah demonstrasi **SkripsiKita** — aplikasi mobile Flutter saya untuk tugas Sesi 6.
>
> Sebagai ringkasan, aplikasi ini sudah menggunakan:
> - **Lebih dari 30 jenis Flutter widget** dari layout, material, form, dan animation
> - **GoRouter** untuk routing utama dengan auth guard dan ShellRoute
> - **MaterialPageRoute** untuk sub-navigation
> - **5 form** dengan validation lengkap dan berbagai jenis input
>
> Semua kode bisa dilihat di folder proyek, dan APK debug sudah saya build dan siap diinstall.
>
> Terima kasih sudah menonton. Sampai jumpa di tugas berikutnya!"

[AKSI: Stop recording]

---

# 🎯 TIPS PRAKTIS RECORDING

## ✅ Do's
1. **Latihan 1–2 kali dulu** sebelum recording sungguhan
2. **Bicara perlahan dan jelas** — lebih baik 12 menit santai daripada 8 menit terburu-buru
3. **Tunjuk dengan kursor** saat menjelaskan elemen UI tertentu
4. **Sebut nama widget/file** secara eksplisit ketika menjelaskan kode
5. **Zoom in di kode** (Cmd+= di VS Code) agar audience bisa baca
6. **Tutup notifikasi laptop** saat recording (mode "Do Not Disturb")

## ❌ Don'ts
1. ❌ Jangan baca narasi kata-per-kata seperti robot — sesuaikan dengan gaya bicaramu
2. ❌ Jangan terlalu lama menjelaskan satu bagian — kalau berlebihan, audiens bosan
3. ❌ Jangan lupa screen capture audio + microphone — cek setting OBS dulu
4. ❌ Jangan demo fitur yang belum dipersiapkan — bisa nge-crash

## 🎬 Urutan Aksi yang Direkomendasikan

| Step | Aksi |
|------|------|
| 1 | Buka emulator/HP, kosongkan data app (uninstall lalu install ulang APK) |
| 2 | Buka VS Code dengan project sudah loaded |
| 3 | Buka OBS, set scene: split-screen IDE + emulator |
| 4 | Start recording |
| 5 | Baca narasi Bagian 1 (Intro) |
| 6 | Jalankan aplikasi dari awal, demo seperti narasi Bagian 2 |
| 7 | Switch ke IDE, explain widget (Bagian 3) |
| 8 | Switch antara IDE & emulator untuk Bagian 4 (Navigation) |
| 9 | Switch antara IDE & emulator untuk Bagian 5 (Form) |
| 10 | Penutup |

---

# 📌 LAMPIRAN: Cheat Sheet Konsep Penting

## Widget yang HARUS Disebut di Video
- `Scaffold`, `AppBar`, `SafeArea`
- `Column`, `Row`, `Stack`, `Expanded`, `Padding`, `Container`
- `Card`, `ListView`, `SingleChildScrollView`
- `TextFormField`, `Form`, `GlobalKey<FormState>`
- `TextEditingController`
- `ElevatedButton`, `OutlinedButton`, `TextButton`, `FloatingActionButton`
- `Chip`, `ChoiceChip`, `SegmentedButton`
- `LinearProgressIndicator`, `CircularProgressIndicator`
- `ChoiceChip`, `Slider`, `Checkbox`
- `showDatePicker`, `showModalBottomSheet`, `showDialog`
- `Dismissible`, `RefreshIndicator`
- `AnimatedContainer`, `AnimatedSwitcher`, `FadeTransition`

## Konsep Navigasi yang HARUS Disebut
- **GoRouter**: declarative routing, URL-based
- `GoRoute`, `ShellRoute`, `initialLocation`, `redirect`
- `context.go('/path')` vs `context.push('/path')` vs `context.pop()`
- **MaterialPageNavigator**: `Navigator.of(context).push(MaterialPageRoute(builder: ...))`
- Perbedaan kapan pakai yang mana

## Konsep Form yang HARUS Disebut
- `GlobalKey<FormState>` dan `formKey.currentState!.validate()`
- `TextFormField` vs `TextField`
- `validator` function — return `null` if OK, string if error
- `TextEditingController` — disposal di `dispose()`
- `onSubmitted` vs button onPressed
- Form serialization: read value dari controller saat submit

---

**Selamat recording! 🎬 Semoga lancar dan dapat nilai bagus.**
