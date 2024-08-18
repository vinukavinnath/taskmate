import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:url_launcher/url_launcher.dart';

import 'client_active_jobs_sendmsg.dart';

class ClientActiveJobFiles extends StatefulWidget {
  final String image3Url;
  final String image4Url;
  final QueryDocumentSnapshot activeJobDoc;

  const ClientActiveJobFiles({
    Key? key,
    required this.image3Url,
    required this.image4Url,
    required this.activeJobDoc,
  }) : super(key: key);

  @override
  State<ClientActiveJobFiles> createState() => _ClientActiveJobFilesState();
}

class _ClientActiveJobFilesState extends State<ClientActiveJobFiles> {
  late final String imageUrl3;
  late final String imageUrl4;

  @override
  void initState() {
    super.initState();
    imageUrl3 = widget.activeJobDoc['image3Url'];
    imageUrl4 = widget.activeJobDoc['image4Url'];
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
              'Download Submissions',
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
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Open the image in a new screen or show a larger version
                          // based on your specific requirements.
                        },
                        child: AttachmentCard(
                          cardChild: Image.network(imageUrl3),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Trigger the download action
                          _downloadImage(context, imageUrl3);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Open the image in a new screen or show a larger version
                          // based on your specific requirements.
                        },
                        child: AttachmentCard(
                          cardChild: Image.network(imageUrl4),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Trigger the download action
                          _downloadImage(context, imageUrl4);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            DarkMainButton(
              title: 'Accept',
              process: () async {
                try {
                  // Update the status to "complete" in Firestore
                  await widget.activeJobDoc.reference
                      .update({'status': 'complete'});

                  // TODO: Add any other processing logic if needed

                  // Show a SnackBar indicating success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Job accepted and complete'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  // Handle errors, and show a SnackBar indicating failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error accepting job: $e'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              screenWidth: screenWidth,
            ),

            LightMainButton(
              title: 'Message',
              process: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientActiveJobsSendMsg(
                      activeJobDoc: widget.activeJobDoc,
                    ),
                  ),
                );
              },
              screenWidth: screenWidth,
            )

          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    final dio = Dio();
    final fileName = imageUrl.split('/').last;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final savePath = directory.path + '/$fileName';

      final response = await dio.download(
        imageUrl,
        savePath,
        onReceiveProgress: (received, total) {
          print("Received: $received, Total: $total");
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloading complete'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
