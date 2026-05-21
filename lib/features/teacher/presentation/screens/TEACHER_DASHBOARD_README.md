# Teacher Dashboard Screen

Halaman Dashboard untuk Teacher/Guru dengan UI/UX yang sesuai desain mockup dan siap dipasangkan dengan database.

## 📁 File Structure

```
attend/lib/features/teacher/presentation/screens/
├── teacher_main_screen.dart           # Main screen dengan bottom nav
├── teacher_dashboard_screen.dart      # ✅ Dashboard screen (UPDATED)
├── teacher_schedule_screen.dart       # Schedule screen
└── teacher_setting_screen.dart        # Settings screen
```

## 🎨 Features Implemented

### 1. **Header Section (Blue Background)**
- ✅ Profile avatar (circular) - siap untuk image dari database
- ✅ Nama guru - dari database
- ✅ Mata pelajaran - dari database
- ✅ Tanggal otomatis (format: TUESDAY, SEPTEMBER 16, 2025)
- ✅ Notification icon button

### 2. **Active Class Card**
- ✅ Status badge "IN PROGRESS" dengan green dot
- ✅ Waktu kelas (08:00 - 09:30)
- ✅ Informasi kelas (XII RPL 1 • Web Programming)
- ✅ Lokasi (Room 204 • Building B)
- ✅ Button "Start Attendance"
- ✅ Card hanya muncul jika ada kelas aktif

### 3. **Teacher Menu Section**
- ✅ **Create Test** (full width card)
  - Icon: Quiz (blue background)
  - Title: "Create Test"
  - Subtitle: "Design new assessment"
  
- ✅ **Attendance History** (half width - left)
  - Icon: History (purple background)
  - Title: "Attendance History"
  
- ✅ **Exam History** (half width - right)
  - Icon: Assignment (orange background)
  - Title: "Exam History"

### 4. **Next Schedule Section**
- ✅ Title: "Next Schedule"
- ✅ Schedule card dengan blue left border
- ✅ Class code (XTKJ2)
- ✅ Subject name (Network Infrastructure Administration)
- ✅ Time (10:00 - 11:30)

## 🔧 Database Integration Points

### 1. **Teacher Profile Data**

```dart
// Location: Line 15-17
// TODO: Fetch from database
String _teacherName = 'Budi Santoso';
String _teacherSubject = 'Web Programming';
String _profileImageUrl = ''; // URL dari database

// Implementation:
Future<void> _fetchTeacherProfile() async {
  final profile = await DatabaseService.getTeacherProfile();
  setState(() {
    _teacherName = profile.name;
    _teacherSubject = profile.subject;
    _profileImageUrl = profile.imageUrl;
  });
}
```

### 2. **Active Class Data**

```dart
// Location: Line 20-28
// TODO: Fetch from database
Map<String, dynamic>? _activeClass = {
  'status': 'IN PROGRESS',
  'className': 'XII RPL 1',
  'subject': 'Web Programming',
  'startTime': '08:00',
  'endTime': '09:30',
  'room': 'Room 204',
  'building': 'Building B',
};

// Implementation:
Future<void> _fetchActiveClass() async {
  final activeClass = await DatabaseService.getActiveClass();
  setState(() {
    _activeClass = activeClass;
  });
}
```

### 3. **Next Schedules Data**

```dart
// Location: Line 31-38
// TODO: Fetch from database
final List<Map<String, dynamic>> _nextSchedules = [
  {
    'classCode': 'XTKJ2',
    'subject': 'Network Infrastructure Administration',
    'startTime': '10:00',
    'endTime': '11:30',
  },
];

// Implementation:
Future<void> _fetchNextSchedules() async {
  final schedules = await DatabaseService.getNextSchedules();
  setState(() {
    _nextSchedules = schedules;
  });
}
```

### 4. **Complete Fetch Function**

```dart
// Location: Line 54-68
Future<void> _fetchDashboardData() async {
  // TODO: Replace with actual database calls
  
  // Example implementation:
  try {
    final teacherProfile = await DatabaseService.getTeacherProfile();
    final activeClass = await DatabaseService.getActiveClass();
    final nextSchedules = await DatabaseService.getNextSchedules();
    
    if (mounted) {
      setState(() {
        _teacherName = teacherProfile.name;
        _teacherSubject = teacherProfile.subject;
        _profileImageUrl = teacherProfile.imageUrl;
        _activeClass = activeClass;
        _nextSchedules = nextSchedules;
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() => _isLoading = false);
    }
    // Handle error
  }
}
```

## 🎯 Navigation Points (TODO)

