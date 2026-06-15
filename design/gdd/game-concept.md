# Game Concept: 《命》—— 人生全知模拟器

*Created: 2026-06-15*
*Status: Draft*

---

## Elevator Pitch

> 这是一款人生模拟游戏，你在星露谷式的 2.5D 小镇中「过人生」而非「读人生」——操控角色从童年到老年，亲眼见证 6 个童年伙伴的多种平行命运，通过「命运全景图」看到所有可能的人生分支，最终在全知之后做出属于自己的人生选择。
>
> **10 秒测试**：你出生在一个中国小镇，度过一生。每玩一次，你看到不同的人生。玩够了，你才知道自己想活成什么样。

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | 人生模拟 / 叙事体验 / 哲学思考 |
| **Platform** | PC / 移动端 / 主机 |
| **Target Audience** | 对人生有思考的人、经历过迷茫的年轻人、喜欢叙事类游戏的玩家 |
| **Player Count** | 单人 |
| **Session Length** | 30-60 分钟（单次人生）/ 10-20 小时（完整体验） |
| **Monetization** | 买断制（Premium） |
| **Estimated Scope** | Large（6-12 个月，独立开发） |
| **Comparable Titles** | 中国式家长、To the Moon、Stardew Valley |

---

## Core Fantasy

**「当你看遍了所有的人生，你才真正知道自己想活成什么样。」**

玩家获得的不是权力幻想，而是一种**理解命运的平静**。你不是在「赢」人生，你是在「看见」人生——看见富裕家庭的空虚、贫困家庭的充实、努力一辈子的平凡、不努力的衣食无忧。当你看遍了所有可能的路，你不再恐惧未来，因为你知道无论走哪条路，都有人走过。而你唯一能做的，就是选择一条路，然后走下去——不是因为它最好，而是因为它是你的。

**这个核心幻想在其他游戏中找不到**：没有同类游戏让玩家通过多周目体验不同人生来「理解命运」。

---

## Unique Hook

> **像中国式家长，AND ALSO 你能看到所有人生的可能性——包括你没走的那条路。**

- **中国式家长**做了人生节点选择，但你只能看到自己走的那条路
- **To the Moon**做了情感叙事，但你是旁观者而非亲历者
- **Stardew Valley**做了小镇生活，但没有命运分层和多周目全景

《命》的独特之处：**命运全景图**——一个能让你看到「如果当时选了另一条路会怎样」的系统。这不是简单的分支叙事，而是一个完整的命运可视化系统，让你看到自己和伙伴们的所有可能人生。

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Narrative** (drama, story arc) | 1 | 多周目人生叙事、NPC 平行命运、命运之书 |
| **Discovery** (exploration, secrets) | 2 | 小镇探索、隐藏事件、NPC 秘密、命运分支 |
| **Fantasy** (make-believe, role-playing) | 3 | 代入不同出身、体验不同人生、理解命运 |
| **Fellowship** (social connection) | 4 | 与 6 个童年伙伴的情感连接、见证他们的命运 |
| **Sensation** (sensory pleasure) | 5 | 暖色调扁平手绘、钢琴 BGM、环境音 |
| **Challenge** (obstacle course, mastery) | 6 | 高考小游戏、人生选择的「重量感」 |
| **Submission** (relaxation, comfort zone) | 7 | 小镇漫步、日常生活的节奏感 |
| **Expression** (self-expression, creativity) | N/A | 不是重点——游戏是关于理解而非表达 |

### Key Dynamics (Emergent player behaviors)

1. **探索与发现**：玩家在小镇中主动探索，发现隐藏的 NPC 位置、触发条件、事件分支
2. **情感投射**：玩家将自身经历投射到角色和 NPC 身上，产生共鸣
3. **比较与反思**：多周目后，玩家自然开始比较不同人生，反思自己的选择
4. **分享与讨论**：玩家会分享「我的人生」和「伙伴的命运」，引发讨论

### Core Mechanics (Systems we build)

