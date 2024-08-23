import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:taskmate/pages/freelancer/proposals/active_jobs_pages/details_section.dart';
import 'package:taskmate/pages/freelancer/proposals/active_jobs_pages/files_section.dart';
import 'package:taskmate/pages/freelancer/proposals/active_jobs_pages/payments_section.dart';
import 'package:taskmate/pages/freelancer/proposals/active_jobs_pages/reviews_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ActiveJobDetails extends StatefulWidget {
  // final String documentID;
  final String jobTitle; // Add this parameter
  final String jobDescription;
  final String budgetField;
  final QueryDocumentSnapshot activeJobDoc;
  final String image1Url; // URL for image1
  final String image2Url; // URL for image2
  final String createdAt; // Add this parameter


  ActiveJobDetails({
    super.key,
    required this.jobTitle, // Add this parameter
     required this.jobDescription,
    required this.budgetField,
     required this.activeJobDoc,
    required this.image1Url,
    required  this.image2Url,
    required this.createdAt,
    // required this.documentID,
  });

  @override
  State<ActiveJobDetails> createState() => _ActiveJobDetailsState();
}

class _ActiveJobDetailsState extends State<ActiveJobDetails> {
  int activeJobItemIndex = 0;
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

  void _onToggle(int? index) {
    setState(() {
      activeJobItemIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final List activeJobItems = [
      Details(
        jobTitle: widget.jobTitle,
        jobDescription : widget.jobDescription,
        budgetField: widget.budgetField,
        activeJobDoc: widget.activeJobDoc,
        image1Url: widget.image1Url, // Pass the URL of image1
        image2Url: widget.image2Url, // Pass the URL of image2
        //documentID: widget.documentID,
        createdAt:widget.createdAt,
          ),
      Files(activeJobDoc: widget.activeJobDoc), // Pass the activeJobDoc
      Payments( budgetField: widget.budgetField,activeJobDoc: widget.activeJobDoc),
      Reviews(activeJobDoc: widget.activeJobDoc),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
            _getTranslatedText('activ_jbs'),
            style: kHeadingTextStyle,
          ),
          elevation: 4.0,
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ToggleSwitch(
                  activeBgColor: const [kOceanBlueColor],
                  activeFgColor: kDeepBlueColor,
                  inactiveBgColor: kLightBlueColor,
                  inactiveFgColor: kOceanBlueColor,
                  cornerRadius: 10.0,
                  radiusStyle: true,
                  minWidth: screenWidth,
                  minHeight: 50.0,
                  initialLabelIndex: activeJobItemIndex,
                  totalSwitches: 4,
                  customTextStyles: const [
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                  ],
                  animate: true,
                  curve: Curves.ease,
                  labels: const ['Details', 'Files', 'Payments', 'Reviews'],
                  onToggle: _onToggle,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: screenWidth,
                    child: activeJobItems[activeJobItemIndex],
                  ),
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

