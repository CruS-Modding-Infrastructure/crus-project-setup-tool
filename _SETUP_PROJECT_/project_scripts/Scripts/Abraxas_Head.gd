extends KinematicBody

var type = 1
var active = false
export var health = 10
var destroyed = false

func _ready():
	pass

func damage(dmg, nrml, pos, shoot_pos):
	if not active:
		return
	health -= dmg
	if health <= 0:
		destroyed = true
		get_parent().get_node("Sphere").hide()
		get_parent().get_node("Particle").show()

func get_type():
	return type
