extends "res://scenes/title_screen/title_screen.gd"

func create_toons() -> void:
	var toons := Globals.TOON_UNLOCK_ORDER.duplicate()
	for i in range(toons.size() -1, -1, -1):
		if i >= SaveFileService.progress_file.characters_unlocked:
			toons.remove_at(i)
	toons.append_array(CustomToonRegistry.CUSTOM_TOONS.duplicate())

	var starting_point := (-floorf(toons.size() / 2)) * TOON_SEPARATION
	if toons.size() % 2 == 0: starting_point += (TOON_SEPARATION / 2.0)
	
	for character : PlayerCharacter in toons:
		await Task.delay(0.25)
		var toon := spawn_toon(character)
		toon_origin.add_child(toon)
		toon.construct_toon(toon.toon_dna)
		spawn_accessories(character, toon)
		toon.position.x = starting_point
		starting_point += TOON_SEPARATION
		toon.teleport_in()
		toon.animator.animation_finished.connect(toon.animator.play.bind('neutral').unbind(1))

func spawn_accessories(character: PlayerCharacter, toon: Toon) -> void:
	for item: Item in character.starting_items:
		if item is not ItemAccessory:
			continue
		if item.slot != Item.ItemSlot.PASSIVE:
			var mod := item.model.instantiate()
			var player := Player.new()
			var bone := get_toon_bone(item,toon)
			for accessory in bone.get_children():
				accessory.queue_free()
			bone.add_child(mod)
			var placement := ItemAccessory.get_placement(item, toon.toon_dna)
			mod.position = placement.position
			mod.rotation_degrees = placement.rotation
			mod.scale = placement.scale
			if mod.has_method('setup'):
				mod.setup(item)

func get_toon_bone(item: ItemAccessory, toon: Toon) -> BoneAttachment3D:
	if not toon:
		return null
	match item.slot:
		ItemAccessory.ItemSlot.HAT:
			return toon.hat_bone
		ItemAccessory.ItemSlot.GLASSES:
			return toon.glasses_bone
		ItemAccessory.ItemSlot.BACKPACK:
			return toon.backpack_bone
	return null

func begin_game(character: PlayerCharacter, falling_scene := false) -> void:
	if has_existing_run:
		SaveFileService.progress_file.win_streak = 0

	SaveFileService.delete_run_file()
	RandomService.generate_seed()
	Util.floor_number = -1
	# Create the player object
	var player: Player = PLAYER.instantiate()
	player.stats = PlayerStats.new()
	player.stats.character = character.duplicate(true)
	player.reset_stats()
	CustomToonRegistry.setup(player)
	player.stats.max_out()
	SceneLoader.add_persistent_node(player)
	SaveFileService.progress_file.new_games += 1
	if falling_scene:
		SceneLoader.load_into_scene("res://scenes/falling_scene/falling_scene.tscn")
	else:
		SceneLoader.load_into_scene("res://scenes/cog_building/cog_building_floor.tscn")
