extends ItemScript

var loadout : GagLoadout

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

## Connect the gag track elements up to be shuffled
func on_battle_start(manager: BattleManager) -> void:
	RandomService.array_shuffle_channel('anomaly_reorg',Util.get_player().stats.character.gag_loadout.loadout)
