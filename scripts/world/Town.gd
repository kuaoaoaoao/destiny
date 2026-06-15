## Town - 小镇场景脚本
extends Node2D

signal scene_change_requested(scene_name: String)

func _ready() -> void:
	# 连接NPC信号
	for npc in get_tree().get_nodes_in_group("npc"):
		if npc.has_signal("dialogue_requested"):
			npc.dialogue_requested.connect(_on_npc_dialogue_requested)

## NPC对话请求
func _on_npc_dialogue_requested(npc_id: String) -> void:
	# 根据NPC和当前状态选择对话
	var dialogue := get_npc_dialogue(npc_id)
	EventEngine.dialogue_started.emit(dialogue)

## 获取NPC对话
func get_npc_dialogue(npc_id: String) -> Dictionary:
	# 简化：返回基础对话
	return {
		"npc_id": npc_id,
		"nodes": [
			{"id": "start", "speaker": npc_id, "text": "你好啊！", "next": null}
		]
	}
