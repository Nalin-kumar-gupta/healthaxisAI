// File: lib/models/app_data.dart
import 'package:flutter/material.dart';

class AppData {
  static final List<Map<String, dynamic>> appointments = [
    {
      'name': 'Sarah Johnson',
      'imagePath': 'assets/patients/patient1.jpg',
      'details': 'Annual Checkup',
      'time': '2024-01-05 09:30:00',
      'status': 'Confirmed',
      'type': 'General',
      'notes': 'Patient reported mild headaches',
      'contact': '+1 (555) 123-4567'
    },
    {
      'name': 'Robert Chen',
      'imagePath': 'assets/patients/patient2.jpg',
      'details': 'Diabetes Follow-up',
      'time': '2024-01-05 10:45:00',
      'status': 'In Progress',
      'type': 'Specialist',
      'notes': 'Review recent blood sugar logs',
      'contact': '+1 (555) 234-5678'
    },
    {
      'name': 'Maria Garcia',
      'imagePath': 'assets/patients/patient3.jpg',
      'details': 'Prenatal Checkup',
      'time': '2024-01-05 14:15:00',
      'status': 'Scheduled',
      'type': 'Obstetrics',
      'notes': '28 weeks pregnant, routine check',
      'contact': '+1 (555) 345-6789'
    },
    {
      'name': 'James Wilson',
      'imagePath': 'assets/patients/patient4.jpg',
      'details': 'Blood Pressure Review',
      'time': '2024-01-05 15:30:00',
      'status': 'Confirmed',
      'type': 'Cardiology',
      'notes': 'Monthly BP monitoring',
      'contact': '+1 (555) 456-7890'
    },
  ];

  static final List<Map<String, dynamic>> patients = [
    {
      'name': 'Sarah Johnson',
      'imagePath': 'assets/patients/patient1.jpg',
      'status': 'Stable',
      'details': 'Hypertension',
      'nextAppointment': '2024-01-20',
      'age': 45,
      'gender': 'Female',
      'bloodGroup': 'O+',
      'address': '123 Main St, Cityville',
      'medicalHistory': ['Hypertension', 'Allergies'],
      'medications': ['Lisinopril 10mg', 'Zyrtec 5mg']
    },
    {
      'name': 'Robert Chen',
      'imagePath': 'assets/patients/patient2.jpg',
      'status': 'Monitoring',
      'details': 'Type 2 Diabetes',
      'nextAppointment': '2024-01-15',
      'age': 52,
      'gender': 'Male',
      'bloodGroup': 'A+',
      'address': '456 Oak Ave, Townsburg',
      'medicalHistory': ['Diabetes', 'High Cholesterol'],
      'medications': ['Metformin 1000mg', 'Statin 20mg']
    },
    {
      'name': 'Maria Garcia',
      'imagePath': 'assets/patients/patient3.jpg',
      'status': 'Stable',
      'details': 'Pregnancy - 28 weeks',
      'nextAppointment': '2024-01-12',
      'age': 31,
      'gender': 'Female',
      'bloodGroup': 'B+',
      'address': '789 Pine Rd, Villagetown',
      'medicalHistory': ['G1P0', 'Iron deficiency'],
      'medications': ['Prenatal vitamins', 'Iron supplements']
    },
  ];

  static final List<Map<String, dynamic>> areas = [
    {
      'title': 'Central District',
      'imagePath': 'assets/areas/central.jpg',
      'locationCount': 12,
      'riskLevel': 'Low',
      'activeCases': 23,
      'recoveredCases': 156,
      'vaccineStock': 'Adequate',
      'hospitals': ['Central Hospital', 'City Clinic', 'Metro Healthcare']
    },
    {
      'title': 'North Zone',
      'imagePath': 'assets/areas/north.jpg',
      'locationCount': 8,
      'riskLevel': 'Medium',
      'activeCases': 45,
      'recoveredCases': 234,
      'vaccineStock': 'Low',
      'hospitals': ['North General', 'Community Health Center']
    },
    {
      'title': 'East Region',
      'imagePath': 'assets/areas/east.jpg',
      'locationCount': 15,
      'riskLevel': 'High',
      'activeCases': 89,
      'recoveredCases': 445,
      'vaccineStock': 'Critical',
      'hospitals': ['Eastern Medical', 'Regional Hospital', 'Care Center']
    },
  ];
}

