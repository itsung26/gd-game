extends Area2D

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body) -> void:
	print("you died!")
	Engine.time_scale = 0.5
	body.velocity.y = 0
	body.can_move_leftRight = false
	body.is_dead = true
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
