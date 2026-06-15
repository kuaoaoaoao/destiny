## NPC - NPC基础脚本
## 支持精灵图动画、日程系统、天气响应、随机行为
extends CharacterBody2D

## NPC属性
@export var npc_id: String = "xiaogang"
@export var npc_name: String = "小刚"
@export var base_speed: float = 60.0

## NPC 精灵图配置（不同 NPC 使用不同的精灵图）
var npc_sprites := {
	"xiaogang": "res://assets/sprites/npc/red.png",      # 小刚 - 红色（活泼）
	"xiaofang": "res://assets/sprites/npc/basic.png",    # 小芳 - 基础色（温柔）
	"dazhuang": "res://assets/sprites/npc/blue.png",     # 大壮 - 蓝色（稳重）
	"aqiang": "res://assets/sprites/npc/grey.png",       # 阿强 - 灰色（勤劳）
	"lili": "res://assets/sprites/npc/straw.png",        # 莉莉 - 草帽（聪明）
	"xiaomei": "res://assets/sprites/npc/cowboy.png",    # 小美 - 牛仔（独立）
	"mother": "res://assets/sprites/npc/basic.png",      # 妈妈 - 基础色
	"father": "res://assets/sprites/npc/blue.png",       # 爸爸 - 蓝色
	"teacher": "res://assets/sprites/npc/grey.png"       # 王老师 - 灰色
}

## NPC 颜色配置（用于进一步区分）
var npc_colors := {
	"xiaogang": Color(1.0, 0.9, 0.8, 1),   # 暖色调
	"xiaofang": Color(1.0, 0.85, 0.9, 1),  # 粉色调
	"dazhuang": Color(0.85, 0.95, 0.85, 1), # 绿色调
	"aqiang": Color(0.8, 0.85, 1.0, 1),    # 蓝色调
	"lili": Color(0.95, 0.85, 1.0, 1),      # 紫色调
	"xiaomei": Color(0.85, 1.0, 0.85, 1),  # 浅绿色调
	"mother": Color(1.0, 0.9, 0.85, 1),    # 肤色调
	"father": Color(0.85, 0.8, 0.75, 1),   # 棕色调
	"teacher": Color(0.8, 0.85, 0.9, 1)    # 灰蓝色调
}

## 方向
enum Direction { DOWN, LEFT, RIGHT, UP }
var current_direction: Direction = Direction.DOWN

## 状态
enum NPCState { IDLE, WALKING, TALKING, WORKING }
var current_state: NPCState = NPCState.IDLE

## 精灵引用
@onready var sprite: Sprite2D = $Sprite
@onready var name_label: Label = $NameLabel

## 动画配置
const WALK_FRAMES := 6  # 行走动画使用 6 帧
const WALK_FRAME_START := 0  # 行走动画起始帧

## 动画状态
var animation_time: float = 0.0
var animation_speed: float = 0.15  # 每帧时间（比玩家慢）
var current_walk_frame: int = 0
var is_moving: bool = false

## 移动目标
var move_target := Vector2.ZERO
var home_position := Vector2.ZERO

## 随机行为
var idle_timer: float = 0.0
var idle_duration: float = 0.0
var random_look_timer: float = 0.0
var random_look_interval: float = 3.0

## 位置定义
var locations := {
	"home": Vector2(200, 400),
	"school": Vector2(800, 200),
	"old_tree": Vector2(400, 300),
	"shop": Vector2(900, 450),
	"park": Vector2(600, 600),
	"river": Vector2(800, 1000)
}

## 日程配置
var schedule := {
	"xiaogang": {
		"morning": {"location": "school", "condition": "age >= 7"},
		"afternoon": {"location": "old_tree", "condition": "age >= 7"},
		"evening": {"location": "home", "condition": ""},
		"night": {"location": "home", "condition": ""}
	},
	"xiaofang": {
		"morning": {"location": "school", "condition": "age >= 7"},
		"afternoon": {"location": "park", "condition": ""},
		"evening": {"location": "home", "condition": ""},
		"night": {"location": "home", "condition": ""}
	},
	"dazhuang": {
		"morning": {"location": "shop", "condition": ""},
		"afternoon": {"location": "shop", "condition": ""},
		"evening": {"location": "home", "condition": ""},
		"night": {"location": "home", "condition": ""}
	}
}

func _ready() -> void:
	home_position = global_position

	# 更新名称标签
	if name_label:
		name_label.text = npc_name

	# 设置 NPC 精灵图和颜色
	_setup_appearance()

	# 初始化精灵帧显示
	if sprite:
		_update_sprite_frame()

	# 连接时间信号
	TimeManager.time_period_changed.connect(_on_time_period_changed)

	# 根据初始时间设置位置
	update_position_for_time()

	# 初始化随机行为
	_init_random_behavior()

