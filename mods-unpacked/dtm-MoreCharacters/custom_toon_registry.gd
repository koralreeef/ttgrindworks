extends Node
class_name CustomToonRegistry

static var CUSTOM_TOONS : Array[PlayerCharacter] = []
static var CUSTOM_TOON_SETUPS : Dictionary[String, Callable] = {}

static func setup(player: Player) -> void:
	var player_setup : Callable = CUSTOM_TOON_SETUPS.get(player.stats.character.character_name)
	if player_setup != null:
		player_setup.call(player)
