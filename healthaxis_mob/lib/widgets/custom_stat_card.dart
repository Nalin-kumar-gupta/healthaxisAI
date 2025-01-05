// File: core/widgets/custom_stat_card.dart
import 'package:flutter/material.dart';
import '../core/constants/text_styles.dart';

class CustomStatCard extends StatelessWidget {
  final String value;
  final String label;

  const CustomStatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline1.copyWith(fontSize: 20),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: AppTextStyles.body1.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}