import 'dart:async';

import 'package:chat_bot/splash_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';


class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Timer(Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()),);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width*0.8,
                child: Text("WELCOME TO CHATBOT",textAlign: TextAlign.center,style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 40),),
              ),
              SizedBox(height: 10,),
              Container(
                width: size.width*0.9,
                  child: Lottie.asset("assets/animations/phone.json")
              ),
              SizedBox(height: 20,),
              Text("ANSWER YOUR QUERY",style: TextStyle(
                  color: Color.fromRGBO(179, 178, 178, 1.0),
                  fontWeight: FontWeight.w900,
                  fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }
}
