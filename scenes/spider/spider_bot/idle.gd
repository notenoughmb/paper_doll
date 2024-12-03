extends State

@export_range(0, 30) var idle_time : float
@export_range(0, 10) var idle_time_offset : float

func enter():
	var new_time = idle_time + randf_range(-idle_time_offset, idle_time_offset)
	#look_at_tween(owner, Vector3.ZERO, new_time/2)
	await get_tree().create_timer(clampf(new_time, 0.0, idle_time)).timeout
	Transitioned.emit(self, "Roaming")
	
func exit():
	pass
	
func update(delta):
	pass
	
func physics_update(delta):
	pass

func look_at_tween(subject : Node3D, to : Vector3, time : float):
	var dummy = Node3D.new()
	self.add_child(dummy)
	dummy.global_transform.origin = subject.global_transform.origin
	dummy.look_at(to, Vector3.UP)
	var tween = create_tween()
	tween.tween_property(subject, "rotation_degrees", dummy.rotation_degrees, time)
	#return tween.finished
