## Tree - 树木脚本
## 支持 2.5D Y-Sort 和碰撞
extends StaticBody2D

## 树木配置
@export var tree_name: String = "树"
@export var tree_type: String = "normal"  # normal, fruit, special
@export var has_collision: bool = true

## 节点引用
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shadow: Sprite2D = $Shadow

## 状态
var health: int = 3
var is_destroyed: bool = false

func _ready() -> void:
	# 设置碰撞
	if collision_shape:
		collision_shape.disabled = not has_collision

	# 设置阴影
	if shadow:
		shadow.modulate = Color(0, 0, 0, 0.2)

## 受到伤害
func take_damage(amount: int = 1) -> void:
	if is_destroyed:
		return

	health -= amount
	if health <= 0:
		_destroy()

## 销毁树木
func _destroy() -> void:
	is_destroyed = true
	# 播放销毁动画
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
		await tween.finished
	# 禁用碰撞
	if collision_shape:
		collision_shape.disabled = true
	# 隐藏精灵
	if sprite:
		sprite.visible = false
	if shadow:
		shadow.visible = false

## 重置树木
func reset() -> void:
	health = 3
	is_destroyed = false
	if sprite:
		sprite.visible = true
		sprite.modulate.a = 1.0
	if shadow:
		shadow.visible = true
	if collision_shape:
		collision_shape.disabled = false
