import 'package:flutter/material.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:taskmate/pages/client/jobs/active/client_active_jobs.dart';
import 'package:taskmate/pages/client/jobs/completed/client_completed_jobs.dart';
import 'package:taskmate/pages/client/jobs/pending/client_pending_jobs.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientJobStatus extends StatefulWidget {
  const ClientJobStatus({super.key});

  @override
  State<ClientJobStatus> createState() => _ClientJobStatusState();
}

class _ClientJobStatusState extends State<ClientJobStatus> {
  int itemIndex = 0;
  String? _languageCode;

  final List _proposalItems =  [
    ClientPendingJobs(),
    ClientActiveJobs(),
    ClientCompletedJobs(),
  ];

  void _onToggle(int? index) {
    setState(() {
      itemIndex = index!;
    });
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
          centerTitle: true,
          title: Text(
            _getTranslatedText('jobs'),
            style: kHeadingTextStyle,
          ),
          elevation: 0,
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
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ToggleSwitch(
                  activeBgColor: const [kOceanBlueColor],
                  activeFgColor: kDeepBlueColor,
                  inactiveBgColor: kLightBlueColor,
                  inactiveFgColor: kOceanBlueColor,
                  cornerRadius: 10.0,
                  radiusStyle: true,
                  minWidth: screenWidth,
                  minHeight: 50.0,
                  initialLabelIndex: itemIndex,
                  totalSwitches: 3,
                  animate: true,
                  curve: Curves.fastLinearToSlowEaseIn,
                  customTextStyles: const [
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                  ],
                  labels: const ['Pending', 'Active', 'Completed'],
                  onToggle: _onToggle,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _proposalItems[itemIndex],
                  ],
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
