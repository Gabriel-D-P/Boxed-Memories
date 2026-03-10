extends Node2D
@onready var sprites: AnimatedSprite2D = $Sprites
@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sounds: Node2D = $Sounds

@export var ID := "TrashBag"
var interact := false
var player : Node2D
var full := false


func _ready() -> void:
	var collision_shape = collision.shape.duplicate()
	collision.shape = collision_shape
	if ID == "TrashBag":
		sprites.play(str(ID, "Full"))
		collision.shape.size = Vector2(12, 8)
	elif ID == "Water":
		sprites.play(ID)
		collision.shape.size = Vector2(30, 14)

func _physics_process(delta: float) -> void:
	if interact:
		sprites.modulate = Color(1.1, 1.1, 1.1)
	else:
		sprites.modulate = Color(0.9, 0.9, 0.9)
	
	if Input.is_action_just_pressed("Hold") and interact:
		if player.item == "None":
			player.item = ID
			if ID == "TrashBag":
				sprites.play(ID)
				sounds.play_sound(sounds.trash_can)
			elif ID == "Water":
				sprites.play(str(ID, "Empty"))
		elif player.item == ID:
			player.item = "None"
			if ID == "TrashBag":
				sprites.play(str(ID, "Full"))
				sounds.play_sound(sounds.trash_can)
			elif ID == "Water":
				sprites.play(ID)


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		interact = true

func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact = false
