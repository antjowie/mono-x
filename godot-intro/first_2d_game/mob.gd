extends RigidBody2D

var _anim: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_anim = $AnimatedSprite2D
	var mob_types = _anim.sprite_frames.get_animation_names()
	_anim.play(mob_types[randi() % mob_types.size()])


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Replace with function body.
