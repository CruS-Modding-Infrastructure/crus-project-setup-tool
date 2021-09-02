extends Control
enum {START_MENU, LEVEL_MENU, LEVEL_END_MENU, SETTINGS_MENU, IN_GAME_MENU}
var MAIN_MENU_SCENE = "res://Menu/Main_Menu.tscn"
onready  var START_BUTTON = $Menu / VBoxContainer / HBoxContainer / VBoxContainer / VBoxContainer / Start_Button
onready  var QUIT_BUTTON = $Menu / VBoxContainer / HBoxContainer / VBoxContainer / VBoxContainer / Quit_Button
onready  var MENUS = [$Menu, $Level_Menu, $Level_End_Menu, $Settings, $In_Game_Menu]
onready  var GLOBAL = $"/root/Global"
onready  var LEVEL_BUTTONS = []
onready  var WEAPON_BUTTON_ONE = $Level_Menu / VBoxContainer2 / Current_Weapons / WEAPON1
onready  var WEAPON_BUTTON_TWO = $Level_Menu / VBoxContainer2 / Current_Weapons / WEAPON2

onready  var PISTOL = $Level_Menu / VBoxContainer2 / Weapon_Select / PISTOL
onready  var SMG = $Level_Menu / VBoxContainer2 / Weapon_Select / SMG
onready  var SHOTGUN = $Level_Menu / VBoxContainer2 / Weapon_Select / SHOTGUN
onready  var ROCKET_LAUNCHER = $Level_Menu / VBoxContainer2 / Weapon_Select / ROCKET_LAUNCHER
onready  var WEAPON_BUTTONS = [PISTOL, SMG, SHOTGUN, ROCKET_LAUNCHER]
onready  var WEAPON_NAMES = ["PISTOL", "SMG", "SHOTGUN", "ROCKET LAUNCHER"]

var current_menu = START_MENU
export  var in_game = false
var weapon_select = 0
var weapon_one = 0
var weapon_two = 1

var goto_level


func _ready():
	$Level_Menu / VBoxContainer2 / Weapon_Select / SMG / SMG_MESH.texture = $SMG_Viewport / Viewport.get_texture()
	$Level_Menu / VBoxContainer2 / Weapon_Select / SMG / SMG_MESH.rect_size = $Level_Menu / VBoxContainer2 / Weapon_Select / SHOTGUN.rect_size
	$Level_Menu / VBoxContainer2 / Weapon_Select / SHOTGUN / SHOTGUN_MESH.texture = $Shotgun_Viewport / Viewport.get_texture()
	$Level_Menu / VBoxContainer2 / Weapon_Select / SHOTGUN / SHOTGUN_MESH.rect_size = $Level_Menu / VBoxContainer2 / Weapon_Select / SHOTGUN.rect_size
	$Level_Menu / VBoxContainer2 / Weapon_Select / ROCKET_LAUNCHER / ROCKET_LAUNCHER_MESH.texture = $RL_Viewport / Viewport.get_texture()
	$Level_Menu / VBoxContainer2 / Weapon_Select / ROCKET_LAUNCHER / ROCKET_LAUNCHER_MESH.rect_size = $Level_Menu / VBoxContainer2 / Weapon_Select / ROCKET_LAUNCHER.rect_size
	if in_game:
		get_tree().paused = false
		visible = false
		current_menu = START_MENU
	for level in GLOBAL.LEVELS:
		var level_button = START_BUTTON.duplicate()
		$Level_Menu / VBoxContainer2 / HBoxContainer / Level_VBox.add_child(level_button)
		level_button.text = level.replace("res://Levels/", "")
		level_button.text = level_button.text.replace(".tscn", "")
		level_button.connect("pressed", self, "_on_Level_pressed", [level])
		level_button.hide()
		LEVEL_BUTTONS.append(level_button)
	for button in range(GLOBAL.LEVELS_UNLOCKED + 1):
		LEVEL_BUTTONS[button].show()
	
	WEAPON_BUTTON_ONE.connect("pressed", self, "_on_Weapon_pressed", [WEAPON_BUTTON_ONE.name])
	WEAPON_BUTTON_TWO.connect("pressed", self, "_on_Weapon_pressed", [WEAPON_BUTTON_TWO.name])
	WEAPON_BUTTON_ONE.text = WEAPON_NAMES[weapon_one]
	WEAPON_BUTTON_TWO.text = WEAPON_NAMES[weapon_two]
	PISTOL.connect("pressed", self, "_on_Weapon_selected", [0])
	SMG.connect("pressed", self, "_on_Weapon_selected", [1])
	SHOTGUN.connect("pressed", self, "_on_Weapon_selected", [2])
	ROCKET_LAUNCHER.connect("pressed", self, "_on_Weapon_selected", [3])
	
	$Settings / HBoxContainer / Tabs / Control / HSlider.value = GLOBAL.mouse_sensitivity * 100
	$Settings / HBoxContainer / Tabs / Volume / Master_Volume.value = GLOBAL.master_volume + 100
	$Settings / HBoxContainer / Tabs / Volume / Music_Volume.value = GLOBAL.music_volume + 100
	$Settings / HBoxContainer / Tabs / Control / FOV_Slider.value = GLOBAL.FOV
	goto_level = GLOBAL.LEVELS[GLOBAL.CURRENT_LEVEL]
	update_level_info()
	

