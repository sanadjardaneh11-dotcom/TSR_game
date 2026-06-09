extends CharacterBody3D

@export var speed = 100
@export var max_speed = 100
@export var friction = 1.1
var velocity_on_a_plane = Vector2(0,0)

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	velocity_on_a_plane = Input.get_vector("ui_left","ui_right","ui_up","ui_down")*speed
	velocity += Vector3(velocity_on_a_plane.x,0,velocity_on_a_plane.y)*delta
	velocity = Vector3(clampf(velocity.x,-max_speed,max_speed),velocity.y,clampf(velocity.z,-max_speed,max_speed))
	velocity /= friction
	
	print(velocity)
	

	move_and_slide()
