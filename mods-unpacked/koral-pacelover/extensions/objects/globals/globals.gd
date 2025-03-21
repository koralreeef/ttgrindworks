extends "res://mods-unpacked/koral-MoreCharacters/extensions/objects/globals/globals.gd"

func load_custom_toons() -> void:
	super()
	Globals.CUSTOM_TOONS.append(load('res://objects/player/characters/pacelover.tres'))
