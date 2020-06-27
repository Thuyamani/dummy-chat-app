import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summoning/widgets/contacts.dart';
import 'package:summoning/widgets/menu.dart';
import 'package:summoning/widgets/theme.dart';
import 'package:provider/provider.dart';



import '../auth.dart';

class Home extends StatefulWidget {

final FirebaseUser user;

   Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
final Authantication auth = Authantication();

Future<bool> _backPressed(){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Do you really want to Exit the App!'),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.pop(context, false);
            },
                child: Text('No'),
            ),
            FlatButton(onPressed: (){
              exit(0);
            },
              child: Text('Yes'),
            ),
          ],
        );
      }
  );
}



  @override
  Widget build(BuildContext context) {
  //  ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return  SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Summoning'),
              ),
            drawer: Menu(user: widget.user),
          body: WillPopScope(
            onWillPop: _backPressed,
            child: SingleChildScrollView(
                        child: Column(
                children: <Widget>[
                  //Text('Welcome'),
                 // Text(widget.user.email),
                  Text(widget.user.displayName),
                  SizedBox(child: Container(color : Colors.blue),height: 200,),
                  SizedBox(child: Container(color : Colors.green),height: 200,),
                  SizedBox(child: Container(color : Colors.limeAccent),height: 200,),
                  SizedBox(child: Container(color : Colors.pink),height: 200,),
               
                ],
              ),
            ),
          ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Contacts()));
             //  _themeChanger.setTheme(Brightness.dark);
              },
              child: Icon(Icons.contacts,color: Colors.white,),
              ),
        ),
     
    );
  }
}



  // ChatScreen(),
                // Container(height:100, child: Messages()),
                  //  NewMessage()
                 // Image.network(widget.user.photoUrl),

                  // RaisedButton(onPressed: (){
                  //   auth.signOut();
                  //  // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  //  Navigator.pop(context);
                  // },
                  // child: Text('Logout'),
                  // )