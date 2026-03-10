extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera
@onready var door8: Node2D = $Garage/Door8
@onready var bedroom: Node2D = $Bedroom
@onready var bathroom: Node2D = $Bathroom
@onready var timer: Timer = $Timer

func _ready() -> void:
	camera.musics.loop_music(camera.musics.day)
	timer.start(10)
	randomize()

	var positions = $Objects/TrashPositions.get_children()
	positions.shuffle()

	var trashes = $Objects/Trashes.get_children()

	for i in range(trashes.size()):
		trashes[i].global_position = positions[i].global_position


func _physics_process(delta: float) -> void:
	camera.position = player.position


func _on_change_rooms_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	door8.locked = true
	bedroom.position = Vector2(300, 0)
	bathroom.position = Vector2(112, 64)
	bedroom.position = Vector2(112, -96)
	$ChangeRooms.monitoring = false


func _on_timer_timeout() -> void:
	camera.speak(1)
