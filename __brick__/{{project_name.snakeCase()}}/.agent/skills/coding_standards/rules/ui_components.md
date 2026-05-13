# 1. UI Components (`lib/app/components`)

**Rule:** Always prioritize using existing components from `lib/app/components` over raw Flutter widgets or creating new duplicates.

### Component Reference

#### 1. Images

**Component:** `CachedImage`

- **Path:** `lib/app/components/cached_image/cached_image.dart`
- **Description:** A powerful image component that supports network images (with caching), assets, files, and memory images. Handles placeholders, error states, and border radius automatically.
- **When to use:** ALWAYS use this for displaying images instead of `Image.network`, `CachedNetworkImage`, or `Image.asset`.
- **Example:**
  ```dart
  CachedImage(
    imageUrl: "https://example.com/image.jpg",
    width: 100,
    height: 100,
    borderRadius: BorderRadius.circular(8),
  )
  ```

#### 2. Buttons

**Component:** `ThemeButton`

- **Path:** `lib/app/components/theme_button/theme_button.dart`
- **Description:** A customizable button with gradient support and built-in tap debouncing (`TapDebouncer`) to prevent double-clicks.
- **When to use:** Primary action buttons that need branding/gradients or debouncing.
- **Example:**
  ```dart
  ThemeButton(
    width: 200,
    height: 50,
    onPressed: () async => await submit(), // Standard async support
    child: Text("Submit"),
  )
  ```

**Component:** `LoadingButton`

- **Path:** `lib/app/components/theme_button/loading_button.dart`
- **Description:** A `ThemeButton` equivalent that automatically shows a loading spinner while the `onPressed` async callback is executing. Handles error capturing via `utils.tools.exceptionCapture`.
- **When to use:** Buttons that trigger network requests or long-running tasks.
- **Example:**
  ```dart
  LoadingButton(
    onPressed: () async => await apiCall(),
    child: Text("Login"),
  )
  ```

#### 3. Lists & Grids

**Component:** `SmartRefresh`

- **Path:** `lib/app/components/smart_refresh/smart_refresh.dart`
- **Description:** A unified component for handling pull-to-refresh, load more, initial data fetching (skeleton/loading states), and empty states.
- **When to use:** Whenever building a list or grid that requires pulling to refresh, pagination, or standard loading/empty states.
- **Example:**
  ```dart
  SmartRefresh(
    controller: controller.refreshController,
    onRefresh: controller.onRefresh,
    onLoadMore: controller.onLoadMore,
    initData: controller.initData,
    isEmpty: () => controller.items.isEmpty,
    emptyText: '暂无数据',
    loadingWidget: LoadingSkeleton(), // Shown during initData
    childBuilder: (context, physics) {
      return ListView.builder(
        physics: physics, // Must pass physics to the scrollable
        itemCount: controller.items.length,
        itemBuilder: (context, index) => Text(controller.items[index]),
      );
    },
  )
  ```

**Component:** `ListItem`

- **Path:** `lib/app/components/list_item/list_item.dart`
- **Description:** A highly configurable list row widget. Supports titles, values, leading icons, trailing arrows, dividers, and tap handling.
- **When to use:** Settings menus, profile details, or any list content.
- **Example:**
  ```dart
  ListItem(
    title: Text("Username"),
    value: Text("Spicely"),
    showArrow: true,
    onTap: () => editUser(),
    showDivider: true,
  )
  ```

**Component:** `GridBox` & `GridItem`

- **Path:** `lib/app/components/grid/grid.dart`
- **Description:** A concise way to build grid layouts without verbose `GridView` boilerplate.
- **When to use:** Dashboard menus, feature grids.

#### 4. Layout Utilities

**Component:** `FutureLayoutBuilder<T>`

- **Path:** `lib/app/components/future_layout_builder/future_layout_builder.dart`
- **Description:** Automatically handles `Future` states: displays a loading widget while waiting, an error widget on failure, and the content on success. Supports auto-reloading.
- **When to use:** fetching data for a page or section.
- **Example:**
  ```dart
  FutureLayoutBuilder<UserInfo>(
    future: () => api.getUserInfo(),
    builder: (data) => UserProfile(data),
  )
  ```

**Component:** `AutoKeep`

- **Path:** `lib/app/components/auto_keep/auto_keep.dart`
- **Description:** Keeps the widget state alive (wraps `AutomaticKeepAliveClientMixin`).
- **When to use:** In `PageView` or `TabBarView` children to preserve state.

**Component:** `Empty`

- **Path:** `lib/app/components/empty/empty.dart`
- **Description:** A placeholder widget for empty states.
- **When to use:** When a list or data view has no content.

**Component:** `DividerText`

- **Path:** `lib/app/components/divider_text/divider_text.dart`
- **Description:** Displays text flanked by horizontal dividers (e.g., "-- OR --").
- **When to use:** Login forms or section separators.

#### 5. Page Utilities

**Component:** `PageInit`

- **Path:** `lib/app/components/page_init/page_init.dart`
- **Description:** A wrapper for top-level pages. Handles "Press back again to exit" logic, click-outside-to-dismiss-keyboard, and Android back-to-desktop.
- **When to use:** Wrap the root widget of every major screen/page.

**Component:** `CodeTime`

- **Path:** `lib/app/components/code_time/code_time.dart`
- **Description:** A countdown timer for verification codes (e.g., sending SMS code).
- **When to use:** Registration or Forgot Password screens.

#### 6. Dialogs

**Rule:** Custom dialog components MUST be created in their own folder under `lib/app/components/dialog/` (e.g., `lib/app/components/dialog/{dialog_name}/{dialog_name}.dart`). Do not write raw UI widgets directly inside `Get.dialog`.

**Component:** `PermissionDialog`

- **Path:** `lib/app/components/dialog/permission_dialog/permission_dialog.dart`
- **Description:** Standard dialog for guiding users to settings when permissions are denied.

**Component:** `UpgradeDialog`

- **Path:** `lib/app/components/dialog/upgrade_dialog/upgrade_dialog.dart`
- **Description:** App update dialog showing version info and progress.

**Component:** `ImagePreviewDialog`

- **Path:** `lib/app/components/dialog/image_preview_dialog/image_preview_dialog.dart`
- **Description:** Dialog for previewing images with a dark overlay.

**Component:** `ConfirmDialog`

- **Path:** `lib/app/components/dialog/confirm_dialog/confirm_dialog.dart`
- **Description:** A modern, customizable confirmation dialog replacing `Get.defaultDialog`.
