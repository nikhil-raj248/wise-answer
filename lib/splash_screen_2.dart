import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'Home_Page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Color> colorizeColors = [
    Colors.grey,
    Colors.black,
    Colors.grey,
    Colors.black,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w800
  );
  static const colorizeTextStyle2 = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w400
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Home()),);
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: size.width*0.8,
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Lottie.asset("assets/animations/bothi.json"),
                ),
                SizedBox(height: 20,),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'I\'m your helper',
                      textStyle: colorizeTextStyle2,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
                SizedBox(height: 8,),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Tap Me',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
