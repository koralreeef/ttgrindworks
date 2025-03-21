extends GagLure
class_name PseudoLure

func action() -> void:
	
	var barrier_turn := SignalBarrier.new()
	barrier_turn._barrier_type = SignalBarrier.BarrierType.ALL
	
	set_camera_angle(camera_angles['SIDE_RIGHT'])
	
	for target in targets:
		var walk_tween := create_walk_tween(target)
		barrier_turn.append(walk_tween.finished)
		
	await manager.barrier(barrier_turn.s_complete, 15.0)
	
	for target in targets:
		if target.trap:
			target.trap.activate()
			barrier_turn.append(target.trap.s_trap)
	
	await manager.barrier(barrier_turn.s_complete, 15.0)

func create_walk_tween(cog: Cog) -> Tween:
	var walk_tween := manager.create_tween()
	walk_tween.tween_callback(cog.set_animation.bind('walk'))
	walk_tween.tween_property(cog.get_node('Body'), 'position:z', Globals.SUIT_LURE_DISTANCE, 0.5)
	walk_tween.tween_callback(cog.set_animation.bind('neutral'))
	
	return walk_tween
