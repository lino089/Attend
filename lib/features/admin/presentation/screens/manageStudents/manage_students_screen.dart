import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'dart:math';

class StudentDummy {
  final String name;
  final String nis;
  final String className;
  final String username;
  final String password;
  
  StudentDummy({
    required this.name, 
    required this.nis, 
    required this.className,
    required this.username,
    required this.password,
  });
}

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  
  bool _isSelectionMode = false;
  final Set<String> _selectedNis = {};
  
  late List<StudentDummy> _allStudents;
  
  @override
  void initState() {
    super.initState();
    // Generate 32 dummy students
    final names = ["Aditya Prasetya", "Budi Santoso", "Citra Lestari", "Dedi Kurniawan", "Eka Putri"];
    final classes = ["XI RPL 2", "XI TKJ 1", "X MM 1", "XII RPL 1"];
    
    _allStudents = List.generate(32, (index) {
      String generatedName = names[index % names.length] + (index >= names.length ? " ${(index / names.length).floor()}" : "");
      return StudentDummy(
        name: generatedName,
        nis: (17792 + index).toString(),
        className: classes[index % classes.length],
        username: "${generatedName.split(' ')[0].toLowerCase()}.p_${1000 + index}",
        password: "pass${1000 + index}",
      );
    });
  }

  int get _totalPages => (_allStudents.length / _itemsPerPage).ceil();

  List<StudentDummy> get _currentStudents {
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = min(start + _itemsPerPage, _allStudents.length);
    if (start >= _allStudents.length) return [];
    return _allStudents.sublist(start, end);
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _deleteStudent(StudentDummy student) {
    setState(() {
      _allStudents.remove(student);
      if (_currentPage > _totalPages && _totalPages > 0) {
        _currentPage = _totalPages;
      }
    });
  }

  void _showDeleteDialog(BuildContext context, StudentDummy student) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDE8E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFE02424), size: 32),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hapus Data Siswa?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGreyLabel,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Apakah Anda yakin ingin menghapus data\n'),
                      TextSpan(
                        text: student.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const TextSpan(text: '? Tindakan ini tidak dapat dibatalkan.'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFF3F4F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal', style: TextStyle(color: AppColors.textGreyLabel, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteStudent(student);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFE02424),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, StudentDummy student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 12,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Edit Data Siswa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.textDark,
                        child: Icon(Icons.person, color: Colors.white, size: 50),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputLabel('NAMA LENGKAP'),
                _buildTextField(initialValue: student.name),
                const SizedBox(height: 16),
                _buildInputLabel('NIS'),
                _buildTextField(initialValue: student.nis),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('NO. ABSEN'),
                          _buildTextField(initialValue: '02'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel('KELAS'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.bgLightGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: student.className,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                                items: ['XI RPL 2', 'XI TKJ 1', 'X MM 1', 'XII RPL 1'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                                  );
                                }).toList(),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Informasi Akun',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCopyField('USERNAME', student.username),
                const SizedBox(height: 12),
                _buildCopyField('PASSWORD', student.password),
                const SizedBox(height: 32),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textGreyLabel,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTextField({required String initialValue}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        initialValue: initialValue,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCopyField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textGreyLabel,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Icon(Icons.copy_outlined, color: AppColors.primaryBlue, size: 20),
        ],
      ),
    );
  }

  void _showAddSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tambah Siswa Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSelectionTile(
                icon: Icons.edit_outlined,
                title: 'Tambah Manual',
                subtitle: 'Isi formulir data siswa satu per satu',
                onTap: () {
                  Navigator.pop(context);
                  _showAddManualBottomSheet(context);
                },
              ),
              const SizedBox(height: 16),
              _buildSelectionTile(
                icon: Icons.cloud_upload_outlined,
                title: 'Otomatis (Unggah File)',
                subtitle: 'Impor data siswa menggunakan file CSV atau Excel',
                onTap: () {
                  Navigator.pop(context);
                  _showAddAutomaticBottomSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectionTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF3E8FB), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFFA458D6)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.textGreyHint, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textGreyHint),
          ],
        ),
      ),
    );
  }

  void _showAddManualBottomSheet(BuildContext context) {
    final nameController = TextEditingController();
    final nisController = TextEditingController();
    final absenController = TextEditingController();
    String selectedClass = 'XI RPL 2';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 12,
                left: 24,
                right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tambah Siswa Manual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(radius: 40, backgroundColor: AppColors.bgLightGrey, child: Icon(Icons.person_outline, color: Colors.grey.shade400, size: 40)),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInputLabel('NAMA LENGKAP'),
                    _buildEditableTextField(controller: nameController),
                    const SizedBox(height: 16),
                    _buildInputLabel('NIS'),
                    _buildEditableTextField(controller: nisController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInputLabel('NO. ABSEN'), _buildEditableTextField(controller: absenController)])),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('KELAS'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedClass,
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                                    items: ['XI RPL 2', 'XI TKJ 1', 'X MM 1', 'XII RPL 1'].map((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textDark)));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setModalState(() => selectedClass = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel_outlined, color: AppColors.textDark),
                          label: const Text('BATAL', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (nameController.text.isNotEmpty && nisController.text.isNotEmpty) {
                              final randNum = Random().nextInt(9000) + 1000;
                              final username = "${nameController.text.split(' ')[0].toLowerCase()}_$randNum";
                              final password = "pass$randNum";
                              final newStudent = StudentDummy(
                                name: nameController.text,
                                nis: nisController.text,
                                className: selectedClass,
                                username: username,
                                password: password,
                              );
                              setState(() {
                                _allStudents.insert(0, newStudent);
                              });
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.save_outlined, color: Colors.white),
                          label: const Text('SIMPAN SISWA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableTextField({required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      ),
    );
  }

  void _showAddAutomaticBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tambah Siswa Otomatis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
                      child: const Icon(Icons.cloud_upload, color: AppColors.primaryBlue, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Klik atau tarik file ke sini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Mendukung format .xlsx atau .csv\n(Maks. 5MB)', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGreyHint, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Unduh Template Excel', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 16),
                        SizedBox(width: 8),
                        Text('KETENTUAN & INSTRUKSI:', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('• Gunakan format file yang sudah disediakan\n• Pastikan tidak ada duplikasi NIS\n• Proses unggah bergantung ukuran data', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 12, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text('Unggah & Proses Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kelola Siswa',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isSelectionMode = !_isSelectionMode;
                if (!_isSelectionMode) {
                  _selectedNis.clear();
                }
              });
            },
            child: Row(
              children: [
                Text(
                  _isSelectionMode ? 'Batal' : 'Pilih',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isSelectionMode ? Icons.close : Icons.checklist, 
                  color: AppColors.primaryBlue, 
                  size: 18,
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Nama/NIS...',
                  hintStyle: const TextStyle(color: AppColors.textGreyHint, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textGreyHint),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Dropdowns
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Semua Kelas',
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
                        items: ['Semua Kelas', 'Kelas 10', 'Kelas 11'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textGreyLabel)),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Semua Jurusan',
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
                        items: ['Semua Jurusan', 'RPL', 'TKJ'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textGreyLabel)),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Add Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showAddSelectionBottomSheet(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Tambah Siswa',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'DAFTAR SISWA',
              style: TextStyle(
                color: AppColors.textGreyLabel,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // List view
            ..._currentStudents.map((student) => _StudentCard(
              student: student,
              isSelectionMode: _isSelectionMode,
              isSelected: _selectedNis.contains(student.nis),
              onSelect: (val) {
                setState(() {
                  if (val == true) {
                    _selectedNis.add(student.nis);
                  } else {
                    _selectedNis.remove(student.nis);
                  }
                });
              },
              onEdit: () => _showEditBottomSheet(context, student),
              onDelete: () => _showDeleteDialog(context, student),
            )),
            
            const SizedBox(height: 24),
            
            // Pagination Bar
            _buildPaginationBar(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationBar() {
    List<Widget> pageButtons = [];
    
    // Add logic for dynamic pages
    int startPage = max(1, _currentPage - 1);
    int endPage = min(_totalPages, _currentPage + 1);
    
    // Show first page and ... if needed
    if (startPage > 1) {
      pageButtons.add(_pageButton(1));
      if (startPage > 2) {
        pageButtons.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('...', style: TextStyle(color: AppColors.textGreyHint)),
        ));
      }
    }
    
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_pageButton(i));
    }
    
    // Show last page and ... if needed
    if (endPage < _totalPages) {
      if (endPage < _totalPages - 1) {
        pageButtons.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('...', style: TextStyle(color: AppColors.textGreyHint)),
        ));
      }
      pageButtons.add(_pageButton(_totalPages));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 20),
          color: _currentPage > 1 ? AppColors.textDark : AppColors.textGreyHint,
          onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
        ),
        ...pageButtons,
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 20),
          color: _currentPage < _totalPages ? AppColors.textDark : AppColors.textGreyHint,
          onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
        ),
      ],
    );
  }

  Widget _pageButton(int page) {
    bool isActive = page == _currentPage;
    return GestureDetector(
      onTap: () => _goToPage(page),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textGreyLabel,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentDummy student;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _StudentCard({
    required this.student,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isSelectionMode)
            Checkbox(
              value: isSelected,
              onChanged: onSelect,
              activeColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.bgLightGrey,
            child: Icon(Icons.person, color: Colors.grey.shade300, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "NIS: ${student.nis} • ${student.className}",
                  style: const TextStyle(
                    color: AppColors.textGreyLabel,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (!isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textGreyLabel),
              onPressed: () {
                if (onEdit != null) onEdit!();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textGreyLabel),
              onPressed: () {
                if (onDelete != null) onDelete!();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
