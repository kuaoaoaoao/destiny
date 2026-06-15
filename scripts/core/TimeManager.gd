## TimeManager - 时间管理系统
## 管理日内时间（实时流逝）和人生年龄（节点推进）
extends Node

## 时间缩放系数
var time_scale: float = 5.0

## 当前游戏时间（分钟，0-1440）
var game_time: float = 360.0  # 6:00 AM

## 时段定义
const TIME_PERIODS := {
	"morning": [360, 600],    # 6:00-10:00
	"afternoon": [600, 1020], # 10:00-17:00
	"evening": [1020, 1200],  # 17:00-20:00
	"night": [1200, 1440]     # 20:00-24:00
}

## 关键日年龄列表
var key_day_ages: Array[int] = [7, 12, 15, 18]

## 当前状态
enum TimeState { MONTAGE, KEY_DAY, PAUSED }
var current_state: TimeState = TimeState.KEY_DAY

## 信号
signal time_period_changed(old_period: String, new_period: String)
signal age_reached(age: int)
signal day_started()
signal day_ended()
signal state_changed(new_state: TimeState)

func _ready() -> void:
	set_time_period_from_minutes()

func _process(delta: float) -> void:
	if current_state == TimeState.PAUSED:
		return
	
	if current_state == TimeState.KEY_DAY:
		advance_day_time(delta)
	elif current_state == TimeState.MONTAGE:
		advance_montage(delta)

## 推进日内时间
func advance_day_time(delta: float) -> void:
	game_time += delta * time_scale
	if game_time >= 1440.0:
		end_day()

## 蒙太奇推进
func advance_montage(delta: float) -> void:
	game_time += delta * time_scale * 100.0
	if game_time >= 1440.0:
		end_day()

## 结束一天
func end_day() -> void:
	day_ended.emit()
	game_time = 360.0  # 重置到早晨6点
	day_started.emit()
	set_time_period_from_minutes()

## 设置时段（TimeManager 是时间段管理的唯一入口）
func set_time_period_from_minutes() -> void:
	var new_period := "morning"
	for period in TIME_PERIODS:
		var range_arr: Array = TIME_PERIODS[period]
		if game_time >= range_arr[0] and game_time < range_arr[1]:
			new_period = period
			break

	if new_period != GameState.current_time_period:
		var old_period := GameState.current_time_period
		GameState.set_time_period(new_period)
		time_period_changed.emit(old_period, new_period)

## 推进年龄
func advance_age(new_age: int) -> void:
	var old_age := GameState.current_age
	GameState.set_age(new_age)
	age_reached.emit(new_age)
	
	# 检查是否是关键日
	if new_age in key_day_ages:
		enter_key_day()

## 进入关键日
func enter_key_day() -> void:
	current_state = TimeState.KEY_DAY
	state_changed.emit(current_state)

## 进入蒙太奇
func enter_montage() -> void:
	current_state = TimeState.MONTAGE
	state_changed.emit(current_state)

## 暂停时间
func pause_time() -> void:
	current_state = TimeState.PAUSED
	state_changed.emit(current_state)

## 恢复时间
func resume_time() -> void:
	current_state = TimeState.KEY_DAY
	state_changed.emit(current_state)

## 获取当前时段
func get_current_period() -> String:
	return GameState.current_time_period

## 获取格式化时间
func get_formatted_time() -> String:
	var hours := int(game_time / 60.0)
	var minutes := int(game_time) % 60
	return "%02d:%02d" % [hours, minutes]

## 回家睡觉（跳到次日早晨）
func sleep() -> void:
	day_ended.emit()
	game_time = 360.0
	set_time_period_from_minutes()
	day_started.emit()
	# 检查是否需要推进年龄
	check_age_progression()

## 检查年龄推进
func check_age_progression() -> void:
	# 每N天推进一岁（可配置）
	# MVP简化：关键日后直接推进到下一个关键日年龄
	var current := GameState.current_age
	for age in key_day_ages:
		if age > current:
			advance_age(age)
			return
	# 如果超过了所有关键日，推进到结束
	advance_age(80)
