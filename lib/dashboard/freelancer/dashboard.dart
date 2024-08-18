import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:taskmate/authentication/get_started.dart';
import 'package:taskmate/authentication/log_in.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/components/dashboard_item.dart';
import 'package:taskmate/dashboard/freelancer/about_us.dart';
import 'package:taskmate/dashboard/freelancer/balance.dart';
import 'package:taskmate/dashboard/freelancer/help_support.dart';
import 'package:taskmate/dashboard/invite_friends.dart';
import 'package:taskmate/dashboard/freelancer/profile.dart';
import 'package:taskmate/dashboard/terms_conditions.dart';
import 'package:taskmate/dashboard/freelancer/transaction_history.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String compliment;
  String userId = '';

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

  @override
  void initState() {
    updateCompliment();
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
                title: 'Profile',
                icon: Icons.badge,
                function: navigateToProfile,
              ),
              DashboardItem(
                title: 'Balance',
                icon: Icons.account_balance,
                function: navigateToBalance,
              ),
              DashboardItem(
                title: 'Trancaction History',
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
                title: 'Help & Support',
                icon: Icons.help,
                function: navigateToHelpSupport,
              ),
              DashboardItem(
                title: 'Invite Friends',
                icon: Icons.group_add,
                function: navigateToInviteFriends,
              ),
              DashboardItem(
                title: 'Terms & Conditions',
                icon: Icons.handshake,
                function: navigateToTermsConditions,
              ),
              DashboardItem(
                title: 'About Us',
                icon: Icons.groups,
                function: navigateToAboutUs,
              ),
              TextButton(
                onPressed: () {
                  signOutUser(context);
                },
                child: Text(
                  'Logout',
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
                  '47c5588bfd2fbc504ad1b4d294b8a375', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
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
}
