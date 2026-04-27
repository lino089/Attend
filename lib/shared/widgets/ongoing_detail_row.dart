import 'package:attend/shared/widgets/ongoing_detail_row.dart';
import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';

class OngoingDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const OngoingDetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textLightGrey, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
