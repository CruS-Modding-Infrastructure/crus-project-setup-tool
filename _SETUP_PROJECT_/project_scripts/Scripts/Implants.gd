extends Node





var IMPLANTS:Array
var purchased_implants:Array
var head_implant:Implant
var torso_implant:Implant
var leg_implant:Implant
var arm_implant:Implant
var empty_implant:Implant

class Implant:
	var head:bool = false
	var torso:bool = false
	var legs:bool = false
	var arms:bool = false
	var price:int = 0
	var armor:float = 1
	var ricochet:bool = false
	var grav:bool = false
	var orbsuit:bool = false
	var speed_bonus:float = 0
	var ammo_bonus:int = 0
	var ski:bool = false
	var market_enhancer:bool = false
	var helmet:bool = false
	var nightvision:bool = false
	var jump_bonus:float = 0
	var terror = false
	var double_jump:float = 0
	var triple_jump:bool = false
	var jetpack:bool = false
	var throw_bonus:float = 0
	var zoom_bonus:float = 1
	var shrink:bool = false
	var slowfall:bool = false
	var healing:float = 0
	var sensor:bool = false
	var instadeath:bool = false
	var stealth:bool = false
	var climb:bool = false
	var explosive_shield:bool = false
	var nightmare:bool = false
	var holy:bool = false
	var fishing_bonus:bool = false
	var grapple:bool = false
	var radio:bool = false
	var cursed_torch:bool = false
	var regen_ammo:bool = false
	var chemical_shield:bool = false
	var bouncy:bool = false
	var thrust:bool = false
	var toxic_shield:bool = false
	var skullgun:bool = false
	var he_grenade:bool = false
	var camo:float = 0
	var kick_improvement = false
	var hidden:bool = false
	var flechette_grenade:bool = false
	var sleep_grenade:bool = false
	var i_name:String = "N/A"
	var explanation:String = ""
	var texture = load("res://Textures/Menu/Empty_Slot.png")
	

