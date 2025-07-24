extends OptionButton
class_name LazyMenuUpdateOptionButton

@export var value_change_name : String
@export var menu : LazyMenuBaseClass

func update_value(id : int) -> void:
	if menu != null and value_change_name != "":
		menu.change_menu_value(value_change_name,id)

func _ready() -> void:
	update_value(0)
	item_selected.connect(update_value)
