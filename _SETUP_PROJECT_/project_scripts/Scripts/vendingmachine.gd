extends StaticBody





var type = 1
var items = [preload("res://Entities/Physics_Objects/can1.tscn"), preload("res://Entities/Physics_Objects/chips1.tscn")]
var item_names = ["Hungry Human Soda", "Super Crunchers"]
export  var max_items = 10
var item_count = 0
var broken = false


func _ready():
	pass

func activation(violence):
	if broken:
		return 
	if item_count < max_items:
		item_count += 1
		var rand = randi() % items.size()
		var new_item = items[rand].instance()
		add_child(new_item)
		new_item.global_transform.origin = $Position3D.global_transform.origin
		new_item.damage(10, (global_transform.origin - $Position3D.global_transform.origin).normalized(), global_transform.origin, global_transform.origin)
		if not violence:
			Global.player.UI.notify("Purchased " + str(item_names[rand]) + " for " + "$10", Color(0, 1, 1))



func player_use():
	if Global.money < 10:
		Global.player.UI.notify("You don't have enough money.", Color(1, 0, 0))
		return 
	if broken:
		Global.player.UI.notify("It's broken.", Color(1, 0, 0))
		return 
	if item_count >= max_items:
		Global.player.UI.notify("It's empty.", Color(1, 0, 0))
		return 
	if Global.money >= 10:
		Global.money -= 10
		
		activation(false)
func damage(a, n, p, sp):
	if broken:
		return 
	if randi() % 3 == 0:
		broken = true
		$AudioStreamPlayer3D.playing = false
	activation(true)
func get_type():
	return type
