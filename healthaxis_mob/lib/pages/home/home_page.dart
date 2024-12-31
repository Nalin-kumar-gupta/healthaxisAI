import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import '../details/area_detail_page.dart'; // Import the AreaDetailPage

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Axis AI', style: AppStyles.header.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomSearchBar(
              onSearch: (query) {
                print('Search query: $query');
                // Handle the search query (e.g., filter items, show results, etc.)
              },
            ),
            SizedBox(height: 20),
            Text('Areas', style: AppStyles.header),
            SizedBox(height: 10),
            // Wrap the Row in a SingleChildScrollView for horizontal scrolling
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomCard(
                    title: 'Downtown',
                    subtitle: '20+ Locations',
                    imagePath: 'assets/downtown.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AreaDetailPage(
                            areaName: 'Downtown',
                            latitude: 45.521563,
                            longitude: -122.677433,
                            diseaseSpread: 'High spread of flu in the area.',
                            diseaseSources: 'Public transport, crowded areas, etc.',
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16), // Add spacing between cards
                  CustomCard(
                    title: 'Uptown',
                    subtitle: '15+ Locations',
                    imagePath: 'assets/uptown.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AreaDetailPage(
                            areaName: 'Uptown',
                            latitude: 40.7831,
                            longitude: -73.9712,
                            diseaseSpread: 'Moderate spread of flu in the area.',
                            diseaseSources: 'Parks, shopping malls, etc.',
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16), // Add spacing between cards
                  // Add more CustomCard widgets as needed
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Patients', style: AppStyles.header),
            SizedBox(height: 10),
            CustomCard(
              title: 'John Doe',
              subtitle: 'Regular Checkup',
              imagePath: 'assets/patient1.jpg',
              onTap: () {
                Navigator.pushNamed(context, '/details', arguments: 'John Doe');
              },
            ),
            CustomCard(
              title: 'Jane Smith',
              subtitle: 'Follow-up',
              imagePath: 'assets/patient2.jpg',
              onTap: () {
                Navigator.pushNamed(context, '/details', arguments: 'Jane Smith');
              },
            ),
          ],
        ),
      ),
    );
  }
}
