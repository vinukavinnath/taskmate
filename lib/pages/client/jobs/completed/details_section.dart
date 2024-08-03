import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/models/client_active_job_details_data.dart';

class Details extends StatefulWidget {
  // final String documentID;
  final String jobTitle;
  final String jobDescription;
  final String budgetField;
  final QueryDocumentSnapshot activeJobDoc;
  final String image1Url; // URL for image1
  final String image2Url; // URL for image2
  final String createdAt; // Add this parameter
  final String completeJobTime; // Add this parameter



  Details({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.budgetField,
    required this.activeJobDoc,
    required this.image1Url, // Add this parameter
    required this.image2Url, // Add this parameter
    required this.createdAt, // Add this parameter
    required this.completeJobTime,
    // required this.documentID,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final String imageUrl1;
  late final String imageUrl2;

  @override
  void initState() {
    super.initState();
    imageUrl1 = widget.activeJobDoc['image1Url'];
    imageUrl2 = widget.activeJobDoc['image2Url'];
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Given on: ${widget.createdAt}',
                      style: kTextStyle,
                    ),
                    Text(
                     'Completed on: ${widget.completeJobTime}',
                      style: kTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              widget.jobTitle,
              style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
            ),
            Text(
              'Title goes here...',
              style: kTextStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Description',
              style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
            ),
            Text(
              widget.jobDescription,
              style: kTextStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Price',
              style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
            ),
            Text(
              'Rs.${widget.budgetField}.00',
              style: kTextStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Your Attachments',
              style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AttachmentCard(
                      cardChild: Image.network(imageUrl1), // Display image1 using its URL
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: AttachmentCard(
                      cardChild: Image.network(imageUrl2), // Display image2 using its URL
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
