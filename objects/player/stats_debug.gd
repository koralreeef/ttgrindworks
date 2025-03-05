extends Label

# AUGHHH make a dict later
var remaining_time = 0
var battle_speed =  0
var damage = 0
var defense = 0
var luck = 0
var evasiveness = 0
var speed = 0
var squirt = 0
var trap = 0
var lure = 0
var sound = 0
var throw = 0
var drop = 0
var loadout = GagLoadout

func _ready() -> void:
	if SaveFileService.settings_file.show_timer:
		show()

func _process(delta: float) -> void:
	var fps = str(Engine.get_frames_per_second())
	if not Util.get_player():
		return
	else:
		var player = Util.get_player()
		remaining_time = player.stats.remaining_time
		battle_speed = player.stats.battle_speed
		speed = player.stats.speed
		if BattleService.ongoing_battle:
			damage = BattleService.ongoing_battle.battle_stats[Util.get_player()].damage
			defense = BattleService.ongoing_battle.battle_stats[Util.get_player()].defense
			evasiveness = BattleService.ongoing_battle.battle_stats[Util.get_player()].evasiveness
			luck = BattleService.ongoing_battle.battle_stats[Util.get_player()].luck
		else:
			damage = player.stats.damage
			defense = player.stats.defense
			evasiveness = player.stats.defense
			luck = player.stats.luck
		squirt = player.stats.gags_unlocked["Squirt"]
		trap = player.stats.gags_unlocked["Trap"]
		lure = player.stats.gags_unlocked["Lure"]
		sound = player.stats.gags_unlocked["Sound"]
		throw = player.stats.gags_unlocked["Throw"]
		drop = player.stats.gags_unlocked["Drop"]
		
	text = "fps: %s 
	battle speed: %.2fx 
	current timer: %.2fs 
	damage: %.2f 
	defense: %.2f
	evasiveness: %.2f
	luck: %.2f
	speed: %.2f
	squirt: lv.%.0f
	trap: lv.%.0f
	lure: lv.%.0f
	sound: lv.%.0f
	throw: lv.%.0f
	drop: lv.%.0f" % [
		fps,
		battle_speed, 
		remaining_time,
		damage,
		defense,
		evasiveness,
		luck,
		speed,
		squirt,
		trap,
		lure,
		sound,
		throw,
		drop]
