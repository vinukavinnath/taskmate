import 'package:flutter/material.dart';
import 'package:taskmate/profile/client/user_model1.dart';
import 'package:taskmate/profile/client/user_repository1.dart';

class DataDisplayScreenClient extends StatefulWidget {
  @override
  _DataDisplayScreenClientState createState() => _DataDisplayScreenClientState();
}

class _DataDisplayScreenClientState extends State<DataDisplayScreenClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display'),
      ),
      body: StreamBuilder<List<UserModel1>>(
        stream: UserRepository1.instance.getClientsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data from Firebase: ${snapshot.error}'),
            );
          } else {
            List<UserModel1>? clients = snapshot.data;
            return ListView.builder(
              key: UniqueKey(),
              itemCount: clients?.length ?? 0, // Use null-aware operator and provide a default value
              itemBuilder: (context, index) {
                UserModel1 client = clients![index];
                return ListTile(
                  title: Text(client.email),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Name: ${client.lastName}'),
                      Text('Last Name: ${client.lastName}'),
                      Text('Phone No: ${client.phoneNo}'),
                      Text('Profile Photo URL: ${client.profilePhotoUrl ?? "N/A"}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
