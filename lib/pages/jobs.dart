import 'package:flutter/material.dart';

import 'package:taskmate/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/components/job_card.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List<String> docIDs = [];

  //Getting docIDs
  Future<void> getDocIDs() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('available_projects').get();
    docIDs = snapshot.docs.map((element) => element.reference.id).toList();
  }

  @override
  void initState() {
    super.initState();
    // Use a Future inside initState to fetch data asynchronously
    // and use then to handle the result
    getDocIDs().then((_) {
      // Calling setState to rebuild the widget with the fetched data
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Projects',
                style: kHeadingTextStyle,
              ),
            ),
            elevation: 0, // Remove elevation for a cleaner look
            flexibleSpace: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'images/noise_image.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            bottom: const TabBar(
              labelColor: kDeepBlueColor,
              unselectedLabelColor: kDarkGreyColor,
              labelStyle: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
              unselectedLabelStyle: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
              indicatorColor: kDeepBlueColor,
              tabs: [
                Tab(text: 'Best Match'), // Add label for Tab 1
                Tab(text: 'Most Recent'), // Add label for Tab 2
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/noise_image.webp'),
              ),
            ),
            child: TabBarView(
              children: [
                //Best Match Jobs goes here
                FutureBuilder(
                    // future: getDocIDs(),
                    builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: JobCard(
                              documentID: docIDs[index].toString(),
                              screenWidth: screenWidth),
                        );
                      });
                }),

                // Center(
                //   child: Text('Tab 2 Content'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
