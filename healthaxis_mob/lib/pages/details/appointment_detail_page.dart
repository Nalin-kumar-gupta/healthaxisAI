import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';


class AppointmentDetailsPage extends StatelessWidget {
  final Map<String, dynamic>? appointment;

  const AppointmentDetailsPage({Key? key, this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If appointment is null, show error state
    if (appointment == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Text('Appointment details not found', style: AppTextStyles.body1),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPatientCard(),
                _buildAppointmentDetails(),
                _buildMedicalHistory(),
                _buildActionButtons(context),
                SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
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
        title: Text(
          'Appointment Details',
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textOnPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: AppColors.textOnPrimary),
          onPressed: () {
            // Implement edit functionality
          },
        ),
      ],
    );
  }

  Widget _buildPatientCard() {
    return Container(
      margin: EdgeInsets.all(AppDimensions.spacing16),
      child: Card(
        elevation: AppDimensions.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
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
                      radius: 40,
                      backgroundImage: appointment!['imagePath'] != null 
                          ? AssetImage(appointment!['imagePath'] as String)
                          : null,
                      child: appointment!['imagePath'] == null 
                          ? Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment!['name']?.toString() ?? 'Unknown Patient',
                          style: AppTextStyles.headline2,
                        ),
                        SizedBox(height: AppDimensions.spacing4),
                        Text(
                          'Patient ID: ${appointment!['patientId']?.toString() ?? 'Unknown ID'}',
                          style: AppTextStyles.body2,
                        ),
                        SizedBox(height: AppDimensions.spacing8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(appointment!['status']?.toString() ?? '').withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            appointment!['status']?.toString() ?? 'Unknown Status',
                            style: AppTextStyles.caption.copyWith(
                              color: _getStatusColor(appointment!['status']?.toString() ?? ''),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    DateTime? appointmentTime;
    try {
      appointmentTime = appointment!['time'] != null 
          ? DateTime.parse(appointment!['time'].toString())
          : null;
    } catch (e) {
      appointmentTime = null;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Appointment Details', style: AppTextStyles.subtitle1),
          SizedBox(height: AppDimensions.spacing16),
          _buildDetailCard([
            _buildDetailItem(
              Icons.calendar_today_outlined,
              'Date',
              appointmentTime != null 
                  ? DateFormat('EEEE, MMMM d, yyyy').format(appointmentTime)
                  : 'Date not specified',
            ),
            _buildDetailItem(
              Icons.access_time,
              'Time',
              appointmentTime != null 
                  ? DateFormat('h:mm a').format(appointmentTime)
                  : 'Time not specified',
            ),
            _buildDetailItem(
              Icons.local_hospital_outlined,
              'Department',
              appointment!['department']?.toString() ?? 'Department not specified',
            ),
            _buildDetailItem(
              Icons.medical_services_outlined,
              'Type',
              appointment!['type']?.toString() ?? 'Type not specified',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMedicalHistory() {
    List<String> medications = [];
    if (appointment!['medications'] != null) {
      if (appointment!['medications'] is List) {
        medications = List<String>.from(appointment!['medications']);
      }
    }

    return Container(
      margin: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medical History', style: AppTextStyles.subtitle1),
          SizedBox(height: AppDimensions.spacing16),
          _buildDetailCard([
            _buildDetailItem(
              Icons.medication_outlined,
              'Current Medications',
              medications.isNotEmpty ? medications.join(', ') : 'No medications listed',
            ),
            _buildDetailItem(
              Icons.history,
              'Previous Visit',
              appointment!['lastVisit']?.toString() ?? 'No previous visits',
            ),
            _buildDetailItem(
              Icons.note_outlined,
              'Notes',
              appointment!['notes']?.toString() ?? 'No notes available',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(icon, size: AppDimensions.iconMedium, color: AppColors.primary),
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body2),
                SizedBox(height: AppDimensions.spacing4),
                Text(
                  value,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.video_call_outlined),
              label: Text('Start Call'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
              ),
              onPressed: () {
                // Implement video call
              },
            ),
          ),
          SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.message_outlined),
              label: Text('Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
              ),
              onPressed: () {
                // Implement messaging
              },
            ),
          ),
        ],
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
}