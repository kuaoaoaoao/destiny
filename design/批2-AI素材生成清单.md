# 第二批 AI 素材生成清单（MVP 核心，直接复制可用）

> 📌 **前置条件**：第一批 3 张（小镇主图 + 主角童年立绘 + 小刚童年立绘）已生成且风格定调。
> 📋 **本批用途**：补齐 MVP（0-18岁垂直切片）所需的全部美术素材。
> 🔧 **核心原则**：复用第一批的 seed 和风格锚，保证风格统一。
> 🎨 **风格宪法**：详见 `16-AI美术素材生成规范.md`。

> ⚠️ **v0.3.2 重要更新**：本清单中**所有场景部分（P0-7 家客厅、P0-8 教室、P0-9 老槐树、P0-10 小卖部）已作废**，因为整张图无法当游戏地图用。
> 改为生成"地砖+物件素材包"，详见 **17 号文档 + 批3清单**。
> 本清单的**角色部分（P0-1 到 P0-6）和 CG/UI 部分（P0-11、P1-1 到 P1-4）仍然有效**。

---

## 通用风格锚（每张图都要带）

**中文版（加在每张提示词最前面）：**
```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材，
```

---

## 优先级说明

| 优先级 | 含义 | 数量 |
|--------|------|------|
| **P0** | MVP 必须有，没有游戏跑不起来 | 11 张/套 |
| **P1** | 锦上添花，可后补 | 4 张 |

---

# 🎯 P0 必做清单（11 张/套）

---

## 【P0-1】主角童年四方向行走图 ⭐最关键

**用途**：玩家操控主角在小镇走动的核心 sprite。
**方案**：MVP 用"四方向静帧"（不做逐帧动画，3 帧简易动画即可）。
**复用**：第一批主角童年立绘的 seed。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
角色设计参考表，同一个7岁中国乡村男孩的四方向视图，
横向四宫格排列，从左到右依次是：正面站立、背面站立、左侧面站立、右侧面站立，
每个都是标准站立姿势，瘦小身形，穿旧白T恤和蓝色短裤，布鞋，
面部背光处理没有清晰五官，柔和轮廓阴影,
暖黄暖橙色调，纯白色背景，横向四宫格布局
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
character design turnaround sheet, the same 7-year-old Chinese rural boy in four views,
horizontal four-panel layout, from left to right: front view, back view, left side view, right side view,
each in a standard standing pose, thin small build, old white T-shirt and blue shorts, cloth shoes,
face in soft shadow with no clear facial features, gentle silhouette,
warm yellow-orange tones, pure white background, horizontal four-panel grid --ar 16:9
```

**参数与技巧：**
- 比例：**16:9 横版**（四宫格）
- **务必复用第一批主角 seed**
- 拿到图后在 Aseprite/PS 里切成 4 个独立 sprite
- 每个方向再复制 2-3 帧做简单行走动画（抬腿/落腿）
- 如果 AI 给的四个方向不像同一人，强化："严格保证是同一个角色，服装发型完全一致"

---

## 【P0-2】主角少年立绘

**用途**：主角 13-18 岁形象。
**复用**：第一批主角 seed（"同一个人长大了"）。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
全身人物立绘，一个16岁的中国少年，偏瘦身形正在抽高，
双手插在宽大的蓝白校服口袋里，微微低头，穿帆布鞋，
面部背光处理，没有清晰五官，只有柔和的轮廓阴影,
情绪沉默迷茫，灰蓝色调（比童年稍冷），纯色背景，竖构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
full-body character portrait, a 16-year-old Chinese teenage boy, thin and lanky growing taller,
hands in the pockets of an oversized blue-and-white school uniform, head slightly down, canvas shoes,
face in soft shadow with no clear facial features, gentle silhouette,
silent and melancholic mood, slightly cooler gray-blue tones, solid color background, vertical composition --ar 2:3
```

**参数：** 比例 2:3 竖版，复用主角 seed

---

## 【P0-3】主角少年四方向行走图

