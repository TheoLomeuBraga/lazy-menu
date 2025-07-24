@tool
extends EditorPlugin
class_name LazyMenu

static func save(location : LazyMenuSaveLocation,data : Dictionary) -> void:
	if location != null:
		var dir = DirAccess.open("user://")
		dir.make_dir_recursive_absolute(location.get_folder_location())
		var file = FileAccess.open(location.get_file_location(), FileAccess.WRITE)
		if file:
			var json_string = JSON.stringify(data)
			file.store_line(json_string)
			file.close()
		else:
			print("Could not open file for saving.")

static func load(location : LazyMenuSaveLocation) -> Dictionary:
	if location != null:
		
		var file = FileAccess.open(location.get_file_location(), FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var parse_result = JSON.parse_string(json_string)
			if parse_result != null:
				return parse_result
			else:
				print("Error parsing JSON:", parse_result.error_string)
				return {}
		else:
			print("Could not open file for loading.")
			return {}
	else:
		return {}


var selected_lazy_menu : LazyMenuBaseClass

func build_lazy_menu() -> void:
	if selected_lazy_menu != null:
		selected_lazy_menu.build()

var lazy_menu_icon : TextureRect
var build_button : Button

func on_selection_changed() -> void:
	var selected_nodes : Array[Node] = EditorInterface.get_selection().get_selected_nodes()
	
	if selected_nodes.size() == 0 or not selected_nodes[0] is LazyMenuBaseClass:
		lazy_menu_icon.visible = false
		build_button.visible = false
		selected_lazy_menu = null
		return
	
	lazy_menu_icon.visible = true
	build_button.visible = true
	
	selected_lazy_menu = selected_nodes[0]
	

func _enter_tree() -> void:
	EditorInterface.get_selection().connect("selection_changed", self.on_selection_changed)
	
	lazy_menu_icon = TextureRect.new()
	lazy_menu_icon.texture = load("res://addons/lazy_menu/LazyIcon.svg")
	lazy_menu_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	lazy_menu_icon.custom_minimum_size = Vector2(32,32)
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU,lazy_menu_icon)
	
	build_button = Button.new()
	build_button.text = "build"
	build_button.visible = false
	build_button.pressed.connect(build_lazy_menu)
	
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU,build_button)


func _exit_tree() -> void:
	EditorInterface.get_selection().disconnect("selection_changed", self.on_selection_changed)
	build_button.pressed.disconnect(build_lazy_menu)
	lazy_menu_icon.queue_free()
	build_button.queue_free()
