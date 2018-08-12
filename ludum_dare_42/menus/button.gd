extends Button

var hover_sound : AudioStreamPlayer

func _ready() -> void:
	hover_sound = AudioStreamPlayer.new()
	hover_sound.volume_db = -30
	hover_sound.bus = "SFX"
	hover_sound.stream = ResourceLoader.load("res://sounds/sfx/button_hover.wav")
	add_child(hover_sound)
	connect("mouse_entered", self, "_hover")

func _hover() -> void:
	hover_sound.play()
