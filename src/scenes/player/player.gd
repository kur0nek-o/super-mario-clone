extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -800.0
const DECELERATION_SPEED = 25.0
const ACCELERATION_SPEED = 30.0

var is_going_up: bool = false
var is_jumping: bool = false
var is_falling: bool = false
var last_frame_on_floor: bool = false
var is_hurting: bool = false

@onready var player_animation = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	is_falling = velocity.y > 0 and not is_on_floor()
	
	# Handle jump.
	handle_jump(get_jump_input(), get_jump_input_release())
	handle_jump_buffer(get_jump_input())
	handle_coyote_timer()
	
	last_frame_on_floor = is_on_floor()

	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		player_animation.flip_h = velocity.x < 0

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION_SPEED)
	
	animation_handler(direction)
	
	move_and_slide()

func knockback() -> void:
	is_hurting = true
	velocity.y = JUMP_VELOCITY
	
	if  player_animation.flip_h:
		velocity.x = 500.0
	else:
		velocity.x = -500.0

func handle_coyote_timer() -> void:
	if not is_on_floor() and last_frame_on_floor and not is_jumping:
		coyote_timer.start()

func handle_jump_buffer(want_to_jump: bool) -> void:
	if want_to_jump and not is_on_floor():
		jump_buffer_timer.start()
	
	if is_on_floor() and not jump_buffer_timer.is_stopped():
		jump()

func handle_jump(want_to_jump: bool, jump_released: bool) -> void:
	if is_on_floor() and not last_frame_on_floor and is_jumping:
		is_jumping = false
	
	if is_allowed_to_jump(want_to_jump):
		jump()

	handle_variable_jump_height(jump_released)
	
	is_going_up = velocity.y < 0 and not is_on_floor()

func is_allowed_to_jump(want_to_jump: bool) -> bool:
	return want_to_jump and (is_on_floor() or not coyote_timer.is_stopped())

func handle_variable_jump_height(jump_released: bool) -> void:
	if jump_released and is_going_up:
		velocity.y = 0

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	
	is_jumping = true
	
	coyote_timer.stop()
	jump_buffer_timer.stop()

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")

func get_jump_input_release() -> bool:
	return Input.is_action_just_released("jump")

func animation_handler(direction: float) -> void:
	if is_hurting:
		player_animation.play("hurting")
		
		await get_tree().create_timer(0.3).timeout
		is_hurting = false
	
	if not is_on_floor():
		if is_jumping:
			player_animation.play("jumping")
		
		if is_falling:
			player_animation.play("falling")
	else:
		if direction != 0:
			player_animation.play("running")
		else:
			player_animation.play("idle")
