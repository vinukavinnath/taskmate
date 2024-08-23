import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/pages/client/jobs/pending/bidded_freelancer_details.dart';

class BiddedFreelancerCard extends StatelessWidget {
  final QueryDocumentSnapshot bidDoc;
  final String jobTitle;
  final QueryDocumentSnapshot pendingjobDoc;

  const BiddedFreelancerCard({
    Key? key,
    required this.bidDoc,
    required this.jobTitle,
    required this.pendingjobDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bidData = bidDoc.data() as Map<String, dynamic>;
    final String userDocId = bidData['UserUID'] ?? ''; // Provide a default value

    if (userDocId.isEmpty) {
      // Handle the case where userDocId is empty
      return Text('User ID is empty');
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('Users').doc(userDocId).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (userSnapshot.hasError) {
          return Text('Error: ${userSnapshot.error}');
        }

        final userData = userSnapshot.data?.data() as Map<String, dynamic>?;

        if (userData == null) {
          // Handle the case where user data is null (document doesn't exist)
          return Text('');
        }

        final String firstName = userData['username'] ?? '';
        final String lastName = userData['lastName'] ?? '';
        final String freelancerName = (firstName).trim().isEmpty ? 'Freelancer Name' : (firstName).trim();

        final String skills = userData['skills'] ?? '';
        final String profilePhotoUrl = userData['profilePhotoUrl'] ?? ''; // Add this line to get the profile photo URL
        final String Level = userData['Level'] ?? '';
        final String professionalRole = userData['professionalRole'] ?? '';
        final String bio = userData['bio'] ?? '';
        final String hourlyRate = userData['hourlyRate'] ?? '';

        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BiddedFreelancerDetails(
                  bidDescription: bidData['bidDescription'] ?? 'bidDescription',
                  bidAmount: bidData['bidAmount'] ?? 'bidAmount',
                  delivery: bidData['delivery'] ?? 'delivery',
                  reviewdesfreelancer: bidData['reviewdesfreelancer'] ?? 'reviewdesfreelancer',

                  jobTitle: jobTitle,
                  pendingJobDoc: pendingjobDoc,
                  freelancerName: freelancerName, // Pass freelancerName
                  skills: skills,
                  profilePhotoUrl: profilePhotoUrl,
                  Level: Level,
                  professionalRole: professionalRole,
                  bio: bio,
                  hourlyRate: hourlyRate,
                ),
              ),
            );
          },
          child: Ink(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: kDeepBlueColor),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundImage: profilePhotoUrl.isNotEmpty
                            ? NetworkImage(profilePhotoUrl) as ImageProvider<Object> // Explicitly specify the type
                            : AssetImage('images/blank_profile.webp') as ImageProvider<Object>, // Explicitly specify the type
                        radius: 35.0,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            freelancerName,
                            style: kJobCardTitleTextStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              bidData['bidDescription'] ?? 'bidDescription',
                              style: kTextStyle,
                            ),
                          ),
                          Text(
                            'LKR. ${bidData['bidAmount'] ?? 0.00}',
                            style: kUserDataGatherTitleTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
