import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/pages/client/jobs/active/client_active_job_details.dart';

class ClientActiveJobCard extends StatefulWidget {
  ClientActiveJobCard({
    // required this.documentID,
    Key? key,
    required this.activeJobDoc,
  }) : super(key: key);

  final QueryDocumentSnapshot activeJobDoc;
  // final String documentID;

  @override
  State<ClientActiveJobCard> createState() => _ClientActiveJobCardState();
}

class _ClientActiveJobCardState extends State<ClientActiveJobCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final subData = widget.activeJobDoc.data() as Map<String, dynamic>;
    final jobTitle = subData['jobTitle'] as String;
    Timestamp? createdAtTimestamp = subData['createdAt'] as Timestamp?;
    String createdAt = '';
    final jobDescription = subData['jobDescription'] as String;
    final budgetField = subData['budget'];
    final jobID = subData['JobID'];
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

    if (createdAtTimestamp != null) {
      DateTime createdAtDateTime = createdAtTimestamp.toDate();
      createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtDateTime);
    }
    String imageUrl1 = subData['imageUrl1'] ??
        ''; // Replace 'imageUrl1' with the actual field name
    String imageUrl2 = subData['imageUrl2'] ??
        ''; // Replace 'imageUrl2' with the actual field name
    String imageUrl3 = subData['imageUrl3'] ?? '';
    String imageUrl4 = subData['imageUrl4'] ?? '';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientActiveJobDetails(
              jobTitle: jobTitle, // Pass the jobTitle
              budgetField: budget, // Pass the budget
              jobDescription: jobDescription,
              activeJobDoc: widget.activeJobDoc,
              image1Url: imageUrl1, // Pass the URL of image1
              image2Url: imageUrl2, // Pass the URL of image2),
              image3Url: imageUrl3,
              image4Url: imageUrl4,
              createdAt: createdAt, // Pass the createdAt value
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: kDeepBlueColor, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jobTitle,
                    style: kJobCardTitleTextStyle,
                  ),
                  const Icon(
                    Icons.arrow_circle_right,
                    color: kDeepBlueColor,
                    size: 25.0,
                  ),
                ],
              ),
            ),
            Text(
              'Job ID: #$jobID',
              style: kTextStyle,
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