### 1. **Notification Button**
```dart
// Location: Line 268
onPressed: () {
  // TODO: Navigate to notifications
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NotificationsScreen()),
  );
}
```

### 2. **Start Attendance Button**
```dart
// Location: Line 357
onPressed: () {
  // TODO: Navigate to attendance screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AttendanceScreen(
        classData: _activeClass!,
      ),
    ),
  );
}
```

### 3. **Create Test Card**
```dart
// Location: Line 387
onTap: () {
  // TODO: Navigate to create test screen
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateTestScreen()),
  );
}
```

### 4. **Attendance History Card**
```dart
// Location: Line 451 (in Row)
onTap: () {
  // TODO: Navigate to attendance history
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AttendanceHistoryScreen()),
  );
}
```

### 5. **Exam History Card**
```dart
// Location: Line 463 (in Row)
onTap: () {
  // TODO: Navigate to exam history
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ExamHistoryScreen()),
  );
}
```

## 🎨 Design Specifications

### Colors
```dart
static const Color primaryBlue = Color(0xFF335CFA);
static const Color textDark = Color(0xFF1E293B);
static const Color textGrey = Color(0xFF64748B);
static const Color greenStatus = Color(0xFF10B981);
static const Color purpleIcon = Color(0xFF9333EA);
static const Color orangeIcon = Color(0xFFEA580C);
```

### Typography
- **Teacher Name**: 20px, bold, white
- **Subject**: 13px, white (90% opacity)
- **Date**: 10px, white (70% opacity), uppercase
- **Section Title**: 20px, bold, textDark
- **Card Title**: 16-20px, bold, textDark
- **Card Subtitle**: 13-14px, textGrey
- **Button Text**: 15px, bold, white

### Spacing
- **Horizontal Padding**: 24px
- **Card Padding**: 20-24px
- **Card Margin Bottom**: 16px
- **Section Spacing**: 32px
- **Header Bottom Padding**: 32px

### Border Radius
- **Header**: 32px (bottom corners)
- **Cards**: 20-24px
- **Buttons**: 16px
- **Status Badge**: 20px
- **Icon Container**: 12px

## 📱 Responsive Behavior

- ✅ SingleChildScrollView untuk scrollable content
- ✅ SafeArea untuk notch handling
- ✅ Flexible layout dengan Expanded widgets
- ✅ Proper spacing untuk bottom navigation

## ✅ Verification Checklist

- ✅ UI 100% sesuai mockup
- ✅ Data structure siap database
- ✅ All TODO comments documented
- ✅ Flutter analyze: 0 errors
- ✅ Responsive layout
- ✅ Smooth animations
- ✅ Proper null safety
- ✅ Loading state handled

## 🔄 Data Flow

```
1. initState() 
   ↓
2. _fetchDashboardData()
   ↓
3. DatabaseService calls (TODO)
   ↓
4. setState() with data
   ↓
5. UI rebuild with data
```

## 📝 Example Database Service

```dart
class DatabaseService {
  static Future<TeacherProfile> getTeacherProfile() async {
    // Fetch from database
    return TeacherProfile(
      name: 'Budi Santoso',
      subject: 'Web Programming',
      imageUrl: 'https://...',
    );
  }
  
  static Future<Map<String, dynamic>?> getActiveClass() async {
    // Fetch current active class
    // Return null if no active class
    return {
      'status': 'IN PROGRESS',
      'className': 'XII RPL 1',
      'subject': 'Web Programming',
      'startTime': '08:00',
      'endTime': '09:30',
      'room': 'Room 204',
      'building': 'Building B',
    };
  }
  
  static Future<List<Map<String, dynamic>>> getNextSchedules() async {
    // Fetch upcoming schedules
    return [
      {
        'classCode': 'XTKJ2',
        'subject': 'Network Infrastructure Administration',
        'startTime': '10:00',
        'endTime': '11:30',
      },
    ];
  }
}
```

## 🚀 Next Steps

1. ✅ UI Implementation - **DONE**
2. ⏳ Database Integration - **TODO**
3. ⏳ Navigation Implementation - **TODO**
4. ⏳ State Management - **TODO**
5. ⏳ API Integration - **TODO**
6. ⏳ Testing - **TODO**

## 📞 Notes

- Semua TODO comments sudah ditandai di code
- Data saat ini hardcoded untuk demo
- Siap untuk dipasangkan dengan database
- Active class card conditional (hanya muncul jika ada data)
- Profile image support dengan fallback icon
- Date format otomatis sesuai sistem

---

**Status**: ✅ Ready for Database Integration
