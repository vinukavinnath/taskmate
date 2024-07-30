import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:taskmate/pages/client/jobs/pending/client_pending_job_card.dart';

class ClientPendingJobs extends StatefulWidget {
  const ClientPendingJobs({Key? key}) : super(key: key);

  @override
  State<ClientPendingJobs> createState() => _ClientPendingJobsState();
}

class _ClientPendingJobsState extends State<ClientPendingJobs> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get the current user's UID
    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: SizedBox(
          width: screenWidth,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .doc(userUid) // Use userUid here if the document ID is the user's UID
                .collection('jobsnew')
                .where('status', isEqualTo: 'new')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Hmm! You\'ve no any pending Jobs!'),
                );
              }
              final jobDocs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: jobDocs.length,
                itemBuilder: (context, index) {
                  final document = jobDocs[index];
                  final docId = document.id;
                  final data = document.data() as Map<String, dynamic>;
                  return ClientPendingJobCard(pendingjobDoc: jobDocs[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