func _on_Weapon_pressed(button):
	$SFX / Select.play()
	$Level_Menu / VBoxContainer2 / Current_Weapons.hide()
	$Level_Menu / VBoxContainer2 / Weapon_Select.show()
	if button == "WEAPON1":
		weapon_select = 1
	if button == "WEAPON2":
		weapon_select = 2
		
	for button in range(WEAPON_BUTTONS.size()):
		if button == weapon_one or button == weapon_two:
			WEAPON_BUTTONS[button].disabled = true
		else :
			WEAPON_BUTTONS[button].disabled = false
		
		if GLOBAL.WEAPONS_UNLOCKED[button] == false:
			WEAPON_BUTTONS[button].disabled = true
			WEAPON_BUTTONS[button].text = "???"
		else :
			WEAPON_BUTTONS[button].text = ""

func _on_Weapon_selected(weapon_index):
	$SFX / Select.play()
	$Level_Menu / VBoxContainer2 / Weapon_Select.hide()
	$Level_Menu / VBoxContainer2 / Current_Weapons.show()
	if weapon_select == 1:
		weapon_one = weapon_index
		WEAPON_BUTTON_ONE.text = WEAPON_NAMES[weapon_index]
	if weapon_select == 2:
		weapon_two = weapon_index
		WEAPON_BUTTON_TWO.text = WEAPON_NAMES[weapon_index]
	weapon_select = 0
	
	for weapon in range(GLOBAL.CURRENT_WEAPONS.size()):
		if weapon == weapon_one or weapon == weapon_two and GLOBAL.WEAPONS_UNLOCKED[weapon]:
			GLOBAL.CURRENT_WEAPONS[weapon] = true
		else :
			GLOBAL.CURRENT_WEAPONS[weapon] = false

func _on_Level_pressed(level):
	$SFX / Select.play()
	goto_level = level
	GLOBAL.CURRENT_LEVEL = GLOBAL.LEVELS.find(level, 0)
	update_level_info()
	
	

