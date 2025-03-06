extends ItemScript

const DAMAGE_BOOST := 1.2
const SUCCESS_SFX := preload("res://audio/sfx/misc/MG_pairing_match_bonus_both.ogg")
const FAIL_SFX := preload("res://audio/sfx/misc/MG_neg_buzzer.ogg")
var player = Util.get_player()

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_started.connect(round_started)
	BattleService.s_round_ended.connect(on_round_reset)
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(manager: BattleManager) -> void:
	var player = Util.get_player()
	AudioManager.tween_music_pitch(0.5, player.stats.pitch)
	await manager.s_ui_initialized
	initialize_ui(manager)

func initialize_ui(manager: BattleManager) -> void:
	var ui := manager.battle_ui
	ui.s_turn_complete.connect(on_turn_complete)
		
func round_started(actions : Array[BattleAction]) -> void:		
	var player = Util.get_player()

	if Globals.PACE_DAMAGE_BOOST == true:
		AudioManager.play_sound(SUCCESS_SFX)
		print("damage boost for ending turn!")
		BattleService.ongoing_battle.battle_stats[Util.get_player()].damage *= DAMAGE_BOOST
		player.stats.pitch *= 1.005
		AudioManager.tween_music_pitch(0.5, player.stats.pitch)
		for action in actions:
			if action is ToonAttack:
				print(action.action_name)
				action.store_boost_text("Speedy Strike!", Color(0.854902, 0.439216, 0.839216))
	else: 
		AudioManager.play_sound(FAIL_SFX)
				
func on_round_reset(manager: BattleManager) -> void: 
	var player = Util.get_player()
	BattleService.ongoing_battle.battle_stats[player].damage = player.stats.damage
	
#func on_turn_complete(_gags: Array[ToonAttack]) -> void:	
#	var checkDupe: Array[ToonAttack] = []
#	for gag in _gags:
#		checkDupe.append(gag.track_name)
#		print(gag.track_name)
