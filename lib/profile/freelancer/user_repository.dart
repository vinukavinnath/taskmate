import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/profile/freelancer/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsersStream() {
    return _db.collection("Users").snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((doc){
            final data = doc.data();
            return UserModel(
                id: doc.id, // Set the 'id' field with the document ID
                firstName: data['firstName'],
                lastName: data ['lastname'],
                address: data['address'],
              zipcode: data['zipcode'],
              birthday: data['birthday'],
              gender: data['gender'],
              province: data['province'],
              city: data['city'],
              email: data['email'],
              phoneNo: data['phoneNo'],
              bio: data['bio'],
              skills: data['skills'],
              services: data['services'],
              sociallink: data['sociallink'],
              professionalRole: data['professionalRole'],
              hourlyRate: data['hourlyRate'],
              password: data['password'],
              profilePhotoUrl: data['profilePhotoUrl'],



            );
          }).toList(),
    );
  }
  updateUser(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).update(user.toJson());
      Get.snackbar(
        "Success",
        "Your Account has been Updated",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }
  }




  createUser(UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());
      Get.snackbar(
        "Success",
        "Your Account has been Created",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

    }
    catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }


  }

}
