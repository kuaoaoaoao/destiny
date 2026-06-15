## ResourceManager - 资源管理器
## 统一管理游戏资源的加载、缓存和使用
extends Node

## 资源缓存
var texture_cache: Dictionary = {}
var font_cache: Dictionary = {}
var audio_cache: Dictionary = {}
var scene_cache: Dictionary = {}

## 资源路径配置
const ASSET_PATHS := {
	# UI 资源
	"ui_icons": "res://assets/ui/icons/",
	"ui_backgrounds": "res://assets/ui/backgrounds/",

	# 角色资源
	"player_sprites": "res://assets/sprites/player/",
	"npc_sprites": "res://assets/sprites/npc/",
	"object_sprites": "res://assets/sprites/objects/",

	# 场景资源
	"tilesets": "res://assets/tilesets/",
	"scenes": "res://scenes/",

	# 音频资源
	"bgm": "res://assets/audio/bgm/",
	"sfx": "res://assets/audio/sfx/",

	# 字体资源
	"fonts": "res://assets/fonts/"
}

## 信号
signal resource_loaded(resource_path: String)
signal resource_load_failed(resource_path: String, error: String)

func _ready() -> void:
	print("[ResourceManager] 资源管理器初始化完成")

## 加载纹理
func load_texture(path: String) -> Texture2D:
	# 检查缓存
	if texture_cache.has(path):
		return texture_cache[path]

	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		push_warning("[ResourceManager] 纹理文件不存在: " + path)
		resource_load_failed.emit(path, "文件不存在")
		return null

	# 加载纹理
	var texture := load(path) as Texture2D
	if texture:
		texture_cache[path] = texture
		resource_loaded.emit(path)
		return texture
	else:
		push_warning("[ResourceManager] 加载纹理失败: " + path)
		resource_load_failed.emit(path, "加载失败")
		return null

## 加载字体
func load_font(path: String, size: int = 18) -> Font:
	var cache_key := "%s_%d" % [path, size]

	# 检查缓存
	if font_cache.has(cache_key):
		return font_cache[cache_key]

	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		push_warning("[ResourceManager] 字体文件不存在: " + path)
		resource_load_failed.emit(path, "文件不存在")
		return null

	# 加载字体
	var font := FontFile.new()
	var error := font.load_dynamic_font(path)
	if error == OK:
		font.fixed_size = size
		font_cache[cache_key] = font
		resource_loaded.emit(path)
		return font
	else:
		push_warning("[ResourceManager] 加载字体失败: " + path)
		resource_load_failed.emit(path, "加载失败")
		return null

## 加载音频
func load_audio(path: String) -> AudioStream:
	# 检查缓存
	if audio_cache.has(path):
		return audio_cache[path]

	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		push_warning("[ResourceManager] 音频文件不存在: " + path)
		resource_load_failed.emit(path, "文件不存在")
		return null

	# 加载音频
	var audio := load(path) as AudioStream
	if audio:
		audio_cache[path] = audio
		resource_loaded.emit(path)
		return audio
	else:
		push_warning("[ResourceManager] 加载音频失败: " + path)
		resource_load_failed.emit(path, "加载失败")
		return null

## 加载场景
func load_scene(path: String) -> PackedScene:
	# 检查缓存
	if scene_cache.has(path):
		return scene_cache[path]

	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		push_warning("[ResourceManager] 场景文件不存在: " + path)
		resource_load_failed.emit(path, "文件不存在")
		return null

	# 加载场景
	var scene := load(path) as PackedScene
	if scene:
		scene_cache[path] = scene
		resource_loaded.emit(path)
		return scene
	else:
		push_warning("[ResourceManager] 加载场景失败: " + path)
		resource_load_failed.emit(path, "加载失败")
		return null

## 预加载资源
func preload_assets(asset_list: Array[String]) -> void:
	for path in asset_list:
		if path.ends_with(".png") or path.ends_with(".jpg"):
			load_texture(path)
		elif path.ends_with(".ttf") or path.ends_with(".ttc"):
			load_font(path)
		elif path.ends_with(".ogg") or path.ends_with(".wav"):
			load_audio(path)
		elif path.ends_with(".tscn"):
			load_scene(path)

## 清除缓存
func clear_cache() -> void:
	texture_cache.clear()
	font_cache.clear()
	audio_cache.clear()
	scene_cache.clear()
	print("[ResourceManager] 缓存已清除")

## 获取资源目录下的所有文件
func get_assets_in_directory(dir_path: String, extension: String = "") -> Array[String]:
	var files: Array[String] = []

	if not DirAccess.dir_exists_absolute(dir_path):
		return files

	var dir := DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if extension.is_empty() or file_name.ends_with(extension):
					files.append(dir_path + file_name)
			file_name = dir.get_next()

	return files

## 检查资源是否存在
func asset_exists(path: String) -> bool:
	return FileAccess.file_exists(path)
