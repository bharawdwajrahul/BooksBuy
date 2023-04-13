import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:software/homePage.dart';
import 'package:software/router/router.gr.dart';
import 'package:software/signUp/login.dart';
import 'package:software/signUp/welcomePage.dart';

import 'getData.dart';
import 'injection.dart';

void main() async {
  configureInjection(Environment.dev);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());

  // await _configureFirebaseAuth();
  // await _configureFirebaseStorage();
  // _configureFirebaseFirestore();
 // await FirebaseAppCheck.instance.activate();

  getIt.registerSingleton<Routera>(Routera());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  late Widget newWidget;

  @override
  Widget build(BuildContext context) {
    if (firebaseUser != null) {
      newWidget = HomePage();
      print('logged in--');
    } else {
      newWidget = WelcomePage();
      print('not logged in');
    }
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:newWidget,
        );
      },
    );
  }
}


