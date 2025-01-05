import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class PatientDetailPage extends StatefulWidget {
  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final Map<String, dynamic> patientData = {
    'name': 'John Doe',
    'age': 45,
    'gender': 'Male',
    'conditions': ['Hypertension', 'Diabetes'],
    'lastVisit': '2023-12-10',
    'hospital': 'City General Hospital',
    'location': LatLng(37.7749, -122.4194),
    'allergies': ['Penicillin'],
    'medicationReminders': ['Metformin: 8 AM', 'Insulin: 6 PM'],
    'longitudinalData': [
      {'date': '2023-09-15', 'visitReason': 'Routine Checkup', 'doctor': 'Dr. Smith'},
      {'date': '2023-10-20', 'visitReason': 'Blood Pressure Monitoring', 'doctor': 'Dr. Taylor'},
      {'date': '2023-12-10', 'visitReason': 'Follow-up on Diabetes', 'doctor': 'Dr. Brown'},
    ],
    'previousPrescriptions': [
      {'date': '2023-09-15', 'medication': 'Metformin', 'notes': 'Control blood sugar levels'},
      {'date': '2023-10-20', 'medication': 'Amlodipine', 'notes': 'Manage hypertension'},
      {'date': '2023-12-10', 'medication': 'Insulin', 'notes': 'Regulate blood sugar during follow-up'},
    ],
    'contact': '+1234567890',
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
                      backgroundImage: AssetImage('assets/patient.jpg'),
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
          backgroundColor: Colors.white24,
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle call patient
                },
                icon: Icon(Icons.phone),
                label: Text('Call Patient'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle schedule follow-up
                },
                icon: Icon(Icons.calendar_today),
                label: Text('Schedule Follow-up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16),
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