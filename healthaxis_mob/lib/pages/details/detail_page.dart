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
            Text('Dr. Morris', style: AppStyles.header),
            Text('Cardio Surgeon', style: AppStyles.subHeader),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('88.2', style: AppStyles.header),
                    Text('Good Review', style: AppStyles.body),
                  ],
                ),
                Column(
                  children: [
                    Text('93.94', style: AppStyles.header),
                    Text('Total Score', style: AppStyles.body),
                  ],
                ),
                Column(
                  children: [
                    Text('78.2', style: AppStyles.header),
                    Text('Satisfaction', style: AppStyles.body),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'About',
              style: AppStyles.header,
            ),
            Text(
              'A doctor can be found in several settings, including public health organizations...',
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
}