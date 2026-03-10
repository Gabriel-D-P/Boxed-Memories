extends Node2D
@onready var timer: Timer = $Timer
@onready var sounds: Node2D = $Sounds

@export var tick_timer := 1.0

func _ready() -> void:
	timer.start(tick_timer)


func _on_timer_timeout() -> void:
	sounds.play_sound(sounds.tick)
	timer.start(tick_timer)
