import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmate/client_home_page.dart';

import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/components/loading_screen.dart';
import 'dart:io';
import 'package:taskmate/profile/client/user_model1.dart';
import 'package:taskmate/constants.dart';

class ProfileClientAddphoto extends StatefulWidget {
  final UserModel1 client;

  const ProfileClientAddphoto({Key? key, required this.client})
      : super(key: key);

  @override
  _ProfileClientAddphotoState createState() => _ProfileClientAddphotoState();
}

class _ProfileClientAddphotoState extends State<ProfileClientAddphoto> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController professionalRoleController =
      TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  String? profileImageUrl;
  String? selectedGender;
  String? selectedProvince;
  String? selectedSkills;
  bool dataSubmitted = false;

  bool isLoading = false;

  List<String> selectedServices = [];
  File? selectedImage;

  String? get existingUserId => null;

  void updateData() {
    if (formKey.currentState!.validate()) {
      setState(() {
        dataSubmitted = true;
      });
    }
  }

  void _chooseAPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Upload image to Firebase Storage and get the download URL

      // Refresh the UI if needed
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  void _takeAPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  void _submitDetails() async {
    setState(() {
      isLoading = true;
    });
    // Upload image to Firebase Storage and get the download URL
    final String downloadUrl =
        await uploadImageToFirebaseStorage(selectedImage!);

    // Get the current user's UID from Firebase Authentication
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      // Use the user's UID as the Firestore document ID
      final userId = user.uid;

      // Create a Firestore document and save the data with the user's UID as the document ID
      await FirebaseFirestore.instance
          .collection('Clients')
          .doc(userId) // Use the user's UID as the document ID
          .set({
        'firstName': widget.client.firstName,
        'lastName': widget.client.lastName,
        'address': widget.client.address,
        'zipcode': widget.client.zipcode,
        'street': widget.client.street,
        'birthday': widget.client.birthday,
        'gender': widget.client.gender,
        'province': widget.client.province,
        'city': widget.client.city,
        'phoneNo': widget.client.phoneNo,
        'email': widget.client.email,
        // 'password': widget.client.password,
        'professionalRole': widget.client.professionalrole,
        'profilePhotoUrl': downloadUrl,
      });
      setState(() {
        isLoading = false;
      });

      // Navigate back to the previous page or any other page
      if (context.mounted) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => ClientHomePage(
        //       passedIndex: 1,
        //
        //         // client: widget.client,
        //         // downloadUrl: downloadUrl,
        //         // selectedIndex: 1,
        //         ),
        //   ),
        // );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ClientHomePage(
                    passedIndex: 1,
                  )),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: !isLoading
          ? Scaffold(
              body: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/noise_image.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Add a Profile Photo',
                          style: kHeadingTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        radius: 150,
                        backgroundColor: Colors.transparent,
                        backgroundImage: selectedImage != null
                            ? FileImage(
                                selectedImage!) // Display selected/captured image
                            : profileImageUrl != null
                                ? NetworkImage(profileImageUrl!)
                                : const AssetImage(
                                        'images/iconamoon_profile-circle-thin.png')
                                    as ImageProvider<Object>,
                      ),
                    ),
                    DarkMainButton(
                      title: 'Choose a Photo from Gallery',
                      process: _chooseAPhoto,
                      screenWidth: screenWidth,
                    ),
                    LightMainButton(
                      title: 'Take a Photo',
                      process: _takeAPhoto,
                      screenWidth: screenWidth,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    DarkMainButton(
                      title: 'Submit',
                      process: _submitDetails,
                      screenWidth: screenWidth,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            )
          : const LoadingScreen(title: 'Uploading Photo . . .'),
    );
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;

      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      return '';
    }
  }
}
