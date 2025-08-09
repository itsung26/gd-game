extends Node

var score = 0
@onready var coin_counter: Label = $CoinCounter

func add_point():
	score += 1
	coin_counter.text = "you collected " + str(score) + " coins."
	print("coins: " + str(score))

func _process(delta) -> void:
	
	# when tidle key is pressed, force quit the whole scene tree
	if Input.is_action_pressed("quit"):
		get_tree().quit()
