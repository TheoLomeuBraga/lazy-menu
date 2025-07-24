extends ColorRect

@onready var lazy_menu : BasicLazyMenu = $"../LazyExample"

func update_config(data : Dictionary) -> void:
	if data.has("R"):
		color.r = data["R"]
	if data.has("G"):
		color.g = data["G"]
	if data.has("B"):
		color.b = data["B"]

func _ready() -> void:
	update_config(LazyMenu.load(lazy_menu.data_save_location))
	lazy_menu.apply.connect(update_config)
	lazy_menu.back.connect(get_tree().quit)
