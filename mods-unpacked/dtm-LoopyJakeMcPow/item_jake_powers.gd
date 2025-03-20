extends ItemScript


func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(manager: BattleManager) -> void:
	manager.s_actions_ended.connect(check_traps)

func check_traps() -> void:
	var manager := BattleService.ongoing_battle
	var pseudo_lure = PseudoLure.new()
	pseudo_lure.user = Util.get_player()
	for cog in manager.cogs:
		var trap_damage := manager.get_damage(cog.trap.damage, cog.trap, cog)
		if cog.trap:
			print(trap_damage, cog.stats.hp)
		else:
			continue
		if trap_damage >= cog.stats.hp:
			pseudo_lure.targets.append(cog)
			cog.trap.activating_lure = pseudo_lure
	if not pseudo_lure.targets.is_empty():
		BattleService.ongoing_battle.round_end_actions.append(pseudo_lure)
