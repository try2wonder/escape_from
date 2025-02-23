extends Node

var score = 0
var frags = 0

@onready var score_label = $ScoreLabel
@onready var frag_label = $"Dead NPC count"

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
	
func add_kill_point():
	frags += 1
	frag_label.text = "You've killed " + str(frags) + " enemies"
