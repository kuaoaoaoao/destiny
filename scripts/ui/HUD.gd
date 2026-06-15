## HUD - 抬头显示脚本
## 显示时间、年龄、位置、交互提示
## 在对话/菜单打开时自动隐藏
extends CanvasLayer

@onready var time_label: Label = $MarginContainer/TopBar/TimeLabel
@onready var age_label: Label = $MarginContainer/TopBar/AgeLabel
@onready var location_label: Label = $MarginContainer/TopBar/LocationLabel
@onready var day_label: Label = $MarginContainer/TopBar/DayLabel
@onready var interaction_hint: Label = $MarginContainer/InteractionHint
@onready var notification_label: Label = $MarginContainer/NotificationLabel

# ===== 时段名称映射 =====
const PERIOD_NAMES := {
	"morning": "早晨",
	"afternoon": "下午",
	"evening": "傍晚",
	"night": "夜晚"
}

# ===== 时段图标映射（可选，如果有时段图标节点） =====
const PERIOD_ICONS := {
	"morning": "☀️",
	"afternoon": "🌤️",
	"evening": "🌅",
	"night": "🌙"
}

func _ready() -> void:
	# 连接信号
	GameState.age_changed.connect(_on_age_changed)
	TimeManager.time_period_changed.connect(_on_time_period_changed)

	# 连接玩家交互信号
	var player = get_tree().get_first_node_in_group("player")
	if player:
		if player.has_signal("interaction_available"):
			player.interaction_available.connect(_on_interaction_available)
		if player.has_signal("interaction_unavailable"):
			player.interaction_unavailable.connect(_on_interaction_unavailable)

	# 连接 UIManager 信号（UI 打开时隐藏 HUD）
	UIManager.ui_opened.connect(_on_ui_opened)
	UIManager.all_ui_closed.connect(_on_all_ui_closed)

	# 初始化显示
	_update_time_display()
	_update_age_display()

func _process(_delta: float) -> void:
	# 更新时间显示
	_update_time_display()

## 更新时间显示
func _update_time_display() -> void:
	if time_label:
		var period: String = GameState.current_time_period
		var period_name: String = PERIOD_NAMES.get(period, period)
		var icon: String = PERIOD_ICONS.get(period, "")
		time_label.text = "%s %s %s" % [icon, TimeManager.get_formatted_time(), period_name]

## 更新年龄显示
func _update_age_display() -> void:
	if age_label:
		age_label.text = "%d 岁" % GameState.current_age

## 更新天数显示
func update_day_display(days: int) -> void:
	if day_label:
		day_label.text = "第 %d 天" % days

## 更新位置显示
func update_location(location_name: String) -> void:
	if location_label:
		location_label.text = location_name

## 年龄变化
func _on_age_changed(_old_age: int, new_age: int) -> void:
	_update_age_display()

## 时段变化
func _on_time_period_changed(_old_period: String, _new_period: String) -> void:
	_update_time_display()

## 交互可用
func _on_interaction_available(node: Node2D) -> void:
	if interaction_hint:
		var hint_text: String = _get_interaction_hint_text(node)
		interaction_hint.text = hint_text
		interaction_hint.visible = true

## 交互不可用
func _on_interaction_unavailable() -> void:
	if interaction_hint:
		interaction_hint.visible = false

## 获取交互提示文本
func _get_interaction_hint_text(node: Node2D) -> String:
	var node_name: String = node.name
	var hint: String = "[空格] "

	# 检查是否是 NPC
	var npc_id: String = ""
	if node.has_method("get"):
		npc_id = node.get("npc_id") if node.has_method("get") else ""

	if npc_id != "":
		match npc_id:
			"xiaogang": hint += "和小刚聊天"
			"xiaofang": hint += "和小芳聊天"
			"dazhuang": hint += "和大壮聊天"
			_: hint += "交谈"
	else:
		# 检查是否是地点
		match node_name:
			"Home": hint += "回家"
			"School": hint += "学校"
			"OldTree": hint += "老槐树"
			"Shop": hint += "小卖部"
			_: hint += "互动"

	return hint

## UI 打开时隐藏 HUD
func _on_ui_opened(_ui_name: String) -> void:
	visible = false

## 所有 UI 关闭时显示 HUD
func _on_all_ui_closed() -> void:
	visible = true
