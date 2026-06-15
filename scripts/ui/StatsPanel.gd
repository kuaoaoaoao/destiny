## 数值面板 UI
## 显示六大数值、年龄、阶段
## 支持 Tween 动画和正确的信号连接
extends PanelContainer

# ===== 节点引用 =====
@onready var age_label: Label = $VBoxContainer/AgeLabel
@onready var stage_label: Label = $VBoxContainer/StageLabel
@onready var background_label: Label = $VBoxContainer/BackgroundLabel
@onready var health_bar: ProgressBar = $VBoxContainer/Stats/HealthBar
@onready var psychology_bar: ProgressBar = $VBoxContainer/Stats/PsychologyBar
@onready var education_bar: ProgressBar = $VBoxContainer/Stats/EducationBar
@onready var money_bar: ProgressBar = $VBoxContainer/Stats/MoneyBar
@onready var social_bar: ProgressBar = $VBoxContainer/Stats/SocialBar
@onready var family_bar: ProgressBar = $VBoxContainer/Stats/FamilyBar

# ===== 配置 =====
@export var animation_duration: float = 0.5  # 数值变化动画时长

# ===== 数值变化指示器 =====
var change_indicators: Dictionary = {}

func _ready() -> void:
	# 连接正确的信号
	GameState.stats_changed.connect(_on_stats_changed)
	GameState.age_changed.connect(_on_age_changed)
	_update_all()

func _update_all() -> void:
	if age_label:
		age_label.text = "年龄: %d 岁" % GameState.current_age
	if stage_label:
		stage_label.text = "阶段: %s" % GameState.get_stage_name()
	if background_label:
		background_label.text = "出身: %s" % GameState.get_background_name()
	_update_bar(health_bar, "health")
	_update_bar(psychology_bar, "psychology")
	_update_bar(education_bar, "education")
	_update_bar(money_bar, "money")
	_update_bar(social_bar, "social")
	_update_bar(family_bar, "family")

func _update_bar(bar: ProgressBar, stat_name: String) -> void:
	if bar == null:
		return
	var new_value: int = GameState.get_stat(stat_name)
	var old_value: int = int(bar.value)

	# Tween 动画
	if old_value != new_value:
		var tween = create_tween()
		tween.tween_property(bar, "value", float(new_value), animation_duration)

	# 根据数值设置颜色
	if new_value < 20:
		bar.modulate = Color(1.0, 0.3, 0.3, 1.0)  # 红色
	elif new_value < 40:
		bar.modulate = Color(1.0, 0.8, 0.3, 1.0)  # 黄色
	else:
		bar.modulate = Color(1.0, 1.0, 1.0, 1.0)  # 白色

# ===== 显示数值变化指示器 =====
func _show_change_indicator(stat_name: String, change: int) -> void:
	var bar: ProgressBar = null
	match stat_name:
		"health": bar = health_bar
		"psychology": bar = psychology_bar
		"education": bar = education_bar
		"money": bar = money_bar
		"social": bar = social_bar
		"family": bar = family_bar

	if bar == null:
		return

	# 创建变化指示标签
	var indicator := Label.new()
	if change > 0:
		indicator.text = "+%d" % change
		indicator.modulate = Color(0.3, 1.0, 0.3, 1.0)  # 绿色
	else:
		indicator.text = "%d" % change
		indicator.modulate = Color(1.0, 0.3, 0.3, 1.0)  # 红色

	indicator.position = Vector2(bar.size.x + 10, 0)
	bar.add_child(indicator)

	# Tween 动画：向上飘动并淡出
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(indicator, "position:y", -30.0, 0.8)
	tween.tween_property(indicator, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(indicator.queue_free)

# ===== 信号回调 =====
func _on_stats_changed(stat_name: String, old_value: int, new_value: int) -> void:
	_update_all()
	# 显示变化指示器
	var change: int = new_value - old_value
	if change != 0:
		_show_change_indicator(stat_name, change)

func _on_age_changed(_old_age: int, _new_age: int) -> void:
	_update_all()
