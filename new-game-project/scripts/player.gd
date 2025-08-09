extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var is_dead = false
var temp_var = 0
var can_move_leftRight = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# get axis direction, can be 1, 0 , -1
	var direction := Input.get_axis("left", "right")
	
	# disables movement when can_move_leftRight returns false (set by a killbox)
	if not can_move_leftRight:
		direction = 0
	
	# flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
	# play animations
	# if the player is on the floor and alive, idle and run
	if is_on_floor() and not is_dead:
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	# if the player is not on the floor, but is not dead, fall
	elif not is_on_floor() and not is_dead:
		animated_sprite_2d.play("jump")
	# if the player is not on the floor and is dead, fall and die
	elif not is_on_floor() and is_dead:
		# temp variable to play the animation only once
		if temp_var == 0:
			animated_sprite_2d.play("death")
			temp_var += 1
	
	# apply movement direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
