import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/components/freelancer/user_data_gather_title.dart';
import 'package:taskmate/components/review_card.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/dashboard/freelancer/edit_profile.dart';
//import 'package:taskmate/messaging/Chatscreen.dart';

class BiddedFreelancerProfile extends StatefulWidget {
  final QueryDocumentSnapshot pendingJobDoc;
  final String jobTitle;
  final String reviewdesfreelancer;
  final String freelancerName;
  final String skills;
  final String profilePhotoUrl;
  final String Level;
  final String professionalRole;
  final String bio;
  final String hourlyRate;

  BiddedFreelancerProfile({
    Key? key,
    required this.jobTitle,
    required this.freelancerName,
    required this.skills,
    required this.profilePhotoUrl,
    required this.Level,
    required this.pendingJobDoc,
    required this.professionalRole,
    required this.reviewdesfreelancer,
    required this.bio,
    required this.hourlyRate,
  }) : super(key: key);

  @override
  State<BiddedFreelancerProfile> createState() =>
      _BiddedFreelancerProfileState();
}

class _BiddedFreelancerProfileState extends State<BiddedFreelancerProfile> {
  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfile(),
      ),
    );
  }

  void _navigateToBackward() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'images/noise_image.webp',
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: <Container>[
                      Container(
                        width: screenWidth,
                        height: screenHeight / 5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'images/cover_photo.webp',
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => Chatscreen(),
                            //         ),
                            //       );
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       elevation: 6.0,
                            //       backgroundColor: kAmberColor,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20.0),
                            //       ),
                            //     ),
                            //     child: const Text(
                            //       'Message',
                            //       style: TextStyle(
                            //         color: kDeepBlueColor,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 15,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _navigateToBackward,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.navigate_before,
                                  size: 35.0,
                                ),
                                Text('Back'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0, // Set the border width
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: widget.profilePhotoUrl.isNotEmpty
                          ? NetworkImage(widget.profilePhotoUrl)
                              as ImageProvider<
                                  Object> // Explicitly specify the type
                          : const AssetImage('images/blank_profile.webp')
                              as ImageProvider<
                                  Object>, // Explicitly specify the type
                      radius: 40,
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.freelancerName,
                      style: kSubHeadingTextStyle,
                    ),
                    Text(
                      widget.Level,
                      style: kTextStyle.copyWith(color: kOceanBlueColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Professional Role - ${widget.professionalRole}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: UserDataGatherTitle(
                            title: 'Hourly Rate : LKR.${widget.hourlyRate}',
                          ),
                        ),
                        const UserDataGatherTitle(title: 'Overview'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            widget.bio,
                            style: kTextStyle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            width: screenWidth / 1.2,
                            child: const Divider(
                              color: kDarkGreyColor,
                              thickness: 1.0,
                            ),
                          ),
                        ),
                        const UserDataGatherTitle(
                          title: 'Portfolio',
                        ),
                        SingleChildScrollView(
                          // Wrap this part
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35.0, 10.0, 10.0, 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Get the current user
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    final User? firebaseUser =
                                        _auth.currentUser;

                                    if (firebaseUser != null) {
                                      final String userUid = firebaseUser.uid;

                                      // Create a reference to the user's document
                                      final DocumentReference userDocRef =
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(userUid);

                                      // Fetch document with ID '1' from the subcollection 'portfolio_items'
                                      userDocRef
                                          .collection('portfolio_items')
                                          .doc(
                                              '1') // Use '1' as the document ID
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          final Map<String, dynamic>? data =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>?;
                                          final String title =
                                              data?['title'] ?? '';
                                          final String itemDescription =
                                              data?['item_description'] ?? '';
                                          final List<dynamic>? imageUrls =
                                              data?['image_urls'];

                                          // Check if imageUrls is not empty
                                          if (imageUrls != null &&
                                              imageUrls.isNotEmpty) {
                                            // Create a list of images for this portfolio item
                                            List<Widget> images = [];

                                            // Loop through the image URLs and add them to the list
                                            for (var imageUrl in imageUrls) {
                                              images.add(
                                                Image.network(
                                                  imageUrl,
                                                  width:
                                                      100, // Adjust the width as needed
                                                  height:
                                                      100, // Adjust the height as needed
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            List<Widget> imageRows = [];

                                            // Calculate the number of images per row
                                            int imagesPerRow =
                                                2; // You can change this value to the desired number

                                            // Create rows of images with spacing
                                            for (int i = 0;
                                                i < images.length;
                                                i += imagesPerRow) {
                                              List<Widget> rowChildren = [];

                                              // Add images to the current row
                                              for (int j = i;
                                                  j < i + imagesPerRow &&
                                                      j < images.length;
                                                  j++) {
                                                rowChildren.add(
                                                  Column(
                                                    children: [
                                                      images[j],
                                                      const SizedBox(height: 8.0),
                                                    ],
                                                  ),
                                                );

                                                if (j < i + imagesPerRow - 1) {
                                                  // Add spacing between images in the same row
                                                  rowChildren.add(
                                                    const SizedBox(width: 16.0),
                                                  );
                                                }
                                              }

                                              // Create a row with images and spacing
                                              imageRows.add(
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: rowChildren,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Container(
                                                    width:
                                                        600, // Adjust the width as needed
                                                    padding:
                                                        const EdgeInsets.all(16.0),
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/noise_image.webp'), // Add your background image here
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          title,
                                                          style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                            'Description: $itemDescription'),
                                                        const SizedBox(height: 16.0),
                                                        // Display the rows of images
                                                        Column(
                                                          children: imageRows,
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                kDeepBlueColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: const <
                                                                  Widget>[
                                                                Text(
                                                                  'Close',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kBrilliantWhite,
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          // Handle the case where the document with ID '1' does not exist
                                        }
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // You can set a placeholder image here
                                          // This will be shown until the actual image is loaded
                                          // You can also check if 'imageUrls' is not empty and use the first URL
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/taskmate_logo_light.webp', // Replace with your image URL
                                                width:
                                                    80, // Adjust the width as needed
                                                height:
                                                    100, // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              8.0), // Add spacing between the box and text
                                      Text(
                                        'Project 1',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35.0, 10.0, 10.0, 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Get the current user
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    final User? firebaseUser =
                                        _auth.currentUser;

                                    if (firebaseUser != null) {
                                      final String userUid = firebaseUser.uid;

                                      // Create a reference to the user's document
                                      final DocumentReference userDocRef =
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(userUid);

                                      // Fetch document with ID '1' from the subcollection 'portfolio_items'
                                      userDocRef
                                          .collection('portfolio_items')
                                          .doc(
                                              '2') // Use '2' as the document ID
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          final Map<String, dynamic>? data =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>?;
                                          final String title =
                                              data?['title'] ?? '';
                                          final String itemDescription =
                                              data?['item_description'] ?? '';
                                          final List<dynamic>? imageUrls =
                                              data?['image_urls'];

                                          // Check if imageUrls is not empty
                                          if (imageUrls != null &&
                                              imageUrls.isNotEmpty) {
                                            // Create a list of images for this portfolio item
                                            List<Widget> images = [];

                                            // Loop through the image URLs and add them to the list
                                            for (var imageUrl in imageUrls) {
                                              images.add(
                                                Image.network(
                                                  imageUrl,
                                                  width:
                                                      100, // Adjust the width as needed
                                                  height:
                                                      100, // Adjust the height as needed
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            List<Widget> imageRows = [];

                                            // Calculate the number of images per row
                                            int imagesPerRow =
                                                2; // You can change this value to the desired number

                                            // Create rows of images with spacing
                                            for (int i = 0;
                                                i < images.length;
                                                i += imagesPerRow) {
                                              List<Widget> rowChildren = [];

                                              // Add images to the current row
                                              for (int j = i;
                                                  j < i + imagesPerRow &&
                                                      j < images.length;
                                                  j++) {
                                                rowChildren.add(
                                                  Column(
                                                    children: [
                                                      images[j],
                                                      const SizedBox(height: 8.0),
                                                    ],
                                                  ),
                                                );

                                                if (j < i + imagesPerRow - 1) {
                                                  // Add spacing between images in the same row
                                                  rowChildren.add(
                                                    const SizedBox(width: 16.0),
                                                  );
                                                }
                                              }

                                              // Create a row with images and spacing
                                              imageRows.add(
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: rowChildren,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Container(
                                                    width:
                                                        600, // Adjust the width as needed
                                                    padding:
                                                        const EdgeInsets.all(16.0),
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/noise_image.webp'), // Add your background image here
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          title,
                                                          style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                            'Description: $itemDescription'),
                                                        const SizedBox(height: 16.0),
                                                        // Display the rows of images
                                                        Column(
                                                          children: imageRows,
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                kDeepBlueColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: const <
                                                                  Widget>[
                                                                Text(
                                                                  'Close',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kBrilliantWhite,
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          // Handle the case where the document with ID '1' does not exist
                                        }
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // You can set a placeholder image here
                                          // This will be shown until the actual image is loaded
                                          // You can also check if 'imageUrls' is not empty and use the first URL
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/taskmate_logo_light.webp', // Replace with your image URL
                                                width:
                                                    80, // Adjust the width as needed
                                                height:
                                                    100, // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              8.0), // Add spacing between the box and text
                                      Text(
                                        'Project 2',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35.0, 10.0, 10.0, 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Get the current user
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    final User? firebaseUser =
                                        _auth.currentUser;

                                    if (firebaseUser != null) {
                                      final String userUid = firebaseUser.uid;

                                      // Create a reference to the user's document
                                      final DocumentReference userDocRef =
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(userUid);

                                      // Fetch document with ID '1' from the subcollection 'portfolio_items'
                                      userDocRef
                                          .collection('portfolio_items')
                                          .doc(
                                              '3') // Use '3' as the document ID
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          final Map<String, dynamic>? data =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>?;
                                          final String title =
                                              data?['title'] ?? '';
                                          final String itemDescription =
                                              data?['item_description'] ?? '';
                                          final List<dynamic>? imageUrls =
                                              data?['image_urls'];

                                          // Check if imageUrls is not empty
                                          if (imageUrls != null &&
                                              imageUrls.isNotEmpty) {
                                            // Create a list of images for this portfolio item
                                            List<Widget> images = [];

                                            // Loop through the image URLs and add them to the list
                                            for (var imageUrl in imageUrls) {
                                              images.add(
                                                Image.network(
                                                  imageUrl,
                                                  width:
                                                      100, // Adjust the width as needed
                                                  height:
                                                      100, // Adjust the height as needed
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            List<Widget> imageRows = [];

                                            // Calculate the number of images per row
                                            int imagesPerRow =
                                                2; // You can change this value to the desired number

                                            // Create rows of images with spacing
                                            for (int i = 0;
                                                i < images.length;
                                                i += imagesPerRow) {
                                              List<Widget> rowChildren = [];

                                              // Add images to the current row
                                              for (int j = i;
                                                  j < i + imagesPerRow &&
                                                      j < images.length;
                                                  j++) {
                                                rowChildren.add(
                                                  Column(
                                                    children: [
                                                      images[j],
                                                      const SizedBox(height: 8.0),
                                                    ],
                                                  ),
                                                );

                                                if (j < i + imagesPerRow - 1) {
                                                  // Add spacing between images in the same row
                                                  rowChildren.add(
                                                    const SizedBox(width: 16.0),
                                                  );
                                                }
                                              }

                                              // Create a row with images and spacing
                                              imageRows.add(
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: rowChildren,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Container(
                                                    width:
                                                        600, // Adjust the width as needed
                                                    padding:
                                                        const EdgeInsets.all(16.0),
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/noise_image.webp'), // Add your background image here
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          title,
                                                          style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                            'Description: $itemDescription'),
                                                        const SizedBox(height: 16.0),
                                                        // Display the rows of images
                                                        Column(
                                                          children: imageRows,
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                kDeepBlueColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: const <
                                                                  Widget>[
                                                                Text(
                                                                  'Close',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kBrilliantWhite,
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          // Handle the case where the document with ID '1' does not exist
                                        }
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // You can set a placeholder image here
                                          // This will be shown until the actual image is loaded
                                          // You can also check if 'imageUrls' is not empty and use the first URL
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/taskmate_logo_light.webp', // Replace with your image URL
                                                width:
                                                    80, // Adjust the width as needed
                                                height:
                                                    100, // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              8.0), // Add spacing between the box and text
                                      Text(
                                        'Project 3',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35.0, 10.0, 10.0, 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Get the current user
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    final User? firebaseUser =
                                        _auth.currentUser;

                                    if (firebaseUser != null) {
                                      final String userUid = firebaseUser.uid;

                                      // Create a reference to the user's document
                                      final DocumentReference userDocRef =
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(userUid);

                                      // Fetch document with ID '1' from the subcollection 'portfolio_items'
                                      userDocRef
                                          .collection('portfolio_items')
                                          .doc(
                                              '4') // Use '4' as the document ID
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          final Map<String, dynamic>? data =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>?;
                                          final String title =
                                              data?['title'] ?? '';
                                          final String itemDescription =
                                              data?['item_description'] ?? '';
                                          final List<dynamic>? imageUrls =
                                              data?['image_urls'];

                                          // Check if imageUrls is not empty
                                          if (imageUrls != null &&
                                              imageUrls.isNotEmpty) {
                                            // Create a list of images for this portfolio item
                                            List<Widget> images = [];

                                            // Loop through the image URLs and add them to the list
                                            for (var imageUrl in imageUrls) {
                                              images.add(
                                                Image.network(
                                                  imageUrl,
                                                  width:
                                                      100, // Adjust the width as needed
                                                  height:
                                                      100, // Adjust the height as needed
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            List<Widget> imageRows = [];

                                            // Calculate the number of images per row
                                            int imagesPerRow =
                                                2; // You can change this value to the desired number

                                            // Create rows of images with spacing
                                            for (int i = 0;
                                                i < images.length;
                                                i += imagesPerRow) {
                                              List<Widget> rowChildren = [];

                                              // Add images to the current row
                                              for (int j = i;
                                                  j < i + imagesPerRow &&
                                                      j < images.length;
                                                  j++) {
                                                rowChildren.add(
                                                  Column(
                                                    children: [
                                                      images[j],
                                                      const SizedBox(height: 8.0),
                                                    ],
                                                  ),
                                                );

                                                if (j < i + imagesPerRow - 1) {
                                                  // Add spacing between images in the same row
                                                  rowChildren.add(
                                                    const SizedBox(width: 16.0),
                                                  );
                                                }
                                              }

                                              // Create a row with images and spacing
                                              imageRows.add(
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: rowChildren,
                                                ),
                                              );
                                            }

                                            // Display the portfolio item in a dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Container(
                                                    width:
                                                        600, // Adjust the width as needed
                                                    padding:
                                                        const EdgeInsets.all(16.0),
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/noise_image.webp'), // Add your background image here
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          title,
                                                          style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                            'Description: $itemDescription'),

                                                        const SizedBox(height: 16.0),
                                                        // Display the rows of images
                                                        Column(
                                                          children: imageRows,
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                kDeepBlueColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: const <
                                                                  Widget>[
                                                                Text(
                                                                  'Close',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kBrilliantWhite,
                                                                    fontSize:
                                                                        15.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          // Handle the case where the document with ID '1' does not exist
                                        }
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // You can set a placeholder image here
                                          // This will be shown until the actual image is loaded
                                          // You can also check if 'imageUrls' is not empty and use the first URL
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/taskmate_logo_light.webp', // Replace with your image URL
                                                width:
                                                    80, // Adjust the width as needed
                                                height:
                                                    100, // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              8.0), // Add spacing between the box and text
                                      Text(
                                        'Project 4',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            width: screenWidth / 1.2,
                            child: const Divider(
                              color: kDarkGreyColor,
                              thickness: 1.0,
                            ),
                          ),
                        ),
                        const UserDataGatherTitle(
                          title: 'Reviews',
                        ),
                        const ReviewCard(
                          imagePath: 'images/woman.jpg',
                          jobTitle: 'My face edited into a picture',
                          feedback:
                              'Great! Very creative and had great ideas! ',
                          username: 'Nimali de Zoysa',
                        ),
                        const ReviewCard(
                          imagePath:
                              'images/41bde2fdf20f4375ad5e353ff96daedd.jpg',
                          jobTitle: 'A Logo for my Investing Club',
                          feedback:
                              'He was able to take some general ideas of what I wanted and turn '
                              'them into an easily recognizable logo.',
                          username: 'Kapila Silva',
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                        //   child: DarkMainButton(
                        //       title: 'Edit Profile',
                        //       process: _navigateToEditProfile,
                        //       screenWidth: screenWidth),
                        // )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
