extends AudioStreamPlayer3D

@export var skeleton : Skeleton3D
@export var bone : String
var bone_index : int

func _ready():
	bone_index = skeleton.find_bone(bone)
	print(bone_index)

func _process(delta):
	self.global_position = skeleton.get_bone_pose_position(bone_index)
