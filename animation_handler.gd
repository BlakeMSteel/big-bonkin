extends Node2D

@onready var attack_sprite: AnimatedSprite2D = $AnimatedAttack
@onready var idle_sprite: AnimatedSprite2D = $AnimatedIdle
@onready var run_sprite: AnimatedSprite2D = $AnimatedRun
@onready var jump_sprite: AnimatedSprite2D = $AnimatedJump
@onready var walk_sprite: AnimatedSprite2D = $AnimatedWalk
@onready var die_sprite: AnimatedSprite2D = $AnimatedDie

var sprites = {}
var currentSprite: AnimatedSprite2D

var facing = "down"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprites = {
		"attack": attack_sprite,
		"idle": idle_sprite,
		"run": run_sprite,
		"jump": jump_sprite,
		"walk": walk_sprite,
		"die": die_sprite
	}
	currentSprite = idle_sprite
	currentSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_animation(animation: String) -> void:
	if sprites.find_key(animation) == null:
		pass

	currentSprite.stop()
	currentSprite.visible = false
	currentSprite = sprites[animation]
	currentSprite.animation = facing
	currentSprite.visible = true
	currentSprite.play()
	

func set_facing(position: Variant, target: Vector2) -> void:
	var facing_angle = position.direction_to(target).angle()
	if facing_angle < PI / 6 && facing_angle > -PI / 6:
		facing = "right"
	elif facing_angle >= PI / 6 && facing_angle < PI / 3:
		facing = "down_right"
	elif facing_angle >= PI / 3 && facing_angle < 2 * PI / 3:
		facing = "down"
	elif facing_angle >= 2 * PI / 3 && facing_angle < 5 * PI / 6:
		facing = "down_left"
	elif facing_angle >= 5 * PI / 6 || facing_angle <= -5 * PI / 6:
		facing = "left"
	elif facing_angle <= -2 * PI / 3 && facing_angle > -5 * PI / 6:
		facing = "up_left"
	elif facing_angle <= -PI / 3 && facing_angle > -2 * PI / 3:
		facing = "up"
	elif facing_angle <= -PI / 6 && facing_angle > -PI / 3:
		facing = "up_right"
	currentSprite.animation = facing
