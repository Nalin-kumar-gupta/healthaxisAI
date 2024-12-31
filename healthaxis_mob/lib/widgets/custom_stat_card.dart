// File: core/widgets/custom_stat_card.dart
import 'package:flutter/material.dart';
import '../core/constants/styles.dart';

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
          style: AppStyles.header.copyWith(fontSize: 20),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: AppStyles.body.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}