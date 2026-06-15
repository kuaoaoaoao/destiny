## ProceduralSprite - 程序化精灵生成器
## 使用 Godot 绘制功能创建简单的装饰物精灵
extends Node2D

## 精灵类型
enum SpriteType {
	TREE,
	BUSH,
	FLOWER,
	ROCK,
	WELL,
	BENCH,
	LAMP,
	MAILBOX,
	FENCE,
	HOUSE,
	SCHOOL,
	SHOP
}

## 配置
@export var sprite_type: SpriteType = SpriteType.BUSH
@export var variation: int = 0  # 变体（用于随机化）
@export var scale_factor: float = 1.0

## 颜色配置
var colors := {
	SpriteType.TREE: {
		"trunk": Color(0.45, 0.3, 0.15),
		"leaves": Color(0.25, 0.6, 0.25),
		"leaves_dark": Color(0.2, 0.5, 0.2)
	},
	SpriteType.BUSH: {
		"leaves": Color(0.3, 0.65, 0.3),
		"leaves_dark": Color(0.25, 0.55, 0.25)
	},
	SpriteType.FLOWER: {
		"stem": Color(0.3, 0.6, 0.3),
		"petals": Color(0.9, 0.4, 0.5),
		"center": Color(1.0, 0.9, 0.3)
	},
	SpriteType.ROCK: {
		"main": Color(0.6, 0.6, 0.6),
		"shadow": Color(0.5, 0.5, 0.5),
		"highlight": Color(0.7, 0.7, 0.7)
	},
	SpriteType.WELL: {
		"stone": Color(0.6, 0.55, 0.5),
		"wood": Color(0.5, 0.35, 0.2),
		"water": Color(0.3, 0.5, 0.7)
	},
	SpriteType.BENCH: {
		"wood": Color(0.6, 0.45, 0.3),
		"shadow": Color(0.5, 0.35, 0.2)
	},
	SpriteType.LAMP: {
		"pole": Color(0.4, 0.4, 0.4),
		"light": Color(1.0, 0.95, 0.8),
		"glow": Color(1.0, 0.9, 0.6, 0.3)
	},
	SpriteType.MAILBOX: {
		"box": Color(0.3, 0.3, 0.7),
		"post": Color(0.5, 0.35, 0.2)
	},
	SpriteType.FENCE: {
		"wood": Color(0.65, 0.5, 0.35),
		"shadow": Color(0.55, 0.4, 0.25)
	},
	SpriteType.HOUSE: {
		"wall": Color(0.85, 0.75, 0.65),
		"roof": Color(0.6, 0.35, 0.2),
		"door": Color(0.45, 0.3, 0.2),
		"window": Color(0.7, 0.85, 0.95)
	},
	SpriteType.SCHOOL: {
		"wall": Color(0.9, 0.88, 0.85),
		"roof": Color(0.65, 0.4, 0.25),
		"door": Color(0.5, 0.35, 0.2),
		"window": Color(0.75, 0.88, 0.95)
	},
	SpriteType.SHOP: {
		"wall": Color(0.95, 0.85, 0.7),
		"roof": Color(0.7, 0.45, 0.3),
		"door": Color(0.55, 0.4, 0.3),
		"sign": Color(0.8, 0.7, 0.5)
	}
}

func _draw() -> void:
	match sprite_type:
		SpriteType.TREE:
			_draw_tree()
		SpriteType.BUSH:
			_draw_bush()
		SpriteType.FLOWER:
			_draw_flower()
		SpriteType.ROCK:
			_draw_rock()
		SpriteType.WELL:
			_draw_well()
		SpriteType.BENCH:
			_draw_bench()
		SpriteType.LAMP:
			_draw_lamp()
		SpriteType.MAILBOX:
			_draw_mailbox()
		SpriteType.FENCE:
			_draw_fence()
		SpriteType.HOUSE:
			_draw_house()
		SpriteType.SCHOOL:
			_draw_school()
		SpriteType.SHOP:
			_draw_shop()

## 绘制树木
func _draw_tree() -> void:
	var c = colors[SpriteType.TREE]
	# 树干
	draw_rect(Rect2(-3, -8, 6, 16), c["trunk"])
	# 树冠
	draw_circle(Vector2(0, -16), 14, c["leaves"])
	draw_circle(Vector2(-6, -12), 10, c["leaves_dark"])
	draw_circle(Vector2(6, -12), 10, c["leaves"])
	# 阴影
	draw_circle(Vector2(2, 8), 8, Color(0, 0, 0, 0.15))

## 绘制灌木
func _draw_bush() -> void:
	var c = colors[SpriteType.BUSH]
	# 灌木丛
	draw_circle(Vector2(0, -6), 10, c["leaves"])
	draw_circle(Vector2(-6, -4), 8, c["leaves_dark"])
	draw_circle(Vector2(6, -4), 8, c["leaves"])
	# 阴影
	draw_circle(Vector2(0, 4), 6, Color(0, 0, 0, 0.1))

## 绘制花丛
func _draw_flower() -> void:
	var c = colors[SpriteType.FLOWER]
	# 茎
	draw_line(Vector2(0, 0), Vector2(0, -10), c["stem"], 2)
	# 花瓣
	var petal_pos = Vector2(0, -14)
	draw_circle(petal_pos, 5, c["petals"])
	draw_circle(petal_pos + Vector2(4, -2), 4, c["petals"])
	draw_circle(petal_pos + Vector2(-4, -2), 4, c["petals"])
	draw_circle(petal_pos + Vector2(2, 3), 4, c["petals"])
	draw_circle(petal_pos + Vector2(-2, 3), 4, c["petals"])
	# 花心
	draw_circle(petal_pos, 3, c["center"])

