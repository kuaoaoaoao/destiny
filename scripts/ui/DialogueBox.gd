## 对话框系统
## 显示 NPC 对话、旁白、选择
## 与 UIManager 和 EventEngine 集成
extends CanvasLayer

# ===== 节点引用 =====
@onready var panel: PanelContainer = $PanelContainer
@onready var name_label: Label = $PanelContainer/VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $PanelContainer/VBoxContainer/TextLabel
@onready var continue_hint: Label = $PanelContainer/VBoxContainer/ContinueHint
@onready var choice_container: VBoxContainer = $PanelContainer/VBoxContainer/ChoiceContainer
@onready var typewriter_timer: Timer = $TypewriterTimer

# ===== 配置 =====
@export var typewriter_speed: float = 0.05  # 打字机速度（秒/字）

# ===== 状态 =====
var is_showing: bool = false
var full_text: String = ""
var current_char_index: int = 0
var waiting_for_input: bool = false
var current_choices: Array = []
var current_effects: Dictionary = {}

# ===== 信号 =====
signal dialogue_finished
signal choice_made(choice_index: int, effects: Dictionary)

func _ready() -> void:
	hide_dialogue()
	typewriter_timer.timeout.connect(_on_typewriter_tick)
	# 连接事件引擎信号
	EventEngine.event_choice_required.connect(_on_event_choice_required)

func _input(event: InputEvent) -> void:
	if not is_showing:
		return
	if event.is_action_pressed("interact"):
		if current_char_index < full_text.length():
			# 跳过打字机效果，直接显示全文
			text_label.text = full_text
			current_char_index = full_text.length()
			typewriter_timer.stop()
			if current_choices.is_empty():
				_show_continue_hint()
		elif waiting_for_input:
			if current_choices.is_empty():
				hide_dialogue()
				dialogue_finished.emit()

# ===== 显示对话（兼容旧接口） =====
func show_dialogue_legacy(speaker_name: String, text: String, choices: Array = []) -> void:
	is_showing = true
	visible = true
	panel.visible = true
	name_label.text = speaker_name
	full_text = text
	current_char_index = 0
	text_label.text = ""
	current_choices = choices
	current_effects = {}
	waiting_for_input = false
	continue_hint.visible = false
	# 清空选择按钮
	_clear_choice_buttons()
	# 开始打字机效果
	typewriter_timer.wait_time = typewriter_speed
	typewriter_timer.start()

# ===== 显示对话（新接口，接收 Dictionary 数据） =====
func show_dialogue(data: Dictionary) -> void:
	var speaker_name: String = data.get("speaker", "")
	var text: String = data.get("text", "")
	var choices: Array = data.get("options", [])
	var effects: Dictionary = data.get("effects", {})

	is_showing = true
	visible = true
	panel.visible = true
	name_label.text = speaker_name
	full_text = text
	current_char_index = 0
	text_label.text = ""
	current_choices = choices
	current_effects = effects
	waiting_for_input = false
	continue_hint.visible = false
	# 清空选择按钮
	_clear_choice_buttons()
	# 开始打字机效果
	typewriter_timer.wait_time = typewriter_speed
	typewriter_timer.start()

func show_simple_dialogue(speaker_name: String, text: String) -> void:
	show_dialogue_legacy(speaker_name, text, [])

func show_narrative(text: String) -> void:
	show_dialogue_legacy("旁白", text, [])

func show_choice_dialogue(speaker_name: String, text: String, choices: Array, effects: Dictionary = {}) -> void:
	current_effects = effects
	show_dialogue_legacy(speaker_name, text, choices)

# ===== 打字机效果 =====
func _on_typewriter_tick() -> void:
	if current_char_index < full_text.length():
		current_char_index += 1
		text_label.text = full_text.left(current_char_index)
	else:
		typewriter_timer.stop()
		if current_choices.is_empty():
			_show_continue_hint()
		else:
			_show_choices()

# ===== 显示继续提示 =====
func _show_continue_hint() -> void:
	continue_hint.text = "[ 按空格继续 ]"
	continue_hint.visible = true
	waiting_for_input = true

# ===== 显示选项 =====
func _show_choices() -> void:
	_clear_choice_buttons()
	for i in current_choices.size():
		var choice: Dictionary = current_choices[i]
		var btn := Button.new()
		btn.text = choice.get("text", "选项 %d" % (i + 1))
		btn.add_theme_font_size_override("font_size", 18)
		btn.pressed.connect(_on_choice_selected.bind(i))
		# 检查选项条件
		if choice.has("conditions"):
			var can_choose := true
			for cond in choice["conditions"]:
				if not EventEngine._eval_condition(cond):
					can_choose = false
					break
			if not can_choose:
				btn.disabled = true
				btn.text += " (条件不足)"
		choice_container.add_child(btn)
	choice_container.visible = true
	continue_hint.visible = false

func _clear_choice_buttons() -> void:
	for child in choice_container.get_children():
		child.queue_free()
	choice_container.visible = false

func _on_choice_selected(choice_index: int) -> void:
	var choice: Dictionary = current_choices[choice_index]
	# 应用选择效果
	var effects: Dictionary = choice.get("effects", {})
	if not effects.is_empty():
		GameState.modify_stats(effects)
	# 应用好感度效果
	if choice.has("affinity"):
		for npc_id in choice["affinity"]:
			GameState.modify_affinity(npc_id, choice["affinity"][npc_id])
	# 应用动作
	var action: String = choice.get("action", "")
	# 显示选择结果
	var result_text: String = choice.get("result_text", "")
	if result_text != "":
		show_dialogue_legacy("", result_text, [])
	else:
		hide_dialogue()
		dialogue_finished.emit()
	choice_made.emit(choice_index, effects)
	# 处理动作（在对话框关闭后执行）
	if action != "":
		_handle_action(action)

# ===== 处理动作 =====
func _handle_action(action: String) -> void:
	match action:
		"sleep":
			# 通知 UIManager 或 Main 场景处理睡觉
			get_tree().call_group("game_controllers", "go_to_sleep")
		"fate_book":
			UIManager.show_fate_book()
		"stats":
			UIManager.show_stats_panel()

# ===== 事件回调 =====
func _on_event_choice_required(event_id: String, choices: Array) -> void:
	var event_data: Dictionary = EventEngine.events_data.get(event_id, {})
	var narrative: String = event_data.get("narrative", "")
	show_choice_dialogue("旁白", narrative, choices)

# ===== 隐藏 =====
func hide_dialogue() -> void:
	is_showing = false
	panel.visible = false
	continue_hint.visible = false
	_clear_choice_buttons()
	current_choices = []
	current_effects = {}
	waiting_for_input = false
	typewriter_timer.stop()
	visible = false
