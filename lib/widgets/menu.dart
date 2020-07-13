

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summoning/screen/about.dart';
import 'package:summoning/screen/privacy.dart';
import 'package:summoning/screen/profile.dart';
import 'package:summoning/screen/testing.dart';
import 'package:summoning/widgets/thememode.dart';
import '../auth.dart';
import '../screen/loginscreen.dart';

class Menu extends StatefulWidget {

final FirebaseUser user;

  Menu({Key key, this.user}) : super(key: key);


  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

final Authantication auth = Authantication();


String uid ='';
String displayName='';
String email='';
String photoUrl='';
SharedPreferences prefs;

@override
  void initState() {
    super.initState();
    readLocal();
  }


void readLocal() async {
     prefs = await SharedPreferences.getInstance();
     uid = prefs.getString('uid') ?? '';
     displayName = prefs.getString('displayName') ?? '';
    email = prefs.getString('email') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
print(photoUrl);
    // Force refresh input
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
          
            UserAccountsDrawerHeader(
              accountName: Text(displayName), 
              accountEmail: Text(email),
              currentAccountPicture: ClipRRect(
            
            borderRadius: BorderRadius.circular(35),
            child: Image.network(photoUrl,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            errorBuilder: (a,b,c){
            return Container();
          },)),
              //onDetailsPressed: (){},
              otherAccountsPictures: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> 
                  ProfileUpdate()
                  ));
                  
                }, child: Icon(Icons.edit))
              ],
              ),
              ListTile(
                title: Text('Home'),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                title: Text('About Summoning'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> About()));
                },
              ),
              Divider(),
               ListTile(
                title: Text('Privacy Policy'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Privacy()));
                },
              ), 
                Divider(),
               ListTile(
                title: Text('Testing'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Testing()));
                },
              ), 
              Divider(),
                ListTile(
                title: Text('Theme Mode'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeModes()));
                },
              ),
              
              Divider(),
               ListTile(
                title: Text('Sign Out'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  auth.signOut();
                },
              ),
          ],
        ),
      );
  }
}


class UserData{




}