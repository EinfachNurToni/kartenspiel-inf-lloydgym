extends Node

# Reference to Card Deck:
@onready var cardDeck = %"Card Deck"

# Reference to Canvas Layer:
@onready var canvasLayer = %"Canvas Layer"

# Reference to Game Over Screen Logic:
@onready var gameOverLogic = %"Game Over Screen"

# List of all players in their respective sequence:
@export var playerSequence: Array[Player] = []

# References to all other important objects:
@export var playersTurnLabel: Label

# Bool for when game is currently in progress:
@export var gameIsRunning: bool = true

# Bool to make sure animations/actions don't overlap:
@export var actionInProgress: bool = false

# Bool for when player one is at their turn:
@export var playerOneActive: bool = false

#region Functions for the entire main gameplay loop:
func _ready():
	# Giving all players their enemy references / Setting up sequence:
	SetSequenceInPlayer()
	
	# Giving all players their five starting cards:
	for n in range(2):
		for player in playerSequence:
			await GivePlayerCard(player, 0.1, false)
	
	print("<GameplayManager> It's your turn!")
	playerOneActive = true

func _process(delta):
	if (actionInProgress or !gameIsRunning):
		playersTurnLabel.visible = false
	else:
		if (playerOneActive == true):
			playersTurnLabel.visible = true
		elif(playerOneActive == false and playersTurnLabel.visible == true):
			playersTurnLabel.visible = false

func NextTurn():
	# Ending player's turn:
	playerOneActive = false
	print("<GameplayManager> Ending turn...")
	
	# Updating sequence in all players:
	SetSequenceInPlayer()
	
	for player in playerSequence:
		# Ignore if player one:
		if (player.playerName == "Player 1"):
			# If there is only one player remaining:
			if (playerSequence.size() == 1):
				gameOverLogic.WonGame()
				break
			else:
				continue
		elif (player.health <= 0):
			continue
			
		# Checking if game is still running:
		if (!gameIsRunning):
			break
			
		# Letting AI decide what to do:
		print("<GameplayManager> Making decision for: " + str(player))
		await MakeDecisionForPlayer(player)
	
	print("<GameplayManager> It's your turn!")
	playerOneActive = true
#endregion

func MakeDecisionForPlayer(playerToDecideFor: Player):
	# Activating indicator that this player is making their turn:
	playerToDecideFor.playerStats.titleOfPlayer.set("theme_override_colors/font_color", Color8(124, 191, 124))
	
	var randomValue: int = randi_range(1, 100)
	
	if (playerToDecideFor.cardHand.size() == 0):
		# Player has empty hand and has to draw:
		await GivePlayerCard(playerToDecideFor, 1.0, false)
	elif (playerToDecideFor.cardHand.size() > 3):
		if (randomValue > 10):
			# Player WILL play a card:
			await PlayCardForPlayer(playerToDecideFor)
		else:
			# Player draws another card:
			await GivePlayerCard(playerToDecideFor, 1.0, false)
	elif (playerToDecideFor.cardHand.size() <= 3):
		if (randomValue > 30):
			# Player draws another card:
			await GivePlayerCard(playerToDecideFor, 1.0, false)
		else:
			# Player WILL play a card:
			await PlayCardForPlayer(playerToDecideFor)
	
	# Disabling indicator that this player is making their turn:
	playerToDecideFor.playerStats.titleOfPlayer.set("theme_override_colors/font_color", Color8(220, 220, 220))

#region Function for when player dies:
func PlayerDied(playerThatDied: Player):
	print("<GameplayManager> " + str(playerThatDied) + " has just died!")
	playerSequence.erase(playerThatDied)

#region Setting/Updating Sequence of all players: (order of play)
func SetSequenceInPlayer():
	var index = 0
	for player in playerSequence:
		if (index + 1 > (playerSequence.size() - 1)):
			player.attackingTarget = playerSequence[0]
		else:
			player.attackingTarget = playerSequence[index + 1]
		if (index - 1 < 0):
			player.defendingAgainst = playerSequence[playerSequence.size() - 1]
		else:
			player.defendingAgainst = playerSequence[index - 1]
		index += 1
#endregion

#region Playing an card for an other player:
func PlayCardForPlayer(playerToPlayFor: Player):
	var randomCard: Card = playerToPlayFor.cardHand[randi_range(0, playerToPlayFor.cardHand.size() - 1)]
	if (randomCard.cardValue > 0):
		await randomCard.PlayingCard("attack")
	elif (randomCard.cardValue < 0):
		await randomCard.PlayingCard("defense")
#endregion

#region Giving card to an player:
func GivePlayerCard(playerToReceiveCard: Player, speedMultiplier: float, immediatelyShow: bool):
	if (playerToReceiveCard.cardHand.size() >= 6):
		# If card hand is full, player will play a card instead:
		PlayCardForPlayer(playerToReceiveCard)
	else:
		print("<GameplayManager> " + str(playerToReceiveCard) + " now draws card.")
		await cardDeck.DrawCard(playerToReceiveCard, speedMultiplier, immediatelyShow)
#endregion
