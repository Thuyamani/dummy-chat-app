import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:summoning/screen/loginscreen.dart';

class Splashscreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new LoginScreen(),
      imageBackground: AssetImage('assets/images/splash.jpg'),
      
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
     
      loaderColor: Colors.white,
    );
  }
}