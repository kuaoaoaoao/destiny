## FateBook - 命运之书
## 记录和显示人生关键时刻
extends CanvasLayer

## 节点引用
@onready var info_label: Label = $PanelContainer/VBoxContainer/InfoLabel
@onready var entries_list: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/EntriesList
@onready var stats_summary: RichTextLabel = $PanelContainer/VBoxContainer/StatsSummary
@onready var close_button: Button = $PanelContainer/VBoxContainer/CloseButton

## 人生记录
var life_records: Array = []

func _ready() -> void:
	# 连接关闭按钮
	close_button.pressed.connect(_on_close_pressed)
	# 初始隐藏
	visible = false

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("open_stats"):
		_on_close_pressed()

## 显示命运之书
func show_fate_book() -> void:
	_update_display()
	visible = true

## 更新显示内容
func _update_display() -> void:
	# 更新基本信息
	if info_label:
		info_label.text = "出身: %s\n年龄: %d 岁" % [
			GameState.get_background_name(),
			GameState.current_age
		]

	# 清空旧条目
	if entries_list:
		for child in entries_list.get_children():
			child.queue_free()

	# 添加记录条目
	if entries_list:
		for record in life_records:
			var entry_label := Label.new()
			entry_label.text = "%d岁 - %s" % [record["age"], record["description"]]
			entry_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			entries_list.add_child(entry_label)

	# 更新数值摘要
	if stats_summary:
		stats_summary.text = "=== 当前数值 ===\n"
		stats_summary.text += "健康: %d\n" % GameState.get_stat("health")
		stats_summary.text += "心理: %d\n" % GameState.get_stat("psychology")
		stats_summary.text += "教育: %d\n" % GameState.get_stat("education")
		stats_summary.text += "金钱: %d\n" % GameState.get_stat("money")
		stats_summary.text += "社交: %d\n" % GameState.get_stat("social")
		stats_summary.text += "家庭: %d\n" % GameState.get_stat("family")

## 记录事件
func record_event(event_type: String, description: String, age: int) -> void:
	life_records.append({
		"type": event_type,
		"description": description,
		"age": age,
		"time": TimeManager.get_formatted_time()
	})

## 获取所有记录
func get_all_records() -> Array:
	return life_records

## 获取指定年龄的记录
func get_records_by_age(age: int) -> Array:
	var records = []
	for record in life_records:
		if record["age"] == age:
			records.append(record)
	return records

## 清空记录
func clear_records() -> void:
	life_records.clear()

## 生成人生摘要
func generate_summary() -> Dictionary:
	var summary = {
		"total_days": 0,
		"events_count": life_records.size(),
		"final_stats": GameState.stats.duplicate(),
		"final_age": GameState.current_age,
		"key_events": []
	}

	# 提取关键事件
	for record in life_records:
		if record["type"] in ["age_milestone", "exam", "career", "marriage"]:
			summary["key_events"].append(record)

	return summary

## 关闭命运之书
func _on_close_pressed() -> void:
	visible = false
	UIManager.hide_fate_book()
