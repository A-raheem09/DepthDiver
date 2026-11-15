extends Node2D
const spawn = Vector2(132,24)
@onready var diver = $diver
@onready var fall_timer = $diver/fall_timer
@onready var temp_points
@onready var timer
@onready var points = $CanvasLayer/points_holder/points
@onready var depth = $CanvasLayer/depth_holder/depth
@onready var shop_button = $CanvasLayer/shop
@onready var respawning = false
@onready var god = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.fall_time = -0.5
	if Global.stats[2] >= 1 or god:
		Global.bouncevision = true
	diver.respawn()
	pass # Replace with function body.
func falling():
	Global.fall_time += 0.1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.bounce == true:
		diver.velocity.y = -300
		Global.bounce = false
	Global.depth = int(diver.position.y - 23)/10
	depth.text = "Depth: " + str(Global.depth)
	points.text = "Points: " + str(Global.stats['points'])
	if not diver.is_on_floor() and fall_timer.is_stopped() and not god:
		fall_timer.start(0.1)
		$diver/fallsfx.play()
	if diver.is_on_floor():
		if not fall_timer.is_stopped():
			$diver/fallsfx.stop()
			$diver/landsfx.play(3.9)
		fall_timer.stop()
		Global.fall_time = 0
	if Global.fall_time >= Global.stats["freefall"] and not respawning:
		respawn()
	if Global.moved:
		shop_button.visible = false
		$CanvasLayer/points_holder.visible = false
	else:
		shop_button.visible = true
		$CanvasLayer/points_holder.visible = true
	if Global.attempts >= 2:
		Global.points_mult = Global.stats['points_mult'] - 0.75
	elif Global.attempts == 0 and Global.highscore:
		Global.points_mult = Global.stats["points_mult"] + 1.5
	else:
		Global.points_mult = Global.stats['points_mult']
func respawn():
	diver.death()
	$diver/deathfx.play()
	respawning = true
	await get_tree().create_timer(0.2).timeout
	$AnimationPlayer.play("Reset")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("fade out")
	await get_tree().create_timer(0.5).timeout
	if Global.depth > Global.stats["highscore"]:
		Global.stats["highscore"] = Global.depth
		Global.highscore = true
		Global.attempts = 0
	else:
		Global.attempts += 1
		Global.highscore = false
	temp_points = Global.depth * max(Global.points_mult,0.01)
	Global.moved = false
	fall_timer.stop()
	Global.fall_time = 0
	diver.global_position = spawn
	diver.respawn()
	respawning = false
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


func _on_next_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "diver":
		$AnimationPlayer.play("new_scene")
		$CanvasLayer/Label.z_index += 1000
		$CanvasLayer/Label.text = "Wandering into your own demise little puppet? So be it."
	pass # Replace with function body.
