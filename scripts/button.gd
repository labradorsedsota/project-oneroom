extends Area2D
class_name Button

# === 配置 ===
@export var activate_mode: String = "press"  # press, click, hold, timed
@export var required_presses: int = 1
@export var hold_time: float = 0.0

# === 状态 ===
var is_active: bool = false
var press_count: int = 0
var is_pressed: bool = false

# === 信号 ===
signal activated
signal deactivated
signal pressed

# === 引用 ===
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and activate_mode == "press":
		_press()

func _on_body_exited(body: Node2D) -> void:
	if body is Player and activate_mode == "press":
		_release()

func _press() -> void:
	if is_active:
		return
	is_pressed = true
	press_count += 1
	pressed.emit()

	if press_count >= required_presses:
		activate()

func _release() -> void:
	is_pressed = false
	if activate_mode == "press":
		deactivate()

func activate() -> void:
	if is_active:
		return
	is_active = true
	activated.emit()
	# 视觉反馈：变红
	if sprite:
		sprite.modulate = Color(1, 0.3, 0.3)

func deactivate() -> void:
	if not is_active:
		return
	is_active = false
	deactivated.emit()
	# 视觉反馈：恢复
	if sprite:
		sprite.modulate = Color.WHITE

# === 鼠标点击模式（L4） ===
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if activate_mode == "click" and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_press()

# === 供关卡调用的接口 ===
func reset() -> void:
	is_active = false
	press_count = 0
	is_pressed = false
	if sprite:
		sprite.modulate = Color.WHITE
