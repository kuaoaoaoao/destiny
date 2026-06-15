# Systems Index: 《命》—— 人生全知模拟器

> **Status**: Draft
> **Created**: 2026-06-15
> **Last Updated**: 2026-06-15
> **Source Concept**: design/gdd/game-concept.md

---

## Overview

《命》是一款人生模拟游戏，在星露谷式的 2.5D 小镇中「过人生」。游戏需要 16 个系统来支撑核心循环：在小镇中走动 → 遇 NPC → 触发事件 → 做选择 → 数值变化 → 推进人生。系统的依赖关系清晰（无循环依赖），但「时间系统」和「事件引擎」是高风险瓶颈——分别被 5 个系统依赖。

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | 玩家控制系统 | 基础 | MVP | Designed | [player-control-system.md](player-control-system.md) | — |
| 2 | 时间系统 | 基础 | MVP | Designed | [time-system.md](time-system.md) | — |
| 3 | 场景管理系统 | 基础 | MVP | Designed | [scene-management-system.md](scene-management-system.md) | — |
| 4 | 事件引擎 | 核心 | MVP | Designed | [event-engine.md](event-engine.md) | 时间系统 |
| 5 | NPC 日程系统 | 核心 | MVP | Designed | [npc-schedule-system.md](npc-schedule-system.md) | 时间系统, 场景管理系统 |
| 6 | 对话系统 | 核心 | MVP | Designed | [dialogue-system.md](dialogue-system.md) | 事件引擎, NPC 日程系统 |
| 7 | 小镇生活系统 | 核心 | MVP | Designed | [town-life-system.md](town-life-system.md) | 玩家控制系统, 场景管理系统, NPC 日程系统, 事件引擎 |
| 8 | 命运系统 | 功能 | MVP | Designed | [fate-system.md](fate-system.md) | 人生节点系统, 事件引擎 |
| 9 | 人生节点系统 | 功能 | MVP | Designed | [life-node-system.md](life-node-system.md) | 事件引擎, 时间系统, 对话系统 |
| 10 | NPC 平行人生系统 | 功能 | MVP | Designed | [npc-parallel-life-system.md](npc-parallel-life-system.md) | NPC 日程系统, 对话系统, 命运系统 |
| 11 | 存档系统 | 核心 | MVP | Designed | [save-system.md](save-system.md) | 命运系统, NPC 平行人生系统 |
| 12 | 小游戏框架 | 功能 | MVP | Designed | [minigame-framework.md](minigame-framework.md) | 场景管理系统, 命运系统 |
| 13 | HUD 系统 | 展示 | MVP | Designed | [hud-system.md](hud-system.md) | 时间系统, 玩家控制系统, 场景管理系统 |
| 14 | 对话框 UI | 展示 | MVP | Designed | [dialogue-box-ui.md](dialogue-box-ui.md) | 对话系统 |
| 15 | 数值面板 UI | 展示 | MVP | Designed | [stats-panel-ui.md](stats-panel-ui.md) | 命运系统 |
| 16 | 命运之书 UI | 展示 | MVP | Designed | [fate-book-ui.md](fate-book-ui.md) | 命运系统, 人生节点系统 |

---

## Categories

| Category | Description | Typical Systems |
|----------|-------------|-----------------|
| **基础** | 零依赖的基础框架 | 玩家控制、时间、场景管理 |
| **核心** | 驱动核心循环的系统 | 事件引擎、NPC 日程、小镇生活、对话 |
| **功能** | 游戏特色功能 | 命运系统、人生节点、NPC 平行人生、小游戏 |
| **展示** | UI 和信息展示 | HUD、对话框、数值面板、命运之书 |

---

## Priority Tiers

| Tier | Definition | Target Milestone | Design Urgency |
|------|------------|------------------|----------------|
| **MVP** | 核心循环运转所需的系统。没有这些，无法测试「好不好玩」 | 首个可玩原型 | 设计优先 |
| **Vertical Slice** | 一个完整、打磨过的体验所需的系统 | 垂直切片 / Demo | 设计第二 |
| **Alpha** | 所有功能粗略存在。完整的机制范围，占位内容可接受 | Alpha 里程碑 | 设计第三 |
| **Full Vision** | 打磨、边界情况、锦上添花、内容完整的功能 | Beta / 发布 | 按需设计 |

---

## Dependency Map

### Foundation Layer (no dependencies)

1. **玩家控制系统** — 角色移动和交互输入，30 秒循环的基础
2. **时间系统** — 日内时间 + 人生年龄，驱动整个世界的节奏
3. **场景管理系统** — 室内外切换、地图加载，世界的空间框架

