## TownMap - 小镇地图管理器
## 负责 TileMap 地图的初始化和管理
extends Node2D

## 地图配置
const TILE_SIZE := 16
const MAP_WIDTH := 80  # 地图宽度（瓦片数）
const MAP_HEIGHT := 60  # 地图高度（瓦片数）

## TileMapLayer 引用
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var path_layer: TileMapLayer = $PathLayer
@onready var water_layer: TileMapLayer = $WaterLayer
@onready var decoration_layer: TileMapLayer = $DecorationLayer

## 地图数据
var map_data: Dictionary = {}

func _ready() -> void:
	# 初始化地图
	_generate_map()

## 生成地图
func _generate_map() -> void:
	# 生成草地背景
	_generate_grass()

	# 生成道路
	_generate_paths()

	# 生成水面（小河、池塘）
	_generate_water()

	# 生成装饰（花丛、灌木）
	_generate_decorations()

## 生成草地
func _generate_grass() -> void:
	# 填充整个地图为草地
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			# 使用随机草地变体
			var variant := Vector2i(randi() % 4, 0)
			ground_layer.set_cell(Vector2i(x, y), 0, variant)

## 生成道路
func _generate_paths() -> void:
	# 主干道（水平）
	for x in range(MAP_WIDTH):
		# 中央主路
		path_layer.set_cell(Vector2i(x, 30), 0, Vector2i(1, 0))
		path_layer.set_cell(Vector2i(x, 31), 0, Vector2i(1, 0))

	# 垂直道路
	for y in range(MAP_HEIGHT):
		# 左侧道路
		path_layer.set_cell(Vector2i(20, y), 0, Vector2i(1, 0))
		path_layer.set_cell(Vector2i(21, y), 0, Vector2i(1, 0))

		# 右侧道路
		path_layer.set_cell(Vector2i(60, y), 0, Vector2i(1, 0))
		path_layer.set_cell(Vector2i(61, y), 0, Vector2i(1, 0))

	# 连接道路
	for x in range(20, 62):
		path_layer.set_cell(Vector2i(x, 15), 0, Vector2i(1, 0))
		path_layer.set_cell(Vector2i(x, 45), 0, Vector2i(1, 0))

## 生成水面
func _generate_water() -> void:
	# 小河（地图下方）
	for x in range(MAP_WIDTH):
		for y in range(55, 60):
			water_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))

	# 池塘（地图右侧）
	for x in range(65, 75):
		for y in range(20, 28):
			water_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))

## 生成装饰
func _generate_decorations() -> void:
	# 随机放置花丛
	for i in range(50):
		var x := randi() % MAP_WIDTH
		var y := randi() % MAP_HEIGHT
		# 避免在道路和水面上放置
		if path_layer.get_cell_source_id(Vector2i(x, y)) == -1 and water_layer.get_cell_source_id(Vector2i(x, y)) == -1:
			decoration_layer.set_cell(Vector2i(x, y), 0, Vector2i(randi() % 3, 1))

	# 随机放置灌木
	for i in range(30):
		var x := randi() % MAP_WIDTH
		var y := randi() % MAP_HEIGHT
		if path_layer.get_cell_source_id(Vector2i(x, y)) == -1 and water_layer.get_cell_source_id(Vector2i(x, y)) == -1:
			decoration_layer.set_cell(Vector2i(x, y), 0, Vector2i(randi() % 2, 2))

## 获取瓦片位置
func world_to_tile(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(world_pos.x / TILE_SIZE),
		int(world_pos.y / TILE_SIZE)
	)

## 获取世界位置
func tile_to_world(tile_pos: Vector2i) -> Vector2:
	return Vector2(
		tile_pos.x * TILE_SIZE + TILE_SIZE / 2,
		tile_pos.y * TILE_SIZE + TILE_SIZE / 2
	)

## 检查瓦片是否可通行
func is_tile_walkable(tile_pos: Vector2i) -> bool:
	# 检查水面
	if water_layer.get_cell_source_id(tile_pos) != -1:
		return false
	# 检查装饰物碰撞
	if decoration_layer.get_cell_source_id(tile_pos) != -1:
		return false
	return true
