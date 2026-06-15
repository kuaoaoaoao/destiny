## DayNightCycle - 昼夜循环系统
## 借鉴 stardew-valley 的 CanvasModulate 实现动态光影
extends CanvasModulate

## 时间配置
@export var day_duration: float = 240.0  # 一天持续时间（秒）

## 时间段配置
@export var dawn_start: float = 0.2    # 黎明开始（0-1）
@export var dawn_duration: float = 0.1 # 黎明持续时间
@export var dusk_start: float = 0.7    # 黄昏开始
@export var dusk_duration: float = 0.1 # 黄昏持续时间

## 颜色配置
@export var dawn_color: Color = Color(1.0, 0.85, 0.7, 1.0)    # 黎明 - 温暖橙色
@export var day_color: Color = Color(1.0, 1.0, 1.0, 1.0)      # 白天 - 白色
@export var dusk_color: Color = Color(1.0, 0.75, 0.8, 1.0)    # 黄昏 - 粉色
@export var night_color: Color = Color(0.3, 0.3, 0.5, 1.0)    # 夜晚 - 深蓝色
@export var rain_color: Color = Color(0.5, 0.5, 0.6, 1.0)     # 雨天 - 灰蓝色

## 时间状态
var current_time: float = 0.0  # 当前时间（0-day_duration）
var is_raining: bool = false
var is_paused: bool = false

## 信号
signal time_changed(time_ratio: float)
signal period_changed(new_period: String)
signal day_started()
signal day_ended()

func _ready() -> void:
	# 初始化为白天
	current_time = day_duration * 0.5
	_update_color()

func _process(delta: float) -> void:
	if is_paused:
		return

	# 推进时间
	current_time += delta
	if current_time >= day_duration:
		_end_day()

	# 更新颜色
	_update_color()

	# 发射时间变化信号
	time_changed.emit(current_time / day_duration)

## 更新颜色
func _update_color() -> void:
	var time_ratio: float = current_time / day_duration
	var color: Color

	# 根据时间段计算颜色
	if time_ratio >= dawn_start and time_ratio < dawn_start + dawn_duration:
		# 黎明
		var blend: float = (time_ratio - dawn_start) / dawn_duration
		color = night_color.lerp(dawn_color, blend)
	elif time_ratio >= dawn_start + dawn_duration and time_ratio < dusk_start:
		# 白天
		color = day_color
	elif time_ratio >= dusk_start and time_ratio < dusk_start + dusk_duration:
		# 黄昏
		var blend: float = (time_ratio - dusk_start) / dusk_duration
		color = day_color.lerp(dusk_color, blend)
	else:
		# 夜晚
		color = night_color

	# 应用雨天效果
	if is_raining:
		color = color.lerp(rain_color, 0.5)

	# 应用颜色
	self.color = color

## 结束一天
func _end_day() -> void:
	day_ended.emit()
	current_time = 0.0
	day_started.emit()

## 设置时间
func set_time(new_time: float) -> void:
	current_time = clampf(new_time, 0.0, day_duration)
	_update_color()

## 设置时间比例
func set_time_ratio(ratio: float) -> void:
	current_time = ratio * day_duration
	_update_color()

## 获取当前时间段
func get_current_period() -> String:
	var time_ratio: float = current_time / day_duration
	if time_ratio >= dawn_start and time_ratio < dawn_start + dawn_duration:
		return "dawn"
	elif time_ratio >= dawn_start + dawn_duration and time_ratio < dusk_start:
		return "day"
	elif time_ratio >= dusk_start and time_ratio < dusk_start + dusk_duration:
		return "dusk"
	else:
		return "night"

## 设置下雨状态
func set_raining(raining: bool) -> void:
	is_raining = raining
	_update_color()

## 暂停时间
func pause_time() -> void:
	is_paused = true

## 恢复时间
func resume_time() -> void:
	is_paused = false

## 推进到下一天
func advance_to_next_day() -> void:
	_end_day()

## 获取格式化时间
func get_formatted_time() -> String:
	var time_ratio: float = current_time / day_duration
	var hours: int = int(time_ratio * 24)
	var minutes: int = int((time_ratio * 24 - hours) * 60)
	return "%02d:%02d" % [hours, minutes]
