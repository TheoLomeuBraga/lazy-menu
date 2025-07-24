@icon("res://addons/lazy_menu/LazyIcon.svg")
@tool
extends Control
class_name LazyMenuBaseClass

var menu_values : Dictionary

func change_menu_value(key,value) -> void:
	menu_values[key] = value


func build() -> void:
	pass
