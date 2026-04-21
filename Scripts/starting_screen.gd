extends Control

var savepath = "res://savedata.json"
var savedata:Dictionary
func _ready() -> void:
	load_json_file()
	
func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from file")
	savedata = jsonobject.data
	return savedata
	
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_begin_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
