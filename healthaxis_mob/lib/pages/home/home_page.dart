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


  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.chat_bubble_outline,
        'label': 'Chatbot',
        'route': '/chatbot',
        'color': Color(0xFF4CAF50),
      },
      {
        'icon': Icons.medical_services_outlined,
        'label': 'Stock',
        'route': '/stock',
        'color': Color(0xFF2196F3),
      },
      {
        'icon': Icons.calendar_today_outlined,
        'label': 'Calendar',
        'onTap': () => _showCalendarView(), // Ensure _showCalendarView is accessible
        'color': Color(0xFFFF4081),
      },
      {
        'icon': Icons.help_outline,
        'label': 'Help',
        'onTap': () => _showHelp(context),
        'color': Color(0xFF9C27B0),
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: Text('Quick Actions', style: AppTextStyles.headline2),
          ),
          SizedBox(height: AppDimensions.spacing16),
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actions.map((action) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
                    child: InkWell(
                      onTap: () {
                        if (action.containsKey('onTap') && action['onTap'] is Function) {
                          // Execute the onTap function if it exists
                          (action['onTap'] as Function)();
                        } else if (action.containsKey('route') && action['route'] is String) {
                          // Navigate to the route if it exists
                          Navigator.pushNamed(context, action['route'] as String);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(AppDimensions.spacing12),
                            decoration: BoxDecoration(
                              color: action['color'] as Color,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              boxShadow: [
                                BoxShadow(
                                  color: (action['color'] as Color).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              action['icon'] as IconData,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(height: AppDimensions.spacing8),
                          Text(
                            action['label'] as String,
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/appointment-details', arguments: appointment),
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(appointment['imagePath']),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['name'],
                            style: AppTextStyles.subtitle1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppDimensions.spacing4),
                          Text(
                            appointment['details'],
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spacing16),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: AppDimensions.iconSmall,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: AppDimensions.spacing8),
                      Text(
                        DateFormat('hh:mm a').format(DateTime.parse(appointment['time'])),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildAreaCard(Map<String, dynamic> area) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/area-details', arguments: area),
      child: Container(
        width: 220,
        height: 195,
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusLarge),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      area['imagePath'],
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: AppDimensions.spacing12,
                      left: AppDimensions.spacing12,
                      child: Text(
                        area['title'],
                        style: AppTextStyles.subtitle1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spacing12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Map<String, dynamic> patient) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/patient-details', arguments: patient),
      child: Card(
        elevation: AppDimensions.elevationSmall,
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacing16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(patient['imagePath']),
                backgroundColor: AppColors.surfaceMedium,
              ),
              SizedBox(width: AppDimensions.spacing16),
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
      expandedHeight: 180,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: AppTextStyles.body2.copyWith(color: AppColors.textOnPrimary),
            ),
            Text(
              'Dr. Smith',
              style: AppTextStyles.headline2.copyWith(color: AppColors.textOnPrimary),
            ),
          ],
        ),
        titlePadding: EdgeInsets.only(
          left: AppDimensions.spacing16,
          bottom: AppDimensions.spacing16,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: AppDimensions.spacing8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => _showNotifications(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => _showProfile(),
          ),
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

  Widget _buildSection({
    required String title,
    required Widget child,
    VoidCallback? onSeeAll,
  }) {
    return Container(
      margin: EdgeInsets.only(top: AppDimensions.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.headline2),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: Text(
                      'See All',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spacing12),
          child,
        ],
      ),
    );
  }

  
  // Update build method to use _currentIndex instead of TabController
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          NestedScrollView(
            key: const PageStorageKey('home_scroll'),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildAppBar(),
              _buildSearchBar(),
            ],
            body: RefreshIndicator(
              onRefresh: () async {},
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    _buildSection(
                      title: 'Today\'s Appointments',
                      onSeeAll: _showAllAppointments,
                      child: SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
                          itemCount: _getTodayAppointments().length,
                          itemBuilder: (context, index) =>
                              _buildAppointmentCard(_getTodayAppointments()[index]),
                        ),
                      ),
                    ),
                    _buildSection(
                      title: 'Area Overview',
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
                          itemCount: _getAreas().length,
                          itemBuilder: (context, index) =>
                              _buildAreaCard(_getAreas()[index]),
                        ),
                      ),
                    ),
                    _buildSection(
                      title: 'Recent Patients',
                      onSeeAll: () => Navigator.pushNamed(context, '/patients'),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                        itemCount: _getRecentPatients().length,
                        itemBuilder: (context, index) =>
                            _buildPatientCard(context, _getRecentPatients()[index]),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing24),
                  ],
                ),
              ),
            ),
          ),
          const Center(
            key: PageStorageKey('schedule_page'),
            child: Text('Schedule'),
          ),
          const Center(
            key: PageStorageKey('patients_page'),
            child: Text('Patients'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAppointmentDialog(),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primary,
        elevation: 4,
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

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Emergency Assistance',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Emergency Call Button
                        _buildEmergencyButton(
                          icon: Icons.emergency,
                          title: 'Call Emergency Services',
                          subtitle: 'Immediate medical assistance (911)',
                          color: Colors.red,
                          onTap: () => _showEmergencyCallDialog(context),
                        ),
                        
                        // First Aid Information
                        _buildHelpSection(
                          icon: Icons.medical_services,
                          title: 'First Aid Guide',
                          subtitle: 'Quick steps for common emergencies',
                          onTap: () => _showFirstAidGuide(context),
                        ),
                        
                        // Support Chat
                        _buildHelpSection(
                          icon: Icons.chat_bubble,
                          title: 'Contact Support',
                          subtitle: 'Chat with our medical team',
                          onTap: () => _showSupportChat(context),
                        ),
                        
                        // Nearby Hospitals
                        _buildHelpSection(
                          icon: Icons.local_hospital,
                          title: 'Nearby Hospitals',
                          subtitle: 'Find medical facilities near you',
                          onTap: () => _showNearbyHospitals(context),
                        ),
                        
                        // Emergency Contacts
                        _buildHelpSection(
                          icon: Icons.contacts,
                          title: 'Emergency Contacts',
                          subtitle: 'Manage your emergency contacts',
                          onTap: () => _showEmergencyContacts(context),
                        ),
                        
                        // Guided Help
                        _buildHelpSection(
                          icon: Icons.help,
                          title: 'Guided Assistance',
                          subtitle: 'Step-by-step help for your situation',
                          onTap: () => _showGuidedHelp(context),
                        ),
                        
                        // Panic Button
                        _buildEmergencyButton(
                          icon: Icons.warning,
                          title: 'Panic Button',
                          subtitle: 'Send SOS with your location',
                          color: Colors.orange,
                          onTap: () => _activatePanicButton(context),
                        ),
                      ],
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

  Widget _buildHelpSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: color.withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, size: 28, color: color),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Helper functions for each section
  void _showEmergencyCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Emergency Services?'),
        content: const Text('This will dial 911. Do you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement emergency call
              // You can use url_launcher package to make phone calls
              Navigator.pop(context);
            },
            child: const Text('Call', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFirstAidGuide(BuildContext context) {
    // Implement first aid guide display
  }

  void _showSupportChat(BuildContext context) {
    // Implement support chat interface
  }

  void _showNearbyHospitals(BuildContext context) {
    // Implement nearby hospitals map/list
  }

  void _showEmergencyContacts(BuildContext context) {
    // Implement emergency contacts list/management
  }

  void _showGuidedHelp(BuildContext context) {
    // Implement guided help flow
  }

  void _activatePanicButton(BuildContext context) {
    // Implement panic button functionality
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




















