extends Control

const LEVELS = [
	{"name": "Level 1", "scene": "res://scenes/levels/level1.tscn"},
	{"name": "Level 2", "scene": "res://scenes/levels/level2.tscn"},
	{"name": "Level 3", "scene": "res://scenes/levels/level3.tscn"},
]

func _ready() -> void:
	for level in LEVELS:
		var button = Button.new()
		button.text = level["name"]
		button.pressed.connect(func(): get_tree().change_scene_to_file(level["scene"]))
		$LevelList.add_child(button)
