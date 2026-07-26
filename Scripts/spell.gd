extends Node3D

var startmoving:bool=false
var speed = 10
func start(Rotation,Position):
	rotation = Rotation - Vector3(0,deg_to_rad(-90),0)
	position = Position
	startmoving = true

func _physics_process(delta: float) -> void:
	if startmoving != true:
		return
	position += Vector3(1,0,0).rotated(Vector3.UP,rotation.y)*speed*delta
