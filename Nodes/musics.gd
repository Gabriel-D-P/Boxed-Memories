extends Node2D
@onready var daily_tasks: AudioStreamPlayer = $DailyTasks
@onready var daily_life: AudioStreamPlayer = $DailyLife
@onready var day: AudioStreamPlayer = $Day

@export var lower_music := false

func _process(delta: float) -> void:
	for music in self.get_children():
		if music is AudioStreamPlayer and !lower_music:
			music.volume_db = Global.music_volume_db[Global.musics_volume]
		elif music is AudioStreamPlayer and lower_music:
			music.volume_db -= 1 if music.volume_db > -80 else 0

func stop_looping_musics() -> void:
	for music in self.get_children():
		if music.is_in_group("looping"):
			music.stop()
			music.queue_free()

func stop_all_musics() -> void:
	for music in self.get_children():
		if music.playing and !music.is_in_group("original"):
			music.queue_free()
		else:
			music.stop()


func loop_music(original: AudioStreamPlayer) -> void:
	original.play()


func play_music(original: AudioStreamPlayer) -> void:
	original.play()
