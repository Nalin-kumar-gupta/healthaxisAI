import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';

class AppointmentDetailsPage extends StatelessWidget {
  // Demo data - hardcoded appointment details
  final Map<String, dynamic> appointment = {
    'name': 'Anjali Mehta',
    'patientId': 'P-2024-0123',
    'status': 'Stable',
    'imagePath': 'assets/patients/anjali_mehta.jpg',  // Make sure to have a default avatar image
    'time': '2025-01-15 14:30:00',
    'department': 'Cardiology',
    'type': 'Follow-up Consultation',
    'medications': [
      'Lisinopril 10mg',
      'Metoprolol 25mg',
      'Aspirin 81mg'
    ],
    'lastVisit': 'December 5, 2024',
    'notes': 'Patient reports improved exercise tolerance. Blood pressure has stabilized with current medication regimen. Continue monitoring cardiac function and medication adherence.',
  };

  AppointmentDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  // Rest of the code remains the same, just remove the null checks since we now have hardcoded data
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
          textAlign: TextAlign.center,
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
                      backgroundImage: AssetImage(appointment['imagePath']),
                      child: appointment['imagePath'] == null 
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
                          appointment['name'],
                          style: AppTextStyles.headline2,
                        ),
                        SizedBox(height: AppDimensions.spacing4),
                        Text(
                          'Patient ID: ${appointment['patientId']}',
                          style: AppTextStyles.body2,
                        ),
                        SizedBox(height: AppDimensions.spacing8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(appointment['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            appointment['status'],
                            style: AppTextStyles.caption.copyWith(
                              color: _getStatusColor(appointment['status']),
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
    DateTime appointmentTime = DateTime.parse(appointment['time']);

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
              DateFormat('EEEE, MMMM d, yyyy').format(appointmentTime),
            ),
            _buildDetailItem(
              Icons.access_time,
              'Time',
              DateFormat('h:mm a').format(appointmentTime),
            ),
            _buildDetailItem(
              Icons.local_hospital_outlined,
              'Department',
              appointment['department'],
            ),
            _buildDetailItem(
              Icons.medical_services_outlined,
              'Type',
              appointment['type'],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMedicalHistory() {
    List<String> medications = List<String>.from(appointment['medications']);

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
              medications.join(', '),
            ),
            _buildDetailItem(
              Icons.history,
              'Previous Visit',
              appointment['lastVisit'],
            ),
            _buildDetailItem(
              Icons.note_outlined,
              'Notes',
              appointment['notes'],
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
                icon: Icon(
                  Icons.medical_information,
                  color: Colors.white, // Make icon white
                ),
                label: Text(
                  'Start Diagnosis',
                  style: TextStyle(
                    color: Colors.white, // Make text white
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
                  foregroundColor: Colors.white, // This will affect both icon and text
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/diagnosis'); // Add navigation route
                },
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
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