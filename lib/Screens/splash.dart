import 'dart:async';
import 'package:apna_vaidya_task/Screens/signin_screen.dart';
import 'package:apna_vaidya_task/Screens/swap_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String LOGINKEY = "isLogin";
  static const String NAME = "userName";

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), whereToGo);
  }

  void whereToGo() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(LOGINKEY);

    if (isLoggedIn != null && isLoggedIn == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xFFE5E2EB),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
              child: Text(
            'Apna Vaidya',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7E57C2),
            ),
          )),
        ));
  }
}
