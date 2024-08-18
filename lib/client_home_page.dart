import 'package:flutter/material.dart';
import 'package:taskmate/bottom_nav_bar/client/client_account.dart';
// import 'package:taskmate/client_dashboard/Dashboard.dart';
import 'package:taskmate/bottom_nav_bar/client/client_job_status.dart';
import 'package:taskmate/bottom_nav_bar/client/client_messaging.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taskmate/dashboard/client/dashboard.dart';

import 'package:taskmate/bottom_nav_bar/client/client_posted.dart';
import 'package:taskmate/messaging/Receivemsg.dart';

import 'package:taskmate/profile/client/user_model1.dart';

import 'messaging/Sendmsg.dart';

class ClientHomePage extends StatefulWidget {
  int passedIndex;

  ClientHomePage({
    // required this.selectedIndex,

    // this.downloadUrl,
    required this.passedIndex,

    //  this.downloadUrl,
    super.key,
  });

  // final UserModel1 client; // Add this line
  // final String? downloadUrl;

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late final List _items = [
    SendMsg(),
    const ClientPosted(),
    const ClientJobStatus(),
    Dashboard(
        // client: widget.client,
        // profileImageUrl: widget.downloadUrl,
        ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // int selectedIndex=widget.passedIndex;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          width: screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'images/noise_image.webp',
              ),
            ),
          ),
          child: GNav(
            gap: 10.0,
            selectedIndex: widget.passedIndex,
            onTabChange: (int index) {
              setState(() {
                widget.passedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.mail_outline,
                text: 'Messages',
              ),
              GButton(
                icon: Icons.add_circle,
                text: 'Post a Job',
              ),
              GButton(
                icon: Icons.work,
                text: 'Job Status',
              ),
              GButton(
                icon: Icons.person,
                text: 'Account',
              ),
            ],
          ),
        ),
        body: _items[widget.passedIndex],
      ),
    );
  }
}