**用途**：少年段操控 sprite。
**复用**：本批 P0-2 少年立绘的 seed。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
角色设计参考表，同一个16岁中国少年的四方向视图，
横向四宫格排列，从左到右依次是：正面、背面、左侧面、右侧面,
标准站立姿势，偏瘦身形，穿蓝白校服，帆布鞋,
面部背光处理没有清晰五官，纯白色背景，横向四宫格布局
```

**参数：** 16:9 横版四宫格，复用 P0-2 seed

---

## 【P0-4】小芳童年立绘

**用途**：青梅竹马小芳 7-12 岁。
**关键特征**：乖巧、马尾辫、酒窝、清秀。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
全身人物立绘，一个10岁的中国乡村女孩，
清秀乖巧，扎着马尾辫，脸颊有酒窝，温柔地微笑着,
穿着碎花连衣裙，脚踩布鞋，双手交叠在身前的文静站姿,
清晰的五官特征，暖黄暖橙色调，纯色背景，竖构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
full-body character portrait, a 10-year-old Chinese rural girl,
delicate and well-behaved, ponytail, dimples, gentle smile,
wearing a floral dress, cloth shoes, quiet standing pose with hands folded in front,
clear facial features, warm yellow-orange tones, solid color background, vertical composition --ar 2:3
```

**参数：** 2:3 竖版，**小芳 seed 必须记录**（后续 4 个版本复用）

---

## 【P0-5】妈妈立绘

**用途**：主角母亲，全程核心 NPC。
**关键特征**：中年妇女、疲惫、慈祥。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
全身人物立绘，一位40岁的中国农村妇女,
面容略显疲惫但眼神慈祥，头发简单扎起，穿着碎花衬衫和深色长裤，系着围裙,
双手在围裙上擦拭的朴素站姿,
清晰的五官特征，暖黄暖橙色调，纯色背景，竖构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
full-body character portrait, a 40-year-old Chinese rural woman,
slightly tired face but kind eyes, hair simply tied up, wearing a floral shirt and dark pants with an apron,
simple standing pose wiping hands on the apron,
clear facial features, warm yellow-orange tones, solid color background, vertical composition --ar 2:3
```

**参数：** 2:3 竖版，**妈妈 seed 记录**（中年患病/老年版本复用）

---

## 【P0-6】王老师立绘

**用途**：小学班主任，童年/少年引路人 NPC。
**关键特征**：中年女教师、戴眼镜、严厉而温柔。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
全身人物立绘，一位35岁的中国乡村小学女教师,
戴着一副细框眼镜，表情严肃中带着温柔，头发整齐盘起,
穿着朴素的深色职业装和白色衬衫，手里拿着一本教案,
双手持书的端正站姿，清晰的五官特征，暖黄暖橙色调，纯色背景，竖构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
full-body character portrait, a 35-year-old Chinese rural primary school female teacher,
thin-rimmed glasses, serious but gentle expression, hair neatly in a bun,
wearing a simple dark professional outfit and white shirt, holding a lesson plan,
upright standing pose holding the book, clear facial features, warm yellow-orange tones, solid color background, vertical composition --ar 2:3
```

**参数：** 2:3 竖版

---

## 【P0-7】场景：家·客厅（农村普通家庭）

**用途**：主角家室内，睡觉/家庭事件/父母对话。
**复用**：第一批小镇主图的透视风格（俯视斜45°）。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
2.5D俯视斜45度等距透视，中国乡村普通家庭的客厅室内,
旧布沙发、一张方桌、老式显像管电视、墙上贴着旧挂历和奖状,
一扇窗户透进暖黄的午后阳光，地上铺着旧瓷砖,
简陋但温馨整洁，暖黄色调，柔和平涂，绘本质感，留白
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
2.5D isometric top-down perspective, interior of a living room in an ordinary Chinese rural home,
old fabric sofa, a square table, old CRT TV, old calendar and merit certificates on the wall,
a window letting in warm yellow afternoon sunlight, old tiles on the floor,
simple but cozy and tidy, warm yellow tones, soft cel shading, storybook texture, negative space --ar 16:9
```

**参数：** 16:9 横版，记录 seed（后续少年/中年版本只换色调滤镜）

---

## 【P0-8】场景：学校教室

**用途**：童年/少年主场景，上课/考试/同学事件。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
2.5D俯视斜45度等距透视，中国乡村小学的教室,
整齐排列的旧木课桌椅，前面是黑板，黑板上写着"好好学习",
墙上挂着国旗，几扇高高的窗户透进光线,
压抑中带着希望的氛围，灰蓝色调（比家稍冷），柔和平涂，绘本质感
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
2.5D isometric top-down perspective, interior of a Chinese rural primary school classroom,
neatly arranged old wooden desks and chairs, a blackboard at the front with "Study Hard" written on it,
a national flag on the wall, several tall windows letting in light,
atmosphere of oppression mixed with hope, cooler gray-blue tones, soft cel shading, storybook texture --ar 16:9
```

