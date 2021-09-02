extends Area

export  var weapon_index = 1
var gun_pickup = preload("res://Entities/Objects/Gun_Pickup.tscn")
var t = 0

func _ready():
	queue_free()
	
func _physics_process(delta):
	t += 1
	rotation.y += 3 * delta
	transform.origin.y += sin(t * 1.5 * delta) * 0.003


func use():
	if Global.player.weapon.current_weapon == weapon_index:
		return 
	var last_weapon = Global.player.weapon.current_weapon
	Global.player.weapon.set_weapon(weapon_index)
	var new_gun_pickup = gun_pickup.instance()
	get_parent().add_child(new_gun_pickup)
	new_gun_pickup.global_transform.origin = global_transform.origin + Vector3(0, 0.5, 0)
	new_gun_pickup.gun.MESH[new_gun_pickup.gun.current_weapon].hide()
	new_gun_pickup.gun.MESH[weapon_index].hide()
	new_gun_pickup.gun.current_weapon = last_weapon
	new_gun_pickup.gun.MESH[last_weapon].show()
	
	queue_free()

















