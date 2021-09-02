extends Spatial

var bullet = preload("res://Entities/Bullets/Acid_Ball.tscn")
var time = 0
var reloading = false
var fire_counter = 0
var max_fire = 50
var body
var soul
var rothelp
var has_anim_attack = false
func _ready():
	
	body = get_parent().get_parent()
	soul = get_parent().get_parent().get_parent()
	rothelp = get_parent()
	yield (get_tree(), "idle_frame")
	has_anim_attack = body.anim_player.has_animation("Attack")

func _physics_process(delta):
	time += delta * 10
	

func AI_shoot():
	
		if has_anim_attack:
			body.anim_player.play("Attack", - 1, 1)
		var new_bullet = bullet.instance()
		soul.add_child(new_bullet)
		new_bullet.global_transform.origin = global_transform.origin
		new_bullet.set_velocity(10, body.transform.basis * rothelp.transform.basis)
