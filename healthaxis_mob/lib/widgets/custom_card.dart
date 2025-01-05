import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const CustomCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.background,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.headline2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
