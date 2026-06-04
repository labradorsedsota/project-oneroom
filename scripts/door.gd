extends StaticBody2D
class_name Door

# === 配置 ===
@export var open_direction: Vector2 = Vector2(0, -1)  # 门滑开方向
@export var open_distance: float = 128.0
@export var open_speed: float = 200.0

# === 状态 ===
var is_open: bool = false
var is_locked: bool = false
var _original_pos: Vector2

# === 信号 ===
signal opened
signal closed

# === 引用 ===
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_original_pos = position

func open() -> void:
	if is_open or is_locked:
		return
	is_open = true
	opened.emit()
	# 动画滑开
	var target = _original_pos + open_direction * open_distance
	var tween = create_tween()
	tween.tween_property(self, "position", target, open_distance / open_speed)
	tween.tween_callback(func(): collision.set_deferred("disabled", true))
	# 视觉反馈
	if sprite:
		sprite.modulate = Color(0.3, 1, 0.3)

func close() -> void:
	if not is_open:
		return
	is_open = false
	closed.emit()
	collision.set_deferred("disabled", false)
	var tween = create_tween()
	tween.tween_property(self, "position", _original_pos, open_distance / open_speed)
	if sprite:
		sprite.modulate = Color.WHITE

func lock() -> void:
	is_locked = true
	if sprite:
		sprite.modulate = Color(1, 0.2, 0.2)

func unlock() -> void:
	is_locked = false
	if sprite:
		sprite.modulate = Color.WHITE

func reset() -> void:
	is_open = false
	is_locked = false
	position = _original_pos
	if collision:
		collision.set_deferred("disabled", false)
	if sprite:
		sprite.modulate = Color.WHITE
