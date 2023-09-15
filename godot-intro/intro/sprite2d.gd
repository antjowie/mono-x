extends Sprite2D

var speed = 400
var angular_speed = PI
var auto_move = true
var can_move = true

func _process(delta: float) -> void:
	process_move(delta)

func process_move(delta: float) -> void:
	if !can_move:
		pass

	var direction = 0;
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	
	if auto_move:
		direction = 1
	rotation += angular_speed * direction * delta
	
	var moving = 0;
	if Input.is_action_pressed("ui_up"):
		moving = 1
	
	if auto_move:	
		moving = 1
	var velocity = Vector2.UP.rotated(rotation) * speed * moving
	position += velocity * delta

func _ready() -> void:
	var timer: Timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	visible = !visible

func _on_button_pressed() -> void:
	set_process(!is_processing())
