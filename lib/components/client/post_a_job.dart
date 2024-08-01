import 'package:flutter/material.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:taskmate/pages/client/client_post_job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostAJob extends StatefulWidget {
  const PostAJob({
    // required this.client,
    super.key,
  });

  // final UserModel1 client;

  @override
  State<PostAJob> createState() => _PostAJobState();
}

class _PostAJobState extends State<PostAJob> {
  String? _languageCode;

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      padding: const EdgeInsets.all(8.0),
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 1.0,
          color: kDeepBlueColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              _getTranslatedText('clnt_pstd_crd_ttl'),
              style: kJobCardTitleTextStyle.copyWith(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Text(
              _getTranslatedText('clnt_pstd_crd_des'),
              style: kTextStyle.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          DarkMainButton(
            title: _getTranslatedText('clnt_pstd_crd_btn'),
            process: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ClientPostJob(
                      // client: widget.client,
                      ),
                ),
              );
            },
            screenWidth: screenWidth,
          ),
        ],
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