## 设置 NPC 外观
func _setup_appearance() -> void:
	# 加载对应的精灵图
	var sprite_path = npc_sprites.get(npc_id, "res://assets/sprites/npc/basic.png")
	if ResourceLoader.exists(sprite_path):
		var texture = load(sprite_path)
		if texture and sprite:
			sprite.texture = texture
			# 根据精灵图尺寸自动计算帧数
			var texture_width = texture.get_width()
			var texture_height = texture.get_height()
			# 假设每帧 48x48 像素
			sprite.hframes = texture_width / 48
			sprite.vframes = texture_height / 48

	# 设置颜色
	var color = npc_colors.get(npc_id, Color.WHITE)
	if sprite:
		sprite.modulate = color

## 初始化随机行为
func _init_random_behavior() -> void:
	idle_duration = randf_range(2.0, 5.0)
	random_look_interval = randf_range(2.0, 4.0)

func _physics_process(delta: float) -> void:
	# 更新随机行为
	_update_random_behavior(delta)

	# 根据状态处理
	match current_state:
		NPCState.IDLE:
			_process_idle(delta)
		NPCState.WALKING:
			_process_walking(delta)
		NPCState.TALKING:
			_process_talking(delta)
		NPCState.WORKING:
			_process_working(delta)

## 更新随机行为
func _update_random_behavior(delta: float) -> void:
	random_look_timer += delta
	if random_look_timer >= random_look_interval:
		random_look_timer = 0.0
		_random_look_around()

## 处理空闲状态
func _process_idle(delta: float) -> void:
	# 站立时重置到站立帧
	current_walk_frame = 0
	_update_sprite_frame()

	# 更新空闲计时器
	idle_timer += delta
	if idle_timer >= idle_duration:
		idle_timer = 0.0
		idle_duration = randf_range(2.0, 5.0)
		# 随机决定下一步行动
		_decide_next_action()

## 处理行走状态
func _process_walking(delta: float) -> void:
	if is_moving:
		move_to_target(delta)
		# 更新行走动画
		_update_walk_animation(delta)
	else:
		# 到达目标后切换到空闲状态
		current_state = NPCState.IDLE

## 处理交谈状态
func _process_talking(_delta: float) -> void:
	# 交谈时面向玩家
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = global_position.direction_to(player.global_position)
		_update_direction(direction)
		_update_sprite_frame()

## 处理工作状态
func _process_working(delta: float) -> void:
	# 工作时的动画
	_update_walk_animation(delta)

## 随机环顾四周
func _random_look_around() -> void:
	if current_state == NPCState.IDLE:
		# 随机选择一个方向
		var random_dir = randi() % 4
		current_direction = random_dir as Direction
		_update_sprite_frame()

## 决定下一步行动
func _decide_next_action() -> void:
	# 80% 概率继续等待，20% 概率随机移动
	if randf() < 0.2:
		# 随机移动到附近位置
		var random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		var target = home_position + random_offset
		move_to(target)
		current_state = NPCState.WALKING

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
	if animation_time >= animation_speed:
		animation_time = 0.0
		current_walk_frame = (current_walk_frame + 1) % WALK_FRAMES
		_update_sprite_frame()

## 更新精灵帧
func _update_sprite_frame() -> void:
	if sprite:
		# 计算帧索引：行 * 每行帧数 + 列
		sprite.frame = current_direction * sprite.hframes + WALK_FRAME_START + current_walk_frame

## 根据时间更新位置
func update_position_for_time() -> void:
	var period = GameState.current_time_period
	var age = GameState.current_age

	# 获取 NPC 的日程
	var npc_schedule = schedule.get(npc_id, {})
	var period_schedule = npc_schedule.get(period, {})

	# 检查条件
	var condition = period_schedule.get("condition", "")
	var location_key = period_schedule.get("location", "home")

	# 评估条件
	if condition != "":
		if condition == "age >= 7" and age < 7:
			location_key = "home"

	# 获取目标位置
	var target_pos = locations.get(location_key, home_position)

	# 添加随机偏移，避免 NPC 重叠
	var random_offset = Vector2(randf_range(-20, 20), randf_range(-20, 20))
	target_pos += random_offset

	# 移动到目标位置
	move_to(target_pos)
	current_state = NPCState.WALKING

## 移动到目标
func move_to(target: Vector2) -> void:
	move_target = target
	is_moving = true

## 移动逻辑
func move_to_target(delta: float) -> void:
	var direction := global_position.direction_to(move_target)
	velocity = direction * base_speed

	# 更新方向
	_update_direction(direction)

	if global_position.distance_to(move_target) < 10:
		velocity = Vector2.ZERO
		is_moving = false

	move_and_slide()

## 开始交谈
func start_talking() -> void:
	current_state = NPCState.TALKING

## 结束交谈
func stop_talking() -> void:
	current_state = NPCState.IDLE

## 时段变化回调
func _on_time_period_changed(_old: String, _new: String) -> void:
	update_position_for_time()

## 设置 NPC 外观
func set_appearance(texture: Texture2D, color: Color = Color.WHITE) -> void:
	if sprite:
		sprite.texture = texture
		sprite.modulate = color

## 获取 NPC 状态信息
func get_status_info() -> Dictionary:
	return {
		"id": npc_id,
		"name": npc_name,
		"state": current_state,
		"direction": current_direction,
		"position": global_position
	}
