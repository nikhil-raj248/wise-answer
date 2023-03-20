import 'package:chat_bot/splash_screen_2.dart';
import 'package:chat_bot/splash_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Home_Page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ChatBot",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen1(),
    );

    // Timer(Duration(seconds: 1),(){
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingPage()),);
    // });

    //page_transition: "^2.0.9"
    ////Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: LoginPage()));
  }
}

