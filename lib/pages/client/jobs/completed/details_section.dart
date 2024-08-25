import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/constants.dart';

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

  const Details({
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

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    imageUrl1 = widget.activeJobDoc['image1Url'];
    imageUrl2 = widget.activeJobDoc['image2Url'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            'Title',
            style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
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
                  child: imageUrl1 != null && imageUrl1.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _showFullScreenImage(imageUrl1),
                          child: AttachmentCard(
                            cardChild: Image.network(imageUrl1),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'Attachment 1 was not submitted',
                            textAlign: TextAlign.center,
                            style: kUserDataGatherTitleTextStyle.copyWith(
                                color: kWarningRedColor),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: imageUrl2 != null && imageUrl2.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _showFullScreenImage(imageUrl2),
                          child: AttachmentCard(
                            cardChild: Image.network(imageUrl2),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'Attachment 2 was not submitted',
                            textAlign: TextAlign.center,
                            style: kUserDataGatherTitleTextStyle.copyWith(
                                color: kWarningRedColor),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
