extends RigidBody2D

@export var explosion_force: float = 500.0

func _ready():
	# Apply an initial force to the projectile
	apply_central_impulse(Vector2.RIGHT * explosion_force)

func _on_body_entered(body: Node):
	# Handle collision with another body
	if body.is_in_group("enemies"):
		body.stun(10)  # Assume the enemy has a take_damage() method
	queue_free()  # Destroy the projectile after hitting something
