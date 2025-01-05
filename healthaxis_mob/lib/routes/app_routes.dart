// File: lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
// import '../pages/details/appointment_detail_page.dart';
import '../pages/details/patient_detail_page.dart';
import '../pages/details/area_detail_page.dart';
import '../pages/details/chatbot_detail_page.dart';
import '../pages/details/stock_tracking_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => HomePage(),
    // '/appointment-details': (context) => AppointmentDetailPage(
    //       appointment: ModalRoute.of(context)!.settings.arguments 
    //           as Map<String, dynamic>,
    //     ),
    '/patient-details': (context) => PatientDetailPage(),
    // '/area-details': (context) => AreaDetailPage(
    //       area: ModalRoute.of(context)!.settings.arguments 
    //           as Map<String, dynamic>,
    //     ),
    '/chatbot': (context) => ChatbotDetailPage(),
    // '/stock': (context) => const StockTrackingPage(),
  };
}