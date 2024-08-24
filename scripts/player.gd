extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var can_doublejump = false
var is_doublejumping = false
var alive = true
var is_wallsliding = false
var wallslide_gravity =  100
var wall_jump_pushback = 500
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_doublejump = true
	elif Input.is_action_just_pressed("jump") and can_doublejump:
		velocity.y = JUMP_VELOCITY
		is_doublejumping = true
		can_doublejump = false

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0: 
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor() and alive:
		is_doublejumping = false
		is_wallsliding = false
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	elif not is_on_floor() and is_on_wall() and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and alive:
		animated_sprite.play("wall_slide")
		is_wallsliding = true
		velocity.y += (wallslide_gravity * delta)
		velocity.y = min(velocity.y, wallslide_gravity)
	elif not is_on_floor() and is_doublejumping and alive:
		animated_sprite.play("double_jump")
	elif not alive:
		animated_sprite.play("death")
	else:
		animated_sprite.play("jump")
	
	if is_wallsliding and Input.is_action_just_pressed("jump") and Input.is_action_pressed("move_right"):
		velocity.y = JUMP_VELOCITY
		velocity.x = -wall_jump_pushback
	if is_wallsliding and Input.is_action_just_pressed("jump") and Input.is_action_pressed("move_left"):
		velocity.y = JUMP_VELOCITY
		velocity.x = wall_jump_pushback
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	
func death():
	alive = false
	
func bounce():
	velocity.y = JUMP_VELOCITY
	is_doublejumping = true
	can_doublejump = false
	
func stopMovement():
	velocity.y = 0
	velocity.x = 0
