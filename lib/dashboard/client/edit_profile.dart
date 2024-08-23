import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/freelancer/user_data_gather_title.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/components/review_card.dart';
import 'package:taskmate/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/localization/locales.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // final _formKey = GlobalKey<FormState>();
  // final TextEditingController professionalRoleController =
  //     TextEditingController();

  String userId = '';
  String? _languageCode;
  final picker = ImagePicker();
  late String _imageUrl;

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  Future<void> fetchImageURL() async {
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Clients')
          .doc(userId)
          .get();

      // Get the current image URL
      setState(() {
        _imageUrl = userDoc['photoUrl'] ??
            ''; // If 'photoUrl' doesn't exist, set it to an empty string
      });
    } catch (e) {
      //Ignored
    }
  }

  Future<void> updateImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            backColor: kSuccessGreenColor,
            time: 5,
            title: _getTranslatedText('uploading'),
            icon: Icons.upload,
          ),
        );
      }

      // Upload the selected file to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
      UploadTask uploadTask = ref.putData(File(file.path!).readAsBytesSync());

      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      // Update the Firestore document with the new image URL
      await FirebaseFirestore.instance
          .collection('Clients')
          .doc(userId)
          .update({'profilePhotoUrl': downloadUrl});

      setState(() {
        _imageUrl = downloadUrl; // Update the image URL in the UI
      });
    }
  }

  void _navigateBackwards() {
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
                              'images/cover_photo.webp',
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const <Widget>[],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 15,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    //alignment: Alignment.center,
                    children: [
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kBrilliantWhite,
                          ),
                          child: IconButton(
                            onPressed: updateImage,
                            icon: const Icon(
                              Icons.add_photo_alternate,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Good Morning!',
                    //   style:
                    //       kJobCardTitleTextStyle.copyWith(color: kAmberColor),
                    // ),
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
                    const SizedBox(
                      height: 10.0,
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
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            width: screenWidth / 1.2,
                            child: const Divider(
                              color: kDarkGreyColor,
                              thickness: 1.0,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            _getTranslatedText('cng_prf_phot'),
                            style: kTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: LightMainButton(
                                  title: _getTranslatedText('cancel'),
                                  process: _navigateBackwards,
                                ),
                              ),
                              Expanded(
                                child: DarkMainButton(
                                  title: _getTranslatedText('save'),
                                  process: () {
                                    // if (_formKey.currentState!.validate()) {
                                    // Form is valid, proceed with submission or other actions
                                    _navigateBackwards();
                                    // }
                                    //TODO Implement Save feature
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
