extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var killzone = $PlayerKiller
@onready var players = get_tree().get_nodes_in_group("player_char")


enum State {
	 IDLE, ROAMING, STUNNED, CHASING 
	}
var current_state = State.CHASING
var stun_timer: Timer
var SPEED := 100.0
var direction := 1
const JUMP_VELOCITY = -300.0

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
	killzone.body_entered.connect(_on_killzone_body_entered)
	
func passify():
	current_state = State.ROAMING

func _on_killzone_body_entered(body):
	print("Killzone body entered:", body.name)
	if body.is_in_group("player_char") :
		body.die()
	else: pass

func _process(delta):
	if current_state == State.STUNNED:
		killzone.monitoring = false
	elif current_state == State.ROAMING or current_state == State.CHASING:
		killzone.monitoring = true
	if current_state == State.CHASING:
		add_to_group("chasing")
	else:
		remove_from_group("chasing")

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
	# Revee direction if hitting a wall
	if is_on_wall():
		direction *= -1

func chase_movement(delta):
	basic_movement(delta)
	if is_on_wall():
		velocity.y = JUMP_VELOCITY


func _physics_process(delta):
	match current_state:
		State.ROAMING:
			SPEED = 50
			roaming(delta)
		State.STUNNED:
			SPEED = 0
		State.CHASING:
			SPEED = 100
			point_to_player()
			chase_movement(delta)
