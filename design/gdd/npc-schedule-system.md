# NPC 日程系统

> **Status**: Designed
> **Author**: Claude + User
> **Last Updated**: 2026-06-15
> **Implements Pillar**: Pillar 5（多周目见全貌）— NPC 日程随人生变化

## Overview

**NPC 日程系统**是游戏的核心层，负责管理 NPC 在不同时间出现在不同位置。它是「探索与发现」的核心乐趣来源——玩家每天在小镇中走动，遇到不同的 NPC，触发不同的事件。

**技术层面**：每个 NPC 有日程表（Schedule），定义在不同时段的位置和行为。日程表随人生年龄变化（童年/少年/青年版本不同）。NPC 按日程在小镇中移动，使用简易状态机管理行为。

**玩家体验层面**：玩家在小镇中探索时，每天都有新的遇见机会——早晨在小卖部遇到大壮，下午在学校遇到小芳，傍晚在老槐树遇到小刚。NPC 不是固定的障碍物，而是「活」的人。

**核心设计原则**：NPC 日程应该「可预测但不完全可预测」——玩家知道大概在哪里能找到 NPC，但偶尔会有惊喜。

## Player Fantasy

**「这些人有自己的生活。」**

玩家在小镇中走动时，应该感到 NPC 不是等待玩家触发的「任务机器」，而是有自己日程的「人」——他们会在特定时间出现在特定地点，做特定的事情。玩家需要「找到」他们，而不是他们主动找上门。

**支柱服务**：直接服务 Pillar 5（多周目见全貌）— 不同人生阶段，NPC 日程不同，玩家看到不同版本的小镇。

## Detailed Design

### Core Rules

**1. 日程表结构**

每个 NPC 有日程表，定义在不同时段的位置：
```json
{
  "npc_id": "xiaogang",
  "schedules": {
    "childhood": {
      "morning": {"location": "home", "behavior": "playing"},
      "afternoon": {"location": "school", "behavior": "studying"},
      "evening": {"location": "old_tree", "behavior": "chatting"},
      "night": {"location": "home", "behavior": "sleeping"}
    },
    "teen": {
      "morning": {"location": "school", "behavior": "studying"},
      "afternoon": {"location": "school", "behavior": "studying"},
      "evening": {"location": "old_tree", "behavior": "secret"},
      "night": {"location": "home", "behavior": "sleeping"}
    }
  }
}
```

**2. 日程切换规则**
- NPC 按日内时间段切换位置
- NPC 按人生年龄切换日程表版本
- NPC 在场景间移动时使用简易路径（非 A* 寻路）
- NPC 到达目标位置后执行行为（站立/坐下/走动/对话）

**3. NPC 行为状态**

| 行为 | 说明 | 可交互 |
|------|------|--------|
| **idle** | 站立不动 | 是 |
| **walking** | 走向目标位置 | 否 |
| **playing** | 玩耍（童年） | 是 |
| **studying** | 学习（少年） | 是 |
| **working** | 工作（青年/中年） | 有限 |
| **sleeping** | 睡觉 | 否 |

**4. NPC 避让**
- NPC 遇到玩家时自动避让（绕行）
- NPC 不会穿过玩家
- NPC 之间不碰撞（简化处理）

### States and Transitions

| 状态 | 描述 | 可转入 |
|------|------|--------|
| **AT_LOCATION** | 在目标位置 | MOVING |
| **MOVING** | 移向下一个位置 | AT_LOCATION |
| **INTERACTING** | 与玩家交互中 | AT_LOCATION |

### Interactions with Other Systems

| 系统 | 数据流向 | 接口 |
|------|---------|------|
| **时间系统** ← | 当前时段 → 日程切换 | 信号：`time_period_changed` |
| **场景管理系统** ← | 当前场景 → NPC 加载 | 查询当前场景名 |
| **玩家控制系统** ← | 玩家位置 → 避让 | 查询玩家位置 |
| **事件引擎** ← | NPC 状态 → 事件触发 | 查询 NPC 当前位置和行为 |
| **对话系统** ← | NPC 交互 → 对话启动 | 调用接口：`start_npc_dialogue(npc_id)` |

## Formulas

NPC 移动速度公式：
`npc_speed = base_npc_speed × age_modifier`

| 变量 | 符号 | 类型 | 范围 | 描述 |
|------|------|------|------|------|
| base_npc_speed | S | float | 80–150 | NPC 基础移动速度 |
| age_modifier | A | float | 0.7–1.1 | 年龄段修正 |

## Edge Cases

- **如果 NPC 目标位置在另一个场景中**：NPC 在当前场景消失，在目标场景出现
- **如果 NPC 日程冲突（同一时间两个位置）**：使用优先级更高的日程
- **如果玩家在 NPC 移动路径上**：NPC 等待或绕行
- **如果场景切换时 NPC 正在移动**：重置 NPC 到目标位置

## Dependencies

依赖：
- **时间系统**：查询当前时段
- **场景管理系统**：查询当前场景

被以下系统依赖：
- **对话系统**：依赖 NPC 位置启动对话
- **事件引擎**：依赖 NPC 状态触发事件
- **NPC 平行人生系统**：依赖 NPC 日程展示不同人生

## Tuning Knobs

| 旋钮 | 默认值 | 范围 | 说明 |
|------|--------|------|------|
| npc_base_speed | 100 | 80–150 | NPC 基础移动速度 |
| npc_avoidance_range | 32px | 16–64 | NPC 避让检测范围 |
| schedule_update_interval | 1.0s | 0.5–2.0 | 日程检查间隔 |

## Visual/Audio Requirements

- NPC 行走动画（四方向）
- NPC 行为动画（学习/工作/玩耍）
- NPC 头顶的名称/图标显示

## UI Requirements

- NPC 交互提示（靠近时显示名称）

## Acceptance Criteria

- GIVEN 早晨时段，WHEN 小刚的日程为"在家"，THEN 小刚出现在家的位置
- GIVEN 下午时段，WHEN 时间切换到下午，THEN 小刚移动到学校
- GIVEN 玩家靠近小刚，WHEN 小刚在 idle 状态，THEN 显示交互提示
- GIVEN NPC 正在移动，WHEN 玩家挡在路上，THEN NPC 等待或绕行
- GIVEN 童年年龄段，WHEN 查看小刚日程，THEN 日程为童年版本

## Open Questions

- NPC 在不同场景间的移动路径如何定义
- NPC 行为动画的资源需求需要评估
