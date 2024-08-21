import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/constants.dart';

class FreelancerCompleteJobsReceiveMsg extends StatefulWidget {
  final QueryDocumentSnapshot activeJobDoc;

  const FreelancerCompleteJobsReceiveMsg({
    Key? key,
    required this.activeJobDoc,
  }) : super(key: key);

  @override
  _FreelancerCompleteJobsReceiveMsgState createState() => _FreelancerCompleteJobsReceiveMsgState();
}

class _FreelancerCompleteJobsReceiveMsgState extends State<FreelancerCompleteJobsReceiveMsg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('',
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
            fit: BoxFit.cover,
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

                        bool isFreelancer = sender == 'freelancer';

                        return Align(
                          alignment: isFreelancer ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isFreelancer
                                  ? Color(0xFF5696FA) // Freelancer message bubble color
                                  : Color(0xFFB4D7FE), // Different color for client
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: isFreelancer
                                    ? Radius.circular(12)
                                    : Radius.circular(0),
                                bottomRight: isFreelancer
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
                                    fontSize: 16.0, // Ensuring readability
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
      ),
    );
  }
}
