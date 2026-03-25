import 'package:attend/data/dummy_data.dart';
import 'package:attend/models/teacher_model.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  bool _isLoading = true;
  TeacherModel? _teacher;

  @override
  void initState() {
    super.initState();
    _fecthProfileData();
  }

  Future<void> _fecthProfileData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _teacher = dummyTeacher;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A65E5)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4A6EF2), Color(0xFF2B44BA)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A65E5).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    _teacher!.profileImageUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _teacher!.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _teacher!.role,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -40,
                          left: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('PREFERENSI'),
                  _buildSettingsCard(
                    childern: [
                      _buildSettingsItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Tema Aplikasi',
                        trailingWidget: Switch(
                          value: false,
                          onChanged: (val) {},
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifikasi',
                        trailingText: 'Off',
                        showArrow: true,
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.language_rounded,
                        title: 'Bahasa',
                        trailingText: 'Indonesia',
                        showArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('TENTANG & BANTUAN'),
                  _buildSettingsCard(
                    childern: [
                      _buildSettingsItem(
                        icon: Icons.menu_book_rounded,
                        title: 'Panduan',
                        showArrow: true,
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.help_outline_rounded,
                        title: 'FAQ',
                        showArrow: true,
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.headset_mic_outlined,
                        title: 'Hubungi Kami',
                        showArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('AKUN'),
                  _buildSettingsCard(
                    childern: [
                      _buildSettingsItem(
                        icon: Icons.logout_rounded,
                        title: 'Keluar',
                        isDestructive: true,
                        onTap: () {
                          print('Keluar');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8993A4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> childern}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: childern),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    bool showArrow = false,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final Color iconColor = isDestructive
        ? const Color(0xFFFF4B4B)
        : const Color(0xFF4A65E5);
    final Color iconBgColor = isDestructive
        ? const Color(0xFFFFF0F0)
        : const Color(0xFFEDF1FF);
    final Color textColor = isDestructive
        ? const Color(0xFFFF4B4B)
        : const Color(0xFF1F2937);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const Spacer(),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (trailingWidget != null) ...[
              const SizedBox(width: 8),
              trailingWidget,
            ],
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey.shade100, thickness: 1.5),
    );
  }
}
