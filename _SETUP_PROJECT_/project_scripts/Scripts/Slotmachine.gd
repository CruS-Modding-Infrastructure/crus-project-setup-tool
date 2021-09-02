extends StaticBody





var rotation_counter = - 1
var coin = preload("res://Entities/Physics_Objects/Coin.tscn")


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
			Global.player.UI.notify("You win $1000!", Color(1, 0, 1))
			spawn_coins(100)
		elif randi() % 10 == 1:
			Global.player.UI.notify("You win $100!", Color(0, 1, 0))
			spawn_coins(10)
		elif randi() % 2 == 1:
			Global.player.UI.notify("You win $10!", Color(0, 1, 0))
			spawn_coins(1)
		else :
			Global.player.UI.notify("You lose", Color(1, 0, 0))



func spawn_coins(amount):
	for i in range(amount):
		var new_coin = coin.instance()
		add_child(new_coin)
		new_coin.global_transform.origin = $Position3D.global_transform.origin
		new_coin.damage(20, (global_transform.origin - ($Forward_Position.global_transform.origin + Vector3(rand_range( - 0.1, 0.1), rand_range( - 0.1, 0.1), rand_range( - 0.1, 0.1)))).normalized(), global_transform.origin, Vector3.ZERO)
		yield (get_tree(), "idle_frame")
		yield (get_tree(), "idle_frame")
func player_use():
	if rotation_counter >= 0:
		return 
	if Global.money < 10:
		Global.player.UI.notify("$10 required to play", Color(1, 1, 1))
		return 
	Global.money -= 10
	rotation_counter = 50
