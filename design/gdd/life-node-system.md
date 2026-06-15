# 人生节点系统

> **Status**: Designed
> **Author**: Claude + User
> **Last Updated**: 2026-06-15
> **Implements Pillar**: Pillar 2（没有好坏，只有不同）— 每个选择都是不同的路

## Overview

**人生节点系统**是游戏的功能层，负责管理人生中的关键事件和选择分支。它是人生的「分叉点」——每个节点都是一次重大选择，影响后续人生轨迹。

**技术层面**：管理人生节点（Life Node）的触发、选择和后果。节点在特定年龄触发，提供 2-4 个选项，每个选项有不同的数值效果和后续影响。

**玩家体验层面**：玩家在人生节点做出重大选择——高考志愿、第一份工作、婚姻决定。每个选择都有重量，影响后续人生。

**核心设计原则**：节点选择应该「两难」——没有明显的「最优解」，每个选项都有代价和收获。

## Player Fantasy

**「这是我的人生选择。」**

玩家在人生节点做选择时，应该感到这个选择真的重要——它会影响后续的人生轨迹，影响 NPC 的命运，影响最终结局。选择不是「对错」，是「取舍」。

**支柱服务**：直接服务 Pillar 2（没有好坏，只有不同）— 每个选择都是不同的路，没有好坏之分。

## Detailed Design

### Core Rules

**1. 人生节点定义**

```json
{
  "node_id": "college_major",
  "name": "高考志愿",
  "trigger_age": 18,
  "options": [
    {
      "text": "报考重点大学",
      "effects": {"education": 20, "psychology": -10, "money": -15},
      "consequences": ["university_path"]
    },
    {
      "text": "报考普通大学",
      "effects": {"education": 10, "psychology": 5, "money": -5},
      "consequences": ["community_path"]
    },
    {
      "text": "直接工作",
      "effects": {"education": 0, "psychology": -5, "money": 15},
      "consequences": ["work_path"]
    }
  ]
}
```

**2. 节点触发规则**
- 节点在特定年龄自动触发
- 触发时暂停游戏，显示选择界面
- 玩家选择后应用效果，继续游戏
- 节点选择不可撤销

**3. 节点类型**

| 类型 | 说明 | 示例 |
|------|------|------|
| **教育节点** | 升学/专业选择 | 高考志愿、考研 |
| **职业节点** | 工作选择 | 第一份工作、跳槽 |
| **关系节点** | 人际关系选择 | 相亲、结婚 |
| **家庭节点** | 家庭事件 | 父母生病、生孩子 |

### Interactions with Other Systems

| 系统 | 数据流向 | 接口 |
|------|---------|------|
| **时间系统** ← | 当前年龄 → 节点触发 | 信号：`age_reached(age)` |
| **事件引擎** ← | 节点事件 → 事件执行 | 调用接口：`trigger_life_node(node_id)` |
| **命运系统** ← | 选择效果 → 数值修改 | 调用接口：`modify_stats(effects)` |
| **对话系统** ← | 节点对话 → 选择界面 | 传递选择数据 |
| **NPC 平行人生系统** ← | 选择结果 → 伙伴命运 | 信号：`life_choice_made(node_id, choice)` |

## Formulas

节点效果公式：
`stat_after_node = clamp(stat_before + choice_effects, 0, 100)`

## Edge Cases

- **如果节点触发时玩家正在对话中**：排队等待，对话结束后触发
- **如果节点有前置条件未满足**：跳过该节点，使用默认选项
- **如果节点选择导致数值溢出**：限制在 0-100 范围
- **如果节点选择影响 NPC 命运**：通知 NPC 平行人生系统更新

## Dependencies

依赖：
- **时间系统**：查询当前年龄
- **事件引擎**：触发节点事件
- **对话系统**：显示选择界面

被以下系统依赖：
- **命运系统**：接收节点效果
- **NPC 平行人生系统**：接收选择结果
- **命运之书 UI**：记录节点选择

## Tuning Knobs

| 旋钮 | 默认值 | 范围 | 说明 |
|------|--------|------|------|
| node_display_duration | 0.0s | — | 节点显示直到选择（无超时） |
| choice_confirmation | true | — | 选择后需要确认 |

## Visual/Audio Requirements

- 节点触发时的特殊视觉效果
- 选择界面的 UI 设计
- 选择后的数值变化动画

## UI Requirements

- 人生节点选择界面（选项列表 + 后果预览）
- 节点历史记录

## Acceptance Criteria

- GIVEN 到达 18 岁，WHEN 年龄推进，THEN 触发高考志愿节点
- GIVEN 节点触发，WHEN 玩家选择选项，THEN 应用对应数值效果
- GIVEN 节点选择，WHEN 选择「报考重点大学」，THEN 教育 +20，心理 -10
- GIVEN 节点选择完成，WHEN 继续游戏，THEN 选择不可撤销

## Open Questions

- 节点选择的后果预览应该显示多少信息
- 节点之间的依赖关系如何设计
