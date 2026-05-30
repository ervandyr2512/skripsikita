# SkripsiKita — MVVM Implementation

**Pendamping Cerdas Perjalanan Skripsi Mahasiswa Indonesia**

> "Skripsimu, perjalanan kita."

Aplikasi mobile Flutter yang dibangun mengikuti **arsitektur MVVM (Model–View–ViewModel)** untuk mendemonstrasikan separation of concerns yang bersih antara UI, business logic, dan data management.

Tugas ini adalah AFL 2 dari mata kuliah **Mobile Application Development (IMT01303401)** — IMT UC Online, melanjutkan konsep yang sudah dirancang di AFL 1 (Mobile App Concept Proposal).

---

## 📚 Overview Arsitektur MVVM

**MVVM** adalah pola arsitektur yang memisahkan aplikasi menjadi tiga lapisan utama, masing-masing dengan tanggung jawab yang jelas:

### 1. **Model** — Data & Business Rules

Model merepresentasikan **data dan aturan bisnis murni**. Tidak tahu tentang UI dan tidak bergantung pada Flutter widgets.

Dalam SkripsiKita, kami memiliki tujuh entity classes:

| Model | Lokasi | Deskripsi |
|---|---|---|
| `UserProfile` | `lib/models/user_profile.dart` | Profil mahasiswa (nama, NIM, prodi, target sidang) |
| `Milestone` | `lib/models/milestone.dart` | Satu target/tugas skripsi |
| `Consultation` | `lib/models/consultation.dart` | Sesi bimbingan dengan dosen |
| `ReferenceItem` | `lib/models/reference_item.dart` | Referensi jurnal/buku |
| `Squad`, `SquadMember` | `lib/models/squad.dart` | Kelompok mahasiswa |
| `MoodLog` | `lib/models/mood_log.dart` | Catatan mood harian |
| `ChatMessage` | `lib/models/chat_message.dart` | Pesan chat SkripsiBot |

Setiap model dapat berisi computed properties (contoh: `Milestone.statusColor`, `MoodLog.score`) yang merupakan business rule murni.

### 2. **Repository** — Data Source Abstraction

Repository adalah lapisan abstraksi antara ViewModel dan sumber data. Dia bertanggung jawab atas **operasi CRUD (Create, Read, Update, Delete)**. Implementasi saat ini menggunakan in-memory + SharedPreferences, namun bisa di-swap ke API backend nanti **tanpa mengubah ViewModel**.

| Repository | CRUD Operations |
|---|---|
| `AuthRepository` | login, register, logout, restoreSession, updateProfile |
| `MilestoneRepository` | getAll, getByChapter, getUpcoming, add, update, updateStatus, delete |
| `ConsultationRepository` | getAll, getUpcoming, getPast, add, completeWithNotes, delete |
| `ReferenceRepository` | getAll, search (query+tag), getAllTags, add, toggleStar, update, delete |
| `SquadRepository` | getCurrentSquad, getCheckedInCount, joinSquad, addMember, removeMember |
| `WellnessRepository` | getAll, getLast, getAverageScore, logMood, deleteLog, getWellnessContent |
| `ChatRepository` | getAll, addUserMessage, addBotMessage, generateReply, clearAll |

### 3. **ViewModel** — UI State & Logic

ViewModel **extends `ChangeNotifier`** dan:
- Menerima Repository melalui constructor injection
- Mengexpose state ke View (data yang siap ditampilkan)
- Menyediakan method untuk aksi user (yang memanggil Repository)
- Memanggil `notifyListeners()` saat state berubah agar View otomatis rebuild

| ViewModel | Tanggung Jawab |
|---|---|
| `AuthViewModel` | Login/register/logout state, profil user, onboarding flag |
| `TimelineViewModel` | Milestone list, filter, progress per BAB, CRUD milestone |
| `ConsultationViewModel` | Daftar bimbingan (upcoming/past), CRUD consultation |
| `ReferenceViewModel` | Referensi + search query + filter tag, CRUD reference |
| `SquadViewModel` | Data squad, daily check-in, member management |
| `WellnessViewModel` | Mood selection + logging + history, wellness content |
| `SkripsiBotViewModel` | Chat messages, typing state, send/receive simulation |

