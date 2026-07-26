extends Node3D

var startmoving:bool=false
var speed = 10
func start(Rotation,Position):
	rotation = Rotation
	position = Position
	startmoving = true

func _physics_process(delta: float) -> void:
	if startmoving != true:
		return
	position.x += speed*delta
