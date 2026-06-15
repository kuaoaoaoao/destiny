## IndoorScene - 室内场景脚本
## 管理室内场景的交互和功能
extends Node2D

## 场景名称
@export var scene_name: String = "室内"

## 可交互家具
var interactable_furniture: Dictionary = {}

## 退出区域
var exit_area: Area2D = null

func _ready() -> void:
	# 注册家具交互
	_register_furniture_interactions()

	# 查找退出区域
	_find_exit_area()

	# 连接交互信号
	for node in get_tree().get_nodes_in_group("interactable"):
		if node != self:
			if node.has_signal("body_entered"):
				node.body_entered.connect(_on_interactable_body_entered.bind(node))

## 查找退出区域
func _find_exit_area() -> void:
	for child in get_children():
		if child is Area2D and child.is_in_group("interactable"):
			exit_area = child
			break

## 注册家具交互
func _register_furniture_interactions() -> void:
	# 床 - 可以睡觉
	interactable_furniture["Bed"] = {
		"name": "床",
		"action": "sleep",
		"description": "休息一下"
	}

	# 桌子 - 可以学习
	interactable_furniture["Table"] = {
		"name": "桌子",
		"action": "study",
		"description": "学习"
	}

	# 书架 - 可以看书
	interactable_furniture["Bookshelf"] = {
		"name": "书架",
		"action": "read",
		"description": "看书"
	}

	# 电视 - 可以看电视
	interactable_furniture["TV"] = {
		"name": "电视",
		"action": "watch_tv",
		"description": "看电视"
	}

	# 课桌 - 可以学习
	interactable_furniture["Desk"] = {
		"name": "课桌",
		"action": "study",
		"description": "学习"
	}

	# 黑板 - 可以听课
	interactable_furniture["Blackboard"] = {
		"name": "黑板",
		"action": "listen",
		"description": "听课"
	}

	# 收银台 - 可以购物
	interactable_furniture["CashRegister"] = {
		"name": "收银台",
		"action": "shop",
		"description": "购物"
	}

## 可交互物体进入回调
func _on_interactable_body_entered(body: Node2D, interactable: Node2D) -> void:
	if body.is_in_group("player"):
		# 检查是否是退出区域
		if interactable == exit_area:
			_exit_scene()
		else:
			# 检查是否是家具
			var furniture_name = interactable.name
			if interactable_furniture.has(furniture_name):
				_handle_furniture_interaction(interactable_furniture[furniture_name])

## 处理家具交互
func _handle_furniture_interaction(furniture: Dictionary) -> void:
	var action: String = furniture["action"]

	match action:
		"sleep":
			_handle_sleep()
		"study":
			_handle_study()
		"read":
			_handle_read()
		"watch_tv":
			_handle_watch_tv()
		"listen":
			_handle_listen()
		"shop":
			_handle_shop()

## 处理睡觉
func _handle_sleep() -> void:
	# 恢复健康和心理
	GameState.modify_stat("health", 10)
	GameState.modify_stat("psychology", 10)

	# 通知 UI
	UIManager.show_notification("休息了一会儿，感觉好多了")

	# 推进时间
	TimeManager.sleep()

## 处理学习
func _handle_study() -> void:
	# 增加教育，减少心理
	GameState.modify_stat("education", 5)
	GameState.modify_stat("psychology", -3)

	# 通知 UI
	UIManager.show_notification("认真学习了一会儿")

## 处理看书
func _handle_read() -> void:
	# 增加教育和心理
	GameState.modify_stat("education", 3)
	GameState.modify_stat("psychology", 5)

	# 通知 UI
	UIManager.show_notification("看了一会儿书，增长了知识")

## 处理看电视
func _handle_watch_tv() -> void:
	# 增加心理，减少教育
	GameState.modify_stat("psychology", 5)
	GameState.modify_stat("education", -2)

	# 通知 UI
	UIManager.show_notification("看了一会儿电视，放松了一下")

## 处理听课
func _handle_listen() -> void:
	# 增加教育
	GameState.modify_stat("education", 8)
	GameState.modify_stat("psychology", -5)

	# 通知 UI
	UIManager.show_notification("认真听了一节课")

## 处理购物
func _handle_shop() -> void:
	# 检查金钱
	if GameState.get_stat("money") >= 10:
		GameState.modify_stat("money", -10)
		GameState.modify_stat("psychology", 5)
		UIManager.show_notification("买了一些东西，心情变好了")
	else:
		UIManager.show_notification("钱不够了...")

## 退出室内场景
func _exit_scene() -> void:
	# 获取场景过渡管理器
	var scene_transition = get_tree().get_first_node_in_group("scene_transition_manager")
	if scene_transition:
		scene_transition.return_to_main()
	else:
		# 直接切换到主场景
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
