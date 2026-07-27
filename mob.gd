extends RigidBody2D

enum states { IDLE, TRAVEL, ATTACK, DIE }

@export var speed = 100
var target = position
var velocity
var player: CharacterBody2D
var state = states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = states.TRAVEL
	$AnimationHandler.set_animation("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == states.TRAVEL:
		target = player.position
		$AnimationHandler.set_facing(position, target)
		continue_travel()

func continue_travel():
	if position.distance_to(target) > 100:
		linear_velocity = position.direction_to(target) * speed
	else:
		attack()

func attack():
	linear_velocity = Vector2.ZERO
	state = states.ATTACK
	$AnimationHandler.set_animation("attack")

func die():
	if state != states.DIE:
		state = states.DIE
		linear_velocity = Vector2.ZERO
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationHandler.set_animation("die")

func _on_die_animation_finished() -> void:
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	die()

func _on_attack_animation_finished() -> void:
	die()
