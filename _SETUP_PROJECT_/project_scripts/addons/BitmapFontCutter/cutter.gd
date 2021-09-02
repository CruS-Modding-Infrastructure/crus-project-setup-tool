tool 
extends BitmapFont

var index = 0
export (Vector2) var GlyphSize = Vector2(8, 8) setget changeGlyphSize
var Separation = Vector2(0, 0) setget changeSeparation
export (Texture) var TextureToCut = null setget changeTexture
var ManualCharacterSet = false
export (int, 255) var StartChar = 32 setget changeStartChar





func changeStartChar(value):
	StartChar = value
	update()

func changeGlyphSize(value):
	GlyphSize = value
	height = GlyphSize.y
	update()
	
func changeSeparation(value):
	Separation = value
	
func changeTexture(value):
	TextureToCut = value
	index = 0
	if TextureToCut:
		update()
		pass

	
func update():
	print("cut thing")
	if TextureToCut != null:
		if GlyphSize.x > 0 and GlyphSize.y > 0:
			
			var w = TextureToCut.get_width()
			var h = TextureToCut.get_height()
			var tx = w / GlyphSize.x
			var ty = h / GlyphSize.y

			var font = self
			var i = 0

			clear()

			
			font.add_texture(TextureToCut)
			font.height = GlyphSize.y
			for y in range(ty):
				for x in range(tx):


						
						
					var region = Rect2(x * GlyphSize.x, y * GlyphSize.y, GlyphSize.x, GlyphSize.y)
					font.add_char(StartChar + i, 0, region)
						
					i += 1
			update_changes()
	pass
	



func is_empty(texture, x, y, w, h):
	var result = true
	var image = texture.get_data()
	image.lock()
	for xx in range(x, x + w):
		for yy in range(y, y + h):
			
			var pixel = image.get_pixel(xx, yy)
			if pixel.a != 0:
				return false
	
	image.unlock()
	
	return result
