import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskmate/authentication/log_in.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/components/bottom_sub_text.dart';
import 'package:taskmate/authentication/create_my_account_1.dart';

import 'package:taskmate/components/maintenance_page.dart';
import 'package:taskmate/components/dark_main_button.dart';


class SignUp extends StatelessWidget {
  const SignUp({super.key});

  // void _showCustomDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomAlertDialog(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Add your alert dialog content here
  //             Text('Your Alert Title'),
  //             SizedBox(height: 10),
  //             Text('Your Alert Message'),
  //             SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: Text('Close'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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

                                child: Text(
                                  'Sign up & Find Your Next Gig',
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
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    //Button icon and Text goes here
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: const <Widget>[
                                        Icon(
                                          Icons.person_add,
                                          color: kBrilliantWhite,
                                        ),
                                        Text(
                                          'Continue with Email or Mobile',
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
                                padding:
                                const EdgeInsets.symmetric(vertical: 32.0),
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
                              //Third Party Auth buttons goes here
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  //"Google" Signup Button
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 24.0),
                                        backgroundColor: kLightBlueColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16.0),

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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'icons/google.png',
                                            width: 25.0,
                                          ),
                                          const SizedBox(
                                            width: 8.0,

                                          ),
                                          Text(
                                            'Continue with Email or Mobile',
                                            style: TextStyle(
                                                color: kBrilliantWhite,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //"Facebook" Signup Button
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 24.0),
                                        backgroundColor: kLightBlueColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const MaintenancePage();
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'icons/facebook.png',
                                            width: 25.0,
                                          ),
                                          const SizedBox(
                                            width: 8.0,

                                          ),
                                        ),
                                        onPressed: () {
                                          signInWithGoogle();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'icons/google.png',
                                              width: 25.0,
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            const Text(
                                              'Google',
                                              style: TextStyle(
                                                  color: kDeepBlueColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //"Facebook" Signup Button
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 24.0),
                                          backgroundColor: kLightBlueColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MaintenancePage(
                                                [
                                                  const Image(
                                                    image: AssetImage(
                                                        'images/gear.webp'),
                                                  ),
                                                  Text(
                                                    'We’re',
                                                    style: kSubHeadingTextStyle
                                                        .copyWith(height: 0.5),
                                                  ),
                                                  const Text(
                                                    'Under Maintenance',
                                                    style: kSubHeadingTextStyle,
                                                  ),
                                                  const Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                    child: Text(
                                                      'Please check back soon just putting little touch up on some pretty updates.',
                                                      style: kTextStyle,
                                                      textAlign:
                                                      TextAlign.center,
                                                    ),
                                                  ),
                                                  DarkMainButton(
                                                      title: 'Close',
                                                      process: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      screenWidth: screenWidth)
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'icons/facebook.png',
                                              width: 25.0,
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            const Text(
                                              'Facebook',
                                              style: TextStyle(
                                                  color: kDeepBlueColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Bottom most row of the screen
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const BottomSubText('Already registered?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => const Login(),
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
}
