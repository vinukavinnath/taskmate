import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskmate/authentication/log_in.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/components/bottom_sub_text.dart';
import 'package:taskmate/authentication/create_my_account_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskmate/components/maintenance_page.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/localization/locales.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? imagePath;
  String? _languageCode;
  Future<void> loadImages(String imageUrl) async {
    try {
      await precacheImage(AssetImage(imagePath!), context);
    } catch (e) {
      //Ignored
    }
  }

  //Method for Google Authentication
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    loadImages('images/background/signup.webp');
    loadImages('images/taskmate_logo_light.webp');
    loadImages('images/noise_image.webp');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kAshWhiteColor,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('images/background/signup.webp'),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Image.asset('images/taskmate_logo_light.webp'),
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      bottom: 0,
                      child: Container(
                        width: screenWidth,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/noise_image.webp'),
                            repeat: ImageRepeat.repeat,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: ListView(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 30.0,
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    'Sign Up & Find Your\nNext Gig',
                                    textAlign: TextAlign.center,
                                    style: kHeadingTextStyle,
                                  ),
                                ),
                                //"Continue with Mobile or Email button goes here"
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 28.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateMyAccount1(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kDeepBlueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      //Button icon and Text goes here
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:  <Widget>[
                                          Icon(
                                            Icons.person_add,
                                            color: kBrilliantWhite,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
                                            _getTranslatedText('sgn_up_emlbtn'),
                                            style: TextStyle(
                                                color: kBrilliantWhite,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //Separator goes here
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          height: 3.0,
                                          width: screenWidth / 4,
                                          color: kLightBlueColor,
                                        ),
                                      ),
                                      const Text(
                                        'Or continue with',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          height: 3.0,
                                          width: screenWidth / 4,
                                          color: kLightBlueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //"Sign up & Find your next Gig" text goes here

                                //Third Party Auth buttons goes here
                                Container(
                                  width: screenWidth,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                        horizontal: 24.0,
                                      ),
                                      backgroundColor: kLightBlueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      signInWithGoogle();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'icons/google.png',
                                            width: 25.0,
                                          ),
                                          const SizedBox(width: 15.0),
                                          const Text(
                                            'Google',
                                            style: TextStyle(
                                                color: kDeepBlueColor,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //Bottom most row of the screen
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const BottomSubText(
                                          'Already registered?'),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Log In',
                                          style: TextStyle(
                                            color: kAmberColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _getTranslatedText(String key) {
    Map<String, dynamic> localizedText =
    _languageCode == 'en' ? LocalData.EN : LocalData.SI;
    return localizedText[key] ??
        key; // Fallback to the key if the translation is not found
  }
}
