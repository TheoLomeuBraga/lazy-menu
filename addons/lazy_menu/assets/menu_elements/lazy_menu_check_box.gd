extends CheckBox
class_name LazyMenuUpdateCheckBox

@export var value_change_name : String
@export var menu : LazyMenuBaseClass

func update_value(c : bool) -> void:
	
	if menu != null and value_change_name != "":
		menu.change_menu_value(value_change_name,c)


func _ready() -> void:
	update_value(button_pressed)
	toggled.connect(update_value) 
