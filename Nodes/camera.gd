extends Camera2D
@onready var blackscreen: Sprite2D = $CanvasLayer/BlackScreen
@onready var timer: Timer = $Timer

@onready var pause: Button = $CanvasLayer/Pause
@onready var ui: Node2D = $CanvasLayer/UI
@onready var joy_stick: Node2D = $CanvasLayer/UI/JoyStick
@onready var interact: TouchScreenButton = $CanvasLayer/UI/Interact

@onready var settings: Node2D = $CanvasLayer/Settings
@onready var n_music: Label = $CanvasLayer/Settings/Music/NMusic
@onready var n_sound: Label = $CanvasLayer/Settings/Sounds/NSound
@onready var n_language: Label = $CanvasLayer/Settings/Language/NLanguage

@onready var text: Label = $CanvasLayer/Text/Label
@onready var text_bubble: Node2D = $CanvasLayer/Text

var exit_time := 3.0
@export var can_quit := true
@onready var musics: Node2D = $Musics

var blackscreen_stop := false

func speak(number: int) -> void:
	text.visible_characters = 0
	text_bubble.visible = true
	text.text = str(tr(".Speak%s" % number))
	text.modulate = Color(1, 1, 1)
	await get_tree().create_timer(1).timeout
	for i in text.text.length():
		text.visible_characters += 1
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(3).timeout
	text_bubble.visible = false

func _process(delta: float) -> void:
	if Global.mobile:
		ui.visible = not (Global.transition or Global.final_transition) and can_quit and not get_tree().paused
	else:
		ui.visible = false
	
	pause.visible = not (Global.transition or Global.final_transition) and can_quit
	
	musics.lower_music = Global.transition
	
	if Input.is_action_just_pressed("Pause") and not (Global.transition or Global.final_transition) and can_quit:
		_on_pause_pressed()
	
	n_music.text = str(Global.musics_volume)
	n_sound.text = str(Global.sounds_volume)


func _physics_process(delta):
	$PointLight2D.energy = 0
	if Global.transition:
		if Global.final_transition:
			blackscreen.modulate.a = min(blackscreen.modulate.a + 0.5 * delta, 1.0)
		elif !blackscreen_stop:
			blackscreen.modulate.a = min(blackscreen.modulate.a + 0.5 * delta, 1.0)
		if blackscreen.modulate.a >= 1.0 and timer.time_left == 0:
			timer.start(0.5)
	elif !blackscreen_stop:
		blackscreen.modulate.a = max(blackscreen.modulate.a - 0.5 * delta, 0.0)


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Nodes/day_count.tscn")


# Settings Buttons & Configs
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


func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Nodes/menu.tscn")


func _on_pause_pressed() -> void:
	get_tree().paused = !get_tree().paused
	blackscreen_stop = get_tree().paused
	blackscreen.modulate.a = 1.0 if get_tree().paused else 0.0
	settings.visible = get_tree().paused
	for button in settings.get_children():
		if button is Button:
			button.disabled = !get_tree().paused
