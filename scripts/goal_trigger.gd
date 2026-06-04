extends Area2D
class_name GoalTrigger

# 关卡终点触发器 - 玩家到达此处即过关

signal player_reached

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached.emit()
		# 视觉反馈
		modulate = Color(0.3, 1, 0.3, 0.8)
