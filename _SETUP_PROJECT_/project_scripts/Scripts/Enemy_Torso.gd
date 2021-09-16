extends KinematicBody

var soul
export var alive_head = false
export var head = false
export var poisonous = false
var headoff = false
var head_mesh
export var gibbable = true
var boresound
var bored = false
export var head_health = 40
var damage_multiplier = 1
var cancer_orb = preload("res://Cancerball.tscn")
var gibflag = false
var bloodparticles:Array = [preload("res://Entities/Particles/Blood_Particle.tscn"), preload("res://Entities/Particles/Blood_Particle3.tscn")]
onready  var deadhead = get_node("../Dead_Head")

export var type = 0
onready var head_gib = preload("res://Entities/Physics_Objects/Head_Gib.tscn")

func _ready():
	set_physics_process(false)
	set_process(false)
	head_health = 50
	soul = get_parent().get_parent()
	if self.name == "Torso":
		damage_multiplier = 1
	elif head:
		head = true
		set_physics_process(true)
		head_mesh = get_parent().get_parent().get_node_or_null("Nemesis/Armature/Skeleton/Head_Mesh")
		damage_multiplier = 2
	elif self.name == "Legs":
		damage_multiplier = 0.5
	else :
		damage_multiplier = 1
		

func cancer():
	if soul.cancer_immunity:
		return 
	if soul.armor > 0:
		return 
	for i in range(6):
		var cancerball = cancer_orb.instance()
		soul.get_parent().add_child(cancerball)
		cancerball.global_transform.origin = global_transform.origin
		cancerball.dir = cancerball.dir.rotated(Vector3.FORWARD, rand_range( - PI, PI))
		cancerball.dir = cancerball.dir.rotated(Vector3.LEFT, rand_range( - PI, PI))
		cancerball.dir = cancerball.dir.rotated(Vector3.UP, rand_range( - PI, PI))
	soul.remove_objective()
	soul.queue_free()

func _physics_process(delta):
	if bored:
		head_health -= 1
		damage(0, Vector3.ZERO, global_transform.origin, global_transform.origin)
		var new_blood_particle = bloodparticles[randi() % bloodparticles.size()].instance()
		add_child(new_blood_particle)
		new_blood_particle.global_transform.origin = global_transform.origin + Vector3.UP * 0.7
		new_blood_particle.rotation = Vector3(rand_range( - PI, PI), rand_range( - PI, PI), rand_range( - PI, PI))
		new_blood_particle.emitting = true

func set_water(a):
	if head:
		if soul.body.has_method("set_water") and not soul.body.dead:
			soul.body.set_water(a)

func add_velocity(normal, amount):
	soul.add_velocity(normal, amount)

func tranquilize(dart):
	soul.set_tranquilized(dart)

func tranq_timeout(dart):
	soul.tranq_timeout(dart)

func grapple(pos:Position3D):
	soul.grapple(pos)

func damage(damage, collision_n, collision_p, shooter_pos):
	if head and damage < 0.5 and not bored:
		return 
	soul.damage(damage * damage_multiplier, collision_n, collision_p, shooter_pos)
	if soul.armor <= 0:
		type = 0
	else :
		type = 1
	if head and not bored and damage > 0.5:
		
		head_health = - 1
	if bored and head_health > - 1:
		head_health -= 1
	if head_health < 0 and headoff == false:
		if bored:
			if is_instance_valid(boresound):
				boresound.queue_free()
		bored = false
		deadhead.already_dead()
		soul.die(damage, collision_n, collision_p)
		if not gibflag and gibbable:
			var new_head_gib = head_gib.instance()
			soul.add_child(new_head_gib)
			new_head_gib.global_transform.origin = global_transform.origin
			new_head_gib.damage(damage, collision_n, collision_p, shooter_pos)
		for child in get_children():
			child.hide()
		hide()
		if is_instance_valid(head_mesh):
			head_mesh.hide()
		$CollisionShape.disabled = true
		gibflag = true

func player_use():
	if get_collision_layer_bit(8):
		if not soul.armored and Global.husk_mode:
			soul.damage(200, Vector3.ZERO, global_transform.origin, Vector3.ZERO)
			if not poisonous:
				Global.player.add_health(1)
				Global.player.UI.notify("Flesh consumed.", Color(1, 0, 0))
			else :
				Global.player.set_toxic()
		else :
			Global.player.weapon.hold(soul.body)

func remove_weapon():
	soul.remove_weapon()

func piercing_damage(damage, collision_n, collision_p, shooter_pos):
	soul.piercing_damage(damage * damage_multiplier, collision_n, collision_p)
	if head:
		
		head_health = - 1
	if head_health < 0 and headoff == false:
		deadhead.already_dead()
		soul.die(damage, collision_n, collision_p)
		if not gibflag:
			var new_head_gib = head_gib.instance()
			soul.add_child(new_head_gib)
			new_head_gib.global_transform.origin = global_transform.origin
			new_head_gib.damage(damage, collision_n, collision_p, shooter_pos)
		for child in get_children():
			child.hide()
		hide()
		if is_instance_valid(head_mesh):
			head_mesh.hide()
		$CollisionShape.disabled = true
		gibflag = true

func already_dead():
	headoff = true

func get_head_health():
	return head_health

func get_type():
	return type;
