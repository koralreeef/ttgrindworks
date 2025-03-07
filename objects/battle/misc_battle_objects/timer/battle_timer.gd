extends Control
class_name GameTimer

var timer: Timer
const SFX_TIMER = preload("res://audio/sfx/objects/moles/MG_sfx_travel_game_bell_for_trolley.ogg")
signal s_timeout

var tween: Tween:
	set(x):
		if tween and tween.is_valid():
			tween.kill()
		tween = x

func start(time: float) -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(time)
	if Util.get_player().character.character_name == "pacelover2000":
		Globals.PACE_DAMAGE_BOOST = true
	timer.timeout.connect(
	func(): 
		Globals.PACE_DAMAGE_BOOST = false
		print("timed out :(")
		s_timeout.emit()
		queue_free()
	)

func _process(_delta) -> void:
	if timer:
		$TimeLabel.set_text(str(int(floor(timer.time_left))))
		%TimeLabel.label_settings.font_color = Color.RED if timer.time_left <= 6 else Color.BLACK
		# DUDE LOL
		if timer.time_left >= 3.31 and timer.time_left <= 3.33:
			var audio_player := AudioManager.play_snippet(SFX_TIMER)
			audio_player.pitch_scale = 1.15

func scale_pop() -> void:
	tween = Sequence.new([
		LerpProperty.new(self, ^"scale", 0.2, Vector2.ONE * 1.2).interp(Tween.EASE_OUT),
		LerpProperty.new(self, ^"scale", 0.2, Vector2.ONE * 1.0).interp(Tween.EASE_IN),
	]).as_tween(self)
