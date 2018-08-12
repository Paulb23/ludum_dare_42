extends Control

var can_unpause = false

func _ready() -> void:
	self.rect_position = Vector2(-10000, -10000)

	$pause_timer.connect("timeout", self, "_pause_timer")
	$continue.connect("pressed", self, "_continue")
	$menu.connect("pressed", self, "_menu")
	$exit.connect("pressed", self, "_exit")
	$music_vol.connect("value_changed", self, "_music_vol_changed")
	$music_vol.value = AudioServer.get_bus_volume_db(abs(AudioServer.get_bus_index("Music")))

	$sfx_vol.connect("value_changed", self, "_sfx_vol_changed")
	$sfx_vol.value = AudioServer.get_bus_volume_db(abs(AudioServer.get_bus_index("SFX")))

func _physics_process(delta : float) -> void:
	if (not can_unpause):
		return

	if (Input.is_action_just_pressed("pause")):
		_continue()

func display():
	$click.play()
	$pause_timer.start()
	self.rect_position = Vector2(0, 0)

func _pause_timer() -> void:
	can_unpause = true

func _music_vol_changed(val) -> void:
	AudioServer.set_bus_volume_db(abs(AudioServer.get_bus_index("Music")), val)

func _sfx_vol_changed(val):
	AudioServer.set_bus_volume_db(abs(AudioServer.get_bus_index("SFX")), val)

func _continue() -> void:
	$click.play()
	yield($click, "finished")
	self.rect_position = Vector2(-10000, -10000)
	get_tree().paused = false
	can_unpause = false

func _menu() -> void:
	$click.play()
	yield($click, "finished")
	get_tree().paused = false
	can_unpause = false
	Globals.set_scene("res://menus/main_menu.tscn")

func _exit() -> void:
	$click.play()
	yield($click, "finished")
	get_tree().quit()