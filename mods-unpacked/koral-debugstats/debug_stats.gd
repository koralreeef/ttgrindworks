extends Control

# AUGHHH make a dict later
var label := Label.new()
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
var battle_speed = 0
var loadout = GagLoadout

func _ready() -> void:
	# top level node so it doesn't get destroyed when switching scenes
	label.set_as_top_level(false)
	name = "debug stats"
	label.self_modulate = Color(1, 1, 1, 0.737255)
	label.set("theme_override_fonts/font", load("res://fonts/Minnie.TTF"))
	label.set("theme_override_font_sizes/font_size", 14)
	label.set("theme_override_constants/shadow_outline_size", 3)
	label.set("theme_override_colors/font_shadow_color", Color(0.0862745, 0.0862745, 0.0862745, 0.615686))
	label.layout_mode = 1
	label.offset_left = 4.0
	label.offset_top = 142.0
	label.offset_right = 146.0
	label.offset_bottom = 171.0
	print("p[enis]")
	add_child(label)
	set_process(true)

func _process(_delta):
	var fps = str(Engine.get_frames_per_second())
	if not Util.get_player():
		label.set_text("fps: %s
		waiting for player..." % fps)
		return
	else:
		var player = Util.get_player()
		battle_speed = SettingsFile.SpeedOptions[SaveFileService.settings_file.get('battle_speed_idx')]
		speed = player.stats.speed
		
		if BattleService.ongoing_battle != null:
			damage = BattleService.ongoing_battle.battle_stats[Util.get_player()].damage
			defense = BattleService.ongoing_battle.battle_stats[Util.get_player()].defense
			evasiveness = BattleService.ongoing_battle.battle_stats[Util.get_player()].evasiveness
			luck = BattleService.ongoing_battle.battle_stats[Util.get_player()].luck
		else:
			damage = player.stats.damage
			defense = player.stats.defense
			evasiveness = player.stats.evasiveness
			luck = player.stats.luck
			
		squirt = player.stats.gags_unlocked["Squirt"]
		trap = player.stats.gags_unlocked["Trap"]
		lure = player.stats.gags_unlocked["Lure"]
		sound = player.stats.gags_unlocked["Sound"]
		throw = player.stats.gags_unlocked["Throw"]
		drop = player.stats.gags_unlocked["Drop"]
		
	label.set_text("fps: %s 
	battle speed: %.2fx 
	
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
	)
