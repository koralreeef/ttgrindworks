extends ItemScript

# This item runs a x second battle timer on every round
# And shuffles the order of gags on the menu
const pace_multi := 0.965
var ROUND_TIME := 10.0
var THIS_ROUND_TIME = ROUND_TIME

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

func initialize_ui(manager: BattleManager) -> void:
	RandomService.array_shuffle_channel('anomaly_reorg',Util.get_player().stats.character.gag_loadout.loadout)
	var ui := manager.battle_ui
	for element: Control in ui.gag_tracks.get_children():
		element.refresh()

## Runs the battle timer at the beginning of each round
func on_round_reset(manager: BattleManager) -> void:
	await manager.s_ui_initialized
	initialize_ui(manager)
	print("hey")
