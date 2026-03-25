import 'package:attend/screens/admin/adminSideScreen/admin_add_teacher_screen.dart';
import 'package:flutter/material.dart';

class TeacherAccountModel {
  final String id;
  final String name;
  final String role;
  final String email;
  final String password;
  final String avatarUrl;

  TeacherAccountModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.password,
    required this.avatarUrl,
  });
}

final List<TeacherAccountModel> dummyTeacherAccount = [
  TeacherAccountModel(
    id: 'G01',
    name: 'Rossy Rahmadani',
    role: 'Guru Rekaya Perangkat Lunak',
    email: 'rossy@gmail.com',
    password: 'guru123',
    avatarUrl: "https://i.pravatar.cc/150?img=44",
  ),
  TeacherAccountModel(
    id: "G02",
    name: "Aditya Pratama",
    role: "Guru Desain Komunikasi Visual",
    email: "aditya.p@email.com",
    password: "Password456",
    avatarUrl: "https://i.pravatar.cc/150?img=68",
  ),
  TeacherAccountModel(
    id: "G03",
    name: "Budi Santoso",
    role: "Guru Teknik Komputer Jaringan",
    email: "budi.s@email.com",
    password: "Password789",
    avatarUrl: "https://i.pravatar.cc/150?img=11",
  ),
  TeacherAccountModel(
    id: "G04",
    name: "Cindy Aulia",
    role: "Guru Matematika & Logika",
    email: "cindy.a@email.com",
    password: "PasswordABC",
    avatarUrl: "https://i.pravatar.cc/150?img=5",
  ),
];

class AdminManageTeachersScreen extends StatefulWidget {
  const AdminManageTeachersScreen({super.key});

  @override
  State<AdminManageTeachersScreen> createState() =>
      _AdminManageTeachersScreen();
}

class _AdminManageTeachersScreen extends State<AdminManageTeachersScreen> {
  bool _isLoading = true;
  List<TeacherAccountModel> _teachers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeacherAccounts();
  }

  Future<void> _fetchTeacherAccounts() async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      setState(() {
        _teachers = List.from(dummyTeacherAccount);
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xff1f2937)),
        ),
        centerTitle: true,
        title: const Text(
          'Kelola Guru',
          style: TextStyle(
            color: Color(0xff1f2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      hintText: 'Cari nama guru...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminAddTeacherScreen())
                      );
                    },
                    icon: const Icon(
                      Icons.person_add_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Tambah Guru Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4a65e5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'DAFTAR AKUN GURU',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xff6b7280),
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xff4a65e5)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _teachers.length,
                    itemBuilder: (context, index) {
                      return _buildTeacherAccountCard(_teachers[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherAccountCard(TeacherAccountModel teacher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(teacher.avatarUrl),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1f2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      teacher.role,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4a65e5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: Color(0xff6b7280),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            teacher.email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xff6b7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_open_rounded,
                          size: 14,
                          color: Color(0xff6b7280),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Pass: ${teacher.password}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xff6b7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: Colors.grey.shade200),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Color(0xff4a65e5),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: Color(0xff4a65e5),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_outlined,
                          color: Color(0xffe54a4),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Hapus',
                          style: TextStyle(
                            color: Color(0xffe54a4a),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
