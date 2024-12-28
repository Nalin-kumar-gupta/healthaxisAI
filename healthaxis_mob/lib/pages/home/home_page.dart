import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../details/detail_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Health Axis AI',
          style: AppStyles.header.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Peter Parker',
              style: AppStyles.header,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Category',
              style: AppStyles.subHeader,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryCard('Chemist & Druggist', '350+ Stores', Colors.green),
                _buildCategoryCard('Covid-19 Specialist', '899 Doctors', Colors.blue),
                _buildCategoryCard('Cardiologists', '500+ Doctors', Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Top Doctors',
              style: AppStyles.subHeader,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildDoctorCard(context, 'Dr. David Kemp', 'Heart Surgeon', 'assets/doctor1.jpg'),
                  _buildDoctorCard(context, 'Dr. Kathy Mathews', 'Neurology', 'assets/doctor2.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, Color color) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: AppStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, String name, String specialty, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(name, style: AppStyles.body),
        subtitle: Text(specialty, style: AppStyles.subHeader.copyWith(fontSize: 14)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage()),
          );
        },
      ),
    );
  }
}