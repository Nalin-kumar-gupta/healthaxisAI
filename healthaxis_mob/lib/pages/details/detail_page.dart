import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/doctor3.jpg'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text('Dr. Morris', style: AppStyles.header),
                  Text('Cardio Surgeon', style: AppStyles.subHeader),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('88.2', 'Good Review'),
                _buildStatCard('93.94', 'Total Score'),
                _buildStatCard('78.2', 'Satisfaction'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'About',
              style: AppStyles.header,
            ),
            SizedBox(height: 10),
            Text(
              'A doctor can be found in several settings, including public health organizations, group practices, and hospitals. They have some of the most diverse and challenging careers available and are part of a universally well-respected profession.',
              style: AppStyles.body,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Make an Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
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