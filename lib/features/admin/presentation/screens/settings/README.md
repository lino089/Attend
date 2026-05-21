# Admin Settings Screen

Halaman Pengaturan untuk Admin dengan UI/UX yang lengkap dan siap dipasangkan dengan database.

## 📁 File Structure

```
attend/lib/features/admin/presentation/screens/settings/
├── admin_settings_screen.dart       # Main settings screen
├── admin_settings_example.dart      # Example usage
└── README.md                        # Documentation
```

## 🎨 Features

### 1. **Profile Header Card**
- Menampilkan nama sekolah (dari database)
- Menampilkan role user (dari database)
- Gradient background dengan shadow
- Responsive design

### 2. **Section: PREFERENSI**
- **Tema Aplikasi**: Toggle switch untuk dark mode
- **Notifikasi**: Status notifikasi dengan navigasi
- **Bahasa**: Pilihan bahasa dengan navigasi

### 3. **Section: TENTANG & BANTUAN**
- **Panduan**: Navigasi ke halaman panduan
- **FAQ**: Navigasi ke halaman FAQ
- **Hubungi Kami**: Navigasi ke halaman kontak

### 4. **Section: AKUN**
- **Keluar**: Logout dengan confirmation dialog

## 🚀 Usage

### Basic Usage (Hardcoded)

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AdminSettingsScreen(
      schoolName: 'SMKN 1 BANTUL',
      role: 'Administrator',
    ),
  ),
);
```

### With Database

```dart
// Fetch data dari database
final schoolData = await DatabaseService.getSchoolInfo();
final userData = await DatabaseService.getCurrentUser();

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AdminSettingsScreen(
      schoolName: schoolData.name,
      role: userData.role,
    ),
  ),
);
```

### With Provider/State Management

```dart
// Menggunakan Provider
final schoolName = context.read<SchoolProvider>().schoolName;
final userRole = context.read<AuthProvider>().userRole;

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AdminSettingsScreen(
      schoolName: schoolName,
      role: userRole,
    ),
  ),
);
```

## 📝 Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `schoolName` | `String` | ✅ Yes | - | Nama sekolah dari database |
| `role` | `String` | ❌ No | `'Administrator'` | Role user (e.g., Administrator, Super Admin) |

## 🎯 TODO: Integration Points

Berikut adalah bagian-bagian yang perlu diintegrasikan dengan backend/database:

### 1. **Fetch School Name & User Role**
```dart
// Location: Saat membuka settings screen
// TODO: Implement database query
final schoolName = await DatabaseService.getSchoolName();
final userRole = await DatabaseService.getCurrentUserRole();
```

### 2. **Dark Mode Toggle**
```dart
// Location: _buildMenuItemWithToggle - onChanged callback
// TODO: Save to database/shared preferences
await PreferencesService.setDarkMode(value);
```

### 3. **Notification Settings**
```dart
// Location: Notifikasi menu item - onTap callback
// TODO: Navigate to notification settings screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationSettingsScreen(),
  ),
);
```

### 4. **Language Settings**
```dart
// Location: Bahasa menu item - onTap callback
// TODO: Navigate to language selection screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => LanguageSelectionScreen(),
  ),
);
```

### 5. **Panduan**
```dart
// Location: Panduan menu item - onTap callback
// TODO: Navigate to guide/tutorial screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GuideScreen(),
  ),
);
```

### 6. **FAQ**
```dart
// Location: FAQ menu item - onTap callback
// TODO: Navigate to FAQ screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FAQScreen(),
  ),
);
```

### 7. **Hubungi Kami**
```dart
// Location: Hubungi Kami menu item - onTap callback
// TODO: Navigate to contact us screen or open email/phone
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ContactUsScreen(),
  ),
);
```

### 8. **Logout**
```dart
// Location: _showLogoutDialog - Keluar button onPressed
// TODO: Implement logout logic
await AuthService.logout();
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => LoginScreen()),
  (route) => false,
);
```

## 🎨 Design Specifications

### Colors
- Primary Blue: `#4461F2` (AppColors.primaryBlue)
- Background: `#F7F8FA`
- Card Background: `#FFFFFF`
- Icon Background: `#E2E6FF`
- Logout Red: `#E02424`
- Logout Background: `#FDE8E8`

### Typography
- Section Headers: 11px, bold, uppercase, grey
- Menu Labels: 15px, medium weight
- School Name: 22px, bold, white
- Role: 14px, medium, white (90% opacity)

### Spacing
- Horizontal Margin: 20px
- Vertical Spacing: 12-32px
- Card Padding: 16px
- Icon Size: 22px
- Icon Container: 40px

### Border Radius
- Cards: 16px
- Header Card: 20px
- Icon Container: 12px
- Dialog: 24px

## 🔧 Customization

### Mengubah Gradient Header

```dart
// Di admin_settings_screen.dart, line ~50
gradient: const LinearGradient(
  colors: [
    Color(0xFF4461F2),  // Ubah warna ini
    Color(0xFF5B75F5),  // Ubah warna ini
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
),
```

### Menambah Menu Item Baru

```dart
// Tambahkan di section yang sesuai
_buildMenuItem(
  icon: Icons.your_icon,
  label: 'Menu Baru',
  onTap: () {
    // TODO: Implement action
  },
),
```

### Menambah Section Baru

```dart
// Tambahkan setelah section terakhir
_buildSectionHeader('SECTION BARU'),
const SizedBox(height: 12),

_buildMenuItem(
  icon: Icons.your_icon,
  label: 'Menu Item',
  onTap: () {
    // TODO: Implement action
  },
),
```

## 📱 Screenshots Reference

Desain mengikuti mockup yang diberikan dengan:
- ✅ Profile header dengan gradient biru
- ✅ Section headers dengan uppercase grey text
- ✅ Menu items dengan icon, label, dan action
- ✅ Toggle switch untuk tema aplikasi
- ✅ Status text untuk notifikasi dan bahasa
- ✅ Logout dengan warna merah
- ✅ Confirmation dialog untuk logout

## ⚠️ Notes

1. **Database Integration**: Screen ini sudah siap untuk dipasangkan dengan database. Parameter `schoolName` dan `role` dapat diambil dari database.

2. **Navigation**: Semua menu items memiliki `onTap` callback dengan TODO comments untuk implementasi navigasi.

3. **State Management**: Saat ini menggunakan `setState` untuk demo. Untuk production, disarankan menggunakan Provider/Bloc/Riverpod.

4. **Print Statements**: Print statements digunakan untuk debugging. Hapus atau ganti dengan proper logging di production.

5. **Logout Dialog**: Dialog konfirmasi logout sudah diimplementasikan. Tinggal tambahkan logic logout yang sebenarnya.

## 🔄 Next Steps

1. ✅ UI/UX Implementation - **DONE**
2. ⏳ Database Integration - **TODO**
3. ⏳ Navigation Implementation - **TODO**
4. ⏳ State Management - **TODO**
5. ⏳ API Integration - **TODO**
6. ⏳ Testing - **TODO**

## 📞 Support

Jika ada pertanyaan atau butuh modifikasi, silakan hubungi developer team.
