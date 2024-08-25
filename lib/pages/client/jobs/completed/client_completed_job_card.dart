import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/pages/client/jobs/completed/client_completed_job_details.dart';

class ClientCompletedJobCard extends StatefulWidget {
  const ClientCompletedJobCard({
    // required this.documentID,
    Key? key,
    required this.completeJobDoc,
  }) : super(key: key);

  // final String documentID;
  final QueryDocumentSnapshot completeJobDoc;
  @override
  State<ClientCompletedJobCard> createState() => _ClientCompletedJobCardState();
}

class _ClientCompletedJobCardState extends State<ClientCompletedJobCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final subData = widget.completeJobDoc.data() as Map<String, dynamic>;
    final jobTitle = subData['jobTitle'] as String;
    Timestamp? createdAtTimestamp = subData['createdAt'] as Timestamp?;
    String createdAt = '';
    final jobDescription = subData['jobDescription'] as String;
    final budgetField = subData['budget'];
    String budget = '0.0'; // Initialize with a default value
    final completeJobTimeField = subData['CompleteJobTime'];
    String completeJobTimeString = '';

    if (completeJobTimeField is Timestamp) {
      DateTime completeJobDateTime = completeJobTimeField.toDate();
      completeJobTimeString =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(completeJobDateTime);
    } else if (completeJobTimeField is String) {
      // Assuming CompleteJobTime is stored as a string
      completeJobTimeString = completeJobTimeField;
    }

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
            builder: (context) => ClientCompletedJobDetails(
              jobTitle: jobTitle, // Pass the jobTitle
              budgetField: budget, // Pass the budget
              jobDescription: jobDescription,
              completeJobDoc: widget.completeJobDoc,
              image1Url: imageUrl1, // Pass the URL of image1
              image2Url: imageUrl2, // Pass the URL of image2),
              image3Url: imageUrl3,
              image4Url: imageUrl4,
              createdAt: createdAt, // Pass the createdAt value
              completeJobTime:
                  completeJobTimeString, // Pass the CompleteJobTime value
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: kDeepBlueColor, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed on ${completeJobTimeString.toString()} ',
                  style: kTextStyle,
                ),
                const Icon(
                  Icons.arrow_circle_right,
                  color: kDeepBlueColor,
                  size: 25.0,
                ),
              ],
            ),
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
                // const Text(
                //   'From FreelancerName',
                //   style: kJobCardDescriptionTextStyle,
                // ),
                Text(
                  'Budget LKR.${budget.toString()}',
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
