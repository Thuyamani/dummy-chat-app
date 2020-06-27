import 'package:flutter/material.dart';


class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

String text = '''Baki Hanma (範馬 刃牙, Hanma Baki) is the main character and protagonist of the Baki the Grappler franchise. He is the son of Yujiro Hanma and Emi Akezawa. Baki is also the half-brother of Jack Hanma. 

 He is known as the "Champion" (チャンピオン, Chanpion) of the Underground Arena in Tokyo Dome. In the fourth manga series, he is often called "the World's Strongest Boy" (地上最強のガキ, Chijō Saikyō no Gaki).''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
              Container(
                width: double.infinity,
                child: Image.asset('assets/images/about.jpg'),
                ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(text, style: TextStyle(fontSize: 20),),
              ),
          ],
        ),
      ),
    );
  }
}


