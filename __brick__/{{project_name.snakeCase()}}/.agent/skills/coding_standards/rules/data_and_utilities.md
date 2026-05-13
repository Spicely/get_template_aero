# 2. Data & Utilities (`lib/app/data`)

**Rule:** Use the centralized `utils` object and standard data structures located in `lib/app/data`.

### Utils Access (`lib/app/data/utils/utils.dart`):

The project uses a singleton `utils` object to access core services.

- **Logging:** Use `utils.logger` instead of `print`.
- **Database:** Access database functions via `utils.db`.
- **Config:** Access app configuration via `utils.config`.
- **Tools:** Common helpers are in `utils.tools` (e.g., `utils.tools.isNotEmpty`).
- **APIs:** API clients are managed in `utils.apis`.

### Directory Structure:

- **`models/`**: Place all data models here.
- **`database/`**: Database related logic.
- **`theme/`**: Theme configurations.
- **`mixins/`**: Reusable mixins for controllers.
  - **`RouterMixin`**: All routing navigation MUST be centralized here. The UI layer should NOT contain any conditional routing logic (`if (title == 'xxx')`). Furthermore, avoid using "unified" string-matching handlers. Instead, define **explicit, granular methods** for each navigation action (e.g., `toDrafts()`, `toAbout()`) inside `RouterMixin`. The UI components should bind to these specific methods directly via explicit callbacks (e.g., `onTap: homeController.toAbout`).
  - **`DialogMixin`**: All dialog invocations (e.g., `Get.dialog`, `Get.defaultDialog`) MUST be centralized here. Controllers should mix in `DialogMixin` to trigger dialogs (e.g., `showConfirmDialog`, `showImagePreview`). UI logic for dialogs should be extracted into separate components under `lib/app/components/dialog`.
  - **`PermissionMixin`**: Used for handling permission requests.
  - **`FocusMixin`**: Used for handling keyboard dismissal and focus logic.

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
