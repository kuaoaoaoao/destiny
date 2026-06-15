# 事件引擎

> **Status**: Designed
> **Author**: Claude + User
> **Last Updated**: 2026-06-15
> **Implements Pillar**: Pillar 1（真实大于戏剧）— 事件触发自然，不强制打断

## Overview

**事件引擎**是游戏的核心层，负责管理 30-40 个事件的触发、条件检查和执行。它是数据驱动架构的地基——所有事件用 JSON 定义，不在代码里写死。

**技术层面**：Autoload 单例 `EventEngine`，管理事件数据库、触发条件检查、事件执行队列。事件通过 JSON 文件定义，支持位置触发、NPC 触发、时间触发、数值触发、伙伴线触发 5 种触发方式。

**玩家体验层面**：玩家在小镇中自然地遇到事件——走进某个角落触发回忆，靠近某个 NPC 触发对话，到达某个年龄触发人生节点。事件不是弹窗打断，而是「在场体验」。

**核心设计原则**：事件应该「被遇到，不被推送」——玩家主动接近触发，不是被动弹窗。

## Player Fantasy

**「这个小镇记得我。」**

玩家在小镇中探索时，应该感到世界在回应自己的存在——走到操场角落触发被欺负事件，靠近哭泣的小芳触发她的故事，高考前夜自动触发紧张氛围。事件是小镇的「记忆」，记录着玩家的人生轨迹。

**支柱服务**：直接服务 Pillar 1（真实大于戏剧）— 事件触发自然，不强制打断；服务 Pillar 3（见证者，非英雄）— 事件是「发生在你身上」的，不是「你主动发起」的。

## Detailed Design

### Core Rules

**1. 事件数据结构**

每个事件用 JSON 定义，包含以下字段：
```json
{
  "id": "childhood_bully",
  "name": "操场角落",
  "trigger_type": "location",
  "trigger_location": "school_corner",
  "trigger_conditions": {
    "age_range": [7, 12],
    "time_period": "afternoon",
    "affinity_xiaogang": {"min": 30}
  },
  "dialogue": [
    {"speaker": "narrator", "text": "你听到角落里传来哭声..."},
    {"speaker": "choice", "options": [
      {"text": "走过去看看", "effects": {"psychology": -5, "social": 5}},
      {"text": "装作没听到", "effects": {"psychology": 5}}
    ]}
  ],
  "effects": {"psychology": -10},
  "one_time": true
}
```

**2. 五种触发方式**

| 触发方式 | 说明 | 示例 |
|---------|------|------|
| **位置触发** | 走进特定区域 | 走进操场角落 → 被欺负事件 |
| **NPC 触发** | 走近某 NPC | 走近哭泣的小芳 → 触发她的事件 |
| **时间触发** | 到达某时刻/日期 | 高考前夜自动触发 |
| **数值触发** | 数值达标 | 金钱<20 → 回家触发"父母吵架欠债" |
| **伙伴线触发** | 伙伴人生线推进 | 小刚"去打工"时自动播过场 |

**3. 事件执行规则**
- 同一时间只能执行一个事件
- 事件执行期间暂停日内时间
- 事件结果直接修改六大数值
- 一次性事件（`one_time: true`）触发后标记为已完成
- 可重复事件（`one_time: false`）每次满足条件都触发

**4. 事件优先级**
- 人生节点事件 > 伙伴线事件 > 普通事件
- 如果多个事件同时满足条件，按优先级顺序执行

### States and Transitions

| 状态 | 描述 | 可转入 |
|------|------|--------|
| **IDLE** | 无事件执行 | CHECKING |
| **CHECKING** | 检查触发条件 | TRIGGERED, IDLE |
| **TRIGGERED** | 事件触发，等待执行 | EXECUTING |
| **EXECUTING** | 事件执行中（对话/选择） | IDLE |

### Interactions with Other Systems

| 系统 | 数据流向 | 接口 |
|------|---------|------|
| **时间系统** ← | 当前时间/年龄 → 条件检查 | 查询接口 |
| **玩家控制系统** ← | 玩家位置 → 位置触发 | 信号：`player_entered_area(area_id)` |
| **NPC 日程系统** ← | NPC 状态 → NPC 触发 | 查询接口 |
| **命运系统** ← | 事件结果 → 数值修改 | 调用接口：`modify_stats(effects)` |
| **对话系统** ← | 事件对话 → 对话显示 | 调用接口：`start_dialogue(dialogue_data)` |
| **人生节点系统** ← | 关键事件 → 节点推进 | 信号：`life_node_triggered(node_id)` |

## Formulas

事件条件检查公式：
`event_triggerable = (age_in_range AND time_matches AND conditions_met AND not_completed)`

| 变量 | 符号 | 类型 | 范围 | 描述 |
|------|------|------|------|------|
| age_in_range | A | bool | true/false | 当前年龄在事件年龄范围内 |
| time_matches | T | bool | true/false | 当前时段匹配事件时间要求 |
| conditions_met | C | bool | true/false | 所有数值条件满足 |
| not_completed | N | bool | true/false | 事件未完成（一次性事件） |

## Edge Cases

- **如果事件触发时玩家正在对话中**：排队等待，对话结束后触发
- **如果事件触发时玩家正在场景切换中**：取消触发，下次进入区域时重新检查
- **如果事件的数值条件在执行过程中变化**：以触发时的条件为准，执行过程中不重新检查
- **如果事件 JSON 格式错误**：跳过该事件，记录错误日志，不影响其他事件
- **如果同一位置有多个事件**：按优先级顺序执行，每次只执行一个

## Dependencies

依赖：
- **时间系统**：查询当前时间和年龄

被以下系统依赖：
- **人生节点系统**：依赖事件引擎触发关键事件
- **命运系统**：依赖事件引擎修改数值
- **小镇生活系统**：依赖事件引擎驱动生活循环

## Tuning Knobs

| 旋钮 | 默认值 | 范围 | 说明 |
|------|--------|------|------|
| event_check_interval | 0.5s | 0.2–1.0 | 事件条件检查间隔 |
| event_queue_max | 3 | 1–5 | 最大排队事件数 |
| dialogue_speed | 0.05s | 0.02–0.1 | 对话文字显示速度 |

## Visual/Audio Requirements

- 事件触发时的视觉提示（感叹号/闪烁）
- 事件对话的对话框 UI
- 事件完成后的数值变化特效

## UI Requirements

- 对话框 UI（显示 NPC 对话和选项）
- 数值变化提示（六大数值 +/- 显示）
- 事件日志（记录已触发事件）

## Acceptance Criteria

- GIVEN 角色进入操场角落，WHEN 年龄在 7-12 岁且为下午，THEN 触发"操场角落"事件
- GIVEN 事件执行中，WHEN 玩家按交互键，THEN 推进对话或选择选项
- GIVEN 事件完成，WHEN 数值效果应用，THEN 六大数值正确更新
- GIVEN 一次性事件已完成，WHEN 再次满足条件，THEN 事件不重复触发
- GIVEN 多个事件同时满足条件，WHEN 检查触发，THEN 按优先级顺序执行

## Open Questions

- 事件数据的 JSON Schema 需要定义
- 事件编辑器的 UI 设计需要工具链规划
- 222+ 事件的数据管理策略需要讨论
