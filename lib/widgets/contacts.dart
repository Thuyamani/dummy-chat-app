import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summoning/screen/chat.dart';

class Contacts extends StatefulWidget {

final FirebaseUser user;

   Contacts({Key key, this.user}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts', style: TextStyle(fontSize:25),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), 
          onPressed: (){
            setState(() {
              
            });
          })
        ],
      ),
      body: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Text('Loading');
                  }
                  print(snapshot.data);
                  
                  if (snapshot.data.documents.length == 0) {
                    
                    return Center(
                      child: Text('Nothing to show')
                     //  CircularProgressIndicator( ),
                    );
                  } else {
                    final contactDocs = snapshot.data.documents;
                    return  ListView.builder(
                      
                          itemCount: contactDocs.length,
                           itemBuilder: (ctx, index){
                             return 
                             ContactList(
                               url: contactDocs[index]['photoUrl'], 
                               name: contactDocs[index]['displayName'],
                               email: contactDocs[index]['email'], 
                               uid: contactDocs[index]['uid'],
                               currentUser: widget.user.uid,
                               token: contactDocs[index]['token'],
                               status: contactDocs[index]['status'],
                               );
                           }
                           
                           );
                      }
                         
                      
                },
              ),
           

     
    );
  }
}


class ContactList extends StatefulWidget {

final String url;
final String name;
final String email;
final String uid;
final String currentUser;
final String token;
final String status;

ContactList({this.email, this.name, this.url, this.uid, this.currentUser, this.token, this.status});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    if(widget.uid == widget.currentUser){
      return Container();
    }else{
      return  Card(
        elevation: 5,
        
        margin: EdgeInsets.all(5),
        child: ListTile(
          leading: ClipRRect(
            
            borderRadius: BorderRadius.circular(25),
            child: Image.network(widget.url,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            errorBuilder: (a,b,c){
            return null;
          },)),
          title: Text(widget.name, style: TextStyle(fontSize:20),),
          subtitle: Text(widget.email, style: TextStyle(fontSize:16),),
          trailing: widget.status == 'Online'? CircleAvatar(backgroundColor: Colors.green,radius: 5,): CircleAvatar(backgroundColor: Colors.red,radius: 5,),
          onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(
          peerAvatar: widget.url, peerName: widget.name,peerId: widget.uid,peerEmail: widget.email,peerToken: widget.token, peerStatus : widget.status
          )));
      }, 
        ),
      );
      
    
    }


    
  }
}