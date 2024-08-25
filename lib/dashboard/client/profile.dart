import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/freelancer/user_data_gather_title.dart';
import 'package:taskmate/components/review_card.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/dashboard/client/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/localization/locales.dart';



class Profile extends StatefulWidget {

  // final UserModel1 client; // Add this line
  // final String? downloadUrl;

  const Profile({
    // required this.client,
    // this.downloadUrl,
    super.key
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userId = '';

  String? _languageCode;

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }


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

  Future<Map<String, dynamic>> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    // Define the Firestore collection, document ID, and fields you want to retrieve.
    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Clients')
        .doc(userId)
        .get();

    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return data;
  }

  @override
  void initState() {
    _loadLanguagePreference();
    super.initState();
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
                              // widget.downloadUrl ??
                                  'images/cover_photo.webp', // Use ?? to provide a default image
                            ),
                          ),
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
                              children: [
                                const Icon(
                                  Icons.navigate_before,
                                  size: 35.0,
                                ),
                                Text(_getTranslatedText('bck'),),
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
                    child: FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${snapshot.data?['profilePhotoUrl']}',
                            ),
                            radius: 40,
                          );
                        } else {
                          return const SpinKitFadingCircle(
                            color: kDeepBlueColor,
                            size: 30.0,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            '${snapshot.data?['firstName']} ${snapshot.data?['lastName']}',
                            style: kSubHeadingTextStyle,
                          );
                        } else {
                          return const SpinKitThreeBounce(
                            color: kDeepBlueColor,
                            size: 30.0,
                          );
                        }
                      },

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
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 16.0),
                            width: screenWidth / 1.2,
                            child: const Divider(
                              color: kDarkGreyColor,
                              thickness: 1.0,
                            ),
                          ),
                        ),
                         UserDataGatherTitle(
                          title: _getTranslatedText('rws'),
                        ),
                        const ReviewCard(
                          imagePath: 'images/freelancer0.webp',
                          jobTitle: 'Graphic designer for family care product',
                          feedback:
                              'Great! Very creative and had great ideas! ',
                          username: 'Nalin Perera',
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: DarkMainButton(
                              title: _getTranslatedText('edt_prf'),
                              process: _navigateToEditProfile,
                              screenWidth: screenWidth),
                        )
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
  String _getTranslatedText(String key) {
    Map<String, dynamic> localizedText =
    _languageCode == 'en' ? LocalData.EN : LocalData.SI;
    return localizedText[key] ??
        key; // Fallback to the key if the translation is not found
  }
}
