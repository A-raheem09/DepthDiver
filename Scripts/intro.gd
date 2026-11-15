extends Control
@onready var Txt = $TextHolder/Text
@onready var diag_number = 1
@onready var timer = $Timer
@onready var count
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.stats["new_save"] == false:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	else:
		run_diag()
	pass # Replace with function body.

func run_diag():
	if diag_number == 1:
		Txt.text = "You must have many questions, about your birth, your parents..."
		count = 0
		timer.start(0.08)
	elif diag_number == 2:
		Txt.visible_ratio = 0
		Txt.text = "Go to Barnabus' dungeon.."
		timer.start(0.08)
	elif diag_number == 3:
		Txt.visible_ratio = 0
		Txt.text = "There you will find the answers.."
		timer.start(0.08)
	elif diag_number == 4:
		Txt.visible_ratio = 0
		Txt.text = "Although finding the dungeon may be the greatest task you face.."
		timer.start(0.08)
	elif diag_number == 5:
		Txt.visible_ratio = 0
		Txt.text = "May The Spirits Look Kindly Upon Ye"
		timer.start(0.08)
func _diag_show():
	count = min(count+0.1, 1)
	Txt.visible_ratio = min(count,1)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if count == 1:
		timer.stop()
		count = 0
		$Finished.start(1)


func _on_finished_timeout() -> void:
	diag_number += 1
	if diag_number >= 6:
		exit()
	run_diag()
	pass # Replace with function body.
func exit():
	Global.stats['new_save'] = false
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
