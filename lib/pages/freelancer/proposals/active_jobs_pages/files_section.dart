import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskmate/pages/freelancer/proposals/active_jobs_pages/receive_msg.dart';

import '../../../../components/snackbar.dart';

class Files extends StatefulWidget {
  final QueryDocumentSnapshot activeJobDoc;

  Files({
    Key? key,
    required this.activeJobDoc,
  }) : super(key: key);

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  File? _selectedImage3;
  File? _selectedImage4;

  Future<void> _pickImage3() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage3 = File(pickedFile.path); // Store the selected image
      });
    }
  }

  Future<void> _pickImage4() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage4 = File(pickedFile.path); // Store the selected image
      });
    }
  }

  Future<void> _uploadImagesToFirebase() async {
    if (_selectedImage3 != null && _selectedImage3 != null) {
      try {
        final FirebaseStorage storage = FirebaseStorage.instance;

        // Upload the first image
        final Reference ref1 = storage
            .ref()
            .child('files/${path.basename(_selectedImage3!.path)}');
        final UploadTask task1 = ref1.putFile(_selectedImage3!);

        // Upload the second image
        final Reference ref2 = storage
            .ref()
            .child('files/${path.basename(_selectedImage4!.path)}');
        final UploadTask task2 = ref2.putFile(_selectedImage4!);

        // Wait for both uploads to complete
        await Future.wait([
          task1.whenComplete(() => print('Image 1 uploaded')),
          task2.whenComplete(() => print('Image 2 uploaded'))
        ]);

        // After both images are uploaded, get the download URLs
        final String imageUrl1 = await ref1.getDownloadURL();
        final String imageUrl2 = await ref2.getDownloadURL();

        // Create a map with the data to update the Firestore document
        final Map<String, dynamic> updatedData = {
          'image3Url': imageUrl1,
          'image4Url': imageUrl2,
        };

        // Update the Firestore document using the reference to the activeJobDoc
        await widget.activeJobDoc.reference.update(updatedData);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Work submitted successfully.'),
        );

        // TODO: Add your additional logic here
      } catch (e) {
        print('Error uploading images: $e');
        // Handle errors here, e.g., show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Error submitting work: $e'),
        );
      }
    } else {
      // Handle case when one or both images are not selected
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar('Please select both images before submitting.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Submit work to get payment',
              style: kJobCardTitleTextStyle.copyWith(
                color: kJetBlack,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage3(); // Call the _pickImage1 function when tapped
                        },
                        child: AttachmentCard(
                          cardChild: _selectedImage3 == null
                              ? const Text('+ Add')
                              : Image(
                                  image: FileImage(
                                      _selectedImage3!), // Use FileImage
                                ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _selectedImage3 = null; // Reset selected image
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.delete,
                              color: kDarkGreyColor,
                            ),
                            Text(
                              'Delete',
                              style: kTextStyle,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage4(); // Call the _pickImage2 function when tapped
                        },
                        child: AttachmentCard(
                          cardChild: _selectedImage4 == null
                              ? const Text('+ Add')
                              : Image(
                                  image: FileImage(
                                      _selectedImage4!), // Use FileImage
                                ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _selectedImage4 = null; // Reset selected image
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.delete,
                              color: kDarkGreyColor,
                            ),
                            Text(
                              'Delete',
                              style: kTextStyle,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            DarkMainButton(
              title: 'Submit Work',
              process: () {
                if (_selectedImage3 == null || _selectedImage4 == null) {
                  // Show the snackbar with the error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar('Please select both images'),
                  );
                } else {
                  _uploadImagesToFirebase();
                }
              },
              screenWidth: screenWidth,
            ),
            LightMainButton(
              title: 'Message',
              process: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiveMsg(
                      activeJobDoc: widget.activeJobDoc, // Pass the activeJobDoc here

                    ),
                  ),
                );
              },
              screenWidth: screenWidth,
            )
          ],
        ),
      ),
    );
  }
}
