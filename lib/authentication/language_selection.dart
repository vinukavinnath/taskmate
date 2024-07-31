// language_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/authentication/root_page.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => selectLanguage(context, 'en'),
              child: Text('English'),
            ),
            ElevatedButton(
              onPressed: () => selectLanguage(context, 'si'),
              child: Text('සිංහල'),
            ),
          ],
        ),
      ),
    );
  }
}
