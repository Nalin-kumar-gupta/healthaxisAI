// calendar_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';
import '../../models/app_data.dart';

class CalendarBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(Map<String, dynamic>) onAppointmentTap;
  final VoidCallback onAddAppointment;

  const CalendarBottomSheet({
    Key? key,
    required this.appointments,
    required this.onAppointmentTap,
    required this.onAddAppointment,
  }) : super(key: key);

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  List<Map<String, dynamic>> _selectedDayAppointments = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _updateSelectedDayAppointments();
  }

  void _updateSelectedDayAppointments() {
    _selectedDayAppointments = widget.appointments.where((appointment) {
      final appointmentDate = DateTime.parse(appointment['time']);
      return isSameDay(appointmentDate, _selectedDay);
    }).toList();
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return widget.appointments.where((appointment) {
      final appointmentDate = DateTime.parse(appointment['time']);
      return isSameDay(appointmentDate, day);
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppDimensions.spacing16),
          _buildCalendar(),
          SizedBox(height: AppDimensions.spacing16),
          _buildAppointmentsList(),
          _buildAddAppointmentButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Calendar', style: AppTextStyles.headline2),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing8),
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
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
              _focusedDay = focusedDay;
              _updateSelectedDayAppointments();
            });
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointments for ${DateFormat('MMM dd, yyyy').format(_selectedDay)}',
            style: AppTextStyles.subtitle1,
          ),
          SizedBox(height: AppDimensions.spacing8),
          Expanded(
            child: _selectedDayAppointments.isEmpty
                ? Center(
                    child: Text(
                      'No appointments for this day',
                      style: AppTextStyles.body1,
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedDayAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = _selectedDayAppointments[index];
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
                          onTap: () => widget.onAppointmentTap(appointment),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAppointmentButton() {
    return Padding(
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
          onPressed: widget.onAddAppointment,
        ),
      ),
    );
  }
}

// In your HomePage class, update the _showCalendarView method:
