# flutter 模板

> 前置

```
    flutter pub global activate get_cli # 安装get_cli

    flutter pub global activate intl_utils

    dart pub global activate fastforge

    dart pub global activate spider

    /// 资源处理
    fluttergen

    /// 依据env生成
    dart run build_runner build

    /// 图标生成
    dart run flutter_launcher_icons

    /// 启动页图片
    dart run flutter_native_splash:create
```

> 打包

```
    /// 打包测试
    fastforge release --name dev

    /// 打包测试android
    fastforge release --name dev --jobs release-dev-android --skip-clean

    /// 打包测试ios
    fastforge release --name dev --jobs release-dev-ios --skip-clean

    /// 打包正式
    fastforge release --name prod --skip-clean

    /// 打包正式android
    fastforge release --name prod --jobs release-android --skip-clean

    /// 打包正式ios
    fastforge release --name prod --jobs release-ios --skip-clean

    /// 打包正式windows
    fastforge release --name prod --jobs release-windows --skip-clean

    /// 打包正式macos
    fastforge release --name prod --jobs release-macos --skip-clean

```

> 权限

```
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```
