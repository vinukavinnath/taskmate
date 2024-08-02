// language_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/authentication/root_page.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/constants.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> setLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  void selectLanguage(BuildContext context, String languageCode) async {
    await setLanguage(languageCode);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RootPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Choose Your Preferred Language',style: kHeadingTextStyle,textAlign: TextAlign.center,),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48.0),
                child: Image(
                  image: AssetImage('images/language.webp'),
                ),
              ),
              DarkMainButton(
                  title: 'English',
                  process: () {
                    selectLanguage(context, 'en');
                  },screenWidth: screenWidth,),
              LightMainButton(
                  title: 'සිංහල',
                  process: () {
                    selectLanguage(context, 'si');
                  },screenWidth: screenWidth,)
            ],
          ),
        ),
      ),
    );
  }
}
