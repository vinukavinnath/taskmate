import 'package:flutter/material.dart';

import 'package:taskmate/constants.dart';

class VerifyIdentityOutlinedButton extends StatelessWidget {
  const VerifyIdentityOutlinedButton({
    super.key,
    required this.hyperlinkText,
    this.function,
  });

  final String hyperlinkText;
  final void Function()? function;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: function,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(color: kDarkGreyColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.add_circle,
            color: kDeepBlueColor,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            hyperlinkText,
            style: kTextStyle.copyWith(
                color: kDeepBlueColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
