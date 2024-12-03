extends Node3D

@export var move_speed : float = 5.0
@export var turn_speed : float = 1.0
@export var ground_offset: float = 0.5

@onready var fl_target = $Armature/FrontLeftIKTarget
@onready var fr_target = $Armature/FrontRightIKTarget
@onready var bl_target = $Armature/BackLeftIKTarget
@onready var br_target = $Armature/BackRightIKTarget

@onready var destination = $Destination


func _process(delta):
	
	var plane1 = Plane(bl_target.global_position, fl_target.global_position, fr_target.global_position)
	var plane2 = Plane(fr_target.global_position, br_target.global_position, bl_target.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, move_speed * delta).orthonormalized()
	
	var avg = (fl_target.position + fr_target.position + bl_target.position + br_target.position) / 4
	var target_pos = avg + transform.basis.y * ground_offset
	var distance = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
	
	_movement(delta)


func _movement(delta):
	var dir = self.global_position.direction_to(destination.global_position) 
	translate(Vector3(dir.x, 0, dir.z) * move_speed * delta)


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
