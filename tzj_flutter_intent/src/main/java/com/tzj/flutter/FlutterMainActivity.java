package com.tzj.flutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Window;

import io.flutter.plugin.common.PluginRegistry;

/**
 * flutter  容器
 */
public class FlutterMainActivity extends TzjFlutterActivity {
    public static IPluginRegistrant mPluginRegistrant;

    public static void start(Context context) {
        Intent starter = new Intent(context, FlutterMainActivity.class);
        context.startActivity(starter);
    }

    /**
     * @param context
     * @param uri     运行的文件路径
     * @param entrypoint 入口函数
     * @param route   路由
     */
    public static void start(Context context, Uri uri, String entrypoint, String route) {
        Intent starter = new Intent(context, FlutterMainActivity.class);
        starter.setAction(Intent.ACTION_RUN);
        if (uri != null) {
            starter.setData(uri);
        }
        if (entrypoint != null) {
            starter.putExtra("entrypoint", entrypoint);
        }
        if (route != null) {
            starter.putExtra("route", route);
        }
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        //去除标题
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        //全屏
//        getWindow().setFlags(
//                WindowManager.LayoutParams.FLAG_FULLSCREEN,
//                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        super.onCreate(savedInstanceState);
        if (mPluginRegistrant == null){
            throw new RuntimeException("请设置 FlutterMainActivity.mPluginRegistrant");
        }
        mPluginRegistrant.registerWith(this);
    }

    @Override
    public void finish() {
        //onBackPressed -> flutter/navigation.popRoute -> SystemNavigator.pop()
        // -> flutter/platform.SystemNavigator.pop -> finish()
        //最后会调用到这，但是系统不支持返回参数，除非自己去实现
        setResult(hashCode()%10000);
        super.finish();
    }

    public interface IPluginRegistrant{
        void registerWith(PluginRegistry registry);
    }
}
