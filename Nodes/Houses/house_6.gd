extends Node2D
@onready var door6: Node2D = $Doors/Door6
@onready var door7: Node2D = $Doors/Door7
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera
@onready var timer: Timer = $Timer

var number := 1
@onready var timer2: Timer = $Timer2

var can_end := false

func _ready() -> void:
	timer.start(1.0)
	timer2.start(5)

func _physics_process(delta: float) -> void:
	camera.position = player.position
	if (door6.state != "Closed" or door7.state != "Closed") and can_end:
		await get_tree().create_timer(3).timeout
		Global.final_transition = true
		Global.transition = true
		Global.day = 7
		can_end = false


func _on_timer_timeout() -> void:
	can_end = true


func _on_timer_2_timeout() -> void:
	camera.speak(number)
	number += 1 if number < 5 else 0
	if number < 5:
		timer2.start(10)
