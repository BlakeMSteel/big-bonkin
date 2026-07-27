extends CharacterBody2D

signal hit

@export var speed = 400
var screen_size
var target

enum states { IDLE, CHARGE, TRAVEL, ATTACK, DIE }
var state = states.IDLE

var charge_time = 0

func spawn(pos):
	position = pos
	show()
	$Hurtbox/CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle()
	target = Vector2(0,0)
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationHandler.set_facing(position, target)

func _physics_process(delta: float) -> void:
	recieve_player_inputs(delta)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	get_hurt()

func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	get_hurt()

func idle() -> void:
	charge_time = 0
	state = states.IDLE
	$AnimationHandler.set_animation("idle")

func die() -> void:
	state = states.DIE
	$AnimationHandler.set_animation("die")

func recieve_player_inputs(delta: float) -> void:
	if Input.is_action_pressed("left_mouse") && (state == states.IDLE || state == states.CHARGE):
		charge_up_attack(delta)
	elif !Input.is_action_pressed("left_mouse") && state == states.CHARGE:
		start_travel()
	elif state == states.TRAVEL:
		continue_travel()

func charge_up_attack(delta: float) -> void:
	state = states.CHARGE
	$AnimationHandler.set_animation("idle")
	target = get_global_mouse_position()
	charge_time += delta
	
func start_travel() -> void:
	state = states.TRAVEL
	$AnimationHandler.set_animation("run")
	speed = 200 + charge_time * 100
	continue_travel()

func continue_travel() -> void:
	if position.distance_to(target) > 10:
		velocity = position.direction_to(target) * speed
		move_and_slide()
	else:
		start_attack()
		
func start_attack() -> void:
	state = states.ATTACK
	$AnimationHandler.set_animation("attack")

func get_hurt() -> void:
	hit.emit()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	die()
	

func _on_attack_animation_finished() -> void:
	idle()

func _on_die_animation_finished() -> void:
	hide()
