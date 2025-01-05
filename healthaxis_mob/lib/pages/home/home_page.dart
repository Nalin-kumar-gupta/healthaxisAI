import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import '../../models/app_data.dart';


// Add at the top of the HomePage file, with other imports
import 'package:intl/intl.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  // Update the data fetching methods
  List<Map<String, dynamic>> _getTodayAppointments() {
    return AppData.appointments;
  }

  List<Map<String, dynamic>> _getAreas() {
    return AppData.areas;
  }

  List<Map<String, dynamic>> _getRecentPatients() {
    return AppData.patients;
  }

  int _currentIndex = 0;  // Single variable for navigation state
  late DateTime _selectedDay;
  final ScrollController _scrollController = ScrollController();
    
  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: AppDimensions.spacing16),
      child: Card(
        elevation: AppDimensions.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: InkWell(
          // onTap: () => _showAppointmentDetails(),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacing12),
            child: Row(
              children: [
                // Patient Image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(appointment['imagePath']),
                  backgroundColor: AppColors.surfaceMedium,
                ),
                SizedBox(width: AppDimensions.spacing12),
                // Appointment Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appointment['name'],
                        style: AppTextStyles.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimensions.spacing4),
                      Text(
                        appointment['details'],
                        style: AppTextStyles.body2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimensions.spacing8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: AppDimensions.iconSmall,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppDimensions.spacing4),
                          Text(
                            DateFormat('hh:mm a').format(
                              DateTime.parse(appointment['time']),
                            ),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Map<String, dynamic> patient) {
    return Card(
      elevation: AppDimensions.elevationSmall,
      margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: InkWell(
        // onTap: () => _showPatientDetails(patient),
        onTap: () => Navigator.pushNamed(context, '/patient'),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacing16),
          child: Row(
            children: [
              // Patient Image
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(patient['imagePath']),
                backgroundColor: AppColors.surfaceMedium,
              ),
              SizedBox(width: AppDimensions.spacing16),
              // Patient Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          patient['name'],
                          style: AppTextStyles.subtitle1,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(patient['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            patient['status'],
                            style: AppTextStyles.caption.copyWith(
                              color: _getStatusColor(patient['status']),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing8),
                    Row(
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          size: AppDimensions.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppDimensions.spacing4),
                        Text(
                          patient['details'],
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                    if (patient['nextAppointment'] != null) ...[
                      SizedBox(height: AppDimensions.spacing8),
                      Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: AppDimensions.iconSmall,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: AppDimensions.spacing4),
                          Text(
                            'Next: ${DateFormat('MMM dd, yyyy').format(
                              DateTime.parse(patient['nextAppointment']),
                            )}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildAreaCard(Map<String, dynamic> area) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: AppDimensions.spacing16),
      child: Card(
        elevation: AppDimensions.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: InkWell(
          // onTap: () => _showAreaDetails(area),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Area Image
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusMedium),
                ),
                child: Image.asset(
                  area['imagePath'],
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area['title'],
                      style: AppTextStyles.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppDimensions.spacing4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppDimensions.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppDimensions.spacing4),
                        Text(
                          '${area['locationCount']} Locations',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing8),
                    _buildRiskIndicator(area['riskLevel']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return AppColors.urgent;
      case 'stable':
        return AppColors.stable;
      case 'monitoring':
        return AppColors.monitoring;
      default:
        return AppColors.neutral;
    }
  }

  Widget _buildRiskIndicator(String riskLevel) {
    Color color;
    switch (riskLevel.toLowerCase()) {
      case 'high':
        color = AppColors.urgent;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      case 'low':
        color = AppColors.stable;
        break;
      default:
        color = AppColors.neutral;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_outlined,
            size: AppDimensions.iconSmall,
            color: color,
          ),
          SizedBox(width: AppDimensions.spacing4),
          Text(
            '$riskLevel Risk',
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }


  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Health Axis AI',
          style: AppTextStyles.headline2.copyWith(color: AppColors.textOnPrimary),
        ),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined),
          onPressed: () => _showNotifications(),
        ),
        IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () => _showProfile(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 80,
        maxHeight: 80,
        child: Container(
          color: AppColors.background,
          padding: EdgeInsets.all(AppDimensions.spacing16),
          child: CustomSearchBar(
            onSearch: (query) {
              // Implement search
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.headline2),
        SizedBox(height: AppDimensions.spacing12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.chat_bubble_outline,
              label: 'Chatbot',
              onTap: () => Navigator.pushNamed(context, '/chatbot'),
            ),
            _buildActionButton(
              icon: Icons.medical_services_outlined,
              label: 'Stock',
              onTap: () => Navigator.pushNamed(context, '/stock'),
            ),
            _buildActionButton(
              icon: Icons.calendar_today_outlined,
              label: 'Calendar',
              onTap: () => _showCalendarView(),
            ),
            _buildActionButton(
              icon: Icons.help_outline,
              label: 'Help',
              onTap: () => _showHelp(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spacing8),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today\'s Appointments', style: AppTextStyles.headline2),
            TextButton(
              onPressed: () => _showAllAppointments(),
              child: Text('See All'),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacing12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getTodayAppointments().length,
            itemBuilder: (context, index) {
              final appointment = _getTodayAppointments()[index];
              return _buildAppointmentCard(appointment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAreaOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Area Overview', style: AppTextStyles.headline2),
        SizedBox(height: AppDimensions.spacing12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getAreas().length,
            itemBuilder: (context, index) {
              final area = _getAreas()[index];
              return _buildAreaCard(area);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Patients', style: AppTextStyles.headline2),
        SizedBox(height: AppDimensions.spacing12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _getRecentPatients().length,
          itemBuilder: (context, index) {
            final patient = _getRecentPatients()[index];
            return _buildPatientCard(context , patient);
          },
        ),
      ],
    );
  }



  // Replace the _buildBottomNav method with this implementation
  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: 'Schedule',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: 'Patients',
        ),
      ],
    );
  }

  // Update build method to use _currentIndex instead of TabController
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // Home tab content
            NestedScrollView(
              key: const PageStorageKey('home_scroll'), // Add unique key
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                _buildAppBar(),
                _buildSearchBar(),
              ],
              body: RefreshIndicator(
                onRefresh: () async {
                  // Implement refresh logic
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickActions(),
                        SizedBox(height: AppDimensions.spacing24),
                        _buildUpcomingAppointments(),
                        SizedBox(height: AppDimensions.spacing24),
                        _buildAreaOverview(),
                        SizedBox(height: AppDimensions.spacing24),
                        _buildPatientsList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Schedule tab content - Add unique keys
            const Center(
              key: PageStorageKey('schedule_page'),
              child: Text('Schedule'),
            ),
            // Patients tab content - Add unique keys
            const Center(
              key: PageStorageKey('patients_page'),
              child: Text('Patients'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAppointmentDialog(),
        child: Icon(Icons.add, color: AppColors.textOnPrimary),
        backgroundColor: AppColors.primary,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }


  // Helper methods to get data (replace with actual data fetching)
  // List<Map<String, dynamic>> _getTodayAppointments() {
  //   // Implementation
  //   return [];
  // }

  // List<Map<String, dynamic>> _getAreas() {
  //   // Implementation
  //   return [];
  // }

  // List<Map<String, dynamic>> _getRecentPatients() {
  //   // Implementation
  //   return [];
  // }

  // Navigation methods
  void _showNotifications() {
    // Implementation
  }

  void _showProfile() {
    // Implementation
  }



  void _showCalendarView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            DateTime _selectedDay = DateTime.now();

            // Ensure _selectedDay is within the valid range
            if (_selectedDay.isBefore(DateTime.utc(2024, 1, 1)) ||
                _selectedDay.isAfter(DateTime.utc(2024, 12, 31))) {
              _selectedDay = DateTime.utc(2024, 1, 1);
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calendar', style: AppTextStyles.headline2),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  
                  // Calendar
                  Card(
                    elevation: AppDimensions.elevationSmall,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.spacing8),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2024, 1, 1),
                        lastDay: DateTime.utc(2024, 12, 31),
                        focusedDay: _selectedDay.isBefore(DateTime.utc(2024, 1, 1)) || 
                                    _selectedDay.isAfter(DateTime.utc(2024, 12, 31))
                            ? DateTime.utc(2024, 1, 1)
                            : _selectedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        eventLoader: (day) => _getAppointmentsForDay(day),
                        calendarStyle: CalendarStyle(
                          markerDecoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                          });
                          _showDayAppointments(selectedDay);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  
                  // Today's Appointments Section
                  Text(
                    'Today\'s Appointments',
                    style: AppTextStyles.subtitle1,
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getTodayAppointments().length,
                      itemBuilder: (context, index) {
                        final appointment = _getTodayAppointments()[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(appointment['imagePath']),
                            ),
                            title: Text(appointment['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(appointment['details']),
                                Text(
                                  DateFormat('hh:mm a').format(
                                    DateTime.parse(appointment['time']),
                                  ),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(AppDimensions.spacing8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(appointment['status'])
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusSmall,
                                ),
                              ),
                              child: Text(
                                appointment['status'],
                                style: AppTextStyles.caption.copyWith(
                                  color: _getStatusColor(appointment['status']),
                                ),
                              ),
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/appointment-details',
                              arguments: appointment,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Add Appointment Button
                  Padding(
                    padding: EdgeInsets.only(top: AppDimensions.spacing16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Add Appointment'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.spacing12,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showAddAppointmentDialog();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDayAppointments(DateTime day) {
    final appointments = _getAppointmentsForDay(day);
    if (appointments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No appointments for this day'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Appointments for ${DateFormat('MMM dd, yyyy').format(day)}',
            style: AppTextStyles.subtitle1,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(appointment['imagePath']),
                  ),
                  title: Text(appointment['name']),
                  subtitle: Text(
                    '${appointment['details']} - ${DateFormat('hh:mm a').format(
                      DateTime.parse(appointment['time']),
                    )}',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/appointment-details',
                      arguments: appointment,
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return AppData.appointments.where((appointment) {
      final appointmentDate = DateTime.parse(appointment['time']);
      return isSameDay(appointmentDate, day);
    }).toList();
  }

  
  void _showAppointmentDetails() {
    // Implementation
  }

  void _showHelp() {
    // Implementation
  }

  void _showAllAppointments() {
    // Implementation
  }

  void _showAddAppointmentDialog() {
    // Implementation
  }
}

// Custom delegate for the search bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}