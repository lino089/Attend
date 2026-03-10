import 'package:flutter/material.dart';
import '../models/dummy_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FE), // Background abu keunguan
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // Menggunakan SingleChildScrollView agar aman kalau layarnya kecil
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KARTU PROFIL ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF5169F6), // Biru khas aplikasi
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF5169F6).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    // Mengambil gambar dari dummy data yang sama dengan Dashboard
                    backgroundImage: NetworkImage(dummyTeacher.profileImageUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dummyTeacher.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dummyTeacher.role,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // --- SECTION: PREFERENSI ---
            _buildSectionTitle('Preferensi'),
            _buildSettingsCard(
              children: [
                _buildListTile(
                  icon: Icons.brightness_6_outlined,
                  title: 'Tema Aplikasi',
                  trailingText: 'Light',
                  trailingWidget: Switch(
                    value: false, // Dummy switch off
                    onChanged: (val) {},
                    activeColor: const Color(0xFF5169F6),
                  ),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifikasi',
                  trailingText: 'Off',
                  showArrow: true,
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.language_rounded,
                  title: 'Bahasa',
                  trailingText: 'Indonesia',
                  showArrow: true,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- SECTION: TENTANG & BANTUAN ---
            _buildSectionTitle('Tentang & Bantuan'),
            _buildSettingsCard(
              children: [
                _buildListTile(icon: Icons.menu_book_rounded, title: 'Panduan', showArrow: true),
                _buildDivider(),
                _buildListTile(icon: Icons.help_outline_rounded, title: 'FAQ', showArrow: true),
                _buildDivider(),
                _buildListTile(icon: Icons.headset_mic_outlined, title: 'Hubungi Kami', showArrow: true),
              ],
            ),

            const SizedBox(height: 24),

            // --- SECTION: AKUN ---
            _buildSectionTitle('Akun'),
            _buildSettingsCard(
              children: [
                _buildListTile(
                  icon: Icons.logout_rounded, 
                  title: 'Keluar', 
                  isDestructive: true, // Beri tanda kalau ini tombol logout
                  onTap: () {
                    // Nanti dihubungkan ke fungsi Firebase SignOut
                    print("Tombol keluar ditekan");
                  }
                ),
              ],
            ),
            
            const SizedBox(height: 30), // Spasi bawah agar tidak tertutup nav bar
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Biar kode rapi & gak diulang-ulang) ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    bool showArrow = false,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: isDestructive ? Colors.red : Colors.black87),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15, 
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
            const Spacer(),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            if (trailingWidget != null) ...[
              const SizedBox(width: 8),
              trailingWidget,
            ],
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}