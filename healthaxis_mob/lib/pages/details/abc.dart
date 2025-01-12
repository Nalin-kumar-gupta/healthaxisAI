import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';

class HealthcareFacility {
  final String name;
  final String type;
  final int bedCapacity;
  final int availableBeds;
  final LatLng location;
  final String contact;

  HealthcareFacility({
    required this.name,
    required this.type,
    required this.bedCapacity,
    required this.availableBeds,
    required this.location,
    required this.contact,
  });

  factory HealthcareFacility.fromMap(Map<String, dynamic> map) {
    return HealthcareFacility(
      name: map['name'] as String,
      type: map['type'] as String,
      bedCapacity: map['bedCapacity'] as int,
      availableBeds: map['availableBeds'] as int,
      location: map['location'] as LatLng,
      contact: map['contact'] as String,
    );
  }
}
class AreaDetailPage extends StatefulWidget {
  const AreaDetailPage({
    super.key,
    required this.areaName,
    required this.latitude,
    required this.longitude,
  });

  final String areaName;
  final double latitude;
  final double longitude;

  @override
  State<AreaDetailPage> createState() => _AreaDetailPageState();
}

class _AreaDetailPageState extends State<AreaDetailPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final MapController _mapController = MapController();
  bool _isDataSynced = true;

  final List<Map<String, dynamic>> diseaseData = [
    {
      'name': 'Dengue Fever',
      'activeCases': 45,
      'severity': 'High',
      'trend': 'Increasing',
      'symptoms': ['High Fever', 'Severe Headache', 'Joint Pain'],
      'riskFactors': ['Standing Water', 'Poor Drainage'],
      'color': AppColors.urgent,
    },
    {
      'name': 'Malaria',
      'activeCases': 32,
      'severity': 'Moderate',
      'trend': 'Stable',
      'symptoms': ['Fever', 'Chills', 'Headache'],
      'riskFactors': ['Mosquito Breeding', 'Poor Sanitation'],
      'color': AppColors.monitoring,
    },
  ];


  late final List<HealthcareFacility> facilities;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize facilities with proper typing
    facilities = [
      HealthcareFacility(
        name: 'Primary Health Center',
        type: 'Government',
        bedCapacity: 50,
        availableBeds: 15,
        location: LatLng(28.7041, 77.1025),
        contact: '+91 1234567890',
      ),
      HealthcareFacility(
        name: 'Community Clinic',
        type: 'Private',
        bedCapacity: 20,
        availableBeds: 8,
        location: LatLng(28.7045, 77.1030),
        contact: '+91 9876543210',
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
      // floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: AppDimensions.elevationSmall,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.areaName, style: AppTextStyles.headline2.copyWith(color: AppColors.textOnPrimary)),
          Text(
            'Population: 5,234 | Area: 12.5 km²',
            style: AppTextStyles.caption.copyWith(color: AppColors.textOnPrimary),
          ),
        ],
      ),
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
        indicatorColor: AppColors.secondary,
        tabs: const [
          Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
          Tab(icon: Icon(Icons.medical_services), text: 'Diseases'),
          Tab(icon: Icon(Icons.people), text: 'Patients'),
          Tab(icon: Icon(Icons.local_hospital), text: 'Facilities'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(),
          SizedBox(height: AppDimensions.spacing16),
          _buildDiseaseMap(),
          SizedBox(height: AppDimensions.spacing16),
          _buildRecentAlerts(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Area Statistics', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Active Cases', '135', Icons.sick, AppColors.urgent),
                _buildStatItem('Critical', '12', Icons.warning, AppColors.monitoring),
                _buildStatItem('Recovered', '45', Icons.healing, AppColors.stable),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: AppDimensions.iconLarge),
        SizedBox(height: AppDimensions.spacing8),
        Text(value, style: AppTextStyles.headline2),
        Text(label, style: AppTextStyles.body2),
      ],
    );
  }

  Widget _buildDiseaseMap() {
    return SizedBox(
      height: 400,
      child: Card(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(widget.latitude, widget.longitude),
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _buildMarkers(),
            ),
          ],
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    return facilities.map((facility) {
      return Marker(
        point: facility.location as LatLng,
        width: 40,
        height: 40,
        child: Icon(
          Icons.local_hospital,
          color: AppColors.secondary,
          size: AppDimensions.iconLarge,
        ),
      );
    }).toList();
  }

  Widget _buildRecentAlerts() {
    return Card(
      child: ListTile(
        title: Text('Recent Alerts', style: AppTextStyles.subtitle1),
        subtitle: const Text('3 new cases reported in the last 24 hours'),
        leading: Icon(Icons.notifications_active, color: AppColors.warning),
        trailing: TextButton(
          onPressed: () {},
          child: Text('View All', style: TextStyle(color: AppColors.primary)),
        ),
      ),
    );
  }

  Widget _buildDiseasesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      itemCount: diseaseData.length,
      itemBuilder: (context, index) {
        final disease = diseaseData[index];
        return Card(
          child: ExpansionTile(
            title: Text(disease['name'], style: AppTextStyles.subtitle1),
            subtitle: Text('Active Cases: ${disease['activeCases']}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDiseaseInfo('Severity', disease['severity']),
                    _buildDiseaseInfo('Trend', disease['trend']),
                    const SizedBox(height: AppDimensions.spacing8),
                    Text('Symptoms:', style: AppTextStyles.body1),
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

  Widget _buildDiseaseInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: Row(
        children: [
          Text('$label: ', style: AppTextStyles.body1),
          Text(value, style: AppTextStyles.body2),
        ],
      ),
    );
  }

  Widget _buildPatientsTab() {
    return const Center(
      child: Text('Patients information will be displayed here'),
    );
  }

  Widget _buildFacilitiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
        return Card(
          elevation: AppDimensions.elevationSmall,
          margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  facility.name,
                  style: AppTextStyles.subtitle1,
                ),
                subtitle: Text(
                  facility.type,
                  style: AppTextStyles.body2,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: AppColors.primary,
                    size: AppDimensions.iconMedium,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.phone),
                  color: AppColors.primary,
                  onPressed: () {
                    // Handle phone call
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFacilityStat(
                      'Total Beds',
                      facility.bedCapacity.toString(),
                      Icons.bed,
                    ),
                    _buildFacilityStat(
                      'Available',
                      facility.availableBeds.toString(),
                      Icons.bedroom_child,
                      color: facility.availableBeds > 0 
                          ? AppColors.success 
                          : AppColors.error,
                    ),
                    _buildFacilityStat(
                      'Occupancy',
                      '${((facility.bedCapacity - facility.availableBeds) / facility.bedCapacity * 100).round()}%',
                      Icons.people,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFacilityStat(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.primary,
          size: AppDimensions.iconMedium,
        ),
        const SizedBox(height: AppDimensions.spacing4),
        Text(
          value,
          style: AppTextStyles.subtitle1.copyWith(
            color: color ?? AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }


  Widget _buildSyncBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing8),
      color: AppColors.surfaceMedium,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isDataSynced ? Icons.cloud_done : Icons.cloud_off,
            color: _isDataSynced ? AppColors.success : AppColors.warning,
          ),
          SizedBox(width: AppDimensions.spacing8),
          Text(
            _isDataSynced ? 'Data Synced' : 'Offline Mode',
            style: AppTextStyles.body2,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: () => _showAddCaseDialog(),
          label: const Text('Add Case'),
          icon: const Icon(Icons.add_circle),
          backgroundColor: AppColors.secondary,
          heroTag: 'addCase',
        ),
        SizedBox(height: AppDimensions.spacing8),
        FloatingActionButton.extended(
          onPressed: () => _showEmergencyResponse(),
          label: const Text('Emergency'),
          icon: const Icon(Icons.emergency),
          backgroundColor: AppColors.urgent,
          heroTag: 'emergency',
        ),
      ],
    );
  }

  void _showAddCaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Case', style: AppTextStyles.subtitle1),
        content: const Text('Case reporting form will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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
        title: Text('Emergency Response', style: AppTextStyles.subtitle1),
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

  void _showAlerts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Area Alerts', style: AppTextStyles.subtitle1),
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
        title: Text('Filter Options', style: AppTextStyles.subtitle1),
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