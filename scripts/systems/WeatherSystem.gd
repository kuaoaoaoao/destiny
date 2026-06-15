## WeatherSystem - 天气系统
## 管理天气变化，影响游戏氛围和 NPC 行为
extends Node

## 天气类型
enum WeatherType {
	SUNNY,    # 晴天
	CLOUDY,   # 多云
	RAINY,    # 雨天
	STORMY    # 暴风雨
}

## 当前天气
var current_weather: WeatherType = WeatherType.SUNNY
var weather_duration: float = 0.0
var weather_timer: float = 0.0

## 天气配置
var weather_config := {
	WeatherType.SUNNY: {
		"name": "晴天",
		"icon": "☀️",
		"light_modifier": 1.0,
		"speed_modifier": 1.0,
		"mood_modifier": 5,
		"probability": 0.4
	},
	WeatherType.CLOUDY: {
		"name": "多云",
		"icon": "☁️",
		"light_modifier": 0.8,
		"speed_modifier": 1.0,
		"mood_modifier": 0,
		"probability": 0.3
	},
	WeatherType.RAINY: {
		"name": "雨天",
		"icon": "🌧️",
		"light_modifier": 0.6,
		"speed_modifier": 0.8,
		"mood_modifier": -5,
		"probability": 0.2
	},
	WeatherType.STORMY: {
		"name": "暴风雨",
		"icon": "⛈️",
		"light_modifier": 0.4,
		"speed_modifier": 0.6,
		"mood_modifier": -10,
		"probability": 0.1
	}
}

## 天气效果节点
var rain_particles: GPUParticles2D = null
var cloud_overlay: ColorRect = null

## 信号
signal weather_changed(new_weather: WeatherType, old_weather: WeatherType)

func _ready() -> void:
	# 初始化天气
	_change_weather(WeatherType.SUNNY)

	# 连接时间信号
	TimeManager.time_period_changed.connect(_on_time_period_changed)

	# 初始化天气效果
	_init_weather_effects()

func _process(delta: float) -> void:
	# 更新天气计时器
	weather_timer += delta
	if weather_timer >= weather_duration:
		weather_timer = 0.0
		_randomize_weather()

## 初始化天气效果
func _init_weather_effects() -> void:
	# 创建雨滴粒子效果
	rain_particles = GPUParticles2D.new()
	rain_particles.name = "RainParticles"
	rain_particles.emitting = false
	rain_particles.amount = 200
	rain_particles.lifetime = 1.0
	rain_particles.process_material = _create_rain_material()
	add_child(rain_particles)

	# 创建云层覆盖
	cloud_overlay = ColorRect.new()
	cloud_overlay.name = "CloudOverlay"
	cloud_overlay.color = Color(0.5, 0.5, 0.6, 0.0)
	cloud_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	cloud_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(cloud_overlay)

## 创建雨滴材质
func _create_rain_material() -> ParticleProcessMaterial:
	var material = ParticleProcessMaterial.new()
	material.direction = Vector3(0, 1, 0)
	material.spread = 10.0
	material.initial_velocity_min = 200.0
	material.initial_velocity_max = 300.0
	material.gravity = Vector3(0, 500, 0)
	material.scale_min = 0.5
	material.scale_max = 1.0
	return material

## 随机化天气
func _randomize_weather() -> void:
	var rand_val = randf()
	var cumulative = 0.0
	var new_weather = WeatherType.SUNNY

	for weather_type in weather_config:
		cumulative += weather_config[weather_type]["probability"]
		if rand_val <= cumulative:
			new_weather = weather_type
			break

	_change_weather(new_weather)

## 改变天气
func _change_weather(new_weather: WeatherType) -> void:
	var old_weather = current_weather
	current_weather = new_weather

	# 设置天气持续时间（2-5 分钟）
	weather_duration = randf_range(120.0, 300.0)
	weather_timer = 0.0

	# 更新天气效果
	_update_weather_effects()

	# 发射天气变化信号
	weather_changed.emit(new_weather, old_weather)

	# 通知 UI
	var config = weather_config[new_weather]
	UIManager.show_notification("天气变化: " + config["icon"] + " " + config["name"])

## 更新天气效果
func _update_weather_effects() -> void:
	var config = weather_config[current_weather]

	# 更新雨滴效果
	if rain_particles:
		rain_particles.emitting = (current_weather == WeatherType.RAINY or current_weather == WeatherType.STORMY)

	# 更新云层覆盖
	if cloud_overlay:
		var alpha = 0.0
		match current_weather:
			WeatherType.CLOUDY:
				alpha = 0.1
			WeatherType.RAINY:
				alpha = 0.2
			WeatherType.STORMY:
				alpha = 0.3
		cloud_overlay.color = Color(0.5, 0.5, 0.6, alpha)

	# 更新光照
	var lighting = get_tree().get_first_node_in_group("lighting_system")
	if lighting and lighting.has_method("set_light_modifier"):
		lighting.set_light_modifier(config["light_modifier"])

## 获取当前天气名称
func get_weather_name() -> String:
	return weather_config[current_weather]["name"]

## 获取当前天气图标
func get_weather_icon() -> String:
	return weather_config[current_weather]["icon"]

## 获取速度修正
func get_speed_modifier() -> float:
	return weather_config[current_weather]["speed_modifier"]

## 获取心情修正
func get_mood_modifier() -> int:
	return weather_config[current_weather]["mood_modifier"]

## 检查是否在下雨
func is_raining() -> bool:
	return current_weather == WeatherType.RAINY or current_weather == WeatherType.STORMY

## 设置天气（供外部调用）
func set_weather(weather_type: WeatherType) -> void:
	_change_weather(weather_type)

## 时段变化回调
func _on_time_period_changed(_old: String, _new: String) -> void:
	# 30% 概率在时段变化时改变天气
	if randf() < 0.3:
		_randomize_weather()
