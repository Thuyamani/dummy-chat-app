import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:summoning/screen/chat.dart';
import 'package:summoning/widgets/contacts.dart';
import 'package:summoning/widgets/menu.dart';
import '../firebase_message.dart';





import '../auth.dart';

class Home extends StatefulWidget {

final FirebaseUser user;

   Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
 // String token = '';

@override
void initState() {
    
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    
    fbm.configure(onMessage: (msg){
    //  print(msg);
      return;
    },onLaunch: (msg){
    //  print(msg);
      return;
    },
    onResume: (msg){
    //  print(msg);
      return;
    },
    );
    fbm.getToken().then((value) {
     // token= value;
      print(value);
      readLocal(value);
    } );

        WidgetsBinding.instance.addObserver(this);
       // didChangeAppLifecycleState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state");
    if (state == AppLifecycleState.resumed){

Firestore.instance.collection('users').document(widget.user.uid).setData({'status': 'Online'}, merge:true);

    }
      
    else{
 
Firestore.instance.collection('users').document(widget.user.uid).setData({'status': 'Offline'}, merge: true);
    }
    
  }

   readLocal(String tokenId) async {
 
    Firestore.instance.collection('users').document(widget.user.uid).updateData({'token': tokenId});

    

    setState(() {});
  }

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

// Future <List<DocumentSnapshot>> getChats() async{
//   var ff = Firestore.instance.collection('messages');
// return await Firestore.instance.collection('messages').document().snapshots().toList();
// //.where((event) => event.documentID.contains(widget.user.uid)).toList();
// }



  @override
  Widget build(BuildContext context) {
    //print(widget.user.uid);
  //  ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return  SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Summoning', style: TextStyle(fontSize:25),),
                
              ),
            drawer: 
            //Navbar(user: widget.user),
            Menu(user: widget.user),
          body: WillPopScope(
            onWillPop: _backPressed,
            child: buildMainScreenContact(),
            //Text('data')
            // FutureBuilder(
            //   future: getChats(),
            //   builder: (ctx, AsyncSnapshot<List<DocumentSnapshot>> snapshot){
            //   return Container(child:Text("${snapshot.data}"));
            // }),
          ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Contacts(user: widget.user,)));
             //  _themeChanger.setTheme(Brightness.dark);
              },
              child: Icon(Icons.contacts,color: Colors.white,),
              ),
        ),
     
    );
  }

  Widget buildMainScreenContact(){
    return StreamBuilder(
                stream: Firestore.instance.collection('messagesMainScreen').document(widget.user.uid).collection(widget.user.uid).orderBy('timeStamp').snapshots(),
       
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){ 
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.data.documents.length == 0){
                      return SingleChildScrollView(
                                              child: Column(
                          children: <Widget>[
                            SizedBox(height: 50,),
                            Center(child: Text('No Chat History to show', style: TextStyle(fontSize:25),)),
                            SizedBox(height: 50,),
                            Image.asset('assets/images/noChat.gif',)

                          ],
                        ),
                      );
                  }
                //  print(snapshot.hasData);
              //    print(snapshot.data);
                 else {
                    final contactDocs = snapshot.data.documents;
                    return  ListView.builder(
                      
                          itemCount: contactDocs.length,
                           itemBuilder: (ctx, index){
                             return buildMainScreenList(
                               cUid: contactDocs[index]['peerId'],
                               cName:  contactDocs[index]['peerName'],
                               cEmail: contactDocs[index]['peerEmail'], 
                               cUrl: contactDocs[index]['peerAvatar'], 
                               cToken: contactDocs[index]['peerToken'],
                               cStatus: contactDocs[index]['peerStatus'],
                               );
                            //  ContactList(
                            //    url: contactDocs[index]['photoUrl'], 
                            //    name: contactDocs[index]['displayName'],
                            //    email: contactDocs[index]['email'], 
                            //    uid: contactDocs[index]['uid'],
                            //    currentUser: widget.user.uid,
                            //    );
                           }
                           
                           );
                      }
                         
                      
                },
              );
  }

  Widget buildMainScreenList({String cName, String cUrl, String cUid, String cEmail, String cToken, String cStatus}){

final String name =cName;
final String url = cUrl;
final String uid = cUid;
final String email = cEmail;
final String token = cToken;
final String status = cStatus;

    return Card(
        elevation: 9,
        
        margin: EdgeInsets.all(5),
        child: ListTile(
          
          leading: ClipRRect(
            
            borderRadius: BorderRadius.circular(35),
            child: Image.network(url,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            errorBuilder: (a,b,c){
            return Container();
          },)),
          title: Text(name, style: TextStyle(fontSize:20),),
          subtitle: Text(email, style: TextStyle(fontSize:18),),
        //  trailing: status == 'Online'? CircleAvatar(backgroundColor: Colors.green,radius: 5,): CircleAvatar(backgroundColor: Colors.red,radius: 5,),
          onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(peerStatus: status, peerAvatar: url, peerName: name,peerId: uid, peerEmail: email, peerToken: token,)));
      },
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