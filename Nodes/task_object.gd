extends StaticBody2D

@onready var interact_area: Area2D = $Interact
@onready var sprites: AnimatedSprite2D = $Sprites
@onready var BG_bar: Sprite2D = $BGCompletionBar
@onready var completion_bar: Sprite2D = $CompletionBar
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprites2: AnimatedSprite2D = null
@onready var interact_collision: CollisionShape2D = $Interact/CollisionShape2D
@onready var sounds: Node2D = $Sounds

enum COMPLETION_MODE {CANCEL, WASTE, STOP}

enum TASK {
	DISHES,
	TRASH,
	BOX,
	LUNCH,
	FRIDGE,
	TOILET,
	SHOWER,
	SINK,
	BED,
	TV,
	PLANT,
	KEY,
	PICTURE
}

var interact := false

@export var task_type := TASK.BOX
@export var max_completion := 1.0
@export var completion_mode := COMPLETION_MODE.WASTE

## comportamento especial
@export var required_item : String = "None"
@export var instant_interaction := false
@export var play_open_while_holding := false
@export var close_when_released := false
@export var close_when_finished := false
@export var change_collision := false
@export var variation_number := 1
@onready var has_second_sprite := false

var ID := "Box"

var completion := 0.0

var very_important := false

func _ready() -> void:
	collision.position = Vector2.ZERO
	if interact_collision:
		var collision_shape = interact_collision.shape
		interact_collision.shape = collision_shape.duplicate()
	match task_type:
		TASK.DISHES:
			ID = "Dishes"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(30, 14)
		TASK.TRASH:
			ID = "Trash"
			required_item = "TrashBag"
			instant_interaction = true
			play_open_while_holding = false
			close_when_released = false
			close_when_finished = false
			interact_collision.shape.radius = 6
		TASK.BOX:
			ID = "Box"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(14, 14)
			max_completion = 1 if self.scale <= Vector2(1, 1) else 2
		TASK.LUNCH:
			ID = "Lunch"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(30, 14)
		TASK.FRIDGE:
			ID = "Fridge"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(26, 11)
				collision.position = Vector2(0, -9.5)
		TASK.TOILET:
			ID = "Toilet"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(12, 12)
		TASK.SHOWER:
			ID = "Shower"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(3, 30)
				collision.position = Vector2(-13.5, 0)
				interact_area.position.y = -10
			sprites2 = $SecondSprites
			has_second_sprite = true
		TASK.SINK:
			ID = "Sink"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(14, 14)
		TASK.BED:
			ID = "Bed"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(26, 42)
				interact_collision.shape.radius = 18
		TASK.TV:
			ID = "TV"
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(28, 14)
				collision.position = Vector2(0, -8)
		TASK.PLANT:
			ID = str("Plant", variation_number)
			if collision:
				var collision_shape = collision.shape
				collision.shape = collision_shape.duplicate()
				collision.shape.size = Vector2(14, 8)
				collision.position = Vector2(0, 2)
			sprites2 = $SecondSprites
			required_item = "Water"
			play_open_while_holding = true
			close_when_released = true
			close_when_finished = true
			interact_collision.shape.radius = 12
			has_second_sprite = true
		TASK.KEY:
			ID = "Key"
			collision.queue_free()
			play_open_while_holding = false
			close_when_released = false
			close_when_finished = false
			interact_collision.shape.radius = 6
		TASK.PICTURE:
			ID = str("Picture", variation_number)
			collision.queue_free()
			play_open_while_holding = false
			close_when_released = false
			close_when_finished = false
			interact_collision.shape.radius = 6
	
	if ID in ["Trash"]:
		randomize()
		sprites.play(str(ID,randi_range(1, 4)))
		collision.queue_free()
	elif ID in ["Picture1", "Picture2", "Picture3", "Picture4", "Plant1", "Plant2", "Plant3", "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Key"]:
		sprites.play(ID)
	else:
		sprites.play(str(ID, "Closed"))


