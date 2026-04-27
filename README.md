# Attend - Multi-Tenant School Management Prototype

Attend adalah aplikasi prototipe berbasis Flutter yang dirancang untuk manajemen presensi, penjadwalan, dan sistem ujian (CBT) skala multi-sekolah (Multi-Tenant SaaS). Aplikasi ini memiliki arsitektur multi-peran yang memfasilitasi interaksi spesifik untuk Admin Sekolah, Guru, dan Siswa.

Saat ini, proyek berada dalam fase purwarupa visual (UI) dan refaktorisasi arsitektur awal, di mana aliran data masih menggunakan data statis (mocking) dan belum terhubung ke antarmuka pemrograman aplikasi (API) nyata.

## ✨ Fitur Saat Ini

- **Sistem Multi-Peran (Multi-Role):** Akses antarmuka yang terpisah antara Admin, Guru, dan Siswa dimulai dari layar *Role Selection*.
- **Portal Autentikasi (UI):** Layar login khusus untuk Guru (berbasis NIK), Siswa (berbasis NISN), dan Admin/Sekolah (berbasis NPSN), dilengkapi integrasi visual tombol Google Sign-In.
- **Dasbor Siswa Dinamis (Mock):** Menampilkan jadwal kelas interaktif yang berubah status secara otomatis berdasarkan komputasi waktu lokal (jam sistem).
- **Dasbor Guru & Admin (UI):** Kerangka dasbor navigasi untuk mengelola sistem kelas dan jadwal.

## 🛠 Tumpukan Teknologi (Tech Stack)

Berdasarkan konfigurasi `pubspec.yaml` saat ini:
- **Framework:** Flutter (SDK `^3.10.8`)
- **Bahasa Pemrograman:** Dart
- **Manajemen State (State Management):** `flutter_riverpod: ^3.3.1` (Telah diinisialisasi pada tingkat atas, belum diimplementasikan pada level komponen) & `setState` bawaan Flutter.
- **Platform/Backend:** `firebase_core: ^4.5.0` (Dependensi inti terinstal, fungsionalitas turunan belum aktif).
- **Format Data:** `intl: ^0.20.2` (Penyusunan format tanggal/waktu).

## 📂 Struktur Proyek

Proyek ini telah direfaktor menggunakan **Feature-First Architecture** untuk menjamin skalabilitas yang tinggi. Berikut adalah direktori krusial di dalam folder `lib/`:

```text
lib/
├── core/
│   └── theme/
│       └── app_colors.dart        # Single Source of Truth untuk palet warna aplikasi
├── features/
│   ├── admin/                     # Modul Admin Sekolah (Dasbor, Pengaturan)
│   ├── auth/                      # Modul Autentikasi (Role Selection, Layar Login, Registrasi)
│   ├── student/                   # Modul Siswa (Dasbor Siswa, Jadwal)
│   └── teacher/                   # Modul Guru (Dasbor Guru, Manajemen Kelas)
├── shared/
│   └── widgets/                   # Komponen UI Reusable (CustomInputField, TopMenuCard, dll)
├── firebase_options.dart          # File konfigurasi Firebase otomatis
└── main.dart                      # Titik masuk (Entry point) aplikasi
```

## 🏗 Arsitektur & Desain Sistem

- **Pola Arsitektur:** Aplikasi mengadopsi pendekatan **Feature-First** di mana setiap modul (auth, admin, teacher, student) diisolasi dengan direktori `presentation/screens` mereka sendiri. Struktur ini disiapkan untuk penerapan Clean Architecture pada fase selanjutnya.
- **Manajemen State Global:** Akar aplikasi telah dibungkus dengan `ProviderScope`, menyiapkan basis lingkungan untuk `Riverpod`.
- **Alur Data Saat Ini:** 
  `Interaksi UI` → `Future.delayed (Simulasi Jaringan)` → `State Lokal (setState)` → `Rebuild Antarmuka`.
  *(Belum ada konektivitas repository, domain logic, maupun panggilan database murni).*

## 🚀 Instalasi & Pengaturan

Ikuti langkah-langkah di bawah ini untuk menjalankan proyek secara lokal:

1. Kloning repositori ini (atau buka folder di editor kode Anda).
2. Pastikan Anda telah menginstal Flutter SDK terbaru.
3. Unduh semua dependensi:
   ```bash
   flutter pub get
   ```
4. Bersihkan modul yang tidak terpaut (opsional):
   ```bash
   flutter clean
   ```
5. Jalankan aplikasi pada perangkat atau emulator:
   ```bash
   flutter run
   ```

## 📱 Penggunaan

1. **Layar Pilihan:** Saat aplikasi terbuka, Anda akan dihadapkan dengan 3 opsi: Sekolah, Siswa, Guru.
2. **Login Siswa:** 
   - Pilih "Siswa".
   - Masukkan NISN apa saja (karena belum divalidasi API) dan klik Login.
   - Aplikasi akan melakukan *loading delay* 2 detik lalu masuk ke `StudentDashboardScreen`.
   - Dasbor ini membaca jam lokal komputer/ponsel untuk menampilkan status jam pelajaran yang "sedang berlangsung".

## ⚙️ Konfigurasi Tambahan

- **Firebase:** Kode konfigurasi `firebase_options.dart` dan paket `firebase_core` sudah tertaut, namun fungsi seperti login multi-peran dan sinkronisasi presensi membutuhkan konfigurasi lanjut di panel *Firebase Console* dan pemasangan paket `firebase_auth` serta `cloud_firestore`.

## ⚠️ Masalah / Keterbatasan yang Diketahui

1. **Self-Import pada Widget Reusable:** File seperti `schedule_item.dart`, `top_menu_card.dart`, dan `ongoing_detail_row.dart` secara keliru mengimpor *file*-nya sendiri di baris teratas (contoh: `import 'package:attend/shared/widgets/schedule_item.dart';`). Ini menimbulkan *warning* linter minor namun tidak menghentikan kompilasi.
2. **Dummy Data:** Semua jadwal kelas, profil pengguna, dan *academic status* bersifat keras di dalam kode (hardcoded).
3. **Lompatan Logika:** Verifikasi *form* di layar login berjalan secara lokal. Jika input tidak kosong, pengguna diotorisasi masuk secara instan tanpa validasi backend.

## 🔮 Peningkatan di Masa Depan

Berdasarkan basis kode saat ini, langkah teknis selanjutnya yang sangat disarankan:
1. **Setup Konektivitas Database:** Instalasi `cloud_firestore` untuk manajemen *multi-tenant* dan `firebase_auth` untuk manajemen peran.
2. **Implementasi Riverpod Sepenuhnya:** Menggeser status lokal dan data tiruan ke *Providers* (`FutureProvider` / `StreamProvider`).
3. **Lapisan Domain & Repositori (Data Layer):** Memisahkan logika jadwal dan autentikasi dari *file UI* untuk mematuhi prinsip tanggung jawab tunggal (SOLID).
4. **Pembersihan Linter:** Menangani *warning* dari `dart analyze` terkait duplikasi impor dan API widget yang kedaluwarsa.
