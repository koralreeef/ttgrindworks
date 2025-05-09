extends ItemScript

# This item runs a x second battle timer on every round
# And shuffles the order of gags on the menu
const pace_multi := 0.965
var ROUND_TIME := 10.0

const TIMER_ANCHOR := Control.PRESET_TOP_RIGHT
const SFX_TIMER = preload("res://audio/sfx/objects/moles/MG_sfx_travel_game_bell_for_trolley.ogg")

## Battle Timer created by Util
var timer: GameTimer
var loadout : GagLoadout

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_ended.connect(on_round_reset)
	BattleService.s_battle_started.connect(on_battle_start)

## Connect the gag track elements up to be shuffled
func on_battle_start(manager: BattleManager) -> void:
	await manager.s_ui_initialized
	initialize_ui(manager)

func initialize_ui(manager: BattleManager) -> void:
	var ui := manager.battle_ui
	for element: Control in ui.gag_tracks.get_children():
		element.s_refreshing.connect(on_track_refresh)
		element.refresh()
	
	# Also run the round reset method for this first round
	on_round_reset(manager)
	ui.s_turn_complete.connect(on_turn_complete)

## Shuffles the gag order of each track
func on_track_refresh(element: Control) -> void:
	var unlocked: int = element.unlocked
	if unlocked > 0:
		element.gags = element.gags.slice(0,unlocked)
		element.gags.shuffle()

## Runs the battle timer at the beginning of each round
func on_round_reset(manager: BattleManager) -> void:
	var player = Util.get_player()
	var THIS_ROUND_TIME = ROUND_TIME
	# Move to pacelover boost? idk
	if player.stats.speed_up != 0:
		THIS_ROUND_TIME = player.stats.remaining_time
		if THIS_ROUND_TIME > 7:
			# avoid decreasing timer if a battle stops
			if BattleService.ongoing_battle:
				player.stats.remaining_time = player.stats.remaining_time * 0.98
				if player.stats.remaining_time < 7:
					player.stats.remaining_time = 7.00
				THIS_ROUND_TIME = player.stats.remaining_time
				print("new round time: %.2f" % THIS_ROUND_TIME)
			else: 
				return
	 
	timer = Util.run_timer(THIS_ROUND_TIME, TIMER_ANCHOR)
	timer.timer.timeout.connect(on_timeout.bind(manager.battle_ui))
	timer.reparent(manager.battle_ui)
	if manager.cogs.size() > 0:
		AudioManager.play_sound(SFX_TIMER)

func on_timeout(ui: BattleUI) -> void:
	# Good way to tell if round isn't over is if the UI is still visible
	if not ui.visible:
		return
	ui.complete_turn()

func on_turn_complete(_gags: Array[ToonAttack]) -> void:
	if is_instance_valid(timer) and not timer.is_queued_for_deletion():
		timer.queue_free()
