extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()

func game_over() -> void:
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.spawn($StartPosition.position)
	$MobTimer.start()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	mob.player = $Player

	set_mob_start_position(mob)

	add_child(mob)


func set_mob_start_position(mob):
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
