extends Spatial





export (Array, String) var materials
export  var head_only = false
export  var cutscene = false
onready  var anim = $AnimationPlayer


func _ready():
	$Armature / Skeleton / Head_Mesh.material_override = load(materials[randi() % materials.size()])
	if head_only:
		return 
	$Armature / Skeleton / Torso_Mesh.material_override = load(materials[randi() % materials.size()])



func _process(delta):
	if not cutscene:
		return 
	translate(Vector3.FORWARD * delta)
	anim.play("Walk")
