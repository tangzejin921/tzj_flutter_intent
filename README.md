# tzj_flutter_intent
**只支持 android**
> 代码改至:<br>
[android_intent 0.2.1](https://github.com/flutter/plugins/tree/master/packages)<br>
[android_permissions_manager 0.0.4](https://github.com/Gigahawk/android_permissions_manager)
## 功能
- android 获取权限
- flutter 跳转 Activity (可以带参数，和返回参数)
- Activity 跳转 flutter (无法带参，及返参)

    **改了FlutterActivity，FlutterActivityDelegate**，达到自定义入口函数，而不是固定 main 函数

## 为什么要做下面的 工程引入
    因为工程结构被我改了，

    原来是：
    android
    ios
    lib
    pubspec.yaml

    被我改为了
    android
        src
            main
            flutter
                pubspec.yaml

    所以要做一些改动


## 工程引入
- pub 加入
    ```pub
    dev_dependencies:
      android_intent:
        git:
          url: git://github.com/tzjandroid/tzj_flutter_intent.git
          path: tzj_flutter_intent/src/flutter
    ```
- android 工程下的 settings.gradle 中改为如下
    ```Gradle
    def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

    def plugins = new Properties()
    def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
    if (pluginsFile.exists()) {
        pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
    }

    plugins.each { name, path ->
        def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
        if(!pluginDirectory.exists()){
            pluginDirectory = flutterProjectRoot.resolve(path).getParent().getParent().toFile()
        }
        if(pluginDirectory.exists()){
            include ":$name"
            project(":$name").projectDir = pluginDirectory
        }
    }
    ```
- android 工程下的 build.gradle  加入
    ```Gradle
    rootProject.extensions.add("android_intent",Type.isFlutterPlugin.name())
    enum Type{
        isAPP,
        isModule,
        isFlutterPlugin;
    }
    project.ext {
        ext._compileSdkVersion = 27
        ext._buildToolsVersion = '27.0.3'
        ext._minSdkVersion = 16
        ext._targetSdkVersion = 27
        ext._supportVersion = "27.1.1"
        ext.javaVersion = JavaVersion.VERSION_1_8
    }
    ```

## android 代码需要改动如下
找到 flutter 的宿主 Activity,改为如下 （FlutterMainActivity 就是一个 flutter宿主）
```java
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterMainActivity.mPluginRegistrant = new FlutterMainActivity.IPluginRegistrant() {
            @Override
            public void registerWith(PluginRegistry registry) {
                GeneratedPluginRegistrant.registerWith(registry);
            }
        };
        GeneratedPluginRegistrant.registerWith(this);
    }
```
做了上面改动就可以运行 demo 了

## example
example 目录有两个 demo
- 界面跳转 demo
- 请求权限 demo (两个文件)