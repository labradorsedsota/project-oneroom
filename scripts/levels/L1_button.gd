extends Node

# L1: The Button - Tutorial
# 玩家踩按钮 → 门打开 → 走到终点过关

var button: Area2D
var door: Node2D
var goal: Area2D

func _ready() -> void:
	# 查找场景中的节点
	button = get_parent().get_node("Button")
	door = get_parent().get_node("Door")
	goal = get_parent().get_node("GoalTrigger")

	# 连接信号
	button.activated.connect(_on_button_activated)
	goal.player_reached.connect(_on_goal_reached)

func _on_button_activated() -> void:
	print("[L1] Button activated → opening door")
	door.open()

func _on_goal_reached() -> void:
	print("[L1] Goal reached → level complete!")
	# 通知关卡管理器
	var level_manager = get_node_or_null("/root/Main/LevelManager")
	if level_manager:
		level_manager._on_level_complete()
