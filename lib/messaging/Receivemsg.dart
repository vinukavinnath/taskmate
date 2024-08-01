import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart'; // To format date and time

class Receivemsg extends StatefulWidget {
  Receivemsg({super.key});

  @override
  State<Receivemsg> createState() => _ReceivemsgState();
}

class _ReceivemsgState extends State<Receivemsg> {
  final Stream<QuerySnapshot> listMsg = FirebaseFirestore.instance
      .collection('message')
      .orderBy("date", descending: true)
      .snapshots();

  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/noise_image.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 120,
          title: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      color: Color(0xFF16056B),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.search, size: 20, color: Color(0xFF4B4646)),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "search",
                      style: TextStyle(fontSize: 15, color: Color(0xFF4B4646)),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.filter_list, size: 25, color: Color(0xFF4B4646)),
                    ),
                  ],
                ),
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF4B4646)),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/noise_image.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: listMsg,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Connection error"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No messages yet."));
                    }
                    var docs = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true, // To show the most recent message at the bottom
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var message = docs[index];
                        var dateTime = (message['date'] as Timestamp).toDate();
                        String formattedDate = DateFormat('h:mm a - d/M/y').format(dateTime);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(message['image']),
                                radius: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['text'],
                                        style: TextStyle(fontSize: 15, color: Color(0xFF4B4646)),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Color(0xFF16056B)),
                                onPressed: () async {
                                  deleteMsg(message.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFF16056B)),
                    onPressed: () {
                      sendMsg(_replyController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteMsg(String id) {
    FirebaseFirestore.instance.collection('messages').doc(id).delete();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Deleted',
      text: 'Message is permanently deleted',
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void sendMsg(String text) {
    if (text.isNotEmpty) {
      FirebaseFirestore.instance.collection('message').add({
        'text': text,
        'date': Timestamp.now(),
        'image': 'https://example.com/default_user_image.png', // Update with the appropriate image URL or logic
      });
      _replyController.clear();
    }
  }
}
