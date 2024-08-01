import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:taskmate/constants.dart';
import 'package:get/get.dart';
import 'package:taskmate/firebase_options.dart';
import 'package:taskmate/profile/client/user_repository1.dart';
import 'package:taskmate/profile/freelancer/user_repository.dart';
import 'package:taskmate/authentication/splash_screen.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:taskmate/localization/locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      //systemNavigationBarColor: Colors.blue, // navigation bar color
      statusBarColor: kDeepBlueColor, //
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code') ?? 'en';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserRepository1());
  Get.put(UserRepository());

  runApp(
     Taskmate(initLanguageCode: languageCode),
  );
}

class Taskmate extends StatefulWidget {
  final String initLanguageCode;


  // UserModel1 client;
  const Taskmate({required this.initLanguageCode,super.key});

  @override
  State<Taskmate> createState() => _TaskmateState();
}

class _TaskmateState extends State<Taskmate> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  void configureLocalization() {
    localization.init(mapLocales: LOCALS, initLanguageCode: widget.initLanguageCode);
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    configureLocalization();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: const SafeArea(
        child: SplashScreen(),
      ),
    );
  }
}
