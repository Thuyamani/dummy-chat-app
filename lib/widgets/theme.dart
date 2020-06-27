import 'package:flutter/material.dart';


class ThemeChanger with ChangeNotifier{
  
  Brightness _brightness;

  ThemeChanger({ brightness}){
     
      _brightness= brightness;
  }

  getTheme()=> _brightness;

  setTheme(Brightness brightness){
    _brightness = brightness;
    notifyListeners();
  }
}