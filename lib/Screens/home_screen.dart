import 'package:apna_vaidya_task/Screens/signin_screen.dart';
import 'package:apna_vaidya_task/Screens/splash.dart';
import 'package:apna_vaidya_task/Screens/swap_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInitials();
  }

  void _loadInitials() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    name = sharedPref.getString(SplashScreenState.NAME);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade400,
          title: const Text(
            'Apna Vaidya',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(color: Colors.white),
            tabs: [
              Tab(
                text: 'Swap',
              ),
              Tab(text: 'Create'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SwapScreen(),
            CreateScreen(),
          ],
        ),
      ),
    );
  }
}
