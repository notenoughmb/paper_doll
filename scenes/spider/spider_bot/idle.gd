extends State

@export_range(0, 30) var idle_time : float
@export_range(0, 10) var idle_time_offset : float

func enter():
	await get_tree().physics_frame
	owner.spotlight_burst_move(2.0)
	var new_time = idle_time + randf_range(-idle_time_offset, idle_time_offset)
	await get_tree().create_timer(clampf(new_time, 0.0, idle_time)).timeout
	Transitioned.emit(self, "Roaming")
	
func exit():
	pass
	
func update(delta):
	pass
	
func physics_update(delta):
	pass
