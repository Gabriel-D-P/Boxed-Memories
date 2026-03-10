extends Node

var task_list := {
	".Open_Boxes": 0,
	".Wash_Dishes": false,
	".Eat_Snack": false,
	".Collect_Trash": 0,
	".Sleep": false,
	".Check_Fridge": false,
	".Pee": false,
	".Take_a_Shower": false,
	".Watch_TV": false,
	".Brush_Teeth": false,
	".Water_Plants": 0,
	".Find_Key": false,
	".Find_Photos": 0,
	"Sair": false
}

var full_task_list := {
	".Open_Boxes": 0,
	".Wash_Dishes": true,
	".Eat_Snack": true,
	".Collect_Trash": 20,
	".Sleep": true,
	".Check_Fridge": true,
	".Pee": true,
	".Take_a_Shower": true,
	".Watch_TV": true,
	".Brush_Teeth": true,
	".Water_Plants": 9,
	".Find_Key": true,
	".Find_Photos": 4,
	"Sair": false
}

# OBJETIVOS DOS DIAS

var tasks_1 := {
	".Wash_Dishes": true,
	".Open_Boxes": 5,
	".Eat_Snack": true,
	".Collect_Trash": 20
}

var tasks_2 := {
	".Open_Boxes": 10,
	".Pee": true,
	".Watch_TV": true,
	".Check_Fridge": true
}

var tasks_3 := {
	".Open_Boxes": 15,
	".Brush_Teeth": true,
	".Eat_Snack": true,
	".Water_Plants": 9
}

var tasks_4 := {
	".Open_Boxes": 20,
	".Take_a_Shower": true,
	".Find_Key": true,
	".Find_Photos": 4
}

var tasks_5 := {
	".Open_Boxes": 25,
	".Wash_Dishes": true,
	".Eat_Snack": true,
	".Collect_Trash": 20
}

var tasks_6 := {
	"Sair": false,
}

var day := 1
var transition := false #Changes the day
var final_transition := false #Ends the game

var volume_db := [-80, -40, -35, -30, -25, -20, -15, -10, -5, 0, 5]
var music_volume_db := [-80, -45, -40, -35, -30, -25, -20, -15, -10, -5, 0]
var language_array := ["en_US", "pt_BR"]
var language_index := 0

var musics_volume := 8
var sounds_volume := 8

func get_day_tasks(day:int):

	match day:
		1: return tasks_1
		2: return tasks_2
		3: return tasks_3
		4: return tasks_4
		5: return tasks_5
		6: return tasks_6

	return {}

func is_day_complete(day:int) -> bool:

	var tasks = get_day_tasks(day)

	for task_name in tasks:

		var target = tasks[task_name]
		var progress = task_list[task_name]

		# tarefas booleanas
		if typeof(target) == TYPE_BOOL:
			if progress == false:
				return false

		# tarefas com número
		else:
			if progress < target:
				return false

	return true

func reset_all() -> void:
	task_list = {
	".Open_Boxes": 0,
	".Wash_Dishes": false,
	".Eat_Snack": false,
	".Collect_Trash": 0,
	".Sleep": false,
	".Check_Fridge": false,
	".Pee": false,
	".Take_a_Shower": false,
	".Watch_TV": false,
	".Brush_Teeth": false,
	".Water_Plants": 0,
	".Find_Key": false,
	".Find_Photos": 0,
	"Sair": false }

func save_game():
	var data = {
		"day": day,
		"language_index": language_index,
		"musics_volume": musics_volume,
		"sounds_volume": sounds_volume
	}

	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_game():
	if !FileAccess.file_exists("user://save.json"):
		return
	
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	day = data["day"]
	language_index = data["language_index"]
	musics_volume = data["musics_volume"]
	sounds_volume = data["sounds_volume"]
