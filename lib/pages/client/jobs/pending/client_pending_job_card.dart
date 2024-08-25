import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/pages/client/jobs/pending/bidded_freelancers.dart';

class ClientPendingJobCard extends StatefulWidget {
  ClientPendingJobCard({
    Key? key,
    required this.pendingjobDoc,
  }) : super(key: key);

  final QueryDocumentSnapshot pendingjobDoc;

  @override
  State<ClientPendingJobCard> createState() => _ClientPendingJobCardState();
}

class _ClientPendingJobCardState extends State<ClientPendingJobCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final subData = widget.pendingjobDoc.data() as Map<String, dynamic>;
    final jobTitle = subData['jobTitle'] as String;
    Timestamp? createdAtTimestamp = subData['createdAt'] as Timestamp?;
    String createdAt = '';
    final budget = int.tryParse(subData['budget'].toString() ?? '0') ?? 0;
    final bidsCollection =
        widget.pendingjobDoc.reference.collection('bidsjobs');

    if (createdAtTimestamp != null) {
      DateTime createdAtDateTime = createdAtTimestamp.toDate();
      createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAtDateTime);
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BiddedFreelancers(
              pendingjobDoc: widget.pendingjobDoc,
              jobTitle: jobTitle,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      jobTitle,
                      style: kJobCardTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    'Budget LKR.${budget.toString()}',
                    style: kJobCardDescriptionTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Posted on: ${createdAt}',
                    style: kJobCardDescriptionTextStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: bidsCollection.get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final numBids = snapshot.data?.docs.length ?? 0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Proposals: $numBids',
                            style: kJobCardDescriptionTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kDeepBlueColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.navigate_next,
              size: 35.0,
            ),
          ],
        ),
      ),

    );
  }
}
