import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/localization/locales.dart';
import '../pages/client/jobs/active/client_active_job_card.dart';
import 'Send_Job_card.dart';

class SendMsg extends StatefulWidget {
  const SendMsg({Key? key}) : super(key: key);

  @override
  State<SendMsg> createState() => _SendMsgState();
}

class _SendMsgState extends State<SendMsg> {
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

    // Get the current user's UID
    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            _getTranslatedText('message'),
            style: kHeadingTextStyle,
          ),
        ),
        elevation: 0,
        flexibleSpace: Stack(
          children: [
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/noise_image.webp'),
          ),
        ),
        child: SizedBox(
          width: screenWidth,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No jobs found.'),
                );
              }

              final jobDocs = snapshot.data!.docs;

              return ListView(
                children: jobDocs.map<Widget>((doc) {
                  // Check if the job belongs to the current user
                  if (doc.id == userUid) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: doc.reference
                          .collection('jobsnew')
                          .where('status', whereIn: ['active', 'complete'])
                          .snapshots(),
                      builder: (context, subSnapshot) {
                        if (subSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!subSnapshot.hasData ||
                            subSnapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No jobs with status "active" or "complete" found'),
                          );
                        }

                        final jobDocs = subSnapshot.data!.docs;

                        return Column(
                          children: jobDocs.map<Widget>((subDoc) {
                            return SendJobCard(activeJobDoc: subDoc);
                          }).toList(),
                        );
                      },
                    );
                  } else {
                    return Container(); // If the job doesn't belong to the current user
                  }
                }).toList(),
              );
            },
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
