## 对话管理器 - Autoload 单例
## 加载和管理 JSON 对话数据，提供对话查询接口
extends Node

# ===== 对话数据 =====
var npc_dialogues: Dictionary = {}  # NPC 对话数据
var location_dialogues: Dictionary = {}  # 地点对话数据

# ===== DialogueBox 引用 =====
var dialogue_box: Node = null

func _ready() -> void:
	# 加载对话数据
	_load_all_dialogues()

func _load_all_dialogues() -> void:
	# 加载 NPC 对话
	_load_npc_dialogue("xiaogang")
	_load_npc_dialogue("xiaofang")
	_load_npc_dialogue("dazhuang")
	_load_npc_dialogue("aqiang")
	_load_npc_dialogue("lili")
	_load_npc_dialogue("xiaomei")

	# 加载地点对话
	_load_location_dialogues()

## 加载 NPC 对话数据
func _load_npc_dialogue(npc_id: String) -> void:
	var file_path: String = "res://data/dialogues/%s.json" % npc_id
	if FileAccess.file_exists(file_path):
		var file := FileAccess.open(file_path, FileAccess.READ)
		var json := JSON.new()
		var error := json.parse(file.get_as_text())
		if error == OK:
			npc_dialogues[npc_id] = json.data
			print("[DialogueManager] 加载 NPC 对话: ", npc_id)
		else:
			push_warning("[DialogueManager] 解析 NPC 对话文件失败: " + file_path)
	else:
		push_warning("[DialogueManager] NPC 对话文件不存在: " + file_path)

## 加载地点对话数据
func _load_location_dialogues() -> void:
	var file_path: String = "res://data/dialogues/locations.json"
	if FileAccess.file_exists(file_path):
		var file := FileAccess.open(file_path, FileAccess.READ)
		var json := JSON.new()
		var error := json.parse(file.get_as_text())
		if error == OK:
			location_dialogues = json.data.get("locations", {})
			print("[DialogueManager] 加载地点对话数据")
		else:
			push_warning("[DialogueManager] 解析地点对话文件失败: " + file_path)
	else:
		push_warning("[DialogueManager] 地点对话文件不存在: " + file_path)

## 获取 NPC 对话（根据年龄、天气、时间）
func get_npc_dialogue(npc_id: String) -> Dictionary:
	if not npc_dialogues.has(npc_id):
		return {"speaker": "???", "text": "...", "options": []}

	var npc_data: Dictionary = npc_dialogues[npc_id]
	var npc_name: String = npc_data.get("npc_name", npc_id)
	var dialogues: Dictionary = npc_data.get("dialogues", {})
	var current_age: int = GameState.current_age
	var current_period: String = GameState.current_time_period

	# 检查天气相关对话
	var is_raining = false
	if Engine.has_singleton("WeatherSystem"):
		is_raining = WeatherSystem.is_raining()
	if is_raining and dialogues.has("rainy"):
		var rainy_data: Dictionary = dialogues["rainy"]
		return {
			"speaker": npc_name,
			"text": rainy_data.get("text", ""),
			"options": rainy_data.get("options", [])
		}

	# 检查时段相关对话
	if dialogues.has(current_period):
		var period_data: Dictionary = dialogues[current_period]
		return {
			"speaker": npc_name,
			"text": period_data.get("text", ""),
			"options": period_data.get("options", [])
		}

	# 根据年龄查找合适的对话
	for stage_key in dialogues:
		var stage_data: Dictionary = dialogues[stage_key]
		var age_range: Array = stage_data.get("age_range", [0, 100])
		if current_age >= age_range[0] and current_age < age_range[1]:
			return {
				"speaker": npc_name,
				"text": stage_data.get("text", ""),
				"options": stage_data.get("options", [])
			}

	# 如果没有匹配的对话，返回默认
	return {"speaker": npc_name, "text": "...", "options": []}

## 获取地点对话（根据年龄）
func get_location_dialogue(location_id: String) -> Dictionary:
	if not location_dialogues.has(location_id):
		return {"speaker": "???", "text": "...", "options": []}

	var location_data: Dictionary = location_dialogues[location_id]
	var location_name: String = location_data.get("name", location_id)
	var current_age: int = GameState.current_age

	# 检查是否有年龄分支对话
	if location_data.has("dialogues"):
		var dialogues: Dictionary = location_data["dialogues"]
		for stage_key in dialogues:
			var stage_data: Dictionary = dialogues[stage_key]
			var age_range: Array = stage_data.get("age_range", [0, 100])
			if current_age >= age_range[0] and current_age < age_range[1]:
				return {
					"speaker": location_name,
					"text": stage_data.get("text", ""),
					"options": stage_data.get("options", [])
				}

	# 如果没有年龄分支，返回基础对话
	return {
		"speaker": location_name,
		"text": location_data.get("text", ""),
		"options": location_data.get("options", [])
	}

## 注册 DialogueBox（兼容旧接口）
func register_dialogue_box(box: Node) -> void:
	dialogue_box = box

## 显示简单对话（兼容旧接口）
func show_simple_dialogue(speaker_name: String, text: String) -> void:
	if dialogue_box and is_instance_valid(dialogue_box):
		dialogue_box.show_simple_dialogue(speaker_name, text)
	else:
		print("[%s]: %s" % [speaker_name, text])

## 重新加载所有对话数据（用于热更新）
func reload_all() -> void:
	npc_dialogues.clear()
	location_dialogues.clear()
	_load_all_dialogues()
