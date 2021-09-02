extends Area

var lifetime = 200
var t = 0
var player_fire = false



onready  var parent = get_parent()


func _ready():
	pass



func _physics_process(delta):
	t += 1
	if lifetime < t:
		queue_free()
	if fmod(t, 25) != 0:
		return 
	if "soul" in parent and not "random_line" in parent:
		if parent.soul.pain_sfx[0].stream != parent.soul.firesound:
			parent.soul.pain_sfx[0].stream = parent.soul.firesound
		parent.soul.damage(20.6, Vector3.ZERO, global_transform.origin, global_transform.origin)
	elif "random_line" in parent:
		if not "pain_sfx" in parent.get_parent():
			return 
		if parent.get_parent().pain_sfx[0].stream != parent.get_parent().firesound:
			parent.get_parent().pain_sfx[0].stream = parent.get_parent().firesound
		parent.get_parent().damage(5, Vector3.ZERO, global_transform.origin, global_transform.origin)

	else :
		if parent.has_method("damage"):
			parent.damage(5, Vector3.ZERO, global_transform.origin, global_transform.origin)


func _on_Area_body_entered(body):
	if body != parent:
		
			var new_fire_child = self.duplicate()
		
			if "soul" in body:
				if body.soul.on_fire:
					return 
				body.soul.on_fire = true
				body.soul.body.add_child(new_fire_child)
				new_fire_child.scale.y = 2.0
				new_fire_child.global_transform.origin = body.soul.body.global_transform.origin - Vector3.UP * 0.5







			elif body == Global.player and not player_fire:
				body.add_child(new_fire_child)
				player_fire = true
				new_fire_child.player_fire = true
				new_fire_child.scale.y = 2.0
				new_fire_child.global_transform.origin = body.global_transform.origin - Vector3.UP * 0.5

func set_water(value):
	queue_free()
