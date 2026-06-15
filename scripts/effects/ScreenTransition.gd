## ScreenTransition - 屏幕过渡效果
## 提供各种场景切换和 UI 过渡效果
extends CanvasLayer

## 过渡类型
enum TransitionType {
	FADE_BLACK,
	FADE_WHITE,
	CIRCLE_WIPE,
	DIAMOND_WIPE
}

## 当前过渡状态
var is_transitioning: bool = false

## 信号
signal transition_started
signal transition_midpoint
signal transition_finished

func _ready() -> void:
	# 初始隐藏
	visible = false
	layer = 100  # 确保在最上层

## 执行过渡效果
func transition(type: TransitionType = TransitionType.FADE_BLACK, duration: float = 1.0) -> void:
	if is_transitioning:
		return

	is_transitioning = true
	visible = true
	transition_started.emit()

	match type:
		TransitionType.FADE_BLACK:
			await _fade_transition(Color.BLACK, duration)
		TransitionType.FADE_WHITE:
			await _fade_transition(Color.WHITE, duration)
		TransitionType.CIRCLE_WIPE:
			await _circle_wipe_transition(duration)
		TransitionType.DIAMOND_WIPE:
			await _diamond_wipe_transition(duration)

	is_transitioning = false
	visible = false
	transition_finished.emit()

## 淡入淡出过渡
func _fade_transition(color: Color, duration: float) -> void:
	# 创建全屏遮罩
	var overlay := ColorRect.new()
	overlay.color = color
	overlay.color.a = 0.0
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	# 淡入
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 1.0, duration / 2.0)
	await tween.finished

	transition_midpoint.emit()

	# 淡出
	tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, duration / 2.0)
	await tween.finished

	# 清理
	overlay.queue_free()

## 圆形擦除过渡
func _circle_wipe_transition(duration: float) -> void:
	# 创建 Shader
	var shader_code := """
	shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	float dist = distance(UV, center);
	float radius = progress * 1.5;
	float alpha = smoothstep(radius - 0.01, radius + 0.01, dist);
	COLOR = vec4(color.rgb, alpha * color.a);
}
"""

	var shader := Shader.new()
	shader.code = shader_code

	var shader_material := ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("progress", 0.0)
	shader_material.set_shader_parameter("center", Vector2(0.5, 0.5))
	shader_material.set_shader_parameter("color", Color.BLACK)

	# 创建全屏遮罩
	var overlay := ColorRect.new()
	overlay.material = shader_material
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	# 扩大圆形
	var tween := create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", 1.0, duration / 2.0)
	await tween.finished

	transition_midpoint.emit()

	# 缩小圆形
	tween = create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", 0.0, duration / 2.0)
	await tween.finished

	# 清理
	overlay.queue_free()

## 菱形擦除过渡
func _diamond_wipe_transition(duration: float) -> void:
	# 创建 Shader
	var shader_code := """
	shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 uv = UV - 0.5;
	float dist = abs(uv.x) + abs(uv.y);
	float diamond = progress * 1.5;
	float alpha = smoothstep(diamond - 0.01, diamond + 0.01, dist);
	COLOR = vec4(color.rgb, alpha * color.a);
}
"""

	var shader := Shader.new()
	shader.code = shader_code

	var shader_material := ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("progress", 0.0)
	shader_material.set_shader_parameter("color", Color.BLACK)

	# 创建全屏遮罩
	var overlay := ColorRect.new()
	overlay.material = shader_material
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	# 扩大菱形
	var tween := create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", 1.0, duration / 2.0)
	await tween.finished

	transition_midpoint.emit()

	# 缩小菱形
	tween = create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", 0.0, duration / 2.0)
	await tween.finished

	# 清理
	overlay.queue_free()
