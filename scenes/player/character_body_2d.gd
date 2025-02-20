extends CharacterBody2D

var speed = 200
var jump_force = -400
var gravity = 800


func _ready():
	$Camera2D.make_current()

func _physics_process(delta):
	velocity.y += gravity * delta
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()
