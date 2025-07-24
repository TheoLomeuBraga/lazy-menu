extends TextEdit
class_name  LazyMenuUpdateTextEdit

@export var value_change_name : String
@export var menu : LazyMenuBaseClass

func update_value() -> void:
	
	if menu != null and value_change_name != "":
		menu.change_menu_value(value_change_name,text)


func _ready() -> void:
	update_value()
	text_changed.connect(update_value)
