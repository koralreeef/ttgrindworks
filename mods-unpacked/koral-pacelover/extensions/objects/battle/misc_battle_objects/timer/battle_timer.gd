extends "res://objects/battle/misc_battle_objects/timer/battle_timer.gd"

func start(time: float) -> void:
	super(time)
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(time)
	print("made it")
	timer.timeout.connect(
	func(): 
		print("timed out")
		s_timeout.emit()
		queue_free()
	)
