// File: lib/pages/area_detail/area_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';

class AreaDetailPage extends StatefulWidget {
  const AreaDetailPage({
    super.key,
    required this.areaName,
    required this.latitude,
    required this.longitude,
    required this.diseaseSpread,
    required this.diseaseSources,
  });

  final String areaName;
  final double latitude;
  final double longitude;
  final String diseaseSpread;
  final String diseaseSources;

  @override
  State<AreaDetailPage> createState() => _AreaDetailPageState();
}

class _AreaDetailPageState extends State<AreaDetailPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isDataSynced = true;

  final diseaseData = [
    {
      'name': 'Dengue Fever',
      'activeCases': 45,
      'severity': 'High',
      'trend': 'Increasing',
      'symptoms': ['High Fever', 'Severe Headache', 'Joint Pain'],
      'riskFactors': ['Standing Water', 'Poor Drainage'],
    },
    {
      'name': 'Typhoid',
      'activeCases': 28,
      'severity': 'Moderate',
      'trend': 'Stable',
      'symptoms': ['Fever', 'Weakness', 'Stomach Pain'],
      'riskFactors': ['Contaminated Water', 'Poor Sanitation'],
    },
    {
      'name': 'Respiratory Infections',
      'activeCases': 62,
      'severity': 'Moderate',
      'trend': 'Decreasing',
      'symptoms': ['Cough', 'Shortness of Breath', 'Fever'],
      'riskFactors': ['Air Pollution', 'Dense Population'],
    },
  ];

  final patientData = [
    {
      'id': 'P001',
      'name': 'John Doe',
      'age': 45,
      'condition': 'Dengue Fever',
      'severity': 'Critical',
      'address': '123 Main St',
      'lastVisit': '2024-01-10',
      'status': 'Under Treatment',
    },
  ];

  final healthcareFacilities = [
    {
      'name': 'City General Hospital',
      'type': 'Government Hospital',
      'bedCapacity': 200,
      'availableBeds': 45,
      'location': LatLng(27.6640, 79.4205),
      'specialties': ['Emergency Care', 'Infectious Diseases'],
    },
    {
      'name': 'Community Health Center',
      'type': 'Primary Healthcare',
      'bedCapacity': 50,
      'availableBeds': 15,
      'location': LatLng(27.6630, 79.4190),
      'specialties': ['General Medicine', 'Vaccination'],
    },
  ];

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
      appBar: AppBar(
        title: Text(widget.areaName),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showAlerts(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.medical_services), text: 'Diseases'),
            Tab(icon: Icon(Icons.people), text: 'Patients'),
            Tab(icon: Icon(Icons.local_hospital), text: 'Facilities'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildDiseasesTab(),
          _buildPatientsTab(),
          _buildFacilitiesTab(),
        ],
      ),
      bottomNavigationBar: _buildSyncBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showAddCaseDialog(),
            label: const Text('Add Case'),
            icon: const Icon(Icons.add_circle),
            backgroundColor: AppColors.secondary,
            heroTag: 'addCase',
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () => _showEmergencyResponse(),
            label: const Text('Emergency'),
            icon: const Icon(Icons.emergency),
            backgroundColor: AppColors.urgent,
            heroTag: 'emergency',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(),
          const SizedBox(height: 16),
          _buildDiseaseMap(),
          const SizedBox(height: 16),
          _buildRecentAlerts(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Area Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Active Cases', '135', Icons.sick),
                _buildStatItem('Critical', '12', Icons.warning),
                _buildStatItem('Recovered', '45', Icons.healing),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }

  Widget _buildDiseaseMap() {
    return SizedBox(
      height: 300,
      child: Card(
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(widget.latitude, widget.longitude),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(widget.latitude, widget.longitude),
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
                ...healthcareFacilities.map((facility) => Marker(
                      point: facility['location'] as LatLng,
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.local_hospital,
                        color: AppColors.secondary,
                        size: 30,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlerts() {
    return Card(
      child: ListTile(
        title: const Text('Recent Alerts'),
        subtitle: const Text('3 new cases reported in the last 24 hours'),
        leading: const Icon(Icons.notifications_active),
        trailing: TextButton(
          onPressed: () {},
          child: const Text('View All'),
        ),
      ),
    );
  }

  Widget _buildDiseasesTab() {
    return ListView.builder(
      itemCount: diseaseData.length,
      itemBuilder: (context, index) {
        final disease = diseaseData[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(disease['name'] as String),
            subtitle: Text('Active Cases: ${disease['activeCases']}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Severity: ${disease['severity']}'),
                    Text('Trend: ${disease['trend']}'),
                    const SizedBox(height: 8),
                    const Text('Symptoms:'),
                    ...(disease['symptoms'] as List).map((s) => Text('• $s')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPatientsTab() {
    return ListView.builder(
      itemCount: patientData.length,
      itemBuilder: (context, index) {
        final patient = patientData[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('${patient['name']} (${patient['age']} yrs)'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Condition: ${patient['condition']}'),
                Text('Status: ${patient['status']}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => _showPatientDetails(patient),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFacilitiesTab() {
    return ListView.builder(
      itemCount: healthcareFacilities.length,
      itemBuilder: (context, index) {
        final facility = healthcareFacilities[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(facility['name'] as String),
            subtitle: Text(
                '${facility['type']}\nBeds Available: ${facility['availableBeds']}/${facility['bedCapacity']}'),
            leading: const Icon(Icons.local_hospital),
            trailing: IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                // Implement navigation to facility on map
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyncBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isDataSynced ? Icons.cloud_done : Icons.cloud_off,
            color: _isDataSynced ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(_isDataSynced ? 'Data Synced' : 'Offline Mode'),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () => _syncData(),
            icon: const Icon(Icons.sync),
            label: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }

  void _syncData() {
    setState(() {
      _isDataSynced = !_isDataSynced;
    });
  }

  void _showAddCaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Case'),
        content: const Text('Case reporting form will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyResponse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Response'),
        content: const Text('Emergency response actions will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPatientDetails(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(patient['name'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${patient['id']}'),
            Text('Age: ${patient['age']}'),
            Text('Condition: ${patient['condition']}'),
            Text('Status: ${patient['status']}'),
            Text('Address: ${patient['address']}'),
            Text('Last Visit: ${patient['lastVisit']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAlerts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Area Alerts'),
        content: const Text('Recent alerts will be shown here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: const Text('Filter options will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}