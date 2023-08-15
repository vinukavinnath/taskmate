
class UserModel1 {
  final String? id;
  final String firstName ;
  final String lastName ;
  final String address ;
  final String zipcode ;
  final String street;
  final String birthday;
  final String gender;
  final String province ;
  final String city ;
  final String email ;
  final String phoneNo ;
  final String password ;
  final String? profilePhotoUrl;

  const UserModel1 ({
    this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.zipcode,
    required this.street,
    required this.birthday,
    required this.gender,
    required this.province,
    required this.city,
    required this.phoneNo,
    this.profilePhotoUrl,
  });

  Map<String, dynamic> toJson(){
    return {

      "FirstName": firstName,
      "LastName": lastName,
      "Address": address,
      "ZipCode": zipcode,
      "Street": street,
      "Birthday": birthday,
      "Gender": gender,
      "Province": province,
      "City":city,
      "Email": email,
      "Phone": phoneNo,
      "Password": password,
      "ProfilePhotoUrl": profilePhotoUrl,
    };
  }
  // Named constructor to convert Firestore data to UserModel1 object
  factory UserModel1.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel1(
      id: documentId,
      email: json['Email'] ?? '', // Use the null-aware operator to provide a default value
      password: json['Password'] ?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      address: json['Address'] ?? '',
      zipcode: json['ZipCode'] ?? '',
      street: json['Street'] ?? '',
      birthday: json['Birthday'] ?? '',
      gender: json['gender'] ?? '',
      province: json['Province'] ?? '',
      city: json['City'] ?? '',
      phoneNo: json['Phone'] ?? '',
      profilePhotoUrl: json['ProfilePhotoUrl'],
    );
  }

}