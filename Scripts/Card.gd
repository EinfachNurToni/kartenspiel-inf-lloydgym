class_name Card

extends Node

@export var cardPath: String
@export var cardBackgroundPath: String
@export var cardColor: Color
@export var title: String
@export var description: String

@export var cardValue: int

# Bool to check if this card is in the player's deck:
var cardOfWhichPlayer: int = -1
var referenceToPlayer: Player

# Variables to draw card from deck:
@onready var canvasLayer = get_tree().root.get_child(0).canvasLayer
@onready var cardDeck = get_tree().root.get_child(0).cardDeck
@onready var gameplayManager = get_tree().root.get_child(0)
@onready var cardButton = $"Card Button"
@onready var topRightValue = $"Top Right Value"
@onready var bottomLeftValue = $"Bottom Left Value"

func RevealCard():
	cardOfWhichPlayer = 0
	ShowCard()

func ShowCard():
	topRightValue.modulate = Color(1.0, 1.0, 1.0, 1.0)
	bottomLeftValue.modulate = Color(1.0, 1.0, 1.0, 1.0)
	self.texture = ResourceLoader.load(cardPath)

func HideCard():
	topRightValue.modulate = Color(1.0, 1.0, 1.0, 0.0)
	bottomLeftValue.modulate = Color(1.0, 1.0, 1.0, 0.0)
	self.texture = ResourceLoader.load(cardBackgroundPath)

func PlayingCard(action: String):
	# Generic stuff to execute always:
	ShowCard() # Revealing card for playing it to others
	referenceToPlayer.cardHand.erase(self) # Removing card from actual card hand of player
	await reparent(canvasLayer)
	
	# Specific actions:
	match action:
		"attack":
			if (cardOfWhichPlayer != 0):
				await MoveCard(referenceToPlayer.attackingTarget.positionOfCardHandObject.position, 0.75)
			else:
				MoveCard(referenceToPlayer.attackingTarget.positionOfCardHandObject.position, 1.0)
			print("<Card> " + str(referenceToPlayer) + " now attacking: " + str(referenceToPlayer.attackingTarget))
			await DestroyCard(2.5)
			referenceToPlayer.attackingTarget.GettingAttacked(cardValue)
	
		"defense":
			if (cardOfWhichPlayer != 0):
				await MoveCard(referenceToPlayer.positionOfCardHandObject.position, 0.75)
			else:
				MoveCard(referenceToPlayer.positionOfCardHandObject.position, 1.0)
			print("<Card> " + str(referenceToPlayer) + " increasing defense by: " + str(-cardValue))
			await DestroyCard(2.5)
			referenceToPlayer.PreparingDefense(-cardValue)
	
	# Also generic stuff to execute always:
	HideCard()
	cardDeck.cardsInDeck.append(self) # Returning card to card deck for now --
	gameplayManager.actionInProgress = false
	if (cardOfWhichPlayer == 0):
		gameplayManager.NextTurn()

#region Drawing card from deck (Card Button)
func _ready():
	cardButton.pressed.connect(self._button_pressed)

func _process(delta):
	if (cardOfWhichPlayer != 0):
		cardButton.disabled = true
		return
	
	if (gameplayManager.actionInProgress == false):
		cardButton.disabled = !gameplayManager.playerOneActive
	else:
		cardButton.disabled = true

func _button_pressed():
	if (gameplayManager.actionInProgress):
		return
		
	gameplayManager.actionInProgress = true
	
	if (cardValue > 0):
		PlayingCard("attack")
	elif (cardValue < 0):
		PlayingCard("defense")
#endregion

#region Card animations
func InitializeCard(speedMultiplier: float):
	self.scale = Vector2(0, 0)
	self.rotation_degrees = -180
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.5 * speedMultiplier).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "rotation_degrees", 0, 0.5 * speedMultiplier).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished

func MoveCard(newPosition: Vector2, speedMultiplier: float):
	var tween = create_tween()
	tween.tween_property(self, "position", newPosition, 1 * speedMultiplier).set_trans(Tween.TRANS_QUINT)
	await tween.finished

func DestroyCard(speedMultiplier: float):
	self.scale = Vector2(1, 1)
	self.rotation_degrees = 0
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(), 0.5 * speedMultiplier).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "rotation_degrees", 180, 0.45 * speedMultiplier).set_trans(Tween.TRANS_QUINT)
	await tween.finished
#endregion
