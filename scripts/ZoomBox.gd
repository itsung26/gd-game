extends Area2D

@onready var camera_2d: Camera2D = $"../../Player/Camera2D"


func _on_body_entered(body) -> void:
	camera_2d.zoom = Vector2(2.0, 2.0)


func _on_body_exited(body) -> void:
	camera_2d.zoom = Vector2(4.0, 4.0)
