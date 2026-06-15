# 对话系统

> **Status**: Designed
> **Author**: Claude + User
> **Last Updated**: 2026-06-15
> **Implements Pillar**: Pillar 1（真实大于戏剧）— 对话自然，不说教

## Overview

**对话系统**是游戏的核心层，负责管理 NPC 对话和事件选择。没有对话，NPC 只是行走的贴图。

**技术层面**：管理对话树（Dialogue Tree）、对话选项、NPC 好感度影响。对话数据用 JSON 定义，支持分支选项和数值效果。推荐使用 Dialogic 插件或自研 DialogueBox。

**玩家体验层面**：玩家与 NPC 对话时，应该感到在与「真实的人」交流——NPC 有自己的性格、记忆和情感。对话不是任务提示，而是情感连接。

**核心设计原则**：对话应该「像真人说话」——简短、自然、有潜台词，不说教、不鸡汤。

## Player Fantasy

**「这些人记得我说过什么。」**

玩家与 NPC 对话时，应该感到 NPC 记得之前的互动——如果之前帮助过小刚，他会更信任你；如果之前忽视过小芳，她会更疏远。对话是情感的桥梁，不是信息的传递。

**支柱服务**：直接服务 Pillar 1（真实大于戏剧）— 对话自然，不说教。

## Detailed Design

### Core Rules

**1. 对话数据结构**

```json
{
  "dialogue_id": "xiaogang_childhood_1",
  "npc_id": "xiaogang",
  "nodes": [
    {
      "id": "start",
      "speaker": "xiaogang",
      "text": "嘿，你来啦！",
      "next": "choice_1"
    },
    {
      "id": "choice_1",
      "speaker": "player",
      "options": [
        {"text": "今天天气真好", "next": "weather", "effects": {"affinity_xiaogang": 5}},
        {"text": "你在干嘛？", "next": "doing", "effects": {}},
        {"text": "我先走了", "next": null, "effects": {}}
      ]
    }
  ]
}
```

**2. 对话流程**
- 玩家接近 NPC 并按交互键 → 启动对话
- 对话按节点顺序执行，支持分支选择
- 选项可能影响好感度和数值
- 对话结束后恢复正常移动

**3. 对话触发方式**
- **主动对话**：玩家按交互键触发
- **被动对话**：NPC 主动找玩家对话（特定条件下）
- **事件对话**：事件引擎触发的对话

**4. NPC 记忆**
- NPC 记住玩家之前的选择（通过好感度系统）
- 对话选项根据好感度变化
- 高好感度：更多信任对话
- 低好感度：更多疏远对话

### States and Transitions

| 状态 | 描述 | 可转入 |
|------|------|--------|
| **IDLE** | 无对话 | ACTIVE |
| **ACTIVE** | 对话进行中 | IDLE |
| **WAITING** | 等待玩家选择 | ACTIVE, IDLE |

### Interactions with Other Systems

| 系统 | 数据流向 | 接口 |
|------|---------|------|
| **NPC 日程系统** ← | NPC 状态 → 对话可用性 | 查询 NPC 是否可交互 |
| **事件引擎** ← | 事件对话 → 对话数据 | 传递对话 JSON |
| **命运系统** ← | 对话效果 → 数值修改 | 调用接口：`modify_stats(effects)` |
| **NPC 平行人生系统** ← | 好感度 → 对话分支 | 查询好感度值 |
| **对话框 UI** ← | 对话数据 → UI 显示 | 信号：`dialogue_started(data)` |

## Formulas

好感度变化公式：
`affinity_change = base_change × context_modifier`

| 变量 | 符号 | 类型 | 范围 | 描述 |
|------|------|------|------|------|
| base_change | B | int | -10–10 | 基础好感度变化 |
| context_modifier | C | float | 0.5–2.0 | 情境修正（关键事件倍率） |

**输出范围**：-20–20 好感度变化
**示例**：帮助小刚 = 5 × 1.0 = +5 好感度

## Edge Cases

- **如果 NPC 正在移动时触发对话**：NPC 停止移动，对话结束后恢复
- **如果对话中场景切换**：取消对话，不保存进度
- **如果对话选项有数值效果但数值已到边界**：应用效果但限制在有效范围内
- **如果对话 JSON 格式错误**：跳过对话，记录错误

## Dependencies

依赖：
- **NPC 日程系统**：查询 NPC 位置和状态
- **事件引擎**：接收事件对话数据

被以下系统依赖：
- **NPC 平行人生系统**：依赖对话影响好感度
- **人生节点系统**：依赖对话选择推进人生
- **对话框 UI**：依赖对话数据显示界面

## Tuning Knobs

| 旋钮 | 默认值 | 范围 | 说明 |
|------|--------|------|------|
| text_display_speed | 0.05s | 0.02–0.1 | 文字显示速度 |
| dialogue_timeout | 30.0s | 10.0–60.0 | 对话超时时间 |
| affinity_decay_rate | 0.0 | 0.0–1.0 | 好感度衰减率（每天） |

## Visual/Audio Requirements

- 对话框 UI（头像 + 文字 + 选项）
- NPC 头像（不同表情）
- 对话音效（打字机声/选择声）

## UI Requirements

- 对话框 UI（底部居中）
- 选项列表（垂直排列）
- NPC 名称和头像显示

## Acceptance Criteria

- GIVEN 玩家靠近 NPC，WHEN 按交互键，THEN 启动对话并显示对话框
- GIVEN 对话进行中，WHEN 玩家选择选项，THEN 执行对应分支和效果
- GIVEN 对话有好感度效果，WHEN 选择选项，THEN 好感度正确更新
- GIVEN 对话结束，WHEN 关闭对话框，THEN 恢复正常移动
- GIVEN NPC 正在移动，WHEN 触发对话，THEN NPC 停止移动

## Open Questions

- 是否使用 Dialogic 插件还是自研对话系统
- NPC 头像的美术风格需要确认
