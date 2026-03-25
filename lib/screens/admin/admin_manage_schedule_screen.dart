import 'package:flutter/material.dart';

class ScheduleTeacherModel {
  final String id;
  final String name;
  final String subject;
  final String avatarUrl;

  ScheduleTeacherModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.avatarUrl,
  });
}

final List<ScheduleTeacherModel> dummyScheduleTeachers = [
  ScheduleTeacherModel(
    id: "T01",
    name: "Rossy Rahmadani",
    subject: "Pemrograman Perangkat Bergerak",
    avatarUrl: "https://i.pravatar.cc/150?img=44",
  ),
  ScheduleTeacherModel(
    id: "T02",
    name: "Budi Setiawan",
    subject: "Dasar Infrastruktur Jaringan",
    avatarUrl: "https://i.pravatar.cc/150?img=11",
  ),
  ScheduleTeacherModel(
    id: "T03",
    name: "Siti Aminah",
    subject: "Desain Grafis Percetakan",
    avatarUrl: "https://i.pravatar.cc/150?img=5",
  ),
  ScheduleTeacherModel(
    id: "T04",
    name: "Ahmad Subarjo",
    subject: "Pemrograman Berorientasi Objek",
    avatarUrl: "https://i.pravatar.cc/150?img=12",
  ),
];

class AdminManageScheduleScreen extends StatefulWidget {
  const AdminManageScheduleScreen({super.key});

  @override
  State<AdminManageScheduleScreen> createState() =>
      _AdminManageScheduleScreen();
}

class _AdminManageScheduleScreen extends State<AdminManageScheduleScreen> {
  bool _isLoading = true;
  List<ScheduleTeacherModel> _teachers = [];

  String _selectedFilter = 'Semua Guru';
  final List<String> _filterOptions = [
    'Semua Guru',
    'Guru Tetap',
    'Guru Honorer',
    'Guru RPL',
    'Guru TKJ',
  ];

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _teachers = List.from(dummyScheduleTeachers);
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
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xff1f2937)),
        ),
        centerTitle: true,
        title: const Text(
          'Kelola Jadwal',
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      hintText: 'Cari Nama Guru...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xff4a65e5),
                          size: 18,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xff1f2937),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      items: _filterOptions.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text('Guru: $item'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedFilter = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xff4a65e5)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _teachers.length,
                    itemBuilder: (context, index) {
                      return _buildTeacherCard(_teachers[index]);
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
                  Icon(Icons.chevron_left_rounded, color: Colors.grey.shade400, size: 20,),
                  const SizedBox(width: 16),
                  _buildPageNumber('1', isActive: true),
                  const SizedBox(width: 12),
                  _buildPageNumber('2'),
                  const SizedBox(width: 12),
                  _buildPageNumber('3'),
                  const SizedBox(width: 12),
                  const Text('...', style: TextStyle(color: Color(0xff6b7280))),
                  const SizedBox(width: 16),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey.shade600, size: 20,)
                ],
              ),
            ),

          const SizedBox(height: 50)
        ],
      ),
    );
  }

  Widget _buildTeacherCard(ScheduleTeacherModel teacher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(teacher.avatarUrl),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1f2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        teacher.subject,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff6b7280),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Edit Jadwal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
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
          ),
        ),
      ),
    );
  }

  Widget _buildPageNumber(String number, {bool isActive = false}) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff4a65e5) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
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
