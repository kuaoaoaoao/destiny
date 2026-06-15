# HUD 系统

> **Status**: Designed
> **Author**: Claude + User
> **Last Updated**: 2026-06-15
> **Implements Pillar**: Pillar 4（小镇是情感锚点）— HUD 不遮挡小镇风景

## Overview

**HUD 系统**是游戏的展示层，负责显示基础信息——日内时间、当前位置、交互提示。HUD 应该最小化，不遮挡小镇风景。

**技术层面**：CanvasLayer 上的 Control 节点，显示时间、位置、交互提示。使用信号接收其他系统的数据更新。

**玩家体验层面**：玩家看到最小化的 HUD——时间图标、位置名称、交互提示。HUD 是「背景信息」，不是「前景噪音」。

**核心设计原则**：HUD 应该「存在但不显眼」——玩家需要时能找到，不需要时不会注意到。

## Detailed Design

### Core Rules

**1. HUD 元素**

| 元素 | 位置 | 显示内容 |
|------|------|---------|
| 时间图标 | 左上角 | 太阳/月亮图标，表示时段 |
| 位置名称 | 顶部居中 | 当前场景名称 |
| 交互提示 | 底部居中 | 按键提示/点击区域 |
| 年龄显示 | 左上角 | 当前年龄（关键日时显示） |

**2. HUD 显示规则**
- 默认显示时间图标和位置名称
- 靠近可交互物体时显示交互提示
- 关键日时显示年龄
- 对话/菜单时隐藏 HUD

### Interactions with Other Systems

| 系统 | 数据流向 | 接口 |
|------|---------|------|
| **时间系统** ← | 当前时段 → 时间图标 | 查询接口 |
| **场景管理系统** ← | 当前场景 → 位置名称 | 查询接口 |
| **玩家控制系统** ← | 交互状态 → 交互提示 | 信号：`interaction_available` |

## Formulas

无复杂公式。

## Edge Cases

- **如果 HUD 元素重叠**：自动调整位置避免重叠
- **如果场景名称过长**：截断显示

## Dependencies

依赖：
- **时间系统**：查询当前时段
- **场景管理系统**：查询当前场景
- **玩家控制系统**：接收交互提示信号

## Tuning Knobs

| 旋钮 | 默认值 | 范围 | 说明 |
|------|--------|------|------|
| hud_opacity | 0.8 | 0.5–1.0 | HUD 透明度 |
| interaction_prompt_duration | 3.0s | 1.0–5.0 | 交互提示显示时间 |

## Visual/Audio Requirements

- 最小化的 HUD 设计
- 时间图标的变化（太阳/月亮）
- 交互提示的动画

## UI Requirements

- HUD 布局（左上角/顶部居中/底部居中）

## Acceptance Criteria

- GIVEN 游戏运行，WHEN 查看 HUD，THEN 显示时间图标和位置名称
- GIVEN 靠近可交互物体，WHEN 进入交互范围，THEN 显示交互提示
- GIVEN 对话进行中，WHEN 查看 HUD，THEN HUD 隐藏

## Open Questions

- HUD 的具体视觉设计需要 UX 设计
