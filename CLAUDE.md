# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

**《命》** —— 人生全知模拟器。一款 2.5D 小镇生活 + 多周目命运全景的人生模拟游戏，使用 Godot 4.6.3 + GDScript + C# 开发。

## 开发框架

本项目使用 **Claude Code Game Studios (CCGS)** 框架管理开发：
- **49 个协调子代理**：分工明确的专业代理团队
- **73 个技能命令**：覆盖完整开发流程
- **12 个自动化钩子**：提交、推送、资产变更时自动验证

### 关键代理

| 代理 | 职责 |
|------|------|
| `godot-specialist` | Godot 引擎权威，GDScript 最佳实践 |
| `godot-gdscript-specialist` | GDScript 代码质量和模式 |
| `game-designer` | 游戏设计和机制 |
| `narrative-director` | 叙事设计和故事 |
| `art-director` | 美术方向和风格 |
| `technical-artist` | 技术美术和着色器 |
| `gameplay-programmer` | 游戏玩法编程 |
| `ui-programmer` | UI 编程 |
| `level-designer` | 关卡设计 |
| `world-builder` | 世界构建 |

### 关键命令

```bash
/start          # 开始引导式入门
/help           # 获取帮助
/brainstorm     # 头脑风暴
/setup-engine   # 设置引擎
/map-systems    # 映射系统
/create-epics   # 创建史诗
/create-stories # 创建故事
/dev-story      # 开发故事
/story-done     # 故事完成
/gate-check     # 阶段检查
/code-review    # 代码审查
```

## 项目结构

```
destinyDemo/
├── .claude/                # CCGS 框架配置
│   ├── agents/             # 49 个专业代理
│   ├── skills/             # 73 个技能命令
│   ├── hooks/              # 12 个自动化钩子
│   ├── rules/              # 11 个编码规则
│   └── settings.json       # 框架设置
├── production/             # 生产阶段管理
│   └── stage.txt           # 当前阶段
├── design/                 # 游戏设计文档（18 份）
├── assets/                 # 游戏素材资源
├── data/                   # 数据驱动文件
├── scripts/                # GDScript 脚本
├── scenes/                 # Godot 场景
└── docs/                   # CCGS 文档
```

## 设计文档导航

**14、15 号文档是 v0.3 最新纲领，开发以这两份为准。**

| 优先级 | 文档 | 内容 |
|--------|------|------|
| ⭐ 最高 | `14-玩法转向与小镇系统设计.md` | v0.3 核心纲领 |
| ⭐ 最高 | `15-NPC伙伴与多线故事设计.md` | NPC 多版本人生系统 |
| ⭐ 高 | `17-场景制作与TileMap拼装工作流.md` | 地砖+物件素材包工作流 |
| ⭐ 高 | `16-AI美术素材生成规范.md` | AI 美术生成规范 |

## 核心设计要点

### 玩法架构（v0.3 转向）

- **表现形式**：星露谷式 2.5D 小镇生活
- **不变的内核**：六大数值、命运之骰、命运之书、命运全景图、全知模式、多结局
- **三层舞台**：乡村（出生地）→ 小镇（社交中心）→ 城市（拼搏战场）

### 美术方向

- **风格**：暖色调扁平手绘插画，2.5D 俯视斜 45° 透视
- **生成工具**：即梦/可灵/通义/Midjourney
- **场景**：AI 生成地砖+物件素材包，在 Godot TileMap 中拼装
- **色板**：米暖白 `#F5EFE0`、浅卡其 `#E8DCC4`、深棕灰 `#3D3530`、暖橙棕 `#C97B4A`、雾霾蓝 `#6B8E9E`、灰绿 `#8FA96B`

## 技术架构

- **引擎**：Godot 4.6.3
- **语言**：GDScript（游戏/UI 脚本），C#（性能关键系统），C++ via GDExtension（仅原生插件）
- **构建系统**：.NET SDK + Godot Export Templates
- **资产管线**：Godot Import System + 自定义资源管线
- **地图系统**：TileMap + TileSet，地砖 48×48 像素
- **角色系统**：CharacterBody2D
- **数据驱动**：事件/NPC/出身/结局使用 JSON 数据结构
- **全局系统**：Autoload 单例

## Engine Version Reference

@docs/engine-reference/godot/VERSION.md

## 开发阶段

当前阶段：`concept`（概念阶段）

### 阶段流程

1. **Concept** - 概念定义
2. **Systems Design** - 系统设计
3. **Technical Setup** - 技术设置
4. **Pre-Production** - 预生产
5. **Production** - 生产
6. **Polish** - 打磨
7. **Release** - 发布

## 注意事项

- 使用 CCGS 框架的 `/start` 命令开始引导式开发
- 使用 `/help` 获取当前阶段的下一步指导
- 使用 `/gate-check` 检查是否满足进入下一阶段的条件
- 所有代码变更需要通过 `/code-review` 验证
- 设计文档中 `14` 和 `15` 号是最新纲领
