import 'package:flutter/material.dart';
import 'pages/splash/splash_screen.dart';
import 'pages/home/home_page.dart';
// import 'routes/app_routes.dart';
// import '../pages/details/appointment_detail_page.dart';
import '../pages/details/patient_detail_page.dart';
import '../pages/details/area_detail_page.dart';
import '../pages/details/chatbot_detail_page.dart';
import '../pages/details/stock_tracking_page.dart';

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
        '/chatbot': (context) => ChatbotDetailPage(),
        '/stock': (context) => StockTrackingPage(),
        '/patient': (context) => PatientDetailPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => HomePage());
      },
    );
  }
}
