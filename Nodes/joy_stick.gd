extends Node2D
@onready var ball: Sprite2D = $JoystickBall
@onready var joystick: Sprite2D = $Joystick

var radius := 26.0
var touching := false

func _input(event):
	if event is InputEventScreenTouch:
		touching = event.pressed
		
		if not touching:
			ball.global_position = joystick.global_position

	if touching and event is InputEventScreenDrag:
		var touch_pos = event.position
		var center = joystick.global_position
		
		var dist = center.distance_to(touch_pos)
		
		# Só reage se o toque começou dentro do joystick
		if dist <= radius:
			var dir = touch_pos - center
			
			if dir.length() > radius:
				dir = dir.normalized() * radius
