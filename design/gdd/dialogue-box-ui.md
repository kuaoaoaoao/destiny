# 对话框 UI

> **Status**: Designed
> **Author**: Claude + User
> **Last Updated**: 2026-06-15
> **Implements Pillar**: Pillar 1（真实大于戏剧）— 对话框简洁，不抢戏

## Overview

**对话框 UI**是游戏的展示层，负责显示 NPC 对话和选项。对话框应该简洁、自然，不抢戏。

**技术层面**：Control 节点，显示 NPC 头像、名称、对话文字、选项列表。支持打字机效果和选项选择。

**玩家体验层面**：玩家看到简洁的对话框——NPC 头像、名字、对话文字。对话框是「窗口」，不是「屏幕」。

**核心设计原则**：对话框应该「透明」——玩家看到 NPC，不是看到 UI。

## Detailed Design

### Core Rules

**1. 对话框布局**

```
┌─────────────────────────────────┐
│ [头像] NPC名称                   │
│                                 │
│ 对话文字内容...                  │
│                                 │
│ > 选项1                         │
│ > 选项2                         │
│ > 选项3                         │
└─────────────────────────────────┘
```

**2. 对话框行为**
- 底部居中显示
- 打字机效果显示文字
- 按交互键推进对话或选择选项
- 对话结束时自动隐藏

### Interactions with Other Systems

| 系统 | 数据流向 | 接口 |
|------|---------|------|
| **对话系统** ← | 对话数据 → UI 显示 | 信号：`dialogue_started(data)` |

## Formulas

无复杂公式。

## Edge Cases

- **如果对话文字过长**：自动换行，超出部分滚动
- **如果选项过多**：滚动显示

## Dependencies

依赖：
- **对话系统**：接收对话数据

## Tuning Knobs

| 旋钮 | 默认值 | 范围 | 说明 |
|------|--------|------|------|
| text_speed | 0.05s | 0.02–0.1 | 打字机速度 |
| dialogue_box_opacity | 0.9 | 0.7–1.0 | 对话框透明度 |

## Visual/Audio Requirements

- 对话框的视觉风格（暖色调、绘本感）
- 打字机音效
- 选项选择音效

## UI Requirements

- 对话框布局（底部居中）
- NPC 头像和名称显示
- 选项列表

## Acceptance Criteria

- GIVEN 对话开始，WHEN 显示对话框，THEN 显示 NPC 头像和对话文字
- GIVEN 对话进行中，WHEN 按交互键，THEN 推进到下一句
- GIVEN 有选项，WHEN 玩家选择，THEN 应用选择效果

## Open Questions

- 对话框的具体视觉风格需要美术设计
