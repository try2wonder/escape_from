extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var countJumps :int 
@onready var animated_sprite = $AnimatedSprite2D

#Get the gravity frmo the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#Added a double jump - could be an upgrade perk!
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("jump") and not is_on_floor() and countJumps < 1:
		countJumps += 1
		velocity.y = JUMP_VELOCITY
	if is_on_floor():
		countJumps =0
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Get input direction: -1 0 1
	var direction = Input.get_axis("move_left", "move_right")
	
	
	#Apply movemet
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#Flips the sprite
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false
		

	#play animations
	if not is_on_floor():
		animated_sprite.play("jumping")
	if is_on_floor():
		if direction ==0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	move_and_slide()
