@tool
extends LazyMenuResource
class_name LazyMenuSaveLocation

@export var game_directory : String = "lazy menu/data"
@export var file_name : String = "lazy menu demo"

func get_file_location() -> String:
	return "user://" + game_directory + "/" + file_name + ".json"

func get_folder_location() -> String:
	return "user://" + game_directory
