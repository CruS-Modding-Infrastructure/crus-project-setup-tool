extends Spatial

onready  var FISH = []
export  var menu = false
export  var aquarium = false
var t = 0
var aquarium_bounds = 2.5
var tickers:Array






func _ready():
	for fish in Global.STOCKS.stocks:
		if fish.asset_type == "fish":
			tickers.append(fish.ticker)
	print(get_child_count())
	var i = 0
	for child in get_children():
		FISH.append(child)
		if aquarium:
			if Global.STOCKS.FISH_FOUND.find(tickers[i]) != - 1:
				child.show()
			i += 1
			child.transform.origin += Vector3(rand_range( - aquarium_bounds, aquarium_bounds), rand_range( - aquarium_bounds, aquarium_bounds), rand_range( - aquarium_bounds, aquarium_bounds))
	
	pass



func _process(delta):
	if aquarium:
		t += delta
		for child in get_children():
			child.transform.origin = lerp(child.transform.origin, child.transform.origin + Vector3(rand_range( - 1, 1), rand_range( - 1, 1), rand_range( - 1, 1)), delta * 0.1)
			child.look_at(Global.player.global_transform.origin + Vector3(sin(t), cos(t), sin(t)), Vector3.UP)
			child.transform.origin.x = clamp(child.transform.origin.x, - aquarium_bounds, aquarium_bounds)
			child.transform.origin.z = clamp(child.transform.origin.z, - aquarium_bounds, aquarium_bounds)
			child.transform.origin.y = clamp(child.transform.origin.y, - aquarium_bounds, aquarium_bounds)
	if menu:
		rotation.y += 2 * delta
