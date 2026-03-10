import 'package:flutter/material.dart';
import '../models/schedule_model.dart'; 
import '../models/dummy_data.dart'; 
// import '../models/teacher_model.dart'; 

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    const days = ['MINGGU', 'SENIN', 'SELASA', 'RABU', 'KAMIS', 'JUMAT', 'SABTU'];
    const months = ['JANUARI', 'FEBRUARI', 'MARET', 'APRIL', 'MEI', 'JUNI', 'JULI', 'AGUSTUS', 'SEPTEMBER', 'OKTOBER', 'NOVEMBER', 'DESEMBER'];
    
    String dayName = days[now.weekday == 7 ? 0 : now.weekday];
    String monthName = months[now.month - 1];
    
    return "$dayName, ${now.day} $monthName";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- CUSTOM APP BAR ---
        Container(
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
          decoration: const BoxDecoration(
            color: Color(0xFF5169F6), 
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(dummyTeacher.profileImageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dummyTeacher.name, 
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dummyTeacher.role, 
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFormattedDate(), 
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- LIST JADWAL KELAS ---
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: dummySchedules.length, 
            itemBuilder: (context, index) {
              return ScheduleCard(schedule: dummySchedules[index]);
            },
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schedule.className,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                schedule.isOngoing ? "(Sedang Berlangsung)" : "Status : Menunggu",
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: schedule.isOngoing ? FontStyle.italic : FontStyle.normal,
                  color: schedule.isOngoing ? const Color(0xFF8BC34A) : const Color(0xFFD3A2A2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Jam Pelajaran",
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          Text(
            "${schedule.startTime} - ${schedule.endTime}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          
          // Tombol hanya muncul jika kelas sedang berlangsung
          if (schedule.isOngoing) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigasi ke Halaman Proses Presensi
                  print("Mulai presensi untuk ${schedule.className}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB1A225), 
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Mulai Presensi",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}