### 4. **View** — UI Pure

View hanya **menampilkan UI dan mengirim event ke ViewModel**. Tidak ada business logic di View. View membaca state dari ViewModel menggunakan widget `Consumer` atau `context.watch<ViewModel>()` dari package `provider`.

Contoh:
```dart
// View membaca state dari ViewModel
final vm = context.watch<TimelineViewModel>();

// View mengirim event ke ViewModel
context.read<TimelineViewModel>().addMilestone(milestone);

// View menggunakan Consumer untuk rebuild partial
Consumer<TimelineViewModel>(
  builder: (_, vm, __) => Text('${vm.doneCount}/${vm.totalCount}'),
)
```

---

## 🏗️ Struktur Folder

```
lib/
├── main.dart                          ← Entry + MultiProvider setup
├── core/
│   ├── constants/app_constants.dart   ← Colors, strings, spacing
│   ├── theme/app_theme.dart           ← Material 3 theme
│   └── router/app_router.dart         ← GoRouter dengan auth guards
├── models/                            ← MODEL LAYER
│   ├── user_profile.dart
│   ├── milestone.dart
│   ├── consultation.dart
│   ├── reference_item.dart
│   ├── squad.dart
│   ├── mood_log.dart
│   ├── chat_message.dart
│   └── models.dart                    ← Barrel export
├── repositories/                      ← REPOSITORY LAYER (CRUD)
│   ├── auth_repository.dart
│   ├── milestone_repository.dart
│   ├── consultation_repository.dart
│   ├── reference_repository.dart
│   ├── squad_repository.dart
│   ├── wellness_repository.dart
│   └── chat_repository.dart
├── viewmodels/                        ← VIEWMODEL LAYER
│   ├── auth_viewmodel.dart
│   ├── timeline_viewmodel.dart
│   ├── consultation_viewmodel.dart
│   ├── reference_viewmodel.dart
│   ├── squad_viewmodel.dart
│   ├── wellness_viewmodel.dart
│   ├── skripsibot_viewmodel.dart
│   └── viewmodels.dart                ← Barrel export
├── features/                          ← VIEW LAYER (organized by feature)
│   ├── splash/
│   ├── onboarding/
│   ├── auth/                          ← login, register
│   ├── main_shell/                    ← bottom navigation
│   ├── dashboard/
│   ├── timeline/                      ← list + add milestone
│   ├── bimbingan/                     ← list + schedule
│   ├── references/                    ← list + add
│   ├── squad/
│   ├── wellness/                      ← mood + history
│   ├── skripsibot/                    ← AI chat
│   └── profile/                       ← profile + edit
├── shared/
│   └── widgets/                       ← Reusable widgets
└── data/
    └── mock_data.dart                 ← Seed data
```

---

## 🔄 Aliran Data (Data Flow)

```
┌─────────────┐   user action    ┌──────────────┐   call         ┌──────────────┐
│    View     │ ───────────────► │  ViewModel   │ ─────────────► │  Repository  │
│             │                  │              │                │              │
│ (Consumer / │ ◄──────────────  │ (Change-     │ ◄────────────  │   (CRUD)     │
│  watch VM)  │  notifyListeners │  Notifier)   │  data returned │              │
└─────────────┘                  └──────────────┘                └──────┬───────┘
                                                                        │
                                                                        ▼
                                                                 ┌──────────────┐
                                                                 │    Model     │
                                                                 │  (Data + BR) │
                                                                 └──────────────┘
```

**Contoh konkret: User menambah milestone**
1. **View** (AddMilestoneScreen): user submit form → `context.read<TimelineViewModel>().addMilestone(m)`
2. **ViewModel** (TimelineViewModel): menerima call, panggil `_repository.add(m)`, lalu `notifyListeners()`
3. **Repository** (MilestoneRepository): simpan ke in-memory list, lalu sort by due date
4. **Model** (Milestone): instance baru ditambahkan ke list
5. **View** (TimelineScreen): otomatis rebuild karena watch ViewModel → tampilkan milestone baru

---

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat

- Flutter SDK 3.5.0 atau lebih baru
- Dart SDK 3.5+
- Android Studio dengan Android Emulator, atau Xcode dengan iOS Simulator
- Untuk iOS: macOS + CocoaPods (`brew install cocoapods`)

