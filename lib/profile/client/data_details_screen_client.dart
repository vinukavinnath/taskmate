import 'package:flutter/material.dart';
import 'package:taskmate/profile/client/user_model1.dart';

class DataDetailsScreenClient extends StatelessWidget {
  final UserModel1 client;

  DataDetailsScreenClient({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo in Circle
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(client.profilePhotoUrl ?? ''),
              ),
            ),
            SizedBox(height: 8),
            // Email
            Center(
              child: Text(
                client.email,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6),
            // First Name + Last Name
            Center(
              child: Text(
                '${client.firstName} ${client.lastName}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),

            //dummy data


            // Address with Circular Border
      Center(
        child: SizedBox(
          width: 300, // Adjust the width as needed
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text('Address: ${client.address}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                ),
              ),
          ),
        ),
      ),
            SizedBox(height: 16),

            Center(
              child: SizedBox(
                width: 300, // Adjust the width as needed
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text('Zipcode: ${client.zipcode}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            Center(
              child: SizedBox(
                width: 300, // Adjust the width as needed
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text('Province: ${client.province}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

      Center(
        child: SizedBox(
          width: 300, // Adjust the width as needed
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text('City: ${client.city}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ),
        ),
      ),
            SizedBox(height: 16),

        Center(
          child: SizedBox(
            width: 300, // Adjust the width as needed
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text('Phone No: ${client.phoneNo}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
