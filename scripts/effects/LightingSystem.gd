## LightingSystem - 光影系统
## 管理昼夜光影变化，营造氛围
extends CanvasModulate

## 时间配置
@export var dawn_color: Color = Color(0.95, 0.85, 0.7, 1.0)      # 黎明
@export var day_color: Color = Color(1.0, 1.0, 1.0, 1.0)          # 白天
@export var dusk_color: Color = Color(0.9, 0.7, 0.5, 1.0)         # 黄昏
@export var night_color: Color = Color(0.3, 0.3, 0.5, 1.0)        # 夜晚

## 当前状态
var current_time: float = 0.0  # 0.0 - 1.0 表示一天的时间
var time_speed: float = 0.01   # 时间流逝速度

## 信号
signal time_changed(new_time: float)
signal period_changed(new_period: String)

func _ready() -> void:
	# 初始化为白天
	current_time = 0.5
	_update_color()

func _process(delta: float) -> void:
	# 推进时间
	current_time += delta * time_speed
	if current_time >= 1.0:
		current_time -= 1.0

	# 更新颜色
	_update_color()

	# 发射时间变化信号
	time_changed.emit(current_time)

## 更新颜色
func _update_color() -> void:
	var new_color: Color

	if current_time < 0.25:
		# 黎明
		new_color = dawn_color.lerp(day_color, current_time / 0.25)
	elif current_time < 0.75:
		# 白天
		new_color = day_color
	elif current_time < 0.85:
		# 黄昏
		new_color = day_color.lerp(dusk_color, (current_time - 0.75) / 0.1)
	else:
		# 夜晚
		new_color = dusk_color.lerp(night_color, (current_time - 0.85) / 0.15)

	# 应用颜色
	self.color = new_color

## 设置时间
func set_time(new_time: float) -> void:
	current_time = clampf(new_time, 0.0, 1.0)
	_update_color()

## 获取当前时段
func get_current_period() -> String:
	if current_time < 0.25:
		return "dawn"
	elif current_time < 0.75:
		return "day"
	elif current_time < 0.85:
		return "dusk"
	else:
		return "night"

## 设置时间流逝速度
func set_time_speed(speed: float) -> void:
	time_speed = speed

## 暂停时间
func pause_time() -> void:
	set_time_speed(0.0)

## 恢复时间
func resume_time() -> void:
	set_time_speed(0.01)
