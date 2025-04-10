extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		animated_sprite_2d.play("collected")


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
