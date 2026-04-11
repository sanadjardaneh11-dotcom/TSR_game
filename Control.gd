extends Control
var allocation_points = 50
var stats = {"luck":1,"strength":1,"speed":1,"endurance":1,"wit":1}
@onready var label = $Label
func _ready():
	label.
func _input(event):
	if event.is_action_pressed("ACTION"):
		label.text = "CHOOSE YOUR STATS"
