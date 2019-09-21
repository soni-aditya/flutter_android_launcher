import 'package:flutter/material.dart';
import 'package:geeky_launcher/models/app.dart';
import 'package:geeky_launcher/native/launcher.dart';

class AppWidget extends StatefulWidget {
  final AndroidApp androidApp;
  final bool showingContextMenu;
  final Function onDeleteFinally;
  const AppWidget({
      this.androidApp,
      this.showingContextMenu,
      this.onDeleteFinally
  });

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation<double> _animation;
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(seconds: 1),);
    _animation = new Tween(begin: 0.0,end: 1.0).animate(animationController);
    _animation.addListener((){setState((){});});
    animationController.addStatusListener((s){
      if(s==AnimationStatus.completed)
        widget.onDeleteFinally(widget.androidApp);
    });
    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.androidApp.deleted && !animationController.isAnimating)
      animationController.forward();
    return Opacity(
      opacity: 1-_animation.value,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GridTile(
            footer: Text(
              widget.androidApp.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            child: Center(
              child: Container(
                width: 70*(1-_animation.value),
                height: 70*(1-_animation.value),
                padding: EdgeInsets.all(5),
                child: widget.androidApp.icon,
              ),
            ),
          ),
          widget.showingContextMenu
              ? Positioned(
                  left: 4,
                  top: 4,
                  child: InkWell(
                    onTap: () {
                      GeekyLauncher.appInfo(widget.androidApp.packageName);
                    },
                    customBorder: CircleBorder(),
                    child: ClipOval(
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.info,
                              size: 20,
                              color: Colors.green,
                            ))),
                  ),
                )
              : SizedBox(),
          widget.showingContextMenu
              ? Positioned(
                  right: 4,
                  top: 4,
                  child: InkWell(
                    onTap: () {
                      GeekyLauncher.uninstallApp(widget.androidApp.packageName);
                    },
                    customBorder: CircleBorder(),
                    child: ClipOval(
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.red,
                            ))),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

