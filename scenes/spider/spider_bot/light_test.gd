extends OmniLight3D

var min_energy = 0.0
var max_energy = 2.0
var energy_step = 0.25
var energy_decay = 1.0

var energy : float = min_energy

func _ready() -> void:
	$"../../../../../FrontLeftIKTarget".step_energy.connect(_on_energy_received)
	$"../../../../../BackLeftIKTarget".step_energy.connect(_on_energy_received)
	$"../../../../../FrontRightIKTarget".step_energy.connect(_on_energy_received)
	$"../../../../../BackRightIKTarget".step_energy.connect(_on_energy_received)
	

func _process(delta: float) -> void:
	energy -= delta * energy_decay
	energy = clampf(energy, min_energy, max_energy)
	print(energy)
	self.light_energy = energy

func _on_energy_received():
	energy += energy_step
