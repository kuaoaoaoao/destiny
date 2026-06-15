## Main - 主场景脚本
## 管理 2.5D 小镇地图、玩家、NPC、UI
extends Node2D

## UI 引用
@onready var hud: CanvasLayer = $HUD
@onready var exam_minigame = $ExamMinigame

## 场景引用
@onready var objects: Node2D = $Objects
@onready var player: CharacterBody2D = $Objects/Player

## 命运之书
var life_records: Array = []

## 当前状态
var is_dialogue_active: bool = false
var current_npc: Node2D = null
var nearby_interactable: Node2D = null
var days_passed: int = 0
var days_per_year: int = 3
var exam_taken: bool = false

## 关键日年龄
var key_ages: Array = [7, 12, 15, 18, 22, 25, 28, 30]

func _ready() -> void:
	# 连接核心信号
	GameState.stats_changed.connect(_on_stats_changed)
	GameState.age_changed.connect(_on_age_changed)
	TimeManager.time_period_changed.connect(_on_time_period_changed)
	TimeManager.day_started.connect(_on_day_started)

	# 连接玩家交互信号
	if player:
		player.interaction_available.connect(_on_interaction_available)
		player.interaction_unavailable.connect(_on_interaction_unavailable)

	# 连接建筑信号
	_connect_building_signals()

	# 注册到游戏控制器组
	add_to_group("game_controllers")

	# 显示欢迎信息
	UIManager.show_notification("欢迎来到《命》- 人生全知模拟器")

func _process(_delta: float) -> void:
	# 处理交互输入
	if Input.is_action_just_pressed("interact"):
		if is_dialogue_active:
			_advance_dialogue()
		elif nearby_interactable:
			_start_interaction()

## 连接建筑信号
func _connect_building_signals() -> void:
	for building in get_tree().get_nodes_in_group("building"):
		if building.has_signal("player_entered"):
			building.player_entered.connect(_on_building_entered)
		if building.has_signal("player_exited"):
			building.player_exited.connect(_on_building_exited)
		if building.has_signal("door_interacted"):
			building.door_interacted.connect(_on_building_door_interacted)

## 建筑进入回调
func _on_building_entered(building_id: String) -> void:
	print("进入建筑: ", building_id)

## 建筑离开回调
func _on_building_exited(building_id: String) -> void:
	print("离开建筑: ", building_id)

## 建筑门交互回调
func _on_building_door_interacted(building_id: String) -> void:
	print("门交互: ", building_id)

## 开始交互
func _start_interaction() -> void:
	if not nearby_interactable:
		return

	current_npc = nearby_interactable
	is_dialogue_active = true
	TimeManager.pause_time()

	var node_name: String = current_npc.name

	# 检查是否是 NPC
	var npc_id: String = ""
	if current_npc.has_method("get"):
		npc_id = current_npc.get("npc_id") if current_npc.has_method("get") else ""

	if npc_id != "":
		# 先检查事件引擎是否有触发事件
		var event_triggered: bool = false
		for event_id in EventEngine.events:
			var event: Dictionary = EventEngine.events[event_id]
			if event.get("trigger_type") == "npc" and event.get("trigger_npc") == npc_id:
				if EventEngine.try_trigger_event(event_id):
					event_triggered = true
					break

		# 如果没有事件触发，显示普通对话
		if not event_triggered:
			var dialogue_data: Dictionary = DialogueManager.get_npc_dialogue(npc_id)
			_show_dialogue(dialogue_data)
	else:
		# 地点交互 - 先检查事件引擎
		EventEngine.check_location_events(node_name)

		# 检查特殊地点
		if node_name == "School" and GameState.current_age >= 18 and not exam_taken:
			_start_exam()
		else:
			# 显示地点对话
			var dialogue_data: Dictionary = DialogueManager.get_location_dialogue(node_name)
			_show_dialogue(dialogue_data)

## 显示对话
func _show_dialogue(data: Dictionary) -> void:
	UIManager.show_dialogue(data)

## 推进对话（按空格时调用）
func _advance_dialogue() -> void:
	_on_dialogue_end()

## 对话结束
func _on_dialogue_end() -> void:
	is_dialogue_active = false
	current_npc = null
	UIManager.hide_dialogue()

## 开始高考
func _start_exam() -> void:
	is_dialogue_active = false
	if exam_minigame:
		exam_minigame.start_exam()
		exam_taken = true
		record_event("exam", "参加了高考", GameState.current_age)
		UIManager.show_notification("高考开始了！")

## 记录人生事件
func record_event(event_type: String, description: String, age: int) -> void:
	life_records.append({
		"type": event_type,
		"description": description,
		"age": age
	})

## 回家睡觉
func go_to_sleep() -> void:
	_on_dialogue_end()
	days_passed += 1

	GameState.modify_stat("health", 5)
	GameState.modify_stat("psychology", 5)

	if days_passed % days_per_year == 0:
		var new_age: int = GameState.current_age + 1
		if new_age <= 80:
			GameState.set_age(new_age)

	TimeManager.sleep()

	SaveSystem.save_game()
	UIManager.show_notification("新的一天开始了")

## 交互可用回调
func _on_interaction_available(node: Node2D) -> void:
	nearby_interactable = node

## 交互不可用回调
func _on_interaction_unavailable() -> void:
	nearby_interactable = null

## 时段变化回调
func _on_time_period_changed(_old_period: String, _new_period: String) -> void:
	pass

## 年龄变化回调
func _on_age_changed(_old_age: int, new_age: int) -> void:
	record_event("age_milestone", "你" + str(new_age) + "岁了", new_age)

	if new_age in key_ages:
		_show_age_event(new_age)

## 显示年龄事件
func _show_age_event(age: int) -> void:
	var events: Dictionary = {
		7: {"speaker": "旁白", "text": "你7岁了，开始上小学。"},
		12: {"speaker": "旁白", "text": "你12岁了，小学毕业。"},
		15: {"speaker": "旁白", "text": "你15岁了，升入高中。"},
		18: {"speaker": "旁白", "text": "你18岁了，高考在即。去学校参加高考吧！"},
		22: {"speaker": "旁白", "text": "你22岁了，大学毕业。"},
		25: {"speaker": "旁白", "text": "你25岁了，开始考虑人生大事。"},
		28: {"speaker": "旁白", "text": "你28岁了，人生进入新阶段。"},
		30: {"speaker": "旁白", "text": "你30岁了，三十而立。"}
	}

	if events.has(age):
		is_dialogue_active = true
		TimeManager.pause_time()
		_show_dialogue(events[age])
		record_event("age_milestone", events[age]["text"], age)

## 数值变化回调
func _on_stats_changed(_stat_name: String, _old_value: int, _new_value: int) -> void:
	pass  # UI 更新由 UIManager 和 StatsPanel 处理

## 新的一天回调
func _on_day_started() -> void:
	SaveSystem.save_game()

## 获取天数（供 SaveSystem 调用）
func get_days_passed() -> int:
	return days_passed

## 设置天数（供 SaveSystem 调用）
func set_days_passed(days: int) -> void:
	days_passed = days
