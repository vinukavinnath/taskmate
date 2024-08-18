import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/pages/client/jobs/active/client_active_job_details.dart';

import '../pages/client/jobs/active/client_active_jobs_sendmsg.dart';
import '../pages/freelancer/proposals/active_jobs_pages/receive_msg.dart';
import 'Client_Complete_Jobs_send_msg.dart';
import 'Freelancer_Complete_Jobs_receive_msg.dart';

class ReceiveJobCard extends StatelessWidget {
  const ReceiveJobCard({
    Key? key,
    required this.activeJobDoc,
  }) : super(key: key);

  final QueryDocumentSnapshot activeJobDoc;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final subData = activeJobDoc.data() as Map<String, dynamic>;
    final jobTitle = subData['jobTitle'] as String;
    Timestamp? createdAtTimestamp = subData['createdAt'] as Timestamp?;
    String createdAt = '';
    final jobDescription = subData['jobDescription'] as String;
    final budgetField = subData['budget'];
    String budget = '0.0'; // Initialize with a default value

    if (budgetField is int) {
      budget = budgetField.toString(); // Convert int to string
    } else if (budgetField is double) {
      budget = budgetField.toString(); // Convert double to string
    } else if (budgetField is String) {
      double? parsedBudget = double.tryParse(budgetField);
      if (parsedBudget != null) {
        budget = parsedBudget.toString();
      }
    }
    String imageUrl1 = subData['imageUrl1'] ?? ''; // Replace 'imageUrl1' with the actual field name
    String imageUrl2 = subData['imageUrl2'] ?? ''; // Replace 'imageUrl2' with the actual field name

    if (createdAtTimestamp != null) {
      DateTime createdAtDateTime = createdAtTimestamp.toDate();
      createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtDateTime);
    }

    String status = subData['status'] ?? ''; // Assuming you have 'status' field

    return InkWell(
      onTap: () {
        if (status == 'active') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReceiveMsg(
                activeJobDoc: activeJobDoc,
              ),
            ),
          );
        } else if (status == 'complete') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FreelancerCompleteJobsReceiveMsg(
                activeJobDoc: activeJobDoc,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                jobTitle,
                style: kJobCardTitleTextStyle,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget LKR.${budget.toString()}',
                  style: kJobCardDescriptionTextStyle,
                ),
                Text(
                  createdAt,
                  style: kJobCardDescriptionTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
