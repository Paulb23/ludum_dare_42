extends Control

func _ready() -> void:
	$menu.connect("pressed", self, "_menu")
	$exit.connect("pressed", self, "_exit")


func _menu():
	$click.play()
	yield($click, "finished")
	Globals.set_scene("res://menus/main_menu.tscn")

func _exit():
	$click.play()
	yield($click, "finished")
	get_tree().quit()