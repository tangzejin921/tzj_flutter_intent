# android_intent

android intent 的跳转

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://.io/platform-plugins/#edit-code).flutter


## 问题：
发现 android:launchMode="singleTop" 的activity  可以开启多个，
其他的 launchMode 并没有验证

返回键的判断，是返回上一路由还是返回原生
原生->flutter->原生->flutter  这种情况怎么处理


## 打开同一个界面时报这些错

    E/EGL_emulation: eglMakeCurrent: error: EGL_BAD_ACCESS: context 0x707806edb060 current to another thread!
    E/EGL_emulation: tid 9408: eglMakeCurrent(1663): error 0x3002 (EGL_BAD_ACCESS)
    E/libEGL: eglMakeCurrent:1091 error 3002 (EGL_BAD_ACCESS)
    E/flutter: [ERROR:flutter/shell/platform/android/android_context_gl.cc(217)] Could not make the context current
    E/flutter: [ERROR:flutter/shell/platform/android/android_context_gl.cc(53)] EGL Error: EGL_BAD_ACCESS (12290)



