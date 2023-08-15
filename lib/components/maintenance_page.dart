import 'package:flutter/material.dart';
import 'package:taskmate/constants.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage(
      this.items, {
        super.key,
      });

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ), //this right here
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kDeepBlueColor,width: 1.5,),
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage(
                'images/noise_image.webp',
              ),
              fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        ),
      ),
    );
  }
}