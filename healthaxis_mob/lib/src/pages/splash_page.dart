import 'package:flutter/material.dart';
// import 'package:healthaxis_mob/src/pages/bottomNavigation/dashboard_screen.dart';
// import 'package:healthaxis_mob/src/pages/bottomNavigation/doctor_dashboard_screen.dart';
// import 'package:healthaxis_mob/src/pages/login_page.dart';
import 'package:healthaxis_mob/src/theme/color_resources.dart';
import 'package:healthaxis_mob/src/theme/text_styles.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key); // Use null safety

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? id; // Use null safety
  String? userType;

  @override
  void initState() {
    super.initState();
    // getCustomerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/doctor_face.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorResources.themered,
                      ColorResources.themered.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              Image.asset(
                "assets/heartbeat.png",
                color: Colors.white,
                height: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Your health",
                style: TextStyles.h1Style.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                "By Pakiza Technovation",
                style: TextStyles.bodySm.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(flex: 7),
            ],
          ),
        ],
      ),
    );
  }

  // void getCustomerInfo() async {
  //   final SharedPreferences customerInfo = await SharedPreferences.getInstance();

  //   setState(() {
  //     id = customerInfo.getString('id');
  //     userType = customerInfo.getString('userType');
  //   });

  //   // Navigate after a short delay
  //   await Future.delayed(const Duration(seconds: 2));

  //   if (id != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => userType == 'Patient'
  //             ? const DashboardScreen()
  //             : const DoctorDashboardScreen(),
  //       ),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const LoginPage()),
  //     );
  //   }
  // }
}
