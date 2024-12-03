extends AudioStreamPlayer3D

@export var timeout : float
@export var random_offset : float

var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	self.add_child(timer)
	
	timer.wait_time = self.timeout
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(_timeout)

func _timeout():
	self.play()
	await self.finished
	timer.wait_time = timeout + randf_range(-random_offset, random_offset)
	timer.start()
