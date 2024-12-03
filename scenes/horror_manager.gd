class_name HorrorManager
extends Node3D

@export var min_radius : float
@export var max_radius : float
@export var sound_threshold : int = 600

@export_category("Nodes")
@export var player : Player

var allowed : bool

var lighter_open : bool
var lighter_radius : Area3D
var horror_factor : int

@onready var sound_scene = preload("res://scenes/horror_sound.tscn")

func _ready():
	lighter_radius = player.LIGHTER.light_area
	await get_tree().create_timer(10).timeout
	_spawn_sound()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lighter_open = player.LIGHTER.open
	if !lighter_open:
		horror_factor += delta * 60 * randi_range(0, 3)
	else:
		horror_factor = 0
	if horror_factor > sound_threshold:
		horror_factor = 0
		if allowed:
			_spawn_sound()

func _spawn_sound():
	allowed = false
	var new_sound : HorrorSound = sound_scene.instantiate()
	self.add_child(new_sound)
	new_sound.global_position = Vector3(randf_range(min_radius, max_radius), randf_range(min_radius, max_radius), player.global_position.z)
	await new_sound.animation_signal
	new_sound.queue_free()
	allowed = true
	
