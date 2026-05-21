import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final int selectedDayIndex; // 1=Senin, 2=Selasa, ..., 6=Sabtu
  final Function(int) onDaySelected;

  const DatePickerWidget({
    super.key,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightGreyBg = Color(0xFFF1F5F9);

  static const List<String> _dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, index) {
          final dayIndex = index + 1; // 1=Senin, 2=Selasa, etc.
          final isSelected = dayIndex == selectedDayIndex;

          return GestureDetector(
            onTap: () => onDaySelected(dayIndex),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? primaryBlue : lightGreyBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _dayNames[index],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : textGrey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
