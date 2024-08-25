import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
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
  void initState() {
    super.initState();
    imageUrl3 = widget.activeJobDoc['image3Url'];
    imageUrl4 = widget.activeJobDoc['image4Url'];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final subData = widget.activeJobDoc.data() as Map<String, dynamic>;
    final jobTitle = subData['jobTitle'] as String;

    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Preview Submissions',
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
                          _showFullScreenImage(context, imageUrl3);
                        },
                        child: AttachmentCard(
                          cardChild: Image.network(imageUrl3),
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
                          _showFullScreenImage(context, imageUrl4);
                        },
                        child: AttachmentCard(
                          cardChild: Image.network(imageUrl4),
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
                  // Show a SnackBar indicating success
                  ScaffoldMessenger.of(context).showSnackBar(
                    CusSnackBar(
                      backColor: kSuccessGreenColor,
                      time: 2,
                      title: 'Successfully Hired!',
                      icon: Icons.assignment_turned_in,
                    ),
                  );
                } catch (e) {
                  // Handle errors, and show a SnackBar indicating failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    CusSnackBar(
                      backColor: kWarningRedColor,
                      time: 2,
                      title: 'Freelancer can\'t be Hired!',
                      icon: Icons.error,
                    ),
                  );
                }
              },
              screenWidth: screenWidth,
            ),
            LightMainButton(
              title: 'Any Revisions?',
              process: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientActiveJobsSendMsg(
                      activeJobDoc: widget.activeJobDoc,
                      jobtitle: jobTitle,
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
        onReceiveProgress: (received, total) {},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Downloading complete'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
