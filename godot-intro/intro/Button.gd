extends Button

var original_text: String
var timer: Timer

func _ready() -> void:
	original_text = text
	timer = $"../Sprite2D/Timer"

func _process(delta: float) -> void:
	text = original_text + " " + String.num(timer.time_left,2)
