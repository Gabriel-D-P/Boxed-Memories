extends Node2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var main: Node2D = $CanvasLayer/Main
@onready var credits: Node2D = $CanvasLayer/Credits
@onready var settings: Node2D = $CanvasLayer/Settings
@onready var black_screen: Sprite2D = $CanvasLayer/BlackScreen
@onready var secret: CanvasLayer = $Secret

@onready var n_music: Label = $CanvasLayer/Settings/Music/NMusic
@onready var n_sound: Label = $CanvasLayer/Settings/Sounds/NSound
@onready var n_language: Label = $CanvasLayer/Settings/Language/NLanguage


func _ready() -> void:
	TranslationServer.set_locale(Global.language_array[Global.language_index])
	if Global.day == 1:
		$CanvasLayer/Main/TStart.text = ".Start"
	else:
		$CanvasLayer/Main/TStart.text = ".Continue"
	return

var cheat := false

var konami_code = [
	KEY_UP, KEY_UP,
	KEY_DOWN, KEY_DOWN,
	KEY_LEFT, KEY_RIGHT,
	KEY_LEFT, KEY_RIGHT,
	KEY_B, KEY_A
]

var input_sequence = []


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		input_sequence.append(event.keycode)

		# Mantém o tamanho máximo da sequência
		if input_sequence.size() > konami_code.size():
			input_sequence.pop_front()

		# Verifica se a sequência bate
		if input_sequence == konami_code:
			cheat = true
			print("Konami code ativado!")


# General Menu Buttons
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	black_screen.visible = true
	secret.visible = false
	for button in secret.get_children():
		if button is Button:
			button.disabled = true
	
	main.visible = false
	for button in main.get_children():
		if button is Button:
			button.disabled = true
	
	settings.visible = false
	for button in settings.get_children():
		if button is Button:
			button.disabled = true
	
	credits.visible = true
	for button in credits.get_children():
		if button is Button:
			button.disabled = false

func _on_back_pressed() -> void:
	black_screen.visible = false
	credits.visible = false
	for button in credits.get_children():
		if button is Button:
			button.disabled = true
	
	settings.visible = false
	for button in settings.get_children():
		if button is Button:
			button.disabled = true
	
	secret.visible = false
	for button in secret.get_children():
		if button is Button:
			button.disabled = true
	
	main.visible = true
	for button in main.get_children():
		if button is Button:
			button.disabled = false

func _on_settings_pressed() -> void:
	black_screen.visible = true
	credits.visible = false
	for button in credits.get_children():
		if button is Button:
			button.disabled = true
	
	secret.visible = false
	for button in secret.get_children():
		if button is Button:
			button.disabled = true
	
	main.visible = false
	for button in main.get_children():
		if button is Button:
			button.disabled = true
	
	settings.visible = true
	for button in settings.get_children():
		if button is Button:
			button.disabled = false

func _on_start_pressed() -> void:
	Global.reset_all()
	Global.final_transition = false
	get_tree().change_scene_to_file("res://Nodes/day_count.tscn")

# Settings Buttons & Configs
func _physics_process(_delta: float) -> void:
	n_music.text = str(Global.musics_volume)
	n_sound.text = str(Global.sounds_volume)
	
	if cheat:
		black_screen.visible = true
		secret.visible = true
		for button in secret.get_children():
			if button is Button:
				button.disabled = false
		
		main.visible = false
		for button in main.get_children():
			if button is Button:
				button.disabled = true
		
		settings.visible = false
		for button in settings.get_children():
			if button is Button:
				button.disabled = true
		
		credits.visible = false
		for button in credits.get_children():
			if button is Button:
				button.disabled = true

func _on_music_pressed(value: int) -> void:
	Global.musics_volume += value if (Global.musics_volume != 0 and value == -1) or (Global.musics_volume != 10 and value == 1) else 0

func _on_sound_pressed(value: int) -> void:
	Global.sounds_volume += value if (Global.sounds_volume != 0 and value == -1) or (Global.sounds_volume != 10 and value == 1) else 0


func _on_lang_change_pressed(value: int) -> void:
	Global.language_index = clamp(
		Global.language_index + value,
		0,
		Global.language_array.size() - 1
	)

	TranslationServer.set_locale(Global.language_array[Global.language_index])


func _on_day_pressed(day: int) -> void:
	Global.day = day
	Global.reset_all()
	Global.final_transition = false
	get_tree().change_scene_to_file("res://Nodes/day_count.tscn")
