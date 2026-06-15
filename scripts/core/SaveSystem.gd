## SaveSystem - 存档系统
## 管理游戏进度的保存和加载
extends Node

const SAVE_PATH := "user://save_%d.json"
const AUTO_SAVE_PATH := "user://save_auto.json"

## 保存游戏
func save_game(slot: int = -1) -> void:
	var save_data := {
		"version": 2,
		"stats": GameState.stats,
		"current_age": GameState.current_age,
		"current_time_period": GameState.current_time_period,
		"background": GameState.background,
		"triggered_events": GameState.triggered_events,
		"affinity": GameState.affinity,
		"game_time": TimeManager.game_time,
		"days_passed": _get_days_passed()
	}

	var path: String
	if slot == -1:
		path = AUTO_SAVE_PATH
	else:
		path = SAVE_PATH % slot

	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()
	print("[SaveSystem] 游戏已保存到: ", path)

## 加载游戏
func load_game(slot: int = -1) -> bool:
	var path: String
	if slot == -1:
		path = AUTO_SAVE_PATH
	else:
		path = SAVE_PATH % slot

	if not FileAccess.file_exists(path):
		push_warning("[SaveSystem] 存档文件不存在: " + path)
		return false

	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	file.close()

	if error != OK:
		push_warning("[SaveSystem] 解析存档文件失败")
		return false

	var data: Dictionary = json.data

	# 重置游戏状态
	GameState.reset()

	# 使用正确的方法加载数据（会触发信号）
	# 加载数值
	var saved_stats: Dictionary = data.get("stats", {})
	for stat_name in saved_stats:
		var old_value: int = GameState.get_stat(stat_name)
		var new_value: int = saved_stats[stat_name]
		if old_value != new_value:
			GameState.stats[stat_name] = new_value
			GameState.stats_changed.emit(stat_name, old_value, new_value)

	# 加载年龄
	var saved_age: int = data.get("current_age", 7)
	if saved_age != GameState.current_age:
		GameState.set_age(saved_age)

	# 加载背景
	GameState.background = data.get("background", "rural_normal")

	# 加载已触发事件
	GameState.triggered_events = data.get("triggered_events", [])

	# 加载好感度
	var saved_affinity: Dictionary = data.get("affinity", {})
	for npc_id in saved_affinity:
		GameState.affinity[npc_id] = saved_affinity[npc_id]

	# 加载时间
	TimeManager.game_time = data.get("game_time", 360.0)
	TimeManager.set_time_period_from_minutes()

	# 加载天数（如果有）
	var days_passed: int = data.get("days_passed", 0)
	_set_days_passed(days_passed)

	print("[SaveSystem] 游戏已从存档加载: ", path)
	return true

## 检查存档是否存在
func has_save(slot: int = -1) -> bool:
	var path: String
	if slot == -1:
		path = AUTO_SAVE_PATH
	else:
		path = SAVE_PATH % slot
	return FileAccess.file_exists(path)

## 删除存档
func delete_save(slot: int) -> void:
	var path := SAVE_PATH % slot
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("[SaveSystem] 存档已删除: ", path)

## 获取存档信息（用于显示存档列表）
func get_save_info(slot: int = -1) -> Dictionary:
	var path: String
	if slot == -1:
		path = AUTO_SAVE_PATH
	else:
		path = SAVE_PATH % slot

	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	file.close()

	if error != OK:
		return {}

	var data: Dictionary = json.data
	return {
		"age": data.get("current_age", 7),
		"stats": data.get("stats", {}),
		"days_passed": data.get("days_passed", 0),
		"file_path": path
	}

## 获取天数（从 Main 场景）
func _get_days_passed() -> int:
	var main_scene = get_tree().current_scene
	if main_scene and main_scene.has_method("get_days_passed"):
		return main_scene.get_days_passed()
	return 0

## 设置天数（到 Main 场景）
func _set_days_passed(days: int) -> void:
	var main_scene = get_tree().current_scene
	if main_scene and main_scene.has_method("set_days_passed"):
		main_scene.set_days_passed(days)
