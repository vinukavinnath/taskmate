import 'package:flutter/material.dart';
import 'package:taskmate/authentication/create_my_account_1.dart';
import 'package:taskmate/authentication/log_in.dart';
import 'package:taskmate/authentication/sign_up.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/components/bottom_sub_text.dart';
import 'package:taskmate/profile/client/profile_client.dart';
import 'package:taskmate/profile/freelancer/profile_freelancer.dart';

class TakeAction extends StatefulWidget {
  const TakeAction({super.key});

  @override
  State<TakeAction> createState() => _TakeActionState();
}

class _TakeActionState extends State<TakeAction> {
  bool isWork = true;
  bool isHire = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    //final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: kAshWhiteColor,
      body: Container(
        decoration: const BoxDecoration(color: kDeepBlueColor),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Image.asset('images/TaskMateLogo_Light.png'),
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
                          image: AssetImage('images/noise_image.png'),
                          repeat: ImageRepeat.repeat,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: ListView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Take Action & Open Your Account',
                                  textAlign: TextAlign.center,
                                  style: kHeadingTextStyle,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isWork = true;
                                    isHire = false;
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const ProfileFreelancer(),
                                      ),
                                    );
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: isWork
                                        ? kOceanBlueColor
                                        : kLowOpacityLightBlueColor,
                                    border: Border.all(color: kOceanBlueColor),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 32.0),
                                        child: Text(
                                          'I want to work',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: isWork
                                                ? kAshWhiteColor
                                                : kDeepBlueColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(4.0),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 30.0,
                                        ),
                                        width: screenWidth / 4,
                                        decoration: BoxDecoration(
                                          color: isWork
                                              ? const Color(0xFF1d58f5)
                                              : kLightBlueColor,
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: isWork
                                              ? kAshWhiteColor
                                              : kDeepBlueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'Or',
                                  style: TextStyle(
                                      color: kDarkGreyColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isWork = false;
                                    isHire = true;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const ProfileClient(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: isHire
                                        ? kOceanBlueColor
                                        : kLowOpacityLightBlueColor,
                                    border: Border.all(color: kOceanBlueColor),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 32.0),
                                        child: Text(
                                          'I want to hire',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: isHire
                                                ? kAshWhiteColor
                                                : kDeepBlueColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(4.0),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 30.0,
                                        ),
                                        width: screenWidth / 4,
                                        decoration: BoxDecoration(
                                          color: isHire
                                              ? const Color(0xFF1d58f5)
                                              : kLightBlueColor,
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: isHire
                                              ? kAshWhiteColor
                                              : kDeepBlueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const BottomSubText("Already registered?"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => const Login(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Login',
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
    );
  }
}
