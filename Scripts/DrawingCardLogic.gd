extends Node

@onready var gameplayManager = get_tree().root.get_child(0)
@onready var cardDeckButton = $"Card Deck Button"
@onready var cardDeck = %"Card Deck"
@onready var errorLabel = $"Error Label"

func _ready():
	cardDeckButton.pressed.connect(self._button_pressed)

func _process(delta):
	if (gameplayManager.actionInProgress == false):
		cardDeckButton.disabled = !gameplayManager.playerOneActive
	else:
		cardDeckButton.disabled = true

func _button_pressed():
	# Firstly checking if card hand is not full:
	if (gameplayManager.playerSequence[0].cardHand.size() >= 6):
		errorLabel.ShowError()
	else:
		# Also showing the card immediately!
		await cardDeck.DrawCard(gameplayManager.playerSequence[0], 1.0, true)
		gameplayManager.NextTurn()
