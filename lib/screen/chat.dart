

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'dart:html';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summoning/firebase_message.dart';
import 'package:summoning/screen/dp.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Chat extends StatelessWidget {

  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String peerEmail;
  final String peerToken;
  final String peerStatus;

  Chat({Key key, @required this.peerId, @required this.peerAvatar, @required this.peerName, @required this.peerEmail, @required this.peerToken, @required this.peerStatus}) : super(key: key);
 
 Widget buildOnline(){
   return StreamBuilder(
     stream: Firestore.instance.collection('users').where('uid', isEqualTo: peerId).snapshots(),
     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
       if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
       }
       final onlineDocs = snapshot.data.documents;
       return ListView.builder(
         itemCount: onlineDocs.length,
         itemBuilder: (ctx, index){
           return buildOnlineList(onlineDocs[index]['status']);
         }
         );
     },
     );
 }

 Widget buildOnlineList(String status){
   return status == 'Online'? CircleAvatar(backgroundColor: Colors.green,radius: 5,): CircleAvatar(backgroundColor: Colors.red,radius: 5,);
 }
 
 
  @override
  Widget build(BuildContext context) {
    print(peerStatus);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
                  child: Row(children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(peerAvatar),radius: 25,),
            SizedBox(width:12),
            Text(peerName, style: TextStyle(fontSize:25),),
            SizedBox(width: 10,),
            Container( 
              width: 12,
              height: 12,
              child: buildOnline())
            ],),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> DP(peerName: peerName, peerAvatar: peerAvatar,)));
            },
        ),
        //Text(peerName),
      ),
      body: ChatScreen( peerId: peerId, peerAvatar: peerAvatar, peerName: peerName, peerEmail: peerEmail, peerToken: peerToken, peerStatus: peerStatus,),
    );
  }
}


class ChatScreen extends StatefulWidget {

  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String peerEmail;
  final String peerToken;
  final String peerStatus;

  ChatScreen({Key key,@required this.peerStatus, @required this.peerId, @required this.peerAvatar, @required this.peerName, @required this.peerEmail, @required this.peerToken}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar, peerName: peerName, peerToken: peerToken);
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{

  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String peerToken;

  _ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar, @required this.peerName, @required this.peerToken});


final  _controller = TextEditingController();
 var _enteredMessage = '';
   String groupChatId;
  SharedPreferences prefs;
  String id;

   @override
  void initState() {
    super.initState();
    
    groupChatId = '';
    readLocal();

    WidgetsBinding.instance.addObserver(this);
  }


  readLocal() async {
    final user = await FirebaseAuth.instance.currentUser();
    prefs = await SharedPreferences.getInstance();
    id = user.uid;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    Firestore.instance.collection('users').document(id).updateData({'chattingWith': peerId});

    setState(() {});
  }

    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    
    if (state == AppLifecycleState.resumed){

Firestore.instance.collection('users').document(id).collection(id).document(peerId).setData({'status': 'Online'}, merge:true);

    }
      
    else{
 
Firestore.instance.collection('users').document(id).collection(id).document(peerId).setData({'status': 'Offline'}, merge:true);
    }
    
  }

 void _sendMessage()async{
  FocusScope.of(context).unfocus();

  _enteredMessage = _controller.text;

  if(_enteredMessage.trim().isEmpty){
 Fluttertoast.showToast(msg: "Nothing to Send");
  }else{

 final user = await FirebaseAuth.instance.currentUser();

 var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': _enteredMessage,
            
          },
        );
      });

       var docReference = Firestore.instance
          .collection('messagesMainScreen')
          .document(id)
          .collection(id)
          .document(peerId);

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          docReference,
          {
         
            'peerId': peerId,
            'peerName': peerName,
            'peerAvatar': peerAvatar,
            'peerEmail': widget.peerEmail,
            'timeStamp': DateTime.now(),
            'peerToken': peerToken,
            'peerStatus': 'Online',
          },
        );
      });

 sendAndRetrieveMessage(title: user.displayName, body: _enteredMessage, tokenId: peerToken);
   
  _controller.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

     Expanded(child: buildListMessage()),

     buildInput(),

    ],);
  }

Widget buildInput(){
  return Container(
      margin: EdgeInsets.only(top:8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              // onChanged: (value){
              //   setState(() {
              //     _enteredMessage = value;
              //   });
              // },
              // onSubmitted: (value){
              //   setState(() {
              //      _enteredMessage = value;
              //   });
              // },
              )
          ),
          IconButton(icon: Icon(Icons.send), 
          onPressed: _sendMessage
          //_enteredMessage.trim().isEmpty ? null : _sendMessage
          )
        ],
      ),
    );
}

 Widget buildListMessage(){
   return FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
                      builder:(ctx, futureSnapshot){
                        if(futureSnapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }
                        return StreamBuilder(
        stream: Firestore.instance.collection('messages').document(groupChatId)
                  .collection(groupChatId)
                 .orderBy('timestamp', descending: true)
                  .snapshots(),
        builder: (ctx, chatSnapshot){
          if(chatSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          final chatDocs = chatSnapshot.data.documents;

          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index){
                return 
                buildList(messages: chatDocs[index]['text'],isme: chatDocs[index]['idFrom'] == id,);
                // MessageBubble(
                //   chatDocs[index]['text'],
                //   chatDocs[index]['userId'] == futureSnapshot.data.uid,
                //   key: ValueKey(chatDocs[index].documentID),
                //   );
                //Text(chatDocs[index]['text']);
              }
              );}
          );
        }
        );
 }

 Widget buildList({String messages, bool isme}){

   final String message = messages;
final bool isMe = isme;

   return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration : BoxDecoration(
            color:isMe? Colors.blue[900]: Colors.pink[900],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
               topRight: Radius.circular(12),
               bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
               bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          constraints: BoxConstraints(maxWidth: 200,minWidth: 1),
         // constraints: BoxConstraints(maxHeight: 170,minHeight: 10,maxWidth: 170,minWidth: 10),
          //width: 250,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(message, style: TextStyle(color:Colors.white),),
        ),
      ],
    );
 }

}