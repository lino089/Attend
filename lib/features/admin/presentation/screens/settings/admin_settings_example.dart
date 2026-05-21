import 'package:flutter/material.dart';
import 'package:attend/features/admin/presentation/screens/settings/admin_settings_screen.dart';

/// Example file untuk mendemonstrasikan cara menggunakan AdminSettingsScreen
/// 
/// CARA PENGGUNAAN:
/// 
/// 1. Tanpa database (hardcoded):
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => const AdminSettingsScreen(
///       schoolName: 'SMKN 1 BANTUL',
///       role: 'Administrator',
///     ),
///   ),
/// );
/// ```
/// 
/// 2. Dengan data dari database:
/// ```dart
/// // Contoh: Ambil data dari database/API
/// final schoolData = await DatabaseService.getSchoolInfo();
/// final userData = await DatabaseService.getCurrentUser();
/// 
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => AdminSettingsScreen(
///       schoolName: schoolData.name, // e.g., "SMKN 1 BANTUL"
///       role: userData.role,          // e.g., "Administrator"
///     ),
///   ),
/// );
/// ```
/// 
/// 3. Dengan Provider/Bloc:
/// ```dart
/// // Menggunakan Provider
/// final schoolName = Provider.of<SchoolProvider>(context).schoolName;
/// final userRole = Provider.of<AuthProvider>(context).userRole;
/// 
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => AdminSettingsScreen(
///       schoolName: schoolName,
///       role: userRole,
///     ),
///   ),
/// );
/// ```

class AdminSettingsExample extends StatelessWidget {
  const AdminSettingsExample({super.key});

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
                    builder: (context) => const AdminSettingsScreen(
                      schoolName: 'SMKN 1 BANTUL',
                      role: 'Administrator',
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
    final schoolName = await _fetchSchoolNameFromDatabase();
    final userRole = await _fetchUserRoleFromDatabase();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminSettingsScreen(
            schoolName: schoolName,
            role: userRole,
          ),
        ),
      );
    }
  }

  // Simulasi database fetch
  Future<String> _fetchSchoolNameFromDatabase() async {
    // TODO: Replace with actual database query
    // Example: return await DatabaseService.getSchoolName();
    await Future.delayed(const Duration(milliseconds: 500));
    return 'SMKN 1 BANTUL';
  }

  Future<String> _fetchUserRoleFromDatabase() async {
    // TODO: Replace with actual database query
    // Example: return await DatabaseService.getCurrentUserRole();
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Administrator';
  }
}
