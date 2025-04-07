extends Actor

var direction: int = -1

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_on_wall():
		direction *= -1
	
	velocity.x = direction * speed
	
	move_and_slide()
