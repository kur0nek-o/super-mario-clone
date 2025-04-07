extends Actor

var is_going_up: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var direction: float = Input.get_axis('move_left', "move_right")
	
	# handling player movement
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, 30.0)
	else:
		velocity.x = move_toward(velocity.x, 0, 20.0)
	
	# handling jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump") and is_going_up:
		velocity.y = 0.0
	
	is_going_up = velocity.y < 0 and not is_on_floor()
	
	move_and_slide()
