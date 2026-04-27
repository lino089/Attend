import 'package:attend/shared/widgets/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';

class ScheduleItem extends StatelessWidget {
  final bool isRest;
  final String subject;
  final String grade;
  final String time;

  const ScheduleItem({
    super.key,
    required this.isRest,
    required this.subject,
    required this.grade,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isRest ? AppColors.bgLightBlue : Colors.grey,
              borderRadius: BorderRadius.circular(14),
            ),
            child: isRest
                ? const Icon(
                    Icons.coffee_outlined,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  )
                : const Icon(
                    Icons.face,
                    color: AppColors.textLightGrey,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isRest ? time : "\$grade • \$time",
                  style: const TextStyle(
                    color: AppColors.textLightGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isRest)
            const Icon(Icons.chevron_right_sharp, color: Colors.grey),
        ],
      ),
    );
  }
}
