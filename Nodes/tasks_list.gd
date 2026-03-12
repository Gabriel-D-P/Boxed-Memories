extends Node2D
@onready var main: Label = $CL/Label

@onready var task1: Label = $CL/Task1
@onready var task2: Label = $CL/Task2
@onready var task3: Label = $CL/Task3
@onready var task4: Label = $CL/Task4
@onready var task5: Label = $CL/Task5

@onready var cl: CanvasLayer = $CL

var current_tasks := []
var labels := []

func _ready() -> void:
	if Global.day == 6:
		main.text = " "
		task1.text = " "
		task2.text = " "
		task3.text = " "
		task4.text = " "
		task5.text = " "
	else:
		var tasks = Global.get_day_tasks(Global.day)

		current_tasks = tasks.keys()
		current_tasks.shuffle()

		var labels = [task1, task2, task3, task4, task5]

		for i in range(min(current_tasks.size(), labels.size())):
			labels[i].text = current_tasks[i]
		task5.text = ".Sleep"
	
	var tasks = Global.get_day_tasks(Global.day)
	labels = [task1, task2, task3, task4, task5]


func _physics_process(_delta: float) -> void:

	#if Input.is_action_just_pressed("Tab") and !Global.transition:
		#cl.visible = !cl.visible

	if Global.transition:
		cl.visible = false

	if Global.day in [1, 2, 3, 4, 5]:
		var tasks = Global.get_day_tasks(Global.day)

		for i in range(min(current_tasks.size(), labels.size())):
			if current_tasks[i] in [".Collect_Trash", ".Open_Boxes", ".Find_Photos", ".Water_Plants"]:
				labels[i].text = str(current_tasks[i])
				labels[i].get_child(0).text = str(Global.task_list.get(current_tasks[i], 0), "/", tasks.get(current_tasks[i], 0))
			else:
				labels[i].text = current_tasks[i]
				if labels[i].get_child_count() > 0:
					labels[i].get_child(0).text = " "
		task5.text = ".Sleep"

	for task in cl.get_children():

		if task is Label:

			match task.text:

				"Sair":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get("Sair", 0) else Color(0,0,0)

				".Wash_Dishes":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Wash_Dishes", 0) else Color(0,0,0)

				".Collect_Trash":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Collect_Trash", 0) >= 20 else Color(0,0,0)

				".Open_Boxes":
					match Global.day:
						1:
							task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Open_Boxes", 0) >= 2 else Color(0,0,0)
						2:
							task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Open_Boxes", 0) >= 5 else Color(0,0,0)
						3:
							task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Open_Boxes", 0) >= 8 else Color(0,0,0)
						4:
							task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Open_Boxes", 0) >= 12 else Color(0,0,0)
						5:
							task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Open_Boxes", 0) >= 16 else Color(0,0,0)

				".Eat_Snack":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Eat_Snack", 0) else Color(0,0,0)

				".Sleep":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Sleep", 0) else Color(0,0,0)

				".Check_Fridge":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Check_Fridge", 0) else Color(0,0,0)

				".Pee":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Pee", 0) else Color(0,0,0)

				".Take_a_Shower":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Take_a_Shower", 0) else Color(0,0,0)

				".Watch_TV":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Watch_TV", 0) else Color(0,0,0)

				".Brush_Teeth":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Brush_Teeth", 0) else Color(0,0,0)

				".Water_Plants":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Water_Plants", 0) >= 9 else Color(0,0,0)

				".Find_Key":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Find_Key", 0) else Color(0,0,0)

				".Find_Photos":
					task.modulate = Color(0.5,0.5,0.5) if Global.task_list.get(".Find_Photos", 0) >= 4 else Color(0,0,0)
