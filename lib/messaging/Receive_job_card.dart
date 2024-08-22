import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/constants.dart';
import '../pages/freelancer/proposals/active_jobs_pages/receive_msg.dart';
import 'Freelancer_Complete_Jobs_receive_msg.dart';

class ReceiveJobCard extends StatefulWidget {
  const ReceiveJobCard({
    Key? key,
    required this.activeJobDoc,
  }) : super(key: key);

  final QueryDocumentSnapshot activeJobDoc;

  @override
  _ReceiveJobCardState createState() => _ReceiveJobCardState();
}

class _ReceiveJobCardState extends State<ReceiveJobCard> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final subData = widget.activeJobDoc.data() as Map<String, dynamic>;
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
    String imageUrl1 = subData['imageUrl1'] ?? '';
    String imageUrl2 = subData['imageUrl2'] ?? '';

    if (createdAtTimestamp != null) {
      DateTime createdAtDateTime = createdAtTimestamp.toDate();
      createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtDateTime);
    }

    String status = subData['status'] ?? '';

    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: () {
            if (status == 'active') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReceiveMsg(
                    activeJobDoc: widget.activeJobDoc,
                    jobtitle: jobTitle,
                  ),
                ),
              );
            } else if (status == 'complete') {
              ScaffoldMessenger.of(context).showSnackBar(
                CusSnackBar(
                  backColor: kSuccessGreenColor,
                  time: 3,
                  title: 'You\'ve Completed this Job',
                  icon: Icons.task,
                ),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
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
                    Text(
                      status.toUpperCase(),
                      style: status == 'complete'
                          ? kUserDataGatherTitleTextStyle.copyWith(
                              color: kOceanBlueColor)
                          : kUserDataGatherTitleTextStyle.copyWith(
                              color: kSuccessGreenColor),
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
              Positioned(
                top: 8.0,
                right: 8.0,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: kWarningRedColor),
                  onPressed: () async {
                    setState(
                      () {
                        isVisible = false;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
