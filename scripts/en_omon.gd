extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var killzone = $PlayerKiller
@onready var players = get_tree().get_nodes_in_group("player_char")
@onready var player_detector = $RayCast2D

enum State { IDLE, MOVING, STUNNED, CHASING, SLOWED }
var current_state = State.MOVING
var slow_timer: Timer
var SPEED := 100.0
var direction := 1
var JUMP_VELOCITY = -300.0

func get_player():
	if players.size() > 0:
		return players[0]
	return null

func get_player_coordinates():
	var player = get_player()
	if player:
		return player.global_position
	return Vector2.ZERO	
	
func point_to_player():
	#calculate the difference between Player position's Vector2D and Mob's
	var diff = get_player_coordinates() - global_position 
	
	#Horizontal movement
	if abs(diff.x) > 1:
		if diff.x > 0:	
			direction = 1
		elif diff.x < 0:
			direction = -1
	else:
		direction = 0
		
	#Vertiucal movement
	if abs(diff.x) < 1 and diff.y < 0:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
	
func _ready():
	#killzone.body_entered.connect(_on_killzone_body_entered)
	slow_timer = Timer.new()
	slow_timer.one_shot = true
	slow_timer.timeout.connect(_on_slow_end)
	add_child(slow_timer)
	
func _on_killzone_body_entered(body):
	print("Killzone body entered:", body.name)
	if body.is_in_group("player_char") :
		body.die()
	else: pass

func _process(delta):
	if current_state == State.STUNNED:
		killzone.monitoring = false
	elif current_state == State.MOVING or current_state == State.SLOWED:
		killzone.monitoring = true
	
func detect_player():
	if player_detector.is_colliding():
		var collider = player_detector.get_collider()
		if collider and collider.is_in_group("player_char"):
			current_state = State.CHASING
			player_detector.enabled = false

func get_slowed(duration):
	if current_state != State.SLOWED:
		print("Enemy slowed!")
		current_state = State.SLOWED
		slow_timer.start(duration)
		
func _on_slow_end():
	print("Enemy recovered from slow!")
	current_state = State.MOVING

func roaming(delta):
	SPEED = 100
	velocity.x = SPEED * direction
	move_and_slide()
	# Revee direction if hitting a wall
	if is_on_wall():
		direction *= -1
		animated_sprite.flip_h = not animated_sprite.flip_h
		player_detector.scale.x *= -1
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func basic_movement(delta):
	velocity.x = SPEED * direction
	move_and_slide()
	
	if is_on_wall():
		velocity.y = JUMP_VELOCITY
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if velocity.x < 0:
		animated_sprite.flip_h = false
	if velocity.x > 0:
		animated_sprite.flip_h = true

func _physics_process(delta):
	match current_state:
		State.MOVING:
			roaming(delta)
			detect_player()
		State.SLOWED:
			SPEED = 50
			JUMP_VELOCITY = -150.0
			point_to_player()
			basic_movement(delta)
		State.STUNNED:
			SPEED = 0
		State.CHASING:
			SPEED = 150
			point_to_player()
			basic_movement(delta)
			