func _physics_process(delta: float) -> void:
	if has_second_sprite and sprites2:
		sprites2.visible = true
	# highlight
	if interact and completion == 0.0:
		sprites.modulate = Color(1.1,1.1,1.1)
	else:
		sprites.modulate = Color(0.9,0.9,0.9)

	# interação instantânea (tipo lixo)
	if instant_interaction:
		BG_bar.visible = false
		completion_bar.visible = false
		if Input.is_action_just_pressed("Hold") and interact:
			complete_task()
		return

	# toca sons durante a tarefa
	if Input.is_action_just_pressed("Hold") and interact:
		playing_sounds()
		very_important = true
	elif ((Input.is_action_just_released("Hold") and interact) or !interact) and very_important:
		very_important = false
		sounds.stop_looping_sounds()
	
	# progresso normal)
	if Input.is_action_pressed("Hold") and interact and completion != max_completion:

		completion = min(completion + delta, max_completion)

		if play_open_while_holding:
			if ID in ["Picture1", "Picture2", "Picture3", "Picture4", "Plant1", "Plant2", "Plant3", "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Key"]:
				sprites.play(ID)
			else:
				if ID in ["Picture1", "Picture2", "Picture3", "Picture4", "Plant1", "Plant2", "Plant3", "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Key"]:
					sprites.play(ID)
				else:
					sprites.play(str(ID, "Open"))
			if sprites2:
				if ID == "Shower":
					sprites2.play(str(ID, "Open"))
				else:
					sprites2.play("PlantOpen")

	elif completion != max_completion:

		if close_when_released:
			if ID in ["Picture1", "Picture2", "Picture3", "Picture4", "Plant1", "Plant2", "Plant3", "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Key"]:
				sprites.play(ID)
			else:
				sprites.play(str(ID, "Closed"))
			if sprites2:
				if ID == "Shower":
					sprites2.play(str(ID, "Closed"))
				else:
					sprites2.play("PlantClosed")

		match completion_mode:
			COMPLETION_MODE.WASTE:
				completion = completion - delta if completion > 0.0 else 0.0
			COMPLETION_MODE.CANCEL, COMPLETION_MODE.STOP:
				completion = 0.0

	# barras
	BG_bar.scale.x = 1
	completion_bar.scale.x = completion/max_completion

	BG_bar.visible = (interact and completion > 0)
	completion_bar.visible = (interact and completion > 0)

	# completou
	if completion >= max_completion and interact:

		if close_when_finished:
			if ID in ["Picture1", "Picture2", "Picture3", "Picture4", "Plant1", "Plant2", "Plant3", "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Key"]:
				sprites.play(ID)
			else:
				sprites.play(str(ID, "Closed"))
			if sprites2:
				if ID == "Shower":
					sprites2.play(str(ID, "Closed"))
				else:
					sprites2.play("PlantClosed")
		else:
			if ID in ["Picture1", "Picture2", "Picture3", "Picture4", "Plant1", "Plant2", "Plant3", "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Key"]:
				sprites.play(ID)
			else:
				sprites.play(str(ID, "Open"))

		if change_collision and collision:
			collision.shape.size = Vector2(24,14)

		complete_task()

		interact_area.monitoring = false
		interact = false


func playing_sounds() -> void:
	match task_type:
		TASK.BOX:
			sounds.loop_sound(sounds.opening_box)
		TASK.DISHES, TASK.SHOWER:
			sounds.loop_sound(sounds.flowing_water)
		TASK.SINK:
			sounds.loop_sound(sounds.flowing_water)
			sounds.loop_sound(sounds.teeth)
		TASK.FRIDGE:
			sounds.play_sound(sounds.close_fridge)
		TASK.LUNCH:
			sounds.loop_sound(sounds.eating)
		TASK.TV:
			sounds.loop_sound(sounds.tv_on)
		TASK.TOILET:
			sounds.loop_sound(sounds.pee)
		TASK.PLANT:
			sounds.loop_sound(sounds.watering)


func complete_task():
	very_important = false

	match task_type:

		TASK.BOX:
			Global.task_list[".Open_Boxes"] += 1
			sounds.play_sound(sounds.open_box)

		TASK.TRASH:
			Global.task_list[".Collect_Trash"] += 1
			sounds.play_sound(sounds.collect_trash)
			interact_area.monitoring = false
			hide()
			await get_tree().create_timer(0.2).timeout
			queue_free()

		TASK.DISHES:
			Global.task_list[".Wash_Dishes"] = true
			sounds.play_sound(sounds.finish_dishes)

		TASK.LUNCH:
			Global.task_list[".Eat_Snack"] = true
			sounds.play_sound(sounds.finish_dishes)

		TASK.FRIDGE:
			Global.task_list[".Check_Fridge"] = true
			sounds.play_sound(sounds.close_fridge)

		TASK.TOILET:
			Global.task_list[".Pee"] = true
			sounds.play_sound(sounds.flush)

		TASK.SHOWER:
			Global.task_list[".Take_a_Shower"] = true
			sounds.play_sound(sounds.close_faucet)

		TASK.SINK:
			Global.task_list[".Brush_Teeth"] = true
			sounds.play_sound(sounds.close_faucet)

		TASK.BED:
			Global.task_list[".Sleep"] = true
			if not Global.transition:
				Global.day += 1 if Global.day < 6 else 0
			Global.transition = true
			sounds.play_sound(sounds.sleep)

		TASK.TV:
			Global.task_list[".Watch_TV"] = true
			sounds.play_sound(sounds.tv_off)

		TASK.PLANT:
			Global.task_list[".Water_Plants"] += 1

		TASK.KEY:
			Global.task_list[".Find_Key"] = true
			sounds.play_sound(sounds.collect_trash)
			interact_area.monitoring = false
			hide()
			await get_tree().create_timer(0.2).timeout
			queue_free()

		TASK.PICTURE:
			Global.task_list[".Find_Photos"] += 1
			sounds.play_sound(sounds.collect_trash)
			interact_area.monitoring = false
			hide()
			await get_tree().create_timer(0.2).timeout
			queue_free()

	sounds.stop_looping_sounds()


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.item == required_item:
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame
		if ID == "Bed":
			interact = Global.is_day_complete(Global.day)
		else:
			interact = true


func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact = false
