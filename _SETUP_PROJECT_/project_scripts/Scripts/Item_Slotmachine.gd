extends StaticBody





var rotation_counter = - 1
var coin = preload("res://Entities/Physics_Objects/Coin.tscn")
var junk_items:Array = [preload("res://Entities/Physics_Objects/Chest_Gib.tscn"), 
						preload("res://Entities/Physics_Objects/Head_Gib.tscn"), 
						preload("res://Entities/Props/Plant_1.tscn"), 
						preload("res://Entities/Props/Trashcan.tscn"), 
						preload("res://Entities/Props/Monitor.tscn")]


func _ready():
	pass

func _physics_process(delta):
	if rotation_counter >= 0:
		rotation_counter -= 1
		if not $Audio.playing:
			$Audio.play()
		$MeshInstance2.rotation.x += 1
	if rotation_counter == 0:
		randomize()
		if randi() % 1000 == 500:
			spawn_item()
		elif randi() % 10 == 1:
			spawn_item()
		elif randi() % 2 == 1:
			spawn_item()
		else :
			Global.player.UI.notify("You lose", Color(1, 0, 0))



func spawn_item():
	var new_coin = junk_items[randi() % junk_items.size()].instance()
	add_child(new_coin)
	new_coin.global_transform.origin = $Position3D.global_transform.origin
	new_coin.damage(20, (global_transform.origin - ($Forward_Position.global_transform.origin + Vector3(rand_range( - 0.1, 0.1), rand_range( - 0.1, 0.1), rand_range( - 0.1, 0.1)))).normalized(), global_transform.origin, Vector3.ZERO)
func player_use():
	if rotation_counter >= 0:
		return 
	if Global.money < 10:
		Global.player.UI.notify("$10 required to play", Color(1, 0, 0))
		return 
	Global.money -= 10
	rotation_counter = 50
