import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/colors.dart';




// Add at the top of the HomePage file, with other imports
import 'package:intl/intl.dart';

class PatientDetailPage extends StatefulWidget {
  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final Map<String, dynamic> patientData = {
    'name': 'Anjali Mehta',
    'age': 32,
    'gender': 'Female',
    'conditions': ['Hypertension', 'Diabetes'],
    'lastVisit': '2023-12-10',
    'hospital': 'City General Hospital',
    'location': LatLng(37.7749, -122.4194),
    'allergies': ['Penicillin', 'Aspirin'],
    'medicationReminders': [
      'Metformin: 8 AM - Take with breakfast',
      'Insulin: 6 PM - Inject before dinner'
    ],
    'emergencyContact': {
      'name': 'Raj Mehta',
      'relation': 'Husband',
      'contact': '+9876543210'
    },
    'insuranceDetails': {
      'provider': 'HealthCare Plus',
      'policyNumber': 'HCP123456789',
      'expiryDate': '2025-12-31'
    },
    'longitudinalData': [
      {'date': '2023-09-15', 'visitReason': 'Routine Checkup', 'doctor': 'Dr. Asha Patel', 'notes': 'Routine health check, blood pressure monitored.'},
      {'date': '2023-10-20', 'visitReason': 'Blood Pressure Monitoring', 'doctor': 'Dr. Ravi Kumar', 'notes': 'Blood pressure elevated, increased dosage of Amlodipine.'},
      {'date': '2023-12-10', 'visitReason': 'Follow-up on Diabetes', 'doctor': 'Dr. Vijay Desai', 'notes': 'Diabetes well-controlled, insulin dosage adjusted.'},
    ],
    'previousPrescriptions': [
      {'date': '2023-09-15', 'medication': 'Metformin', 'dosage': '500 mg', 'notes': 'Control blood sugar levels, take with food.'},
      {'date': '2023-10-20', 'medication': 'Amlodipine', 'dosage': '5 mg', 'notes': 'Manage hypertension, take once daily.'},
      {'date': '2023-12-10', 'medication': 'Insulin', 'dosage': '10 units', 'notes': 'Regulate blood sugar during follow-up, inject before dinner.'},
    ],
    'contact': '+1234567890',
    'preferredLanguage': 'Hindi',
    'occupation': 'Teacher',
    'emergencyInstructions': 'In case of an emergency, contact the nearest hospital or call 911.',
  };


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Patient Info
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.only(top: 100, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/patients/anjali_mehta.jpg'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patientData['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Age: ${patientData['age']} | ${patientData['gender']}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          _buildQuickActionChips(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick Info Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _buildQuickInfoCards(),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(icon: Icon(Icons.person_outline), text: 'Overview'),
                  Tab(icon: Icon(Icons.history), text: 'History'),
                  Tab(icon: Icon(Icons.medical_services), text: 'Prescriptions'),
                  Tab(icon: Icon(Icons.map), text: 'Location'),
                ],
              ),
            ),
            pinned: true,
          ),

          // Tab Bar View Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildHistoryTab(),
                _buildPrescriptionsTab(),
                _buildLocationTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildQuickActionChips() {
    return Wrap(
      spacing: 8,
      children: patientData['conditions'].map<Widget>((condition) {
        return Chip(
          label: Text(
            condition,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: const Color.fromARGB(211, 233, 67, 76),
        );
      }).toList(),
    );
  }

  Widget _buildQuickInfoCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Hospital',
                patientData['hospital'],
                Icons.local_hospital,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Last Visit',
                patientData['lastVisit'],
                Icons.calendar_today,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildAllergyCard(),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                SizedBox(width: 8),
                Text(title, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyCard() {
    return Card(
      elevation: 2,
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Allergies',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...patientData['allergies'].map<Widget>(
              (allergy) => Padding(
                padding: EdgeInsets.only(left: 32),
                child: Text('• $allergy'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Medication Schedule'),
          _buildMedicationList(),
          SizedBox(height: 24),
          _buildSectionTitle('Vital Statistics'),
          _buildVitalStats(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: patientData['longitudinalData'].length,
      itemBuilder: (context, index) {
        final visit = patientData['longitudinalData'][index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.calendar_today),
              backgroundColor: AppColors.primary.withOpacity(0.1),
            ),
            title: Text(visit['visitReason']),
            subtitle: Text('${visit['date']}\n${visit['doctor']}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPrescriptionsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: patientData['previousPrescriptions'].length,
      itemBuilder: (context, index) {
        final prescription = patientData['previousPrescriptions'][index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medication, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      prescription['medication'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(prescription['notes']),
                      SizedBox(height: 4),
                      Text(
                        'Prescribed: ${prescription['date']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationTab() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: patientData['location'],
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: patientData['location'],
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    String _formatDateTime(DateTime dateTime) {
      // Custom datetime formatting without intl package
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} - $hour:$minute $amPm';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Use simple dialog to show phone number instead of url_launcher
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Contact Patient'),
                        content: Text('Call: ${patientData['contact']}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Here you would implement your app's calling functionality
                            },
                            child: const Text('Call'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text('Call Patient', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Show date picker
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (date != null) {
                    // Show time picker
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      // Combine date and time
                      final DateTime scheduledDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Follow-up'),
                            content: Text(
                              'Schedule follow-up for:\n${_formatDateTime(scheduledDateTime)}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Save the appointment
                                  // You would typically call a function here to save to your backend
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Follow-up scheduled successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                label: const Text('Schedule Follow-up', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMedicationList() {
    return Column(
      children: patientData['medicationReminders'].map<Widget>((reminder) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.medication, color: AppColors.primary),
            title: Text(reminder),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVitalStats() {
    // Placeholder for vital statistics
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildVitalStatCard('Blood Pressure', '120/80', Icons.favorite),
        _buildVitalStatCard('Heart Rate', '72 bpm', Icons.timeline),
        _buildVitalStatCard('Temperature', '98.6°F', Icons.thermostat),
        _buildVitalStatCard('Weight', '70 kg', Icons.monitor_weight),
      ],
    );
  }

  Widget _buildVitalStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}