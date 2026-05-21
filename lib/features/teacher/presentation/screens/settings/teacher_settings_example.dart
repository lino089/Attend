import 'package:flutter/material.dart';
import 'package:attend/features/teacher/presentation/screens/settings/teacher_settings_screen.dart';
import 'package:attend/features/teacher/presentation/screens/settings/models/teacher_profile_model.dart';

/// Example file untuk mendemonstrasikan cara menggunakan TeacherSettingsScreen
/// 
/// CARA PENGGUNAAN:
/// 
/// 1. Tanpa database (hardcoded):
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => TeacherSettingsScreen(
///       profile: TeacherProfileModel(
///         name: 'Rossy Rahmadani',
///         subject: 'Guru Rekayasa Perangkat Lunak',
///         photoUrl: null,
///       ),
///     ),
///   ),
/// );
/// ```
/// 
/// 2. Dengan data dari database:
/// ```dart
/// // Contoh: Ambil data dari database/API
/// final teacherData = await DatabaseService.getTeacherProfile();
/// 
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => TeacherSettingsScreen(
///       profile: TeacherProfileModel(
///         name: teacherData.name,
///         subject: teacherData.subject,
///         photoUrl: teacherData.photoUrl,
///       ),
///     ),
///   ),
/// );
/// ```
/// 
/// 3. Dengan Provider/Bloc:
/// ```dart
/// // Menggunakan Provider
/// final teacherProfile = Provider.of<TeacherProvider>(context).profile;
/// 
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => TeacherSettingsScreen(
///       profile: teacherProfile,
///     ),
///   ),
/// );
/// ```

class TeacherSettingsExample extends StatelessWidget {
  const TeacherSettingsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Example 1: Hardcoded data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherSettingsScreen(
                      profile: TeacherProfileModel(
                        name: 'Rossy Rahmadani',
                        subject: 'Guru Rekayasa Perangkat Lunak',
                        photoUrl: null,
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Open Settings (Hardcoded)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Example 2: Simulated database data
                _openSettingsWithDatabaseData(context);
              },
              child: const Text('Open Settings (Simulated DB)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettingsWithDatabaseData(BuildContext context) async {
    // Simulasi fetch data dari database
    // Dalam implementasi nyata, ganti dengan actual database call
    final teacherProfile = await _fetchTeacherProfileFromDatabase();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherSettingsScreen(
            profile: teacherProfile,
          ),
        ),
      );
    }
  }

  // Simulasi database fetch
  Future<TeacherProfileModel> _fetchTeacherProfileFromDatabase() async {
    // TODO: Replace with actual database query
    // Example: return await DatabaseService.getTeacherProfile();
    await Future.delayed(const Duration(milliseconds: 500));
    return TeacherProfileModel(
      name: 'Rossy Rahmadani',
      subject: 'Guru Rekayasa Perangkat Lunak',
      photoUrl: null, // Or provide actual URL from database
    );
  }
}
