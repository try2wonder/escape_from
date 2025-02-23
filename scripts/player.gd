extends CharacterBody2D

@export var projectile_scene: PackedScene  # Assign the projectile scene in the Inspector
var is_facing_right: bool = true

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var countJumps :int 
@onready var animated_sprite = $AnimatedSprite2D
@onready var weapon_menu = $"../CanvasLayer/WeaponMenu"

#Get the gravity frmo the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	weapon_menu.connect("weapon_changed", _on_weapon_changed)
	if projectile_scene == null:
		print("Projectile scene is not assigned!")

func _on_weapon_changed(index: int):
	print("Switched to weapon:", index)
	# Update the character's weapon logic here

func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		spawn_projectile()
		
func spawn_projectile():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		projectile.shot_speed = 500
		
		#Set the projectile direction
		if is_facing_right:
			projectile.direction = Vector2(1, -1)
			
		else:
			projectile.direction = Vector2(-1, -1)
			
		get_parent().add_child(projectile)
		projectile.position = position
		print("Projectile Spawned")
	else:
		print("Projectile scene is not assigned!")

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
	#Get input direction: -1 0 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#Apply movemet + slowing down
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#Flips the sprite
	if direction < 0:
		animated_sprite.flip_h = true
		is_facing_right = false
		
	elif direction > 0:
		animated_sprite.flip_h = false
		is_facing_right = true
		
		
	#play animations
	if not is_on_floor():
		animated_sprite.play("jumping")
	if is_on_floor():
		if direction ==0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	move_and_slide()

		
