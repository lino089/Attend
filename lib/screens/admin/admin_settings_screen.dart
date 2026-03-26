import 'package:flutter/material.dart';

class AdminProfileModel {
  final String id;
  final String schoolName;
  final String role;

  AdminProfileModel({
    required this.id,
    required this.schoolName,
    required this.role,
  });
}

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreen();
}

class _AdminSettingsScreen extends State<AdminSettingsScreen> {
  bool _isLoading = true;
  AdminProfileModel? _adminProfile;

  @override
  void initState() {
    super.initState();
    _fecthAdminProfile();
  }

  Future<void> _fecthAdminProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _adminProfile = AdminProfileModel(
          id: 'ADM-01',
          schoolName: 'SMKN 1 BANTUL',
          role: 'Admin',
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xff1f2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff4a65e5)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff4a6ef2), Color(0xff2b44ba)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff4a65e5).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _adminProfile!.schoolName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _adminProfile!.role,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('PREFERENSI'),
                  _buildSettingCard(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Tema Aplikasi',
                        trailingWidget: Switch(
                          value: false,
                          onChanged: (value) {},
                          activeColor: const Color(0xff4a65e5),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.language_rounded,
                        title: 'Bahasa',
                        trailingText: 'Indonesia',
                        showArrow: true,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle("TENTANG & BANTUAN"),
                  _buildSettingCard(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.menu_book_rounded,
                        title: 'Panduan',
                        showArrow: true,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.help_center_outlined,
                        title: 'FAQ',
                        showArrow: true,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        icon: Icons.headset_mic_outlined,
                        title: 'Hubungi Kami',
                        showArrow: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('AKUN'),
                  _buildSettingCard(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.logout_rounded,
                        title: 'Keluar',
                        isDestructive: true,
                        showArrow: true,
                        onTap: () {
                          
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40)
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
          color: Color(0xff8993a4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
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
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
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
        ? const Color(0xffe54a4a)
        : const Color(0xff4a65e5);
    final Color iconBgColor = isDestructive
        ? const Color(0xFFFFE4E4)
        : const Color(0xFFEDF1FF);
    final Color textColor = isDestructive
        ? const Color(0xFFE54A4A)
        : const Color(0xFF1F2937);
    final Color arrowColor = isDestructive
        ? const Color(0xFFE54A4A)
        : const Color(0xFF9CA3AF);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff9ca3af),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (trailingWidget != null) ...[
                const SizedBox(width: 8),
                trailingWidget,
              ],
              if (showArrow) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: arrowColor,
                ),
              ],
            ],
          ),
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
