import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/models/active_job_details_data.dart';
import 'package:taskmate/components/attachment_card.dart';

class Details extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String budgetField;
  final QueryDocumentSnapshot completeJobDoc;
  final String image1Url; // URL for image1
  final String image2Url; // URL for image2
  final String createdAt;
  final String completeJobTime; // Add this parameter

  const Details({
    Key? key,
    required this.jobTitle,
    required this.jobDescription,
    required this.budgetField,
    required this.completeJobDoc,
    required this.image1Url,
    required this.image2Url,
    required this.createdAt,
    required this.completeJobTime,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final String imageUrl1;
  late final String imageUrl2;

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    imageUrl1 = widget.completeJobDoc['image1Url'];
    imageUrl2 = widget.completeJobDoc['image2Url'];
  }

  /// Custom method to display an image in full-screen with a black background

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
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
                      'Recieved on: ${widget.createdAt}',
                      style: kTextStyle,
                    ),
                    Text(
                      'Completed on: ${widget.completeJobTime}',
                      style: kTextStyle,
                    ),
                  ],
                )
              ],
            ),
            Text(
              'Title',
              style: kJobCardTitleTextStyle.copyWith(
                color: kJetBlack,
              ),
            ),
            Text(
              widget.jobTitle,
              style: kTextStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Description',
              style: kJobCardTitleTextStyle.copyWith(
                color: kJetBlack,
              ),
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
              style: kJobCardTitleTextStyle.copyWith(
                color: kJetBlack,
              ),
            ),
            Text(
              widget.budgetField,
              style: kTextStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Attachments',
              style: kJobCardTitleTextStyle.copyWith(
                color: kJetBlack,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: imageUrl1 != null && imageUrl1!.isNotEmpty
                        ? GestureDetector(
                      onTap: () => _showFullScreenImage(context,imageUrl1!),
                      child: AttachmentCard(
                        cardChild: Image.network(imageUrl1!),
                      ),
                    )
                        : Text(
                      'No Attachment 1 Available',
                      style: kTextStyle.copyWith(color: kWarningRedColor),
                    ),
                  ),

                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: imageUrl2 != null && imageUrl2!.isNotEmpty
                        ? GestureDetector(
                      onTap: () => _showFullScreenImage(context,imageUrl2!),
                      child: AttachmentCard(
                        cardChild: Image.network(imageUrl2!),
                      ),
                    )
                        : Text(
                      'No Attachment 2 Available',
                      style: kTextStyle.copyWith(color: kWarningRedColor),
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
