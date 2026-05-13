# 3. General Guidelines

- **Consistency:** Follow the existing file structure and naming conventions.
- **Imports:** Use specific imports or relative imports consistent with the file functionality.
- **State Management:** Use GetX for state management where appropriate (aligned with project patterns).
- **Category UI:** If encountering a category selection or classification UI (分类), ALWAYS prioritize considering `TabBar + TabBarView` over custom horizontal lists or manual state switching.
- **Colors:** 颜色 优先从 `lib/app/data/theme/extend_theme.dart` 获取。
