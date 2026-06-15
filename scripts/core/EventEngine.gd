## EventEngine - 事件引擎
## 管理事件触发、条件检查、执行
extends Node

## 事件数据库
var events: Dictionary = {}
## events_data 别名（兼容 DialogueBox 等组件的引用）
var events_data: Dictionary:
	get:
		return events
	set(value):
		events = value

## 事件队列
var event_queue: Array[Dictionary] = []

## 当前执行事件
var current_event: Dictionary = {}

## 信号
signal event_triggered(event_id: String)
signal event_completed(event_id: String)
signal dialogue_started(dialogue_data: Dictionary)
signal event_choice_required(event_id: String, choices: Array)

func _ready() -> void:
	load_events()

## 加载事件数据
func load_events() -> void:
	var event_files := ["res://data/events/childhood.json", "res://data/events/teen.json", "res://data/events/young.json"]
	for file_path in event_files:
		if FileAccess.file_exists(file_path):
			var file := FileAccess.open(file_path, FileAccess.READ)
			var json := JSON.new()
			var error := json.parse(file.get_as_text())
			if error == OK:
				var data: Dictionary = json.data
				for event in data.get("events", []):
					events[event["id"]] = event

## 检查事件触发条件
func check_event_conditions(event: Dictionary) -> bool:
	# 检查年龄范围
	var age_range: Array = event.get("trigger_conditions", {}).get("age_range", [0, 100])
	if GameState.current_age < age_range[0] or GameState.current_age > age_range[1]:
		return false
	
	# 检查时段
	var required_period: String = event.get("trigger_conditions", {}).get("time_period", "")
	if required_period != "" and required_period != GameState.current_time_period:
		return false
	
	# 检查是否已触发（一次性事件）
	if event.get("one_time", true) and GameState.is_event_triggered(event["id"]):
		return false
	
	# 检查好感度条件
	var affinity_conditions: Dictionary = event.get("trigger_conditions", {}).get("affinity", {})
	for npc_id in affinity_conditions:
		var min_val: int = affinity_conditions[npc_id].get("min", 0)
		if GameState.get_affinity(npc_id) < min_val:
			return false
	
	return true

## 尝试触发事件
func try_trigger_event(event_id: String) -> bool:
	if not events.has(event_id):
		return false
	
	var event: Dictionary = events[event_id]
	if check_event_conditions(event):
		trigger_event(event)
		return true
	return false

## 触发事件
func trigger_event(event: Dictionary) -> void:
	current_event = event
	event_triggered.emit(event["id"])
	
	# 应用效果
	if event.has("effects"):
		GameState.modify_stats(event["effects"])
	
	# 标记为已触发
	GameState.mark_event_triggered(event["id"])
	
	# 如果有对话，启动对话
	if event.has("dialogue"):
		dialogue_started.emit(event["dialogue"])
	
	# 完成事件
	event_completed.emit(event["id"])
	current_event = {}

## 检查位置触发事件
func check_location_events(location_id: String) -> void:
	for event_id in events:
		var event: Dictionary = events[event_id]
		if event.get("trigger_type") == "location" and event.get("trigger_location") == location_id:
			try_trigger_event(event_id)

## 获取所有可用事件
func get_available_events() -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	for event_id in events:
		var event: Dictionary = events[event_id]
		if check_event_conditions(event):
			available.append(event)
	return available

## 评估条件（供 DialogueBox 等组件调用）
func _eval_condition(condition: Dictionary) -> bool:
	# 检查数值条件
	if condition.has("stat"):
		var stat_name: String = condition["stat"]
		var op: String = condition.get("op", ">=")
		var value: int = condition.get("value", 0)
		var current_value: int = GameState.get_stat(stat_name)
		match op:
			">=": return current_value >= value
			"<=": return current_value <= value
			">": return current_value > value
			"<": return current_value < value
			"==": return current_value == value
			"!=": return current_value != value
			_: return true

	# 检查年龄条件
	if condition.has("age"):
		var age_op: String = condition["age"].get("op", ">=")
		var age_value: int = condition["age"].get("value", 0)
		match age_op:
			">=": return GameState.current_age >= age_value
			"<=": return GameState.current_age <= age_value
			">": return GameState.current_age > age_value
			"<": return GameState.current_age < age_value
			"==": return GameState.current_age == age_value
			_: return true

	# 检查好感度条件
	if condition.has("affinity"):
		var npc_id: String = condition["affinity"]["npc"]
		var affinity_op: String = condition["affinity"].get("op", ">=")
		var affinity_value: int = condition["affinity"].get("value", 0)
		var current_affinity: int = GameState.get_affinity(npc_id)
		match affinity_op:
			">=": return current_affinity >= affinity_value
			"<=": return current_affinity <= affinity_value
			">": return current_affinity > affinity_value
			"<": return current_affinity < affinity_value
			"==": return current_affinity == affinity_value
			_: return true

	# 检查事件是否已触发
	if condition.has("event_triggered"):
		return GameState.is_event_triggered(condition["event_triggered"])

	# 检查事件是否未触发
	if condition.has("event_not_triggered"):
		return not GameState.is_event_triggered(condition["event_not_triggered"])

	return true

## 应用选择效果（供 DialogueBox 等组件调用）
func apply_choice(choice: Dictionary) -> void:
	# 应用数值效果
	if choice.has("effects"):
		GameState.modify_stats(choice["effects"])

	# 应用好感度效果
	if choice.has("affinity"):
		for npc_id in choice["affinity"]:
			GameState.modify_affinity(npc_id, choice["affinity"][npc_id])

	# 标记事件触发
	if choice.has("trigger_event"):
		GameState.mark_event_triggered(choice["trigger_event"])

	# 发射选择完成信号
	if choice.has("next_event"):
		try_trigger_event(choice["next_event"])
