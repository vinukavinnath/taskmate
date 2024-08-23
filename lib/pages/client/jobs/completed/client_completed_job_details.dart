import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';

import 'package:taskmate/pages/client/jobs/completed/details_section.dart';
import 'package:taskmate/pages/client/jobs/completed/files_section.dart';
import 'package:taskmate/pages/client/jobs/completed/payments_section.dart';
import 'package:taskmate/pages/client/jobs/completed/reviews_section.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientCompletedJobDetails extends StatefulWidget {
  // final String documentID;
  final String jobTitle; // Add this parameter
  final String jobDescription;
  final String budgetField;
  final QueryDocumentSnapshot completeJobDoc;
  final String image1Url; // URL for image1
  final String image2Url; // URL for image2
  final String image3Url; // URL for image1
  final String image4Url; // URL for image2
  final String createdAt; // Add this parameter
  final String completeJobTime; // Add this parameter


  const ClientCompletedJobDetails({
    super.key,
    required this.jobTitle, // Add this parameter
    required this.jobDescription,
    required this.budgetField,
    required this.completeJobDoc,
    required this.image1Url,
    required  this.image2Url,
    required  this.image3Url,
    required  this.image4Url,
    required this.createdAt,
    required this.completeJobTime,    // required this.documentID,
  });


  @override
  State<ClientCompletedJobDetails> createState() => _ClientCompletedJobDetailsState();
}

class _ClientCompletedJobDetailsState extends State<ClientCompletedJobDetails> {
  int activeJobItemIndex = 0;
  String? _languageCode;

  void _onToggle(int? index) {
    setState(() {
      activeJobItemIndex = index!;
    });
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
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
        activeJobDoc: widget.completeJobDoc,
        image1Url: widget.image1Url, // Pass the URL of image1
        image2Url: widget.image2Url, // Pass the URL of image2
        createdAt: widget.createdAt, // Pass the createdAt value
        completeJobTime:widget.completeJobTime,

        //documentID: widget.documentID,
      ),
       Files(
         image3Url: widget.image3Url,
         image4Url: widget.image4Url,
         completeJobDoc: widget.completeJobDoc,
       ),
       Payments(
         budgetField: widget.budgetField,
         completeJobDoc: widget.completeJobDoc,
       ),
       Reviews(
         completeJobDoc: widget.completeJobDoc,
       ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
            _getTranslatedText('comple_jbs'),
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
