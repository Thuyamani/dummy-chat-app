import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileUpdate extends StatefulWidget {



  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {

  final ImagePicker _picker = ImagePicker();

File newProfilePic;


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

    // Force refresh input
    setState(() {});
  }


Future getImage(ImageSource source) async{
  final tempImage = await _picker.getImage(source: source);
if(tempImage!=null){
 setState(() {
    newProfilePic = File(tempImage.path);
  });
}

 
}

bool isLoading = false;

_cameraPressed(){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Select photo from any option below'),
          actions: <Widget>[
           
            GestureDetector(
              onTap: (){
                getImage(ImageSource.camera);
                Navigator.pop(context);
              },
                          child: Row(
                children: <Widget>[
                  Icon(Icons.camera_alt),
                  Text('Camera')
                ],
              ),
            ),
            SizedBox(width:10),
            Text('|'),
            SizedBox(width:10),
            GestureDetector(
              onTap: (){
                getImage(ImageSource.gallery);
                Navigator.pop(context);
              },
                          child: Row(
                children: <Widget>[
                  Icon(Icons.photo_library),
                  Text('Gallery')
                ],
              ),
            ),
          ],
        );
      }
  );
}

Future _uploadData() async{
setState(() {
  isLoading = true;
});

  String newphotoUrl = '';

String fileName = uid;
StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(newProfilePic);

   await uploadTask.onComplete;
 
 
 var rr = await  reference.getDownloadURL();
     // print(value); 

      setState(() {
        newphotoUrl = rr;
      });
    
       Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({'uid':uid,'displayName': displayName, 'email': email, 'photoUrl': newphotoUrl, 'lastSeen': Timestamp.now()});
               await prefs.setString('photoUrl', newphotoUrl);
    setState(() {
      isLoading = false;
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Profile", style: TextStyle(fontSize:25),),),
      body: SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                
                children: <Widget>[
                 CircleAvatar(
                   backgroundImage: newProfilePic == null ? NetworkImage(photoUrl): FileImage(newProfilePic),
                   //Material(child: Image.file(newProfilePic)),
                   radius: 70,
                   child: IconButton(
                     icon: Icon(Icons.camera_alt, color: Colors.white,), 
                     onPressed: (){
                       //Fluttertoast.showToast(msg: "Update success");
                       _cameraPressed();
                     },
                     splashColor: Colors.blue,
                     padding: EdgeInsets.all(55.0),
                     iconSize: 50.0,
                     highlightColor: Colors.grey,
                     ),
                     ),
           
                
              ], ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(bottom:15),
                width: double.infinity,
                child: Text('Display Name :', style: TextStyle(fontSize:20),)
                ),
              Container(
                width: double.infinity,
                child: Text(displayName, style: TextStyle(fontSize:20),)
                ),
              SizedBox(child: Divider(thickness: 3,),width: double.infinity),
              
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(bottom:15),
                width: double.infinity,
                child: Text('Your Email ID :', style: TextStyle(fontSize:20),)
                ),
              Container(
                width: double.infinity,
                child: Text(email, style: TextStyle(fontSize:20),)
                ),
              SizedBox(child: Divider(thickness: 3,),width: double.infinity),
              SizedBox(height: 30,),
              !isLoading ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: RaisedButton(
                      onPressed: _uploadData,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Update', style: TextStyle(fontSize:22),),
                      ),
                      ),
                  ),
                  SizedBox(width: 20,),
                   Center(
                child: RaisedButton(
                  onPressed: (){
                    setState(() {
                      newProfilePic = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Cancel', style: TextStyle(fontSize:22),),
                  ),
                  ),
              )
                ],
              ): Center(child: CircularProgressIndicator())
              
            ],
          ),
        ),
      ),
    );
  }
}