## TransitionManager - 过渡管理器
## 管理场景切换和 UI 过渡效果
extends Node

## 过渡效果引用
var screen_transition: CanvasLayer = null

## 过渡类型
enum TransitionType {
	FADE_BLACK,
	FADE_WHITE,
	CIRCLE_WIPE,
	DIAMOND_WIPE
}

func _ready() -> void:
	# 延迟初始化
	call_deferred("_init_transition")

func _init_transition() -> void:
	# 创建过渡效果场景
	screen_transition = CanvasLayer.new()
	screen_transition.layer = 100
	screen_transition.name = "ScreenTransition"

	# 添加到场景树
	get_tree().root.add_child(screen_transition)

	# 添加过渡脚本
	var transition_script := load("res://scripts/effects/ScreenTransition.gd")
	if transition_script:
		screen_transition.set_script(transition_script)

	print("[TransitionManager] 过渡管理器初始化完成")

## 切换场景（带过渡效果）
func change_scene_with_transition(scene_path: String, transition_type: TransitionType = TransitionType.FADE_BLACK, duration: float = 1.0) -> void:
	if screen_transition and screen_transition.has_method("transition"):
		# 开始过渡
		await screen_transition.transition(transition_type, duration)

		# 切换场景
		get_tree().change_scene_to_file(scene_path)
	else:
		# 直接切换场景
		get_tree().change_scene_to_file(scene_path)

## 淡入淡出过渡
func fade_transition(duration: float = 1.0) -> void:
	if screen_transition and screen_transition.has_method("transition"):
		await screen_transition.transition(TransitionType.FADE_BLACK, duration)

## 圆形擦除过渡
func circle_wipe_transition(duration: float = 1.0) -> void:
	if screen_transition and screen_transition.has_method("transition"):
		await screen_transition.transition(TransitionType.CIRCLE_WIPE, duration)

## 菱形擦除过渡
func diamond_wipe_transition(duration: float = 1.0) -> void:
	if screen_transition and screen_transition.has_method("transition"):
		await screen_transition.transition(TransitionType.DIAMOND_WIPE, duration)
