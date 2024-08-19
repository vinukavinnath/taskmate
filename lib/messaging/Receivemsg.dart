import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/messaging/Receive_job_card.dart';

class ReceiveMsg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Received Jobs"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
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

              return ListView.builder(
                itemCount: jobDocs.length,
                itemBuilder: (context, index) {
                  final doc = jobDocs[index];
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
      ),
    );
  }
}
