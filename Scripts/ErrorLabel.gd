extends Node

var alreadyShowingError: bool = false

func ShowError():
	if (!alreadyShowingError):
		alreadyShowingError = true
		self.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 1.5)
		await tween.finished
		alreadyShowingError = false
