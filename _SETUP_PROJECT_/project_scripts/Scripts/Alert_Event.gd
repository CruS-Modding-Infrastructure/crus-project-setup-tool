extends Area

func _ready():
	pass

func _on_Spatial_body_entered(body):
	if body == Global.player:
		for b in get_overlapping_bodies():
			if b.has_method("alert"):
				b.alert(Global.player.global_transform.origin)
