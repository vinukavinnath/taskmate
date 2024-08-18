import 'package:flutter/material.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskmate/dashboard/scan_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/localization/locales.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  String? _languageCode;
  void shareApp() async {
    final result = await Share.shareWithResult(
        'Be a proud member of TaskMate Family! https://tinyurl.com/5n6dapka',
        subject: 'Download TaskMate Now!');
    if (result.status == ShareResultStatus.success) {}
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
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
          title:  Text(
            _getTranslatedText('ivt_ttl'),
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                   Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Text(
                        _getTranslatedText('ivt_des'),
                      textAlign: TextAlign.center,
                      style: kJobCardTitleTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset('images/playstore.png'),
                  ),
                  SizedBox(
                    width: screenWidth,
                    child: DarkMainButton(
                      title: _getTranslatedText('ivt_btn1'),
                      process: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ScanQR(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: SizedBox(
                      width: screenWidth,
                      child: LightMainButton(
                        title: _getTranslatedText('ivt_btn2'),
                        process: shareApp,
                      ),
                    ),
                  ),
                ],
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
