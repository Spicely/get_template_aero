---
name: Coding Standards
description: Guidelines for using project-specific components and data utilities. Enforces reuse of `lib/app/components` and `lib/app/data`.
---

# Luma Flu Coding Standards

This skill defines the coding standards for the Luma Flu project. You MUST follow these guidelines when writing code.
Depending on your current task, you MUST use the `view_file` tool to read the relevant sub-files before proceeding.

## Available Guidelines

1. **[UI Components](rules/ui_components.md)**
   - Read this when building or modifying UI. It contains rules for using existing components from `lib/app/components` like `CachedImage`, `ThemeButton`, `SmartRefresh`, `FutureLayoutBuilder`, Dialogs, etc.

2. **[Data & Utilities](rules/data_and_utilities.md)**
   - Read this when dealing with data, API calls, routing, permissions, or dialog invocations. It covers usage of the `utils` object and `lib/app/data` structure.

3. **[General Guidelines](rules/general_guidelines.md)**
   - Read this for general file structure, naming conventions, and state management (GetX).

4. **[UI/UX & Interaction Design](rules/ui_ux_design.md)**
   - Read this for interaction design rules, animations, state transitions, and physical feedback.

5. **[File Header Comments](rules/file_headers.md)**
   - Read this whenever creating a new Dart file. It contains the required file header template.

**CRITICAL:** You must read the specific files related to your task before writing code.
