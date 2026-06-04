extends CharacterBody2D
class_name Player

# === 物理参数（可被关卡覆写） ===
@export var move_speed: float = 300.0
@export var jump_velocity: float = -450.0
@export var gravity_scale: float = 1.0
@export var friction: float = 0.85

# === 状态 ===
enum State { IDLE, RUN, JUMP, FALL, PUSH }
var current_state: State = State.IDLE
var jump_disabled: bool = false

# === 引用 ===
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# === 信号 ===
signal state_changed(new_state: State)

func _physics_process(delta: float) -> void:
	# 重力
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale
	if not is_on_floor() and not is_on_ceiling():
		velocity.y += gravity * delta
	elif is_on_ceiling() and gravity_scale < 0:
		velocity.y += gravity * delta

	# 跳跃
	if Input.is_action_just_pressed("jump") and not jump_disabled:
		if is_on_floor() and gravity_scale > 0:
			velocity.y = jump_velocity
		elif is_on_ceiling() and gravity_scale < 0:
			velocity.y = -jump_velocity

	# 水平移动
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x *= friction
		if abs(velocity.x) < 10:
			velocity.x = 0

	move_and_slide()
	_update_state(direction)

func _update_state(direction: float) -> void:
	var new_state: State
	if not is_on_floor() and not is_on_ceiling():
		new_state = State.JUMP if velocity.y < 0 else State.FALL
	elif abs(velocity.x) > 10:
		new_state = State.RUN
	else:
		new_state = State.IDLE

	if new_state != current_state:
		current_state = new_state
		state_changed.emit(current_state)

# === 供关卡调用的接口 ===
func set_gravity_scale(scale: float) -> void:
	gravity_scale = scale

func set_move_speed(speed: float) -> void:
	move_speed = speed

func set_jump_disabled(disabled: bool) -> void:
	jump_disabled = disabled

func set_friction(value: float) -> void:
	friction = value

func reset_params() -> void:
	move_speed = 300.0
	jump_velocity = -450.0
	gravity_scale = 1.0
	friction = 0.85
	jump_disabled = false
