extends ItemScript


func on_collect(_item: Item, _model: Node3D) -> void:
	setup()
 
func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_toon_dealt_damage.connect(toon_dealt_damage)

func toon_dealt_damage(action: BattleAction, target: Node3D, amount: int):
	if action is not GagDrop and amount > 0:
		var manager := BattleService.ongoing_battle
		var shock : StatEffectAftershock = find_cog_aftershock(manager, target)
		if shock == null:
			return
		
		await manager.sleep(1.0)
		target.stats.hp -= shock.amount
		manager.battle_text(target, "-"+str(shock.amount), BattleText.colors.orange[0], BattleText.colors.orange[1])
		Util.get_player().boost_queue.queue_text("Shocking!", Color(0.208, 0.957, 1.0))
		target.set_animation('pie-small')
		await manager.sleep(2.0)
		
		if shock.rounds == 0:
			await BattleService.ongoing_battle.expire_status_effect(shock)
		elif shock.rounds > 0:
			shock.rounds -= 1

func find_cog_aftershock(manager: BattleManager, cog: Cog) -> StatEffectAftershock:
	for effect in manager.status_effects:
		if effect is StatEffectAftershock:
			if cog == effect.target:
				return effect
	return null
