## FlashEffect - 闪光效果
## 借鉴 stardew-valley 的 FlashSprite2D 实现交互反馈
extends Sprite2D

## 闪光配置
@export var flash_color: Color = Color(1, 1, 1, 1)
@export var flash_duration: float = 0.2

## 着色器代码
const FLASH_SHADER = """
shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_amount);
	COLOR = color;
}
"""

## 状态
var is_flashing: bool = false

func _ready() -> void:
	# 创建着色器材质
	var shader = Shader.new()
	shader.code = FLASH_SHADER
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("flash_color", flash_color)
	self.material = material

## 闪光效果
func flash(duration: float = flash_duration, callback: Callable = func(): pass) -> void:
	if is_flashing:
		return

	is_flashing = true

	# 创建 Tween 动画
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/flash_amount", 1.0, duration * 0.5)
	tween.tween_callback(callback)
	tween.tween_property(material, "shader_parameter/flash_amount", 0.0, duration * 0.5)
	await tween.finished

	is_flashing = false

## 快速闪光（用于交互反馈）
func quick_flash() -> void:
	flash(0.1)

## 强闪光（用于重要事件）
func strong_flash() -> void:
	flash(0.3)

## 设置闪光颜色
func set_flash_color(color: Color) -> void:
	flash_color = color
	if material:
		material.set_shader_parameter("flash_color", color)
