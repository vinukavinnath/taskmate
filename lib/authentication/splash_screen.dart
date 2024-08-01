import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/authentication/language_selection.dart';
import 'package:taskmate/authentication/root_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String image = 'images/TaskMateLogo_Dark.webp';

  Future<void> loadImage(String imageUrl) async {
    try {
      await precacheImage(AssetImage(image), context);
    } catch (e) {
      //Ignored
    }
  }

  @override
  void initState() {
    super.initState();
    loadImage(image);

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');

    Timer(const Duration(seconds: 4), () {
      if (languageCode == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LanguageSelectionScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RootPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F9),
        body: Center(
          child: Image(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}