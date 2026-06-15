## InteractionManager - 交互管理器
## 统一管理玩家与可交互对象的交互逻辑
extends Node

## 当前附近的可交互对象
var nearby_interactable: Node2D = null

## 当前交互状态
var is_interacting: bool = false

## 信号
signal interaction_started(node: Node2D)
signal interaction_ended()
signal interaction_available(node: Node2D)
signal interaction_unavailable()

func _ready() -> void:
	# 注册到交互管理器组
	add_to_group("interaction_manager")

## 设置附近的可交互对象
func set_nearby_interactable(node: Node2D) -> void:
	if node != nearby_interactable:
		nearby_interactable = node
		if node:
			interaction_available.emit(node)
		else:
			interaction_unavailable.emit()

## 清除附近的可交互对象
func clear_nearby_interactable() -> void:
	nearby_interactable = null
	interaction_unavailable.emit()

## 开始交互
func start_interaction() -> bool:
	if not nearby_interactable:
		return false

	is_interacting = true
	interaction_started.emit(nearby_interactable)
	return true

## 结束交互
func end_interaction() -> void:
	is_interacting = false
	interaction_ended.emit()

## 获取交互提示文本
func get_interaction_hint(node: Node2D) -> String:
	if not node:
		return ""

	var hint: String = "[空格] "

	# 检查是否是 NPC
	var npc_id: String = ""
	if node.has_method("get"):
		npc_id = node.get("npc_id") if node.has_method("get") else ""

	if npc_id != "":
		match npc_id:
			"xiaogang": hint += "和小刚聊天"
			"xiaofang": hint += "和小芳聊天"
			"dazhuang": hint += "和大壮聊天"
			"aqiang": hint += "和阿强聊天"
			"lili": hint += "和莉莉聊天"
			"xiaomei": hint += "和小美聊天"
			_: hint += "交谈"
	else:
		# 检查是否是地点
		match node.name:
			"Home": hint += "回家"
			"School": hint += "学校"
			"OldTree": hint += "老槐树"
			"Shop": hint += "小卖部"
			"Park": hint += "公园"
			"Library": hint += "图书馆"
			"Hospital": hint += "医院"
			_: hint += "互动"

	return hint

## 获取可交互对象的类型
func get_interactable_type(node: Node2D) -> String:
	if not node:
		return "unknown"

	# 检查是否是 NPC
	var npc_id: String = ""
	if node.has_method("get"):
		npc_id = node.get("npc_id") if node.has_method("get") else ""

	if npc_id != "":
		return "npc"

	# 检查是否是地点
	match node.name:
		"Home": return "location"
		"School": return "location"
		"OldTree": return "location"
		"Shop": return "location"
		"Park": return "location"
		"Library": return "location"
		"Hospital": return "location"
		_: return "unknown"

## 获取可交互对象的 ID
func get_interactable_id(node: Node2D) -> String:
	if not node:
		return ""

	# 检查是否是 NPC
	var npc_id: String = ""
	if node.has_method("get"):
		npc_id = node.get("npc_id") if node.has_method("get") else ""

	if npc_id != "":
		return npc_id

	# 返回节点名称作为地点 ID
	return node.name
