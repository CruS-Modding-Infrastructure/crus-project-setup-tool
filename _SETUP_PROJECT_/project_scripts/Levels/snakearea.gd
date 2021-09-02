extends Area





var t1
var t2
var t3


func _ready():
	yield (get_tree(), "idle_frame")
	t1 = get_node_or_null("snake/snake/Armature/Bone/Bone001/Bone002/Bone003/Bone004/Bone005/KinematicBody")
	t2 = get_node_or_null("snake2/snake/Armature/Bone/Bone001/Bone002/Bone003/Bone004/Bone005/KinematicBody")
	t3 = get_node_or_null("snake3/snake/Armature/Bone/Bone001/Bone002/Bone003/Bone004/Bone005/KinematicBody")





func _on_Area_body_entered(body):
	if not is_instance_valid(t1):
		t1 = null
	if not is_instance_valid(t2):
		t2 = null
	if not is_instance_valid(t3):
		t3 = null
	if t1 != null:
		t1.active = true
	if t2 != null:
		t2.active = true
	if t3 != null:
		t3.active = true
