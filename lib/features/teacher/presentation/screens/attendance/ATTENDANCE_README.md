# Teacher Attendance Screen

Halaman Presensi untuk Teacher/Guru dengan sistem efisien (hanya kirim data S, I, A) dan fitur undo untuk mengembalikan siswa yang sudah ditandai hadir.

## 📁 File Structure

```
attend/lib/features/teacher/presentation/screens/attendance/
├── teacher_attendance_screen.dart      # Main attendance screen
├── models/
│   ├── student_model.dart              # Student data model
│   └── attendance_data_model.dart      # Attendance data model
└── ATTENDANCE_README.md                # Documentation
```

## 🎨 Features Implemented

### 1. **AppBar**
- ✅ Back button
- ✅ Class name (dari parameter/database)
- ✅ Subject name (dari parameter/database)
- ✅ History icon - untuk undo/restore siswa hadir

### 2. **Progress Section**
- ✅ Progress text dengan percentage (0-100%)
- ✅ Student count (processed/total)
- ✅ Progress bar indicator (blue)
- ✅ Real-time update

### 3. **Student List**
- ✅ Student card dengan nomor urut
- ✅ Avatar dengan fallback (initial letter)
- ✅ Student name (truncated jika > 15 karakter)
- ✅ NIS display
- ✅ 4 status buttons (H, S, I, A)

### 4. **Status Button Logic**
- ✅ **H (Hadir)** - Blue button
  - Card **HILANG** dari list
  - Pindah ke `_attendedStudents` list
  - Data **TIDAK** dikirim ke database
  
- ✅ **S (Sakit)** - Orange button (when selected)
  - Card **TETAP** ada
  - Status updated
  - Data **DIKIRIM** ke database
  
- ✅ **I (Izin)** - Blue button (when selected)
  - Card **TETAP** ada
  - Status updated
  - Data **DIKIRIM** ke database
  
- ✅ **A (Alpa)** - Red button (when selected)
  - Card **TETAP** ada
  - Status updated
  - Data **DIKIRIM** ke database

### 5. **Bottom Summary Section**
- ✅ 4 summary buttons dengan count:
  - "X Hadir" (Green)
  - "X Sakit" (Orange)
  - "X Izin" (Blue)
  - "X Alpa" (Red)
- ✅ Real-time count update

### 6. **Submit Button**
- ✅ "Kirim Presensi (X)" button
- ✅ X = count of S + I + A (data yang akan dikirim)
- ✅ Confirmation dialog sebelum kirim
- ✅ Loading indicator saat kirim
- ✅ Success message

### 7. **Undo/Restore Feature**
- ✅ History icon di AppBar
- ✅ Bottom sheet dengan list attended students
- ✅ Restore button per student
- ✅ Update lists and progress setelah restore

### 8. **Empty State**
- ✅ Message ketika semua siswa sudah hadir
- ✅ Icon check circle
- ✅ Instruction text

## 🔧 How It Works

### Status Flow

```
1. Initial State:
   - All students in _activeStudents list
   - All status = 'none'

2. User taps H button:
   - Student.status = 'H'
   - Move to _attendedStudents
   - Remove from _activeStudents
   - Card disappears
   - Progress updates

3. User taps S/I/A button:
   - Student.status = 'S'/'I'/'A'
   - Stay in _activeStudents
   - Card remains visible
   - Progress updates

4. User taps History icon:
   - Show bottom sheet
   - Display _attendedStudents
   - Can restore to _activeStudents

5. User taps Submit:
   - Get only S, I, A students
   - Show confirmation
   - Send to database
   - Show success/error
```

### Data Efficiency

```dart
// Hanya kirim data S, I, A (hemat bandwidth)
List<StudentAttendance> _getDataToSend() {
  return _activeStudents
      .where((s) => s.status == 'S' || s.status == 'I' || s.status == 'A')
      .map((s) => StudentAttendance(
            studentId: s.id,
            status: s.status,
          ))
      .toList();
}

// Contoh:
// Total siswa: 36
// Hadir: 30 (tidak dikirim)
// Sakit: 3 (dikirim)
// Izin: 2 (dikirim)
// Alpa: 1 (dikirim)
// Data yang dikirim: 6 siswa (bukan 36!)
```

## 🎯 Database Integration Points

### 1. **Fetch Students**

```dart
// Location: Line 56-95
Future<void> _fetchStudents() async {
  // TODO: Replace with actual database call
  
  // Example implementation:
  try {
    final students = await DatabaseService.getStudentsByClass(widget.classId);
    
    if (mounted) {
      setState(() {
        _activeStudents.addAll(students);
        _totalStudents = students.length;
        _isLoading = false;
      });
    }
  } catch (e) {
    // Handle error
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

### 2. **Submit Attendance**

```dart
// Location: Line 280-350
Future<void> _submitAttendance() async {
  final dataToSend = _getDataToSend();
  
  // TODO: Replace with actual database call
  
  // Example implementation:
  try {
    final attendanceData = AttendanceData(
      classId: widget.classId,
      className: widget.className,
      subject: widget.subject,
      date: DateTime.now(),
      absences: dataToSend,
    );
    
    await DatabaseService.submitAttendance(attendanceData);
    
    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Presensi berhasil dikirim!'),
        backgroundColor: greenStatus,
      ),
    );
    
    // Navigate back
    Navigator.pop(context);
  } catch (e) {
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: redStatus,
      ),
    );
  }
}
```

### 3. **Example Database Service**

```dart
class DatabaseService {
  // Fetch students by class
  static Future<List<Student>> getStudentsByClass(String classId) async {
    // Query database
    final response = await http.get('/api/students?classId=$classId');
    final List<dynamic> data = json.decode(response.body);
    
    return data.map((json) => Student.fromJson(json)).toList();
  }
  
