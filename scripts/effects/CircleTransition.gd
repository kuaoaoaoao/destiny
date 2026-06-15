## CircleTransition - 圆形遮罩过渡效果
## 借鉴 stardew-valley 的 circle_mask shader
extends CanvasLayer

## 过渡配置
@export var transition_duration: float = 1.0
@export var center: Vector2 = Vector2(0.5, 0.5)
@export var mask_color: Color = Color(0, 0, 0, 1)

## 节点引用
var mask_rect: ColorRect = null
var shader_material: ShaderMaterial = null

## 状态
var is_transitioning: bool = false

## 信号
signal transition_started
signal transition_midpoint
signal transition_completed

func _ready() -> void:
	layer = 100  # 确保在最上层
	visible = false

	# 创建遮罩
	_create_mask()

## 创建遮罩
func _create_mask() -> void:
	# 加载着色器
	var shader = load("res://shader/circle_mask.gdshader")
	if not shader:
		push_warning("[CircleTransition] 着色器文件不存在")
		return

	# 创建着色器材质
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("progress", 1.0)
	shader_material.set_shader_parameter("center", center)
	shader_material.set_shader_parameter("color", mask_color)

	# 创建遮罩矩形
	mask_rect = ColorRect.new()
	mask_rect.name = "MaskRect"
	mask_rect.material = shader_material
	mask_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	mask_rect.color = Color(1, 1, 1, 1)
	add_child(mask_rect)

## 执行过渡
func transition(new_scene_path: String = "") -> void:
	if is_transitioning:
		return

	is_transitioning = true
	visible = true
	transition_started.emit()

	# 关闭遮罩（从外向内）
	await _animate_mask(1.0, 0.0)

	transition_midpoint.emit()

	# 切换场景
	if new_scene_path != "":
		get_tree().change_scene_to_file(new_scene_path)
		await get_tree().process_frame

	# 打开遮罩（从内向外）
	await _animate_mask(0.0, 1.0)

	is_transitioning = false
	visible = false
	transition_completed.emit()

## 动画遮罩
func _animate_mask(from: float, to: float) -> void:
	if not shader_material:
		return

	var tween = create_tween()
	tween.tween_method(_set_mask_progress, from, to, transition_duration / 2.0)
	await tween.finished

## 设置遮罩进度
func _set_mask_progress(value: float) -> void:
	if shader_material:
		shader_material.set_shader_parameter("progress", value)

## 快速过渡（用于场景切换）
func quick_transition(new_scene_path: String) -> void:
	transition_duration = 0.5
	await transition(new_scene_path)
	transition_duration = 1.0

## 慢速过渡（用于重要场景）
func slow_transition(new_scene_path: String) -> void:
	transition_duration = 1.5
	await transition(new_scene_path)
	transition_duration = 1.0
