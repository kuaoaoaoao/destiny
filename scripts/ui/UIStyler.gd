## UIStyler - UI 样式管理器
## 为 UI 元素添加统一的样式和动画效果
extends Node

## 样式配置
var style_config := {
	"panel_bg": Color(0.15, 0.12, 0.1, 0.9),
	"panel_border": Color(0.4, 0.35, 0.3, 0.8),
	"button_normal": Color(0.35, 0.3, 0.25, 0.9),
	"button_hover": Color(0.45, 0.4, 0.35, 0.95),
	"button_pressed": Color(0.25, 0.2, 0.15, 0.9),
	"text_primary": Color(0.95, 0.93, 0.88, 1),
	"text_secondary": Color(0.8, 0.75, 0.7, 1),
	"text_accent": Color(0.9, 0.85, 0.7, 1),
	"progress_bg": Color(0.2, 0.18, 0.15, 0.8),
	"progress_fill": Color(0.6, 0.55, 0.5, 0.9),
	"shadow": Color(0, 0, 0, 0.3)
}

## 动画配置
var animation_config := {
	"fade_duration": 0.3,
	"slide_duration": 0.2,
	"scale_duration": 0.1,
	"bounce_duration": 0.15
}

func _ready() -> void:
	# 注册到 UI 样式管理器组
	add_to_group("ui_styler")

## 创建面板样式
func create_panel_style(bg_color: Color = style_config["panel_bg"],
						border_color: Color = style_config["panel_border"]) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	style.shadow_color = style_config["shadow"]
	style.shadow_size = 4
	style.shadow_offset = Vector2(2, 2)
	style.content_margin_left = 10
	style.content_margin_top = 10
	style.content_margin_right = 10
	style.content_margin_bottom = 10
	return style

## 创建按钮样式
func create_button_style(state: String = "normal") -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	var color: Color

	match state:
		"normal":
			color = style_config["button_normal"]
		"hover":
			color = style_config["button_hover"]
		"pressed":
			color = style_config["button_pressed"]
		_:
			color = style_config["button_normal"]

	style.bg_color = color
	style.border_color = style_config["panel_border"]
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	style.content_margin_left = 8
	style.content_margin_top = 4
	style.content_margin_right = 8
	style.content_margin_bottom = 4
	return style

## 创建进度条样式
func create_progress_bar_style(is_fill: bool = false) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()

	if is_fill:
		style.bg_color = style_config["progress_fill"]
		style.corner_radius_top_left = 3
		style.corner_radius_top_right = 3
		style.corner_radius_bottom_right = 3
		style.corner_radius_bottom_left = 3
	else:
		style.bg_color = style_config["progress_bg"]
		style.border_color = style_config["panel_border"]
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1
		style.corner_radius_top_left = 4
		style.corner_radius_top_right = 4
		style.corner_radius_bottom_right = 4
		style.corner_radius_bottom_left = 4

	return style

## 应用淡入动画
func fade_in(node: Control, duration: float = animation_config["fade_duration"]) -> void:
	if not node:
		return

	node.modulate.a = 0.0
	node.visible = true

	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

## 应用淡出动画
func fade_out(node: Control, duration: float = animation_config["fade_duration"]) -> void:
	if not node:
		return

	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	await tween.finished
	node.visible = false

## 应用滑入动画
func slide_in(node: Control, direction: String = "left",
			  duration: float = animation_config["slide_duration"]) -> void:
	if not node:
		return

	var original_position = node.position
	var offset: Vector2

	match direction:
		"left":
			offset = Vector2(-100, 0)
		"right":
			offset = Vector2(100, 0)
		"top":
			offset = Vector2(0, -50)
		"bottom":
			offset = Vector2(0, 50)
		_:
			offset = Vector2(-100, 0)

	node.position = original_position + offset
	node.visible = true

	var tween = create_tween()
	tween.tween_property(node, "position", original_position, duration)

## 应用缩放动画
func scale_bounce(node: Control, duration: float = animation_config["bounce_duration"]) -> void:
	if not node:
		return

	var original_scale = node.scale
	node.scale = Vector2(0.8, 0.8)

	var tween = create_tween()
	tween.tween_property(node, "scale", original_scale, duration)

## 应用摇晃动画
func shake(node: Control, intensity: float = 5.0,
		   duration: float = animation_config["bounce_duration"]) -> void:
	if not node:
		return

	var original_position = node.position
	var shake_count = 3

	for i in shake_count:
		var offset = Vector2(randf_range(-intensity, intensity), 0)
		node.position = original_position + offset
		await get_tree().create_timer(duration / shake_count).timeout

	node.position = original_position

## 应用脉冲动画
func pulse(node: Control, scale_factor: float = 1.1,
		   duration: float = animation_config["bounce_duration"]) -> void:
	if not node:
		return

	var original_scale = node.scale

	var tween = create_tween()
	tween.tween_property(node, "scale", original_scale * scale_factor, duration / 2)
	tween.tween_property(node, "scale", original_scale, duration / 2)

## 设置面板样式
func apply_panel_style(panel: PanelContainer) -> void:
	if panel:
		panel.add_theme_stylebox_override("panel", create_panel_style())

## 设置按钮样式
func apply_button_style(button: Button) -> void:
	if button:
		button.add_theme_stylebox_override("normal", create_button_style("normal"))
		button.add_theme_stylebox_override("hover", create_button_style("hover"))
		button.add_theme_stylebox_override("pressed", create_button_style("pressed"))
		button.add_theme_stylebox_override("focus", create_button_style("hover"))

## 设置进度条样式
func apply_progress_bar_style(progress_bar: ProgressBar) -> void:
	if progress_bar:
		progress_bar.add_theme_stylebox_override("background", create_progress_bar_style(false))
		progress_bar.add_theme_stylebox_override("fill", create_progress_bar_style(true))

## 设置标签样式
func apply_label_style(label: Label, color: Color = style_config["text_primary"],
					   font_size: int = 16) -> void:
	if label:
		label.add_theme_color_override("font_color", color)
		label.add_theme_font_size_override("font_size", font_size)
