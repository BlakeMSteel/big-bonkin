extends RigidBody2D

enum states { IDLE, TRAVEL, ATTACK, DIE }

@export var speed = 100
@export var attack_aoe: PackedScene

var target = position
var velocity
var player: CharacterBody2D
var state = states.IDLE
var attack_dimensions = Vector2(15, 12)
var current_attack

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
	$AnimationHandler.set_animation("attack_windup")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	die()

func _on_attack_animation_finished() -> void:
	var attack = attack_aoe.instantiate()
	attack.set_scale(attack_dimensions)
	add_child(attack)
	current_attack = attack
	$AnimationHandler.set_animation("post_attack")

func _on_post_attack_animation_finished() -> void:
	remove_child(current_attack)
	state = states.TRAVEL

func die():
	if state != states.DIE:
		state = states.DIE
		linear_velocity = Vector2.ZERO
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationHandler.set_animation("die")

func _on_die_animation_finished() -> void:
	queue_free()
