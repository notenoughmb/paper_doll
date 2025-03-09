class_name SpiderBot
extends Node3D

@export var move_speed: float = 5.0
@export var turn_speed: float = 1.0
@export var ground_offset: float = 0.5

# nodes!
@export var nav_agent : NavigationAgent3D
@export var model : Node3D
@export var spotlight : SpotLight3D

@onready var fl_leg = $FrontLeftIKTarget
@onready var fr_leg = $FrontRightIKTarget

@onready var bl_leg = $BackLeftIKTarget
@onready var br_leg = $BackRightIKTarget

var hori_deg_spotlight_offset : float = 30.0
var vert_deg_spotlight_offset : float = 5.0

func _process(delta):
	var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, move_speed * delta).orthonormalized()
	
	var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4
	var target_pos = avg + transform.basis.y * ground_offset
	var distance = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
	
	_handle_movement(delta)

func _handle_movement(delta):
	var dir = Input.get_axis('ui_down', 'ui_up')
	translate(Vector3(0, 0, -dir) * move_speed * delta)
	
	var a_dir = Input.get_axis('ui_right', 'ui_left')
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 
	
	return result

func spotlight_move_rand(duration : float):
	var hori_spotlight_offset = deg_to_rad(hori_deg_spotlight_offset)
	var vert_spotlight_offset = deg_to_rad(vert_deg_spotlight_offset)
	var random_vector : Vector3 = Vector3.FORWARD.rotated(Vector3.UP, randf_range(-hori_spotlight_offset, hori_spotlight_offset))
	random_vector = random_vector.rotated(Vector3.LEFT, randf_range(-vert_spotlight_offset, vert_spotlight_offset))
	#random_vector = random_vector.rotated(Vector3.LEFT, deg_to_rad(-5))
	
	print(hori_spotlight_offset)
	spotlight_move_targeted(random_vector, duration)

func spotlight_move_targeted(new_rotation : Vector3, duration : float):
	var dummy = Node3D.new()
	var to_move = $Armature/Skeleton3D
	to_move.add_child(dummy)
	dummy.global_transform.origin = to_move.global_transform.origin
	dummy.global_rotation = new_rotation
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(spotlight, "global_rotation", dummy.global_rotation, duration/2)
	tween.tween_property(to_move, "rotation:x", dummy.rotation.x, duration)
	tween.tween_property(to_move, "rotation:y", dummy.rotation.y, duration)
	tween.tween_callback(func() : dummy.queue_free())

func spotlight_burst_move(delay : float, rand_delay : float = 0.0, moves : int = 3):
	if moves < 0:
		return 
	print(moves)
		
	spotlight_move_rand(delay / 2)
	var timer = get_tree().create_timer(delay)
	await timer.timeout
	spotlight_burst_move(delay, rand_delay, moves - 1)
		#i -= 1
		#print(i)
		#if i < 0:
			#timer.queue_free()
		#else:
			#spotlight_move_rand(delay/2))

func spotlight_ai():
	pass
