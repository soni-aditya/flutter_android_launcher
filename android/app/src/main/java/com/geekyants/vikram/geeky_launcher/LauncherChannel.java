package com.geekyants.vikram.geeky_launcher;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.provider.Settings;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LauncherChannel implements MethodChannel.MethodCallHandler {
    private static final String SCHEME = "package";
    private final static String METHOD_CHANNEL = "com.geekyLauncher/method_channel";
    static MethodChannel _channel;
    static FlutterActivity context;
    static String toUninstall;
    static void registerWith(FlutterActivity registrar) {
        _channel = new MethodChannel(registrar.getFlutterView(), METHOD_CHANNEL);
        _channel.setMethodCallHandler(new LauncherChannel(registrar));
    }
    private LauncherChannel(FlutterActivity context){
        this.context = context;
    }
    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if(methodCall.method.equalsIgnoreCase("getApps")){
            PackageManager pm = context.getPackageManager();
            ArrayList<HashMap<String,Object>> appsList = new ArrayList<>();
            Intent i = new Intent(Intent.ACTION_MAIN, null);
            i.addCategory(Intent.CATEGORY_LAUNCHER);
            List<ResolveInfo> allApps = pm.queryIntentActivities(i, 0);
            for(ResolveInfo ri:allApps) {
                HashMap<String, Object> map =new HashMap<>();
                map.put("name",ri.loadLabel(pm).toString());
                map.put("package",ri.activityInfo.packageName);
                map.put("icon",getBitmapFromDrawable(ri.loadIcon(pm)));
                appsList.add(map);
            }
            result.success(appsList);
        }
        else if(methodCall.method.equalsIgnoreCase("launchApp")){
            PackageManager pm = context.getPackageManager();
            context.startActivity(pm.getLaunchIntentForPackage(methodCall.arguments.toString()));
            result.success("done");
        } else if(methodCall.method.equalsIgnoreCase("appInfo")){
            Intent intent = new Intent();
            intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            Uri uri = Uri.fromParts(SCHEME, methodCall.arguments.toString(), null);
            intent.setData(uri);
            context.startActivity(intent);
        } else if(methodCall.method.equalsIgnoreCase("uninstallApp")){
            Intent intent = new Intent(Intent.ACTION_DELETE);
            intent.setData(Uri.fromParts(SCHEME, methodCall.arguments.toString(), null));
            toUninstall = methodCall.arguments.toString();
            context.startActivityForResult(intent,841);
        } else result.notImplemented();
    }
    static byte[] getBitmapFromDrawable(Drawable drawable) {
        final Bitmap bmp = Bitmap.createBitmap(60, 60, Bitmap.Config.ARGB_8888);
        final Canvas canvas = new Canvas(bmp);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG,100,stream);
        return stream.toByteArray();
    }
}
