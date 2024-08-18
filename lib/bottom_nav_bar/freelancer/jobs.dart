import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmate/components/job_card.dart';
import 'package:taskmate/constants.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late TabController _tabController;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    _searchController.addListener(() {
      _onSearchChanged();
    });

    _searchFocusNode.addListener(() {
      setState(() {}); // Update UI based on focus changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
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
              // "Search" Tab
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search by skills...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: kDarkGreyColor,
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide.none, // Remove the default border
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                              color:
                                  kDeepBlueColor), // Border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                              color: kDeepBlueColor,
                              width: 2.0), // Border color when focused
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: JobList(
                      searchTerm: searchTerm,
                      focusNode: _searchFocusNode,
                    ),
                  ),
                ],
              ),

              // Most Recent Tab
              RecentJobs(screenWidth: screenWidth),

              // Urgent Tab
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.paid, color: kDeepBlueColor),
                          Expanded(
                            // Wrap Text with Expanded to avoid overflow
                            child: Text(
                              'Jobs that need to be completed within 1 Day. Remember, lower time means higher charges.',
                              textAlign: TextAlign.center,
                              style: kUserDataGatherTitleTextStyle,
                              softWrap:
                                  true, // Allows text to wrap to the next line
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: UrgentJobs(screenWidth: screenWidth)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentJobs extends StatelessWidget {
  final double screenWidth;

  const RecentJobs({required this.screenWidth});

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

                if (!subSnapshot.hasData || subSnapshot.data!.docs.isEmpty) {
                  return const SizedBox
                      .shrink(); // Avoid returning a widget if no data found
                }

                final matchingJobDocs = subSnapshot.data!.docs;

                // Create a Set to keep track of unique job IDs
                final Set<String> uniqueJobIds = Set();

                // Filter out duplicate jobs
                final filteredJobDocs = matchingJobDocs.where((subDoc) {
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

  const UrgentJobs({required this.screenWidth});

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

                if (!subSnapshot.hasData || subSnapshot.data!.docs.isEmpty) {
                  return const SizedBox
                      .shrink(); // Avoid returning a widget if no data found
                }

                final matchingJobDocs = subSnapshot.data!.docs;

                // Create a Set to keep track of unique job IDs
                final Set<String> uniqueJobIds = Set();

                // Filter out duplicate jobs
                final filteredJobDocs = matchingJobDocs.where((subDoc) {
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
  final FocusNode focusNode;

  const JobList({
    required this.searchTerm,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
            child: Text('Nothing found.'),
          );
        }

        final jobDocs = snapshot.data!.docs;
        List<Widget> jobCards = [];
        int jobCount = 0;

        return FutureBuilder<void>(
          future: Future.forEach(jobDocs, (QueryDocumentSnapshot doc) async {
            final subSnapshot = await doc.reference
                .collection('jobsnew')
                .where('status', isEqualTo: 'new')
                .where('skills', arrayContains: searchTerm)
                .get();

            if (subSnapshot.docs.isNotEmpty) {
              // Create a Set to keep track of unique job IDs
              final Set<String> uniqueJobIds = Set();

              // Filter out duplicate jobs
              final filteredJobDocs = subSnapshot.docs.where((subDoc) {
                final jobId = subDoc.id;
                if (uniqueJobIds.contains(jobId)) {
                  return false; // Skip duplicate job
                } else {
                  uniqueJobIds.add(jobId);
                  return true; // Include unique job
                }
              }).toList();

              // Add the count of filtered jobs to the total job count
              jobCount += filteredJobDocs.length;

              jobCards.addAll(
                filteredJobDocs.map<Widget>((subDoc) {
                  return JobCard(mostjobDoc: subDoc, screenWidth: screenWidth);
                }).toList(),
              );
            }
          }),
          builder: (context, futureSnapshot) {
            if (searchTerm.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.travel_explore,
                        color: kDeepBlueColor,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      'Search for your Skill',
                      textAlign: TextAlign.center,
                      style: kUserDataGatherTitleTextStyle,
                      softWrap: true, // Allows text to wrap to the next line
                    ),
                  ],
                ),
              );
            } else if (jobCards.isEmpty) {
              return const Center(
                child: Text(
                  'Nothing found.',
                  style: kUserDataGatherTitleTextStyle,
                ),
              );
            } else {
              return Column(
                children: [
                  if (jobCount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.manage_search_rounded,
                            color: kDeepBlueColor,
                            size: 24.0,
                          ),
                        ),
                        Text(
                          'Found $jobCount jobs',
                          textAlign: TextAlign.center,
                          style: kUserDataGatherTitleTextStyle,
                        ),
                      ],
                    ),
                  Expanded(
                    child: ListView(
                      children: jobCards,
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
