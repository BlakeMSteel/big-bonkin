extends Node

enum MOB_TYPE { NONE, FIRE_MAGE, MOUNTED_SHAMAN }
@export var mob_type = MOB_TYPE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getDetailsFor(mob_type):
	pass
