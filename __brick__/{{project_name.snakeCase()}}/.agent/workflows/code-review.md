---
description: 审核代码变更（Code Review）
---

# Code Review Workflow

使用 `.agent/skills/code-review-skill` 对当前 Git 工作区的代码变更进行全面审查。

## Steps

// turbo
1. 获取当前所有变更

```bash
git diff HEAD
```

// turbo
2. 获取变更文件列表

```bash
git status
```

3. 读取并激活项目 skill：`.agent/skills/code-review-skill/SKILL.md`

4. 按照 skill 的四阶段审查流程，对变更进行逐文件审查，使用 skill 中定义的严重性标记（🔴 Critical / 🟡 Major / 🔵 Minor / 💡 Suggestion）输出结构化报告。
