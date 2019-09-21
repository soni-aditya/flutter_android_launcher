import 'package:flutter/material.dart';

class AndroidApp{
  String name;
  String packageName;
  var icon;
  bool deleted = false;
  AndroidApp.fromJson(Map map){
    name = map["name"];
    packageName = map["package"];
    icon = Image.memory(map['icon'],fit: BoxFit.contain,filterQuality: FilterQuality.high,);
  }
  @override
  String toString() {
    return packageName;
  }
}