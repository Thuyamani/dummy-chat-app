import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summoning/widgets/theme.dart';

class ThemeModes extends StatefulWidget {
  @override
  _ThemeModesState createState() => _ThemeModesState();
}

class _ThemeModesState extends State<ThemeModes> {

  Size displaySize(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Theme Mode', style: TextStyle(fontSize:25),),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              _themeChanger.setTheme(Brightness.dark);
            },
              child: Container(
                  
                  width: double.infinity,
                    child: Column(children: <Widget>[
                      Container(height: 50, color: Colors.black),
                      Container(height: 150, color: Colors.grey[800],
                        child: Center(child: Text('Dark Mode', style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),),)
                    ],),
            ),
          ),
          GestureDetector(
            onTap: (){
              _themeChanger.setTheme(Brightness.light);
            },
              child: Container(
                  
                  width: double.infinity,
                    child: Column(children: <Widget>[
                      Container(height: 50, color: Colors.blue),
                      Container(height: 150, color: Colors.white,
                        child: Center(child: Text('Light Mode', style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),),)
                    ],),
            ),
          ),
        ],
      )
    );
  }
}