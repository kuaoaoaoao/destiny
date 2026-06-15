## Player - 玩家控制脚本
## 支持 2.5D 移动、相机跟随、精灵图动画
extends CharacterBody2D

## 移动参数
@export var base_speed: float = 120.0
@export var run_speed: float = 180.0

## 年龄段修正系数
var age_modifiers := {
	7: 0.7,
	12: 0.85,
	15: 1.0,
	18: 1.1
}

## 当前状态
enum PlayerState { IDLE, WALK, RUN, INTERACT, WAIT }
var current_state: PlayerState = PlayerState.IDLE

## 方向
enum Direction { DOWN, LEFT, RIGHT, UP }
var current_direction: Direction = Direction.DOWN

## 精灵引用
@onready var sprite: Sprite2D = $Sprite
@onready var shadow: Sprite2D = $Shadow
@onready var camera: Camera2D = $Camera2D
@onready var interaction_area: Area2D = $InteractionArea

## 动画配置
const WALK_FRAMES := 6  # 行走动画使用 6 帧
const WALK_FRAME_START := 0  # 行走动画起始帧（每行的第 0 帧）

## 动画状态
var animation_time: float = 0.0
var animation_speed: float = 0.1  # 每帧时间（秒）
var current_walk_frame: int = 0
var is_moving: bool = false

## 交互
var nearby_interactable: Node2D = null

## 信号
signal interaction_available(node: Node2D)
signal interaction_unavailable()

func _ready() -> void:
	# 初始化精灵
	if sprite and sprite.texture:
		# 根据精灵图尺寸自动计算帧数
		var texture_width = sprite.texture.get_width()
		var texture_height = sprite.texture.get_height()
		# 假设每帧 48x48 像素
		var cols = texture_width / 48
		var rows = texture_height / 48
		sprite.hframes = cols
		sprite.vframes = rows
		_update_sprite_frame()

	# 连接交互区域信号
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_body_entered)
		interaction_area.body_exited.connect(_on_interaction_body_exited)

func _physics_process(delta: float) -> void:
	if current_state == PlayerState.WAIT or current_state == PlayerState.INTERACT:
		return

	# 处理输入
	var move_direction := Vector2.ZERO
	var is_running := Input.is_action_pressed("run")

	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		move_direction.y += 1
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1

	# 标准化方向（4 方向）
	if move_direction != Vector2.ZERO:
		move_direction = move_direction.normalized()
		if abs(move_direction.x) > abs(move_direction.y):
			move_direction.y = 0
		else:
			move_direction.x = 0
		move_direction = move_direction.normalized()

		# 更新方向
		_update_direction(move_direction)
		is_moving = true
	else:
		is_moving = false

	# 移动
	var speed := get_current_speed() * (run_speed / base_speed if is_running else 1.0)
	if is_moving:
		velocity = move_direction * speed
		current_state = PlayerState.RUN if is_running else PlayerState.WALK
		# 更新行走动画
		_update_walk_animation(delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * delta * 10)
		if velocity.length() < 5:
			current_state = PlayerState.IDLE
			# 重置到站立帧（每行的第 0 帧是站立姿态）
			current_walk_frame = 0
			_update_sprite_frame()

	move_and_slide()

## 更新方向
func _update_direction(direction: Vector2) -> void:
	if direction.y < 0:
		current_direction = Direction.UP
	elif direction.y > 0:
		current_direction = Direction.DOWN
	elif direction.x < 0:
		current_direction = Direction.LEFT
	elif direction.x > 0:
		current_direction = Direction.RIGHT

## 更新行走动画
func _update_walk_animation(delta: float) -> void:
	animation_time += delta
	var anim_speed := animation_speed * (0.7 if current_state == PlayerState.RUN else 1.0)
	if animation_time >= anim_speed:
		animation_time = 0.0
		current_walk_frame = (current_walk_frame + 1) % WALK_FRAMES
		_update_sprite_frame()

## 更新精灵帧
func _update_sprite_frame() -> void:
	if sprite:
		# 计算帧索引：行 * 每行帧数 + 列
		# 行走动画使用每行的前 6 帧（0-5）
		sprite.frame = current_direction * sprite.hframes + WALK_FRAME_START + current_walk_frame

## 获取当前速度
func get_current_speed() -> float:
	var modifier := 1.0
	var age := GameState.current_age
	if age_modifiers.has(age):
		modifier = age_modifiers[age]
	return base_speed * modifier

## 交互区域进入
func _on_interaction_body_entered(body: Node2D) -> void:
	if body.has_method("interact") or body.is_in_group("interactable"):
		nearby_interactable = body
		interaction_available.emit(body)

## 交互区域退出
func _on_interaction_body_exited(body: Node2D) -> void:
	if body == nearby_interactable:
		nearby_interactable = null
		interaction_unavailable.emit()

## 锁定控制
func lock_control() -> void:
	current_state = PlayerState.WAIT

## 解锁控制
func unlock_control() -> void:
	current_state = PlayerState.IDLE

## 设置玩家外观
func set_appearance(texture: Texture2D) -> void:
	if sprite:
		sprite.texture = texture

## 设置相机边界
func set_camera_limits(left: int, top: int, right: int, bottom: int) -> void:
	if camera:
		camera.limit_left = left
		camera.limit_top = top
		camera.limit_right = right
		camera.limit_bottom = bottom
