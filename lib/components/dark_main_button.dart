import 'package:flutter/material.dart';

import 'package:taskmate/constants.dart';

class DarkMainButton extends StatelessWidget {
  const DarkMainButton({
    required this.title,
    required this.process,
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;
  final String? title;
  final void Function()? process;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: process,
        style: ElevatedButton.styleFrom(
          elevation: 6.0,
          backgroundColor: kDeepBlueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title!,
            style: kMainButtonTextStyle,
          ),
        ),
      ),
    );
  }
}