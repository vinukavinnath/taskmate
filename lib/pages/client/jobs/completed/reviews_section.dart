import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/models/completed_job_details_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reviews extends StatefulWidget {
  final QueryDocumentSnapshot completeJobDoc;


  const Reviews({
    required this.completeJobDoc,

    // required this.documentID,
    Key? key,
  }) : super(key: key);
  // final String documentID;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  late double clientRating;
  late double freelancerRating;

  @override
  void initState() {
    super.initState();
    clientRating = widget.completeJobDoc['starclient']?.toDouble() ?? 0.0;
    clientRating = clientRating.roundToDouble();

    freelancerRating = widget.completeJobDoc['starfreelancer']?.toDouble() ?? 0.0;
    freelancerRating = freelancerRating.roundToDouble();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Extract review data from the document snapshot
    String clientReview = widget.completeJobDoc['reviewdesclient'] ?? '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Review from Freelancer',
                    style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
                  ),
                ),
                Text(
                  '${widget.completeJobDoc['reviewdesfreelancer']}',
                  style: kTextStyle,
                ),
                SizedBox(
                  height: 16.0,
                ),
                RatingBar.builder(
                  initialRating: freelancerRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5, // Fixed total number of stars
                  itemSize: 30.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) {
                    return Icon(
                      Icons.star,
                      color: index < freelancerRating ? Colors.amber : Colors.grey, // Color based on the rating
                    );
                  },
                  onRatingUpdate: (rating) {},
                ),
                Divider(
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text(
                    'Your Review',
                    style: kJobCardTitleTextStyle.copyWith(color: kJetBlack),
                  ),
                ),
                Text(
                  clientReview,
                  style: kTextStyle,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // Display colored stars based on the actual rating value
                RatingBar.builder(
                  initialRating: clientRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5, // Fixed total number of stars
                  itemSize: 30.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) {
                    return Icon(
                      Icons.star,
                      color: index < clientRating ? Colors.amber : Colors.grey, // Color based on the rating
                    );
                  },
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
