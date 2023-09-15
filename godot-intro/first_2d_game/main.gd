extends Node

@export var mob_scene: PackedScene
var score: int

func _ready() -> void:
	$Music.play();

func game_over():
	$Music.stop();
	$DeathSound.play();
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	if !$Music.playing:
		$Music.play();
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_player_hit() -> void:
	game_over()

func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$MobTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score);

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	mob.rotation = mob_spawn_location.rotation + PI * 0.5
	mob.rotation += randf_range(-PI * 0.2, PI * 0.2)
	
	mob.linear_velocity = Vector2(randf_range(150, 250),0).rotated(mob.rotation)
	
	add_child(mob)

func _on_hud_start_game() -> void:
	new_game(); # Replace with function body.
