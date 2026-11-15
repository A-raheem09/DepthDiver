extends CharacterBody2D

enum state {
	WALK,
	IDLE,
	JUMP,
	FALL,
	LAND,
	DEATH
}
const SPEED = 150.0
const JUMP_VELOCITY = -200.0
@onready var can_move = true
@onready var can_fall = true
@onready var jumping = false
@onready var signal1 = $AnimatedSprite2D.animation_finished
@onready var dropping : bool = false
@onready var dying : bool = false
@onready var timer
#@onready var jump_inc = 2 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and can_fall and dying == false:
		velocity += (get_gravity() * delta) * 0.5
		$AnimatedSprite2D.play("Fall")
	if is_on_floor() and $AnimatedSprite2D.animation == "Fall" and dying == false:
		$AnimatedSprite2D.play("Land")
		can_move = false
		
		await signal1
		can_move = true
	
	# Handle jump.
	#var jump_maxxing = 0
	if Input.is_action_just_pressed("Jump") and is_on_floor() and can_move == true and dying == false:
		can_move = false
		jumping = true
		$AnimatedSprite2D.play("Jump")
		await signal1
		jumping = false
		velocity.y = JUMP_VELOCITY
		Global.fall_time = -0.5
		can_move = true
	if Input.is_action_just_pressed("Drop"):
		set_collision_mask_value(1,false)
		dropping = true
		timer = get_tree().create_timer(0.5).connect("timeout",reset_mask)
		Global.fall_time = -0.5
	
	#while Input.is_action_pressed("Jump") and not is_on_floor() and jump_maxxing >= -600:
		#velocity.y = jump_inc TRIED TO MAKE HOLLOWKNIGHT JUMP WHERE IF YOU HOLD YOU JUMP HIGHER
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction and can_move and jumping == false and dying == false:
			Global.moved = true
			velocity.x = direction * SPEED
			if $AnimatedSprite2D.animation != "Walk" and is_on_floor():
				$AnimatedSprite2D.play("Walk")
			if sign(direction) == -1 :
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#$AnimatedSprite2D.play("default")
	var signal2 = $AnimatedSprite2D.animation_looped
	if signal2 and $AnimatedSprite2D.animation == "Walk" and velocity.x == 0 and can_move and dying == false:
		$AnimatedSprite2D.play("default")
	move_and_slide()
func reset_mask():
	set_collision_mask_value(1,true)
func death():
	$AnimatedSprite2D.play("Death")
	print("dying")
	velocity = Vector2(0,0)
	dying = true
	Global.dead = dying
	await get_tree().create_timer(2).timeout
	dying = false
	
func respawn():
	$AnimatedSprite2D.play("Respawn")
	dying = true
	velocity = Vector2(0,0)
	print("respawning")
	await signal1
	dying = false
	print("respawned")
