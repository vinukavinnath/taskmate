import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:taskmate/constants.dart';

import '../../components/job_card.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    // Adding a listener to the search controller to handle debounce
    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final value = _searchController.text.trim();
    if (value != searchTerm) {
      setState(() {
        searchTerm = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'Projects',
              style: kHeadingTextStyle,
            ),
          ),
          elevation: 0,
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
          bottom: TabBar(
            controller: _tabController,
            labelColor: kDeepBlueColor,
            unselectedLabelColor: kDarkGreyColor,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            indicatorColor: kDeepBlueColor,
            tabs: const [
              Tab(text: 'Search'),
              Tab(text: 'Most Recent'),
              Tab(text: 'Urgent'),
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
            controller: _tabController,
            children: [
              // Search Tab
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by skills...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: JobList(
                      searchTerm: searchTerm,
                    ),
                  ),
                ],
              ),

              // Most Recent Tab
              RecentJobs(screenWidth: screenWidth),

              // Urgent Tab
              UrgentJobs(screenWidth: screenWidth),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentJobs extends StatelessWidget {
  final double screenWidth;

  RecentJobs({required this.screenWidth});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No documents found.'),
          );
        }

        final jobDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: jobDocs.length,
          itemBuilder: (context, index) {
            final doc = jobDocs[index];
            return StreamBuilder<QuerySnapshot>(
              stream: doc.reference
                  .collection('jobsnew')
                  .where('status', isEqualTo: 'new')
                  .snapshots(),
              builder: (context, subSnapshot) {
                if (subSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!subSnapshot.hasData ||
                    subSnapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink(); // Avoid returning a widget if no data found
                }

                final matchingJobDocs = subSnapshot.data!.docs;

                // Create a Set to keep track of unique job IDs
                final Set<String> uniqueJobIds = Set();

                // Filter out duplicate jobs
                final filteredJobDocs =
                matchingJobDocs.where((subDoc) {
                  final jobId = subDoc.id;
                  if (uniqueJobIds.contains(jobId)) {
                    return false; // Skip duplicate job
                  } else {
                    uniqueJobIds.add(jobId);
                    return true; // Include unique job
                  }
                }).toList();

                // Customize how you want to display each matching job in the list
                return Column(
                  children: filteredJobDocs.map<Widget>((subDoc) {
                    return JobCard(
                        mostjobDoc: subDoc, screenWidth: screenWidth);
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class UrgentJobs extends StatelessWidget {
  final double screenWidth;

  UrgentJobs({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No documents found.'),
          );
        }

        final jobDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: jobDocs.length,
          itemBuilder: (context, index) {
            final doc = jobDocs[index];
            return StreamBuilder<QuerySnapshot>(
              stream: doc.reference
                  .collection('jobsnew')
                  .where('status', isEqualTo: 'new')
                  .where('dayCount', isEqualTo: 1)
                  .snapshots(),
              builder: (context, subSnapshot) {
                if (subSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!subSnapshot.hasData ||
                    subSnapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink(); // Avoid returning a widget if no data found
                }

                final matchingJobDocs = subSnapshot.data!.docs;

                // Create a Set to keep track of unique job IDs
                final Set<String> uniqueJobIds = Set();

                // Filter out duplicate jobs
                final filteredJobDocs =
                matchingJobDocs.where((subDoc) {
                  final jobId = subDoc.id;
                  if (uniqueJobIds.contains(jobId)) {
                    return false; // Skip duplicate job
                  } else {
                    uniqueJobIds.add(jobId);
                    return true; // Include unique job
                  }
                }).toList();

                // Customize how you want to display each matching job in the list
                return Column(
                  children: filteredJobDocs.map<Widget>((subDoc) {
                    return JobCard(
                        mostjobDoc: subDoc, screenWidth: screenWidth);
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class JobList extends StatelessWidget {
  final String searchTerm;

  JobList({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No jobs found.'),
          );
        }

        final jobDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: jobDocs.length,
          itemBuilder: (context, index) {
            final doc = jobDocs[index];
            return StreamBuilder<QuerySnapshot>(
              stream: doc.reference
                  .collection('jobsnew')
                  .where('status', isEqualTo: 'new')
                  .where('skills', arrayContains: searchTerm)
                  .snapshots(),
              builder: (context, subSnapshot) {
                if (subSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!subSnapshot.hasData ||
                    subSnapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink(); // Avoid returning a widget if no data found
                }

                final matchingJobDocs = subSnapshot.data!.docs;

                // Create a Set to keep track of unique job IDs
                final Set<String> uniqueJobIds = Set();

                // Filter out duplicate jobs
                final filteredJobDocs =
                matchingJobDocs.where((subDoc) {
                  final jobId = subDoc.id;
                  if (uniqueJobIds.contains(jobId)) {
                    return false; // Skip duplicate job
                  } else {
                    uniqueJobIds.add(jobId);
                    return true; // Include unique job
                  }
                }).toList();

                // Customize how you want to display each matching job in the list
                return Column(
                  children: filteredJobDocs.map<Widget>((subDoc) {
                    return JobCard(
                        mostjobDoc: subDoc, screenWidth: screenWidth);
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
