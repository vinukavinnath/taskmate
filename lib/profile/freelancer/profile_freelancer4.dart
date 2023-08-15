import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskmate/profile/freelancer/data_details_screen_freelancer.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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

  String? profileImageUrl;
  String? selectedGender;
  String? selectedProvince;
  String? selectedSkills;
  bool dataSubmitted = false;

  get _urlRegex => RegExp(
      r"^(https?://)?([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(/\S*)?$");

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
                                  Navigator.pop(context); },),
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
                                  controller: skillsController,
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
                                      return 'Please enter valid url ';}
                                    return null;
                                  },),),],),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: servicesController,
                                  decoration: InputDecoration(
                                    labelText: 'Services',
                                    prefixIcon: Icon(LineAwesomeIcons.business_time),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xF4F7F9),
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your services';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10), // Add some spacing between fields
                              Expanded(
                                child: TextFormField(
                                  controller: professionalRoleController,
                                  decoration: InputDecoration(
                                    labelText: 'Professional Role',
                                    prefixIcon: Icon(LineAwesomeIcons.briefcase),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xF4F7F9),
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your professional role';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          TextFormField(

                            controller: hourlyrateController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              label: Text('Hourly Rate'),
                              prefixIcon: Icon(LineAwesomeIcons.dollar_sign),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Color(0xF4F7F9),
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Hourly Rate value ';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid Hourly Rate';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: //profileImageUrl == null || profileImageUrl!.isEmpty
                            //? null
                            //:
                                () {

                              if (formKey.currentState!.validate()) {
                                // Validated successfully, submit the form
                                final user = UserModel(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
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
                                UserRepository.instance.createUser(user);

                                // Clear the text field values
                                // firstNameController.clear();
                                // lastNameController.clear();
                                // addressController.clear();
                                // zipCodeController.clear();
                                // provinceController.clear();
                                // cityController.clear();
                                // emailController.clear();
                                // phoneController.clear();
                                // bioController.clear();
                                // skillsController.clear();
                                // servicesController.clear();
                                // professionalRoleController.clear();
                                // passwordController.clear();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Success'),
                                      content: Text('Your account is successfully created.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => DataDetailsScreenFreelancer(user: user),
                                              ),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );



                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //     builder: (context) => ProfilePage1(user: user),
                                // // Clear the profile image URL
                                //     ),
                                // );
                              }
                            },

                            child: SizedBox(
                              width: 200, // Adjust the width as needed
                              height: 50, // Adjust the height as needed

                              child: Center(
                                child: Text(
                                  dataSubmitted ? 'Update' : 'Submit',
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),

                                ),

                              ),

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

void selectDate(BuildContext context, TextEditingController birthdayController) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (picked != null && picked != DateTime.now()) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
    birthdayController.text = formattedDate; // Update the text field
  }
}
