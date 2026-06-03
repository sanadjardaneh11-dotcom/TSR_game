extends Control
var allocation_points = 50
var stats = {"luck":1,"strength":1,"speed":1,"endurance":1,"wit":1}
@onready var label = $Label
var PLace_in_story = -1
@export var event = Resource.new()
func _input(event):
	if event.is_action_pressed("ACTION"):
		PLace_in_story += 1
	match PLace_in_story:
		0: text("HEllo")
			
		1: text("Welcome")
			
		2: text("Good eving")
			
		3: pass
			
		5: pass
			
		
func text(text):
	label.text = text
