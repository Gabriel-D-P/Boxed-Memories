extends Node2D
@onready var door_hinge: Node2D = $DoorHinge
@onready var sounds: Node2D = $Sounds
@onready var sound_timer: Timer = $SoundTimer

var state := "Closed"
var open_speed := 150.0

var play_sound := false

@export var locked := false

var player_inside := false

func _physics_process(delta: float) -> void:
	if locked:
		return
	
	match state:
		"OpenUp":
			door_hinge.rotation_degrees += delta * open_speed
		
		"OpenDown":
			door_hinge.rotation_degrees -= delta * open_speed
		
		"Closed":
			door_hinge.rotation_degrees = move_toward(door_hinge.rotation_degrees, 0, delta * open_speed)

	door_hinge.rotation_degrees = clamp(door_hinge.rotation_degrees, -90, 90)

	if play_sound:
		sounds.play_sound(sounds.door)
		play_sound = false

func _on_open_up_body_entered(body: Node2D) -> void:
	if locked:
		return
	if body.is_in_group("player") and state != "OpenDown":
		open_speed = 250 if body.sprint else 150
		state = "OpenUp"
		play_sound = true


func _on_open_down_body_entered(body: Node2D) -> void:
	if locked:
		return
	if body.is_in_group("player") and state != "OpenUp":
		open_speed = 250 if body.sprint else 150
		state = "OpenDown"
		play_sound = true


func _on_open_body_entered(body: Node2D) -> void:
	if locked:
		return
	if body.is_in_group("player"):
		player_inside = true


func _on_open_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false


func _on_open_down_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not player_inside:
		open_speed = 250 if body.sprint else 150
		await get_tree().create_timer(0.25).timeout
		state = "Closed"
		play_sound = true
