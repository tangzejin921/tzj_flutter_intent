package com.tzj.flutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Window;

import io.flutter.app.FlutterActivity;

/**
 * flutter  容器
 */
public class FlutterMainActivity extends FlutterActivity {

    public static void start(Context context) {
        Intent starter = new Intent(context, FlutterMainActivity.class);
        context.startActivity(starter);
    }

    /**
     * @param context
     * @param uri       运行的路径
     * @param route     路由
     */
    public static void start(Context context, Uri uri,String route) {
        Intent starter = new Intent(context, FlutterMainActivity.class);
        starter.setAction(Intent.ACTION_RUN);
        if (uri!=null){
            starter.setData(uri);
        }
        if (route!=null){
            starter.putExtra("route",route);
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
    }


}
