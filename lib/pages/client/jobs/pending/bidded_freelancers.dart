import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:taskmate/pages/client/jobs/pending/bidded_freelancer_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiddedFreelancers extends StatefulWidget {
  final QueryDocumentSnapshot pendingjobDoc;
  final String jobTitle;

  const BiddedFreelancers({
    Key? key,
    required this.pendingjobDoc,
    required this.jobTitle,
  }) : super(key: key);

  @override
  State<BiddedFreelancers> createState() => _BiddedFreelancersState();
}

class _BiddedFreelancersState extends State<BiddedFreelancers> {
  late CollectionReference bidsCollection;
  String? _languageCode;

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    bidsCollection = widget.pendingjobDoc.reference.collection('bidsjobs');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
            _getTranslatedText('proposal'),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                FutureBuilder<QuerySnapshot>(
                  future: bidsCollection.get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Process and display your data here
                    List<QueryDocumentSnapshot> bidDocuments =
                        snapshot.data?.docs ?? [];

                    if (bidDocuments.isEmpty) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('gifs/sand_wait.gif'),
                             Text(
                              _getTranslatedText('no_prp_yet'),
                              style: kHeadingTextStyle,
                            ),
                             Text(
                              _getTranslatedText('still_luck'),
                              style: kUserDataGatherTitleTextStyle,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView(
                          children: bidDocuments.map((bidDoc) {
                            return BiddedFreelancerCard(
                              bidDoc: bidDoc,
                              jobTitle: widget.jobTitle,
                              pendingjobDoc: widget.pendingjobDoc,
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
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
