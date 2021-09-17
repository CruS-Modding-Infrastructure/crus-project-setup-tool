extends Spatial

var t = 0
var arm_l:Array
var claw_l:Array
var arm_r:Array
var claw_r:Array
var legs_1:Array
var legs_2:Array

func _ready():
	arm_l = [$Arm_L_1, $Arm_L_2, $Arm_L_3, $Arm_L_4, $Arm_L_5]
	claw_l = [$Claw_Left_L, $Claw_Left_R]
	arm_r = [$Arm_R_1, $Arm_R_2, $Arm_R_3, $Arm_R_4, $Arm_R_5]
	claw_r = [$Claw_Right_L, $Claw_Right_R]
	legs_1 = [$Leg_L_F, $Leg_R_B]
	legs_2 = [$Leg_R_F, $Leg_L_B]
	pass

func _physics_process(delta):
	t += 1
	for arm in range(arm_l.size()):
		arm_l[arm].transform.origin.x = 0.764 + sin((t + arm) * 0.1) * 0.05 * arm - 0.1
	for claw in claw_l:
		claw.transform.origin.x = 0.764 + sin((t + 6) * 0.1) * 0.05 * 6 - 0.1
	for arm in range(arm_r.size()):
		arm_r[arm].transform.origin.x = - 0.779 - cos((t + arm) * 0.1) * 0.05 * arm + 0.1
	for claw in claw_r:
		claw.transform.origin.x = - 0.779 - cos((t + 6) * 0.1) * 0.05 * 6 + 0.1
		claw.rotation.y = sin(t * 0.1) * 0.1
	for leg in range(legs_1.size()):
		legs_1[leg].transform.origin.z = sin(t * 0.2) * 0.3 + leg - 0.6
	for leg in range(legs_2.size()):
		legs_2[leg].transform.origin.z = cos(t * 0.2) * 0.3 + leg - 0.6



