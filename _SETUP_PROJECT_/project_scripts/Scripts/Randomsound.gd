extends AudioStreamPlayer3D

var shot_timer:float = 0
var burst_timer:float = 0
var burst_period:float = 100
var fire_period:float = 50


func _ready():
	pass

func _physics_process(delta):
	if randi() % 400 == 1 and not $Voice.playing:
		$Voice.play()
	shot_timer += 1
	burst_timer += rand_range(0, 2)
	if burst_timer > burst_period:
		burst_timer = 0
		shot_timer = 0
		burst_period = rand_range(50, 100)
		fire_period = rand_range(1, 50)
	if shot_timer < fire_period and fmod(shot_timer, 10) == 0:
		play()
