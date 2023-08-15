import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taskmate/pages/messaging.dart';
import 'package:taskmate/pages/job_status.dart';
import 'package:taskmate/pages/jobs.dart';
import 'package:taskmate/pages/account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final List _items = [
    const SafeArea(
      child: Messaging(),
    ),
    const JobStatus(),
    const Jobs(),
    const Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 5.0,
        selectedIndex: _selectedIndex,
        onTabChange: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        tabs: const [
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
      body: _items[_selectedIndex],
    );
  }
}