func update_level_info()->void :
	var meta_file = File.new()
	if not meta_file.file_exists(GLOBAL.LEVEL_META[GLOBAL.CURRENT_LEVEL]):
		return 
	meta_file.open(GLOBAL.LEVEL_META[GLOBAL.CURRENT_LEVEL], File.READ)
	var parsed_level_meta:Dictionary = {}
	parsed_level_meta = parse_json(meta_file.get_as_text())
	var level_name = parsed_level_meta.get("name")
	var objectives = parsed_level_meta.get("objectives")
	var description = parsed_level_meta.get("description")
	var level_info = $Level_Menu / VBoxContainer2 / HBoxContainer / VBoxContainer / ScrollContainer / Level_Info
	$Level_Menu / VBoxContainer2 / HBoxContainer / VBoxContainer / Level_Name.text = level_name
	level_info.text = ""
	$Level_Menu / VBoxContainer2 / HBoxContainer / VBoxContainerRight / Objective_Label.text = ""
	for objective in objectives:
		$Level_Menu / VBoxContainer2 / HBoxContainer / VBoxContainerRight / Objective_Label.text += objective + "\n"
	level_info.text += description
	var level_time = $Level_Menu / VBoxContainer2 / HBoxContainer / VBoxContainer / Record_Container / Record_Value

	if Global.LEVEL_TIMES[Global.CURRENT_LEVEL] != null:
		level_time.text = Global.LEVEL_TIMES[Global.CURRENT_LEVEL]
	for button in LEVEL_BUTTONS:
		if button == LEVEL_BUTTONS[GLOBAL.CURRENT_LEVEL]:
			button.disabled = true
		else :
			button.disabled = false
	meta_file.close()
	$Level_Menu / VBoxContainer2 / HBoxContainer / VBoxContainerRight / PanelContainer / Level_Image.texture = GLOBAL.LEVEL_IMAGES[GLOBAL.CURRENT_LEVEL]

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			if current_menu == LEVEL_MENU or current_menu == SETTINGS_MENU:
				if weapon_select == 0:
					if not in_game:
						goto_menu(START_MENU)
					else :
						goto_menu(IN_GAME_MENU)
				else :
					$Level_Menu / VBoxContainer2 / Weapon_Select.hide()
					$Level_Menu / VBoxContainer2 / Current_Weapons.show()



				return 
			if in_game and (current_menu == IN_GAME_MENU or not visible):
				get_tree().paused = not get_tree().paused
				visible = not visible
				if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				else :
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			

func _on_Start_Button_pressed():
	$SFX / Select.play()
	goto_menu(LEVEL_MENU)

func _on_Quit_Button_pressed():
	$SFX / Select.play()
	get_tree().quit()

func goto_menu(menu):
	for i_menu in MENUS:
		if i_menu == MENUS[menu]:
			current_menu = menu
			MENUS[menu].show()
		else :
			i_menu.hide()


func _on_Level_Select_Button_pressed():
	$SFX / Select.play()
	GLOBAL.goto_scene(MAIN_MENU_SCENE)
	in_game = false
	goto_menu(LEVEL_MENU)

func _on_Next_Mission_pressed():
	$SFX / Select.play()
	goto_menu(START_MENU)
	GLOBAL.goto_scene(GLOBAL.LEVELS[0])
	get_tree().paused = false
	visible = false



func _on_BACK_pressed():
	$SFX / Select.play()
	$Level_Menu / VBoxContainer2 / Weapon_Select.hide()
	$Level_Menu / VBoxContainer2 / Current_Weapons.show()
	weapon_select = 0


func _on_Mouse_Sensitivity_value_changed(value):
	GLOBAL.mouse_sensitivity = value * 0.01
	$Settings / HBoxContainer / Tabs / Control / Sensitivity_Label.text = str(value)


func _on_Master_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value - 100)
	GLOBAL.master_volume = value - 100
	if not $SFX / Sound_Test.playing:
		$SFX / Sound_Test.play()

func _on_Music_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value - 100)
	GLOBAL.music_volume = value - 100

func _on_Settings_Button_pressed():
	$SFX / Select.play()
	goto_menu(SETTINGS_MENU)


func _on_Resume_Game_pressed():
	$SFX / Select.play()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false


func _on_Exit_To_Menu_pressed():
	$SFX / Select.play()
	GLOBAL.goto_scene(MAIN_MENU_SCENE)
	in_game = false
	goto_menu(START_MENU)


func _on_Level_Select_pressed():
	$SFX / Select.play()
	GLOBAL.goto_scene(MAIN_MENU_SCENE)
	in_game = false
	goto_menu(LEVEL_MENU)


func _on_BEGIN_pressed():
	$SFX / Select.play()
	for weapon in range(GLOBAL.CURRENT_WEAPONS.size()):
		if weapon == weapon_one or weapon == weapon_two and GLOBAL.WEAPONS_UNLOCKED[weapon]:
			GLOBAL.CURRENT_WEAPONS[weapon] = true
		else :
			GLOBAL.CURRENT_WEAPONS[weapon] = false
	in_game = true
	get_tree().paused = false
	visible = false
	goto_menu(IN_GAME_MENU)
	GLOBAL.level_start()
	GLOBAL.goto_scene(goto_level)



func _on_Button_mouse_entered():
	$SFX / Hover.play()


func _on_Button_focus_entered():
	$SFX / Hover.play()


func _on_FOV_value_changed(value):
	Global.FOV = value
	Global.player.player_view.fov = value
