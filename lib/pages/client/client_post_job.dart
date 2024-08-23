import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskmate/classes/cus_snackbar.dart';
import 'package:taskmate/client_home_page.dart';
import 'package:taskmate/components/attachment_card.dart';
import 'package:taskmate/components/dark_main_button.dart';
import 'package:taskmate/components/freelancer/user_data_gather_textfield.dart';
import 'package:taskmate/components/freelancer/user_data_gather_title.dart';
import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/components/maintenance_page.dart';
import 'package:taskmate/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'dart:async';

class ClientPostJob extends StatefulWidget {
  const ClientPostJob({
    // required this.client,
    Key? key,
  });

  // final UserModel1 client;

  @override
  State<ClientPostJob> createState() => _ClientPostJobState();
}

class _ClientPostJobState extends State<ClientPostJob> {
  final formKey = GlobalKey<FormState>();
  final List<String> _skills = [];
  final String _skillsText = '';

// Audio recording feature
  final record = AudioRecorder();
  final player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? recordingPath;
  Timer? _timer;
  Duration _duration = Duration.zero;

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();
  final TextEditingController dayCountController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  File? _selectedImage1;
  File? _selectedImage2;

  @override
  void initState() {
    super.initState();
    // Request microphone permission when the widget is initialized
    requestPermissions();
  }

  @override
  void dispose() {
    // Dispose of the text controllers to prevent memory leaks
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    dayCountController.dispose();
    budgetController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void selectService(String serviceName) {
    setState(() {
      _skills
          .add(serviceName.toLowerCase()); // Convert to lowercase before adding
      skillController.text = _skills.join(', '); // Update the text field
    });
  }

  Future<void> uploadFile(int imageNumber) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        File selectedImage = File(result.files.single.path!);
        setState(() {
          if (imageNumber == 1) {
            _selectedImage1 = selectedImage;
          } else if (imageNumber == 2) {
            _selectedImage2 = selectedImage;
          }
        });
      }
    } catch (e) {
      // Handle errors
    }
  }

  Future<String?> uploadRecordingToStorage(
      String recordingPath, String recordingName) async {
    try {
      // Get a reference to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a reference to the location you want to upload the recording
      Reference ref = storage.ref().child('recordings').child(recordingName);

      // Upload the recording file
      UploadTask uploadTask = ref.putFile(File(recordingPath));

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded recording
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle any errors that occur during the upload
      return null;
    }
  }

  Future<void> addJobToFirestore(
    String jobTitle,
    String jobDescription,
    int dayCount,
    int Percentage,
    int releaseMoney,
    int budget,
  ) async {
    try {
      // Get the current user's UID from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;
      String? userUid = user?.uid;

      if (userUid == null) {
        // Handle the case where the user is not authenticated
        return;
      }

      // Get a reference to the Firestore collection
      CollectionReference jobsCollection =
          FirebaseFirestore.instance.collection('jobs');

      // Generate a unique job ID (e.g., using a timestamp)
      String timestamp = Timestamp.now().millisecondsSinceEpoch.toString();

      // Use the user's UID as the document ID for the main job document
      DocumentReference jobDocument = jobsCollection.doc(userUid);

      // Create or update a subcollection called "jobsnew" under the main job document
      CollectionReference jobsNewCollection = jobDocument.collection('jobsnew');

      // Upload images to Firebase Storage and get download URLs
      String? image1Url =
          await uploadImageToStorage(_selectedImage1, 'image1_$timestamp');
      String? image2Url =
          await uploadImageToStorage(_selectedImage2, 'image2_$timestamp');

      // Initialize the recordingUrl as null
      String? recordingUrl;

      // Check if recordingPath is not null before uploading the recording
      if (recordingPath != null) {
        recordingUrl = await uploadRecordingToStorage(
            recordingPath!, 'recording_$timestamp');
      }

      // Add job data to Firestore within the "jobsnew" subcollection
      await jobsNewCollection.doc(timestamp).set({
        'JobID': timestamp,
        'jobTitle': jobTitle,
        'jobDescription': jobDescription,
        'dayCount': dayCount,
        'budget': budget,
        'skills': _skills,
        'image1Url':
            image1Url ?? '', // Use an empty string as a default value if null
        'image2Url':
            image2Url ?? '', // Use an empty string as a default value if null
        'recordingUrl': recordingUrl ??
            '', // Set to an empty string if no recording URL is available
        'status': 'new', // Set the status to "active"
        'releaseMoney': releaseMoney,
        'Percentage': Percentage, // Fixed typo from Precentage to Percentage
        'createdAt': FieldValue.serverTimestamp(), // Add the timestamp field
      });
    } catch (e) {
      // Handle any errors that occur
    }
  }

