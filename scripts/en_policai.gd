extends CharacterBody2D

enum State {
	 IDLE, ROAMING, STUNNED 
	}
var current_state = State.ROAMING
var stun_timer: Timer
var SPEED := 100.0
var direction := 1

@onready var stomp_detector: Area2D = $StompDetector
@onready var killzone: Area2D = $PlayerKiller
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

#mby? Get the gravity frmo the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Create a Timer for the stun duration
	stun_timer = Timer.new()
	stun_timer.one_shot = true
	stun_timer.timeout.connect(_on_stun_end)
	add_child(stun_timer)
	stomp_detector.body_entered.connect(_on_stomp_detector_body_entered)
	killzone.body_entered.connect(_on_killzone_body_entered)
	
func _on_stomp_detector_body_entered(body):
	if body.is_in_group("player_char"):
		get_stunned(4.0)
		body.bounce()
		
func _on_killzone_body_entered(body):
	print("Killzone body entered:", body.name)
	if body.is_in_group("player_char") :
		body.die()
	else: pass

func get_stunned(duration : float):
	if current_state != State.STUNNED:
		print("Enemy stunned!")
		current_state = State.STUNNED
		stun_timer.start(duration)  # Stun for 2 seconds
		# Example: Change animation or stop movement
		#$AnimatedSprite2D.play("stunned")
		
func _on_stun_end():
	print("Enemy recovered from stun!")
	current_state = State.ROAMING
	# Example: Resume normal behavior
	#$AnimatedSprite2D.play("moving")

func _process(delta):
	if current_state == State.STUNNED:
		killzone.monitoring = false
	elif current_state == State.ROAMING:
		killzone.monitoring = true
		
func basic_movement(delta):
	velocity.x = SPEED * direction
	move_and_slide()
	if not is_on_floor():
		velocity += get_gravity() * delta
	if velocity.x < 0:
		animated_sprite.flip_h = false
	if velocity.x > 0:
		animated_sprite.flip_h = true
func roaming(delta):
	basic_movement(delta)
	if is_on_wall():
		direction *= -1

func _physics_process(delta):
	match current_state:
		State.ROAMING:
			SPEED = 100
			roaming(delta)
		State.STUNNED:
			SPEED = 0


		
	
