import 'package:flutter/material.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/maintenance_page.dart';

import 'package:taskmate/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/home_page.dart';

class JobDetails extends StatefulWidget {
  final String? documentID;
  const JobDetails({super.key, required this.documentID});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  // final _formKey = GlobalKey<FormState>();
  // final _describeBidController = TextEditingController();

  void congratulateOnPlaceBid() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MaintenancePage(
          [
            const Image(
              image: AssetImage('images/success.webp'),
            ),
            const Text(
              'Congratulations!',
              style: kSubHeadingTextStyle,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'You’ve successfully placed a bid.',
                style: kTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            DarkMainButton(
                title: 'Try Another Project',
                process: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                screenWidth: MediaQuery.of(context).size.width)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('available_projects')
        .doc(widget.documentID);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Job Details',
            style: kHeadingTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: kDeepBlueColor,
            ),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: userDocRef.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                //Overall Job Card flows through here
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/noise_image.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            '${data['title']}',
                            textAlign: TextAlign.center,
                            style: kJobCardTitleTextStyle,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'LKR. ${data['budget']}',
                            style: kJobCardDescriptionTextStyle,
                          ),
                          const Text('Remaining time goes here'),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Description',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              '${data['description']}',
                              style: kJobCardDescriptionTextStyle,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Attachments',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Divider(
                              thickness: 3.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Place a Bid on this Project',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Divider(
                              thickness: 3.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Describe your Bid',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: const [
                                    Text(
                                      'Bid Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text('Textfield goes here'),
                                  ],
                                ),
                                Column(
                                  children: const [
                                    Text(
                                      'Delivered within',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text('Textfield goes here'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DarkMainButton(
                        process: () {
                          congratulateOnPlaceBid();
                        },
                        title: 'Place Bid',
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                );
              }
              return const Text('Loading....');
            }),
      ),
    );
  }
}
