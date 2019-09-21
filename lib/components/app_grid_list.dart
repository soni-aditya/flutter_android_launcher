import 'package:flutter/material.dart';
import 'package:geeky_launcher/models/app.dart';
import 'package:geeky_launcher/native/launcher.dart';
import 'package:geeky_launcher/screens/splash/splash.dart';

import 'app_widget.dart';
import 'explode_widget.dart';

class AppGridList extends StatefulWidget{
  final List<AndroidApp> apps;
  final Function onRemove;
  const AppGridList({Key key, this.apps,this.onRemove}) : super(key:key);
  @override
  _AppGridListState createState() => _AppGridListState();
}

class _AppGridListState extends State<AppGridList> with ClearMixin {
  @override
  Widget build(BuildContext context) {
    print("length ${widget.apps.where((i)=>i.deleted).length}");
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      controller: controller,
      itemCount: widget.apps.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ), itemBuilder: (c,i)=>Material(
      key: UniqueKey(),
      color: Colors.transparent,
      shape: CircleBorder(),
      child: InkWell(
        radius: 20,
        splashColor: Colors.white,
        highlightColor: Colors.white,
        customBorder: CircleBorder(side: BorderSide(
          color: Colors.white,
        )),
        onTap: (){
          setState(() {
            showingContext = -1;
          });
          GeekyLauncher.launchApplication(widget.apps[i].packageName);
        },
        onLongPress: (){
          setState(() {
            showingContext=i;
          });
        },
        child: Card(
          color: Colors.transparent,
          key: UniqueKey(),
          child: widget.apps[i].deleted?Explode(
            duration: Duration(milliseconds: 800),
            size: Size(100,100),
            colors: Colors.accents,
            particleCount: 200,
            onFinish: (){
                widget.onRemove(widget.apps[i]);
            },
            key: explodeKey,
            widget: AppWidget(
              key: UniqueKey(),
              androidApp: widget.apps[i],
              showingContextMenu: showingContext==i,
            ),
          ):AppWidget(
            key: UniqueKey(),
            androidApp: widget.apps[i],
            showingContextMenu: showingContext==i,
          ),
        ),
      ),
    ),
    );
  }
}
mixin ClearMixin<T extends StatefulWidget> on State<T>{
  final ScrollController controller = ScrollController();
  int showingContext= -1;
  void clear(){
    setState(() {
      showingContext = -1;
    });
  }
  @override
  void initState() {
    controller.addListener((){
      if(showingContext!=-1){
        setState(() {
          showingContext =-1;
        });
      }
    });
    super.initState();
  }
}