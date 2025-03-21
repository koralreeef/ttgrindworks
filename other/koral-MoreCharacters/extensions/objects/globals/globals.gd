extends "res://objects/globals/globals.gd"


func _ready() -> void:
	super()
	ALL_TOONS.append_array(TOON_UNLOCK_ORDER.duplicate())
	ALL_TOONS.append_array(CustomToonRegistry.CUSTOM_TOONS.duplicate())

var ALL_TOONS : Array[PlayerCharacter] = []
