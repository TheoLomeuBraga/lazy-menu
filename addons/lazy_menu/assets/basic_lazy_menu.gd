@tool
extends LazyMenuBaseClass
class_name BasicLazyMenu

func set_up_owners(n:Node) -> void:
	n.owner = get_tree().edited_scene_root
	for c in n.get_children():
		set_up_owners(c)

@export var title : String

@export var menu_blueprint : Array[LazyMenuElement]

@export var data_save_location : LazyMenuSaveLocation = LazyMenuSaveLocation.new()

var element_area : Node

signal apply(values : Dictionary)

func apply_menu_changes() -> void:
	LazyMenu.save(data_save_location,menu_values)
	apply.emit(menu_values)

func _ready() -> void:
	
	element_area = $BaseBasicMenu/PanelContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer
	
	var button : Button = get_node("BaseBasicMenu/PanelContainer/VBoxContainer/HBoxContainer/apply")
	if is_instance_valid(button):
		button.pressed.connect(apply_menu_changes)
	
	if not is_instance_valid(element_area):
		return
	
	menu_values = LazyMenu.load(data_save_location)
	for i in menu_blueprint.size():
		var menu_item : LazyMenuElement = menu_blueprint[i]
		if menu_item is LazyMenuOption and menu_values.has(menu_item.name) and (menu_values[menu_item.name] is int or menu_values[menu_item.name] is float):
			
			var option_button : LazyMenuUpdateOptionButton =  element_area.get_child(i).get_node("OptionButton")
			option_button.select(menu_values[menu_item.name])
			
		elif menu_item is LazyMenuSlider and menu_values.has(menu_item.name) and (menu_values[menu_item.name] is int or menu_values[menu_item.name] is float):
			
			var slider : LazyMenuUpdateSlide =  element_area.get_child(i).get_node("VBoxContainer/HSlider")
			slider.value = menu_values[menu_item.name]
			
		elif menu_item is LazyMenuCheckBox and menu_values.has(menu_item.name) and (menu_values[menu_item.name] is int or menu_values[menu_item.name] is float or menu_values[menu_item.name] is bool):
			
			if menu_item.switch:
				var element_check_box = element_area.get_child(i).get_node("CenterContainer/CheckButton")
				element_check_box.button_pressed = menu_values[menu_item.name]
			else:
				var element_check_box = element_area.get_child(i).get_node("CenterContainer/CheckBox")
				element_check_box.button_pressed = menu_values[menu_item.name]
			
		elif menu_item is LazyMenuText and menu_values.has(menu_item.name) and menu_values[menu_item.name] is String:
			
			var element_text : LazyMenuUpdateTextEdit = element_area.get_child(i).get_node("TextEdit")
			element_text.text = menu_values[menu_item.name]
		
		

func build() -> void:
	
	
	
	for c in get_children():
		c.queue_free()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var menu : Control = load("res://addons/lazy_menu/assets/basic_lazy_menu.tscn").instantiate()
	menu.name = "BaseBasicMenu"
	add_child(menu)
	
	set_up_owners(menu)
	menu.scene_file_path = ""
	
	element_area = $BaseBasicMenu/PanelContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer
	
	get_node("BaseBasicMenu/PanelContainer/VBoxContainer/title").text = title
	
	
	for m in menu_blueprint:
		if m is LazyMenuOption:
			var element : Control = load("res://addons/lazy_menu/assets/menu_elements/option.tscn").instantiate()
			element_area.add_child(element)
			set_up_owners(element)
			element.scene_file_path = ""
			
			var option_button : LazyMenuUpdateOptionButton =  element.get_node("OptionButton")
			
			for o in m.options:
				option_button.add_item(o)
			
			option_button.menu = self
			option_button.value_change_name = m.name
			
			option_button.select(m.value)
			
			
		elif m is LazyMenuLable:
			var element : Control = load("res://addons/lazy_menu/assets/menu_elements/lable.tscn").instantiate()
			element_area.add_child(element)
			set_up_owners(element)
			element.scene_file_path = ""
			
			element.get_node("Label").text = m.name
			
			element.get_node("Label2").text = m.text
			
		elif m is LazyMenuSlider:
			var element : Control = load("res://addons/lazy_menu/assets/menu_elements/slider.tscn").instantiate()
			element_area.add_child(element)
			set_up_owners(element)
			element.scene_file_path = ""
			
			element.get_node("Label").text = m.name
			
			var slider : LazyMenuUpdateSlide = element.get_node("VBoxContainer/HSlider")
			var display : Label = element.get_node("display")
			
			slider.min_value = m.min
			slider.max_value = m.max
			slider.step = m.step
			
			slider.value = m.value
			
			slider.menu = self
			slider.value_change_name = m.name
			
		elif m is LazyMenuCheckBox:
			var element : Control
			
			if m.switch:
				element = load("res://addons/lazy_menu/assets/menu_elements/switch.tscn").instantiate()
			else:
				element = load("res://addons/lazy_menu/assets/menu_elements/toggle.tscn").instantiate()
			
			element_area.add_child(element)
			set_up_owners(element)
			element.scene_file_path = ""
			
			element.get_node("Label").text = m.name
			
			if m.switch:
				var element_check_box = element.get_node("CenterContainer/CheckButton")
				element_check_box.menu = self
				element_check_box.value_change_name = m.name
				element_check_box.button_pressed = m.value
			else:
				var element_check_box = element.get_node("CenterContainer/CheckBox")
				element_check_box.menu = self
				element_check_box.value_change_name = m.name
				element_check_box.button_pressed = m.value
			
		elif m is LazyMenuText:
			var element : Control = load("res://addons/lazy_menu/assets/menu_elements/text.tscn").instantiate()
			element_area.add_child(element)
			set_up_owners(element)
			element.scene_file_path = ""
			
			element.get_node("Label").text = m.name
			
			var element_text : LazyMenuUpdateTextEdit = element.get_node("TextEdit")
			element_text.menu = self
			element_text.value_change_name = m.name
			
			element_text.text = m.text
			
