## AudioManager - 音频管理器
## 管理游戏中的音效和背景音乐
extends Node

## 音频播放器
var music_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null
var ambient_player: AudioStreamPlayer = null

## 音量配置
var music_volume: float = 0.7
var sfx_volume: float = 1.0
var ambient_volume: float = 0.5

## 当前播放
var current_music: String = ""
var current_ambient: String = ""

## 音效缓存
var sfx_cache: Dictionary = {}

## 音频文件路径
var audio_paths := {
	"music": "res://assets/audio/music/",
	"sfx": "res://assets/audio/sfx/",
	"ambient": "res://assets/audio/ambient/"
}

## 信号
signal music_changed(track_name: String)
signal sfx_played(sfx_name: String)

func _ready() -> void:
	# 创建音频播放器
	_init_audio_players()

	# 初始化音效缓存
	_init_sfx_cache()

## 初始化音频播放器
func _init_audio_players() -> void:
	# 背景音乐播放器
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"
	add_child(music_player)

	# 音效播放器
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "SFX"
	add_child(sfx_player)

	# 环境音播放器
	ambient_player = AudioStreamPlayer.new()
	ambient_player.name = "AmbientPlayer"
	ambient_player.bus = "Ambient"
	add_child(ambient_player)

## 初始化音效缓存
func _init_sfx_cache() -> void:
	# 预加载常用音效
	sfx_cache = {
		"footstep": null,
		"interact": null,
		"select": null,
		"notification": null,
		"door_open": null,
		"door_close": null,
		"pickup": null,
		"eat": null,
		"study": null,
		"sleep": null
	}

## 播放背景音乐
func play_music(track_name: String, fade_duration: float = 1.0) -> void:
	if current_music == track_name:
		return

	var music_path = audio_paths["music"] + track_name + ".ogg"
	if not ResourceLoader.exists(music_path):
		push_warning("[AudioManager] 音乐文件不存在: " + music_path)
		return

	# 淡出当前音乐
	if music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_duration / 2)
		await tween.finished

	# 播放新音乐
	music_player.stream = load(music_path)
	music_player.volume_db = linear_to_db(music_volume)
	music_player.play()

	# 淡入新音乐
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", linear_to_db(music_volume), fade_duration / 2)

	current_music = track_name
	music_changed.emit(track_name)

## 停止背景音乐
func stop_music(fade_duration: float = 1.0) -> void:
	if not music_player.playing:
		return

	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, fade_duration)
	await tween.finished
	music_player.stop()
	current_music = ""

## 播放音效
func play_sfx(sfx_name: String) -> void:
	var sfx_path = audio_paths["sfx"] + sfx_name + ".wav"
	if not ResourceLoader.exists(sfx_path):
		# 使用程序生成的音效
		_play_procedural_sfx(sfx_name)
		return

	sfx_player.stream = load(sfx_path)
	sfx_player.volume_db = linear_to_db(sfx_volume)
	sfx_player.play()
	sfx_played.emit(sfx_name)

## 播放环境音
func play_ambient(ambient_name: String, fade_duration: float = 2.0) -> void:
	if current_ambient == ambient_name:
		return

	var ambient_path = audio_paths["ambient"] + ambient_name + ".ogg"
	if not ResourceLoader.exists(ambient_path):
		push_warning("[AudioManager] 环境音文件不存在: " + ambient_path)
		return

	# 淡出当前环境音
	if ambient_player.playing:
		var tween = create_tween()
		tween.tween_property(ambient_player, "volume_db", -80.0, fade_duration / 2)
		await tween.finished

	# 播放新环境音
	ambient_player.stream = load(ambient_path)
	ambient_player.volume_db = linear_to_db(ambient_volume)
	ambient_player.play()

	# 淡入新环境音
	var tween = create_tween()
	tween.tween_property(ambient_player, "volume_db", linear_to_db(ambient_volume), fade_duration / 2)

	current_ambient = ambient_name

## 停止环境音
func stop_ambient(fade_duration: float = 2.0) -> void:
	if not ambient_player.playing:
		return

	var tween = create_tween()
	tween.tween_property(ambient_player, "volume_db", -80.0, fade_duration)
	await tween.finished
	ambient_player.stop()
	current_ambient = ""

## 播放程序生成的音效
func _play_procedural_sfx(sfx_name: String) -> void:
	# 创建简单的音效
	var audio_stream = AudioStreamGenerator.new()
	audio_stream.mix_rate = 44100
	audio_stream.buffer_length = 0.1

	sfx_player.stream = audio_stream
	sfx_player.volume_db = linear_to_db(sfx_volume * 0.5)
	sfx_player.play()

	# 根据音效类型调整
	match sfx_name:
		"footstep":
			# 脚步声 - 短促的低音
			pass
		"interact":
			# 交互声 - 清脆的提示音
			pass
		"select":
			# 选择声 - 短促的高音
			pass
		"notification":
			# 通知声 - 悦耳的提示音
			pass
		_:
			pass

## 设置音乐音量
func set_music_volume(volume: float) -> void:
	music_volume = clampf(volume, 0.0, 1.0)
	if music_player.playing:
		music_player.volume_db = linear_to_db(music_volume)

## 设置音效音量
func set_sfx_volume(volume: float) -> void:
	sfx_volume = clampf(volume, 0.0, 1.0)

## 设置环境音音量
func set_ambient_volume(volume: float) -> void:
	ambient_volume = clampf(volume, 0.0, 1.0)
	if ambient_player.playing:
		ambient_player.volume_db = linear_to_db(ambient_volume)

## 获取当前音乐名称
func get_current_music() -> String:
	return current_music

## 获取当前环境音名称
func get_current_ambient() -> String:
	return current_ambient

## 检查是否正在播放音乐
func is_music_playing() -> bool:
	return music_player.playing

## 检查是否正在播放环境音
func is_ambient_playing() -> bool:
	return ambient_player.playing