## 绘制石头
func _draw_rock() -> void:
	var c = colors[SpriteType.ROCK]
	# 石头主体
	draw_circle(Vector2(0, -4), 8, c["main"])
	draw_circle(Vector2(-3, -2), 6, c["shadow"])
	draw_circle(Vector2(3, -6), 5, c["highlight"])
	# 阴影
	draw_circle(Vector2(2, 4), 5, Color(0, 0, 0, 0.1))

## 绘制水井
func _draw_well() -> void:
	var c = colors[SpriteType.WELL]
	# 井身
	draw_rect(Rect2(-10, -8, 20, 16), c["stone"])
	# 井口
	draw_rect(Rect2(-8, -10, 16, 4), c["wood"])
	# 水面
	draw_rect(Rect2(-6, -6, 12, 10), c["water"])
	# 井架
	draw_line(Vector2(-10, -10), Vector2(-10, -20), c["wood"], 2)
	draw_line(Vector2(10, -10), Vector2(10, -20), c["wood"], 2)
	draw_line(Vector2(-10, -20), Vector2(10, -20), c["wood"], 2)
	# 阴影
	draw_rect(Rect2(-8, 8, 16, 4), Color(0, 0, 0, 0.15))

## 绘制石凳
func _draw_bench() -> void:
	var c = colors[SpriteType.BENCH]
	# 凳面
	draw_rect(Rect2(-12, -4, 24, 4), c["wood"])
	# 凳腿
	draw_rect(Rect2(-10, 0, 4, 6), c["shadow"])
	draw_rect(Rect2(6, 0, 4, 6), c["shadow"])
	# 阴影
	draw_rect(Rect2(-10, 6, 20, 3), Color(0, 0, 0, 0.1))

## 绘制路灯
func _draw_lamp() -> void:
	var c = colors[SpriteType.LAMP]
	# 灯杆
	draw_rect(Rect2(-1, -20, 2, 20), c["pole"])
	# 灯罩
	draw_rect(Rect2(-4, -24, 8, 4), c["pole"])
	# 灯光
	draw_circle(Vector2(0, -22), 3, c["light"])
	# 光晕
	draw_circle(Vector2(0, -22), 8, c["glow"])

## 绘制信箱
func _draw_mailbox() -> void:
	var c = colors[SpriteType.MAILBOX]
	# 信箱
	draw_rect(Rect2(-5, -12, 10, 8), c["box"])
	# 投递口
	draw_rect(Rect2(-3, -10, 6, 2), Color(0.2, 0.2, 0.2))
	# 信箱杆
	draw_rect(Rect2(-1, -4, 2, 8), c["post"])

## 绘制栅栏
func _draw_fence() -> void:
	var c = colors[SpriteType.FENCE]
	# 栅栏柱
	draw_rect(Rect2(-7, -8, 3, 12), c["wood"])
	draw_rect(Rect2(4, -8, 3, 12), c["wood"])
	# 横杆
	draw_rect(Rect2(-7, -4, 14, 2), c["shadow"])
	draw_rect(Rect2(-7, 0, 14, 2), c["shadow"])

## 绘制房屋
func _draw_house() -> void:
	var c = colors[SpriteType.HOUSE]
	# 墙壁
	draw_rect(Rect2(-20, -10, 40, 25), c["wall"])
	# 屋顶
	draw_colored_polygon([
		Vector2(-24, -10),
		Vector2(0, -28),
		Vector2(24, -10)
	], c["roof"])
	# 门
	draw_rect(Rect2(-4, 5, 8, 10), c["door"])
	# 窗户
	draw_rect(Rect2(-16, -4, 6, 6), c["window"])
	draw_rect(Rect2(10, -4, 6, 6), c["window"])

## 绘制学校
func _draw_school() -> void:
	var c = colors[SpriteType.SCHOOL]
	# 墙壁
	draw_rect(Rect2(-28, -12, 56, 30), c["wall"])
	# 屋顶
	draw_colored_polygon([
		Vector2(-32, -12),
		Vector2(0, -30),
		Vector2(32, -12)
	], c["roof"])
	# 门
	draw_rect(Rect2(-5, 8, 10, 10), c["door"])
	# 窗户
	draw_rect(Rect2(-22, -4, 8, 8), c["window"])
	draw_rect(Rect2(-10, -4, 8, 8), c["window"])
	draw_rect(Rect2(10, -4, 8, 8), c["window"])
	draw_rect(Rect2(22, -4, 8, 8), c["window"])

## 绘制小卖部
func _draw_shop() -> void:
	var c = colors[SpriteType.SHOP]
	# 墙壁
	draw_rect(Rect2(-22, -10, 44, 25), c["wall"])
	# 屋顶
	draw_rect(Rect2(-26, -16, 52, 6), c["roof"])
	# 门
	draw_rect(Rect2(-4, 5, 8, 10), c["door"])
	# 招牌
	draw_rect(Rect2(-15, -22, 30, 6), c["sign"])
	# 窗户
	draw_rect(Rect2(-18, -4, 8, 8), c["window"])
	draw_rect(Rect2(10, -4, 8, 8), c["window"])
