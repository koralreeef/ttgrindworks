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
	AudioManager.tween_music_pitch(0.5, player.stats.pitch)

func round_started(actions : Array[BattleAction]) -> void:		
	if Globals.PACE_DAMAGE_BOOST == true:
		AudioManager.play_sound(SUCCESS_SFX)
		print("damage boost for ending turn!")
		BattleService.ongoing_battle.battle_stats[Util.get_player()].damage *= DAMAGE_BOOST
		AudioManager.tween_music_pitch(0.5, player.stats.pitch)
		for action in actions:
			if action is ToonAttack:
				action.store_boost_text("Speedy Strike!", Color(0.854902, 0.439216, 0.839216))
	else: 
		AudioManager.play_sound(FAIL_SFX)
				
func on_round_reset(manager: BattleManager) -> void: 
	BattleService.ongoing_battle.battle_stats[player].damage = player.stats.damage
