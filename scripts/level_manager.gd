extends Node

# === 关卡管理器 ===
# 负责加载、切换、重置关卡

var levels: Array[String] = [
	"res://scenes/levels/L1_button.tscn",
	"res://scenes/levels/placeholder.tscn",  # L2
	"res://scenes/levels/placeholder.tscn",  # L3
	"res://scenes/levels/placeholder.tscn",  # L4
	"res://scenes/levels/placeholder.tscn",  # L5
	"res://scenes/levels/placeholder.tscn",  # L6
	"res://scenes/levels/placeholder.tscn",  # L7
	"res://scenes/levels/placeholder.tscn",  # L8
	"res://scenes/levels/placeholder.tscn",  # L9
	"res://scenes/levels/placeholder.tscn",  # L10
	"res://scenes/levels/placeholder.tscn",  # L11
	"res://scenes/levels/placeholder.tscn",  # L12
	"res://scenes/levels/placeholder.tscn",  # L13
	"res://scenes/levels/placeholder.tscn",  # L14
	"res://scenes/levels/placeholder.tscn",  # L15
]

var current_level_index: int = -1
var current_level: Node = null
var is_transitioning: bool = false

signal level_loaded(level_index: int)
signal level_completed(level_index: int)
signal all_levels_completed

func _ready() -> void:
	load_level(0)

func load_level(index: int) -> void:
	if index < 0 or index >= levels.size():
		all_levels_completed.emit()
		print("[LevelManager] All levels completed!")
		return

	if is_transitioning:
		return
	is_transitioning = true

	# 卸载当前关卡
	if current_level:
		current_level.queue_free()
		await get_tree().process_frame
		current_level = null

	current_level_index = index

	# 加载新关卡
	var scene_resource = load(levels[index])
	if scene_resource == null:
		print("[LevelManager] Failed to load level: ", levels[index])
		is_transitioning = false
		return

	current_level = scene_resource.instantiate()
	get_parent().add_child(current_level)

	# 连接关卡完成信号
	if current_level.has_signal("level_complete"):
		current_level.level_complete.connect(_on_level_complete)

	# 更新 UI
	var ui_label = get_parent().get_node_or_null("UI/LevelLabel")
	if ui_label:
		ui_label.text = "L" + str(current_level_index + 1)

	level_loaded.emit(current_level_index)
	is_transitioning = false
	print("[LevelManager] Loaded L", current_level_index + 1)

func _on_level_complete() -> void:
	level_completed.emit(current_level_index)
	print("[LevelManager] L", current_level_index + 1, " completed!")
	# 短暂延迟后加载下一关
	await get_tree().create_timer(1.0).timeout
	load_level(current_level_index + 1)

func restart_level() -> void:
	load_level(current_level_index)

func get_player() -> Node:
	if current_level:
		return current_level.get_node_or_null("Player")
	return null
