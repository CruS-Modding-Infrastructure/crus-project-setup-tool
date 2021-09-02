extends HBoxContainer





var EQUIPMENT_BUTTONS:Array
enum {HEAD, TORSO, LEG, ARM}
var IMPLANTS
var confirmed = false
var cancel = false
var hover_info

func _ready():
	yield (get_tree(), "idle_frame")
	$ConfirmationDialog.get_cancel().connect("pressed", self, "_on_Cancel_Pressed")
	$TextureRect / Money.text = "$" + str(Global.money)
	$TextureRect / Arm_Button.connect("pressed", self, "_slot_button_pressed", [ARM])
	$TextureRect / Arm_Button.connect("mouse_entered", self, "_slot_button_entered", [ARM])
	$TextureRect / Leg_Button.connect("pressed", self, "_slot_button_pressed", [LEG])
	$TextureRect / Leg_Button.connect("mouse_entered", self, "_slot_button_entered", [LEG])
	$TextureRect / Head_Button.connect("pressed", self, "_slot_button_pressed", [HEAD])
	$TextureRect / Head_Button.connect("mouse_entered", self, "_slot_button_entered", [HEAD])
	$TextureRect / Torso_Button.connect("pressed", self, "_slot_button_pressed", [TORSO])
	$TextureRect / Torso_Button.connect("mouse_entered", self, "_slot_button_entered", [TORSO])
	hover_info = get_parent().get_parent().get_node("Hover_Panel/Hover_Info")
	IMPLANTS = Global.implants.IMPLANTS
	for b in range(64):
		var new_button = TextureButton.new()
		$Equip_Grid.add_child(new_button)
		if b < IMPLANTS.size():
			new_button.name = IMPLANTS[b].i_name
			new_button.texture_normal = IMPLANTS[b].texture
			if Global.implants.purchased_implants.find(IMPLANTS[b].i_name) == - 1:
				new_button.modulate = Color(1, 0, 0)
				if IMPLANTS[b].hidden:
					new_button.modulate = Color(1, 1, 1)
					new_button.texture_normal = load("res://Textures/Menu/mystery.png")
		else :
			new_button.name = "n/a"
			new_button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
		new_button.rect_size = Vector2(64, 64)
		new_button.expand = true
		
		new_button.connect("pressed", self, "_on_implant_pressed", [b])
		new_button.connect("mouse_entered", self, "_on_mouse_entered", [b])
		new_button.connect("mouse_exited", self, "_on_mouse_exited", [b])
		new_button.size_flags_horizontal = SIZE_EXPAND_FILL
		new_button.size_flags_vertical = SIZE_EXPAND_FILL
		new_button.stretch_mode = TextureButton.STRETCH_SCALE
		EQUIPMENT_BUTTONS.append(new_button)

func clear_equips():
	Global.implants.head_implant = Global.implants.empty_implant
	Global.implants.leg_implant = Global.implants.empty_implant
	Global.implants.arm_implant = Global.implants.empty_implant
	Global.implants.torso_implant = Global.implants.empty_implant
	$TextureRect / Head_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
	$TextureRect / Torso_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
	$TextureRect / Leg_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
	$TextureRect / Arm_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")

func _slot_button_pressed(type):
	match type:
		HEAD:
			$Unequip.play()
			hover_info.get_parent().hide()
			EQUIPMENT_BUTTONS[IMPLANTS.find(Global.implants.head_implant)].modulate = Color(1, 1, 1, 1)
			Global.implants.head_implant = Global.implants.empty_implant
			$TextureRect / Head_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
			
		TORSO:
			$Unequip.play()
			EQUIPMENT_BUTTONS[IMPLANTS.find(Global.implants.torso_implant)].modulate = Color(1, 1, 1, 1)
			Global.implants.torso_implant = Global.implants.empty_implant
			$TextureRect / Torso_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
		LEG:
			$Unequip.play()
			EQUIPMENT_BUTTONS[IMPLANTS.find(Global.implants.leg_implant)].modulate = Color(1, 1, 1, 1)
			Global.implants.leg_implant = Global.implants.empty_implant
			$TextureRect / Leg_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")
		ARM:
			$Unequip.play()
			EQUIPMENT_BUTTONS[IMPLANTS.find(Global.implants.arm_implant)].modulate = Color(1, 1, 1, 1)
			Global.implants.arm_implant = Global.implants.empty_implant
			$TextureRect / Arm_Button.texture_normal = load("res://Textures/Menu/Empty_Slot.png")

func _slot_button_entered(type):
	match type:
		HEAD:
			if Global.implants.head_implant != Global.implants.empty_implant:
				hover_info.get_parent().show()
				_on_mouse_entered(IMPLANTS.find(Global.implants.head_implant))
		TORSO:
			if Global.implants.torso_implant != Global.implants.empty_implant:
				hover_info.get_parent().show()
				_on_mouse_entered(IMPLANTS.find(Global.implants.torso_implant))
		ARM:
			if Global.implants.arm_implant != Global.implants.empty_implant:
				hover_info.get_parent().show()
				_on_mouse_entered(IMPLANTS.find(Global.implants.arm_implant))
		LEG:
			if Global.implants.leg_implant != Global.implants.empty_implant:
				hover_info.get_parent().show()
				_on_mouse_entered(IMPLANTS.find(Global.implants.leg_implant))
func update_buttons():
	for i in range(IMPLANTS.size()):
		if IMPLANTS[i].hidden and Global.implants.purchased_implants.find(IMPLANTS[i].i_name) != - 1:
			EQUIPMENT_BUTTONS[i].texture_normal = IMPLANTS[i].texture
		elif Global.implants.purchased_implants.find(IMPLANTS[i].i_name) == - 1:
			EQUIPMENT_BUTTONS[i].modulate = Color(1, 0, 0)
		if Global.implants.purchased_implants.find(IMPLANTS[i].i_name) != - 1 and EQUIPMENT_BUTTONS[i].modulate != Color(0.5, 0.5, 0.5):
			EQUIPMENT_BUTTONS[i].modulate = Color(1, 1, 1)
