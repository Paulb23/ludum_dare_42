extends Control

func _ready() -> void:
	$exit.connect("pressed", self, "_exit")
	$play.connect("pressed", self, "_play")


func _play():
	Globals.set_scene("res://main_scene.tscn")

func _exit():
	get_tree().quit()