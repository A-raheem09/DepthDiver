extends Button
@export var upgrade_number : int
@export var cost :float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed",on_pressed)
	if Global.stats[upgrade_number] > 0:
		disabled = true
	else:
		disabled = false
	pass # Replace with function body.
func on_pressed():
	if Global.stats["points"] >= cost:
		Global.stats["points"] -= cost
		Global.stats[upgrade_number] += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