1. **小镇生活系统**：角色移动、NPC 日程、场景交互、事件触发
2. **人生节点系统**：关键事件、选择分支、数值变化、年龄推进
3. **命运系统**：六大数值、命运之骰、命运之书、命运全景图、全知模式
4. **NPC 平行人生系统**：6 个伙伴的多版本人生线、好感度、遇到方式
5. **时间系统**：日内时间（实时流逝）+ 人生年龄（节点推进）

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | 人生节点的自主选择、小镇自由探索、多周目不同人生 | Core |
| **Competence** (mastery, skill growth) | 从「不知道命运」到「理解命运」到「选择命运」的认知成长 | Core |
| **Relatedness** (connection, belonging) | 与 6 个童年伙伴的情感连接、见证他们的命运、代入自身经历 | Core |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Explorers** (discovery, understanding systems, finding secrets) — 小镇探索、隐藏事件、命运分支、NPC 秘密
- [x] **Socializers** (relationships, cooperation, community) — 与 NPC 的情感连接、见证伙伴命运、分享人生故事
- [ ] **Achievers** (goal completion, collection, progression) — 次要吸引力：解锁全知模式维度、收集不同结局
- [ ] **Killers/Competitors** (domination, PvP, leaderboards) — 不适用

### Flow State Design

- **Onboarding curve**：序章「混沌」→ 命运之骰出生 → 童年自由探索（无压力学习移动和交互）
- **难度 scaling**：不追求操作难度，而是「选择的重量感」随年龄增长而加重
- **Feedback clarity**：数值变化可视化、NPC 反应变化、命运之书记录
- **Recovery from failure**：没有 Game Over——人生继续，每个选择都有后果但不是惩罚

---

## Core Loop

### Moment-to-Moment (30 seconds)

在小镇中走动，接近 NPC 或场景入口，按互动键触发对话/事件。

**核心乐趣**：探索与发现的惊喜——NPC 在不同时间出现在不同位置，每天都有新发现。

### Short-Term (5-15 minutes)

一个「游戏日」（3-5 分钟现实时间）：早晨醒来 → 自由行动（去学校/找伙伴/去集市）→ 遇 NPC → 触发事件 → 做选择 → 数值变化 → 夜晚回家睡觉。

**「再来一天」的心理**：NPC 日程表保证每天都有不同的遇见机会。

### Session-Level (30-120 minutes)

一次完整人生：出生（命运之骰）→ 童年关键日（7、12 岁）→ 少年关键日（15、18 岁高考）→ 18 岁「未完待续」。

**自然停止点**：每个关键日结束时。**离开后的牵挂**：「如果当时选了另一条路会怎样？」

### Long-Term Progression

- **单次人生**：从出生到 18 岁，见证一条人生轨迹
- **多周目**：不同出身 + 不同选择 = 看到不同版本的小镇和伙伴
- **全知模式**：解锁 5 个维度（出身/性别/伙伴/结局/选择），最终看到完整命运全景

### Retention Hooks

- **Curiosity**：「如果当时选了另一条路会怎样？」——命运全景图的诱惑
- **Investment**：6 个伙伴的多版本人生——想看到他们所有可能的命运
- **Mastery**：从「不知道命运」到「理解命运」的认知成长——不是操作 mastery，而是人生 mastery

---

## Game Pillars

### Pillar 1: 真实大于戏剧

用真实的细节打动人，用平淡的叙述讲述人生，让玩家自己去感受，而不是被告知该怎么感受。

*Design test*：如果我们纠结于「这个事件要不要更戏剧化」，这个支柱说——选择更真实、更克制的那个。

### Pillar 2: 没有好坏，只有不同

每种人生都有价值和遗憾，平凡不是失败，富贵不是成功。去掉好坏标签，只描述「不同」。

*Design test*：如果我们纠结于「这个结局是好是坏」，这个支柱说——去掉好坏标签，只描述「不同」。

### Pillar 3: 见证者，非英雄

玩家不是拯救世界的英雄，而是见证无数人生后理解自己命运的普通人。

*Design test*：如果我们纠结于「要不要给玩家更多超能力/特殊待遇」，这个支柱说——不，你就是普通人。

### Pillar 4: 小镇是情感锚点

