import 'package:flutter/material.dart';
import 'package:geeky_launcher/models/app.dart';
import 'package:geeky_launcher/native/launcher.dart';

class AppWidget extends StatefulWidget {
  final AndroidApp androidApp;
  final bool showingContextMenu;
  const AppWidget({
      this.androidApp,
      Key key,
      this.showingContextMenu,
  }):super(key:key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget>{
  @override
  Widget build(BuildContext context) {
    return Stack(
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
              width: 70,
              height: 70,
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
    );
  }
}

