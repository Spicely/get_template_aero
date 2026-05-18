---
name: Page Creation (get_cli)
description: 使用 get_cli 在 ttcd 项目中创建新页面的标准流程。涵盖命令、文件结构、路由注册以及创建后必须完成的手动步骤。当用户要求创建新页面/模块时必须遵循此 skill。
---

# 页面创建规范（get_cli）

本项目使用 `get_cli` 脚手架生成页面模板。**每次创建新页面都必须严格遵循以下流程。**

---

## 1. 前提条件

`get_cli` 已全局安装，可执行文件位于：

```
/Users/macmini/.pub-cache/bin/get
```

项目包名（`pubspec.yaml` 中的 `name`）：`ttcd`  
模块根目录：`lib/app/modules/`  
路由文件：`lib/app/routes/app_pages.dart` 和 `lib/app/routes/app_routes.dart`

---

## 2. 生成页面命令

在项目根目录 `/Users/macmini/Documents/ttcd` 下执行：

```bash
get create page:<page_name>
```

**示例** — 创建一个名为 `setting` 的页面：

```bash
get create page:setting
```

该命令会自动生成以下文件结构：

```
lib/app/modules/setting/
├── bindings/
│   └── setting_binding.dart      # 依赖注入：懒加载 SettingController
├── controllers/
│   └── setting_controller.dart   # 业务逻辑控制器，继承 GetxController
└── views/
    └── setting_view.dart         # UI 视图，继承 GetView<SettingController>
```

并自动更新：
- `lib/app/routes/app_pages.dart` — 追加 `GetPage` 路由条目
- `lib/app/routes/app_routes.dart` — 追加路由常量

---

## 3. 生成后必须手动完成的步骤

> ⚠️ get_cli 生成的文件包含模板代码，必须按以下规范调整后才能使用。

### 3.1 检查 `app_routes.dart`

确认路由常量已正确添加，并**补充中文注释**说明页面用途：

```dart
abstract class Routes {
  // ...已有路由...

  /// 设置页
  static const SETTING = _Paths.SETTING;
}

abstract class _Paths {
  // ...已有路径...
  static const SETTING = '/setting';
}
```

### 3.2 检查 `app_pages.dart`

确认 `GetPage` 已正确添加：

```dart
GetPage(
  name: _Paths.SETTING,
  page: () => const SettingView(),
  binding: SettingBinding(),
),
```

### 3.3 在 `RouterMixin` 中添加导航方法

打开 `lib/app/data/mixins/router_mixin.dart`，在 mixin 内添加对应的**具名导航方法**：

```dart
/// 跳转到设置
void toSetting() {
  Get.toNamed(Routes.SETTING);
}
```

**规则：**
- 每个页面对应一个独立的具名方法，不得使用通用字符串匹配
- 如需传参使用 `parameters: {}` 或 `arguments`，保持语义清晰
- 导航逻辑必须集中在 `RouterMixin`，UI 层直接绑定方法引用（如 `onTap: controller.toSetting`）

### 3.4 调整 Controller 模板

`get_cli` 生成的 controller 默认含有空实现，根据业务需要补充：

```dart
import 'package:get/get.dart';

class SettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // 初始化数据
  }

  @override
  void onReady() {
    super.onReady();
    // 页面首次渲染完成后触发
  }

  @override
  void onClose() {
    super.onClose();
    // 释放资源
  }
}
```

### 3.5 调整 View 模板

遵循项目 UI 规范（参考 Coding Standards skill）：

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/page_init/page_init.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageInit(          // ✅ 顶层页面必须用 PageInit 包裹
      child: Scaffold(
        appBar: AppBar(title: const Text('设置')),
        body: const Center(child: Text('设置页')),
      ),
    );
  }
}
```

**注意：** `PageInit` 处理返回拦截、键盘收起等通用逻辑，所有顶层路由页面必须使用。

---

## 4. 嵌套子视图（非路由页面）

对于 Tab 页、子页面等**不需要独立路由**的视图，手动创建在父模块 `views/` 目录下，无需使用 `get create`：

```
lib/app/modules/home/views/
├── home_view.dart               # 主路由视图
├── home/
│   ├── index_view.dart          # Tab 子视图（手动创建）
│   └── index_controller.dart   # 子视图控制器（手动创建，Get.put 注入）
└── same/
    └── same_view.dart           # 另一个 Tab 子视图
```

子视图 Controller 通过 `Get.put` 在 View 中直接注入，而不是通过 Binding：

```dart
// index_view.dart
class IndexView extends StatelessWidget {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IndexController());  // 直接 put
    return ...;
  }
}
```

---

## 5. 完整流程速查

```
1. 执行命令
   cd /Users/macmini/Documents/ttcd
   get create page:<name>

2. 检查生成文件
   - lib/app/modules/<name>/bindings/<name>_binding.dart   ✓
   - lib/app/modules/<name>/controllers/<name>_controller.dart  ✓
   - lib/app/modules/<name>/views/<name>_view.dart          ✓
   - lib/app/routes/app_pages.dart（已追加 GetPage）       ✓
   - lib/app/routes/app_routes.dart（已追加常量）           ✓

3. 手动补充
   - app_routes.dart：添加中文注释
   - router_mixin.dart：添加 to<Name>() 方法
   - <name>_view.dart：用 PageInit 包裹，套用项目 UI 组件
   - <name>_controller.dart：实现业务逻辑
```

---

## 6. 注意事项

- **不要**在 View 中直接调用 `Get.toNamed()`，所有导航统一走 `RouterMixin`
- **不要**在 View 中写路由跳转条件判断逻辑
- Binding 中使用 `Get.lazyPut` 而非 `Get.put`（懒加载，按需创建）
- 页面名称使用 `snake_case`（如 `buy_membership`），生成后 class 名自动为 `PascalCase`
