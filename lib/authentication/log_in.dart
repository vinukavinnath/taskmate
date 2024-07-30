import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmate/authentication/forget_password.dart';
import 'package:taskmate/authentication/sign_up.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/client_home_page.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/loading_screen.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/components/bottom_sub_text.dart';
import 'package:taskmate/components/snackbar.dart';
import 'package:taskmate/bottom_nav_bar/freelancer/jobs.dart';
import 'package:taskmate/components/maintenance_page.dart';
import 'package:taskmate/freelancer_home_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../profile/client/user_model1.dart';

class Login extends StatefulWidget {
  // final UserModel1 client;

  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? imagePath;
  int currentUserRole = 0;
  bool isLoading = false;

  List currentJobRole = [];

  void _onToggle(int? index) {
    setState(() {
      currentUserRole = index!;
    });
  }

  Future<void> loadImages(String imageUrl) async {
    try {
      await precacheImage(AssetImage(imagePath!), context);
    } catch (e) {
      //Ignored
    }
  }

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

  // Future<void> handleSignIn(BuildContext context) async {
  //   UserCredential user = await signInWithGoogle();
  //
  //   if (user != null) {
  //     if (context.mounted) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const Jobs(),
  //         ),
  //       );
  //     }
  //   } else {}
  // }

//Method for Sign in with email and password
  void signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // Sign-in successful, handle the user object or navigate to the next screen.

      if (context.mounted) {
        (currentUserRole == 0)
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const FreelancerHomePage(),
                ),
              )
            : Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ClientHomePage(
                    passedIndex: 1,
                  ),
                ),
              );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-mail') {
        emailController.clear();
        passwordController.clear();
        //Visit the snackbar class for further details
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            backColor: kAmberColor,
            time: 3,
            title: 'Enter a valid email address',
            icon: Icons.mail,
          ),
        );
      } else if (e.code == 'user-not-found') {
        emailController.clear();
        passwordController.clear();
        //Visit the snackbar class for further details
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            backColor: kAmberColor,
            time: 3,
            title: 'Incorrect Email and Password',
            icon: Icons.mail,
          ),
        );
      } else if (e.code == 'wrong-password') {
        passwordController.clear();
        //Visit the snackbar class for further details
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            backColor: kAmberColor,
            time: 3,
            title: 'Incorrect Password',
            icon: Icons.lock,
          ),
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
  void initState() {
    super.initState();
    loadImages('images/background/login.webp');
    loadImages('images/taskmate_logo_light.webp');
    loadImages('images/noise_image.webp');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    // final double screenHeight = screenSize.height;

    return SafeArea(
      child: !isLoading
          ? Scaffold(
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
                      flex: 6,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      Text(
                                        'Welcome Back!',
                                        style: kHeadingTextStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Container(
                                          // margin: EdgeInsets.symmetric(horizontal: 20.0),
                                          // width: screenWidth,
                                          child: ToggleSwitch(
                                            activeBgColor: const [
                                              kOceanBlueColor
                                            ],
                                            activeFgColor: kDeepBlueColor,
                                            inactiveBgColor: kLightBlueColor,
                                            inactiveFgColor: kOceanBlueColor,
                                            cornerRadius: 10.0,
                                            radiusStyle: true,
                                            minWidth: screenWidth / 2,
                                            minHeight: 45.0,
                                            initialLabelIndex: currentUserRole,
                                            totalSwitches: 2,
                                            customTextStyles: const [
                                              TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600),
                                              TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600),
                                            ],
                                            animate: true,
                                            curve: Curves.ease,
                                            labels: const [
                                              'Freelancer',
                                              'Client'
                                            ],
                                            onToggle: _onToggle,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            //Email Textfield
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 28.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      !value.contains('@')) {
                                                    return 'Please enter a valid Email Address';
                                                  }
                                                  return null; // Return null for valid input
                                                },
                                                obscureText: false,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Email',
                                                ),
                                                autofillHints: const [
                                                  AutofillHints.email
                                                ],
                                              ),
                                            ),
                                            //Password Textfield
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 28.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              decoration: BoxDecoration(
                                                color: kBrilliantWhite,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: TextFormField(
                                                controller: passwordController,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
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
                                                        : const Icon(
                                                            Icons.lock_open),
                                                    color: kJetBlack,
                                                    onPressed: () {
                                                      setObsecure();
                                                    },
                                                  ),
                                                ),
                                                autofillHints: const [
                                                  AutofillHints.password
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //"Log In" Button goes here
                                      DarkMainButton(
                                          title: 'Log In',
                                          process: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // Form is valid, proceed with submission or other actions
                                              // signInWithEmailAndPassword(
                                              //   emailController.text.trim(),
                                              //   passwordController.text.trim(),
                                              // );

                                              CollectionReference
                                                  collectionReference =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          (currentUserRole == 0)
                                                              ? 'Users'
                                                              : 'Clients');

                                              setState(() {
                                                isLoading = true;
                                              });

                                              QuerySnapshot querySnapshot =
                                                  await collectionReference
                                                      .where('email',
                                                          isEqualTo:
                                                              emailController
                                                                  .text)
                                                      .get();

                                              if (querySnapshot
                                                  .docs.isNotEmpty) {
                                                // for (QueryDocumentSnapshot documentSnapshot
                                                //     in querySnapshot.docs) {
                                                //   Map<String, dynamic> data =
                                                //       documentSnapshot.data()
                                                //           as Map<String, dynamic>;
                                                //   print(data);
                                                // }
                                                signInWithEmailAndPassword(
                                                  emailController.text.trim(),
                                                  passwordController.text
                                                      .trim(),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  CusSnackBar(
                                                    backColor: kWarningRedColor,
                                                    time: 3,
                                                    title:
                                                        'User isn\'t available',
                                                    icon: Icons.dangerous,
                                                  ),
                                                );
                                              }
                                            }
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                          screenWidth: screenWidth),
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
                                      Container(
                                        width: screenWidth,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 28.0),
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const BottomSubText('Create a'),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignUp(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'TaskMate',
                                              style: TextStyle(
                                                color: kAmberColor,
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
            )
          : const LoadingScreen(title: 'Please wait. . . '),
    );
  }
}
