extends CharacterBody3D
@export var camera_speed = 0.1
@export var speed = 100
@export var max_speed = 100
@export var friction = 1.1
@onready var camera: SpringArm3D = $SpringArm3D
@onready var tree = $AnimationPlayer/AnimationTree
@onready var state = $AnimationPlayer/AnimationTree.get("parameters/playback")
@onready var mesh: Node3D = $Armature
@onready var book_detector: RayCast3D = $SpringArm3D/Camera3D/book_detector
@onready var arrow: TextureRect = $CanvasLayer/arrow/TextureRect
const ARROW = preload("uid://dpltywfej40xp")
const ARROW_SELECTED = preload("uid://bgrsvh3jk7p2e")

var velocity_on_a_plane = Vector2(0,0)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if book_detector.is_colliding() == true:
		arrow.texture = ARROW_SELECTED
	else:arrow.texture = ARROW
	velocity_on_a_plane = Input.get_vector("ui_left","ui_right","ui_up","ui_down")*speed
	velocity += Vector3(velocity_on_a_plane.x,0,velocity_on_a_plane.y).rotated(Vector3.UP, camera.rotation.y)*delta
	velocity = Vector3(clampf(velocity.x,-max_speed,max_speed),velocity.y,clampf(velocity.z,-max_speed,max_speed))
	velocity /= friction
	tree.set("parameters/walk/blend_position", Vector2(velocity.x,velocity.z).rotated(camera.rotation.y))

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		if book_detector.is_colliding() == true:
			book_read()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.relative.y * camera_speed 
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90,90) 
		camera.rotation.y -= event.relative.x * camera_speed 
		mesh.rotation.y = camera.rotation.y
	
func book_read():
	print("read book")
