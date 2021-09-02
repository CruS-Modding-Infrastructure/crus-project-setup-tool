extends Node





onready  var consumer = $Consumer
onready  var softprod = $Softproducts
var t = 0
var activated = false

func _ready():
	
	consumer.scale.x = 0
	softprod.scale.x = 0
	
	



func _process(delta):
	t += 1
	
		
	consumer.rotation.y = lerp(consumer.rotation.y, deg2rad(360), 0.04)
	consumer.scale.x = lerp(consumer.scale.x, 1, 0.03)
	if consumer.scale.x > 0.9:
		softprod.scale.x = lerp(softprod.scale.x, 1, 0.4)
		$OmniLight.translation.x += 1
	if softprod.scale.x > 0.9:
		get_parent().get_node("MarginContainer/CenterContainer/Authority").modulate = lerp(get_parent().get_node("MarginContainer/CenterContainer/Authority").modulate, Color(1, 1, 1, 1), 0.01)
