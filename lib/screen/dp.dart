import 'package:flutter/material.dart';

class DP extends StatelessWidget {

  
  final String peerAvatar;
  final String peerName;
  
 

  DP({Key key,  @required this.peerAvatar, @required this.peerName,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(peerName, style: TextStyle(fontSize:25),),
      ),
      body: Center(
        child: ClipRRect(
            
            borderRadius: BorderRadius.circular(1),
            child: Image.network(peerAvatar,
            fit: BoxFit.cover,
           // width: 50,
           // height: 50,
            errorBuilder: (a,b,c){
            return Container();
          },))
      )
    );
  }
}