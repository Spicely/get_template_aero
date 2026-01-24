---
name: Coding Standards
description: Guidelines for using project-specific components and data utilities. Enforces reuse of `lib/app/components` and `lib/app/data`.
---

# Luma Flu Coding Standards

This skill defines the coding standards for the Luma Flu project. You MUST follow these guidelines when writing code.

## 1. UI Components (`lib/app/components`)

**Rule:** Always prioritize using existing components from `lib/app/components` over raw Flutter widgets or creating new duplicates.

### Key Components:

- **Buttons:** Use `ThemeButton` (`lib/app/components/theme_button/theme_button.dart`).
  - Supports gradients, debouncing (`TapDebouncer`), and custom styling.
  - Do NOT use `ElevatedButton` or `TextButton` directly if a `ThemeButton` can serve the purpose.
- **Images:** Use `CachedImage` (`lib/app/components/cached_image`) for network images.
- **Dialogs:** Check `lib/app/components/dialog` for existing dialogs (e.g., `PermissionDialog`, `UpgradeDialog`).
- **Layout:** Check `future_layout_builder`, `grid`, `list_item` folders for standard layout patterns.

### Usage Example:

```dart
import 'package:luma_flu/lib/app/components/theme_button/theme_button.dart';

// CORRECT
ThemeButton(
  onPressed: () async => await doSomething(),
  child: Text("Submit"),
)

// AVOID
ElevatedButton(
  onPressed: () => doSomething(),
  child: Text("Submit"),
)
```

## 2. Data & Utilities (`lib/app/data`)

**Rule:** Use the centralized `utils` object and standard data structures located in `lib/app/data`.

### Utils Access (`lib/app/data/utils/utils.dart`):

The project uses a singleton `utils` object to access core services.

- **Logging:** Use `utils.logger` instead of `print` or creating new Logger instances.
- **Database:** Access database functions via `utils.db`.
- **Config:** Access app configuration via `utils.config`.
- **Tools:** Common helpers are in `utils.tools`.
- **APIs:** API clients are managed in `utils.apis`.

### Directory Structure:

- **`models/`**: Place all data models here.
- **`database/`**: Database related logic.
- **`theme/`**: Theme configurations.

### Usage Example:

```dart
import 'package:luma_flu/lib/app/data/utils/utils.dart';

void example() {
  // CORRECT
  utils.logger.d("Debug message");

  // AVOID
  print("Debug message");
}
```

## 3. General Guidelines

- **Consistency:** Follow the existing file structure and naming conventions.
- **Imports:** Use specific imports or relative imports consistent with the file functionality.
- **State Management:** (Infer from project, looks like GetX based on `utils.dart` imports seeing `package:get/get.dart`). Use GetX for state management if consistent with the module.
