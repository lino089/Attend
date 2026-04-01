import 'package:attend/auth/School_registration_screen.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const Color primaryBlue = Color(0xff3b5bdb);
  static const Color lightBlueBg = Color(0xFFF0F4FF);
  static const Color textDark = Color(0xFF1A1B22);
  static const Color textGrey = Color(0xFF71717A);
  static const Color backgroundColor = Color(0xFFF9FAFB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryBlue.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.grid_view_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Attend',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                    const Text(
                      'Choose Access',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Select your account type to begin',
                      style: TextStyle(fontSize: 15, color: textGrey),
                    ),
                    const SizedBox(height: 32),

                    RoleCard(
                      title: 'School / Admin',
                      subtitle: 'Manage system, acconts, and report',
                      icon: Icons.school_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchoolRegistrationPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    RoleCard(
                      title: 'Teacher',
                      subtitle: 'Take attendance and manage exams',
                      icon: Icons.badge_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    RoleCard(
                      title: 'Student',
                      subtitle: 'View schedules and take exams',
                      icon: Icons.assignment_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
              child: Text(
                'SELECT YOUR ACCES ROLE TO CONTINUE.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textGrey.withOpacity(0.6),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: RoleSelectionScreen.lightBlueBg,
          highlightColor: RoleSelectionScreen.lightBlueBg.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: RoleSelectionScreen.lightBlueBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: RoleSelectionScreen.primaryBlue,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: RoleSelectionScreen.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: RoleSelectionScreen.textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xff94a3b8),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
