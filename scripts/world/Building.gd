## Building - 建筑基础脚本
## 支持 2.5D 遮挡、门交互、屋顶隐藏、室内场景切换
extends StaticBody2D

## 建筑配置
@export var building_name: String = "建筑"
@export var building_id: String = "building"
@export var has_door: bool = true
@export var door_position: Vector2 = Vector2(0, 24)  # 门的位置（相对于建筑中心）
@export var roof_height: float = 32.0  # 屋顶高度
@export var has_indoor_scene: bool = true  # 是否有室内场景

## 节点引用
@onready var wall_sprite: Sprite2D = $WallSprite
@onready var roof_sprite: Sprite2D = $RoofSprite
@onready var door_area: Area2D = $DoorArea
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var name_label: Label = $NameLabel

## 状态
var is_player_inside: bool = false
var roof_visible: bool = true

## 信号
signal player_entered(building_id: String)
signal player_exited(building_id: String)
signal door_interacted(building_id: String)

func _ready() -> void:
	# 设置建筑名称
	if name_label:
		name_label.text = building_name

	# 连接门区域信号
	if door_area:
		door_area.body_entered.connect(_on_door_body_entered)
		door_area.body_exited.connect(_on_door_body_exited)

## 显示/隐藏屋顶
func set_roof_visible(visible: bool) -> void:
	roof_visible = visible
	if roof_sprite:
		roof_sprite.visible = visible

## 玩家进入门区域
func _on_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_inside = true
		player_entered.emit(building_id)

## 玩家离开门区域
func _on_door_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_inside = false
		player_exited.emit(building_id)

## 交互门
func interact_door() -> void:
	if has_door and is_player_inside:
		door_interacted.emit(building_id)

		# 如果有室内场景，进入室内
		if has_indoor_scene:
			_enter_building()
		else:
			# 否则切换屋顶显示
			set_roof_visible(not roof_visible)

## 进入建筑
func _enter_building() -> void:
	# 获取场景过渡管理器
	var scene_transition = get_tree().get_first_node_in_group("scene_transition_manager")
	if scene_transition:
		scene_transition.enter_building(building_id)
	else:
		# 如果没有场景过渡管理器，直接切换场景
		match building_id:
			"home":
				get_tree().change_scene_to_file("res://scenes/indoor/Home.tscn")
			"school":
				get_tree().change_scene_to_file("res://scenes/indoor/School.tscn")
			"shop":
				get_tree().change_scene_to_file("res://scenes/indoor/Shop.tscn")

## 获取建筑信息
func get_building_info() -> Dictionary:
	return {
		"name": building_name,
		"id": building_id,
		"has_door": has_door,
		"has_indoor_scene": has_indoor_scene,
		"position": global_position
	}
