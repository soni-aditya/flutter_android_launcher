import 'package:flutter/material.dart';
import 'package:geeky_launcher/res/strings.dart';
import 'package:geeky_launcher/routes/route_config.dart';
void main()=>routes();
routes(){
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routeConfig,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
    );
  }
}