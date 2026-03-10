extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera
@onready var timer: Timer = $Timer

func _ready() -> void:
	camera.musics.loop_music(camera.musics.daily_tasks)
	timer.start(8)
	randomize()

	var positions = $Objects/TrashPositions.get_children()
	positions.shuffle()

	var trashes = $Objects/Trashes.get_children()

	for i in range(trashes.size()):
		trashes[i].global_position = positions[i].global_position


func _physics_process(delta: float) -> void:
	camera.position = player.position


func _on_timer_timeout() -> void:
	camera.speak(3)
