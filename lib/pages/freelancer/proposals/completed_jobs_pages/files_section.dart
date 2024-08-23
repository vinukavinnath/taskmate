import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/constants.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../components/snackbar.dart';

class Files extends StatefulWidget {
  final QueryDocumentSnapshot completeJobDoc;

  const Files({
    Key? key,
    required this.completeJobDoc,
  }) : super(key: key);

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final imageUrl3 = widget.completeJobDoc['image3Url'];
    final imageUrl4 = widget.completeJobDoc['image4Url'];

    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Submitted work',
              style: kJobCardTitleTextStyle.copyWith(
                color: kJetBlack,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: imageUrl3 != null && imageUrl3!.isNotEmpty
                      ? GestureDetector(
                          onTap: () =>
                              _showFullScreenImage(context, imageUrl3!),
                          child: AttachmentCard(
                            cardChild: Image.network(imageUrl3!),
                          ),
                        )
                      : Text(
                          'No Attachment 1 Available',
                          style: kTextStyle.copyWith(color: kWarningRedColor),
                        ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: imageUrl4 != null && imageUrl4!.isNotEmpty
                      ? GestureDetector(
                          onTap: () =>
                              _showFullScreenImage(context, imageUrl4!),
                          child: AttachmentCard(
                            cardChild: Image.network(imageUrl4!),
                          ),
                        )
                      : Text(
                          'No Attachment 2 Available',
                          style: kTextStyle.copyWith(color: kWarningRedColor),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
