import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../models/dummy_data.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Index 1 berarti default-nya terpilih hari 'Selasa'
  int _selectedDayIndex = 1; 

  // Data dinamis untuk tombol hari
  final List<Map<String, String>> _days = [
    {'day': 'Sen', 'date': '28'},
    {'day': 'Sel', 'date': '29'},
    {'day': 'Rab', 'date': '30'},
    {'day': 'Kam', 'date': '31'},
    {'day': 'Jum', 'date': '01'},
  ];

  final List<String> _dayKeys = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  Widget build(BuildContext context) {
    // Mengambil data jadwal berdasarkan hari yang dipilih
    String currentDayKey = _dayKeys[_selectedDayIndex];
    List<ScheduleModel> todaySchedules = dummyWeeklySchedules[currentDayKey] ?? [];

    return Scaffold(
      // Pastikan background warnanya abu-abu keunguan sesuai tema
      backgroundColor: const Color(0xFFF6F6FE), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        // --- TAMBAHAN SHADOW DI APP BAR ---
        elevation: 3, 
        shadowColor: Colors.black.withOpacity(0.2),
        title: const Text(
          'Jadwal Mengajar', 
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20), // Jarak dari AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(_days.length, (index) {
                bool isSelected = _selectedDayIndex == index;
                return Expanded( 
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      // Jarak antar kolom (margin kanan dihilangkan untuk elemen terakhir agar tidak jebol)
                      margin: EdgeInsets.only(right: index == _days.length - 1 ? 0 : 10),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF67B0FF) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                                ? const Color(0xFF67B0FF).withOpacity(0.4) 
                                : Colors.black.withOpacity(0.05), // Shadow tipis untuk kotak putih
                            blurRadius: 8, 
                            offset: const Offset(0, 4)
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _days[index]['day']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _days[index]['date']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 18, // Font tanggal sedikit dibesarkan
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

          // --- TEKS RINGKASAN JADWAL ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              todaySchedules.isEmpty 
                  ? "Tidak ada jadwal hari ini" 
                  : "${todaySchedules.length} Kelas", 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          
          const SizedBox(height: 16),

          // --- LIST KARTU JADWAL ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: todaySchedules.length,
              itemBuilder: (context, index) {
                final schedule = todaySchedules[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Garis Warna Penanda
                        Container(
                          width: 8,
                          decoration: BoxDecoration(
                            color: Color(schedule.colorCode),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                          ),
                        ),
                        // Konten Kartu
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${schedule.startTime} - ${schedule.endTime}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  schedule.className,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  schedule.subject,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: Colors.black),
                                    const SizedBox(width: 4),
                                    Text(
                                      schedule.location,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}