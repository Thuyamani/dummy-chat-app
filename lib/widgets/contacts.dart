import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
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
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        
                      ),
                    );
                  } else {
                    final contactDocs = snapshot.data.documents;
                    return  ListView.builder(
                      
                          itemCount: contactDocs.length,
                           itemBuilder: (ctx, index){
                             return 
                             ContactList(url: contactDocs[index]['photoUrl'], name: contactDocs[index]['displayName'],email: contactDocs[index]['email'],);
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

ContactList({this.email, this.name, this.url});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Container(
     // height: 300,
     // width: double.infinity,
      child: Row(
         children: <Widget>[
          Text(widget.name),
         ],
      ),
    );
  }
}