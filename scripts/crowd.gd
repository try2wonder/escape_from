extends Area2D


func _on_body_entered(body):
	if  is_inside_tree():
		if body.is_in_group("player_char"):
			print("Player entered")
			var chasing_NPCs = get_tree().get_nodes_in_group("hostile_NPC")
			
			for char in chasing_NPCs:
				print(typeof(char))
				if char.is_in_group("chasing"):
					char.passify()
