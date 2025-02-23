extends Control

@export var weapon_textures: Array[Texture2D]  # Array of weapon textures
var current_weapon_index := 0

@onready var weapon_buttons: Array[TextureButton] = [
	$"Weapon 1",
	$"Weapon 2"
]

@onready var highlight: TextureRect = $Highlight  # Reference to the highlight node


func _ready():
	update_ui()
	set_process_unhandled_input(true)  # Ensure input is processed
	grab_focus()  # Force focus on this node

func _unhandled_input(event):
	if Input.is_action_just_pressed("Weapon_1"):  # Use the "Weapon_1" action
		switch_weapon(0)  # Switch to weapon 1
		print("wep 1")
	elif Input.is_action_just_pressed("Weapon_2"):  # Use the "Weapon_2" action
		switch_weapon(1)  # Switch to weapon 2
		print("wep 2")


func switch_weapon(index: int):
	if index < weapon_textures.size():
		current_weapon_index = index
		update_ui()
		# Emit a signal or call a method to update the character's weapon
		emit_signal("weapon_changed", current_weapon_index)

func update_ui():
	for i in range(weapon_buttons.size()):
		if i < weapon_textures.size():
			weapon_buttons[i].texture_normal = weapon_textures[i]
			weapon_buttons[i].visible = true
		else:
			weapon_buttons[i].visible = false  # Hide unused slots


	# Move the highlight to the selected weapon button
	move_highlight_to_selected_weapon()
	
func move_highlight_to_selected_weapon():
	if current_weapon_index < weapon_buttons.size():
		var selected_button = weapon_buttons[current_weapon_index]
		highlight.position = selected_button.position - Vector2(1, 0)  # Adjust offset as needed
		highlight.visible = true  # Ensure the highlight is visible
	else:
		highlight.visible = false  # Hide the highlight if no weapon is selected
