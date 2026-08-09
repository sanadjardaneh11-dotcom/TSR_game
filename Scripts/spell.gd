extends Node3D

@onready var timer: Timer = $Timer
var startmoving:bool=false
@export var length = 1
@export var bullet_time = 1
@onready var collision_shape: CollisionShape3D = $Area3D/CollisionShape3D
@onready var mesh_shape: Node3D = $Node3D

func start(Rotation,Position,chargetime):
	rotation = Rotation - Vector3(0,deg_to_rad(-90),0)
	position = Position
	length = chargetime
	startmoving = true
	timer.start()

func _physics_process(delta: float) -> void:
	if startmoving != true:
		return
	if bullet_time < 0:
		queue_free()
	bullet_time -= 1*delta
	mesh_shape.scale += Vector3(1,0,0).rotated(Vector3.UP,mesh_shape.rotation.z)*length*((timer.time_left)/timer.wait_time)
	collision_shape.shape.height += length*((timer.time_left)/timer.wait_time)
	collision_shape.position += Vector3(.5,0,0).rotated(Vector3.UP,collision_shape.rotation.z)*length*((timer.time_left)/timer.wait_time)
