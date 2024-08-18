import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ClientCompleteJobsSendMsg extends StatefulWidget {
  final QueryDocumentSnapshot activeJobDoc;

  const ClientCompleteJobsSendMsg({
    Key? key,
    required this.activeJobDoc,
  }) : super(key: key);

  @override
  _ClientCompleteJobsSendMsgState createState() => _ClientCompleteJobsSendMsgState();
}

class _ClientCompleteJobsSendMsgState extends State<ClientCompleteJobsSendMsg> {
  final String predefinedMessage = "Hello, this is a predefined message.";

  void _sendMessage() async {
    String message = predefinedMessage;

    if (message.isNotEmpty) {
      try {
        await widget.activeJobDoc.reference.collection('messages').add({
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'sender': 'client', // Adjust based on user type
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message sent successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error sending message: $e'); // Detailed logging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message is empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    return Center(child: Text('Error loading messages'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data?.docs ?? [];

                  if (messages.isEmpty) {
                    return Center(child: Text('No messages yet'));
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
                        alignment:
                        isClient ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isClient
                                ? Color(0xFF5696FA) // Your specified color
                                : Color(0xFFB4D7FE),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isClient
                                  ? Radius.circular(12)
                                  : Radius.circular(0),
                              bottomRight: isClient
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                time,
                                style: TextStyle(
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

          ],
        ),
      ),
    );
  }
}