### Core Layer (depends on foundation)

1. **事件引擎** — depends on: 时间系统 — 30-40 个事件的触发、条件检查、执行
2. **NPC 日程系统** — depends on: 时间系统, 场景管理系统 — NPC 按时间出现在不同位置
3. **对话系统** — depends on: 事件引擎, NPC 日程系统 — NPC 对话和事件选择
4. **小镇生活系统** — depends on: 玩家控制系统, 场景管理系统, NPC 日程系统, 事件引擎 — 30 秒循环的核心
5. **存档系统** — depends on: 命运系统, NPC 平行人生系统 — 多周目体验的持久化

### Feature Layer (depends on core)

1. **命运系统** — depends on: 人生节点系统, 事件引擎 — 六大数值 + 命运之骰
2. **人生节点系统** — depends on: 事件引擎, 时间系统, 对话系统 — 关键事件和选择分支
3. **NPC 平行人生系统** — depends on: NPC 日程系统, 对话系统, 命运系统 — 6 个伙伴的多版本人生
4. **小游戏框架** — depends on: 场景管理系统, 命运系统 — 高考等小游戏

### Presentation Layer (depends on features)

1. **HUD 系统** — depends on: 时间系统, 玩家控制系统, 场景管理系统 — 基础信息展示
2. **对话框 UI** — depends on: 对话系统 — NPC 对话界面
3. **数值面板 UI** — depends on: 命运系统 — 六大数值可视化
4. **命运之书 UI** — depends on: 命运系统, 人生节点系统 — 人生回忆录

---

## Recommended Design Order

| Order | System | Priority | Layer | Est. Effort |
|-------|--------|----------|-------|-------------|
| 1 | 玩家控制系统 | MVP | Foundation | S |
| 2 | 时间系统 | MVP | Foundation | M |
| 3 | 场景管理系统 | MVP | Foundation | M |
| 4 | 事件引擎 | MVP | Core | L |
| 5 | NPC 日程系统 | MVP | Core | M |
| 6 | 对话系统 | MVP | Core | M |
| 7 | 小镇生活系统 | MVP | Core | L |
| 8 | 命运系统 | MVP | Feature | L |
| 9 | 人生节点系统 | MVP | Feature | M |
| 10 | NPC 平行人生系统 | MVP | Feature | L |
| 11 | 存档系统 | MVP | Core | M |
| 12 | 小游戏框架 | MVP | Feature | M |
| 13 | HUD 系统 | MVP | Presentation | S |
| 14 | 对话框 UI | MVP | Presentation | S |
| 15 | 数值面板 UI | MVP | Presentation | S |
| 16 | 命运之书 UI | MVP | Presentation | S |

[Effort estimates: S = 1 session, M = 2-3 sessions, L = 4+ sessions]

---

## Circular Dependencies

- **None found** — dependency graph is a directed acyclic graph (DAG).

**Note**: 命运系统 and 人生节点系统 have a **bidirectional data flow** (not a circular dependency):
- 人生节点系统 triggers events → changes six values → updates 命运系统
- 命运系统 provides value state → affects 人生节点 options and consequences
- **Resolution**: Clear interface contract — 人生节点 modifies values via event engine, 命运系统 provides query interface.

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|--------|-----------|-----------------|------------|
| 时间系统 | Technical | 被 5 个系统依赖——如果设计错误，影响面巨大 | 先设计，先实现，先测试 |
| 事件引擎 | Technical | 被 5 个系统依赖——数据驱动架构的地基，数据结构设计是关键 | 先定义数据结构规范，再实现引擎 |
| 命运全景图 | Technical | 需要回溯所有选择分支，技术难度高（⭐⭐⭐⭐） | Alpha 阶段预研，最坏降级为静态展示 |
| NPC 平行人生系统 | Design | 6 伙伴 × 多版本 × 好感度 × 遇到方式，状态空间巨大 | MVP 只做 2 个伙伴验证可行性 |
| 命运系统 | Design | 六大数值的平衡和感知——数值变化需要让玩家「感受到」 | 原型测试数值反馈 |

---

## Progress Tracker

| Metric | Count |
|--------|-------|
| Total systems identified | 16 |
| Design docs started | 16 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 16/16 |
| Vertical Slice systems designed | 0/16 |

---

## Next Steps

- [ ] Review and approve this systems enumeration
- [ ] Design MVP-tier systems first (use `/design-system [system-name]`)
- [ ] Run `/design-review` on each completed GDD
- [ ] Run `/gate-check pre-production` when MVP systems are designed
- [ ] Validate the highest-risk systems with `/vertical-slice` before committing to Production
