extends Node
class_name BaseLevel

# === 所有关卡的基类 ===
# 子类覆写 _level_ready() 来实现关卡逻辑

signal level_complete

var player: Player
var hint_label: Label

func _ready() -> void:
	player = get_parent_node_3d() if get_parent_node_3d() is Player else null
	# 查找 Player
	if not player:
		player = _find_child_of_type("Player")
	# 查找 HintLabel
	hint_label = get_node_or_null("../HintLabel")
	if not hint_label:
		hint_label = _find_child_named("HintLabel")

	# 延迟一帧确保所有节点就绪
	await get_tree().process_frame
	_level_ready()

func _level_ready() -> void:
	# 子类覆写
	pass

func complete_level() -> void:
	level_complete.emit()

func _find_child_of_type(type_name: String) -> Node:
	for child in get_parent().get_children():
		if child.get_class() == type_name:
			return child
		# 也检查脚本类名
		var script = child.get_script()
		if script and script.get_class() == type_name:
			return child
	return null

func _find_child_named(node_name: String) -> Node:
	return get_parent().get_node_or_null(node_name)
