extends Node

@onready var music: HSlider = $settings/SliderSettings/Values/Music
@onready var sounds: HSlider = $settings/SliderSettings/Values/Sounds
@onready var res: HSlider = $settings/SliderSettings/Values/Size
@onready var dispmusic: Label = $"settings/SliderSettings/Display value/Music"
@onready var dispsounds: Label = $"settings/SliderSettings/Display value/Sounds"
@onready var dispres: Label = $"settings/SliderSettings/Display value/Size"
@onready var file_controls = file_control.new()
var savedata:Dictionary
func _ready() -> void:
	savedata = file_controls.load_json_file()
	music.value = savedata["settings"][0]
	print("Loaded value"+str(savedata["settings"][0])+"to music")
	sounds.value = savedata["settings"][1]
	print("Loaded value"+str(savedata["settings"][1])+"to sounds")
	res.value = savedata["settings"][2]
	print("Loaded value"+str(savedata["settings"][2])+"to res")
	dispmusic.text = str(music.value)
	dispsounds.text = str(sounds.value)
	dispres.text = str(res.value)
	


func _on_music_value_changed(value: float) -> void:
	dispmusic.text = str(music.value) 
	savedata["settings"][0] = music.value


func _on_sounds_value_changed(value: float) -> void:
	dispsounds.text = str(sounds.value) 
	savedata["settings"][1] = sounds.value


func _on_size_value_changed(value: float) -> void:
	if res.value == 5:
		dispres.text = "Fullscreen"
		savedata["settings"][3] = 1.0
	else:
		dispres.text = str(res.value)
		savedata["settings"][3] = 0.0
		savedata["settings"][2] = res.value

	

func _on_apply_pressed() -> void:
	file_controls.change_res(savedata["settings"][2],get_window())
	if savedata["settings"][3] == 1.0:
		file_controls.fullscreen(get_window())
	file_controls.save_to_json_file(savedata)
	


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Starting screen.tscn")
