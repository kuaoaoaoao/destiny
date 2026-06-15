## 音频管理 - Autoload 单例
extends Node

var bgm_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var ambient_player: AudioStreamPlayer

const MAX_SFX := 8

func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "BGM"
	bgm_player.volume_db = -10
	add_child(bgm_player)
	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = "Ambient"
	ambient_player.volume_db = -15
	add_child(ambient_player)
	for i in MAX_SFX:
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_players.append(p)

func play_bgm(stream: AudioStream, fade_time: float = 1.0) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	if bgm_player.playing and fade_time > 0:
		var tween := create_tween()
		tween.tween_property(bgm_player, "volume_db", -40, fade_time * 0.5)
		await tween.finished
	bgm_player.stream = stream
	bgm_player.volume_db = -10
	bgm_player.play()

func stop_bgm(fade_time: float = 1.0) -> void:
	if not bgm_player.playing:
		return
	if fade_time > 0:
		var tween := create_tween()
		tween.tween_property(bgm_player, "volume_db", -40, fade_time)
		await tween.finished
	bgm_player.stop()

func play_sfx(stream: AudioStream) -> void:
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.play()
			return

func play_ambient(stream: AudioStream) -> void:
	ambient_player.stream = stream
	ambient_player.play()
