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

func generate_path(to : Vector3):
	await get_tree().physics_frame
	spider.nav_agent.set_target_position(to)
