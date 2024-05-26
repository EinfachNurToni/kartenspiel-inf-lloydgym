extends Node

@export var referenceToPlayer: Player
@export var playerName : String = ""

@onready var titleOfPlayer = $"Title of Player"
@onready var healthOfPlayer = $"Health of Player"
@onready var defenseOfPlayer = $"Defense of Player"

func _ready():
	if (playerName == ""):
		playerName = referenceToPlayer.playerName
	titleOfPlayer.text = "- " + playerName

func _process(delta):
	UpdateHealth()
	UpdateDefense()

func PlayerHasDied():
	healthOfPlayer.text = "HP: 0"
	healthOfPlayer.text = "Defense: 0"
	titleOfPlayer.set("theme_override_colors/font_color", Color8(24, 24, 24))
	healthOfPlayer.set("theme_override_colors/font_color", Color8(61, 28, 28))
	defenseOfPlayer.set("theme_override_colors/font_color", Color8(18, 18, 18))

func UpdateHealth():
	if (referenceToPlayer.health != 0):
		healthOfPlayer.text = "HP: " + str(referenceToPlayer.health)
		
		if (referenceToPlayer.health > 75): # health high
			healthOfPlayer.set("theme_override_colors/font_color", Color8(255, 255, 255))
		elif (referenceToPlayer.health > 50): # health above mid
			healthOfPlayer.set("theme_override_colors/font_color", Color8(255, 212, 196))
		elif (referenceToPlayer.health > 25): # health below mid
			healthOfPlayer.set("theme_override_colors/font_color", Color8(255, 182, 156))
		elif (referenceToPlayer.health > 0): # health low
			healthOfPlayer.set("theme_override_colors/font_color", Color8(255, 115, 115))

func UpdateDefense():
	if (referenceToPlayer.health != 0):
		defenseOfPlayer.text = "Defense: " + str(referenceToPlayer.defense)
		
		if (referenceToPlayer.defense > 75): # defense high
			defenseOfPlayer.set("theme_override_colors/font_color", Color8(150, 203, 255))
		elif (referenceToPlayer.defense > 50): # defense above mid
			defenseOfPlayer.set("theme_override_colors/font_color", Color8(171, 211, 235))
		elif (referenceToPlayer.defense > 25): # defense below mid
			defenseOfPlayer.set("theme_override_colors/font_color", Color8(174, 205, 212))
		elif (referenceToPlayer.defense > 0): # defense low
			defenseOfPlayer.set("theme_override_colors/font_color", Color8(179, 193, 196))
		elif (referenceToPlayer.defense == 0): # defense zero
			defenseOfPlayer.set("theme_override_colors/font_color", Color8(165, 165, 165))
