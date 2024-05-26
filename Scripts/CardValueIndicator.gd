extends Node

@onready var card = $".."

func _process(delta):
	if (card.cardValue < 0):
		self.text = str(-card.cardValue)
	else:
		self.text = str(card.cardValue)
