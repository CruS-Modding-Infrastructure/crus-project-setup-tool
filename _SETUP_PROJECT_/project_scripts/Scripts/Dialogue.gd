extends Node

var DIALOGUE:Array = [
	[
	"Here to improve your aim?", 
	"I love spending time at the lounge, it's so relaxing. All my worries just melt away.", 
	"They just finished renovating the kill box. It's quite something now.", 
	"This place has a mysterious atmosphere don't you think?", 
	"I can occasionally hear somebody talking when nobody else is here. It's upsetting.", 
	"I've heard the rumors about what happened at your last job. Don't let it get to you buddy, we're all here for you.", 
	"You seem cool.", 
	"Coming here is literally therapy to me.", 
	"I've heard rumors of a weapon older than God that taps into the unbound potential of the financial world. Has to be bullshit.", 
	"I fucked up my last job pretty bad. I got the targets but accidentally got a bunch of civilians killed. Still got paid of course but I feel pretty bad.", 
	"What's your favorite weapon? I'm really into anything that shoots flechettes.", 
	"It's a good idea to take a break every now and then...", 
	"Some day I would like to meet Elsa Holmes.", 
	], 
	[
	"I can't talk right now I'm running late.", 
	"Boss has been bullying me all the time recently, I hope someone kills him.", 
	"I'm so tired of cleaning up excrement. Why me?", 
	"Yawn", 
	"Have you tried the new Coffee Burger? That shit slaps.", 
	"I wish I was at home playing Gorbino's Quest.", 
	"What did they do to your face?", 
	"Holy fuck you're ugly.", 
	"What's that smell?", 
	"I'm so fucking tired.", 
	"We've made a breakthrough in combinining rat and human DNA. The result isn't exactly what we expected though...", 
	"The smells from the lab make me nauseous. There's something wrong with the ventilation system here.", 
	"Ever since I slipped and hit my head I've been craving Hungry Human Soda."
	], 
	[
	"Weird mushrooms keep growing on my lawn. I really don't need this shit in my life right now.", 
	"My neighbor loves deconstructed classic rock. That's fine but he should get headphones.", 
	"Do you hear that screaming?", 
	"What are you doing here?", 
	"Are you one of those open carry guys? I respect that.", 
	"They're trying to make it legal to cook meth. Don't get me wrong I'm into freedom but that's a step too far.", 
	"I really look up to people who are good at violence.", 
	"Who doesn't love a good peeperoni pizza after a hard day of trading? I mean pepperoni."
	], 
	[
	"One day I'll be on that rocket to Mercury. Then my dad will respect me.", 
	"Working conditions here are quite rough but it's all for the greater good. Some sacrifices have to be made.", 
	"Oh you're one of the new security hires?", 
	"Did you know we also make tactical nuclear warheads? That's how we fund the space business. Pretty cool.", 
	"The space elevator construction is behind schedule. It's making me depressed.", 
	"I've heard weird noises from the server room... Hope it's not fleshrats.", 
	"What are you talking about? If I didn't believe in what I was doing I'd simply leave and find another job.", 
	"According to the latest research the living conditions on Mercury aren't that bad."
	], 
	[
	"...", 
	"I just want to go home.", 
	"I've lost count of days.", 
	"Keep having these recurring nightmares about transforming into a bouncy castle... It's freaking me out.", 
	"I don't know where the food they give us here comes from. I swear it moves sometimes and the headache it gives me is something else.", 
	"The sounds here at night... I don't know, I just don't.", 
	"Someone's in my head. I can feel someone else's body as if it was mine."
	], 
	[
	"So apparently the fleshrats just escaped from some biotech lab? Great job.", 
	"I'm here to buy Chunkopops for my son. He can't get enough of that plastic crap.", 
	"Dropped by GamesGames only to find out they're all out of Gorbino's Quest. Do you know about artificial scarcity?", 
	"Had a meat lover's at the Pizza House. I think the Meatoids they put on them have become worse quality recently.", 
	"The Donut World at the main plaza is completely overrun by cops due to the rally. I really wanted to feast on some of those delicious treats.", 
	"I simply adore the Megamall atmosphere. The hustle and bustle, the beat of the city, the squirming chthonic energy. Magnificent.", 
	"Apparently there's a minor fleshrat infestation going on here... Thankfully haven't seen any myself.", 
	"If you put your ear against the wall you might hear the mall speak. That's what the urban legend says anyways.", 
	"Punishment huh... What's that?", 
	"You're here to protect the governor? Don't take this personally, I don't like him. He's making life hard for people of wealth."
	], 
	[
	"They say I have to live here because I've sinned.", 
	"This place reeks of mold and shit. If I had a choice I'd pack my things and leave immediately.", 
	"What's with the commotion?", 
	"Hello neighbor!", 
	"I can't sleep.", 
	"Last night I got up to take a piss and guess what I saw? A real live fleshrat! I immediately reached for my home defence xiphos and sliced that fucker.", 
	"Third time the cops come here this week. Why can't they just let us live?", 
	"Saw a big guy with crazy eye implants and a huge gun... Didn't seem like a cop to me. Do you know what's up?"
	], 
	[
	"I just love the salty sea air.", 
	"When I heard about the opportunity to live here as a permanent resident I immediately took the chance. I don't regret it one bit.", 
	"I never had sex before I moved here but now I'm fucking a different bioslave every day.", 
	"We finally have it, we're fully sovereign. Just a couple of shareholders grabbing hold of their destinies on the open seas. Beautiful.", 
	"If you think about it, the joint-stock company truly is the perfect model for all governance.", 
	"This is just the beginning. Soon there will be others like us.", 
	"Some say biocurrency is disgusting, to me it's a natural evolution.", 
	"Don't get too excited my boy. Oh my ahahaha.", 
	"First we conquer the sea, then space. I have already reserved a spot on the Advanced Orbital Instruments mission to Mercury.", 
	"Facts about the average Titanium Princess resident: High IQ, software developer, INTJ. That's me."
	], 
	[
	"OOOHHHHOHOHOOOO", 
	"OOOHH AHHHAHA", 
	"HHAHAHHA"
	], 
	[
	"The prizes aren't so good. Definitely not worth it. Yet here I am.", 
	"I'm cursed with bad luck.", 
	"First they string you in with a victory streak, then when you're feeling good about yourself they make you lose everything.", 
	"I heard the jackpot from the GunMachine is very powerful, some kind of advanced superweapon.", 
	"Some people are just natural winners, not me.", 
	"I'm financially successful, I'm desirable, I'm a multi-millionaire, I will get what I want. I'm a multi-millionaire...", 
	"The atmosphere here is so fancy, it makes you feel rich even if you're not.", 
	"Interior design is all about minimal scandinavian sewers right now. It's so elegant."
	], 
	[
	"Please go to the changing room and get dressed. Looking at your body I assume you're one of the blue uniforms? Do as I say.", 
	"They've really outdone themselves with this year's ball.", 
	"I can only really let go once I'm here at the Rothenburg Fortress, surrounded by the harsh untouched wilderness. Here I can be my wild true self.", 
	"Can't wait for the party to really start.", 
	"Tired of people calling this a secret society. Anyone can join if they deposit the yearly one billion dollar membership fee...", 
	"You going to Mercury too? That's so passe...", 
	"I love deconstructed classic rock. Huh you don't know about it? You don't listen to music? Freak!", 
	"No one cared who I was until I put on the mask... Haha oh my, I know it's plebeian but I simply love popular culture.", 
	"I'm encumbered with deep thoughts.", 
	"...Sorry what did you say? I was thinking about controlled depopulation. There's too many of us on this planet."
	], 
	[
	"Workworkworkworkwork... FUCK. FUCKING PIECE OF SHIT COMPUTER.", 
	"They're having us do crunch time. Made impossible promises to the clients again. Getting death march feels.", 
	"Why did I have to get into fintech. I want my life back.", 
	"They're saying Gorbino's Quest doesn't run on my PC because of the game engine. I'm not having that, I'm going to leave a negative review.", 
	"It's all bullshit, the code is complete spaghetti and they're bringing in more people to fix it, which only makes it worse.", 
	"All our systems have been down today because of a logic bomb activated by a former developer. I'm not supposed to say this but I'm glad it happened.", 
	"So what do you think, OOP vs. functional programming? You don't care?? Get the fuck out of here.", 
	"Just to clarify I'm only here temporarily until I get my own company off the ground. I'm trying to break into potato farming logistics.", 
	"You seem different from the other security guys. Like you have even less emotions somehow. Haha just fucking with you bro."
	], 
	[
	"Uh what happened where am I?", 
	"Is this real?", 
	"I must be sleeping.", 
	"LET ME OUT!", 
	"So the world is ending I guess? Is that it?", 
	"Say what you will but this place is intensely beautiful.", 
	"Are you even human?", 
	"This is just like Gorbino's Quest. This is the Gorbino's Quest of life.", 
	"I heard the 640x480 resolution was passed down to us by God. It allows you to see the unseen. Huh?"
	], 
	[
		"You're not from around here, I can tell.", 
		"Dark? What?", 
		"You're going to the mansion? Why?", 
		"Pain.", 
		"I don't even care anymore. I'm going to enlist in the punishment inflicters.", 
		"There's an infinite amount of dimensional planes. They all contain the same amount of suffering.", 
		"You've been here before. I'm sure of that.", 
		"You can kill me but it won't end this.", 
		"Nobody knows where the glow in the horizon comes from. This is not a place of knowledge."
	], 
		[
		"They market this place as a ski resort but nobody really comes here to ski. I can tell you didn't either... Heh.", 
		"I finally have time for a good relaxing vacation and of course this place is jam-packed with dumbfuck tourists. Fucking hell mate.", 
		"Thank god the fleshrats haven't reached here yet. I was in the hospital for a week after getting bit by one. Nasty.", 
		"The magnificent kinetic sculpture in the lobby was made by the world renowned artist Killforce Gutface. But you obviously knew that already", 
		"Just fantastic. The swamp suite I reserved has been hogged by some pig fucker exec. Regular old me can't catch a break.", 
		"I'm very picky when it comes to food. No cheese, no eat.", 
		"Everywhere I go there's voices inside the walls. You get used to it.", 
		"Nothing like a frosty brew after frying up in the tanning bed. This place is incredible, it's nuts.", 
		"I had a coffee burger for breakfast. You can't beat that.", 
		"You don't look like the kind of guy who could afford this place.", 
		"I'm a busybody.", 
		"There's people and then there's people and then there's me. Know what I mean?", 
	], 
		[
		"I have become lost.", 
		"My doctor diagnosed me with Full Spectrum Mental Illness, FSMI. I was sent here to recover. Honestly? Best thing to ever happen to me.", 
		"The feasts are spectacular. It's almost like you're not working at all. Beats the candy dispenser at my last job. I never knew meat mining could be such a treat.", 
		"Are you on your way to the DNA scrambler?", 
		"Wow, good to see a new face. I like it here but after a while you need fresh blood.", 
		"Our stock value is going parabolic. It's an incredible spectacle. You bought some right?", 
		"Vegan meat... Heh.", 
		"We're more like a family than a company. It's so comfers.", 
		"I'm praying.", 
		"After G-Tech imploded it was simple for us to take over the food industry."
	], 
	[
		"NrNrNr BNBNBNBNBNBNRONICHITY... NNNNNTRONNNNNCHTONOMONOTRACHIA... CRNNNNTRRRRHYRAXIPLASTIA...", 
		"Power is flowing through me. I'm a beast. I'm a destroyer. Get in my way and I will kill you.", 
		"Uhhh ahhh.... OHHH YEAH...", 
		"Biogenetic value accumulation... I'm transacting value to everyone around me. I'm keeping my body primed and my mind sharp. All of my co-workers want to fuck me. I'm here to increase my libido.", 
		"You know if you keep it up you can just like, keep doing this shit forever, like, this place never closes you know, right? So you can just take a hit of gore and keep going... I've been here for weeks.", 
		"I'm a graphic designer.", 
		"Everyone's here to become a better, more complete person.", 
		"When the beat drops I'm going to fucking kill myself.", 
		"My friend overdosed on gore. Not something you ever want to see. The boundaries of human biology are easily crossed.", 
		"Theory time. Us civilians are a writhing mass of flesh, vaguely connected by vegetative psychological link. Our value is determined by an extradimensional being who is toying with us. We have no capacity for thought, we're simply an ecosystem of flesh.", 
		"You invest in the stock market? I'm impressed.", 
		"Where'd you get that sexy outfit?", 
		"I'm the most powerful person in this room. I control this situation. Everyone's dancing to my tune...", 
		"Nobody's saying it out loud but I'm glad they purified this place.", 
		"A good party requires a blood sacrifice.", 
		"Selective breeding. They're doing it but nobody is talking about it.", 
		"I need to come here and really let go so I can work on my creative investment portfolio. I have an artistic take on finance.", 
		"Heartbeat... Good. Brainwaves... Perfect. Blood pressure... Astronomical.", 
		"I need to get out of here... My body is freaking out... I can't contain it...", 
		"You're so composed and cool. Are you an artist?", 
		"I killed my husband. It was worth the fee.", 
		"Have you ever tried prion disease therapy? Works wonders for FSMI."
	], 
	[
		"I could snap you like a twig. I have a home gym.", 
		"To kill is to live. I live a warrior lifestyle.", 
		"Our traditions are oriented around power. Power flows from the soul. I can tell you have none.", 
		"Full Spectrum Mental Illness is a disease of the spirit. Cleanse yourself with death.", 
		"I get intense gratification from bullying losers online.", 
		"The strong decide the nature of sin.", 
		"I used to be a graphic designer. I'm reformed now.", 
		"Greatness is achieved through violence of action.", 
		"Pathetic...", 
		"I follow the teachings of Fuckbro99.", 
		"That is false. Move on.", 
		"You have a weak frame.", 
		"You won't last five seconds around here.", 
		"Eat raw eggs. Sperm. Datura. And you can achieve what I have full natty. If you have what it takes."
	], 
	[
		"I could snap you like a twig. I have a home gym.", 
		"To kill is to live. I live a warrior lifestyle.", 
		"Our traditions are oriented around power. Power flows from the soul. I can tell you have none.", 
		"Full Spectrum Mental Illness is a disease of the spirit. Cleanse yourself with death.", 
		"I get intense gratification from bullying losers online.", 
		"The strong decide the nature of sin.", 
		"I used to be a graphic designer. I'm reformed now.", 
		"Greatness is achieved through violence of action.", 
		"Pathetic...", 
		"I follow the teachings of Fuckbro99.", 
		"That is false. Move on.", 
		"You have a weak frame.", 
		"You won't last five seconds around here.", 
		"Eat raw eggs. Sperm. Datura. And you can achieve what I have full natty. If you have what it takes."
	], 
]


func _ready():
	pass





