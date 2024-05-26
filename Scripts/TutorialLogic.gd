extends Node

@export var tutorialStuff: Array[Node]
@export var statsOfPlayers: Array[Node]

func _ready():
	for playerStat in statsOfPlayers:
		playerStat.modulate = Color (1.0, 1.0, 1.0, 0.0)
	
	var tween = create_tween()
	for thing in tutorialStuff:
		tween.parallel().tween_property(thing, "modulate:a", 0, 5.0)
	await tween.finished
	
	var tween2 = create_tween()
	for playerStat in statsOfPlayers:
		tween2.parallel().tween_property(playerStat, "modulate:a", 1.0, 3.0)
	await tween2.finished
