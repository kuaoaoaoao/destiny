# 第一批 AI 素材生成清单（直接复制可用）

> 📌 **用途**：验证《命》扁平手绘 2.5D 美术风格是否统一满意。
> 📋 **规则**：只生成下面 3 张。**3 张都满意后**再批量做第二批。
> 🎨 **风格宪法**：详见 `16-AI美术素材生成规范.md` 第一节。
> 🔧 **推荐工具**：即梦 / 可灵 / 通义（中文提示词友好），也可用 Midjourney（附英文版）

> ⚠️ **v0.3.2 更新**：本清单的"第 1 张小镇主图"已作废（整张图无法当游戏地图）。改为生成场景素材包，详见 **17 号文档 + 批3清单**。
> 本清单的"第 2 张主角童年立绘""第 3 张小刚童年立绘"**仍然有效**，继续使用。

---

## 通用风格锚（每张图都要带）

把下面这段加在**每个**提示词的最前面：

**中文版：**
```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材，
```

**英文版（Midjourney）：**
```
flat hand-drawn illustration, warm color palette, soft cel shading without outline, storybook art style, minimalist, Chinese countryside, cozy and warm,
```

---

## 第 1 张：小镇主地图 ⭐最关键

**用途**：MVP 主场景，玩家大部分时间在这里走动。

### 完整提示词（中文，直接复制）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材，
2.5D俯视斜45度等距透视，中国北方乡村小镇全景，
画面中心一棵枝叶茂盛的大槐树，旁边一间老旧的小卖部，
几栋土房和红砖房错落，土路蜿蜒穿过，
远处是金黄的田野和低矮的丘陵，一条小河蜿蜒，
夏末午后暖黄阳光，柔和的长影子，
大量天空留白，干净不杂乱，横版宽幅构图
```

### 完整提示词（英文，Midjourney）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline, 
storybook art style, minimalist, Chinese countryside, cozy and warm,
2.5D isometric top-down perspective, panoramic view of a northern Chinese rural small town,
a large lush old pagoda tree in the center, an old grocery store beside it,
scattered earthen and red-brick houses, a winding dirt road,
golden fields and low rolling hills in the distance, a winding small river,
warm late-summer afternoon sunlight, soft long shadows,
lots of negative sky space, clean and uncluttered, wide panoramic composition --ar 16:9
```

**参数建议：**
- 比例：**16:9 横版**（Midjourney 加 `--ar 16:9`）
- 即梦/可灵：选横图模式
- seed：记录下来，后续城市场景复用透视风格

---

## 第 2 张：主角童年立绘

**用途**：主角 7-12 岁形象，立绘用于对话/菜单展示。
**注意**：主角**不画清晰五官**（代入感设计）。

### 完整提示词（中文，直接复制）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材，
全身人物立绘，一个7岁的中国乡村男孩，
瘦小身形，穿着旧的白色T恤和蓝色短裤，脚踩布鞋，
站立姿态，身体微微前倾，好奇地微微抬头，
面部背光处理，没有清晰五官，只有柔和的轮廓阴影，
暖黄暖橙色调，纯色背景，竖构图
```

### 完整提示词（英文，Midjourney）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline, 
storybook art style, minimalist, Chinese countryside, cozy and warm,
full-body character portrait, a 7-year-old Chinese rural boy,
thin small build, wearing an old white T-shirt and blue shorts, cloth shoes,
standing pose, leaning slightly forward, looking up curiously,
face in soft shadow with no clear facial features, only a gentle silhouette,
warm yellow-orange tones, solid color background, vertical composition --ar 2:3
```

**参数建议：**
- 比例：**2:3 竖版**（Midjourney 加 `--ar 2:3`）
- **这张图的 seed 务必记录**，主角少年/青年/中年/老年都要复用，保证"是同一个人在长大"
- 注意：面部要"背光/留白"，AI 如果给了清晰五官，在提示词里强化"面部阴影、看不清五官"

---

## 第 3 张：小刚童年立绘

**用途**：NPC 小刚 7-12 岁形象。
**注意**：NPC **要有辨识度特征**（与主角相反），小刚的关键词是"调皮、瘦、头发乱、不羁"。

### 完整提示词（中文，直接复制）