乡村/小镇是贯穿全游戏的情感核心，城市是拼搏场但不是归宿。

*Design test*：如果我们纠结于「要不要做更大的城市地图」，这个支柱说——把资源花在丰富小镇上。

### Pillar 5: 多周目见全貌

单次人生只看到冰山一角，真正的理解来自多周目体验不同人生。

*Design test*：如果我们纠结于「单次人生内容够不够」，这个支柱说——单次可以短，但多周目必须有新发现。

### Anti-Pillars (What This Game Is NOT)

- **NOT 爽文逆袭**：违反「真实大于戏剧」和「没有好坏」——不做「努力就能成功」的幻想
- **NOT 种田/钓鱼养成**：违反「小镇是情感锚点」——养成系统会抢走叙事重心
- **NOT 善恶二元系统**：违反「没有好坏」——道德评分会让玩家追求「最优解」
- **NOT 开放世界探索**：违反「多周目见全貌」——开放世界会稀释叙事密度
- **NOT 被动阅读体验**：违反「见证者」——必须有「在场感」，不能只是读文字做选择

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| **中国式家长** | 人生节点选择、数值系统、多周目 | 从「选择题」升级为「在场体验」；加入命运全景图 | 验证了「人生模拟 + 多周目」的市场 |
| **To the Moon** | 情感叙事、克制的表达、哲学深度 | 从「旁观者」变为「亲历者」；加入多周目全景 | 验证了「情感叙事」的市场 |
| **Stardew Valley** | 小镇生活、NPC 日程、探索发现 | 从「养成」转向「叙事」；加入命运系统 | 验证了「小镇生活」的沉浸感 |
| **Hades** | 多周目叙事、每次死亡解锁新对话 | 从「战斗」转向「人生」；命运全景图替代死亡重来 | 验证了「多周目叙事」的可行性 |

**Non-game inspirations**：
- **《活着》（余华）**：平凡人生的哲学深度、克制的情感表达
- **《楚门的世界》**：从「被观看」到「观看」的视角转换
- **《土拨鼠之日》**：重复中发现新意义的多周目哲学
- **中国小镇生活**：老槐树、小卖部、车站——真实的空间情感符号

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 18-35 |
| **Gaming experience** | 休闲到中核——玩过中国式家长、Stardew Valley、To the Moon |
| **Time availability** | 30-60 分钟单次人生，周末可以多玩几轮 |
| **Platform preference** | PC（Steam）为主，移动端为辅 |
| **Current games they play** | 中国式家长、Stardew Valley、To the Moon、塞尔达 |
| **What they're looking for** | 对人生有思考、经历过迷茫、想要在游戏中找到共鸣和理解 |
| **What would turn them away** | 过度戏剧化、说教、操作门槛高、内容空洞 |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | Godot 4.5（GDScript）——开源免费、2D 支持优秀、社区活跃、适合独立开发 |
| **Key Technical Challenges** | 命运全景图的回溯演算、NPC 多版本人生的状态管理、数据驱动架构 |
| **Art Style** | 扁平手绘 2.5D、暖色调、AI 生成（即梦/可灵/通义） |
| **Art Pipeline Complexity** | Medium——AI 生成降低了成本，但需要风格一致性管理 |
| **Audio Needs** | Moderate——钢琴 BGM、环境音、交互音效 |
| **Networking** | None——纯单人体验 |
| **Content Volume** | MVP：1 小镇、30-40 事件、2 伙伴；完整版：3 层地图、222+ 事件、10 NPC |
| **Procedural Systems** | 无——全部内容手写 + 数据驱动 |

---

## Risks and Open Questions

### Design Risks
- **多周目重复感**：如果不同人生之间的差异不够大，玩家会觉得「又玩了一遍」
- **小镇生活与命运选择割裂**：如果两层玩法没有有机融合，会感觉像两个游戏
- **哲学说教**：如果表达太直白，会变成「鸡汤游戏」而非真正的共鸣

