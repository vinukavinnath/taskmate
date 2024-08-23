import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Files extends StatefulWidget {
  final String image3Url;
  final String image4Url;
  final QueryDocumentSnapshot completeJobDoc;

  const Files({
    super.key,
    required this.image3Url,
    required this.image4Url,
    required this.completeJobDoc,
  });

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  late final String imageUrl3;
  late final String imageUrl4;

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    try {
      // Check and request permission for Android
      if (await Permission.storage.request().isGranted) {
        // Get the directory to save the file
        final directory = await getExternalStorageDirectory();
        final filePath =
            '${directory!.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Display a Snackbar indicating the download has started
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Text('Downloading image...'),
              ],
            ),
            backgroundColor: kAmberColor, // Set background color
            duration: const Duration(
                days: 1), // Keep Snackbar visible until download is complete
          ),
        );

        // Download the image
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // Notify user that the image was saved successfully
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(); // Hide the previous Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text('File saved successfully'),
                ],
              ),
              backgroundColor: kSuccessGreenColor, // Set success color
              duration: const Duration(
                  seconds: 3), // Show success message for 3 seconds
            ),
          );
        } else {
          // Notify user about the failure
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(); // Hide the previous Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text('Failed to download image'),
                ],
              ),
              backgroundColor: kWarningRedColor, // Set error color
              duration: const Duration(
                  seconds: 3), // Show error message for 3 seconds
            ),
          );
        }
      } else {
        // Handle the case where permission is not granted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const <Widget>[
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 8.0),
                Text('Storage permission denied'),
              ],
            ),
            backgroundColor: kWarningRedColor, // Set error color
            duration:
                const Duration(seconds: 3), // Show error message for 3 seconds
          ),
        );
      }
    } catch (e) {
      // Notify user about the error
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Hide the previous Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(
                Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text('Error occurred: $e'),
            ],
          ),
          backgroundColor: kWarningRedColor, // Set error color
          duration:
              const Duration(seconds: 3), // Show error message for 3 seconds
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    imageUrl3 = widget.completeJobDoc['image3Url'];
    imageUrl4 = widget.completeJobDoc['image4Url'];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Submitted Submissions',
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
                  child: imageUrl3 != null && imageUrl3.isNotEmpty
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _showFullScreenImage(context, imageUrl3),
                              child: AttachmentCard(
                                cardChild: Image.network(imageUrl3),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await downloadImage(context, imageUrl3);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.download,
                                    color: kDarkGreyColor,
                                  ),
                                  Text(
                                    'Download',
                                    style: kTextStyle,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'Attachment 1 was not submitted',
                            textAlign: TextAlign.center,
                            style: kUserDataGatherTitleTextStyle.copyWith(
                                color: kWarningRedColor),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: imageUrl4 != null && imageUrl4.isNotEmpty
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _showFullScreenImage(context, imageUrl4),
                              child: AttachmentCard(
                                cardChild: Image.network(imageUrl4),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await downloadImage(context, imageUrl4);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.download,
                                    color: kDarkGreyColor,
                                  ),
                                  Text(
                                    'Download',
                                    style: kTextStyle,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'Attachment 1 was not submitted',
                            textAlign: TextAlign.center,
                            style: kUserDataGatherTitleTextStyle.copyWith(
                                color: kWarningRedColor),
                          ),
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
