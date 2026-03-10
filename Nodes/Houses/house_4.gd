extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera
@onready var key: StaticBody2D = $Objects/Key
@onready var timer: Timer = $Timer

func _ready() -> void:
	camera.musics.loop_music(camera.musics.daily_tasks)
	timer.start(10)
	randomize()

	var positions = $Objects/TrashPositions.get_children()
	positions.shuffle()

	var trashes = $Objects/Trashes.get_children()

	for i in range(trashes.size()):
		trashes[i].global_position = positions[i].global_position


func _physics_process(delta: float) -> void:
	camera.position = player.position


func _on_spawn_key_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	key.position = Vector2(168, -88)
	$SpawnKey.monitoring = false


func _on_timer_timeout() -> void:
	pass # Replace with function body.
