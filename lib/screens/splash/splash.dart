import 'package:flutter/material.dart';
import 'package:geeky_launcher/components/app_grid_list.dart';
import 'package:geeky_launcher/components/explode_widget.dart';
import 'package:geeky_launcher/models/app.dart';
import 'package:geeky_launcher/native/launcher.dart';
final GlobalKey<_SplashScreenState> mainKey = GlobalKey<_SplashScreenState>();
class SplashScreen extends StatefulWidget{
  SplashScreen():super(key:mainKey);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
var explodeKey = Explode.getKey();
class _SplashScreenState extends State<SplashScreen> {
  List<AndroidApp> apps;
  LauncherState launcherState = LauncherState.VerticalListIcon;
  final key = GlobalKey<ClearMixin>();
  @override
  void initState() {
    getApps();
    super.initState();
  }
  getApps()async{
    print("getting apps");
    await Future.delayed(Duration(seconds: 2));
    apps = await GeekyLauncher.getApplications();
    apps.sort((a,b){
      return a.name.compareTo(b.name);
    });
    setState(() {});
  }
  update(List<AndroidApp> appList){
    setState(() {
      apps = appList;
      explodeKey = Explode.getKey();
    });
    key.currentState.clear();
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(explodeKey.currentState?.mounted??false){
        explodeKey.currentState.explode();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: apps==null?Center(
        child: SizedBox(
          width: 100,
            height: 100,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.orange),
            )
        ),
      ):
          AppGridList(
            apps: apps,
            key: key,
            onRemove: (AndroidApp app){
              setState(() {
                apps.removeWhere((t)=>t.packageName==app.packageName);
              });
            },
          ),
    );
  }

  void clear() {
    key.currentState.clear();
  }
}
enum LauncherState{
  VerticalListIcon,
  VerticalListName,
  HorizontalPanes
}