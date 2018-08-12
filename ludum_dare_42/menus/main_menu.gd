extends Control

func _ready() -> void:
	$exit.connect("pressed", self, "_exit")
	$play.connect("pressed", self, "_play")
	$music_vol.connect("value_changed", self, "_music_vol_changed")
	$music_vol.value = AudioServer.get_bus_volume_db(abs(AudioServer.get_bus_index("Music")))

	$sfx_vol.connect("value_changed", self, "_sfx_vol_changed")
	$sfx_vol.value = AudioServer.get_bus_volume_db(abs(AudioServer.get_bus_index("SFX")))

func _music_vol_changed(val):
	AudioServer.set_bus_volume_db(abs(AudioServer.get_bus_index("Music")), val)

func _sfx_vol_changed(val):
	AudioServer.set_bus_volume_db(abs(AudioServer.get_bus_index("SFX")), val)


func _play():
	$click.play()
	yield($click, "finished")
	Globals.set_scene("res://main_scene.tscn")

func _exit():
	$click.play()
	yield($click, "finished")
	get_tree().quit()