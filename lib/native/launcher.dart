import 'package:flutter/services.dart';
import 'package:geeky_launcher/models/app.dart';
import 'package:geeky_launcher/screens/splash/splash.dart';

class GeekyLauncher {
  static const MethodChannel _channel =
  MethodChannel("com.geekyLauncher/method_channel");

  static init() {}

  static getApplications() async {
    _channel.setMethodCallHandler((m) {
      if (m.method.trim() == "appRemoved") {
        List<AndroidApp> apps  = mainKey.currentState.apps.map((a) {
          if (a.packageName == m.arguments.toString()) a.deleted = true;
          return a;
        }).toList();
        mainKey.currentState.update(apps);
      }
       else if (m.method.trim() == "clear") {
        mainKey.currentState.clear();
      } else if (m.method.trim() == "appAdded") {
        List<AndroidApp> apps = mainKey.currentState.apps;
        apps.add(AndroidApp.fromJson(m.arguments));
        apps.sort((a, b) {
          return a.name.compareTo(b.name);
        });
        mainKey.currentState.update(apps);
      }
      return null;
    });
    List apps = await _channel.invokeListMethod("getApps");
    print(apps.length);
    return apps.map((app) => AndroidApp.fromJson(app)).toList();
  }

  static launchApplication(String package) {
    _channel.invokeMethod("launchApp", package);
  }

  static void appInfo(String packageName) {
    _channel.invokeMethod("appInfo", packageName);
  }

  static void uninstallApp(String packageName) {
    _channel.invokeMethod("uninstallApp", packageName);
  }
}
