  // ignore: file_names
import 'package:flutter/material.dart';
import 'package:reachgoal/theme/Dark_Mode.dart';
import 'package:reachgoal/theme/Light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get  themeData => _themeData;
bool get isDarkMode => themeData == darkMode;
set themeData (ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
}
void themeToggle(){
if(_themeData == lightMode){
  themeData = darkMode;
}
else{
  themeData = lightMode;
}
}
}