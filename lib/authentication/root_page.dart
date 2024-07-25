import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmate/authentication/get_started.dart';

import 'package:taskmate/authentication/sign_up.dart';
import 'package:taskmate/authentication/log_in.dart';
import 'package:taskmate/onboarding/onboarding.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Login();
          } else {
            return const Onboarding();
          }
        },
      ),
    );
  }
}
