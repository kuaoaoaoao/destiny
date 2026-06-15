## 主菜单
extends Control

@onready var new_game_btn: Button = $VBoxContainer/NewGameButton
@onready var load_btn: Button = $VBoxContainer/LoadButton
@onready var quit_btn: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	new_game_btn.pressed.connect(_on_new_game)
	load_btn.pressed.connect(_on_load_game)
	quit_btn.pressed.connect(_on_quit)
	# 如果没有存档，禁用加载按钮
	load_btn.disabled = not SaveSystem.has_save(0)

func _on_new_game() -> void:
	GameState.reset_game()
	get_tree().change_scene_to_file("res://scenes/town/Prologue.tscn")

func _on_load_game() -> void:
	if SaveSystem.load_game(0):
		get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_quit() -> void:
	get_tree().quit()
