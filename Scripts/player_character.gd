extends CharacterBody3D
@export var camera_speed:float = 0.01
@export var speed:float = 100
@export var max_speed:float = 100
@export var friction:float = 1.1
@onready var camera: SpringArm3D = $SpringArm3D
@onready var fpcam: Camera3D = $Armature/Camera3D
@onready var tree = $AnimationPlayer/AnimationTree
@onready var state = $AnimationPlayer/AnimationTree.get("parameters/playback")
@onready var mesh: Node3D = $Armature
@onready var book_reading_position:Node3D = $SpringArm3D/Camera3D/Marker3D
@onready var book_detector: RayCast3D = $SpringArm3D/Camera3D/book_detector
@onready var arrow: TextureRect = $CanvasLayer/arrow/TextureRect
@onready var booktimer: Timer = $booktimer
@export var booktime:float = 2
const ARROW = preload("uid://dpltywfej40xp")
const ARROW_SELECTED = preload("uid://bgrsvh3jk7p2e")
var book = -1
var uldbookpos:Vector3
var readbook:bool = false
var readingbook:bool = false
var velocity_on_a_plane = Vector2(0,0)
func _ready() -> void:
	camera.get_child(0).current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if book_detector.is_colliding() == true:
		arrow.texture = ARROW_SELECTED
	else:arrow.texture = ARROW
	if readingbook == false:
		if Input.get_vector("ui_left","ui_right","ui_up","ui_down") == null:
			velocity_on_a_plane = 0
		else:
			velocity_on_a_plane = Input.get_vector("ui_left","ui_right","ui_up","ui_down")*speed
		velocity += Vector3(velocity_on_a_plane.x,0,velocity_on_a_plane.y).rotated(Vector3.UP, camera.rotation.y)*delta
		velocity = Vector3(clampf(velocity.x,-max_speed,max_speed),velocity.y,clampf(velocity.z,-max_speed,max_speed))
	velocity /= friction
	tree.set("parameters/walk/blend_position", Vector2(velocity.x,velocity.z).rotated(camera.rotation.y))
	if readbook == true and readingbook == true:
		#fpcam.current = true
		var bookrp = book_reading_position.global_position
		book.position.x = lerpf(book.position.x,bookrp.x,(booktime-booktimer.time_left)/booktime)
		book.position.y = lerpf(book.position.y,bookrp.y,(booktime-booktimer.time_left)/booktime)
		book.position.z = lerpf(book.position.z,bookrp.z,(booktime-booktimer.time_left)/booktime)
		book.rotation.x = lerpf(book.rotation.x,camera.rotation.x+deg_to_rad(45),(booktime-booktimer.time_left)/booktime)
		book.rotation.y = lerpf(book.rotation.y,camera.rotation.y+deg_to_rad(180),(booktime-booktimer.time_left)/booktime)

	
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		if book_detector.is_colliding() == true and readingbook == false:
			book_read()
	if event.is_action("ui_cancel"):
		if readingbook== true:
			camera.get_child(0).current = true
			book.playanimation("close")
			book.returnbook(booktime,uldbookpos)
			readingbook = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and readingbook == false:
		camera.rotation.x -= event.relative.y * camera_speed 
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90,90) 
		camera.rotation.y -= event.relative.x * camera_speed 
		mesh.rotation.y = camera.rotation.y
	
func book_read():
	book = book_detector.get_collider().get_parent()
	uldbookpos = book.position
	booktimer.wait_time = booktime
	readbook = true
	readingbook=true
	book.playanimation("open")
	booktimer.start()
	print("read:"+book.name)



func _on_booktimer_timeout() -> void:
	readbook = false
