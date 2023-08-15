import 'package:flutter/material.dart';

import 'package:taskmate/constants.dart';

class VerifyIdentityCard extends StatelessWidget {
  VerifyIdentityCard(
      {super.key,
      required this.icon,
      required this.headingText,
      required this.subText,
      this.docSubmitButton,
      required this.bgColor,
      required this.outlineColor,
      required this.headFontColor,
      required this.subFontColor,
      required this.backCircleColor});

  final IconData icon;
  final String headingText;
  final String subText;
  Widget? docSubmitButton;
  final Color bgColor;
  final Color outlineColor;
  final Color headFontColor;
  final Color subFontColor;
  final Color backCircleColor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    //final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      width: screenWidth,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: outlineColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backCircleColor,
            ),
            child: Icon(
              icon,
              color: kBrilliantWhite,
              size: 25,
            ),
          ),
          Text(
            headingText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: headFontColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              subText,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: subFontColor),
            ),
          ),
          docSubmitButton ?? const SizedBox(),
        ],
      ),
    );
  }
}
