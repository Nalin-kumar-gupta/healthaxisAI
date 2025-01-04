import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import '../details/area_detail_page.dart';
import '../details/chatbot_detail_page.dart'; // Import Chatbot Detail Page
import '../details/stock_tracking_page.dart'; // Import the new StockTrackingPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> patients = [
    {'name': 'John Doe', 'details': 'Regular Checkup', 'imagePath': 'assets/patient1.jpg', 'date': '2023-01-10'},
    {'name': 'Jane Smith', 'details': 'Follow-up', 'imagePath': 'assets/patient2.jpg', 'date': '2023-01-10'},
    {'name': 'Alice Johnson', 'details': 'New Patient', 'imagePath': 'assets/patient3.jpg', 'date': '2023-01-12'},
    {'name': 'Michael Brown', 'details': 'Specialist Consultation', 'imagePath': 'assets/patient4.jpg', 'date': '2023-01-15'},
    {'name': 'Emily Davis', 'details': 'Routine Checkup', 'imagePath': 'assets/patient5.jpg', 'date': '2023-01-15'},
    {'name': 'David Wilson', 'details': 'Post-Surgery Checkup', 'imagePath': 'assets/patient6.jpg', 'date': '2023-01-20'},
    {'name': 'Sophia Taylor', 'details': 'Annual Physical', 'imagePath': 'assets/patient7.jpg', 'date': '2023-01-20'},
    {'name': 'James Moore', 'details': 'Cardiology Appointment', 'imagePath': 'assets/patient8.jpg', 'date': '2023-01-22'},
  ];

  DateTime _selectedDay = DateTime.now();

  // Function to get appointments based on selected day
  List<Map<String, String>> _getAppointmentsForDay(DateTime day) {
    String formattedDate = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    return patients.where((patient) => patient['date'] == formattedDate).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Axis AI', style: AppStyles.header.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // Make entire page scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(
              onSearch: (query) {
                print('Search query: $query');
              },
            ),
            SizedBox(height: 20),
            Text('Calendar', style: AppStyles.header),
            SizedBox(height: 10),
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                _showAppointmentsDialog(selectedDay);
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
            ),
            SizedBox(height: 20),
            Text('Areas', style: AppStyles.header),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomCard(
                    title: 'Rampur',
                    subtitle: '10+ Locations',
                    imagePath: 'assets/rampur.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AreaDetailPage(
                            areaName: 'Rampur',
                            latitude: 27.6637,
                            longitude: 79.4192,
                            diseaseSpread: 'Low spread of flu in the area.',
                            diseaseSources: 'Community gatherings, markets.',
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                  CustomCard(
                    title: 'Bhagalpur',
                    subtitle: '8+ Locations',
                    imagePath: 'assets/bhagalpur.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AreaDetailPage(
                            areaName: 'Bhagalpur',
                            latitude: 25.2424,
                            longitude: 87.0046,
                            diseaseSpread: 'Moderate spread of flu in the area.',
                            diseaseSources: 'Schools, temples.',
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                  CustomCard(
                    title: 'Chittorgarh',
                    subtitle: '12+ Locations',
                    imagePath: 'assets/chittorgarh.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AreaDetailPage(
                            areaName: 'Chittorgarh',
                            latitude: 24.888743,
                            longitude: 74.626921,
                            diseaseSpread: 'High spread of flu in the area.',
                            diseaseSources: 'Public events, busy markets.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Patients', style: AppStyles.header),
            SizedBox(height: 10),
            Column(
              children: patients.map((patient) {
                return CustomCard(
                  title: patient['name']!,
                  subtitle: patient['details']!,
                  imagePath: patient['imagePath']!,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: patient['name']!,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            
            // New button for Medical Stock Management
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockTrackingPage(),
                  ),
                );
              },
              child: Text('View Medical Stock Management'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                textStyle: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            
            // Chatbot Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatbotDetailPage(),
                  ),
                );
              },
              child: Text('Go to Chatbot'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                textStyle: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAppointmentsDialog(DateTime selectedDay) {
    List<Map<String, String>> appointments = _getAppointmentsForDay(selectedDay);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointments on ${selectedDay.toLocal()}'),
          content: appointments.isEmpty
              ? Text('No appointments for this day.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: appointments.map((appointment) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(appointment['imagePath']!),
                      ),
                      title: Text(appointment['name']!),
                      subtitle: Text(appointment['details']!),
                    );
                  }).toList(),
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
