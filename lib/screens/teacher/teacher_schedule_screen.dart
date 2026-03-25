import 'package:attend/data/dummy_data.dart';
import 'package:attend/models/schedule_model.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreen();
}

class _ScheduleScreen extends State<ScheduleScreen> {
  int _selectedDayIndex = 1;
  bool _isLoading = false;
  List<ScheduleModel> _todaySchedule = [];

  final List<Map<String, String>> _days = [
    {'day': 'Sen', 'date': '28'},
    {'day': 'Sel', 'date': '29'},
    {'day': 'Rab', 'date': '30'},
    {'day': 'Kam', 'date': '31'},
    {'day': 'Jum', 'date': '01'},
  ];

  final List<String> _dayKeys = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  void initState() {
    super.initState();
    _fetchScheduleForSelectedDay();
  }

  Future<void> _fetchScheduleForSelectedDay() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        String currentDayIKey = _dayKeys[_selectedDayIndex];
        _todaySchedule = dummyWeaklySchedule[currentDayIKey] ?? [];
        _isLoading = false;
      });
    }
  }

  void _onDaySelected(int index) {
    if (_selectedDayIndex == index) return;
    setState(() {
      _selectedDayIndex = index;
    });
    _fetchScheduleForSelectedDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Jadwal Mengajar',
          style: TextStyle(
            color: Color(0xFF1F2937),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: List.generate(_days.length, (index) {
                bool isSelected = _selectedDayIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onDaySelected(index),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == _days.length - 1 ? 0 : 10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4A65E5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? null
                            : Border.all(color: Colors.grey.shade200),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4A65E5,
                                  ).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _days[index]['day']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF9CA3AF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _days[index]['date']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1F2937),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _isLoading
              ? 'Memuat Jadwal'
              : "${_todaySchedule.length} Kelas, ${_todaySchedule.length * 2} Jam Pelajaran",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 1.0)
            )
          ),

          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF4A65E5)))
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _todaySchedule.length,
              itemBuilder: (context, index){
                return ScheduleCard(schedule: _todaySchedule[index]);
              }
            )
          )
        ],
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: Color(schedule.colorCode)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Kartu: Jam & Lokasi dipisah dengan spaceBetween
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: Color(schedule.colorCode),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${schedule.startTime} - ${schedule.endTime}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(schedule.colorCode),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 12,
                                  color: Color(0xFF6B7280),
                                  // fontWeight DIHAPUS DARI ICON KARENA BIKIN ERROR
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  schedule.location,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Teks ClassName & Subject SEKARANG MASUK KE DALAM COLUMN
                      const SizedBox(height: 16),
                      Text(
                        schedule.className,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.subject,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
