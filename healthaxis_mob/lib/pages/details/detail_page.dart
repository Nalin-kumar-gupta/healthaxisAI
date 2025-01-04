import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';  
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> patientData = {
      'name': 'John Doe',
      'age': 45,
      'gender': 'Male',
      'conditions': ['Hypertension', 'Diabetes'],
      'lastVisit': '2023-12-10',
      'hospital': 'City General Hospital',
      'location': LatLng(37.7749, -122.4194),  // Patient's location
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
      'contact': '+1234567890',  // Patient contact info for doctors
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Patient Overview'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/patient.jpg'),  // Doctor can quickly identify the patient
                ),
              ),
              SizedBox(height: 20),
              Text('${patientData['name']}', style: AppStyles.header),
              Text('Age: ${patientData['age']} | Gender: ${patientData['gender']}', style: AppStyles.subHeader),
              SizedBox(height: 10),
              Text('Last Visit: ${patientData['lastVisit']}', style: AppStyles.body),
              Text('Hospital: ${patientData['hospital']}', style: AppStyles.body),
              Divider(height: 30, thickness: 1),

              // Allergies
              Text('Allergies', style: AppStyles.header),
              SizedBox(height: 8),
              ...patientData['allergies'].map<Widget>(
                (allergy) => Text('• $allergy', style: AppStyles.body),
              ),
              Divider(height: 30, thickness: 1),

              // Medical Conditions
              Text('Medical Conditions', style: AppStyles.header),
              SizedBox(height: 8),
              ...patientData['conditions'].map<Widget>(
                (condition) => Text('• $condition', style: AppStyles.body),
              ),
              Divider(height: 30, thickness: 1),

              // Medication Reminders
              Text('Medication Reminders', style: AppStyles.header),
              SizedBox(height: 8),
              ...patientData['medicationReminders'].map<Widget>(
                (reminder) => Text('• $reminder', style: AppStyles.body),
              ),
              Divider(height: 30, thickness: 1),

              // Patient Location on Map (show hospital or facility)
              Text('Patient Location', style: AppStyles.header),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: FlutterMap(
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
                ),
              ),
              Divider(height: 30, thickness: 1),

              // Longitudinal Data (Visit history)
              Text('Longitudinal Data', style: AppStyles.header),
              SizedBox(height: 10),
              Column(
                children: (patientData['longitudinalData'] as List).map((entry) {
                  return ListTile(
                    leading: Icon(Icons.timeline, color: AppColors.primary),
                    title: Text('${entry['visitReason']}'),
                    subtitle: Text('Date: ${entry['date']}\nDoctor: ${entry['doctor']}'),
                  );
                }).toList(),
              ),
              Divider(height: 30, thickness: 1),

              // Previous Prescriptions (Doctors can modify or add prescriptions)
              Text('Previous Prescriptions', style: AppStyles.header),
              SizedBox(height: 10),
              Column(
                children: (patientData['previousPrescriptions'] as List).map((prescription) {
                  return ListTile(
                    leading: Icon(Icons.medical_services, color: AppColors.primary),
                    title: Text('${prescription['medication']}'),
                    subtitle: Text('${prescription['notes']}\nDate: ${prescription['date']}'),
                  );
                }).toList(),
              ),
              Divider(height: 30, thickness: 1),

              // Action Buttons for doctors (Schedule follow-up, call patient)
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Placeholder for scheduling a follow-up appointment
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Follow-up Appointment Scheduling Coming Soon!')),
                        );
                      },
                      child: Text('Schedule Follow-Up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Placeholder for calling the patient
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Call Patient Feature Coming Soon!')),
                        );
                      },
                      child: Text('Call Patient'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
