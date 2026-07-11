class_name file_control
extends Resource
var savepath = "user://savedata.json"
var newsavepath = "res://savedata.json"
var savedata:Dictionary
const screen = [405,270]

func load_json_file():
	var file = FileAccess.open(savepath, FileAccess.READ)
	if file == null:
		return null
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from file")
	return jsonobject.data

func make_new_json_file():
	var file = FileAccess.open(newsavepath, FileAccess.READ)
	var json = file.get_as_text()
	var jsonobject = JSON.new()
	jsonobject.parse(json)
	print("Loaded:"+str(jsonobject.data)+"from res")
	savedata = jsonobject.data
	file.close()
	var file2 = FileAccess.open(savepath, FileAccess.ModeFlags.WRITE)
	var json_text = JSON.stringify(savedata)
	file2.store_string(json_text)

func save_to_json_file(data):
	var file = FileAccess.open(savepath, FileAccess.ModeFlags.WRITE)
	var json_text = JSON.stringify(data)
	print("written:"+json_text+"to file")
	file.store_string(json_text)

func change_res(scale,window):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	window.content_scale_mode = window.CONTENT_SCALE_MODE_DISABLED
	window.content_scale_factor =  scale
	window.size = (Vector2i(screen[0]*scale,screen[1]*scale))
	print("window size changed")

func fullscreen(window):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	window.size = (Vector2i(screen[0]*304/45,screen[1]*304/45))
	window.content_scale_factor =  304/45
	window.content_scale_mode = window.CONTENT_SCALE_MODE_VIEWPORT
