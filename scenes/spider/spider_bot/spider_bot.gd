class_name SpiderBot
extends Node3D

#region ugly

@export var debug := false

@export var move_speed: float = 5.0
@export var turn_speed: float = 1.0
@export var ground_offset: float = 0.5

@export_group("Nodes")

@export var model : Node3D

@export var player : Player
@export var spotlight : SpotLight3D
@export var long_detection : Area3D
@export var proximity_detection : Area3D

@export var walk_to : Area3D
@export var detect_walk_to: Area3D
@export var nav_agent : NavigationAgent3D

@onready var fl_leg = $FrontLeftIKTarget
@onready var fr_leg = $FrontRightIKTarget

@onready var bl_leg = $BackLeftIKTarget
@onready var br_leg = $BackRightIKTarget

#endregion

var rotation_allowed : = true

func _ready():
	if randi_range(1, 10) == 1:
		print("bear mode activated")
		$Sprite3D.visible = true
	nav_agent.path_height_offset = -self.ground_offset

func _process(delta):
	
	var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis.orthonormalized(), target_basis.orthonormalized(), move_speed * delta).orthonormalized()
	
	var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4
	var target_pos = avg + transform.basis.y * ground_offset
	var distance = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
	
	_handle_movement(delta)
	

#roaming state is chiefly responsible for movement
func _handle_movement(delta):
	if debug:
		var dir = Input.get_axis('ui_down', 'ui_up')
		translate(Vector3(0, 0, -dir) * move_speed * delta)
	
		var a_dir = Input.get_axis('ui_right', 'ui_left')
		translate(Vector3(-a_dir, 0, 0) * move_speed * delta)
	
	

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