  // Submit attendance
  static Future<void> submitAttendance(AttendanceData data) async {
    // Send to database
    await http.post(
      '/api/attendance',
      body: json.encode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
```

## 🚀 Usage

### From Dashboard

```dart
// In teacher_dashboard_screen.dart
// Start Attendance Button onPressed:

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TeacherAttendanceScreen(
      classId: _activeClass!['classId'],
      className: _activeClass!['className'],
      subject: _activeClass!['subject'],
    ),
  ),
);
```

### Standalone

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TeacherAttendanceScreen(
      classId: '123',
      className: 'XI RPL 2',
      subject: 'Pemrograman Perangkat Bergerak',
    ),
  ),
);
```

## 🎨 Design Specifications

### Colors
```dart
static const Color primaryBlue = Color(0xFF335CFA);
static const Color greenStatus = Color(0xFF10B981);
static const Color orangeStatus = Color(0xFFF59E0B);
static const Color blueStatus = Color(0xFF3B82F6);
static const Color redStatus = Color(0xFFEF4444);
static const Color greyInactive = Color(0xFFE5E7EB);
static const Color textDark = Color(0xFF1E293B);
static const Color textGrey = Color(0xFF64748B);
```

### Typography
- **Class Name**: 18px, bold, textDark
- **Subject**: 13px, textGrey
- **Progress Text**: 14px, bold, textDark
- **Student Name**: 15px, bold, textDark
- **NIS**: 12px, textGrey
- **Button Text**: 14-16px, bold

### Spacing
- **Horizontal Padding**: 20px
- **Card Padding**: 16px
- **Card Margin Bottom**: 16px
- **Button Spacing**: 8-12px

### Button Sizes
- **Status Buttons**: 40x40px (circular)
- **Summary Buttons**: height 48px
- **Submit Button**: height 56px

### Border Radius
- **Cards**: 16px
- **Status Buttons**: 20px (circular)
- **Summary Buttons**: 12px
- **Submit Button**: 16px

## 📊 State Management

### State Variables

```dart
// Lists
List<Student> _activeStudents = [];      // Siswa yang masih tampil
List<Student> _attendedStudents = [];    // Siswa yang sudah hadir (hidden)

// Counts
int _totalStudents = 0;
double _progressPercentage = 0.0;
int _processedCount = 0;
int _hadirCount = 0;
int _sakitCount = 0;
int _izinCount = 0;
int _alpaCount = 0;

// Loading
bool _isLoading = true;
```

### Key Methods

```dart
// Handle status button tap
void _handleStatusTap(Student student, String status)

// Update progress and counts
void _updateProgress()

// Get data to send (only S, I, A)
List<StudentAttendance> _getDataToSend()

// Show restore dialog
void _showRestoreDialog()

// Restore student to active list
void _restoreStudent(Student student)

// Submit attendance to database
Future<void> _submitAttendance()
```

## ✅ Features Checklist

- ✅ UI 100% sesuai mockup
- ✅ H button: Card hilang
- ✅ S/I/A button: Card tetap ada
- ✅ Progress bar real-time
- ✅ Summary counts update
- ✅ Undo/restore feature
- ✅ Data efficiency (hanya kirim S, I, A)
- ✅ Confirmation dialog
- ✅ Loading indicator
- ✅ Success/error messages
- ✅ Empty state
- ✅ Siap database integration
- ✅ Flutter analyze: 0 errors
- ✅ Clean code structure

## 🔄 Data Flow Diagram

```
┌─────────────────┐
│  Fetch Students │
│  from Database  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Display in List │
│ (_activeStudents)│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  User Taps      │
│  Status Button  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌───────┐
│   H   │ │ S/I/A │
└───┬───┘ └───┬───┘
    │         │
    ▼         ▼
┌─────────┐ ┌─────────┐
│ Move to │ │ Update  │
│ Attended│ │ Status  │
│ (Hide)  │ │ (Show)  │
└───┬─────┘ └───┬─────┘
    │           │
    └─────┬─────┘
          │
          ▼
    ┌─────────────┐
    │   Update    │
    │   Progress  │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │   Submit    │
    │ (Only S,I,A)│
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │   Database  │
    └─────────────┘
```

## 💡 Tips & Best Practices

1. **Data Efficiency**: Hanya kirim data yang perlu (S, I, A), hemat bandwidth
2. **User Experience**: Card hilang untuk hadir = visual feedback yang jelas
3. **Error Prevention**: Undo feature untuk antisipasi kesalahan
4. **Progress Tracking**: Real-time progress bar untuk monitoring
5. **Confirmation**: Dialog konfirmasi sebelum submit untuk keamanan

## 🐛 Troubleshooting

### Card tidak hilang saat tap H
- Check `_handleStatusTap` method
- Pastikan `_activeStudents.remove(student)` dipanggil
- Pastikan `setState()` dipanggil

### Progress tidak update
- Check `_updateProgress` method
- Pastikan dipanggil setelah setiap status change
- Check calculation logic

### Data tidak terkirim
- Check `_getDataToSend` method
- Pastikan filter hanya S, I, A
- Check database service implementation

## 🚀 Next Steps

1. ✅ UI Implementation - **DONE**
2. ⏳ Database Integration - **TODO**
3. ⏳ API Integration - **TODO**
4. ⏳ State Management (Provider/Bloc) - **TODO**
5. ⏳ Offline Support - **TODO**
6. ⏳ Testing - **TODO**

---

**Status**: ✅ Ready for Database Integration
**Last Updated**: Implementation Complete
