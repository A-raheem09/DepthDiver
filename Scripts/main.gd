extends Node2D
const spawn = Vector2(132,24)
@onready var diver = $diver
@onready var fall_timer = $diver/fall_timer
@onready var temp_points
@onready var timer
@onready var points = $CanvasLayer/points_holder/points
@onready var depth = $CanvasLayer/depth_holder/depth
@onready var shop_button = $CanvasLayer/shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func falling():
	Global.fall_time += 0.1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Global.depth = int(diver.position.y - 23)/10
	depth.text = "Depth: " + str(Global.depth)
	points.text = "Points: " + str(Global.stats['points'])
	if not diver.is_on_floor() and fall_timer.is_stopped():
		fall_timer.start(0.1)
	if diver.is_on_floor():
		fall_timer.stop()
		Global.fall_time = 0
	if Global.fall_time >= Global.stats["freefall"]:
		respawn()
	if Global.moved:
		shop_button.visible = false
		$CanvasLayer/points_holder.visible = false
	else:
		shop_button.visible = true
		$CanvasLayer/points_holder.visible = true
	
func respawn():
	diver.death()
	await get_tree().create_timer(0.75).timeout
	$AnimationPlayer.play("Reset")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("fade out")
	await get_tree().create_timer(0.5).timeout
	if Global.depth > Global.stats["highscore"]:
		Global.stats["highscore"] = Global.depth
		Global.highscore = true
		Global.points_mult = Global.stats["points_mult"] + 1.5
	else:
		Global.highscore = false
		Global.points_mult = Global.stats["points_mult"]
	temp_points = Global.depth * max(Global.points_mult,0.01)
	Global.moved = false
	fall_timer.stop()
	Global.fall_time = 0
	diver.global_position = spawn
	diver.respawn()
	$TallyTimer.start(0.001)
	
func tally():
	if temp_points > 0:
		if Global.highscore:
			$CanvasLayer/Highscore.visible = true
		points.visible = true
		Global.stats['points'] += 1
		temp_points -= 1
	else:
		$TallyTimer.stop()
		$CanvasLayer/Highscore.visible = false
