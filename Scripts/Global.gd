extends Node
const FILE_PATH = "user://DiverSaveFile.json"
@onready var fall_time : float = 0
@onready var moved = false
@onready var points_mult = 1
@onready var depth : int = 0
@onready var highscore = false
@onready var dead = false
@onready var attempts : int = 0
@onready var bounce : bool = false
@onready var bouncevision = false
var stats = {
	"highscore" : 0,
	"points" : 0,
	"freefall" : 1,
	"points_mult" : 1,
	"new_save" : true,
	"can_see" : false,
	0:0,
	1:0,
	2:0,
	3:0,
	4:0,
	}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
