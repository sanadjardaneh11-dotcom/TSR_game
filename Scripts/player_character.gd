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
@onready var general_perpose_detector: RayCast3D = $SpringArm3D/Camera3D/GeneralPerposeDetector
@onready var arrow: TextureRect = $CanvasLayer/ui/crossair
@onready var heathdisplay = [$CanvasLayer/ui/Heath/maxhp, $CanvasLayer/ui/Heath/hp]
@onready var weapon_inspect_screen: Control = $"CanvasLayer/weapon inspect screen"
@onready var weapon_visuals: MeshInstance3D = $Armature/Skeleton3D/BoneAttachment3D/WeaponVisuals
@onready var booktimer: Timer = $booktimer
@onready var chargetimer: Timer = $ChargeTimer
@export var booktime:float = 2
const SPELL = preload("uid://b4pqw4qx07mbg")
const ARROW = preload("uid://c8iftsmvdya3o")
const ARROW_SELECTED = preload("uid://10adgrd0va8k")
var object = -1
var uldbookpos:Vector3
var readbook:bool = false
var readingbook:bool = false
var velocity_on_a_plane = Vector2(0,0)
var hp:float
var savedata = {}
var file = file_control.new()
var damgecalc = DamageCalculations.new()
var maxhp:float
var charge = null
var Weapon_data = { "name": "Bare hands", "type":-1, "mesh":0, "animationtype":0, "damge": 1, "speed": 1.0, "req": 0 }

func _ready() -> void:
	camera.get_child(0).current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	savedata = file.load_json_file()
	hp = savedata["hp"]
	maxhp = savedata["maxhp"]
	heathdisplay[0].text = str(int(maxhp))+"/"
	heathdisplay[1].text = str(int(hp))


func _physics_process(delta: float) -> void:
	heathdisplay[0].text = str(int(maxhp))+"/"
	heathdisplay[1].text = str(int(hp))
	if general_perpose_detector.is_colliding() == true:
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
	tree.set("parameters/walk/blend_position", Vector2(velocity.x,velocity.z).rotated(camera.rotation.y)*0.1)
	if readbook == true and readingbook == true:
		#fpcam.current = true
		var bookrp = book_reading_position.global_position
		object.position.x = lerpf(object.position.x,bookrp.x,(booktime-booktimer.time_left)/booktime)
		object.position.y = lerpf(object.position.y,bookrp.y,(booktime-booktimer.time_left)/booktime)
		object.position.z = lerpf(object.position.z,bookrp.z,(booktime-booktimer.time_left)/booktime)
		object.rotation.x = lerpf(object.rotation.x,camera.rotation.x+deg_to_rad(45),(booktime-booktimer.time_left)/booktime)
		object.rotation.y = lerpf(object.rotation.y,camera.rotation.y+deg_to_rad(180),(booktime-booktimer.time_left)/booktime)

	
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		if general_perpose_detector.is_colliding() == true and readingbook == false:
			book_read()
	if event.is_action("ui_cancel"):
		if readingbook== true:
			camera.get_child(0).current = true
			object.playanimation("close")
			object.returnbook(booktime,uldbookpos)
			readingbook = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			match event.button_mask:
				1:
					print("Left click")
					charge = -1
					chargetimer.start()
				2:
					print("right click")
				4:
					print("middle click")
		if event.pressed == false:
			print("button released")
			if charge != null:
				charge = (chargetimer.wait_time-chargetimer.time_left)
				chargetimer.stop()
				var spell = SPELL.instantiate()
				add_sibling(spell)
				spell.start(Vector3(0,mesh.rotation.y,camera.rotation.x),position,charge)
				charge = null
	if event is InputEventMouseMotion and readingbook == false:
		camera.rotation.x -= event.relative.y * camera_speed 
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90,90) 
		camera.rotation.y -= event.relative.x * camera_speed 
		mesh.rotation.y = camera.rotation.y
	
func book_read():
	object = general_perpose_detector.get_collider().get_parent()
	print(object.name+"'s collision layer:"+str(object.get_child(0).get_collision_layer()))
	if object.get_child(0).get_collision_layer() != 8:
		if object.get_child(0).get_collision_layer() == 32:
			weapon_inspect()
			return
		return
	if object.returning == true:
		return
	object.label.show()
	uldbookpos = object.position
	booktimer.wait_time = booktime
	readbook = true
	readingbook=true
	object.playanimation("open")
	booktimer.start()
	print("read:"+object.name)

func weapon_inspect():
	print(object.name+" is being inspected")
	weapon_inspect_screen.show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _on_booktimer_timeout() -> void:
	readbook = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	hp-=damgecalc.damagetaken(area.damge,0,savedata["stats"]["endurance"])
	


func _on_leave_weapon_pressed() -> void:
	weapon_inspect_screen.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_take_weapon_pressed() -> void:
	print(object.name+"'s data:"+str(object.weapondata))
	weapon_visuals.mesh = object.weapondata["mesh"]
	object.queue_free()
	weapon_inspect_screen.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
