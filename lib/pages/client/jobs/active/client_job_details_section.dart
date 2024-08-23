import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/constants.dart';

class ClientJobDetails extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String budgetField;
  final QueryDocumentSnapshot activeJobDoc;
  final String image1Url;
  final String image2Url;
  final String createdAt;

  const ClientJobDetails({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.budgetField,
    required this.activeJobDoc,
    required this.image1Url,
    required this.image2Url,
    required this.createdAt,
  });

  @override
  State<ClientJobDetails> createState() => _ClientJobDetailsState();
}

class _ClientJobDetailsState extends State<ClientJobDetails> {
  late final String? imageUrl1;
  late final String? imageUrl2;

  @override
  void initState() {
    super.initState();
    imageUrl1 = widget.activeJobDoc['image1Url'];
    imageUrl2 = widget.activeJobDoc['image2Url'];
  }

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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Given in: ${widget.createdAt}',
                style: kTextStyle,
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
            'LKR.${widget.budgetField}',
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
                  child: imageUrl1 != null && imageUrl1!.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _showFullScreenImage(imageUrl1!),
                          child: AttachmentCard(
                            cardChild: Image.network(imageUrl1!),
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                            'Attachment 1 was not submitted',
                            textAlign: TextAlign.center,
                            style: kUserDataGatherTitleTextStyle.copyWith(color: kWarningRedColor),
                          ),
                      ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: imageUrl2 != null && imageUrl2!.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _showFullScreenImage(imageUrl2!),
                          child: AttachmentCard(
                            cardChild: Image.network(imageUrl2!),
                          ),
                        )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'Attachment 2 was not submitted',
                          textAlign: TextAlign.center,
                          style: kUserDataGatherTitleTextStyle.copyWith(color: kWarningRedColor),
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
