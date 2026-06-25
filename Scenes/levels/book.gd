extends Node3D
@export var text:String
@onready var label: Label3D = $MeshInstance3D/Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text
