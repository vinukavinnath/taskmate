import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/authentication/log_in.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/components/maintenance_page.dart';
import 'package:taskmate/components/snackbar.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _forgetPasswordController = TextEditingController();

  @override
  void dispose() {
    _forgetPasswordController.dispose();
    super.dispose();
  }

  //Alert message Method
  void _alertDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MaintenancePage(
          [
            Image.asset('images/magnifier.webp'),
            const Text(
              'Check Your Email!',
              style: kSubHeadingTextStyle,
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'We’ve sent a password reset link to Inbox',
                style: kTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            DarkMainButton(
                title: 'Check Inbox',
                process: ()  async {
                   await LaunchApp.openApp(
                      androidPackageName: 'com.google.android.gm',
                      openStore: false,);
                },
                screenWidth: MediaQuery.of(context).size.width),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'After resetting the password you can now login to Taskmate with your new password',
                style: kTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            LightMainButton(
                title: 'Login Now',
                process: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                screenWidth: MediaQuery.of(context).size.width)
          ],
        );
      },
    );
  }

//Forget password Method
  Future forgetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _forgetPasswordController.text.trim(),
      );
      _alertDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        _forgetPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Enter a valid email address'),
        );
        // Handle invalid email address
      } else if (e.code == 'user-not-found') {
        _forgetPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('User not Found'),
        );
      } else if (e.code == 'too-many-requests') {
        _forgetPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Maximum attempt count reached'),
        );
      } else {
        // Handle other FirebaseAuthExceptions
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage('images/noise_image.webp'),
            ),
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                child: Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: kHeadingTextStyle,
                ),
              ),
              const Expanded(
                flex: 1,
                child: Image(
                  image: AssetImage('images/keys.webp'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Enter your email account to reset password',
                      style: kTextStyle,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 28.0),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: kBrilliantWhite,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextFormField(
                          controller: _forgetPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Email';
                            }
                            return null; // Return null for valid input
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your email here',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    DarkMainButton(
                        title: 'Continue',
                        process: () {
                          if (_formKey.currentState!.validate()) {
                            forgetPassword();
                            // Form is valid, proceed with submission or other actions
                          }
                        },
                        screenWidth: screenWidth),
                  ],
                ),
              ),
              LightMainButton(
                  title: 'Cancel',
                  process: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  screenWidth: screenWidth),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
