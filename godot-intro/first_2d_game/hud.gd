extends CanvasLayer

signal start_game

func _ready() -> void:
	show_welcome()

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)

func show_welcome() -> void:
	$Message.text = "Dodge the creeps!"
	$ScoreLabel.text = "0"
	$StartButton.show()

func show_get_ready() -> void:
	$Message.text = "Get Ready!"
	$MessageTimer.start()

func show_game_over() -> void:
	$Message.text = "Game Over!"
	await get_tree().create_timer(2).timeout
	show_welcome()

func _on_message_timer_timeout() -> void:
	$Message.text = ""

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
	show_get_ready()
