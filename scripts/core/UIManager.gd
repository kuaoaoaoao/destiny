## UIManager - UI 管理器
## 统一管理所有 UI 面板的显示/隐藏/切换
extends Node

## UI 面板引用（在 _ready 中动态获取）
var hud: CanvasLayer = null
var dialogue_box: CanvasLayer = null
var stats_panel: PanelContainer = null
var fate_book: CanvasLayer = null
var notification_label: Label = null

## UI 状态
var is_any_ui_open: bool = false
var current_ui_stack: Array[String] = []

## 通知队列
var notification_queue: Array[String] = []
var is_showing_notification: bool = false

## 信号
signal ui_opened(ui_name: String)
signal ui_closed(ui_name: String)
signal all_ui_closed()

func _ready() -> void:
	# 延迟获取 UI 引用（等待场景树初始化完成）
	call_deferred("_init_ui_references")
	# 连接事件引擎信号
	EventEngine.dialogue_started.connect(_on_event_dialogue_started)
	EventEngine.event_triggered.connect(_on_event_triggered)
	EventEngine.event_completed.connect(_on_event_completed)

func _input(event: InputEvent) -> void:
	# 按 ESC 关闭当前打开的 UI
	if event.is_action_pressed("open_stats"):
		if is_any_ui_open:
			_close_current_ui()
			get_viewport().set_input_as_handled()

func _init_ui_references() -> void:
	var main_scene = get_tree().current_scene
	if not main_scene:
		return

	# 获取独立 UI 场景引用
	hud = main_scene.get_node_or_null("HUD")
	dialogue_box = main_scene.get_node_or_null("DialogueBox")
	stats_panel = main_scene.get_node_or_null("StatsPanel")
	fate_book = main_scene.get_node_or_null("FateBook")

	# 获取通知标签引用（在 HUD 下）
	if hud:
		notification_label = hud.get_node_or_null("MarginContainer/NotificationLabel")
		# 如果没有 NotificationLabel，创建一个
		if not notification_label:
			notification_label = Label.new()
			notification_label.name = "NotificationLabel"
			notification_label.visible = false
			notification_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			notification_label.anchors_preset = Control.PRESET_CENTER_TOP
			notification_label.offset_top = 55
			notification_label.offset_bottom = 75
			hud.get_node("MarginContainer").add_child(notification_label)

	print("[UIManager] UI 引用初始化完成")
	print("  HUD: ", hud != null)
	print("  DialogueBox: ", dialogue_box != null)
	print("  StatsPanel: ", stats_panel != null)
	print("  FateBook: ", fate_book != null)

## 显示对话框
func show_dialogue(data: Dictionary) -> void:
	if dialogue_box:
		dialogue_box.visible = true
		# 通知 DialogueBox 显示对话
		if dialogue_box.has_method("show_dialogue"):
			dialogue_box.show_dialogue(data)
	_push_ui("dialogue")
	TimeManager.pause_time()

## 隐藏对话框
func hide_dialogue() -> void:
	if dialogue_box:
		if dialogue_box.has_method("hide_dialogue"):
			dialogue_box.hide_dialogue()
		dialogue_box.visible = false
	_pop_ui("dialogue")
	TimeManager.resume_time()

## 显示数值面板
func show_stats_panel() -> void:
	if stats_panel:
		stats_panel.visible = true
	_push_ui("stats")

## 隐藏数值面板
func hide_stats_panel() -> void:
	if stats_panel:
		stats_panel.visible = false
	_pop_ui("stats")

## 切换数值面板显示/隐藏
func toggle_stats_panel() -> void:
	if stats_panel:
		if stats_panel.visible:
			hide_stats_panel()
		else:
			show_stats_panel()

## 显示命运之书
func show_fate_book() -> void:
	if fate_book:
		fate_book.visible = true
	_push_ui("fate_book")
	TimeManager.pause_time()

## 隐藏命运之书
func hide_fate_book() -> void:
	if fate_book:
		fate_book.visible = false
	_pop_ui("fate_book")
	TimeManager.resume_time()

## 显示通知
func show_notification(text: String) -> void:
	notification_queue.append(text)
	if not is_showing_notification:
		_process_notification_queue()

## 处理通知队列
func _process_notification_queue() -> void:
	if notification_queue.is_empty():
		is_showing_notification = false
		return

	is_showing_notification = true
	if notification_label:
		notification_label.text = notification_queue.pop_front()
		notification_label.visible = true
		# Tween 淡入效果
		notification_label.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(notification_label, "modulate:a", 1.0, 0.3)
		await tween.finished

		await get_tree().create_timer(2.0).timeout

		# Tween 淡出效果
		var fade_tween = create_tween()
		fade_tween.tween_property(notification_label, "modulate:a", 0.0, 0.3)
		await fade_tween.finished

		notification_label.visible = false
		await get_tree().create_timer(0.3).timeout
		_process_notification_queue()

## 压入 UI 栈
func _push_ui(ui_name: String) -> void:
	if ui_name not in current_ui_stack:
		current_ui_stack.append(ui_name)
	is_any_ui_open = true
	ui_opened.emit(ui_name)

## 弹出 UI 栈
func _pop_ui(ui_name: String) -> void:
	if ui_name in current_ui_stack:
		current_ui_stack.erase(ui_name)
	is_any_ui_open = not current_ui_stack.is_empty()
	ui_closed.emit(ui_name)
	if not is_any_ui_open:
		all_ui_closed.emit()

## 关闭当前打开的 UI（按栈顺序）
func _close_current_ui() -> void:
	if current_ui_stack.is_empty():
		return

	var current_ui: String = current_ui_stack.back()
	match current_ui:
		"dialogue":
			hide_dialogue()
		"stats":
			hide_stats_panel()
		"fate_book":
			hide_fate_book()

## 关闭所有 UI
func close_all_ui() -> void:
	hide_dialogue()
	hide_stats_panel()
	hide_fate_book()
	current_ui_stack.clear()
	is_any_ui_open = false
	all_ui_closed.emit()

## 检查是否有 UI 打开
func has_open_ui() -> bool:
	return is_any_ui_open

## 获取当前打开的 UI 名称
func get_current_ui() -> String:
	if current_ui_stack.is_empty():
		return ""
	return current_ui_stack.back()

## 事件引擎回调：事件对话开始
func _on_event_dialogue_started(dialogue_data: Dictionary) -> void:
	show_dialogue(dialogue_data)

## 事件引擎回调：事件触发
func _on_event_triggered(event_id: String) -> void:
	print("[UIManager] 事件触发: ", event_id)

## 事件引擎回调：事件完成
func _on_event_completed(event_id: String) -> void:
	print("[UIManager] 事件完成: ", event_id)
