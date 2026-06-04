extends Node

# L1: The Button - Tutorial
# 玩家踩按钮 → 门打开

@onready var button: Button = $"../Button"
@onready var door: Door = $"../Door"

func _ready() -> void:
	button.activated.connect(_on_button_activated)

func _on_button_activated() -> void:
	door.open()
