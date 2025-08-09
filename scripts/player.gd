extends CharacterBody2D


@export var SPEED = 130.0
const JUMP_VELOCITY = -300.0

var is_dead = false
var temp_var = 0
var can_move_leftRight = true
var rolling = false
var last_direction = 1
var prior_speed = SPEED
var can_collide_with_killzone = true
var can_roll = true
var can_set_direction = true
var temp_var2 = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var roll_sound: AudioStreamPlayer2D = $RollSound
@onready var roll_sound_alt: AudioStreamPlayer2D = $RollSoundALT
@onready var footstep_1: AudioStreamPlayer2D = $Footstep1
@onready var foot_step_timer: Timer = $FootStepTimer
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

func _physics_process(delta) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	# rolling input
	if Input.is_action_just_pressed("roll"):
		if can_roll == true:
			# print("rolling")
			rolling = true

	# get axis direction, can be 1, 0 , -1
	var direction := Input.get_axis("left", "right")
	# if the direction is not zero, remember the last input direction
	if direction != 0:
		if can_set_direction == true:
			last_direction = direction
	
	# disables movement when can_move_leftRight returns false
	if not can_move_leftRight:
		direction = 0
	
	# flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
	# play animations
	# if the player is rolling, animate rolling
	if rolling:
		if temp_var2 == 0:
			var num_randi = randi_range(0, 1)
			if num_randi == 0:
				roll_sound.play()
				temp_var2 += 1
			elif num_randi == 1:
				roll_sound_alt.play()
				temp_var2 += 1
				
		can_set_direction = false
		can_move_leftRight = false
		direction = last_direction
		SPEED = 260
		can_collide_with_killzone = false
		animated_sprite_2d.play("roll")
		animation_player.play("roll")
		
	# otherwise, do all the other walking anims
	else:
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
	
	# print(SPEED)
	# print(direction)
	# print(velocity.x)

# when the player sprite animation finishes, this function is called
func _on_animated_sprite_2d_animation_finished():
	# when finished anim is roll, set the player's allowed things back to how they were before.
	if animated_sprite_2d.animation == "roll":
		temp_var2 = 0
		can_set_direction = true
		can_collide_with_killzone = true
		rolling = false
		can_move_leftRight = true
		SPEED = prior_speed
