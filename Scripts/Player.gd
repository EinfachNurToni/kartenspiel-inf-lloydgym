class_name Player

extends Node

@export_category("Basic stats:")
@export var playerName: String
@export var health: int
@export var maxHealth: int
@export var defense: int

@export_category("Defining direct enemies:")
@export var attackingTarget: Player
@export var defendingAgainst: Player

@export_category("Player's card hand:")
@export var positionOfCardHandObject: Node
@export var cardHand: Array[Card] = []

@export_category("Reference to ingame objects:")
@onready var gameplayManager = get_tree().root.get_child(0)
@export var handUIObject: Control
@export var playerStats: Control

func PlayerHasDied():
	if (playerName == "Player 1"):
		gameplayManager.gameOverLogic.LoseGame()
		health = 0
		defense = 0
		playerStats.PlayerHasDied()
	else:
		gameplayManager.PlayerDied(self)
		health = 0
		defense = 0
		playerStats.PlayerHasDied()

func GettingAttacked(attackStrength: int):
	if (attackStrength > defense):
		var newAttackStrength = (attackStrength - defense)
		defense = 0 # Also losing all defense
		if (health - newAttackStrength <= 0):
			# Detected that player has died:
			PlayerHasDied()
		else:
			health = health - newAttackStrength # Losing health after losing defense
	elif (attackStrength <= defense):
		defense = defense - attackStrength

func PreparingDefense(defenseValue: int):
	defense = defense + defenseValue
