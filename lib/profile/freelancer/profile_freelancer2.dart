import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskmate/profile/freelancer/data_details_screen_freelancer.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer3.dart';
import 'package:taskmate/profile/freelancer/upload_profile_image.dart';
import 'package:taskmate/profile/freelancer/user_model.dart';
import 'package:taskmate/profile/freelancer/user_repository.dart';

class ProfileFreelancer2 extends StatefulWidget {
  const ProfileFreelancer2({Key? key}) : super(key: key);

  @override
  _ProfileFreelancer2State createState() => _ProfileFreelancer2State();
}

class _ProfileFreelancer2State extends State<ProfileFreelancer2> {
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

  String? profileImageUrl;
  String? selectedGender;
  String? selectedProvince;
  String? selectedSkills;
  bool dataSubmitted = false;

  String existingUserId = "your_existing_user_id";

  List<String> selectedServices = [];


  void updateData() {
    if (formKey.currentState!.validate()) {
      // Validated successfully, update the data
      // Update the data using the values in the text controllers
      // You can use the values to update the user's profile, save it to a database, etc.

      setState(() {
        dataSubmitted =
        true; // Set the flag to indicate data has been submitted
      });
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
                                icon: Icon(Icons.keyboard_arrow_left, size: 66),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProfileFreelancer()),);
                                },),
                              SizedBox(width: 55),
                              // Add spacing between the icon and text
                              Text(
                                "Set Up Your",
                                style: TextStyle(
                                  color: Color(0xFF16056B),
                                  // Use your color code here
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,),),
                            ],),

                          SizedBox(height: 2),
                          Center(
                            child: Text(
                              "Freelancer Profile",
                              style: TextStyle(
                                color: Color(0xFF16056B),
                                // You can use the same or a different color code
                                fontSize: 25.0,
                                // Adjust the font size as needed
                                fontWeight: FontWeight.bold,),),),
                          SizedBox(height: 12),

                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 186.0),
                                        // Add padding around the Column
                                        child: TextFormField(
                                          controller: hourlyrateController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}?$'))
                                          ],
                                          decoration: InputDecoration(
                                            label: Text('Hourly rate'),
                                            prefixText: 'LKR. ',
                                            suffixText: '/hour',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(13),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF4B4646)),
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
                                              return 'Please enter your hourly rate ';
                                            }
                                            return null;
                                          },),),),
                                  ],),),
                            ],),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                // Add padding around the Column
                                child: TextFormField(
                                  controller: bioController,
                                  decoration: InputDecoration(
                                    label: Text('Your overview'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(
                                          color: Color(0xFF4B4646)),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xF4F7F9),
                                    labelStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B4646),
                                    ),
                                  ),
                                  maxLines: 8,
                                  // Adjust the number of lines as needed
                                  maxLength: 100,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your overview ';
                                    }
                                    else if (value.length < 100) {
                                      return 'Please enter at least 100 characters';
                                    }
                                    return null;
                                  },),),
                            ],),

                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                // Add padding around the Column
                                child: TextFormField(
                                  controller: skillsController,
                                  decoration: InputDecoration(
                                    label: Text('Your skills'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(
                                          color: Color(0xFF4B4646)),
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
                                      return 'Please enter your skills ';
                                    }
                                    final skillsList = value.split(',').map((
                                        skill) => skill.trim()).toList();

                                    if (skillsList.length < 5) {
                                      return 'Please enter up to 5 skills';
                                    }
                                    return null;
                                  },),),
                            ],),

                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                // Add padding around the Column
                                child: TextFormField(
                                  controller: servicesController,
                                  decoration: InputDecoration(
                                    label: Text('Your main services'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(
                                          color: Color(0xFF4B4646)),
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
                                      return 'Please enter your main services ';
                                    }
                                    return null;
                                  },),),
                            ],),

                          SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0), // Add horizontal padding
                            child: Text('-Selected Services',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B4646), // Adjust the color as needed
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Service 1 and Service 2 side by side
                              GestureDetector(
                                onTap: () => selectService('Service 1'),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 26.0),
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust the padding
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Color(0xFF4B4646),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Service 1',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B4646),),),),),

                              GestureDetector(
                                onTap: () => selectService('Service 2'),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust the padding
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Color(0xFF4B4646),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Service 2',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B4646),),),),),],),

                          GestureDetector(
                            onTap: () => selectService('Service 3'),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 26.0),
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust the padding
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Color(0xFF4B4646),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Service 3',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B4646),),),),),

                          SizedBox(height: 6),

                          Center(
                            child:ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  UserModel user = UserModel(
                                    id: existingUserId,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    address: addressController.text.trim(),
                                    zipcode: zipCodeController.text.trim(),
                                    birthday: birthdayController.text.trim(),
                                    gender: genderController.text.trim(),
                                    province: provinceController.text.trim(),
                                    city: cityController.text.trim(),
                                    phoneNo: phoneController.text.trim(),
                                    bio: bioController.text.trim(),
                                    skills: skillsController.text.trim(),
                                    services: sociallinkController.text.trim(),
                                    hourlyRate: hourlyrateController.text.trim(),
                                    sociallink: servicesController.text.trim(),
                                    professionalRole: professionalRoleController.text.trim(),
                                    profilePhotoUrl: profileImageUrl,
                                  );
                                  UserRepository.instance.updateUser(user);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProfileFreelancer3()), // Navigate to Profile_freelancer2.dart
                                  );}},
                              child: Text('Save & Next',
                                style: TextStyle(fontSize: 16), // Adjust the font size as needed
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF16056B), // Change the background color
                                onPrimary: Colors.white,    // Change the text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13), // Adjust the border radius as needed
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 138, vertical: 15), ),),)
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

  void selectService(String serviceName) {
    setState(() {
      selectedServices.add(serviceName);
      servicesController.text =
          selectedServices.join(', '); // Update the text field
    });
  }
}
