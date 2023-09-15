extends Area2D

signal hit

@export var speed: int = 400 # How fast the player moves (pixels/s)
var _screen_size: Vector2
var _anim: AnimatedSprite2D
var _collision: CollisionShape2D

func start(pos: Vector2):
	position = pos
	show()
	_collision.disabled = false
	

func _ready() -> void:
	_screen_size = get_viewport_rect().size
	_anim = $AnimatedSprite2D
	_collision = $CollisionShape2D
	hide()

func _process(delta: float) -> void:
	var input: Vector2 = Vector2.ZERO
	
	input.y -= 1 if Input.is_action_pressed("move_up") else 0
	input.y += 1 if Input.is_action_pressed("move_down") else 0
	input.x += 1 if Input.is_action_pressed("move_right") else 0
	input.x -= 1 if Input.is_action_pressed("move_left") else 0
	
	if input.length() > 0:
		var velocity = input.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, _screen_size)
		
		_anim.flip_h = input.x < 0
		_anim.flip_v = input.y > 0
		_anim.animation = "up" if velocity.y != 0 else "walk"
		
		_anim.play()
	else:
		_anim.stop()


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	_collision.set_deferred("disabled", true)
