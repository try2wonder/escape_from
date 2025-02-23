extends CharacterBody2D

enum State { IDLE, MOVING, STUNNED }
var current_state = State.MOVING
var stun_timer: Timer
var SPEED := 100.0
var direction := 1

@onready var animated_sprite = $AnimatedSprite2D

#Get the gravity frmo the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Create a Timer for the stun duration
	stun_timer = Timer.new()
	stun_timer.one_shot = true
	stun_timer.timeout.connect(_on_stun_end)
	add_child(stun_timer)

func get_stunned(duration : float):
	if current_state != State.STUNNED:
		print("Enemy stunned!")
		current_state = State.STUNNED
		stun_timer.start(duration)  # Stun for 2 seconds
		# Example: Change animation or stop movement
		#$AnimatedSprite2D.play("stunned")

func _on_stun_end():
	print("Enemy recovered from stun!")
	current_state = State.MOVING
	# Example: Resume normal behavior
	#$AnimatedSprite2D.play("moving")

func _physics_process(delta):
	match current_state:
		State.MOVING:
			SPEED = 100
			velocity.x = SPEED * direction
			move_and_slide()
	# Reverse direction if hitting a wall
			if is_on_wall():
				direction *= -1
				animated_sprite.flip_h
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta
		State.STUNNED:
			SPEED = 0

	
	
