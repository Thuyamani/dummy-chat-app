
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:summoning/screen/about.dart';
import 'package:summoning/screen/privacy.dart';
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.displayName), 
              accountEmail: Text(widget.user.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.photoUrl),
              ),
              //onDetailsPressed: (){},
              otherAccountsPictures: <Widget>[
                FlatButton(onPressed: (){}, child: Icon(Icons.edit))
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
                title: Text('Theme Mode'),
                onTap: (){
                  Navigator.of(context).pop();
                  
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