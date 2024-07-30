import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for FirebaseAuth
import 'package:taskmate/constants.dart';
import 'package:taskmate/pages/freelancer/job_details.dart';

class JobCard extends StatelessWidget {
  final QueryDocumentSnapshot mostjobDoc;
  final double screenWidth;

  JobCard({
    Key? key,
    required this.mostjobDoc,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subData = mostjobDoc.data() as Map<String, dynamic>;

    // Get the current user's UID
    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetails(
              mostjobDoc: mostjobDoc,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 9.0,
        ),
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: kDeepBlueColor,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subData['jobTitle'] ?? '',
              style: kJobCardTitleTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Budget LKR.${subData['budget']}',
                    style: kJobCardDescriptionTextStyle,
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('jobs')
                        .doc(userUid) // Use userUid here
                        .collection('jobsnew')
                        .doc(mostjobDoc.id)
                        .collection('bidsjobs')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        int numBids = snapshot.data!.docs.length;
                        return Text(
                          '$numBids Bids ',
                          style: kJobCardDescriptionTextStyle,
                        );
                      } else {
                        return const Text(
                          'Loading...',
                          style: kJobCardDescriptionTextStyle,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            FadeTransition(
              opacity: const AlwaysStoppedAnimation(.8),
              child: Text(
                subData['jobDescription'] ?? '',
                style: kJobCardDescriptionTextStyle,
                maxLines: 4,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
