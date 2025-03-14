extends ItemScript

# its only fair to require four different tracks to get the defense boost right?
var max_track_count := 1
var required_tracks: Array[Track] = []
var banned_track: Array[Track] = []
const DAMAGE_BOOST := 1.2
const DEFENSE_BOOST := 1.2
var banned := false
var shielded := false
const SUCCESS_SFX := preload("res://audio/sfx/misc/MG_pairing_match_bonus_both.ogg")
const FAIL_SFX := preload("res://audio/sfx/misc/MG_neg_buzzer.ogg")

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_started.connect(round_started)
	BattleService.s_round_ended.connect(on_round_reset)
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(manager: BattleManager) -> void:
	max_track_count = Util.get_player().stats.turns - 1
	AudioManager.tween_music_pitch(0.5, Util.get_player().stats.pitch)
	await manager.s_ui_initialized
	var ui: BattleUI = manager.battle_ui
	manager.s_round_ended.connect(on_round_start.bind(ui))
	on_round_start(ui)
	
func on_round_start(ui: BattleUI) -> void:
	var player = Util.get_player()
	reset_track_colors(ui)
	required_tracks = []
	banned_track = []
	var loadout := Util.get_player().character.gag_loadout.loadout.duplicate()
	while loadout.size() > 0 and required_tracks.size() < max_track_count:
		RandomService.array_shuffle_channel('wheezer_ability', loadout)
		required_tracks.append(loadout.pop_back())
	
	RandomService.array_shuffle_channel('wheezer_ability', loadout)
	banned_track.append(loadout.pop_back())
	
	# Change button colors
	for i in required_tracks.size():
		var element := ui.get_track_element(required_tracks[i])
		
		for button in element.gag_buttons:
			button.default_color = Color.REBECCA_PURPLE
			
	var element2 := ui.get_track_element(banned_track[0])	
	
	for button in element2.gag_buttons:
		button.default_color = Color.FIREBRICK
		
func round_started(actions : Array[BattleAction]) -> void:	
	# this might be dogshit
	var toonActions := []
	var player = Util.get_player()
	for action in actions:
		if action is ToonAttack:
			toonActions.append(action)
			
	var selected_tracks := []
	var requiredTrackType := []
	var bannedTrackType := []
	for action in toonActions:
		for track in required_tracks:
			for required in track.gags:
				# DEVS PLEASE ADD A TRACK NAME VARIABLE TO ACTIONS PLEASEEEEEEEEEEEEE
				if not requiredTrackType.has(track.track_name) and required.action_name == action.action_name:
					requiredTrackType.append(track.track_name)
					# print("appended %s " % track.track_name)
					
	# future proofing in case one banned gag was too easy
	for action in toonActions:
		for track in banned_track:
			for banned in track.gags:
				if not bannedTrackType.has(track.track_name) and banned.action_name == action.action_name:
					bannedTrackType.append(track.track_name)
	
	print(requiredTrackType)		
	if bannedTrackType.size() == 1:
		print("chose a banned gag!!")
		banned = true
		Util.get_player().boost_queue.queue_text("Weak!", Color(0.54, 0.02, 0.06))
		
	elif requiredTrackType.size() == max_track_count:
		print("defense boost for fulfilling jobs!")
		shielded = true
		Util.get_player().boost_queue.queue_text("Shielded!", Color(0.40, 0.20, 0.60))

	for action in actions:
		if shielded == true:
			if action is CogAttack:
				action.damage *= 0.8
		elif banned == true:
			if action is CogAttack:
				action.damage *= 1.5
			
	if Globals.PACE_DAMAGE_BOOST == true:
		AudioManager.play_sound(SUCCESS_SFX)
		print("damage boost for ending turn!")
		player.stats.pitch *= 1.005
		if player.stats.pitch > 1.40:
			player.stats.pitch = 1.40
		AudioManager.tween_music_pitch(0.5, player.stats.pitch)
		
		for action in toonActions:
			action.damage *= DAMAGE_BOOST
			action.store_boost_text("Speedy Strike!", Color(0.854902, 0.439216, 0.839216))
	
	else: 
		AudioManager.play_sound(FAIL_SFX)
				
func on_round_reset(manager: BattleManager) -> void: 
	banned == false
	shielded == false
	
func reset_track_colors(ui: BattleUI) -> void:
	for track_element in ui.gag_tracks.get_children():
		for button in track_element.gag_buttons:
			button.default_color = Color("00a1ff")
			
#func on_turn_complete(_gags: Array[ToonAttack]) -> void:	
#	var checkDupe: Array[ToonAttack] = []
#	for gag in _gags:
#		checkDupe.append(gag.track_name)
#		print(gag.track_name)
