## 序章 - 命运之骰出生场景
extends Control

@onready var narrative_label: RichTextLabel = $VBoxContainer/NarrativeLabel
@onready var choice_container: VBoxContainer = $VBoxContainer/ChoiceContainer
@onready var continue_btn: Button = $VBoxContainer/ContinueButton

var backgrounds_data: Dictionary = {}
var selected_background: String = ""
var phase: int = 0  # 0=开场, 1=选择出身, 2=确认

func _ready() -> void:
	continue_btn.visible = false
	continue_btn.pressed.connect(_on_continue)
	_load_backgrounds()
	_show_prologue()

func _load_backgrounds() -> void:
	var file := FileAccess.open("res://data/backgrounds.json", FileAccess.READ)
	if file:
		var json := JSON.new()
		if json.parse(file.get_as_text()) == OK:
			backgrounds_data = json.data.get("backgrounds", {})

func _show_prologue() -> void:
	phase = 0
	narrative_label.text = "[center][font_size=24]序章 · 混沌[/font_size][/center]\n\n\n黑暗中，有什么在涌动。\n\n那是无数种人生的可能——\n有人生在富裕家庭，有人生在贫困山村；\n有人一生顺遂，有人坎坷不断；\n有人功成名就，有人默默无闻。\n\n现在，命运之骰即将掷出。\n你将开始一段全新的人生。\n\n你，准备好了吗？"
	continue_btn.visible = true
	continue_btn.text = "掷出命运之骰"
	phase = 0

func _on_continue() -> void:
	match phase:
		0:
			_show_background_selection()
		1:
			_confirm_background()
		2:
			_start_game()

func _show_background_selection() -> void:
	phase = 1
	continue_btn.visible = false
	narrative_label.text = "[center][font_size=24]命运之骰[/font_size][/center]\n\n\n骰子在空中旋转，尘埃落定——\n\n你将出生在什么样的家庭？"
	# 清空按钮
	for child in choice_container.get_children():
		child.queue_free()
	# 创建出身选项
	var bg_ids := backgrounds_data.keys()
	for bg_id in bg_ids:
		var bg: Dictionary = backgrounds_data[bg_id]
		var btn := Button.new()
		btn.text = "%s\n%s" % [bg["name"], bg["description"]]
		btn.add_theme_font_size_override("font_size", 16)
		btn.pressed.connect(_on_background_selected.bind(bg_id))
		choice_container.add_child(btn)

func _on_background_selected(bg_id: String) -> void:
	selected_background = bg_id
	phase = 1
	# 高亮选中的按钮
	for child in choice_container.get_children():
		child.modulate = Color.WHITE
	var idx := backgrounds_data.keys().find(bg_id)
	if idx >= 0 and idx < choice_container.get_child_count():
		choice_container.get_child(idx).modulate = Color(1, 0.9, 0.5)
	# 显示确认按钮
	continue_btn.visible = true
	continue_btn.text = "确认选择"

func _confirm_background() -> void:
	phase = 2
	if selected_background == "":
		# 随机选择
		var bg_ids := backgrounds_data.keys()
		selected_background = bg_ids[randi() % bg_ids.size()]
	var bg: Dictionary = backgrounds_data[selected_background]
	# 应用出身
	GameState.set_background(selected_background)
	# 设置初始标记
	if bg.has("starting_flags"):
		for flag in bg["starting_flags"]:
			GameState.set_flag(flag)
	# 初始化 NPC
	GameState.init_npc()
	# 显示出生叙事
	narrative_label.text = "[center][font_size=24]你的故事开始了[/font_size][/center]\n\n\n%s\n\n%s\n\n%s" % [
		bg.get("name", ""),
		bg.get("childhood_narrative", ""),
		bg.get("core_conflict", "")
	]
	# 清空选项
	for child in choice_container.get_children():
		child.queue_free()
	continue_btn.visible = true
	continue_btn.text = "开始你的人生"

func _start_game() -> void:
	# 设置初始年龄
	GameState.set_age(7)
	# 切换到主场景
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
