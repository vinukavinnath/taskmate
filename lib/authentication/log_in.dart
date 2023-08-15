import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmate/authentication/forget_password.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskmate/authentication/sign_up.dart';


import 'package:taskmate/components/maintenance_page.dart';



import 'package:taskmate/components/maintenance_page.dart';

import 'package:taskmate/authentication/take_action.dart';


import 'package:taskmate/components/dark_main_button.dart';

import 'package:taskmate/constants.dart';
import 'package:taskmate/components/bottom_sub_text.dart';
import 'package:taskmate/components/snackbar.dart';
import 'package:taskmate/pages/jobs.dart';
import 'package:taskmate/components/maintenance_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obsecureController = true;

  void setObsecure() {
    setState(() {
      obsecureController = !obsecureController;
    });
  }

//Method for Google Authentication
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> handleSignIn(BuildContext context) async {
    UserCredential user = await signInWithGoogle();

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Jobs(),
        ),
      );
    } else {}
  }

//Method for Sign in with email and password
  void signInWithEmailAndPassword(String email, String password) async {
    try {


      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Fluttertoast.showToast(
        msg: "Successfully logged in",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );



      // Sign-in successful, handle the user object or navigate to the next screen.

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Jobs(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-mail') {
        emailController.clear();
        passwordController.clear();
        //Visit the snackbar class for further details
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Enter a valid email address'),
        );
      } else if (e.code == 'user-not-found') {
        emailController.clear();
        passwordController.clear();
        //Visit the snackbar class for further details
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Incorrect Email and Password'),
        );
      } else if (e.code == 'wrong-password') {
        passwordController.clear();
        //Visit the snackbar class for further details
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Incorrect Password'),
        );
      }
    }
  }

  //Disposing controllers for preventing memory leaks and unusual behaviours
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    // final double screenHeight = screenSize.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('images/background/login.webp'),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
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
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Welcome Back!',
                                    style: kHeadingTextStyle,
                                  ),
                                ),

                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      //Email Textfield
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 28.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: kBrilliantWhite,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child:
                                            //Email Textfield
                                            TextFormField(
                                          controller: emailController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !value.contains('@')) {
                                              return 'Please enter a valid Email Address';
                                            }
                                            return null; // Return null for valid input
                                          },
                                          obscureText: false,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Email',
                                          ),
                                        ),
                                      ),
                                      //Password Textfield
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 28.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: kBrilliantWhite,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: TextFormField(
                                          controller: passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the Password';
                                            }
                                            return null; // Return null for valid input
                                          },
                                          obscureText: obsecureController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Password',
                                            suffixIcon: IconButton(
                                              icon: obsecureController
                                                  ? const Icon(Icons.lock)
                                                  : const Icon(Icons.lock_open),
                                              color: kJetBlack,
                                              onPressed: () {
                                                setObsecure();
                                              },
                                            ),
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //"Log In" Button goes here
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 28.0),
                                  width: screenWidth,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kDeepBlueColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Form is valid, proceed with submission or other actions
                                        signInWithEmailAndPassword(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'Log In',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgetPassword(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot your Password',
                                    style: TextStyle(
                                      color: kDarkGreyColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
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

                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(

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
                                        ),
                                        onPressed: () {
                                          handleSignIn(context);
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

                              ),
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
                                      ),
                                      onPressed: () {
                                        handleSignIn(context);
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const BottomSubText('Create a'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(

                                          builder: (context) => const SignUp(),

                                          builder: (context) =>

                                              const TakeAction(),


                                        ),
                                      ),
                                    ),
                                    const BottomSubText('Account'),
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
