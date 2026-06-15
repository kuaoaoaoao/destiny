## Decoration - 装饰物基础脚本
## 支持花草、灌木、石头、路灯等装饰物
extends StaticBody2D

## 装饰物配置
@export var decoration_name: String = "装饰物"
@export var decoration_type: String = "bush"  # bush, flower, rock, lamp, well, bench
@export var has_collision: bool = true
@export var is_interactable: bool = false
@export var interaction_text: String = ""

## 节点引用
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shadow: Sprite2D = $Shadow

func _ready() -> void:
	# 设置碰撞
	if collision_shape:
		collision_shape.disabled = not has_collision

	# 设置阴影
	if shadow:
		shadow.modulate = Color(0, 0, 0, 0.15)

## 交互
func interact() -> void:
	if is_interactable:
		_on_interact()

## 交互回调（可被子类重写）
func _on_interact() -> void:
	match decoration_type:
		"well":
			UIManager.show_notification("水井里传来清脆的水声")
		"bench":
			UIManager.show_notification("坐在石凳上休息了一会儿")
			GameState.modify_stat("psychology", 3)
		"lamp":
			UIManager.show_notification("路灯发出温暖的光芒")
		_:
			pass
