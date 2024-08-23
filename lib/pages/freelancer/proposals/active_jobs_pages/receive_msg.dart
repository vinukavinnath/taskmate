import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/constants.dart';

class ReceiveMsg extends StatefulWidget {
  final QueryDocumentSnapshot activeJobDoc;
  final String jobtitle;

  const ReceiveMsg({
    Key? key,
    required this.activeJobDoc,
    required this.jobtitle,
  }) : super(key: key);

  @override
  _ReceiveMsgState createState() => _ReceiveMsgState();
}

class _ReceiveMsgState extends State<ReceiveMsg> {
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
          'sender': 'freelancer',
        });

        _messageController.clear();

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Message sent successfully'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobtitle,
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage('images/noise_image.webp'),
          ),
        ),
        child: Padding(
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

                        bool isFreelancer = sender == 'freelancer';

                        return Align(
                          alignment: isFreelancer
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isFreelancer
                                  ? const Color(
                                      0xFF5696FA) // Freelancer message bubble color
                                  : const Color(
                                      0xFFB4D7FE), // Different color for client
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isFreelancer
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                                bottomRight: isFreelancer
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
                                    fontSize: 16.0, // Ensuring readability
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
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
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).primaryColor, // Matching color
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