// Request microphone permission
  Future<void> requestPermissions() async {
    // Check if the permission is already granted
    var status = await Permission.microphone.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

// Checks for the permission
  Future<bool> checkPermission() async {
    var status = await Permission.microphone.status;
    return status.isGranted;
  }

// Starts recording
  Future<void> startRecording() async {
    bool permissionGranted = await checkPermission();
    if (permissionGranted) {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      final String filePath = p.join(appDocumentsDir.path, "rec.wav");
      await record.start(const RecordConfig(), path: filePath);
      setState(() {
        _isRecording = true;
        _duration = Duration.zero;
        recordingPath = null;
      });
      _startTimer();
    } else {
      if (context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CusSnackBar(
          backColor: kWarningRedColor,
          time: 3,
          title: 'You don\'t have access to record voice',
          icon: Icons.dangerous,
        ),
      );
    }
  }

// Stops recording
  Future<void> stopRecording() async {
    String? filePath = await record.stop();
    _stopTimer();
    if (filePath != null) {
      setState(() {
        _isRecording = false;
        recordingPath = filePath;
      });
    }
  }

// Deletes recording
  Future<void> deleteRecording() async {
    if (recordingPath != null) {
      File file = File(recordingPath!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          recordingPath = null;
          _isRecording = false;
          _isPlaying = false;
        });
      }
    }
  }

// Starts counting time
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds + 1);
      });
    });
  }

// Stops counting time
  void _stopTimer() {
    _timer?.cancel();
  }

// Formats recording time
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

