import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Sendmsg extends StatefulWidget {
  Sendmsg({super.key});

  @override
  State<Sendmsg> createState() => _SendmsgState();
}

class _SendmsgState extends State<Sendmsg> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('message').orderBy('date', descending: true).snapshots(),
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

                      bool isRightSide = index % 2 == 0;
                      Color circleColor = isRightSide ? Color(0xFF16056B) : Color(0xFF5696FA);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isRightSide) CircleAvatar(
                              backgroundColor: circleColor,
                              backgroundImage: NetworkImage(message['image']),
                              radius: 20,
                            ),
                            if (!isRightSide) const SizedBox(width: 10),
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
                                      "${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isRightSide) const SizedBox(width: 10),
                            if (isRightSide) CircleAvatar(
                              backgroundColor: circleColor,
                              backgroundImage: NetworkImage(message['image']),
                              radius: 20,
                            ),
                          ],
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
                        hintText: "Type your message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFF4B4646)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFF16056B)),
                    onPressed: () async {
                      if (_messageController.text.trim().isNotEmpty) {
                        await _firestore.collection('message').add({
                          'text': _messageController.text,
                          'date': Timestamp.now(),
                          'image': 'https://example.com/profile_image.png', // Replace with actual profile image URL
                        });
                        _messageController.clear();
                      }
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
}
