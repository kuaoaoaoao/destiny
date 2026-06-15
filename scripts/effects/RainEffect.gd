## RainEffect - 雨天粒子效果
## 借鉴 stardew-valley 的雨滴和涟漪效果
extends Node2D

## 雨滴配置
@export var rain_intensity: int = 200  # 雨滴数量
@export var rain_speed: float = 300.0  # 雨滴速度
@export var rain_angle: float = 10.0   # 雨滴角度

## 涟漪配置
@export var ripple_intensity: int = 50  # 涟漪数量

## 节点引用
var rain_particles: GPUParticles2D = null
var ripple_particles: GPUParticles2D = null

## 状态
var is_active: bool = false

func _ready() -> void:
	# 创建雨滴粒子
	_create_rain_particles()

	# 创建涟漪粒子
	_create_ripple_particles()

	# 初始隐藏
	set_active(false)

## 创建雨滴粒子
func _create_rain_particles() -> void:
	rain_particles = GPUParticles2D.new()
	rain_particles.name = "RainParticles"
	rain_particles.amount = rain_intensity
	rain_particles.lifetime = 1.0
	rain_particles.process_material = _create_rain_material()
	rain_particles.emitting = false
	add_child(rain_particles)

## 创建涟漪粒子
func _create_ripple_particles() -> void:
	ripple_particles = GPUParticles2D.new()
	ripple_particles.name = "RippleParticles"
	ripple_particles.amount = ripple_intensity
	ripple_particles.lifetime = 0.5
	ripple_particles.process_material = _create_ripple_material()
	ripple_particles.emitting = false
	ripple_particles.z_index = -1  # 在地面之下
	add_child(ripple_particles)

## 创建雨滴材质
func _create_rain_material() -> ParticleProcessMaterial:
	var material = ParticleProcessMaterial.new()
	material.direction = Vector3(0, 1, 0)
	material.spread = rain_angle
	material.initial_velocity_min = rain_speed
	material.initial_velocity_max = rain_speed * 1.2
	material.gravity = Vector3(0, 200, 0)
	material.scale_min = 0.3
	material.scale_max = 0.6
	material.color = Color(0.7, 0.8, 1.0, 0.6)

	# 发射形状
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	material.emission_box_extents = Vector3(640, 0, 0)

	return material

## 创建涟漪材质
func _create_ripple_material() -> ParticleProcessMaterial:
	var material = ParticleProcessMaterial.new()
	material.direction = Vector3(0, 0, 0)
	material.spread = 180.0
	material.initial_velocity_min = 0.0
	material.initial_velocity_max = 0.0
	material.gravity = Vector3(0, 0, 0)
	material.scale_min = 0.5
	material.scale_max = 1.0
	material.color = Color(0.7, 0.8, 1.0, 0.3)

	# 发射形状
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	material.emission_box_extents = Vector3(640, 360, 0)

	return material

## 设置激活状态
func set_active(active: bool) -> void:
	is_active = active
	if rain_particles:
		rain_particles.emitting = active
	if ripple_particles:
		ripple_particles.emitting = active

## 设置雨强度
func set_intensity(intensity: int) -> void:
	rain_intensity = intensity
	if rain_particles:
		rain_particles.amount = intensity

## 获取是否激活
func get_is_active() -> bool:
	return is_active
