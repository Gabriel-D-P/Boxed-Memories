extends Node2D
@onready var text: Label = $Label
@onready var final_text: Label = $Label2
@onready var timer: Timer = $Timer
@onready var sounds: Node2D = $Sounds

func _ready() -> void:
	$BlackScreen.modulate = Color(0, 0, 0)
	Global.reset_all()
	Global.transition = false
	await get_tree().create_timer(0.5).timeout
	sounds.play_sound(sounds.doom)
	if Global.day == 7:
		Global.day = 1
		text.text = ""
		final_text.visible_characters = 0
		final_text.text = str(tr(".End_Phrase"))
		final_text.modulate = Color(1, 1, 1)

		await get_tree().create_timer(1).timeout

		for i in final_text.text.length():
			final_text.visible_characters += 1
			
			if final_text.visible_characters >= 3:
				var part = final_text.text.substr(final_text.visible_characters - 3, 3)
				if part == "...":
					await get_tree().create_timer(2).timeout
			await get_tree().create_timer(0.1).timeout

		timer.start(5)
		await timer.timeout
		get_tree().change_scene_to_file("res://Nodes/menu.tscn")
	else:
		if Global.day == 6:
			text.text = ""
			var translated_title = str(tr(".Day"), " ?")
			for i in translated_title.length():
				text.text += translated_title[i]
				await get_tree().create_timer(0.1).timeout
		else:
			text.text = ""
			var translated_title = str(tr(".Day"), " ", Global.day)
			for i in translated_title.length():
				text.text += translated_title[i]
				await get_tree().create_timer(0.1).timeout
		
		timer.start(2)
		await timer.timeout
		get_tree().change_scene_to_file(str("res://Nodes/Houses/house", Global.day,".tscn"))