```
扁平手绘插画，暖色调，柔和平涂上色，没有描边，绘本质感，克制留白，中国乡村题材,
全身人物立绘，一个10岁的中国乡村男孩，
偏瘦、头发蓬乱微长、表情调皮不羁、嘴角带着坏笑，
穿着旧的白色背心和宽松短裤，脚踩拖鞋，
叉着腰的站姿，有活力，
清晰的五官特征，暖黄暖橙色调，纯色背景，竖构图
```

### 完整提示词（英文，Midjourney）

```
flat hand-drawn illustration, warm color palette, soft cel shading without outline, 
storybook art style, minimalist, Chinese countryside, cozy and warm,
full-body character portrait, a 10-year-old Chinese rural boy,
thin build, messy slightly long hair, mischievous unruly expression with a smirk,
wearing an old white tank top and loose shorts, slippers on feet,
standing with hands on hips, energetic,
clear facial features, warm yellow-orange tones, solid color background, vertical composition --ar 2:3
```

**参数建议：**
- 比例：**2:3 竖版**（Midjourney 加 `--ar 2:3`）
- **这张图的 seed 务必记录**，小刚的 5 个版本（打工/误入歧途/手艺人/早逝/当兵）都要在这个"基础脸"上叠加生成

---

## ✅ 验收标准（3 张都生成后对照检查）

生成完 3 张后，**对照下面 4 条检查**，全过才算风格定调：

### 1. 透视统一 ✅
- [ ] 小镇主图是"俯视斜 45°"
- [ ] 两张立绘是"正面全身"
- （主图和立绘视角不同是正常的，但同类素材之间要统一）

### 2. 色调统一 ✅
- [ ] 3 张都是暖色调（暖黄/暖橙），没有冷色或鲜艳刺眼
- [ ] 没有"赛博朋克霓虹""高饱和纯色"

### 3. 笔触统一 ✅
- [ ] 3 张都是"平涂上色、无描边或极细描边"
- [ ] 没有写实厚涂、没有像素颗粒、没有 3D 渲染感

### 4. 角色一致性 ✅
- [ ] 主角立绘：**面部确实模糊/背光**，没有清晰五官
- [ ] 小刚立绘：**有清晰五官和调皮特征**，和主角气质明显不同
- [ ] 两人服装/气质能区分开

---

## ⚠️ 常见问题与修正

| 问题 | 修正方法 |
|------|---------|
| 风格偏写实/3D | 提示词强化："强调扁平、纯色块、无立体感、绘本插画" |
| AI 给了主角清晰五官 | 强化："面部完全背光、看不清五官、只有黑色轮廓" |
| 色调太鲜艳 | 强化："降低饱和度、灰调、莫兰迪色、做旧感" |
| 小镇太杂乱堆砌 | 强化："极简、大量留白、只画核心几个元素、干净" |
| 透视不对（变平视了） | 强化："严格俯视斜45度、isometric、等距透视" |
| 小刚和主角长得像 | 小刚强化辨识特征："蓬乱头发、坏笑、晒黑、有疤痕" |
| 立绘带杂乱背景 | 强化："纯色背景、纯白色背景、无背景元素" |

---

## 📝 生成结果记录表（填这张表）

每生成一张，把信息记下来，后续复用：

| 素材 | 工具 | 提示词版本 | seed/参数 | 文件名 | 满意度(1-5) | 备注 |
|------|------|----------|----------|--------|------------|------|
| 小镇主图 | | v1 | | scene_town_main_v1.png | / | |
| 主角童年立绘 | | v1 | | char_player_child_v1.png | / | 主角seed务必记 |
| 小刚童年立绘 | | v1 | | char_xiaogang_child_v1.png | / | 小刚seed务必记 |

---

## 🎯 下一步

- ✅ 3 张全满意 → 告诉我，我开始整理**第二批素材清单**（主角行走图、小芳/妈妈/王老师立绘、4个室内场景、4张CG、6个数值图标）
- ❌ 有任何一张不满意 → 把图发我，我帮你诊断提示词怎么改
- 🔄 风格想微调（比如更暖/更冷/更扁平） → 告诉我，我更新风格锚

---

*本清单基于 16 号文档。生成满意后即可进入 Godot 工程搭建阶段。*
