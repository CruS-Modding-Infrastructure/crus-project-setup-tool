extends Control

func _ready():
	pass
func printc(line):
	$Text.text = "~" + str(line) + "\n" + $Text.text
