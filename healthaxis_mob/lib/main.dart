import 'package:flutter/material.dart';
import 'pages/splash/splash_screen.dart';
import 'pages/home/home_page.dart';
// import 'routes/app_routes.dart';
// import '../pages/details/appointment_detail_page.dart';
import '../pages/details/patient_detail_page.dart';
import '../pages/details/area_detail_page.dart';
import '../pages/details/chatbot_detail_page.dart';
import '../pages/details/stock_tracking_page.dart';
import '../pages/details/appointment_detail_page.dart';
import '../../models/app_data.dart';
import '../pages/diagnose/diagnosis.dart';

void main() {
  runApp(HealthAxisAIApp());
}

class HealthAxisAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Axis AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '' : (context) => HomePage(),
        '/chatbot': (context) => MedicalChatbotPage(),
        '/stock': (context) => StockTrackingPage(),
        '/patient-details': (context) => PatientDetailPage(),
        '/area-details': (context) => AreaDetailPage(),
        '/appointment-details': (context) => AppointmentDetailsPage(),
        '/diagnosis': (context) => DiagnosisPage()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => HomePage());
      },
    );
  }
}
