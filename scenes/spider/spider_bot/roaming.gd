extends State

var dummy

@onready var spider : SpiderBot = owner
@onready var navigation_agent = spider.nav_agent


func enter():
	generate_path.call_deferred(Vector3(randf_range(-30, 30), 0, randf_range(-30, 30)))

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	if navigation_agent.is_navigation_finished():
		Transitioned.emit(self, "Idle")

	var current_agent_position: Vector3 = spider.global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	

	var adjusted: Vector3 = Vector3(next_path_position)
	adjusted.y = spider.ground_offset
	spider.translate(current_agent_position.direction_to(next_path_position) * spider.move_speed * delta)

func look_at_tween(subject : Node3D, to : Vector3, time : float):
	var dummy = Node3D.new()
	self.add_child(dummy)
	dummy.global_transform.origin = subject.global_transform.origin
	dummy.look_at(to, Vector3.UP)
	var tween = create_tween()
	tween.tween_property(subject, "rotation_degrees", dummy.rotation_degrees, time)
	#return tween.finished

func generate_path(to : Vector3):
	await get_tree().physics_frame
	spider.nav_agent.set_target_position(to)
	look_at_tween(spider.model, to, 2)
	#_turn_to_next_pos({})

func _turn_to_next_pos(details : Dictionary):
	pass
	#spider.look_at(navigation_agent.get_next_path_position(), Vector3.UP)
	#look_at_tween(spider, spider.rotation_degrees, navigation_agent.get_next_path_position(), 2.0)