**参数：** 16:9 横版

> 💡 **注意**：黑板上让 AI 写英文或留白，**中文字 AI 会写错**，后期 PS 手动加"好好学习"。

---

## 【P0-9】场景：老槐树特写

**用途**：核心情感符号，伙伴聚集地，贯穿全游戏。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
2.5D俯视斜45度等距透视，乡村小镇村口的一棵巨大的老槐树,
枝叶茂盛形成巨大的树冠，树下有一个旧秋千和一张石凳,
树干上刻着一些字迹斑驳的痕迹，树根盘错,
阳光透过树叶洒下斑驳光影，温暖怀旧的氛围，暖黄暖绿色调，柔和平涂
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
2.5D isometric top-down perspective, a giant old pagoda tree at the entrance of a rural town,
lush canopy forming a huge crown, an old swing and a stone bench under the tree,
faint carved marks on the trunk, intertwined roots,
dappled sunlight filtering through leaves, warm nostalgic atmosphere, warm yellow-green tones, soft cel shading --ar 16:9
```

**参数：** 16:9 横版，**这张图贯穿全游戏，要精心打磨**

---

## 【P0-10】场景：小卖部室内

**用途**：大壮家小卖部，买东西/打听消息/烟火气。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
2.5D俯视斜45度等距透视，中国乡村的一间老式小卖部内部,
木制货架上摆满各种零食饮料和日用品，一个老旧的玻璃柜台,
柜台后有一把竹椅，墙上挂着旧广告画,
充满烟火气的市井氛围，暖黄暖橙色调，柔和平涂，绘本质感
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
2.5D isometric top-down perspective, interior of an old-fashioned Chinese rural grocery store,
wooden shelves full of snacks, drinks and daily necessities, an old glass counter,
a bamboo chair behind the counter, old advertisement posters on the wall,
lively bustling market atmosphere, warm yellow-orange tones, soft cel shading, storybook texture --ar 16:9
```

**参数：** 16:9 横版

---

## 【P0-11】关键 CG：小刚告别

**用途**：MVP 最重要的情感爆发点，小刚 15 岁辍学去打工的告别场景。
**注意**：CG 视角自由（不一定是俯视），追求电影感构图。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
电影感构图，中国乡村小镇的简易汽车站，一个少年背着鼓鼓的编织袋正要登上破旧的中巴车,
另一个少年站在车下，两人远远对视，都没有说话,
背景是夕阳下的土路和远处的田野，长长的影子,
强烈的离别感和怅然若失，暖橙色夕阳色调，柔和平涂，绘本质感，16:9横构图,
人物没有清晰五官，用背影和姿态表达情绪
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
cinematic composition, a simple bus station in a Chinese rural town, a teenage boy with a bulging woven bag about to board an old minibus,
another teenage boy standing below the bus, the two looking at each other from a distance, neither speaking,
sunset over a dirt road with fields in the background, long shadows,
strong sense of parting and melancholy, warm orange sunset tones, soft cel shading, storybook texture --ar 16:9,
figures without clear facial features, emotions expressed through silhouettes and poses
```

**参数：** 16:9 横版，这张图值得多生成几次挑最好的

---

# 🎨 P1 锦上添花清单（4 张，可后补）

---

## 【P1-1】CG：序章·混沌

**用途**：游戏开场，建立基调。

### 完整提示词（中文）

```
扁平手绘插画，极简画面，纯黑背景中央有一个微弱的光点正在缓缓汇聚,
光点逐渐显现出一颗骰子的模糊轮廓,
大量黑暗留白，深邃神秘的氛围，绘本质感，16:9横构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, minimalist, pure black background with a faint point of light slowly gathering in the center,
the light gradually revealing the blurred outline of a die,
lots of dark negative space, profound mysterious atmosphere, storybook texture --ar 16:9
```

---

## 【P1-2】CG：命运之骰

**用途**：出生设定画面。

### 完整提示词（中文）

```
扁平手绘插画，一颗巨大的骰子悬浮在暖黄色的虚空中,
骰子的每一面隐约浮现不同的生活场景剪影：一间破旧的土屋、一间普通公寓、一栋宽敞的别墅,
强烈的命运感和宿命感，柔和暖光，绘本质感，16:9横构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, a giant die floating in warm yellow void,
each face of the die faintly showing silhouettes of different life scenes: a dilapidated earthen house, an ordinary apartment, a spacious villa,
strong sense of fate and destiny, soft warm light, storybook texture --ar 16:9
```

---

## 【P1-3】CG：高考考场

**用途**：少年期关键节点。

### 完整提示词（中文）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
中国高考考场，整齐排列的课桌，学生们低头奋笔疾书,
窗外是六月明亮的阳光，黑板上写着考试纪律,
压抑紧张又充满隐隐希望的氛围，灰蓝色调，柔和平涂，绘本质感，16:9横构图
```

