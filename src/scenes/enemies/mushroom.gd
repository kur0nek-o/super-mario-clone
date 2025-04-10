extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_dead: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		var y_delta = position.y - body.position.y
		var x_delta = position.x - body.position.x
		
		if y_delta > 30:
			is_dead = true
			
			animated_sprite_2d.play("hurting")
			body.jump()
		else:
			print('Player is hurting')
			
			body.knockback()


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_dead:
		queue_free()
