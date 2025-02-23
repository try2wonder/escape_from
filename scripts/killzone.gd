extends Area2D

@onready var timer = $Timer
@onready var game_manager = %GameManager
signal enemy_dead

func _on_body_entered(body):
	if body.is_in_group("player_char") :
		print("You died")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	if body.is_in_group("hostile_NPC"):
		game_manager.add_kill_point()
		body.queue_free()
		

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
