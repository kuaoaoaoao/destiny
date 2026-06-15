## GameState - 全局游戏状态
## 管理六大数值、年龄、出身、已触发事件
extends Node

## 六大数值
var stats := {
	"health": 80,      # 健康 HP
	"psychology": 70,  # 心理 MP
	"education": 30,   # 教育 ED
	"money": 40,       # 金钱 MG
	"social": 50,      # 社交 SC
	"family": 75       # 家庭 FM
}

## 当前年龄（岁）
var current_age: int = 7

## age 别名（兼容旧代码）
var age: int:
	get:
		return current_age
	set(value):
		set_age(value)

## 当前日内时段
var current_time_period: String = "morning"  # morning/afternoon/evening/night

## 出身背景
var background: String = "rural_normal"  # rural_normal/urban_middle/rich/poor

## 已触发事件ID列表
var triggered_events: Array[String] = []

## 游戏标志
var flags: Dictionary = {}

## NPC好感度
var affinity := {
	"xiaogang": 50,
	"xiaofang": 50,
	"dazhuang": 50
}

## 周目计数
var playthrough_count: int = 0

## 信号
signal stats_changed(stat_name: String, old_value: int, new_value: int)
signal age_changed(old_age: int, new_age: int)
signal background_changed(new_background: String)
# 注意：time_period_changed 信号由 TimeManager 统一管理，避免重复定义
signal stats_changed(stat_name: String, old_value: int, new_value: int)
signal age_changed(old_age: int, new_age: int)
# 注意：time_period_changed 信号由 TimeManager 统一管理，避免重复定义

## 修改数值
func modify_stat(stat_name: String, change: int) -> void:
	if not stats.has(stat_name):
		push_warning("Unknown stat: " + stat_name)
		return
	var old_value: int = stats[stat_name]
	stats[stat_name] = clampi(old_value + change, 0, 100)
	stats_changed.emit(stat_name, old_value, stats[stat_name])

## 批量修改数值
func modify_stats(changes: Dictionary) -> void:
	for stat_name in changes:
		modify_stat(stat_name, changes[stat_name])

## 获取数值
func get_stat(stat_name: String) -> int:
	return stats.get(stat_name, 0)

## 设置年龄
func set_age(new_age: int) -> void:
	var old_age := current_age
	current_age = new_age
	age_changed.emit(old_age, new_age)

## 设置时段（不发射信号，由 TimeManager 统一管理）
func set_time_period(period: String) -> void:
	current_time_period = period

## 标记事件已触发
func mark_event_triggered(event_id: String) -> void:
	if event_id not in triggered_events:
		triggered_events.append(event_id)

## 检查事件是否已触发
func is_event_triggered(event_id: String) -> bool:
	return event_id in triggered_events

## 修改好感度
func modify_affinity(npc_id: String, change: int) -> void:
	if affinity.has(npc_id):
		affinity[npc_id] = clampi(affinity[npc_id] + change, 0, 100)

## 获取好感度
func get_affinity(npc_id: String) -> int:
	return affinity.get(npc_id, 50)

## 重置游戏状态（新人生）
func reset() -> void:
	stats = {"health": 80, "psychology": 70, "education": 30, "money": 40, "social": 50, "family": 75}
	current_age = 7
	current_time_period = "morning"
	background = "rural_normal"
	triggered_events.clear()
	flags.clear()
	affinity = {"xiaogang": 50, "xiaofang": 50, "dazhuang": 50}

## 重置游戏（兼容旧接口）
func reset_game() -> void:
	reset()
	playthrough_count += 1

## 设置出身背景
func set_background(bg: String) -> void:
	background = bg
	background_changed.emit(bg)

## 设置游戏标志
func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value

## 获取游戏标志
func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

## 初始化 NPC
func init_npc() -> void:
	# 确保所有 NPC 好感度存在
	if not affinity.has("aqiang"):
		affinity["aqiang"] = 50
	if not affinity.has("lili"):
		affinity["lili"] = 50
	if not affinity.has("xiaomei"):
		affinity["xiaomei"] = 50

## 获取人生阶段名称
func get_stage_name() -> String:
	if current_age < 7:
		return "婴幼儿"
	elif current_age < 12:
		return "童年"
	elif current_age < 15:
		return "少年"
	elif current_age < 18:
		return "青年"
	elif current_age < 25:
		return "成年"
	elif current_age < 35:
		return "壮年"
	elif current_age < 50:
		return "中年"
	elif current_age < 65:
		return "晚年"
	else:
		return "老年"

## 获取出身背景名称
func get_background_name() -> String:
	match background:
		"rural_normal": return "乡村普通家庭"
		"urban_middle": return "城市中产家庭"
		"rich": return "富裕家庭"
		"poor": return "贫困家庭"
		_: return "未知背景"
