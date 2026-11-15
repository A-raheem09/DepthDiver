extends Button
@export var upgrade_number : int
@export var stat_to_change : String
@export var amt_to_change : float
@export var initial_cost : int
@export var cost_scaling : float
@onready var cost : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = initial_cost * max(cost_scaling * Global.stats[0],1)
	connect("pressed",on_pressed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text = "Cost: " + str(cost)
	if not Global.stats["points"] >= cost:
		disabled = true
	else:
		disabled = false
	pass
func on_pressed():
	if Global.stats["points"] >= cost:
		Global.stats["points"] -= cost
		Global.stats[upgrade_number] += 1
		Global.stats[stat_to_change] += amt_to_change
		cost = initial_cost * max(cost_scaling * Global.stats[upgrade_number],1)
