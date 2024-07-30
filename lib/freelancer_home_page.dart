import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taskmate/bottom_nav_bar/freelancer/messaging.dart';
import 'package:taskmate/bottom_nav_bar/freelancer/proposals.dart';
import 'package:taskmate/bottom_nav_bar/freelancer/jobs.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/dashboard/freelancer/dashboard.dart';
import 'package:taskmate/messaging/Receivemsg.dart';

class FreelancerHomePage extends StatefulWidget {
  const FreelancerHomePage({super.key});

  @override
  State<FreelancerHomePage> createState() => _FreelancerHomePageState();
}

class _FreelancerHomePageState extends State<FreelancerHomePage> {
  int _selectedIndex = 2;

  final List _items = [
    Receivemsg(),
    Proposals(),
    const Jobs(),
    const Dashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/noise_image.webp'),
                fit: BoxFit.cover),
          ),
          child: GNav(
            activeColor: kAmberColor,
            color: kDeepBlueColor,
            gap: 1.0,
            selectedIndex: _selectedIndex,
            onTabChange: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const <GButton>[
              GButton(
                icon: Icons.mail_outline,
                text: 'Messages',
              ),
              GButton(
                icon: Icons.work_history,
                text: 'Job Status',
              ),
              GButton(
                icon: Icons.work,
                text: 'Jobs',
              ),
              GButton(
                icon: Icons.person,
                text: 'Account',
              ),
            ],
          ),
        ),
        body: _items[_selectedIndex],
      ),
    );
  }
}
