import 'package:flutter/material.dart';


class Privacy extends StatefulWidget {

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
String text ='''Vegeta (ベジータ Bejīta), more specifically Vegeta IV (ベジータ四世 Bejīta Yonsei)[5], recognized as Prince Vegeta (ベジータ王子 Bejīta Ōji) is the prince of the fallen Saiyan race and one of the major characters of the Dragon Ball series.

Regal, egotistical, and full of pride, Vegeta was once a ruthless, cold-blooded warrior and outright killer,[6] but later abandons his role in the Frieza Force, instead opting to remain and live on Earth. His character evolves from villain, to anti-hero, then to hero through the course of the series, repeatedly fighting alongside the universe's most powerful warriors in order to protect his new home and surpass Goku in power''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy"),
      ),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
              Container(
                width: double.infinity,
                child: Image.asset('assets/images/privacy.jpg'),
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


