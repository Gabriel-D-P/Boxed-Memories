extends Node2D
@onready var door: AudioStreamPlayer2D = $Door
@onready var steps: AudioStreamPlayer2D = $Steps

@onready var opening_box: AudioStreamPlayer2D = $OpeningBox
@onready var open_box: AudioStreamPlayer2D = $OpenBox
@onready var finish_dishes: AudioStreamPlayer2D = $FinishDishes
@onready var close_faucet: AudioStreamPlayer2D = $CloseFaucet
@onready var close_fridge: AudioStreamPlayer2D = $CloseFridge
@onready var collect_trash: AudioStreamPlayer2D = $CollectTrash
@onready var trash_can: AudioStreamPlayer2D = $TrashCan
@onready var eating: AudioStreamPlayer2D = $Eating
@onready var pee: AudioStreamPlayer2D = $Pee
@onready var flush: AudioStreamPlayer2D = $Flush
@onready var teeth: AudioStreamPlayer2D = $Teeth
@onready var watering: AudioStreamPlayer2D = $Watering
@onready var sleep: AudioStreamPlayer2D = $Sleep
@onready var tick: AudioStreamPlayer2D = $Tick
@onready var doom: AudioStreamPlayer2D = $Doom

@onready var tv_off: AudioStreamPlayer2D = $TvOff
@onready var tv_on: AudioStreamPlayer2D = $TvOn

@onready var flowing_water: AudioStreamPlayer2D = $FlowingWater


func _ready() -> void:
	for sound in self.get_children():
		if sound is AudioStreamPlayer2D:
			sound.volume_db = Global.volume_db[Global.sounds_volume]
			sound.add_to_group("original")

func stop_looping_sounds() -> void:
	for sound in self.get_children():
		if sound.is_in_group("looping"):
			sound.stop()
			sound.queue_free()

func stop_all_sounds() -> void:
	for sound in self.get_children():
		if sound.playing and !sound.is_in_group("original"):
			sound.queue_free()
		else:
			sound.stop()


func loop_sound(original: AudioStreamPlayer2D) -> void:
	var sound := AudioStreamPlayer2D.new()
	sound.stream = original.stream
	sound.position = original.position
	sound.max_distance = original.max_distance
	sound.volume_db = Global.volume_db[Global.sounds_volume]
	sound.add_to_group("looping")
	sound.stream.loop = true
	add_child(sound)
	sound.play()


func play_sound(original: AudioStreamPlayer2D) -> void:
	var sound := AudioStreamPlayer2D.new()
	sound.stream = original.stream
	sound.position = original.position
	sound.max_distance = original.max_distance
	sound.volume_db = Global.volume_db[Global.sounds_volume]
	add_child(sound)
	sound.play()

	var duration := sound.stream.get_length()
	await get_tree().create_timer(duration).timeout
	if sound != null:
		sound.queue_free()
