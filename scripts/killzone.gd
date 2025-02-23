extends Area2D


@onready var game_manager = %GameManager
signal enemy_dead

func _on_body_entered(body):
	if body.is_in_group("player_char") :
		body.die()
		
	if body.is_in_group("hostile_NPC"):
		game_manager.add_kill_point()
		body.queue_free()
		
