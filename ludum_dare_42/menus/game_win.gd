extends Control

func _ready() -> void:
	$menu.connect("pressed", self, "_menu")
	$exit.connect("pressed", self, "_exit")


func _menu():
	Globals.set_scene("res://menus/main_menu.tscn")

func _exit():
	get_tree().quit()