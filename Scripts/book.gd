extends Node3D
@export var text:String
@onready var label: Label3D = $Armature/Skeleton3D/pages/Label3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var booktimer: Timer = $booktimer
var booktime = 1
var returnpos:Vector3
var returning:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text

func _process(delta: float) -> void:
	if returning == false:
		return
	position.x = lerpf(position.x,returnpos.x,(booktime-booktimer.time_left)/booktime)
	position.y = lerpf(position.y,returnpos.y,(booktime-booktimer.time_left)/booktime)
	position.z = lerpf(position.z,returnpos.z,(booktime-booktimer.time_left)/booktime)
	rotation.x = lerpf(rotation.x,deg_to_rad(0),(booktime-booktimer.time_left)/booktime)
	rotation.y = lerpf(rotation.y,deg_to_rad(0),(booktime-booktimer.time_left)/booktime)

func returnbook(time,pos:Vector3):
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


func _on_booktimer_timeout() -> void:
	returning = false