### 完整提示词（英文）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline,
storybook art style, minimalist, Chinese countryside, cozy and warm,
a Chinese Gaokao exam room, neatly arranged desks, students writing furiously with heads down,
bright June sunlight outside the windows, exam rules on the blackboard,
atmosphere of tension mixed with faint hope, gray-blue tones, soft cel shading, storybook texture --ar 16:9
```

---

## 【P1-4】6 大数值图标

**用途**：HUD 数值显示。
**规格**：正方形，纯色背景便于抠图。

### 提示词（6 个，分别生成）

**💰 金钱：**
```
扁平手绘图标，一枚旧铜钱，暖棕色，极简线条，无背景，绘本质感，正方形构图，留白
```

**🧠 心理：**
```
扁平手绘图标，一个简笔画的粉红色大脑，极简线条，无背景，绘本质感，正方形构图，留白
```

**💪 健康：**
```
扁平手绘图标，一片绿色的叶子，极简线条，无背景，绘本质感，正方形构图，留白
```

**👥 社交：**
```
扁平手绘图标，两个并肩的小人剪影，暖棕色，极简线条，无背景，绘本质感，正方形构图，留白
```

**📚 教育：**
```
扁平手绘图标，一本翻开的书，暖棕色，极简线条，无背景，绘本质感，正方形构图，留白
```

**😊 幸福：**
```
扁平手绘图标，一个简笔画的暖黄色太阳笑脸，极简线条，无背景，绘本质感，正方形构图，留白
```

**英文版示例（金钱）：**
```
flat hand-drawn icon, an old copper coin, warm brown, minimalist lines, no background, storybook texture, square composition, negative space
```

---

# 📊 第二批总结表

| # | 素材 | 类型 | 比例 | 复用seed | 优先级 |
|---|------|------|------|---------|--------|
| 1 | 主角童年四方向行走图 | 角色 | 16:9 | 主角 | **P0** |
| 2 | 主角少年立绘 | 角色 | 2:3 | 主角 | **P0** |
| 3 | 主角少年四方向行走图 | 角色 | 16:9 | 少年 | **P0** |
| 4 | 小芳童年立绘 | 角色 | 2:3 | 小芳(新) | **P0** |
| 5 | 妈妈立绘 | 角色 | 2:3 | 妈妈(新) | **P0** |
| 6 | 王老师立绘 | 角色 | 2:3 | — | **P0** |
| 7 | 家·客厅 | 场景 | 16:9 | 小镇 | **P0** |
| 8 | 学校教室 | 场景 | 16:9 | 小镇 | **P0** |
| 9 | 老槐树特写 | 场景 | 16:9 | 小镇 | **P0** |
| 10 | 小卖部室内 | 场景 | 16:9 | 小镇 | **P0** |
| 11 | CG·小刚告别 | CG | 16:9 | — | **P0** |
| 12 | CG·序章混沌 | CG | 16:9 | — | P1 |
| 13 | CG·命运之骰 | CG | 16:9 | — | P1 |
| 14 | CG·高考考场 | CG | 16:9 | — | P1 |
| 15 | 6 大数值图标 | UI | 1:1 | — | P1 |

---

# ✅ 验收标准

## 角色一致性检查（最关键）

- [ ] **主角童年行走图 vs 第一批主角立绘**：是同一个人（服装、体形、发型一致）
- [ ] **主角少年立绘 vs 童年立绘**：能看出"是同一个人长大了"（脸型/气质延续）
- [ ] **小刚（第一批）vs 小芳/妈妈/王老师**：4 个 NPC 气质各不相同，能一眼区分
- [ ] **所有角色**：平涂无描边、暖色调、绘本质感统一

## 场景一致性检查

- [ ] **4 个室内场景 + 第一批小镇主图**：透视全部是"俯视斜 45°"
- [ ] **色调统一**：都是暖色调，童年阶段偏暖黄
- [ ] **风格统一**：平涂、留白、绘本质感

## CG 检查

- [ ] **小刚告别 CG**：人物是背影/无清晰五官，情绪到位，有电影感
- [ ] **3 张 CG**：构图有主体有留白，没有杂乱细节

---

# ⚠️ 常见问题速查

| 问题 | 解决 |
|------|------|
| 四方向行走图四个方向不像同一人 | 强化"严格保证是同一个角色，服装发型完全一致"，复用 seed |
| 主角少年太像成年人 | 强化"16岁少年，还带着稚气，正在抽高" |
| 小芳和小刚气质分不开 | 小芳强化"温柔文静、马尾辫、碎花裙"；小刚强化"调皮、蓬乱头发" |
| 室内场景透视变平视了 | 强化"严格2.5D俯视斜45度等距透视" |
| 黑板/招牌 AI 写错中文 | 让 AI 写英文或留白，PS 手动加中文 |
| CG 人物有清晰五官（主角） | 强化"人物面部背光，没有清晰五官，用背影和姿态表达" |
| 数值图标风格不统一 | 6 个图标用同一个 seed 或同一套提示词模板，统一加"极简线条" |

---

# 📝 第二批生成结果记录表

| # | 素材 | 工具 | seed | 文件名 | 满意度 | 备注 |
|---|------|------|------|--------|--------|------|
| 1 | 主角童年行走图 | | | char_player_child_walk.png | / | 切4帧 |
| 2 | 主角少年立绘 | | | char_player_teen.png | / | |
| 3 | 主角少年行走图 | | | char_player_teen_walk.png | / | 切4帧 |
| 4 | 小芳童年立绘 | | | char_xiaofang_child.png | / | 小芳seed |
| 5 | 妈妈立绘 | | | char_mom.png | / | 妈妈seed |
| 6 | 王老师立绘 | | | char_teacher_wang.png | / | |
| 7 | 家·客厅 | | | scene_home_living.png | / | |
| 8 | 学校教室 | | | scene_school_classroom.png | / | |
| 9 | 老槐树 | | | scene_old_tree.png | / | 贯穿全游戏 |
| 10 | 小卖部 | | | scene_store.png | / | |
| 11 | CG·小刚告别 | | | cg_farewell.png | / | 关键泪点 |
| 12 | CG·序章 | | | cg_prologue.png | / | |
| 13 | CG·骰子 | | | cg_dice.png | / | |
| 14 | CG·高考 | | | cg_gaokao.png | / | |
| 15 | 数值图标×6 | | | icon_stat_*.png | / | |

---

# 🎯 推荐生成顺序

**不要一口气全做完，分 3 轮：**

### 第 1 轮（验证一致性，半天）
- 主角童年行走图（验证复用 seed 能否保持一致）
- 主角少年立绘（验证"同一个人长大"）
- 小芳/妈妈/王老师立绘（验证 NPC 气质区分）

→ **这轮满意，说明角色一致性策略成立，继续。**

### 第 2 轮（场景，1 天）
- 家·客厅
- 学校教室
- 老槐树
- 小卖部

→ **验证场景透视和色调统一。**

### 第 3 轮（CG + UI，半天）
- CG·小刚告别（重点打磨）
- CG·序章/骰子/高考
- 6 个数值图标

---

*本清单基于 16 号文档。第二批完成后，MVP 美术素材基本齐全，可进入 Godot 工程搭建与素材导入阶段。*
