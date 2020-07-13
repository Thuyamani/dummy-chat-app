import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          Image.asset('assets/images/about.jpg', width: 50, height: 50,),
          
          Text('Title', style: TextStyle(fontSize:25),)
        ],),
      ),
      body: Column(
        children: <Widget>[
          Text('It is for testing purpose only', style: TextStyle(fontSize:25),),
        ],
      ),
    );
  }
}