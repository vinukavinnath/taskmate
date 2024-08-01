import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:taskmate/components/client/post_a_job.dart';
import 'package:taskmate/constants.dart';
// import 'package:taskmate/profile/client/user_model1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:taskmate/pages/client/jobs/pending/client_pending_job_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientPosted extends StatefulWidget {
  const ClientPosted({
    super.key,

    // required this.client,
  });

  // final UserModel1 client; // Add this line

  @override
  State<ClientPosted> createState() => _ClientPostedState();
}

class _ClientPostedState extends State<ClientPosted> {
  bool isJobsAvailable = true;
  String userId = '';
  String? _languageCode;

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  Future<Map<String, dynamic>> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    // Define the Firestore collection, document ID, and fields you want to retrieve.
    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Clients')
        .doc(userId)
        .get();

    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return data;
  }

  // Future<void> fetchJobs() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('jobs')
  //       .doc('49tc6QmGVxgxZGxwjk8ArXJkPnw1')
  //       .collection('jobsnew')
  //       .where('status', isEqualTo: 'new')
  //       .get();
  //
  //   if (querySnapshot.docs.isEmpty) {
  //     setState(() {
  //       isJobsAvailable = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    _loadLanguagePreference();

    // if (FirebaseFirestore.instance
    //         .collection('jobs')
    //         .doc(userId)
    //         .collection('jobsnew')
    //         .where('status', isEqualTo: 'new')
    //         .get() ==
    //     0) {
    //   setState(() {
    //     isJobsAvailable = false;
    //   });
    // }
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    // String? userUid = FirebaseAuth.instance.currentUser?.uid;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          width: screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 60.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              _getTranslatedText('clnt_pstd_ttl'),
                  style: kJobCardTitleTextStyle.copyWith(color: kDarkGreyColor),
                ),
                FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data?['firstName']} ${snapshot.data?['lastName']}',
                        style: kSubHeadingTextStyle,
                      );
                    } else {
                      return const SpinKitThreeBounce(
                        color: kDeepBlueColor,
                        size: 30.0,
                      );
                    }
                  },
                ),
                // isJobsAvailable == true
                //     ?
                // Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const Text('Your Posting'),
                //             const Divider(),
                //             Expanded(
                //               child: StreamBuilder<
                //                   QuerySnapshot<Map<String, dynamic>>>(
                //                 stream: FirebaseFirestore.instance
                //                     .collection('jobs')
                //                     .doc('49tc6QmGVxgxZGxwjk8ArXJkPnw1')
                //                     .collection('jobsnew')
                //                     .where('status', isEqualTo: 'new')
                //                     .snapshots(),
                //                 builder: (context, snapshot) {
                //                   if (snapshot.connectionState ==
                //                       ConnectionState.waiting) {
                //                     return const Center(
                //                       child: CircularProgressIndicator(),
                //                     );
                //                   }
                //                   if (!snapshot.hasData ||
                //                       snapshot.data!.docs.isEmpty) {
                //                     setState(() {
                //                       isJobsAvailable = false;
                //                     });
                //                     //   const Center(
                //                     //   child: Text('Hmm! You\'ve no any pending Jobs!'),
                //                     // );
                //                   }
                //                   final jobDocs = snapshot.data!.docs;
                //                   return ListView.builder(
                //                     itemCount: jobDocs.length,
                //                     itemBuilder: (context, index) {
                //                       final document = jobDocs[index];
                //                       final docId = document.id;
                //                       final data = document.data()
                //                           as Map<String, dynamic>;
                //                       return ClientPendingJobCard(
                //                           pendingjobDoc: jobDocs[index]);
                //                     },
                //                   );
                //                 },
                //               ),
                //             ),
                //           ],
                //
                //         ),
                //       )
                //     :
                const PostAJob(),
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
