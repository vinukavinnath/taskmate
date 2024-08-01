import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/authentication/log_in.dart';
import 'package:taskmate/authentication/verify_email.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/components/bottom_sub_text.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/maintenance_page.dart';
import 'package:taskmate/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskmate/components/snackbar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:taskmate/dashboard/privacy_policy.dart';
import 'package:taskmate/dashboard/terms_conditions.dart';
import 'package:taskmate/dashboard/terms_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/localization/locales.dart';

class CreateMyAccount1 extends StatefulWidget {
  const CreateMyAccount1({super.key});

  @override
  State<CreateMyAccount1> createState() => _CreateMyAccount1State();
}

class _CreateMyAccount1State extends State<CreateMyAccount1> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked1 = false;
  bool isChecked2 = false;

  bool obsecureController0 = true;
  bool obsecureController1 = true;
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _languageCode;

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    _loadLanguagePreference();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void createMyAccount() async {
    final String enteredEmail = email.text.trim();
    final String enteredPassword = password.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    try {
      if (enteredPassword == confirmPassword) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        sendVerificationLink(email.text);

        Fluttertoast.showToast(
          msg: "Account was successfully created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 24.0,

          // Account creation successful
        );
      } else if (enteredPassword != confirmPassword) {
        // Show a snackbar if passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            title: 'Password does not match',
            backColor: kWarningRedColor,
            time: 3,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // The password provided is too weak
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            title: 'Weak password',
            backColor: kWarningRedColor,
            time: 3,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        // The account already exists for that email
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            title: 'Email already in use',
            backColor: kWarningRedColor,
            time: 3,
          ),
        );
      }
    }
  }

  bool isCreateAccountButtonActive() {
    if (isChecked1 == true && isChecked2 == true) {
      return true;
    } else {
      return false;
    }
  }

  void setObsecure0() {
    setState(() {
      obsecureController0 = !obsecureController0;
    });
  }

  void setObsecure1() {
    setState(() {
      obsecureController1 = !obsecureController1;
    });
  }

  void _navigateToVerifyEmail() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const VerifyEmail(),
      ),
    );
  }

  Future<void> sendVerificationLink(String email) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _navigateToVerifyEmail();
      }
    } catch (e) {
      //Ignored catch block
    }
  }

  Future<void> _showMarkdownDialog(BuildContext context) async {
    String markdownContent = await rootBundle.loadString('assets/11.md');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Markdown(
              data: markdownContent,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/noise_image.webp'),
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 8.0),
                      child: Text(
                        _getTranslatedText('crt_acc'),
                        textAlign: TextAlign.center,
                        style: kHeadingTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //"Email" Textfield goes here
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 28.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: kBrilliantWhite,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field can\'t be empty';
                                } else if (!value.contains('@')) {
                                  password.clear();
                                  confirmPasswordController.clear();
                                  return 'Please enter a valid Email Address';
                                }
                                return null; // Return null for valid input
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _getTranslatedText('email'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          //"Password" Textfield goes here
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 28.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: kBrilliantWhite,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field can\'t be empty';
                                }
                                return null; // Return null for valid input
                              },
                              obscureText: obsecureController0,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _getTranslatedText('password'),
                                suffixIcon: IconButton(
                                  icon: obsecureController0
                                      ? const Icon(Icons.lock)
                                      : const Icon(Icons.lock_open),
                                  color: kJetBlack,
                                  onPressed: () {
                                    setObsecure0();
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          //"Confirm Password" Textfield goes here
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 28.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: kBrilliantWhite,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field can\'t be empty';
                                }
                                return null; // Return null for valid input
                              },
                              obscureText: obsecureController1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _getTranslatedText('conf_pw'),
                                suffixIcon: IconButton(
                                  icon: obsecureController1
                                      ? const Icon(Icons.lock)
                                      : const Icon(Icons.lock_open),
                                  color: kJetBlack,
                                  onPressed: () {
                                    setObsecure1();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ListTile(
                        leading: Checkbox(
                          value: isChecked1,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked1 = value!;
                            });
                          },
                          activeColor: kDeepBlueColor,
                        ),
                        title: Wrap(
                          children: [
                            Text(
                              'I have read and agree to TaskMate’s',
                              style: kTextStyle.copyWith(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsConditions(),
                                  ),
                                );
                              },
                              child: Text(
                                'Term of Service',
                                style: kTextStyle.copyWith(
                                  color: kDeepBlueColor,
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              ' and',
                              style: kTextStyle.copyWith(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicy(),
                                  ),
                                );
                              },
                              child: Text(
                                ' Privacy Policy',
                                style: kTextStyle.copyWith(
                                  color: kDeepBlueColor,
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: 'I have read and agree to TaskMate’s',
                        //         style: kTextStyle.copyWith(
                        //           fontFamily: 'Poppins',
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //       TextButton(onPressed: (){}, child: Text('Term of Service'),),
                        //       // TextSpan(
                        //       //   text: ' Term of Service ',
                        //       //   style: kTextStyle.copyWith(
                        //       //     color: kDeepBlueColor,
                        //       //     fontFamily: 'Poppins',
                        //       //     fontSize: 15,
                        //       //   ),
                        //       // ),
                        //       TextSpan(
                        //         text: 'and ',
                        //         style: kTextStyle.copyWith(
                        //           fontFamily: 'Poppins',
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         text: 'Privacy Policy.',
                        //         style: kTextStyle.copyWith(
                        //           color: kDeepBlueColor,
                        //           fontFamily: 'Poppins',
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ListTile(
                        leading: Checkbox(
                          value: isChecked2,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked2 = value!;
                            });
                          },
                          activeColor: kDeepBlueColor,
                        ),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'We reserve the right to terminate or suspend your account at any time for violating our policies.',
                                style: kTextStyle.copyWith(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    DarkMainButton(
                        title: _getTranslatedText('crt_acc'),
                        process: () {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, proceed with submission or other actions
                            if (isCreateAccountButtonActive()) {
                              createMyAccount();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CusSnackBar(
                                  title: 'Please agree to Terms & Conditions',
                                  backColor: kWarningRedColor,
                                  time: 3,
                                ),
                              );
                            }
                          }
                        },
                        screenWidth: screenWidth),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BottomSubText(
                          _getTranslatedText('sgn_up_ftr'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child:Text(
                            _getTranslatedText('login'),
                            style: const TextStyle(
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
