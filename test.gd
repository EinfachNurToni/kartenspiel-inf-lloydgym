extends Node

var deck = ["res://32 by 32 attack card.png", "res://32 by 32 stop attack card.png", "res://32_by_32 Change diretion card.png"]  # Ihr Deck von Karten
var hand = []  # Die Hand des Spielers
var hand_position = Vector2(100, 500)  # Die Position der Hand des Spielers auf dem Bildschirm
var card_spacing = 10  # Der Abstand zwischen den Karten in der Hand des Spielers

func _on_button_pressed():
	var index = randi() % deck.size()  # Generieren Sie einen zufälligen Index
	var card = deck[index]  # Abrufen der zufälligen Karte aus dem Deck
	var sprite = Sprite2D.new()  # Erstellen Sie eine neue Sprite2D-Instanz
	sprite.texture = load(card)  # Laden Sie die Textur der Karte
	add_child(sprite)  # Fügen Sie die Sprite zum aktuellen Knoten hinzu
	sprite.global_position = hand_position + Vector2(hand.size() * card_spacing, 0)  # Positionieren Sie die Karte in der Hand des Spielers
	hand.append(sprite)  # Fügen Sie die Karte zur Hand des Spielers hinzu
