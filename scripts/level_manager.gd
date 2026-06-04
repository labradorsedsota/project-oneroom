extends Node
class_name LevelManager

# === 关卡列表 ===
var levels: Array[String] = [
	"res://scenes/levels/L1_button.tscn",
	"res://scenes/levels/L2_decoy.tscn",
	"res://scenes/levels/L3_patience.tscn",
	"res://scenes/levels/L4_mouse.tscn",
	"res://scenes/levels/L5_keep_jumping.tscn",
	"res://scenes/levels/L6_heavy.tscn",
	"res://scenes/levels/L7_anti_gravity.tscn",
	"res://scenes/levels/L8_slippery.tscn",
	"res://scenes/levels/L9_box.tscn",
	"res://scenes/levels/L10_invisible.tscn",
	"res://scenes/levels/L11_ui.tscn",
	"res://scenes/levels/L12_wall.tscn",
	"res://scenes/levels/L13_time_travel.tscn",
	"res://scenes/levels/L14_keyboard.tscn",
	"res://scenes/levels/L15_end.tscn",
]

var current_level_index: int = 0
var current_level: Node = null

# === 信号 ===
signal level_loaded(level_index: int)
signal level_completed(level_index: int)

func _ready() -> void:
	load_level(0)

func load_level(index: int) -> void:
	if index < 0 or index >= levels.size():
		print("Level index out of range: ", index)
		return

	# 卸载当前关卡
	if current_level:
		current_level.queue_free()
		current_level = null

	current_level_index = index

	# 加载新关卡
	var scene = load(levels[index])
	current_level = scene.instantiate()
	add_child(current_level)

	level_loaded.emit(current_level_index)
	print("Loaded level: L", current_level_index + 1)

func next_level() -> void:
	level_completed.emit(current_level_index)
	load_level(current_level_index + 1)

func restart_level() -> void:
	load_level(current_level_index)

func get_current_level() -> Node:
	return current_level