func _on_mouse_entered(i):
	if i < IMPLANTS.size():
		if IMPLANTS[i].hidden and Global.implants.purchased_implants.find(IMPLANTS[i].i_name) == - 1:
			hover_info.get_node("Image").show()
			hover_info.get_parent().raise()
			hover_info.get_node("Name").text = "???"
			hover_info.get_node("Hint").text = "Somewhere in this world something is waiting for you."
			hover_info.get_node("Image").texture = load("res://Textures/Menu/mystery.png")
			hover_info.get_parent().show()
			return 
		hover_info.get_node("Image").show()
		hover_info.get_parent().raise()
		hover_info.get_node("Name").text = IMPLANTS[i].i_name
		hover_info.get_node("Image").texture = IMPLANTS[i].texture
		var infotext = IMPLANTS[i].explanation
		hover_info.get_node("Hint").text = ""
		if IMPLANTS[i].head:
			hover_info.get_node("Hint").text += "Slot: Head\n"
		if IMPLANTS[i].torso:
			hover_info.get_node("Hint").text += "Slot: Chest\n"
		if IMPLANTS[i].legs:
			hover_info.get_node("Hint").text += "Slot: Legs\n"
		if IMPLANTS[i].arms:
			hover_info.get_node("Hint").text += "Slot: Arms\n"
		if Global.implants.purchased_implants.find(IMPLANTS[i].i_name) == - 1:
			hover_info.get_node("Hint").text += "$" + str(IMPLANTS[i].price) + "\n"
		hover_info.get_node("Hint").show()
		hover_info.get_node("Hint").text += infotext + "\n"
		if IMPLANTS[i].armor != 1:
			hover_info.get_node("Hint").text += "Armor: " + str(100 - IMPLANTS[i].armor * 100, "%") + "\n"
		if IMPLANTS[i].speed_bonus != 0:
			hover_info.get_node("Hint").text += "Speed: " + str(IMPLANTS[i].speed_bonus) + "\n"
		if IMPLANTS[i].jump_bonus != 0:
			hover_info.get_node("Hint").text += "Jump bonus: " + str(IMPLANTS[i].jump_bonus) + "\n"
		hover_info.get_parent().show()
func _on_mouse_exited(i):
	hover_info.get_node("Image").hide()
	hover_info.get_parent().hide()

func _on_implant_pressed(i):
	if i < IMPLANTS.size():
		if IMPLANTS[i].hidden and Global.implants.purchased_implants.find(IMPLANTS[i].i_name) == - 1:
			return 
		if Global.implants.purchased_implants.find(IMPLANTS[i].i_name) == - 1:
			cancel = false
			if Global.money >= IMPLANTS[i].price:
				$ConfirmationDialog.popup(Rect2(get_global_mouse_position(), Vector2(256, 128)))
				$ConfirmationDialog.dialog_text = "Do you want to purchase " + IMPLANTS[i].i_name + " for $" + str(IMPLANTS[i].price) + "?"
				while confirmed == false and cancel == false:
					yield (get_tree(), "idle_frame")
				confirmed = false
				if cancel == true:
					cancel = false
					return 
				cancel = false
				var m = Global.money
				Global.money -= IMPLANTS[i].price
				if Global.money < 0:
					Global.money = m
					return 
				if IMPLANTS[i].i_name == "House":
					Global.BONUS_UNLOCK.append("House")
				EQUIPMENT_BUTTONS[i].modulate = Color(1, 1, 1)
				$TextureRect / Money.text = str("$", Global.money)
				Global.implants.purchased_implants.append(IMPLANTS[i].i_name)
				Global.save_game()
			return 
		
		$Equip.play()
		if IMPLANTS[i].head:
			if Global.implants.head_implant != Global.implants.empty_implant:
				_slot_button_pressed(HEAD)
			Global.implants.head_implant = IMPLANTS[i]
			EQUIPMENT_BUTTONS[i].modulate = Color(0.5, 0.5, 0.5)
			$TextureRect / Head_Button.texture_normal = IMPLANTS[i].texture
		elif IMPLANTS[i].torso:
			if Global.implants.torso_implant != Global.implants.empty_implant:
				_slot_button_pressed(TORSO)
			Global.implants.torso_implant = IMPLANTS[i]
			EQUIPMENT_BUTTONS[i].modulate = Color(0.5, 0.5, 0.5)
			$TextureRect / Torso_Button.texture_normal = IMPLANTS[i].texture
		elif IMPLANTS[i].legs:
			if Global.implants.leg_implant != Global.implants.empty_implant:
				_slot_button_pressed(LEG)
			Global.implants.leg_implant = IMPLANTS[i]
			EQUIPMENT_BUTTONS[i].modulate = Color(0.5, 0.5, 0.5)
			$TextureRect / Leg_Button.texture_normal = IMPLANTS[i].texture
		elif IMPLANTS[i].arms:
			if Global.implants.arm_implant != Global.implants.empty_implant:
				_slot_button_pressed(ARM)
			Global.implants.arm_implant = IMPLANTS[i]
			EQUIPMENT_BUTTONS[i].modulate = Color(0.5, 0.5, 0.5)
			$TextureRect / Arm_Button.texture_normal = IMPLANTS[i].texture

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		cancel = true
		


func _on_ConfirmationDialog_confirmed():
	confirmed = true
func _on_Cancel_Pressed():
	cancel = true
	
