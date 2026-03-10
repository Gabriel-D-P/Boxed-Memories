extends CharacterBody2D
@onready var up_body_sprites: AnimatedSprite2D = $UpperBodySprites
@onready var down_body_sprites: AnimatedSprite2D = $LowerBodySprites
@onready var item_sprite: AnimatedSprite2D = $Item
@onready var light: PointLight2D = $RegularLight
@onready var sounds: Node2D = $Sounds

var sprint := false
var moving_x := false
var moving_y := false
var speed := 50
var rotation_speed := 4
var direction := Vector2(-1, 0)

var interact_object : Node2D

var item := "None"

@export var vision := 5.0

func _ready() -> void:
	add_to_group("player")
	light.texture_scale = vision
	match Global.day:
		1:
			speed = 50
		2:
			speed = 45
		3:
			speed = 40
		4:
			speed = 35
		5:
			speed = 30
		6:
			speed = 30

func _physics_process(delta: float) -> void:
	if Global.transition and !Global.final_transition:
		up_body_sprites.visible = false
		down_body_sprites.visible = false
		return
	controls()
	rotating(delta)
	animate()
	velocity.x = direction.x * speed * 80 * delta if moving_x else 0
	velocity.y = direction.y * speed * 80 * delta if moving_y else 0
	move_and_slide()

func animate() -> void:
	
	if velocity != Vector2.ZERO and $StepTimer.time_left == 0.0:
		match Global.day:
			1, 2:
				$StepTimer.start(0.35)
				down_body_sprites.speed_scale = 1.5
			3, 4:
				$StepTimer.start(0.4)
				down_body_sprites.speed_scale = 1.25
			5, 6:
				$StepTimer.start(0.5)
				down_body_sprites.speed_scale = 1
		sounds.play_sound(sounds.steps)
	elif velocity == Vector2.ZERO:
		sounds.stop_all_sounds()
	
	if item == "None":
		up_body_sprites.play("Moving") if (moving_x or moving_y or (moving_x and moving_y)) and velocity != Vector2.ZERO else up_body_sprites.play("Idle")
	else:
		up_body_sprites.play("Idle")
	
	down_body_sprites.play("Moving") if (moving_x or moving_y or (moving_x and moving_y)) and velocity != Vector2.ZERO else down_body_sprites.play("Idle")
	
	item_sprite.play(item)

func rotating(delta: float) -> void:
	if direction != Vector2.ZERO:
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, (target_angle), 8.0 * delta)

func controls() -> void:
	#Control Y axis
	if Input.is_action_pressed("Up"):
		direction.y = -1
		direction.x = 0 if not (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")) else direction.x
	elif Input.is_action_pressed("Down"):
		direction.y = 1
		direction.x = 0 if not (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")) else direction.x
	
	#Control X axis
	if Input.is_action_pressed("Left"):
		direction.x = -1
		direction.y = 0 if not (Input.is_action_pressed("Up") or Input.is_action_pressed("Down")) else direction.y
	elif Input.is_action_pressed("Right"):
		direction.x = 1
		direction.y = 0 if not (Input.is_action_pressed("Up") or Input.is_action_pressed("Down")) else direction.y
	
	moving_y = Input.is_action_pressed("Down") or Input.is_action_pressed("Up")
	moving_x = Input.is_action_pressed("Left") or Input.is_action_pressed("Right")
	
	direction = direction.normalized()
