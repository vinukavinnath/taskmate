import 'package:flutter/material.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  String? _languageCode;

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  void composeEmail() async {
    final url = Uri.encodeFull('mailto:helpme.taskmate@gmail.com');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            backColor: kWarningRedColor,
            time: 3,
            title: 'Couldn\'t send the mail.',
            icon: null,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _loadLanguagePreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _getTranslatedText('hlp_ttl'),
            style: kHeadingTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 4,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.navigate_before,
              color: kDeepBlueColor,
            ),
          ),
          flexibleSpace: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'images/noise_image.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              Text(
                _getTranslatedText('hlp_des'),
                style: kTextStyle,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: composeEmail,
                child: const Text(
                  'helpme.taskmate@gmail.com',
                  style: TextStyle(color: kDeepBlueColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTranslatedText(String key) {
    Map<String, dynamic> localizedText =
        _languageCode == 'en' ? LocalData.EN : LocalData.SI;
    return localizedText[key] ??
        key; // Fallback to the key if the translation is not found
  }
}
