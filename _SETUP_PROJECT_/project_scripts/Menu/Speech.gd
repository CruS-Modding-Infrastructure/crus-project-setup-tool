extends RichTextLabel


var speech_break = false
var mouse_hover = false
var speech_flag = false
var alpha_sound = [preload("res://Sfx/Voice/A.wav"), 
preload("res://Sfx/Voice/B.wav"), 
preload("res://Sfx/Voice/C.wav"), 
preload("res://Sfx/Voice/D.wav"), 
preload("res://Sfx/Voice/E.wav"), 
preload("res://Sfx/Voice/F.wav"), 
preload("res://Sfx/Voice/G.wav"), 
preload("res://Sfx/Voice/H.wav"), 
preload("res://Sfx/Voice/I.wav"), 
preload("res://Sfx/Voice/J.wav"), 
preload("res://Sfx/Voice/K.wav"), 
preload("res://Sfx/Voice/L.wav"), 
preload("res://Sfx/Voice/M.wav"), 
preload("res://Sfx/Voice/N.wav"), 
preload("res://Sfx/Voice/O.wav"), 
preload("res://Sfx/Voice/P.wav"), 
preload("res://Sfx/Voice/Q.wav"), 
preload("res://Sfx/Voice/R.wav"), 
preload("res://Sfx/Voice/S.wav"), 
preload("res://Sfx/Voice/T.wav"), 
preload("res://Sfx/Voice/U.wav"), 
preload("res://Sfx/Voice/V.wav"), 
preload("res://Sfx/Voice/W.wav"), 
preload("res://Sfx/Voice/X.wav"), 
preload("res://Sfx/Voice/Y.wav"), 
preload("res://Sfx/Voice/Z.wav")]
signal character_speak
func _ready():
	
		
	
		
	
	pass
	

		

func list_files_in_directory(path:String, file_type:String)->Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension() == file_type:

			files.append(path + "/" + file)
	return files

func skip():
	visible_characters = get_total_character_count()

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("mouse_1") and mouse_hover:
			skip()
			speech_break = true

func speech():
	speech_break = true
	
	scroll_to_line(0)
	visible_characters = 0
	for i in range(1):
		yield (get_tree(), "physics_frame")
	speech_break = false
	for c in text:
		while get_tree().paused:
			yield (get_tree(), "physics_frame")
		if speech_break:
			return 
		if Global.high_performance:
			visible_characters += 2
		else :
			visible_characters += 1
		if c.ord_at(0) >= 97 and c.ord_at(0) <= 122:
			$AudioStreamPlayer.stream = alpha_sound[c.ord_at(0) - 97]
			emit_signal("character_speak")
			$AudioStreamPlayer.play()
		if c.ord_at(0) >= 65 and c.ord_at(0) <= 90:
			emit_signal("character_speak")
			$AudioStreamPlayer.stream = alpha_sound[c.ord_at(0) - 65]
			$AudioStreamPlayer.play()
		if c.ord_at(0) == 32:
			for i in range(1):
				if speech_break:
					return 
				yield (get_tree(), "physics_frame")
		
		for i in range(1):
			if speech_break:
				return 
			yield (get_tree(), "physics_frame")


func _on_Description_mouse_entered():
	mouse_hover = true

	set("custom_colors/default_color", Color(0, 1, 0, 1))

func _on_Description_mouse_exited():
	set("custom_colors/default_color", Color(1, 0, 0, 1))
	mouse_hover = false
