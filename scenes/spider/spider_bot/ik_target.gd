extends Marker3D

signal step_energy

@export var step_target: Node3D
@export var step_distance: float = 3.0

@export var adjacent_target: Node3D
@export var opposite_target: Node3D

@onready var step_sound : AudioStreamPlayer3D = $"../Step"

var is_stepping := false

func _process(delta):
	if !is_stepping && !adjacent_target.is_stepping && abs(global_position.distance_to(step_target.global_position)) > step_distance:
		step()
		opposite_target.step()

func step():
	var target_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	step_sound.play()
	step_energy.emit()
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func(): is_stepping = false)
