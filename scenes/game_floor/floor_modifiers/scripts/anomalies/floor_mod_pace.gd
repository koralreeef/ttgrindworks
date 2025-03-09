extends FloorModifier

## hopefully avoids all obstacle rooms
func modify_floor() -> void:
	# could be an unbalanced curve who knows
	if Util.floor_number == 1:
		game_floor.level_range.x += 1
		game_floor.level_range.y += 1
	if Util.floor_number == 2:
		game_floor.level_range.x += 1
		game_floor.level_range.y += 1
	elif Util.floor_number == 3:
		game_floor.level_range.x += 2
		game_floor.level_range.y += 2
	elif Util.floor_number == 4:
		game_floor.level_range.x += 3
		game_floor.level_range.y += 3
	elif Util.floor_number == 5:
		game_floor.level_range.x += 5
		game_floor.level_range.y += 5
	var floor_name = game_floor.floor_variant.floor_name
	var floor_type = game_floor.floor_variant.floor_type
	# im so fucked when new modded floors come out
	if floor_name == "The Factory" or floor_name == "D.A. Office": 
		floor_type.final_rooms[0].rarity_weight = 0
	elif floor_name == "The Mint" or floor_name == "Cog Golf Course": 
		floor_type.final_rooms[1].rarity_weight = 0
	# this kinda ruins vanilla floor gen 
	#for i in floor_type.obstacle_rooms.size():
	#	floor_type.obstacle_rooms[i].rarity_weight = 0
	#   print("removed obstacle room %s"% floor_type.obstacle_rooms[i])
	print("removed overworld boss hopefully")

func get_mod_name() -> String:
	return "Setting the Pace"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/laff_it_up.png")

func get_description() -> String:
	return "More fights, no overworld bosses! You also feel faster..."
