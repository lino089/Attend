import 'package:flutter/material.dart';

class StudentDataModel {
  final String id;
  final String name;
  final String nis;
  final String className;
  final String major;
  final String avatarUrl;

  StudentDataModel({
    required this.id,
    required this.name,
    required this.nis,
    required this.className,
    required this.major,
    required this.avatarUrl,
  });
}

final List<StudentDataModel> dummyStudentData = [
  StudentDataModel(
    id: "S01",
    name: "Aditya Prasetya",
    nis: "17792",
    className: "XI RPL 2",
    major: "RPL",
    avatarUrl: "",
  ),
  StudentDataModel(
    id: "S02",
    name: "Budi Santoso",
    nis: "17793",
    className: "XI RPL 2",
    major: "RPL",
    avatarUrl: "",
  ),
  StudentDataModel(
    id: "S03",
    name: "Citra Lestari",
    nis: "17794",
    className: "XI RPL 2",
    major: "RPL",
    avatarUrl: "https://i.pravatar.cc/150?img=5",
  ),
  StudentDataModel(
    id: "S04",
    name: "Dedi Kurniawan",
    nis: "17795",
    className: "XI TKJ 1",
    major: "TKJ",
    avatarUrl: "https://i.pravatar.cc/150?img=11",
  ),
];

class AdminManageStudentsScreen extends StatefulWidget {
  const AdminManageStudentsScreen({super.key});

  @override
  State<AdminManageStudentsScreen> createState() =>
      _AdminManageStudentsScreen();
}

class _AdminManageStudentsScreen extends State<AdminManageStudentsScreen> {
  bool _isLoading = true;
  List<StudentDataModel> _students = [];

  String _selectedClass = 'Semua Kelas';
  String _selectdMajor = 'Semua Jurusan';

  final List<String> _classOptions = ['Semua Kelas', 'X', 'XI', 'XII'];
  final List<String> _majorOptions = ['Semua Jurusan', 'RPL', 'TKJ', 'DKV'];

  bool _isMultiSelectedMode = false;
  final Set<String> _selectedStudentIds = {};

  @override
  void initState() {
    super.initState();
    _fecthStudents();
  }

  Future<void> _fecthStudents() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _students = List.from(dummyStudentData);
        _isLoading = false;
      });
    }
  }

  void _toggleMutiSelectMode() {
    setState(() {
      _isMultiSelectedMode = !_isMultiSelectedMode;
      if (!_isMultiSelectedMode) {
        _selectedStudentIds.clear();
      }
    });
  }

  void _toggleStudentSelection(String id) {
    setState(() {
      if (_selectedStudentIds.contains(id)) {
        _selectedStudentIds.remove(id);
      } else {
        _selectedStudentIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xff1f2937)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Kelola Siswa',
          style: TextStyle(
            color: Color(0xff1f2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _toggleMutiSelectMode,
            icon: Icon(
              _isMultiSelectedMode
                  ? Icons.close_rounded
                  : Icons.checklist_rtl_rounded,
              color: const Color(0xff4a65e5),
              size: 20,
            ),
            label: Text(
              _isMultiSelectedMode ? 'Batal' : 'Pilih',
              style: const TextStyle(
                color: Color(0xff4a65e5),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
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
                      hintText: 'Cari Nama/NISN...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(_selectedClass, _classOptions, (
                        val,
                      ) {
                        if (val != null) setState(() => _selectedClass = val);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(_selectdMajor, _majorOptions, (
                        val,
                      ) {
                        if (val != null) setState(() => _selectdMajor = val);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Tambah Siswa',
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DAFTAR SISWA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6b7280),
                    letterSpacing: 1.0,
                  ),
                ),
                if (_isMultiSelectedMode)
                  GestureDetector(
                    onTap: () {
                      if (_selectedStudentIds.isEmpty) return;
                    },
                    child: Row(
                      children: [
                        Text(
                          'Hapus (${_selectedStudentIds.length}) data',
                          style: TextStyle(
                            color: _selectedStudentIds.isEmpty
                                ? Colors.grey
                                : const Color(0xffe54a4a),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: _selectedStudentIds.isEmpty
                              ? Colors.grey
                              : const Color(0xffe54a5a),
                        ),
                      ],
                    ),
                  ),
              ],
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
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      final isSelected = _selectedStudentIds.contains(
                        student.id,
                      );

                      return GestureDetector(
                        onTap: () {
                          if (_isMultiSelectedMode) {
                            _toggleMutiSelectMode();
                          } else {}
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xffedf1ff)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xff4a65e5)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
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
                              if (_isMultiSelectedMode) ...[
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: isSelected
                                      ? const Color(0xff4a65e5)
                                      : Colors.grey.shade400,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                              ],
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: student.avatarUrl.isNotEmpty
                                    ? NetworkImage(student.avatarUrl)
                                    : null,
                                child: student.avatarUrl.isEmpty
                                    ? Icon(
                                        Icons.person_rounded,
                                        color: Colors.grey.shade400,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff1f2937),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'NIS: ${student.nis} • ${student.className}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (!_isMultiSelectedMode) ...[
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xff6b7280),
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xff6b7280),
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (!_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: const Color(0xfff7f8fa),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left_rounded, color: Colors.grey.shade500),
                  const SizedBox(width: 16),
                  _buildPageNumber("1", isActive: true),
                  const SizedBox(width: 8),
                  _buildPageNumber("2"),
                  const SizedBox(width: 8),
                  _buildPageNumber("3"),
                  const SizedBox(width: 8),
                  const Text("...", style: TextStyle(color: Color(0xFF6B7280))),
                  const SizedBox(width: 8),
                  _buildPageNumber("10"),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF1F2937),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
            size: 20,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPageNumber(String number, {bool isActive = false}) {
    return Container(
      width: 35,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff4a65e5) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        number,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xff6b7280),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
