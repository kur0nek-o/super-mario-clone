extends CharacterBody2D
class_name Actor

@export var jump_velocity: float = -1200.0
@export var gravity: float = 3000.0
@export var speed: float = 400.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
