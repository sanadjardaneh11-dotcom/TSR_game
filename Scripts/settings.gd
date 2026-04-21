extends Control

@onready var music: HSlider = $settings/SliderSettings/Values/Music
@onready var sounds: HSlider = $settings/SliderSettings/Values/Sounds
@onready var dispmusic: Label = $"settings/SliderSettings/Display value/Music"
@onready var dispsounds: Label = $"settings/SliderSettings/Display value/Sounds"
var savepath = "res://savedata.json"
var savedata:Dictionary

func _ready() -> void:
	load_json_file()
	music.value = savedata["settings"][0]
	print("Loaded value"+str(savedata["settings"][0])+"to music")
	sounds.value = savedata["settings"][1]
	print("Loaded value"+str(savedata["settings"][1])+"to sounds")
	dispmusic.text = str(music.value)
	dispsounds.text = str(sounds.value)
	

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from file")
	savedata = jsonobject.data
	return savedata

func save_to_json_file():
	var file = FileAccess.open(savepath, FileAccess.ModeFlags.WRITE)
	var json_text = JSON.stringify(savedata)
	print("written:"+json_text+"to file")
	file.store_string(json_text)

func _on_music_value_changed(value: float) -> void:
	dispmusic.text = str(music.value) 
	savedata["settings"][0] = music.value

func _on_sounds_value_changed(value: float) -> void:
	dispsounds.text = str(sounds.value) 
	savedata["settings"][1] = sounds.value


func _on_apply_pressed() -> void:
	save_to_json_file()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Starting screen.tscn")
