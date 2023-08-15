

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String firstName ;
  final String lastName ;
  final String address ;
  final String zipcode ;
  final String birthday ;
  final String gender ;
  final String province ;
  final String city ;
  final String email ;
  final String phoneNo ;
  final String bio ;
  final String skills ;
  final String services ;
  final String sociallink ;
  final String professionalRole ;
  final String hourlyRate ;
  final String password ;
  final String? profilePhotoUrl;

   UserModel ({
    this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.zipcode,
    required this.birthday,
    required this.gender,
    required this.province,
    required this.city,
    required this.bio,
    required this.skills,
    required this.services,
    required this.sociallink,
    required this.professionalRole,
    required this.hourlyRate,
    required this.phoneNo,
    this.profilePhotoUrl,
  });

  Map<String, dynamic> toJson(){
    return {

      "FirstName": firstName,
      "LastName": lastName,
      "Address": address,
      "ZipCode": zipcode,
      "Birthday": birthday,
      "Gender": gender,
      "Province": province,
      "City":city,
      "Email": email,
      "Phone": phoneNo,
      "Bio" : bio,
      "Sills": skills,
      "Services" : services,
      "SocialLink" : sociallink,
      "ProfessionalRole": professionalRole,
      "HourlyRate" : hourlyRate,
      "Password": password,
      "ProfilePhotoUrl": profilePhotoUrl,
    };
  }

  // Named constructor to convert Firestore data to UserModel1 object
  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      email: json['Email'] ?? '',
      // Use the null-aware operator to provide a default value
      password: json['Password'] ?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      address: json['Address'] ?? '',
      zipcode: json['ZipCode'] ?? '',
      birthday: json['Birthday'],
      gender: json['Gender'],
      province: json['Province'] ?? '',
      city: json['City'] ?? '',
      bio: json['Bio'] ?? '',
      skills: json['Skills'] ?? '',
      services: json['Services'] ?? '',
      sociallink: json['SocialLink'] ?? '',
      professionalRole: json['ProfessionalRole'] ?? '',
      hourlyRate: json['HourlyRate'] ?? '',
      phoneNo: json['Phone'] ?? '',
      profilePhotoUrl: json['ProfilePhotoUrl'],
    );
  }


}