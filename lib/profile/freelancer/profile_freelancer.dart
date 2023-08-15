import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskmate/profile/freelancer/data_details_screen_freelancer.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer2.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer3.dart';
import 'package:taskmate/profile/freelancer/upload_profile_image.dart';
import 'package:taskmate/profile/freelancer/user_model.dart';
import 'package:taskmate/profile/freelancer/user_repository.dart';

class ProfileFreelancer extends StatefulWidget {
  const ProfileFreelancer({Key? key}) : super(key: key);

  @override
  _ProfileFreelancerState createState() => _ProfileFreelancerState();
}

class _ProfileFreelancerState extends State<ProfileFreelancer> {
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



  get emailRegex => RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', caseSensitive: false, multiLine: false,);
  get phoneRegex => RegExp(r'^[0-9]{10}$', caseSensitive: false, multiLine: false,);
  get _urlRegex => RegExp(r"^(https?://)?([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(/\S*)?$");
  final _city1Regex = RegExp(r'^[a-zA-Z0-9\s]+$');




  void updateData() {
    if (formKey.currentState!.validate()) {
      setState(() {
        dataSubmitted = true; // Set the flag to indicate data has been submitted
      });}}

  void saveDataAndNavigate() {
    if (formKey.currentState!.validate()) {
      UserModel user = UserModel(
        id: FirebaseFirestore.instance.collection("Users").doc().id, // Generate a new ID
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        address: addressController.text,
        zipcode: zipCodeController.text,
        birthday: birthdayController.text,
        gender: genderController.text,
        province: provinceController.text,
        city: cityController.text,
        phoneNo: phoneController.text,
        bio: bioController.text,
        skills: skillsController.text,
        services: sociallinkController.text,
        hourlyRate: hourlyrateController.text,
        sociallink: servicesController.text,
        professionalRole: professionalRoleController.text,
        profilePhotoUrl: profileImageUrl,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileFreelancer2()),
      );
      UserRepository userRepository = UserRepository.instance; // Create an instance of UserRepository
      userRepository.createUser(user); // Save user data to Firebase

      Get.to(ProfileFreelancer2()); // Use Get.to to navigate to the next page
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
                        Container(
                          width: double.infinity,
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.topCenter,
                              children: [
                                Text(
                                  "Set Up Your",
                                  style: TextStyle(
                                    color: Color(0xFF16056B), // Use your color code here
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),),
                        SizedBox(height: 2),
                       Center(
                        child :Text(
                          "Freelancer Profile",
                          style: TextStyle(
                            color: Color(0xFF16056B), // You can use the same or a different color code
                            fontSize: 25.0, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // You can adjust the font weight if needed
                          ),
                        ),
                       ),
                        SizedBox(height: 10,),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First Name*',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          borderSide: BorderSide(color: Color(0xFF4B4646)),
                                        ),
                                        filled: true,
                                        fillColor: Color(0x4B4646),
                                        labelStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4B4646),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10), // Add some spacing between the fields
                                  Expanded(
                                    child: TextFormField(
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name*',
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
                                          return 'Please enter your last name';}
                                        return null;},),),],),),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: birthdayController,
                                          onTap: () {
                                            selectDate(context, birthdayController); // Show the date picker on tap
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Birthday',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                              borderSide: BorderSide(color: Color(0xFF4B4646)),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xF4F7F9),
                                            labelStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF4B4646),),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  selectDate(context, birthdayController); // Show the date picker on icon tap
                                                },
                                                child: Icon(Icons.calendar_today),
                                              )
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please select your birthday';
                                            }
                                            return null;
                                          },),),

                                      SizedBox(width: 10), // Add some spacing between the fields

                                      Expanded(
                                        child: TextFormField(
                                          controller: genderController,
                                          decoration: InputDecoration(
                                            labelText: 'Gender',
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
                                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please select your gender';
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            // Open province selection dialog
                                            final selectedValue = await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Select Gender'),
                                                  content: DropdownButtonFormField<String>(
                                                    value: selectedGender,
                                                    items: [
                                                      DropdownMenuItem(value: 'Male', child: Text('Male'),),
                                                      DropdownMenuItem(value: 'Female', child: Text('Female'),),
                                                      DropdownMenuItem(value: 'Other', child: Text('Other'),)],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedGender = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 8.0,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, selectedGender);
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );},);
                                            if (selectedValue != null) {
                                              genderController.text = selectedValue;}},),),],),),],),],),
                            Column(
                              children : [
                            Padding(
                            padding: const EdgeInsets.all(16.0), // Add padding around the Column
                            child:TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    label: Text('Address(Apartment/suite number)*'),
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
                                      return 'Please enter your address ';}
                                    return null;},),),],),
                        Column(
                          children : [
                            Padding(
                              padding: const EdgeInsets.all(16.0), // Add padding around the Column
                              child:TextFormField(
                                controller: streetController,
                                decoration: InputDecoration(
                                  label: Text('Street'),
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
                                    return 'Please enter your street name ';}
                                  return null;},),),],),
                    Column(
                        children: [
                    Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: 'City*',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Color(0xFF4B4646)),
                              ),
                              filled: true,
                              fillColor: Color(0xF4F7F9),
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B4646),),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your city';
                              }
                              if (!_city1Regex.hasMatch(value)) {
                                return 'Please enter a valid name';
                                return null;
                              }
                            },),),
                        SizedBox(width: 10), // Add some spacing between the fields
                        Expanded(
                          child: TextFormField(
                            controller: provinceController,
                            decoration: InputDecoration(
                              labelText: 'State/Province*',
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
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select your province';
                              }
                              return null;
                            },
                            onTap: () async {
                              // Open province selection dialog
                              final selectedValue = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Select Province'),
                                    content: DropdownButtonFormField<String>(
                                      value: selectedProvince,
                                      items: [
                                          DropdownMenuItem(value: 'Central Province', child: Text('Central Province'),),
                                          DropdownMenuItem(value: 'Eastern Province', child: Text('Eastern province'),),
                                          DropdownMenuItem(value: 'North Central Province', child: Text('North Central Province'),),
                                          DropdownMenuItem(value: 'North Western Province', child: Text('North Western Province'),),
                                          DropdownMenuItem(value: 'Northern Province', child: Text('Northern Province'),),
                                          DropdownMenuItem(value: 'Sabaragamuwa Province', child: Text('Sabaragamuwa Province'),),
                                          DropdownMenuItem(value: 'Southern Province', child: Text('Southern Province'),),
                                          DropdownMenuItem(value: 'Uva Province', child: Text('Uva Province'),),
                                          DropdownMenuItem(value: 'Western Province', child: Text('Western Province'),),],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedProvince = value;
                                          });
                                        },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 8.0,
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, selectedProvince);},
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );},);
                              if (selectedValue != null) {
                                provinceController.text = selectedValue;}},),),],),),],),
                        Column(
                          children : [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Padding(padding: const EdgeInsets.only(right:186.0),// Add padding around the Column
                              child:TextFormField(
                                controller: zipCodeController,
                                decoration: InputDecoration(
                                  label: Text('Zip/Postal Code'),
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
                                    return 'Please enter your zipcode ';}
                                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                                    return 'Please enter a valid zipcode';
                                  }
                                  return null;},),),),],),

                        Column(
                          children : [
                            Padding(
                              padding: const EdgeInsets.all(16.0), // Add padding around the Column
                              child:TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
                                decoration: InputDecoration(
                                  label: Text('Phone number*'),
                                  prefixText: '+94 ',
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
                                    return 'Please enter your phone number';
                                  } else if (value.length != 9) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;},),),],),

                        Column(
                          children : [
                            Padding(
                              padding: const EdgeInsets.all(16.0), // Add padding around the Column
                              child:TextFormField(
                                controller: professionalRoleController,
                                decoration: InputDecoration(
                                  label: Text('Your professional role*'),
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
                                    return 'Please enter your professional role ';}
                                  return null;},),),],),

                      Center(
                        child:ElevatedButton(
                          onPressed: saveDataAndNavigate,
                          child: Text('Save & Next',
                            style: TextStyle(fontSize: 16), // Adjust the font size as needed
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF16056B), // Change the background color
                            onPrimary: Colors.white,    // Change the text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13), // Adjust the border radius as needed
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 138, vertical: 15), ),),),],
                    )),),),),],),),),);}}

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