func _ready():
	empty_implant = Implant.new()
	leg_implant = empty_implant
	arm_implant = empty_implant
	torso_implant = empty_implant
	head_implant = empty_implant
	
	var new_implant = Implant.new()
	new_implant.i_name = "Speed Enhancer Gland"
	new_implant.explanation = "An artificial organ that emits synthetic hormones capable of boosting your neurocircuit activity and metabolism. Decreases your body's natural ability to recover from damage and shock."
	new_implant.armor = 1.1
	new_implant.price = 1000
	new_implant.speed_bonus = 1
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/speed1.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Speed Enhancer Node Cluster"
	new_implant.explanation = "Bypasses most of your body's endocrine system with an artificial one. Your movement speed is significantly improved at the expense of overall weakened health."
	new_implant.armor = 1.5
	new_implant.price = 3000
	new_implant.speed_bonus = 2
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/speed2.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Speed Enhancer Total Organ Package"
	new_implant.explanation = "Bypasses the entirety of your speed-limited set of human organs with more fragile fully unlocked commercial product. Pros only."
	new_implant.armor = 2.0
	new_implant.price = 6000
	new_implant.speed_bonus = 4
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/speed3.png")
	
	IMPLANTS.append(new_implant)
	

	
	new_implant = Implant.new()
	new_implant.i_name = "CSIJ Level II Body Armor"
	new_implant.explanation = "Inexpensive kevlar vest. Minimum recommended protection."
	new_implant.price = 1000
	new_implant.armor = 0.9
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/light_armor.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "CSIJ Level IIB Body Armor"
	new_implant.explanation = "Improved light body armor utilizing advanced material technology."
	new_implant.price = 0
	new_implant.armor = 0.85
	new_implant.torso = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/advanced_armor.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "CSIJ Level III Body Armor"
	new_implant.explanation = "Kevlar with simple Ultra-high-molecular-weight polyethylene trauma plates."
	new_implant.price = 3000
	new_implant.armor = 0.8
	new_implant.speed_bonus = - 1
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/medium_armor.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "CSIJ Level IV Body Armor"
	new_implant.explanation = "Biobreeder spider silk fiber with thick and heavy graphene composite plates."
	new_implant.price = 5000
	new_implant.armor = 0.5
	new_implant.speed_bonus = - 3
	new_implant.jump_bonus = - 5
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/heavy_armor.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "CSIJ Level V Biosuit"
	new_implant.explanation = "A suit of writhing flesh that wraps around you and seals you in. Extremely good protection with no immediately apparent downsides."
	new_implant.price = 99999
	new_implant.armor = 0.6
	new_implant.terror = true
	new_implant.torso = true
	new_implant.toxic_shield = true
	new_implant.texture = load("res://Textures/Menu/Implants/ultra_armor.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "CSIJ Level VI Golem Exosystem"
	new_implant.explanation = "A terrifying exoskeleton built out of unknown metamaterials, originally used by guards in nuclear power plants."
	new_implant.price = 0
	new_implant.orbsuit = true
	new_implant.torso = true
	new_implant.hidden = true
	new_implant.toxic_shield = true
	new_implant.armor = 0.6
	new_implant.texture = load("res://Textures/Menu/Implants/golem.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Tactical Blast Shield"
	new_implant.explanation = "Complete protection from explosives. Allows the use of advanced demolition techniques."
	new_implant.price = 6000
	new_implant.explosive_shield = true
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/blastshield.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Load Bearing Vest"
	new_implant.explanation = "One extra magazine for both weapons. Due to new clever construction it doesn't even slow you down."
	new_implant.price = 1200
	new_implant.ammo_bonus = 1
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/lbv.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Hazmat Suit"
	new_implant.explanation = "Protection against toxic hazards. Funny looking."
	new_implant.price = 0
	new_implant.toxic_shield = true
	new_implant.speed_bonus = 0
	new_implant.torso = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/hazmat.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Military Camouflage"
	new_implant.explanation = "Makes you slightly harder to spot. Increases enemy reaction time."
	new_implant.price = 1000
	new_implant.camo = 0.2
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/militarycamo.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Stealth Suit"
	new_implant.explanation = "Uses a coating of newly developed chameleon bacteria to make the user practically invisible up to about 20 universal length units. Has an overbearing stench and because of this the special forces units that make use of these are widely known as shitmen."
	new_implant.price = 12000
	new_implant.stealth = true
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/stealth.png")
	
	IMPLANTS.append(new_implant)
	
	
	new_implant = Implant.new()
	new_implant.i_name = "Bouncy Suit"
	new_implant.explanation = "A special suit made out of exotic metamaterials designed for the next generation of orbital drop shocktroopers."
	new_implant.price = 0
	new_implant.bouncy = true
	new_implant.torso = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/bouncy.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Extravagant Suit"
	new_implant.explanation = "Only for special occasions. Offers zero protection."
	new_implant.price = 500000
	new_implant.instadeath = true
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/tux.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Biothruster"
	new_implant.explanation = "Propel yourself forwards with a powerful jet of sticky liquid from holes in your back. Replaces your kick."
	new_implant.price = 10000
	new_implant.thrust = true
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/biothruster.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Biojet"
	new_implant.explanation = "A powerful steady stream of warm liquid smoothly lifts you up and lets you fly like a bird. Replaces your kick."
	new_implant.price = 0
	new_implant.hidden = true
	new_implant.jetpack = true
	new_implant.torso = true
	new_implant.texture = load("res://Textures/Menu/Implants/jetpack.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "HE Grenade"
	new_implant.explanation = "Regular high explosive hand grenade. Can be used to breach through some locked doors."
	new_implant.price = 1000
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.he_grenade = true
	new_implant.texture = load("res://Textures/Menu/Implants/he_grenade.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Flechette Grenade"
	new_implant.explanation = "Gives everything nearby a nice new coating tungsten flechettes."
	new_implant.price = 2000
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.flechette_grenade = true
	new_implant.texture = load("res://Textures/Menu/Implants/flechette.png")
	
	IMPLANTS.append(new_implant)
	
	
	new_implant = Implant.new()
	new_implant.i_name = "ZZzzz Special Sedative Grenade"
	new_implant.explanation = "Not in production anymore after most of the first batch ended up on the illegal drug market. Highly sought after for its capacity to induce euphoria that is said to be unlike anything else."
	new_implant.price = 1000
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.sleep_grenade = true
	new_implant.texture = load("res://Textures/Menu/Implants/zzz.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "First Aid Kit"
	new_implant.explanation = "Single use healing item. Always good to have around. It used to be a common policy to keep a bunch of these in all the office restrooms but it was ended after most employees started appearing a little too high on health."
	new_implant.price = 3000
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.healing = 50
	new_implant.texture = load("res://Textures/Menu/Implants/medikit.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Zomy X-200 Portable Cassette Player"
	new_implant.explanation = "Perfect for listening to your favorite tracks on the go."
	new_implant.price = 200
	new_implant.radio = true
	new_implant.speed_bonus = 0
	new_implant.arms = true
	
	new_implant.texture = load("res://Textures/Menu/Implants/radio.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Augmented arms"
	new_implant.explanation = "Throw things with more force. Especially good for using someone's head as a projectile weapon."
	new_implant.price = 1000
	new_implant.throw_bonus = 20
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.texture = load("res://Textures/Menu/Implants/augarm.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Abominator"
	new_implant.explanation = "Creates a reality bubble where the unbearable weight of Life is reversed."
	new_implant.price = 0
	new_implant.arms = true
	new_implant.speed_bonus = 0
	new_implant.grav = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/abominator.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Grappendix"
	new_implant.explanation = "An additional external intestine for climbing and swinging. Smooth, slick and strong. It pulsates."
	new_implant.price = 50000
	new_implant.grapple = true
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.texture = load("res://Textures/Menu/Implants/grappendix.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Angular Advantage Tactical Munitions"
	new_implant.explanation = "Due to increasing security measures some companies started manufacturing intentionally ricocheting bullets for otherwise impossible shots. Use extreme care when firing directly towards a target."
	new_implant.price = 1500
	new_implant.ricochet = true
	new_implant.arms = true
	new_implant.texture = load("res://Textures/Menu/Implants/angular.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Ammunition Gland"
	new_implant.explanation = "Your weapons automatically regenerate ammunition but you can no longer reload manually."
	new_implant.price = 10000
	new_implant.regen_ammo = true
	new_implant.arms = true
	new_implant.texture = load("res://Textures/Menu/Implants/ammogland.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Cursed Torch"
	new_implant.explanation = "A strange device with a doomed aura. The light it casts feels wrong.\n\n'It's possible to create an object that radiates pure death, even stronger than the sun. We can only pray that such knowledge remains hidden for aeons to come.'\n-Ferdinand Sommer the Elder"
	new_implant.price = 0
	new_implant.speed_bonus = 0
	new_implant.arms = true
	new_implant.cursed_torch = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/cursed_torch.png")
	
	IMPLANTS.append(new_implant)
	

	new_implant = Implant.new()
	new_implant.i_name = "Alien Leg Wetware"
	new_implant.explanation = "Simple wetware upgrade to turn off the kick strength limiter. Pulverize your target with incredible power."
	new_implant.price = 4000
	new_implant.kick_improvement = true
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/alienleg.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Pneumatic Legs"
	new_implant.explanation = "Perfect for leaping over obstacles and getting to hard to reach areas."
	new_implant.price = 3500
	new_implant.jump_bonus = 3
	new_implant.speed_bonus = 0
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/pneumalegs.png")
	
	IMPLANTS.append(new_implant)
	

	
	new_implant = Implant.new()
	new_implant.i_name = "Vertical Entry Device"
	new_implant.explanation = "Significantly increases your jumping power. Not always very useful."
	new_implant.price = 7000
	new_implant.jump_bonus = 6
	new_implant.speed_bonus = 0
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/verticalentry.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Icaros Machine"
	new_implant.explanation = "Designed for the military future fighter program as an attempt to reconfigure the linear spatial dimensionality of warfighting but retired after an entire squad of fully augmented supersoldiers ended up decentering biological life against the pavement."
	new_implant.price = 0
	new_implant.jump_bonus = 20
	new_implant.speed_bonus = 0
	new_implant.legs = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/icaros.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Gunkboosters"
	new_implant.explanation = "Boost yourself upwards mid-air by releasing a jet of assorted biological detritus. Makes a huge mess that is extremely unpleasant to clean up."
	new_implant.price = 10000
	new_implant.double_jump = 1
	new_implant.legs = true
	new_implant.texture = load("res://Textures/Menu/Implants/gunkbooster.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Funkgrunters"
	new_implant.explanation = "An upgraded version of the Gunkboosters that allows you to boost twice. Not very popular due to the large uncomfortable container sacks installed below the buttocks."
	new_implant.price = 0
	new_implant.double_jump = 2
	new_implant.legs = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/funkgrunters.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Microbial Oil Secretion Glands"
	new_implant.explanation = "Squirt out special microbial oil that negates all friction and allows you to slide around freely. Surprisingly pleasant smell."
	new_implant.price = 0
	new_implant.ski = true
	new_implant.speed_bonus = 0
	new_implant.legs = true
	new_implant.hidden = true
	
	new_implant.texture = load("res://Textures/Menu/Implants/oil.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Composite Helmet"
	new_implant.explanation = "A simple helmet that offers limited protection. Has a random chance of protecting you from a hit or breaking."
	new_implant.price = 1000
	new_implant.head = true
	new_implant.helmet = true
	new_implant.texture = load("res://Textures/Menu/Implants/helmet.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Zoom N Go Bionic Eyes"
	new_implant.explanation = "Thanks to the easy plug and play eyemplantation technology it's easy to just pop these in. Improved aim."
	new_implant.price = 1000
	new_implant.head = true
	new_implant.zoom_bonus = 0.5
	new_implant.texture = load("res://Textures/Menu/Implants/eyes1.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Life Sensor"
	new_implant.explanation = "Often said to be able to sense the life energy of any living being, the mechanism is actually the opposite. Allows you to sense holes in the background death matrix."
	new_implant.price = 9000
	new_implant.head = true
	new_implant.sensor = true
	new_implant.texture = load("res://Textures/Menu/Implants/lifesensor.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Skullgun"
	new_implant.explanation = "Popular among completely braindead company mechs. A little bit of stuff is scooped out of the skull to make a better fit. Fires a three round burst of micro-caliber HE rounds."
	new_implant.price = 12000
	new_implant.speed_bonus = 0
	new_implant.head = true
	new_implant.skullgun = true
	new_implant.texture = load("res://Textures/Menu/Implants/skullgun.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Goo Overdrive"
	new_implant.explanation = "Overrides the pituitary gland's natural hormone production causing your sweat to turn into sticky goo. Used by climbers."
	new_implant.price = 0
	new_implant.speed_bonus = 0
	new_implant.hidden = true
	new_implant.head = true
	new_implant.climb = true
	new_implant.texture = load("res://Textures/Menu/Implants/goo.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Flowerchute"
	new_implant.explanation = "An extraterrestrial flower of unknow origin planted on the user's head. Works as a parachute and augments cognitive skills."
	new_implant.price = 0
	new_implant.slowfall = true
	new_implant.head = true
	new_implant.hidden = true
	new_implant.texture = load("res://Textures/Menu/Implants/flowerchute.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Cortical Scaledown+"
	new_implant.explanation = "Gives you the psychogenetic ability to shrink your body by influencing its scale value. Installed in the head extension port."
	new_implant.price = 0
	new_implant.speed_bonus = 0
	new_implant.head = true
	new_implant.hidden = true
	new_implant.shrink = true
	new_implant.texture = load("res://Textures/Menu/Implants/scaledown.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Tattered Rain Hat"
	new_implant.explanation = "Old and worn. You've never seen it before but it feels nostalgic."
	new_implant.price = 0
	new_implant.speed_bonus = 0
	new_implant.head = true
	new_implant.hidden = true
	new_implant.fishing_bonus = true
	new_implant.texture = load("res://Textures/Menu/Implants/fishinghat.png")
	
	IMPLANTS.append(new_implant)
	
	new_implant = Implant.new()
	new_implant.i_name = "Eyes of Corporate Insight"
	new_implant.explanation = "Melt into the ancient power of the markets."
	new_implant.price = 250000
	new_implant.market_enhancer = true
	new_implant.speed_bonus = 0
	new_implant.head = true
	new_implant.texture = load("res://Textures/Menu/Implants/finance.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Nightmare Vision Goggles"
	new_implant.explanation = "They give off a putrid stench. Seemingly no effect on anything."
	new_implant.price = 10
	new_implant.speed_bonus = 0
	new_implant.head = true
	new_implant.nightmare = true
	new_implant.texture = load("res://Textures/Menu/Implants/nightmarescope.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Night Vision Goggles"
	new_implant.explanation = "Regular night vision goggles sensitive to the geometric flow of matter."
	new_implant.price = 0
	new_implant.speed_bonus = 0
	new_implant.head = true
	new_implant.hidden = true
	new_implant.nightvision = true
	new_implant.texture = load("res://Textures/Menu/Implants/nightvision.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "Holy Scope"
	new_implant.explanation = "???"
	new_implant.price = 0
	new_implant.speed_bonus = 0
	new_implant.hidden = true
	new_implant.head = true
	new_implant.holy = true
	new_implant.texture = load("res://Textures/Menu/Implants/holyscope.png")
	
	IMPLANTS.append(new_implant)

	new_implant = Implant.new()
	new_implant.i_name = "House"
	new_implant.explanation = "Your very own country house near the cozy village of Lake Green."
	new_implant.price = 1000000
	new_implant.speed_bonus = 0
	new_implant.texture = load("res://Levels/Bonus5.png")
	
	IMPLANTS.append(new_implant)



