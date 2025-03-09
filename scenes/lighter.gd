class_name Lighter
extends Node3D

signal lighter_toggled(open : bool)
signal immolation_time(time : float)

var open : bool = true

@export var light_area : Area3D
@export var close_and_open : AnimationPlayer


func open_lighter():
	if open:
		return
	
	close_and_open.play("open")
	await close_and_open.animation_finished
	open = true

func close_lighter():
	if !open:
		return

	close_and_open.play("close")
	await close_and_open.animation_finished
	open = false

func toggle_lighter():
	if open:
		close_lighter()
	else:
		open_lighter()
	lighter_toggled.emit(open)
