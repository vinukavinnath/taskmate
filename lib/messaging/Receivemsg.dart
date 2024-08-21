import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:taskmate/messaging/Receive_job_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveMsg extends StatefulWidget {
  @override
  State<ReceiveMsg> createState() => _ReceiveMsgState();
}

class _ReceiveMsgState extends State<ReceiveMsg> {
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
            repeat: ImageRepeat.repeat,
            image: AssetImage('images/noise_image.webp'),
          ),
        ),
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

            return ListView.builder(
              itemCount: jobDocs.length,
              itemBuilder: (context, index) {
                final doc = jobDocs[index];
                return StreamBuilder<QuerySnapshot>(
                  stream: doc.reference.collection('jobsnew').where('status',
                      whereIn: ['active', 'complete']).snapshots(),
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
                        child: Text(
                            'No jobs with status "active" or "complete" found'),
                      );
                    }

                    final jobDocs = subSnapshot.data!.docs;

                    return Column(
                      children: jobDocs.map<Widget>((subDoc) {
                        return ReceiveJobCard(activeJobDoc: subDoc);
                      }).toList(),
                    );
                  },
                );
              },
            );
          },
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
