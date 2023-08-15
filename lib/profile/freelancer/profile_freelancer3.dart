import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskmate/profile/freelancer/data_details_screen_freelancer.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer2.dart';
import 'package:taskmate/profile/freelancer/upload_profile_image.dart';
import 'package:taskmate/profile/freelancer/user_model.dart';
import 'package:taskmate/profile/freelancer/user_repository.dart';

class ProfileFreelancer3 extends StatefulWidget {
  const ProfileFreelancer3({Key? key}) : super(key: key);

  @override
  _ProfileFreelancer3State createState() => _ProfileFreelancer3State();
}

class _ProfileFreelancer3State extends State<ProfileFreelancer3> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController sociallinkController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController professionalRoleController = TextEditingController();
  final TextEditingController hourlyrateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? profileImageUrl;
  String? selectedGender;
  String? selectedProvince;
  String? selectedImagePath;
  String? selectedImagePath1;
  String? selectedImagePath2;
  String? selectedFilePath;
  String? selectedSkills;
  bool dataSubmitted = false;

  Future<void> _uploadFile(String filePath, String filename, String fileType) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }
    try {
      Reference storageRef = _storage.ref().child('files/${user.uid}/$filename');
      await storageRef.putFile(File(filePath));

      String downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('files').add({
        'userId': user.uid,
        'filename': filename,
        'fileType': fileType,
        'downloadUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        selectedFilePath = filePath;
      });
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      final String downloadUrl = await uploadProfileImage(imageFile);

      setState(() {
        profileImageUrl = downloadUrl;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // Add margin to the container,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/noise_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),

                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_left,size: 66),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileFreelancer2()),); },),
                              SizedBox(width: 55), // Add spacing between the icon and text
                              Text(
                                "Set Up Your",
                                style: TextStyle(
                                  color: Color(0xFF16056B), // Use your color code here
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,),),],),

                          SizedBox(height: 2),
                          Center(
                            child :Text(
                              "Freelancer Profile",
                              style: TextStyle(
                                color: Color(0xFF16056B), // You can use the same or a different color code
                                fontSize: 25.0, // Adjust the font size as needed
                                fontWeight: FontWeight.bold, ),),),
                          SizedBox(height:12),

                          Column(
                            children : [
                              Padding(
                                padding: const EdgeInsets.all(16.0), // Add padding around the Column
                                child:TextFormField(
                                  controller: sociallinkController,
                                  decoration: InputDecoration(
                                    label: Text('Add portfolio link'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(color: Color(0xFF4B4646)),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xF4F7F9),
                                    labelStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B4646),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter URL ';}
                                    final urlPattern = RegExp(
                                        r"^(https?://)?([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(/\S*)?$",
                                      caseSensitive: false,
                                      multiLine: false,
                                    );
                                    if (!urlPattern.hasMatch(value)) {
                                      return 'Please enter a valid URL';
                                    }
                                    return null;
                                  },),),],),


                          SizedBox(height: 10),

                          SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Add Portfolio Items',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B4646),
                                  ),
                                ),
                                SizedBox(height: 14),

                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF4B4646),),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],);
                                    if (result != null) {
                                      PlatformFile file = result.files.first;

                                      // Check the file type and handle accordingly
                                      if (file.extension == 'pdf') {
                                        // Handle PDF file
                                        print('Selected PDF: ${file.name}');
                                      } else if (file.extension == 'jpg' ||
                                          file.extension == 'jpeg' ||
                                          file.extension == 'png') {
                                        // Handle image file
                                        print('Selected Image: ${file.name}');
                                        setState(() {
                                          selectedImagePath1 = file.path;});}}},
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: selectedImagePath1 != null
                                        ? Image.file(
                                      File(selectedImagePath1!),
                                      fit: BoxFit.cover,
                                    ): Center(
                                    child: Text(
                                      '+ Add',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF4B4646), ),),),),),),],),
                                SizedBox(height: 14),

                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFF4B4646),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],);
                                          if (result != null) {
                                            PlatformFile file = result.files.first;

                                            // Check the file type and handle accordingly
                                            if (file.extension == 'pdf') {
                                              // Handle PDF file
                                              print('Selected PDF: ${file.name}');
                                            } else if (file.extension == 'jpg' ||
                                                file.extension == 'jpeg' ||
                                                file.extension == 'png') {
                                              // Handle image file
                                              print('Selected Image: ${file.name}');
                                              setState(() {
                                                selectedImagePath2 = file.path;});}}},
                                        child: Container(
                                          width: double.infinity,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black, width: 2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: selectedImagePath2!= null
                                              ? Image.file(
                                            File(selectedImagePath2!),
                                            fit: BoxFit.cover,
                                          ): Center(
                                            child: Text(
                                              '+ Add',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF4B4646), ),),),),),),],),
                                SizedBox(height: 14),

                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFF4B4646),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],);
                                          if (result != null) {
                                            PlatformFile file = result.files.first;

                                            // Check the file type and handle accordingly
                                            if (file.extension == 'pdf') {
                                              // Handle PDF file
                                              print('Selected PDF: ${file.name}');
                                            } else if (file.extension == 'jpg' ||
                                                file.extension == 'jpeg' ||
                                                file.extension == 'png') {
                                              // Handle image file
                                              print('Selected Image: ${file.name}');
                                              setState(() {
                                                selectedImagePath = file.path;});}}},
                                        child: Container(
                                          width: double.infinity,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black, width: 2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: selectedImagePath != null
                                              ? Image.file(
                                            File(selectedImagePath!),
                                            fit: BoxFit.cover,
                                          ): Center(
                                            child: Text(
                                              '+ Add',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF4B4646), ),),),),),),],),
                                SizedBox(height: 130),


                                Positioned(
                                  bottom: 20, // Adjust the position as needed
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      List<String?> imagePaths = [selectedImagePath, selectedImagePath1, selectedImagePath2];

                                      for (String? imagePath in imagePaths) {
                                        if (imagePath != null) {
                                          File selectedFile = File(imagePath);

                                          // Upload the file to Firebase Cloud Storage
                                          final storageRef = FirebaseStorage.instance.ref();
                                          final task = storageRef.child('uploads/${DateTime.now().millisecondsSinceEpoch}${selectedFile.path}').putFile(selectedFile);

                                          // Get the download URL after the upload is complete
                                          final snapshot = await task.whenComplete(() {});
                                          final downloadUrl = await snapshot.ref.getDownloadURL();

                                          // Store the download URL and other information in Firestore
                                          final user = FirebaseAuth.instance.currentUser;
                                          if (user != null) {
                                            await FirebaseFirestore.instance.collection('files').add({
                                              'userId': user.uid,
                                              'filename': selectedFile.path.split('/').last, // Extracts the file name from the path
                                              'fileType': selectedFile.path.split('.').last, // Extracts the file extension from the path
                                              'downloadUrl': downloadUrl,
                                              'timestamp': FieldValue.serverTimestamp(),
                                            });
                                          }
                                        }
                                      }

                                      // Clear all selected image paths
                                      setState(() {
                                        selectedImagePath = null;
                                        selectedImagePath1 = null;
                                        selectedImagePath2 = null;
                                      });
                                    },
                                    child: Text('Save & Next',
                                      style: TextStyle(fontSize: 13), // Adjust the font size as needed
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF16056B), // Change the background color
                                      onPrimary: Colors.white,    // Change the text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13), // Adjust the border radius as needed
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 138, vertical: 15), ),
                                  ),
                                ),

                              ],










                      ),




                    ),
                  ],
                    ),
                    ),
    ),

                ),
              ),
              ],

          ),
    ),
      ),
        );





  }
}


