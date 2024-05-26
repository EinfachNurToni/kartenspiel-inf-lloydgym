extends Node

@onready var gameplayManager = get_tree().root.get_child(0)
@onready var cardDeckObject = $"../Card Deck Object"

@onready var lostLabel = $"Lost Label"
@onready var wonLabel = $"Won Label"

@onready var replayButton = $"Replay Button"
@onready var quitButton = $"Quit Button"

#region Handling buttons
func _ready():
	replayButton.pressed.connect(self._replayButton_pressed)
	quitButton.pressed.connect(self._quitButton_pressed)

func _replayButton_pressed():
	get_tree().reload_current_scene()

func _quitButton_pressed():
	get_tree().quit()
#endregion

func LoseGame():
	gameplayManager.gameIsRunning = false
	cardDeckObject.cardDeckButton.disabled = true
	print("<GameOverLogic> Player 1 has lost the game!")
	self.visible = true
	lostLabel.visible = true

func WonGame():
	gameplayManager.gameIsRunning = false
	cardDeckObject.cardDeckButton.disabled = true
	print("<GameOverLogic> Player 1 has won the game!")
	self.visible = true
	wonLabel.visible = true
