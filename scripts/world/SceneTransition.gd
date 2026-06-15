## SceneTransition - 场景过渡管理器
## 管理室内外场景切换
extends Node

## 当前场景
var current_scene: String = "main"
var previous_scene: String = ""
var is_transitioning: bool = false

## 场景路径
var scene_paths := {
	"main": "res://scenes/Main.tscn",
	"home": "res://scenes/indoor/Home.tscn",
	"school": "res://scenes/indoor/School.tscn",
	"shop": "res://scenes/indoor/Shop.tscn"
}

## 玩家位置记忆
var player_positions := {}

## 信号
signal scene_changed(scene_name: String)
signal scene_transition_started
signal scene_transition_completed

func _ready() -> void:
	# 注册到场景过渡管理器组
	add_to_group("scene_transition_manager")

## 切换场景
func change_scene(scene_name: String, save_position: bool = true) -> void:
	if is_transitioning:
		return
	if not scene_paths.has(scene_name):
		push_warning("[SceneTransition] 未知场景: " + scene_name)
		return

	is_transitioning = true

	# 保存当前玩家位置
	if save_position:
		_save_player_position()

	# 开始过渡
	scene_transition_started.emit()

	# 淡出效果
	var canvas = get_tree().current_scene.get_node_or_null("CanvasLayer")
	if canvas:
		var tween = create_tween()
		tween.tween_property(canvas, "modulate:a", 0.0, 0.3)
		await tween.finished

	# 获取目标场景路径
	var target_path: String = scene_paths[scene_name]

	# 切换场景
	get_tree().change_scene_to_file(target_path)
	await get_tree().process_frame
	await get_tree().process_frame

	# 更新当前场景
	previous_scene = current_scene
	current_scene = scene_name

	# 淡入效果
	canvas = get_tree().current_scene.get_node_or_null("CanvasLayer")
	if canvas:
		canvas.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(canvas, "modulate:a", 1.0, 0.3)

	# 恢复玩家位置
	if save_position:
		_restore_player_position()

	# 完成过渡
	is_transitioning = false
	scene_changed.emit(scene_name)
	scene_transition_completed.emit()

## 返回主场景
func return_to_main() -> void:
	change_scene("main")

## 进入建筑
func enter_building(building_id: String) -> void:
	match building_id:
		"home":
			change_scene("home")
		"school":
			change_scene("school")
		"shop":
			change_scene("shop")
		_:
			push_warning("[SceneTransition] 未知建筑: " + building_id)

## 保存玩家位置
func _save_player_position() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player_positions[current_scene] = player.global_position

## 恢复玩家位置
func _restore_player_position() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player_positions.has(current_scene):
		player.global_position = player_positions[current_scene]

## 获取当前场景名称
func get_current_scene() -> String:
	return current_scene

## 获取上一个场景名称
func get_previous_scene() -> String:
	return previous_scene

## 检查是否在室内
func is_indoor() -> bool:
	return current_scene != "main"

## 获取当前场景名称（兼容旧接口）
func get_current_scene_name() -> String:
	return current_scene
