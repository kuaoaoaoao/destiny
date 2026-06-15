## ActivityWheel - 活动选择轮盘
## 借鉴 stardew-valley 的工具选择 UI，实现活动快速选择
extends CanvasLayer

## 活动配置
var activities := [
	{"name": "学习", "icon": "📚", "effects": {"education": 5, "psychology": -3}},
	{"name": "休息", "icon": "😴", "effects": {"health": 5, "psychology": 5}},
	{"name": "社交", "icon": "💬", "effects": {"social": 5, "money": -5}},
	{"name": "运动", "icon": "⚽", "effects": {"health": 5, "psychology": 3}},
	{"name": "打工", "icon": "💼", "effects": {"money": 10, "psychology": -5}},
	{"name": "娱乐", "icon": "🎮", "effects": {"psychology": 8, "education": -3}}
]

## 配置
@export var display_duration: float = 2.0  # 显示持续时间
@export var icon_size: float = 40.0        # 图标大小
@export var radius: float = 80.0           # 轮盘半径

## 节点引用
var container: Control = null
var timer: Timer = null

## 状态
var current_index: int = 0
var is_visible: bool = false

## 信号
signal activity_selected(activity_index: int)
signal activity_confirmed(activity_index: int)

func _ready() -> void:
	layer = 10  # 确保在最上层
	visible = false

	# 创建容器
	_create_container()

	# 创建定时器
	_create_timer()

## 创建容器
func _create_container() -> void:
	container = Control.new()
	container.name = "ActivityContainer"
	container.set_anchors_preset(Control.PRESET_CENTER)
	add_child(container)

## 创建定时器
func _create_timer() -> void:
	timer = Timer.new()
	timer.name = "HideTimer"
	timer.wait_time = display_duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

## 显示活动轮盘
func show_wheel(selected_index: int = 0) -> void:
	current_index = selected_index
	is_visible = true
	visible = true

	# 清空容器
	for child in container.get_children():
		child.queue_free()

	# 创建活动图标
	for i in activities.size():
		var activity = activities[i]
		var angle: float = (i * 2 * PI) / activities.size() - PI / 2
		var pos: Vector2 = Vector2(cos(angle), sin(angle)) * radius

		# 创建图标按钮
		var btn = Button.new()
		btn.text = activity["icon"]
		btn.custom_minimum_size = Vector2(icon_size, icon_size)
		btn.position = pos - Vector2(icon_size / 2, icon_size / 2)
		btn.pressed.connect(_on_activity_selected.bind(i))

		# 高亮当前选择
		if i == current_index:
			btn.modulate = Color(1, 1, 0.5, 1)
		else:
			btn.modulate = Color(1, 1, 1, 0.8)

		container.add_child(btn)

	# 启动定时器
	timer.start()

## 隐藏活动轮盘
func hide_wheel() -> void:
	is_visible = false
	visible = false
	timer.stop()

## 选择活动
func _on_activity_selected(index: int) -> void:
	current_index = index
	activity_selected.emit(index)

	# 高亮选中的活动
	for i in container.get_child_count():
		var btn = container.get_child(i)
		if i == index:
			btn.modulate = Color(1, 1, 0.5, 1)
		else:
			btn.modulate = Color(1, 1, 1, 0.8)

	# 重新启动定时器
	timer.start()

## 确认活动
func confirm_activity() -> void:
	if current_index >= 0 and current_index < activities.size():
		activity_confirmed.emit(current_index)
		_apply_activity_effects(current_index)
		hide_wheel()

## 应用活动效果
func _apply_activity_effects(index: int) -> void:
	var activity = activities[index]
	var effects = activity["effects"]

	# 应用效果
	for stat_name in effects:
		GameState.modify_stat(stat_name, effects[stat_name])

	# 显示通知
	UIManager.show_notification("进行了%s活动" % activity["name"])

## 定时器超时
func _on_timer_timeout() -> void:
	hide_wheel()

## 获取当前活动
func get_current_activity() -> Dictionary:
	if current_index >= 0 and current_index < activities.size():
		return activities[current_index]
	return {}

## 切换到下一个活动
func next_activity() -> void:
	current_index = (current_index + 1) % activities.size()
	_update_highlight()

## 切换到上一个活动
func prev_activity() -> void:
	current_index = (current_index - 1 + activities.size()) % activities.size()
	_update_highlight()

## 更新高亮
func _update_highlight() -> void:
	for i in container.get_child_count():
		var btn = container.get_child(i)
		if i == current_index:
			btn.modulate = Color(1, 1, 0.5, 1)
		else:
			btn.modulate = Color(1, 1, 1, 0.8)
