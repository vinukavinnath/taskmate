import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/pages/client/jobs/completed/client_completed_job_card.dart';

class ClientCompletedJobs extends StatefulWidget {
  const ClientCompletedJobs({Key? key}) : super(key: key);

  @override
  State<ClientCompletedJobs> createState() => _ClientCompletedJobsState();
}

class _ClientCompletedJobsState extends State<ClientCompletedJobs> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get the current user's UID
    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    return Expanded(
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
              child: Text('No documents found.'),
            );
          }

          final jobDocs = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: jobDocs.map<Widget>((doc) {
                // Check if the job belongs to the current user
                if (doc.id == userUid) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: doc.reference
                        .collection('jobsnew')
                        .where('status', isEqualTo: 'complete')
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
                          child: Text('No completed jobs found'),
                        );
                      }

                      final activeJobDocs = subSnapshot.data!.docs;

                      return Column(
                        children: activeJobDocs.map<Widget>((subDoc) {
                          return ClientCompletedJobCard(
                              completeJobDoc: subDoc);
                        }).toList(),
                      );
                    },
                  );
                } else {
                  return Container(); // If the job doesn't belong to the current user
                }
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
