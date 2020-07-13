import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summoning/screen/splashscreen.dart';
import 'package:summoning/widgets/theme.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(brightness: Brightness.dark),

          child: MaterialAppTheme(),
    );
  }
}


class MaterialAppTheme extends StatefulWidget {
  @override
  _MaterialAppThemeState createState() => _MaterialAppThemeState();
}

class _MaterialAppThemeState extends State<MaterialAppTheme>  {




  @override
  Widget build(BuildContext context) {




final brightness = Provider.of<ThemeChanger>(context);

    return MaterialApp(
        title: 'Summoning Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
         brightness: brightness.getTheme(),
          primarySwatch: Colors.blue,
          accentColor: Colors.blue[900],
        
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splashscreens(),
      );
  }
}