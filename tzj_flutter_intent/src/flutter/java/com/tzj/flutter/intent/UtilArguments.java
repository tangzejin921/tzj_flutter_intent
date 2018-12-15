package com.tzj.flutter.intent;

import android.content.Intent;
import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class UtilArguments {
    /**
     * Map 转 Bundle ,rn 里有这个工具可以产考
     */
    public static Bundle convertArguments(Map<String, ?> arguments) {
        Bundle bundle = new Bundle();
        for (String key : arguments.keySet()) {
            Object value = arguments.get(key);
            if (value instanceof Integer) {
                bundle.putInt(key, (Integer) value);
            } else if (value instanceof String) {
                bundle.putString(key, (String) value);
            } else if (value instanceof Boolean) {
                bundle.putBoolean(key, (Boolean) value);
            } else if (value instanceof Double) {
                bundle.putDouble(key, (Double) value);
            } else if (value instanceof Long) {
                bundle.putLong(key, (Long) value);
            } else if (value instanceof byte[]) {
                bundle.putByteArray(key, (byte[]) value);
            } else if (value instanceof int[]) {
                bundle.putIntArray(key, (int[]) value);
            } else if (value instanceof long[]) {
                bundle.putLongArray(key, (long[]) value);
            } else if (value instanceof double[]) {
                bundle.putDoubleArray(key, (double[]) value);
            } else if (isTypedArrayList(value, Integer.class)) {
                bundle.putIntegerArrayList(key, (ArrayList<Integer>) value);
            } else if (isTypedArrayList(value, String.class)) {
                bundle.putStringArrayList(key, (ArrayList<String>) value);
            } else if (isStringKeyedMap(value)) {
                bundle.putBundle(key, convertArguments((Map<String, ?>) value));
            } else {
                throw new UnsupportedOperationException("Unsupported type " + value);
            }
        }
        return bundle;
    }

    /**
     * 是不是 type 类型的 ArrayList
     */
    private static boolean isTypedArrayList(Object value, Class<?> type) {
        if (!(value instanceof ArrayList)) {
            return false;
        }
        ArrayList list = (ArrayList) value;
        for (Object o : list) {
            if (!(o == null || type.isInstance(o))) {
                return false;
            }
        }
        return true;
    }

    /**
     * key 为String 的Map吗？
     */
    private static boolean isStringKeyedMap(Object value) {
        if (!(value instanceof Map)) {
            return false;
        }
        Map map = (Map) value;
        for (Object key : map.keySet()) {
            if (!(key == null || key instanceof String)) {
                return false;
            }
        }
        return true;
    }

    /**
     * intent 转 map
     */
    public static HashMap toMap(Intent data){
        HashMap map = new HashMap();
        if (data!=null){
            Bundle bund = data.getExtras();
            if (bund == null){
                bund = new Bundle();
            }
            for (String key : bund.keySet()) {
                map.put(key,bund.get(key));
            }
        }
        return map;
    }
}
