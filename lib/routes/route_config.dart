import 'package:flutter/material.dart';
import 'package:geeky_launcher/res/strings.dart';
import 'package:geeky_launcher/screens/splash/splash.dart';

final Map<String, Widget Function(BuildContext)> routeConfig = {
  homeRoute : (BuildContext context)=>SplashScreen()
};