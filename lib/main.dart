import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taskmate/profile/client/profile_client.dart';
import 'package:taskmate/profile/client/user_repository1.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer2.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer3.dart';
import 'package:taskmate/profile/freelancer/user_repository.dart';
import 'firebase_options.dart';
//imported pages
import 'package:taskmate/authentication/splash_screen.dart';
import 'package:taskmate/authentication/log_in.dart';
import 'package:taskmate/authentication/take_action.dart';
import 'package:taskmate/authentication/sign_up.dart';
import 'package:taskmate/authentication/create_my_account_1.dart';
import 'package:taskmate/authentication/get_started.dart';
import 'package:taskmate/authentication/verify_email.dart';
import 'package:taskmate/pages/jobs.dart';
import 'package:taskmate/job_details.dart';
import 'package:taskmate/authentication/forget_password.dart';

import 'home_page.dart';
//import 'package:taskmate/verify_identity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserRepository1());
  Get.put(UserRepository());


  runApp(
    const Taskmate(),
  );
}

class Taskmate extends StatelessWidget {
  const Taskmate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),

      home:  const SafeArea(
        child: HomePage(),

      ),
    );
  }
}
