package com.geekyants.vikram.geeky_launcher;

import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static com.geekyants.vikram.geeky_launcher.LauncherChannel._channel;
import static com.geekyants.vikram.geeky_launcher.LauncherChannel.toUninstall;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.e("register","receiver");
    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addDataScheme("package");
    intentFilter.addAction(Intent.ACTION_PACKAGE_ADDED);
    intentFilter.addAction(Intent.ACTION_PACKAGE_FULLY_REMOVED);
    getApplication().registerReceiver(new AppStatesListener(),intentFilter);
    GeneratedPluginRegistrant.registerWith(this);
    LauncherChannel.registerWith(this);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    if(requestCode==841){
      PackageManager pm = getPackageManager();
      Intent intent = pm.getLaunchIntentForPackage(toUninstall);
      if(intent==null)
      {
        _channel.invokeMethod("appUninstalled",toUninstall);
        toUninstall = null;
      }
      else _channel.invokeMethod("clear",null);
    }
  }
}
