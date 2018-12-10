package com.tzj.flutter.intent;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * AndroidIntentPlugin
 * 代码部分是从 https://github.com/flutter/plugins/tree/master/packages android_intent 0.2.1
 *      https://github.com/Gigahawk/android_permissions_manager   android_permissions_manager 0.0.4
 * 拷过来的
 */
public class AndroidIntentPlugin implements MethodCallHandler {
    private final Registrar mRegistrar;
    private static WeakHashMap<Integer, Result> map = new WeakHashMap();

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), AndroidIntentPlugin.class.getSimpleName());
        channel.setMethodCallHandler(new AndroidIntentPlugin(registrar));
    }

    private AndroidIntentPlugin(final Registrar registrar) {
        this.mRegistrar = registrar;
        registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
            @Override
            public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
                Result result = map.remove(requestCode);
                if (result != null) {
                    HashMap map = UtilArguments.toMap(data);
                    map.put("code", resultCode);
                    result.success(map);
                    return true;
                }
                return false;
            }
        });
        registrar.addRequestPermissionsResultListener(new PluginRegistry.RequestPermissionsResultListener() {
            @Override
            public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
                final Result result = map.remove(requestCode);
                if (result != null) {
                    if (grantResults==null){
                        grantResults = new int[0];
                    }
                    List<Boolean> list = new ArrayList(grantResults.length);
                    for (int i = 0; i < grantResults.length; i++) {
                        list.add(grantResults[i] == PackageManager.PERMISSION_GRANTED);
                        //shouldShowRequestPermissionRationale false 表示请求到了权限/拒绝并且记住了
                        if (!ActivityCompat.shouldShowRequestPermissionRationale(mRegistrar.activity(), permissions[i]) &&
                                grantResults[i] != PackageManager.PERMISSION_GRANTED){
                            showDia();
                            list = new ArrayList();
                            list.add(false);
                            result.success(list);
                            return true;
                        }
                    }
                    result.success(list);
                    return true;
                }
                return false;
            }
        });
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        try {
            if (call.method.equals("launch")){
                call(call, result);
            }else if(call.method.equals("checkPermission")){
                result.success(checkPermission((String) call.arguments()));
            }else if(call.method.equals("requestPermissions")){
                requestPermissions(new ArrayList<String>((List<String>)call.arguments()),result);
            }else if (call.method.equals("openSettings")){
                openSettings();
            }else{
                result.notImplemented();
            }
        } catch (Exception e) {
            result.error("-1", e.getMessage() + "", e);
        }
    }

    /**
     * 无权限的dialog 提示
     */
    private void showDia(){
        new AlertDialog.Builder(mRegistrar.activeContext())
                .setTitle("没有权限无法运行程序")
                .setMessage("请到设置界面开启被关闭的权限")
                .setNegativeButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        Uri uri = Uri.fromParts("package", mRegistrar.context().getPackageName(), null);
                        intent.setData(uri);
                        mRegistrar.context().startActivity(intent);
                        dialog.dismiss();
                    }
                }).show();
    }

    /**
     * 打开界面
     */
    private void call(MethodCall call, final Result result) throws Exception {
        Activity context = mRegistrar.activity();
        if (context == null) {
            result.error("-1", "activity is destroy", null);
            return;
        }
        // Build intent
        Intent intent = new Intent();
        if (call.argument("action") != null) {
            String action = convertAction((String) call.argument("action"));
            intent.setAction(action);
        }
        if (call.argument("categorys") != null) {
            Object obj = call.argument("categorys");
            if (obj instanceof JSONArray){
                JSONArray array = (JSONArray) obj;
                for (int i = 0; i < array.length(); i++) {
                    String category = array.getString(i);
                    intent.addCategory(category);
                }
            }else{
                intent.addCategory(obj.toString());
            }
        }
        if (call.argument("data") != null) {
            intent.setData(Uri.parse((String) call.argument("data")));
        }
        if (call.argument("arguments") != null) {
            intent.putExtras(UtilArguments.convertArguments((Map) call.argument("arguments")));
        }
        if (call.argument("component") != null) {
            intent.setClassName(context, (String) call.argument("component"));
        }
        if (call.argument("flags") != null){
            intent.addFlags((int)call.argument("flags"));
        }
        if (call.argument("type") != null){
            intent.setType((String) call.argument("type"));
        }
        if (call.argument("package") != null) {
            intent.setPackage((String) call.argument("package"));
            if (intent.resolveActivity(context.getPackageManager()) == null) {
                intent.setPackage(null);
            }
        }
        int requestCode = -1;
        if (result != null) {
            map.put(result.hashCode() % 65530, result);
            requestCode = result.hashCode() % 65530;
        }
        context.startActivityForResult(intent, requestCode);
    }

    /**
     * action 转换
     */
    private String convertAction(String action) {
        if (action.equals("action_view")){
            return Intent.ACTION_VIEW;
        }else if (action.equals("action_voice")){
            return Intent.ACTION_VOICE_COMMAND;
        }else{
            return action;
        }
    }

    /**
     * 是否有权限
     */
    private boolean checkPermission(String permission) {
        int i = ContextCompat.checkSelfPermission(mRegistrar.activeContext(), permission);
        return PackageManager.PERMISSION_GRANTED == i;
    }
    /**
     * 请求权限
     */
    private void requestPermissions(ArrayList<String> permissions,final Result result) {
        Activity activity = mRegistrar.activity();
        String[] permsToRequest = new String[permissions.size()];
        permsToRequest = permissions.toArray(permsToRequest);
        int requestCode = 0;
        if (result != null) {
            map.put(result.hashCode() % 65530, result);
            requestCode = result.hashCode() % 65530;
        }
        ActivityCompat.requestPermissions(activity, permsToRequest, requestCode);
    }


    /**
     * 打开设置界面
     */
    private void openSettings() {
        Activity activity = mRegistrar.activity();
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,Uri.parse("package:" + activity.getPackageName()));
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(intent);
    }
}
