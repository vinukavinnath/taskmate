import 'package:flutter/material.dart';
import 'dart:async';

import 'package:taskmate/authentication/get_started.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GetStarted(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child:  Scaffold(
        backgroundColor: Color(0xFFF4F7F9),
        body: Center(
          child: Image(
            image: AssetImage('images/TaskMateLogo_Dark.webp'),
          ),
        ),
      ),
    );
  }
}
