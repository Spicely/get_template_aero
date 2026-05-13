# 4. UI/UX & Interaction Design

**Rule:** UI interactions MUST NOT be stiff or abrupt (生硬处理). All interactive elements, state changes, and overlays MUST include appropriate animations and physical feedback.

### Interaction Guidelines:

- **State Transitions:** Avoid sudden `if (show)` pop-ins. Use `AnimatedSwitcher`, `AnimatedOpacity`, or `AnimatedSize` to transition UI states smoothly.
- **Physical Feedback (Bounce/Scale):** Interactive elements (like buttons or selectable cards) should provide tactile visual feedback. Use `AnimatedScale` (e.g., shrinking to `0.92` on press) coupled with bouncy curves like `Curves.easeOutBack` or `Curves.elasticOut`.
- **Depth and Shadows:** Use dynamic `BoxShadow` that intensifies, drops, or spreads out when an element becomes active.
- **Overlays & Glassmorphism:** When presenting modal overlays or delete masks, prefer `BackdropFilter` (frosted glass/blur) over flat semi-transparent black masks for a premium, organic feel.
