import 'package:flutter/material.dart';

import '../auth.dart';
import './splashscreen.dart';
import '../screen/home.dart';
import '../screen/login.dart';





class LoginScreen extends StatelessWidget {

final Authantication auth = Authantication();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: auth.getUser(),
        builder: (context, snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none: 
          case ConnectionState.waiting:  
              return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
           if(snapshot.data!= null){
             return 
             Home(user: snapshot.data,);
           }
           else{
             return LogIn();
           }
            
            break;
          default: 
          return Splashscreens();
        }
      });
  }
}