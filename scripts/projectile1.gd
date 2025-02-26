extends RigidBody2D

var shot_speed: float = 300.0          #Default
var direction: Vector2 = Vector2.RIGHT #Default

func _ready():
	gravity_scale = 1
	# Connect the body_entered signal to detect collisions
	contact_monitor = true
	max_contacts_reported = 10
	body_entered.connect(_on_body_entered)
	apply_central_impulse(direction * shot_speed)
	

func _on_body_entered(body: Node):
	# Handle collision with another body
	if body.is_in_group("hostile_NPC") and body.is_in_group("stunnable"):
		body.get_stunned(2.0)  
		queue_free() 
	if body.is_in_group("hostile_NPC") and body.is_in_group("slowable"):
		body.get_slowed(4.0)  
		queue_free() 
