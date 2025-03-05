extends ItemScript

const DAMAGE_BOOST := 1.2

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_started.connect(round_started)

func round_started(actions : Array[BattleAction]) -> void:		
	if Globals.PACE_DAMAGE_BOOST == true:
		print("damage boost for ending turn!")
		for action in actions:
			if action is ToonAttack:
				action.damage *= DAMAGE_BOOST
				action.store_boost_text("Speedy Boost!", Color(0.854902, 0.439216, 0.839216))
