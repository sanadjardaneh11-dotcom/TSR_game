extends Control

var savedata:Dictionary
var file_controls = file_control.new()


func _ready() -> void:
	if file_controls.load_json_file() == null:
		file_controls.make_new_json_file()
	
	savedata = file_controls.load_json_file()
	file_controls.change_res(savedata["resulution"],get_window())

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/settings.tscn")


func _on_begin_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/Main.tscn")
