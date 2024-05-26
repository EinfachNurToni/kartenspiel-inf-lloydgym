extends Node

# Reference to Gameplay Manager:
@onready var gameplayManager = $".."

# Reference to player one:
@onready var playerOne = $"../Players/Player"

@export var newCardPosition: Node

# Setting up the cards to start with:
@export var cardsToStartWith: Array[Card] = []
@export var amountOfCardsToStartWith: Array[int] = []

@export var cardsInDeck: Array[Card] = []

@export var currentlyDrawingCard: bool = false

func _ready():
	for i in range(cardsToStartWith.size()):
		for n in range(amountOfCardsToStartWith[i]):
			cardsInDeck.append(cardsToStartWith[i])
	randomize()
	cardsInDeck.shuffle()

func DrawCard(playerWhoDrawnCard: Player, speedMultiplier: float, immediatelyShow: bool):
	if (gameplayManager.actionInProgress):
		return
		
	gameplayManager.actionInProgress = true
	
	var randomNumber: int = randi_range(0, cardsInDeck.size() - 1)
	var drawnCard: Card = cardsInDeck[randomNumber]
	cardsInDeck.remove_at(randomNumber)
	
	var copyOfDrawnCard = drawnCard.duplicate()
	
	#region UI stuff
	(%"Canvas Layer").add_child(copyOfDrawnCard)
	copyOfDrawnCard.position = newCardPosition.position
	if (immediatelyShow):
		copyOfDrawnCard.RevealCard()
	copyOfDrawnCard.visible = true
	
	# Start animation:
	await copyOfDrawnCard.InitializeCard(speedMultiplier)
	
	# Moving card to player hand:
	await copyOfDrawnCard.MoveCard(playerWhoDrawnCard.positionOfCardHandObject.position, speedMultiplier)
	copyOfDrawnCard.reparent(playerWhoDrawnCard.handUIObject.cardHandReference)
	
	# Updating card so it shows their actual Sprite, when in hand of player one:
	if (playerWhoDrawnCard == playerOne):
		copyOfDrawnCard.RevealCard()
	#endregion:
	
	# Setting up reference to player in card:
	copyOfDrawnCard.referenceToPlayer = playerWhoDrawnCard
	
	playerWhoDrawnCard.cardHand.append(copyOfDrawnCard)
	gameplayManager.actionInProgress = false
