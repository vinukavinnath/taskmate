import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/constants.dart';

class ClientActiveJobsSendMsg extends StatefulWidget {
  final QueryDocumentSnapshot activeJobDoc;
  final String jobtitle;

  const ClientActiveJobsSendMsg({
    Key? key,
    required this.activeJobDoc,
    required this.jobtitle,
  }) : super(key: key);

  @override
  _ClientActiveJobsSendMsgState createState() =>
      _ClientActiveJobsSendMsgState();
}

class _ClientActiveJobsSendMsgState extends State<ClientActiveJobsSendMsg> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    String message = _messageController.text;

    if (message.isNotEmpty) {
      try {
        await widget.activeJobDoc.reference.collection('messages').add({
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'sender': 'client', // Adjust based on user type
        });

        _messageController.clear();

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Message sent successfully'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          CusSnackBar(
            backColor: kWarningRedColor,
            time: 2,
            title: 'Message was not Sent!',
            icon: Icons.error,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CusSnackBar(
          backColor: kAmberColor,
          time: 2,
          title: 'Please type any Message',
          icon: Icons.feedback,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.jobtitle,
          style: kSubHeadingTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: kDeepBlueColor,
            size: 40.0,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage('images/noise_image.webp'),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.activeJobDoc.reference
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading messages'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data?.docs ?? [];

                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final sender = message['sender'];
                      final text = message['message'];
                      final timestamp = message['timestamp'] as Timestamp?;
                      final time = timestamp != null
                          ? DateFormat('h:mm a').format(timestamp.toDate())
                          : 'Time not available';

                      bool isClient = sender == 'client';

                      return Align(
                        alignment: isClient
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isClient
                                ? const Color(0xFF5696FA) // Your specified color
                                : const Color(0xFFB4D7FE),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isClient
                                  ? const Radius.circular(12)
                                  : const Radius.circular(0),
                              bottomRight: isClient
                                  ? const Radius.circular(0)
                                  : const Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
