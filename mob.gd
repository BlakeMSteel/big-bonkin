extends RigidBody2D

enum states { IDLE, TRAVEL, ATTACK, DIE }

@export var speed = 100
@export var attack_aoe: PackedScene

var target = position
var velocity
var player: CharacterBody2D
var state = states.IDLE
var attack_dimensions = Vector2(6.5, 4.55)
var attack_position = Vector2(0,20)
var current_attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AttackPreview.set_scale(attack_dimensions)
	$AttackPreview.position = attack_position
	start_travel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == states.TRAVEL:
		target = player.position
		$AnimationHandler.set_facing(position, target)
		continue_travel()

func start_travel():
	state = states.TRAVEL
	$AnimationHandler.set_animation("walk")

func continue_travel():
	linear_velocity = position.direction_to(target) * speed

func attack():
	linear_velocity = Vector2.ZERO
	state = states.ATTACK
	$AnimationHandler.set_animation("attack_windup")

func _on_attack_animation_finished() -> void:
	var attack_instance = attack_aoe.instantiate()
	attack_instance.set_scale(attack_dimensions)
	attack_instance.position = attack_position
	add_child(attack_instance)
	current_attack = attack_instance
	$AnimationHandler.set_animation("post_attack")

func _on_post_attack_animation_finished() -> void:
	remove_child(current_attack)
	start_travel()

func die():
	if state != states.DIE:
		state = states.DIE
		linear_velocity = Vector2.ZERO
		$AnimationHandler.set_animation("die")

func _on_die_animation_finished() -> void:
	queue_free()

func _on_attack_preview_area_entered(area: Area2D) -> void:
	attack()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	die()
