package com.geekyants.vikram.geeky_launcher;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

import java.util.HashMap;

public class AppStatesListener extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction() != null) {
            if (intent.getAction().equalsIgnoreCase(Intent.ACTION_PACKAGE_ADDED)) {
                if (intent.getData() != null) {
                    onPackageAdded(intent.getData().getSchemeSpecificPart());
                }
            } else if (intent.getAction().equalsIgnoreCase(Intent.ACTION_PACKAGE_FULLY_REMOVED)) {
                if (intent.getData() != null)
                    onPackageRemoved(intent.getData().getSchemeSpecificPart());
            }
        }
    }

    private void onPackageAdded(String toString) {
        try {
            if (LauncherChannel._channel != null) {
                PackageManager packageManager = LauncherChannel.context.getPackageManager();
                HashMap<String, Object> map = new HashMap<>();
                map.put("name", packageManager.getApplicationLabel(packageManager.getApplicationInfo(toString, 0)));
                map.put("package", toString);
                map.put("icon", LauncherChannel.getBitmapFromDrawable(packageManager.getApplicationIcon(toString)));
                LauncherChannel._channel.invokeMethod("appAdded", map);
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void onPackageRemoved(String toString) {
        if (LauncherChannel._channel != null) {
            LauncherChannel._channel.invokeMethod("appRemoved", toString);
        }
    }
}