### Langkah-langkah

```bash
# 1. Clone repository
git clone git@github.com:ervandyr2512/skripsikita.git
cd skripsikita

# 2. Install dependencies
flutter pub get

# 3. Pastikan ada emulator/simulator yang berjalan
flutter devices

# 4. Run aplikasi
flutter run

# 5. (Opsional) Build APK
flutter build apk --debug
```

### Akun Demo

Form login sudah otomatis terisi data demo:

- **Email:** `rina.pratiwi@student.uc.ac.id`
- **Password:** `password123`

Atau gunakan halaman **Daftar Akun** untuk membuat persona kamu sendiri (data tetap di in-memory).

---

## ✨ Fitur Aplikasi

| # | Fitur | Deskripsi |
|---|---|---|
| 1 | **Smart Timeline & Milestone Tracker** | Pecah skripsi menjadi milestone kecil, visualisasi progres per BAB |
| 2 | **Bimbingan Hub** | Pesan slot bimbingan, tulis agenda, catat hasil |
| 3 | **Reference Vault** | Simpan jurnal PDF, beri tag, generate sitasi APA |
| 4 | **Squad (Komunitas Sebaya)** | Bergabung dengan kelompok mahasiswa, check-in harian |
| 5 | **Wellness Corner & Mood Check** | Logging mood harian, grafik tren, konten wellness |
| 6 | **SkripsiBot AI Assistant** | Chatbot untuk diskusi struktur BAB & metodologi (mock AI) |

---

## 📦 Dependencies

| Package | Versi | Fungsi |
|---|---|---|
| `provider` | ^6.1.2 | State management (ChangeNotifierProvider untuk ViewModel) |
| `go_router` | ^14.6.2 | Declarative routing dengan auth guards |
| `shared_preferences` | ^2.3.3 | Persisten lokal untuk auth & onboarding flag |
| `fl_chart` | ^0.69.2 | Grafik mood history |
| `intl` | ^0.20.0 | Formatting tanggal Bahasa Indonesia |
| `google_fonts` | ^6.2.1 | Typography (Plus Jakarta Sans) |
| `flutter_localizations` | sdk | Lokalisasi widget Material |
| `uuid` | ^4.5.1 | Generate unique ID untuk entity baru |

---

## 🧪 Verifikasi Build

```bash
flutter analyze        # → 0 error, 0 warning
flutter test           # → smoke test passes
flutter build apk      # → app-debug.apk berhasil dibangun
```

---

## 💭 Refleksi (150 kata)

Menerapkan pola MVVM di Flutter mengajarkan saya bahwa **separation of concerns bukan sekadar teori akademik**, melainkan kebutuhan praktis ketika aplikasi mulai tumbuh kompleks. Pada iterasi sebelumnya, saya sempat menggunakan satu `ChangeNotifier` raksasa yang menampung semua state — hasilnya kode sulit dirawat dan view-nya terlalu tahu banyak tentang implementasi data.

Tantangan terbesar adalah **mendesain batas yang jelas antar lapisan**, terutama memutuskan apa yang menjadi tanggung jawab ViewModel versus Repository. Saya menetapkan aturan sederhana: Repository hanya untuk CRUD murni, ViewModel untuk state UI + komposisi logic, View untuk tampilan saja. Hasilnya luar biasa: ketika saya menambah fitur "Edit Profil", saya tidak perlu menyentuh satu pun View lain — cukup menambah method di AuthRepository + AuthViewModel.

Pelajaran terpenting: **MVVM membuat kode lebih testable**. Setiap ViewModel kini bisa diuji dengan mock Repository, tanpa perlu widget tree. Ini fondasi yang krusial untuk maintenance jangka panjang.

---

## 📄 Lisensi & Kredit

Dibangun sebagai assignment **AFL 2 — MVVM Implementation** untuk mata kuliah **Mobile Application Development (IMT01303401)** di IMT UC Online.

Konsep awal dari **AFL 1 — Mobile App Concept Proposal**.

Dibuat dengan ❤️ menggunakan Flutter oleh **Ervandy Rangganata**.