### Technical Risks
- **命运全景图回溯演算**：需要回溯所有选择分支，技术难度高（⭐⭐⭐⭐）
- **NPC 多版本人生状态管理**：6 个伙伴 × 多版本人生 × 好感度 × 遇到方式，状态空间巨大
- **数据驱动架构**：222+ 事件、10 NPC 人生线、10 种结局全部 JSON 定义，数据结构设计是地基

### Market Risks
- **首个游戏 + 几个月时间线**：设计非常完整，但执行风险高
- **目标用户窄**：「对人生有思考的人」是小众但忠诚的群体
- **AI 美术一致性**：AI 生成的扁平手绘风格能否保持一致？

### Scope Risks
- **设计文档 vs 开发能力**：21 份设计文档覆盖了完整游戏，但 MVP 需要严格控制范围
- **MVP 验证问题**：30-40 个事件够不够撑住 0-18 岁？需要原型验证

### Open Questions
- **命运全景图的技术实现**：能否用决策树 + 数据回溯实现？还是需要降级为静态展示？
- **NPC 多版本人生的切换机制**：同一周目内看到伙伴的「不同命运版本」是否可行？
- **AI 美术的工作流**：如何保证 10 个 NPC + 多版本变体的风格一致性？

---

## MVP Definition

**核心假设**：「在小镇中走动遇伙伴、触发事件、做人生选择」这个核心循环是有趣的，玩家会想再玩一次看不同命运。

**MVP 必须包含**：
1. 小镇地图（家 + 学校 + 老槐树 + 小卖部 + 2 个伙伴家）
2. 角色操控（童年/少年 2 个 sprite，四方向行走 + 交互）
3. 2 个 NPC 伙伴（小刚、小芳）+ 父母 + 1 个老师
4. 30-40 个核心事件（从 222 个中精选，覆盖 0-18 岁）
5. 高考小游戏（1 个）
6. 六大数值系统 + 命运之骰
7. 基础命运之书（关键事件 + 数值记录）

**MVP 不包含**（延后到完整版）：
- 命运全景图（M3）
- 全知模式（M3）
- 城市场景（M2）
- 其他 4 种出身（M2）
- 其他 8 个 NPC（M2）
- 其他 8 个小游戏（M2）

### Scope Tiers

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 1 小镇、1 出身、2 伙伴、30-40 事件 | 核心循环（移动+交互+事件+数值+高考） | 8-12 周 |
| **Vertical Slice** | MVP + 完整童年到 18 岁体验 | + 命运之书 + 基础存档 | 12-16 周 |
| **Alpha** | 3 层地图、3 出身、6 伙伴、100+ 事件 | + 命运全景图 + 全知模式 + 城市场景 | 20-30 周 |
| **Full Vision** | 完整内容：222+ 事件、10 NPC、6 出身、9 小游戏 | 全部系统、AI 美术成品、Spine 动画 | 40-52 周 |

---

## Visual Identity Anchor

**视觉方向**：暖色调扁平手绘 2.5D

- **视觉规则**：所有画面都要有「绘本质感」——像翻开一本温暖的人生绘本
- **色彩哲学**：童年暖黄 → 少年浅绿 → 青年深蓝 → 中年深灰 → 老年暖灰
- **核心色板**：米暖白 `#F5EFE0`、浅卡其 `#E8DCC4`、深棕灰 `#3D3530`、暖橙棕 `#C97B4A`、雾霾蓝 `#6B8E9E`、灰绿 `#8FA96B`
- **角色设计**：主角无明确五官（代入感），NPC 有特征（辨识度）
- **场景设计**：多层（地面/物体/前景）+ 窗户光影符号 + 老槐树作为情感锚点

---

## Next Steps

- [ ] 运行 `/setup-engine` 配置 Godot 4.5 引擎
- [ ] 运行 `/art-bible` 创建视觉身份规范
- [ ] 使用 `/design-review design/gdd/game-concept.md` 验证概念完整性
- [ ] 使用 `/map-systems` 将概念分解为独立系统
- [ ] 使用 `/design-system` 为每个系统编写 GDD
- [ ] 使用 `/create-architecture` 制定技术架构
- [ ] 使用 `/architecture-review` 验证架构覆盖度
- [ ] 使用 `/gate-check` 验证进入下一阶段的准备情况
