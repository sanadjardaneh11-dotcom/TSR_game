extends Node3D
@export var text:String
@onready var label: Label3D = $Armature/Skeleton3D/pages/Label3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var booktimer: Timer = $booktimer
@onready var cover: MeshInstance3D = $Armature/Skeleton3D/cover
@onready var pages: MeshInstance3D = $Armature/Skeleton3D/pages
var textures = {-1:preload("uid://di8l53w1sefi3"),0:preload("uid://b4aq4lgy2b4h8")}
var booktime = 1
var returnpos:Vector3
var returning:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Bookopen")
	animation_player.stop()
	label.text = text
	change_texture(0)
	label.hide()

func _process(delta: float) -> void:
	if returning == false:
		return
	position.x = lerpf(position.x,returnpos.x,(booktime-booktimer.time_left)/booktime)
	position.y = lerpf(position.y,returnpos.y,(booktime-booktimer.time_left)/booktime)
	position.z = lerpf(position.z,returnpos.z,(booktime-booktimer.time_left)/booktime)
	rotation.x = lerpf(rotation.x,deg_to_rad(0),(booktime-booktimer.time_left)/booktime)
	rotation.y = lerpf(rotation.y,deg_to_rad(0),(booktime-booktimer.time_left)/booktime)

func returnbook(time,pos:Vector3):
	label.hide()
	print(name+":going from "+str(position)+" back to"+str(pos))
	booktimer.wait_time = time
	booktime = time
	returnpos = pos
	booktimer.start()
	returning = true

func playanimation(animation):
	match animation:
		"open":
			animation_player.play("Bookopen")
		"close":
			animation_player.play_backwards("Bookopen")

func change_texture(texture_no:int):
	pages.material_override.albedo_texture = textures[texture_no]
	cover.material_override.albedo_texture = textures[texture_no]
	
func _on_booktimer_timeout() -> void:
	returning = false