// Uploads audio
  Future<String?> uploadFileToFirebase(String filePath) async {
    File file = File(filePath);
    try {
      String fileName = p.basename(filePath);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('recordings/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Post a Job',
            style: kHeadingTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 4,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.navigate_before,
              color: kDeepBlueColor,
            ),
          ),
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
        ),
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/noise_image.webp'),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Job Title',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: UserDataGatherTextField(
                      controller: jobTitleController,
                      hintText: 'Ex: Need a Logo designer',
                      validatorText: 'Field can\'t be empty',
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Describe about the project',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: jobDescriptionController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        hintText: 'Add job description here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1.0,
                            color: kDarkGreyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: kDeepBlueColor,
                          ),
                        ),
                        filled: true,
                      ),
                      maxLines: 6,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Skills',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: skillController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        hintText: 'Add Skills',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1.0,
                            color: kDarkGreyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: kDeepBlueColor,
                          ),
                        ),
                        filled: true,
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Service 1 and Service 2 side by side
                      GestureDetector(
                        onTap: () => selectService('Logo Design'),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 26.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0), // Adjust the padding
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: kDarkGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Logo Design',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreyColor,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => selectService('Illustrator'),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0), // Adjust the padding
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: kDarkGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Illustrator',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreyColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Service 1 and Service 2 side by side
                      GestureDetector(
                        onTap: () => selectService('Photoshop'),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 26.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0), // Adjust the padding
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: kDarkGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Photoshop',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreyColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Job done within',
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth / 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFormField(
                            controller: dayCountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: '1-12',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1.0,
                                  color: kDarkGreyColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: kDeepBlueColor,
                                ),
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const Text('Days'),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Budget',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 5.0,
                          ),
                          child: Text(
                            'LKR',
                            style: TextStyle(
                              color: kDarkGreyColor,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                        hintText: '1000-4500',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1.0,
                            color: kDarkGreyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: kDeepBlueColor,
                          ),
                        ),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field can\'t be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Add a Sketch of your Idea',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        uploadFile(1);
                      },
                      child: AttachmentCard(
                        cardChild: _selectedImage1 != null
                            ? Image.file(
                                _selectedImage1!,
                                fit: BoxFit.cover, // Adjust the fit as needed
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Tap to upload a file',
                                    style: TextStyle(
                                      color: kJetBlack,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8.0), // Adjust the space between text and icon as needed
                                  Icon(
                                    Icons.upload_file,
                                    color: kJetBlack,
                                  ),
                                ],
                              ), // Empty container if _selectedImage2 is null
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedImage1 = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius as needed
                          ),
                          side: const BorderSide(
                              color:
                                  kJetBlack), // Optional: customize the border color
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            color: kJetBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () async {
                        uploadFile(2);
                      },
                      child: AttachmentCard(
                        cardChild: _selectedImage2 != null
                            ? Image.file(
                                _selectedImage2!,
                                fit: BoxFit.cover, // Adjust the fit as needed
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Tap to upload a file',
                                    style: TextStyle(
                                      color: kJetBlack,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8.0), // Adjust the space between text and icon as needed
                                  Icon(
                                    Icons.upload_file,
                                    color: kJetBlack,
                                  ),
                                ],
                              ), // Empty container if _selectedImage2 is null
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedImage2 = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius as needed
                          ),
                          side: const BorderSide(
                              color:
                                  kJetBlack), // Optional: customize the border color
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            color: kJetBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const UserDataGatherTitle(
                    title: 'Explain with a Voice Recording',
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kDarkGreyColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius:
                          BorderRadius.circular(12), // Border radius (optional)
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            _isRecording
                                ? "Recording: ${_formatDuration(_duration)}"
                                : recordingPath != null
                                    ? "Recorded: ${_formatDuration(_duration)}"
                                    : "Tap Mic button to Record",
                            style: kSubHeadingTextStyle,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(
                                8.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isRecording
                                    ? kOceanBlueColor
                                    : kDeepBlueColor,
                              ),
                              child: Center(
                                child: IconButton(
                                  tooltip: _isRecording
                                      ? 'Tap here to Stop'
                                      : 'Tap here to record',
                                  onPressed: () async {
                                    if (_isRecording) {
                                      await stopRecording();
                                    } else {
                                      await startRecording();
                                    }
                                  },
                                  icon: Icon(
                                    _isRecording ? Icons.stop : Icons.mic,
                                    color: kBrilliantWhite,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(
                                8.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: recordingPath != null
                                    ? kWarningRedColor
                                    : null,
                              ),
                              child: IconButton(
                                tooltip: recordingPath != null
                                    ? 'Delete recording'
                                    : null,
                                onPressed: recordingPath != null
                                    ? deleteRecording
                                    : null,
                                icon: const Icon(Icons.delete),
                                color: recordingPath != null
                                    ? kAshWhiteColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Container(
                            child: recordingPath != null
                                ? LightMainButton(
                                    process: () async {
                                      if (player.playing) {
                                        player.stop();
                                        setState(() {
                                          _isPlaying = false;
                                        });
                                      } else {
                                        await player
                                            .setFilePath(recordingPath!);
                                        player.play();
                                        setState(() {
                                          _isPlaying = true;
                                        });
                                      }
                                    },
                                    title: _isPlaying ? "Stop" : "Play",
                                    screenWidth: screenWidth / 2,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DarkMainButton(
                    title: 'Post Job Now',
                    process: () {
                      if (formKey.currentState!.validate()) {
                        String jobTitle = jobTitleController.text;
                        String jobDescription = jobDescriptionController.text;
                        int dayCount =
                            int.tryParse(dayCountController.text) ?? 0;
                        int budget = int.tryParse(budgetController.text) ?? 0;
                        int percentage =
                            int.tryParse(budgetController.text) ?? 0;
                        int releaseMoney =
                            int.tryParse(budgetController.text) ?? 0;

                        addJobToFirestore(
                          jobTitle,
                          jobDescription,
                          dayCount,
                          budget,
                          releaseMoney,
                          percentage,
                        );
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return MaintenancePage(
                              [
                                const Image(
                                  image: AssetImage('images/tick.webp'),
                                ),
                                Text(
                                  'Posted!',
                                  style: kSubHeadingTextStyle.copyWith(
                                      height: 0.5),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Now keep in touch with your job for bids.',
                                    style: kTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DarkMainButton(
                                    title: 'Visit Job Status',
                                    process: () {
                                      // Navigator.of(context).pushReplacement(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => ClientHomePage(
                                      //       passedIndex: 2,
                                      //       // selectedIndex: 2,
                                      //       // client: widget.client,
                                      //     ),
                                      //   ),
                                      // );
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientHomePage(passedIndex: 2)),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    screenWidth: screenWidth),
                              ],
                            );
                          },
                        );
                      }
                    },
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImageToStorage(File? image, String imageName) async {
    if (image == null) {
      return null;
    }

    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$imageName');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() async {
        // Wait for the upload to complete and then return the download URL
        return await storageReference.getDownloadURL();
      });

      // If the await inside whenComplete doesn't work as expected,
      // you can try using await for the whole operation
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      // Handle errors
    }

    return null;
  }
}
