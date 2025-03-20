extends "res://scenes/falling_scene/falling_scene.gd"

func end_scene() -> void:
	super()
	if is_instance_valid(Util.get_player()):
		CustomToonRegistry.setup(Util.get_player())
