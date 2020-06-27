import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../auth.dart';
import './home.dart';


class LogIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return _LogInState();
  }
}

class _LogInState extends State<LogIn> {
Authantication auth = Authantication();



  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
        body: Column(
          children: <Widget>[
            Image.asset('assets/images/icon.png'),
            Center(
                child:  
                     Container(
                       width: 200,
                       height: 50,
                       child: Center(
                          child: SignInButton(
                            
                            Buttons.Google,
                            text: "Sign up with Google",

                            onPressed: () async{
                             var user = await auth.signInGoogle();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(user: user)));
                            },
                            
                          ),
                        ),
                     )),
          ],
        ),
      
    );
  }
}


// OutlineButton(
//                       child: Text("Login with Google"),
//                       onPressed: () async{
//                       var user = await auth.signInGoogle();
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(user: user)));
//                       },
//                     )