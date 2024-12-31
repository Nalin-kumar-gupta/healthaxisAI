import 'package:flutter/material.dart';
import 'pages/splash/splash_screen.dart';
import 'pages/home/home_page.dart';
import 'pages/details/detail_page.dart';

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
        '/': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/details': (context) => DetailPage(),
      },
    );
  }
}
