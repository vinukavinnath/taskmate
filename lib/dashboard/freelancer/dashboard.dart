import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:taskmate/authentication/get_started.dart';
import 'package:taskmate/authentication/log_in.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/components/dashboard_item.dart';
import 'package:taskmate/dashboard/about_us.dart';
import 'package:taskmate/dashboard/freelancer/balance.dart';
import 'package:taskmate/dashboard/help_support.dart';
import 'package:taskmate/dashboard/invite_friends.dart';
import 'package:taskmate/dashboard/freelancer/profile.dart';
import 'package:taskmate/dashboard/terms_conditions.dart';
import 'package:taskmate/dashboard/freelancer/transaction_history.dart';
import 'package:taskmate/freelancer_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/localization/locales.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String compliment;
  String userId = '';
  String? _languageCode;

  void updateCompliment() {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;
    // final dayFormat = DateFormat('EEEE');
    // final dateFormat = DateFormat('MMM dd, yyyy');
    setState(() {
      compliment = getCompliment(hour);
    });
  }

  String getCompliment(int hour) {
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  void showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('English'),
                onTap: () {
                  changeLanguage(context, 'en');
                },
              ),
              ListTile(
                title: const Text('Sinhala'),
                onTap: () {
                  changeLanguage(context, 'si');
                },
              ),
              // Add more languages as needed
            ],
          ),
        );
      },
    );
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    await setLanguage(languageCode);
    // Close the dialog
    Navigator.of(context).pop();
    // Rebuild the app's UI with the new language
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FreelancerHomePage(),
      ),
    );
  }

  Future<void> setLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  Future<Map<String, dynamic>> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    // Define the Firestore collection, document ID, and fields you want to retrieve.
    final DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return data;
  }

  void navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  void navigateToBalance() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Balance(),
      ),
    );
  }

  void navigateToTransactionHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TransactionHistory(),
      ),
    );
  }

  void navigateToHelpSupport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HelpSupport(),
      ),
    );
  }

  void navigateToInviteFriends() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InviteFriends(),
      ),
    );
  }

  void navigateToTermsConditions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TermsConditions(),
      ),
    );
  }

  void navigateToAboutUs() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AboutUs(),
      ),
    );
  }

  // void signOut() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const GetStarted(),
  //     ),
  //   );
  // }

  void signOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language_code') ?? 'en';
    });
  }

  @override
  void initState() {
    updateCompliment();
    _loadLanguagePreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'images/noise_image.webp',
              ),
            ),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: <Container>[
                      Container(
                        width: screenWidth,
                        height: screenHeight / 5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'images/cover_photo.webp',
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding as needed
                            child: IconButton(
                              icon: const Icon(
                                Icons.translate,
                              ), // Change icon as needed
                              color: kDeepBlueColor, // Change color as needed
                              onPressed: () {
                                showLanguageSelectionDialog(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 30,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0, // Set the border width
                      ),
                    ),
                    child: FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${snapshot.data?['profilePhotoUrl']}',
                            ),
                            radius: 40,
                          );
                        } else {
                          return const SpinKitFadingCircle(
                            color: kDeepBlueColor,
                            size: 30.0,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    compliment,
                    style: kJobCardTitleTextStyle.copyWith(color: kAmberColor),
                  ),
                  FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data?['firstName']} ${snapshot.data?['lastName']}',
                          style: kSubHeadingTextStyle,
                        );
                      } else {
                        return const SpinKitThreeBounce(
                          color: kDeepBlueColor,
                          size: 30.0,
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data?['Level']} Freelancer',
                          style: kTextStyle.copyWith(color: kOceanBlueColor),
                        );
                      } else {
                        return const SpinKitThreeBounce(
                          color: kDeepBlueColor,
                          size: 30.0,
                        );
                      }
                    },
                  ),
                ],
              ),
              DashboardItem(
                title: _getTranslatedText('prf'),
                icon: Icons.badge,
                function: navigateToProfile,
              ),
              DashboardItem(
                title: _getTranslatedText('blnc'),
                icon: Icons.account_balance,
                function: navigateToBalance,
              ),
              DashboardItem(
                title: _getTranslatedText('trns'),
                icon: Icons.currency_exchange,
                function: navigateToTransactionHistory,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                width: screenWidth / 1.2,
                child: const Divider(
                  color: kDarkGreyColor,
                  thickness: 1.0,
                ),
              ),
              DashboardItem(
                title: _getTranslatedText('hlp'),
                icon: Icons.help,
                function: navigateToHelpSupport,
              ),
              DashboardItem(
                title: _getTranslatedText('invt'),
                icon: Icons.group_add,
                function: navigateToInviteFriends,
              ),
              DashboardItem(
                title: _getTranslatedText('trms'),
                icon: Icons.handshake,
                function: navigateToTermsConditions,
              ),
              DashboardItem(
                title: _getTranslatedText('about'),
                icon: Icons.groups,
                function: navigateToAboutUs,
              ),
              TextButton(
                onPressed: () {
                  signOutUser(context);
                },
                child: Text(
                  _getTranslatedText('lg_out'),
                  style: kJobCardTitleTextStyle.copyWith(
                    color: kAmberColor,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'TaskMate v2.0',
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            dynamic conversationObject = {
              'appId':
              '5105cd446c5b2d89ee8995ab67fdfd7e', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
            };

            KommunicateFlutterPlugin.buildConversation(conversationObject)
                .then((clientConversationId) {
              print("Conversation builder success : " +
                  clientConversationId.toString());
            }).catchError((error) {
              print("Conversation builder error : " + error.toString());
            });
          },
          backgroundColor: kDeepBlueColor,
          child: const Image(
            image: AssetImage('images/chatbot.png'),
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
