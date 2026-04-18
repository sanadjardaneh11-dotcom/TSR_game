extends Control

@onready var values: VBoxContainer = $HBoxContainer/Values
@onready var display_value: VBoxContainer = $"HBoxContainer/Display value"
var savepath = "res://savedata.json"
var settings:Dictionary
var numofsettings = 2
func _ready() -> void:
	load_json_file()
	values.get_child(0).value = settings["settings"][0]
	values.get_child(1).value = settings["settings"][1]
	for num in numofsettings:
		display_value.get_child(num).text = str(values.get_child(num).value)

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	settings = jsonobject.data
	return settings

func _on_value_changed(value: float) -> void:
	for num in numofsettings:
		display_value.get_child(num).text = str(values.get_child(num).value) 
