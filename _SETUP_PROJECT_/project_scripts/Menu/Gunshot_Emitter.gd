extends OmniLight

var shot_timer:float = 0
var burst_timer:float = 0
var burst_period:float = 100
var fire_period:float = 50

func _ready():
	pass

func _physics_process(delta):
	light_energy = lerp(light_energy, 0, 0.3)
	shot_timer += 1
	burst_timer += rand_range(0, 2)
	if burst_timer > burst_period:
		burst_timer = 0
		shot_timer = 0
		burst_period = rand_range(100, 500)
		fire_period = rand_range(1, 50)
	if shot_timer < fire_period and fmod(shot_timer, 5) == 0:
		$Sound.play()
		light_energy = 1.0
