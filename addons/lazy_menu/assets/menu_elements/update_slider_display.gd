extends HSlider
class_name  LazyMenuUpdateSlide

@export var value_change_name : String
@export var menu : LazyMenuBaseClass

func update_value(c : float) -> void:
	if value == floor(value):
		$"../../display".text = str(int(value))
	else:
		$"../../display".text = str(value)
	
	if menu != null and value_change_name != "":
		menu.change_menu_value(value_change_name,c)

func _ready() -> void:
	update_value(value)
	value_changed.connect(update_value)
