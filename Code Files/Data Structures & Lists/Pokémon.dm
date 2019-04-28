/* Red (Pokemonred200) */

pokemon
	gender = PLURAL
	Enter(atom/movable/O) // just in case lol
		return 0
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			P.ShowText("[src.name]")
			P.client.Audio.addSound(sound(src.cry,channel=5),"200",autoplay=TRUE)
	parent_type = /partyMon
	density = 1
	layer = POKEMON_LAYER
	Click(location,control,params)
		params = params2list(params)
		if(!params["right"])
			for(var/mob/M in ohearers(src))
				if(M.client)
					M.client.Audio.addSound(sound(src.cry,channel=42),"1532",TRUE)
		else
			if(dir & NORTH)dir = EAST
			else if(dir & EAST)dir = SOUTH
			else if(dir & SOUTH)dir = WEST
			else if(dir & WEST)dir = NORTH
	Cross(atom/movable/O)
		if(istype(O,/player) || istype(O,/pokemon))
			return TRUE
		else
			return ..()
	New(player/P,shinyNum = rand(1,8192),pidLower=rand(0,65535),pidHigher=rand(0,65535),genderByte)
		if(!P)P = new // Placeholder for Read(savefile/F)
		src.genderByte = genderByte
		if(!src.genderByte)
			src.genderByte = pidLower%256
		stats = list("HP"=10,"atk"=10,"def"=10,"satk"=10,"sdef"=10,"speed"=10,"base_exp"=10,"catch_rate"=255,"base_frind"=70,"egg_cycles"=21) // The stats[] list stores base stats.
		evYield = list("HP"=0,"atk"=0,"def"=0,"satk"=0,"sdef"=0,"speed"=0)
		learnset = list()
		ribbons = list()
		HPIv = rand(0,31)
		attackIv = rand(0,31)
		defenseIv = rand(0,31)
		spAttackIv = rand(0,31)
		spDefenseIv = rand(0,31)
		speedIv = rand(0,31)
		shineNumber = shinyNum
		owner = P
		if(gameFlags & TOGGLE_HP_NATURES)
			nature = pick("Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish",
			"Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm",
			"Gentle","Sassy","Careful","Quirky","Caring","Kind","Spirited","Happy","Cheerful","Peaceful",
			"Feeble","Hyper","Morbid","Rude","Stressful")
		else
			nature = pick("Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish",
			"Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm",
			"Gentle","Sassy","Careful","Quirky")
		PIDlower = ( (isnull(pidLower)) || (!isnum(pidLower)) || (!(pidLower in 0 to 65535 )) )?(rand(0,65535)):(pidLower)
		PIDlower = ( (isnull(pidHigher)) || (!isnum(pidHigher)) || (!(pidHigher in 0 to 65535 )) )?(rand(0,65535)):(pidHigher)
		TID = owner.TID
		SID = owner.SID
		if(shineNumber==owner.tValue)
			savedFlags |= SHINY
		else
			savedFlags &= ~SHINY
		fsprite = new
		bsprite = new
		fsprite.layer = 300
		bsprite.layer = 300
		sprite = image(loc=src)
		sprite.layer=POKEMON_LAYER
		sprite.override = TRUE
		sprite.underlays += image('Shadow Effects.dmi',"Shadow")
		calculateHiddenPower()
	var
		tmp
			volatileStatus[] = list("Confusion"=0)
			ivars[] = list("type1","type2","type3","ability1","ability2","attack","defense","spAttack","spDefense","speed")
			attackBoost = 0
			defenseBoost = 0
			spAttackBoost = 0
			spDefenseBoost = 0
			speedBoost = 0
			accuracyBoost = 0
			evasionBoost = 0
			accuracy = 1
			friendsteps = 0
			moveState = 0
			traced = FALSE
			lockedOn = FALSE
			item/removedItem // Knocked Off
			rageStacks = 0
			ragedAttack = 0
			stockpiles = 0 // Stacks of 'Stockpile'
			protectTurns = 1
			infoFlags = (0 | GROUNDED)
			choiceSlot = 0
			pokemonDataFlags = 0
			sleepTurns = 0
			expLevel

		ownerfriendship

		DNAHighValue
		DNALowValue

		pName = ""

		status = "" // Can be Frozen, Sleep, Poison, Burn, or Paralysis
		bpCounter = 0

		form = ""

		// Main Stats
		tmp
			stats[]
			evYield[]
			attack
			defense
			spAttack
			spDefense
			speed
		HP = 1
		maxHP = 1

		tmp/learnset[]

		friendship = 0

		level = 5 as num|anything in 1 to 100
		exp = 0 as num
		tmp
			expGroup = MEDIUM_FAST
			pmove/lastMoveUsed
			icon/menuIcon

		shineNumber // To preserve shininess in evolution

		// EVs
		HPEv = 0
		attackEv = 0
		defenseEv = 0
		spAttackEv = 0
		spDefenseEv = 0
		speedEv = 0

		caughtWith = "Poké Ball"
		caughtLevel = 5
		caughtRoute = "Route 101"
		caughtDate = "December 13, 2013"
		language = ENGLISH
		tmp/dexNumber = "0000"

		ribbons[]

		savedFlags = 0

		beauty = 0
		smart = 0
		tough = 0
		sheen = 0
		cool = 0
		cute = 0

		TID
		SID
		OT
		OTgender // For breeding and disobedience purposes
		tmp
			image/sprite
			sound/cry

		pokerus = 0

		formID // Geneally null; used by Unown and Flaébé Line

		tmp
			type1
			type2
			type3
			genderByte

		importedFrom = "Pokémon Universe Network" // Despite the name, the pokémon need not be imported in this case.
		fromRegion = "Hoenn"

		tmp
			height
			weight

			ability1
			ability2

			eggGroup1
			eggGroup2

		affection = 0 // Based on Mini-Hearts

		tmp
			screen/battleIcon/fsprite
			screen/battleIcon/bsprite

		item/held

		hidden_power_type

		tmp
			// Evolution Data
			base
			evo
			evoLevel
			evoItem
			evoType = LEVEL
			evoTriggerMove
			evoMoves = "" // List of moves this Pokémon will learn upon evolving.
			evoStone = 0

			eggMoves = ""

			// Mega Evolution Data
			megaStoneX
			megaStoneY
			megaEvolutionX
			megaEvolutionY
	proc
		poisonDamage()
			if(gameFlags & TOGGLE_OVERWORLD_POISON)
				switch(src.status)
					if(POISON)
						src.HP = max(src.HP-(max(src.maxHP/25,1)),1)
						if(src.HP==1)
							src.status = ""
					if(BAD_POISON)
						src.HP = max(src.HP-(max(src.maxHP/5,5)),0)
						if(src.HP==0)
							src.status = FAINTED
		getSpeed()
			var finalSpeed = src.speed*stages[src.speedBoost+7]
			if(istype(src.held,/item/normal/choice/Choice_Specs))
				finalSpeed *= 1.5
			return finalSpeed
		sameOT(pokemon/P)
			if(((src.savedFlags & IMPORTED) && (!(P.savedFlags & IMPORTED))) || (!((src.savedFlags & IMPORTED)) && (P.savedFlags & IMPORTED))). = FALSE
			else
				. = ((src.OT==P.OT)&&(src.TID==P.TID)&&(src.SID==P.SID)&&(src.OTgender==P.OTgender))
		withOT()
			if(src.savedFlags & IMPORTED)
				. = FALSE
			else
				. = ((src.OT==src.owner.name) && (src.TID==src.owner.TID) && (src.SID==src.owner.SID) && (src.OTgender==src.owner.gender))
		calculateHiddenPower()
			var
				static
					typeList[] = list(FIGHTING,FLYING,POISON,GROUND,ROCK,BUG,GHOST,STEEL,FIRE,WATER,GRASS,ELECTRIC,PSYCHIC,ICE,DRAGON,DARK)
					typeList2[] = list(NORMAL,FIGHTING,FLYING,POISON,GROUND,ROCK,BUG,GHOST,STEEL,FIRE,WATER,GRASS,ELECTRIC,PSYCHIC,ICE,DRAGON,DARK,FAIRY)
				a = HPIv&1
				b = attackIv&1
				c = defenseIv&1
				d = spAttackIv&1
				e = spDefenseIv&1
				f = speedIv&1
			if(src.savedFlags & IMPORTED_FROM_GEN_3) // this method will allow Pokémon from Gen 3 to keep their hidden power.
				hidden_power_type = typeList[floor((((a+(2*b)+(4+c)+(8*d)+(16*e)+(32*f))*15)/(63)))+1]
			else // However, this method instead allows Normal and Fairy hidden powers.
				hidden_power_type = typeList2[((a+(2*b)+(4*c)+(8*d)+(16*e)+(32*f))%18)+1]
		decreaseFriendship(reason)
			var theStats = getStats(src)
			switch(reason)
				if("trade")
					if((src.OT==src.owner.name)&&(src.OTgender==src.owner.gender)&&(src.TID==src.owner.TID)&&(src.SID==src.owner.SID))
						src.friendship = src.ownerfriendship
					else
						src.friendship = theStats["base_friend"]
				if("healpowder","energypowder")
					if(src.friendship in 0 to 199)src.friendship = src.friendship-5
					else src.friendship = src.friendship-10
				if("energyroot")
					if(src.friendship in 0 to 199)src.friendship = src.friendship-10
					else src.friendship = src.friendship-15
				if("revivalherb")
					if(src.friendship in 0 to 199)src.friendship = src.friendship-15
					else src.friendship = src.friendship-20
			src.friendship = max(src.friendship,0)
		increaseFriendship(reason)
			var sootheBoost = (istype(src.held,/item/normal/Soothe_Bell))?(1.5):(1)
			switch(reason)
				if("walking")
					switch(src.friendship)
						if(0 to 199)src.friendship = (src.friendship+2)*sootheBoost
						else src.friendship = (src.friendship+1)*sootheBoost
				if("massage")
					src.friendship = (src.friendship+pick(prob(6);30,prob(20);10,prob(74);5))*sootheBoost
				if("vitamin")
					switch(src.friendship)
						if(0 to 99)src.friendship = (src.friendship+6)*sootheBoost
						if(100 to 199)src.friendship = (src.friendship+4)*sootheBoost
						else src.friendship = (src.friendship+3)*sootheBoost
				if("wing")
					switch(src.friendship)
						if(0 to 99)src.friendship = (src.friendship+3)*sootheBoost
						if(100 to 199)src.friendship = (src.friendship+2)*sootheBoost
						else src.friendship = (src.friendship+1)*sootheBoost
				if("level")
					switch(src.friendship)
						if(0 to 99)src.friendship = (src.friendship+5)*sootheBoost
						if(100 to 199)src.friendship = (src.friendship+4)*sootheBoost
						else src.friendship = (src.friendship+3)*sootheBoost
				if("soothebag")
					src.friendship = (src.friendship+20)*sootheBoost
				if("lowerberry")
					switch(src.friendship)
						if(0 to 99)src.friendship = (src.friendship+11)*sootheBoost
						if(100 to 199)src.friendship = (src.friendship+6)*sootheBoost
						else src.friendship = (src.friendship+3)*sootheBoost
				if("colorshake")src.friendship = (src.friendship+max(floor(args[2]/100),1))*sootheBoost
				if("raresoda")src.friendship = (src.friendship+6)
				if("evjuice")src.friendship = (src.friendship+4)
			if(src.caughtWith=="Luxury Ball"){src.friendship = (src.friendship+1)*sootheBoost}
			src.friendship = min(src.friendship,255)
		levelUp(goEvo=FALSE,showMessage=TRUE)
			var{oldMaxHP=maxHP;oldAttack=attack;oldDefense=defense;oldSpAttack=spAttack;oldSpDefense=spDefense;oldSpeed=speed}
			var oldTotal = oldMaxHP+oldAttack+oldDefense+oldSpAttack+oldSpDefense+oldSpeed
			if(src.owner.playerFlags & IN_BATTLE)
				src.infoFlags |= HAS_LEVELED
			++src.level
			src.stat_calculate()
			var newTotal = maxHP+attack+defense+spAttack+spDefense+speed
			if(showMessage)
				owner.ShowText("[src] grew to level [src.level]!")
			winset(owner,"statCheck.newHP","text=[maxHP]")
			winset(owner,"statCheck.newAttack","text=[attack]")
			winset(owner,"statCheck.newDefense","text=[defense]")
			winset(owner,"statCheck.newSpAttack","text=[spAttack]")
			winset(owner,"statCheck.newSpDefense","text=[spDefense]")
			winset(owner,"statCheck.newSpeed","text=[speed]")
			winset(owner,"statCheck.newTotal","text=[newTotal]")
			winset(owner,"statCheck.HPgain","text=(%2b[maxHP-oldMaxHP])")
			winset(owner,"statCheck.attackGain","text=(%2b[attack-oldAttack])")
			winset(owner,"statCheck.defenseGain","text=(%2b[defense-oldDefense])")
			winset(owner,"statCheck.spAttackGain","text=(%2b[spAttack-oldSpAttack])")
			winset(owner,"statCheck.spDefenseGain","text=(%2b[spDefense-oldSpDefense])")
			winset(owner,"statCheck.speedGain","text=(%2b[speed-oldSpeed])")
			winset(owner,"statCheck.totalGain","text=(%2b[newTotal-oldTotal])")
			winset(owner,"statCheck","is-visible=true")
			spawn(100) winset(owner,"statCheck","is-visible=false")
			src.learn_move()
			src.increaseFriendship("level")
			if(src.friendship > 255)
				src.friendship = 255
			if(goEvo)
				src.evolve()
		process_moves(newMoves[])
			if((istype(newMoves,/list)) && (newMoves.len))
				move_loop
					for(var/NM in newMoves)
						var isMove = text2path(NM)
						if(isMove)
							var pmove/M = new isMove
							if(locate(M.type) in src.moves)continue move_loop
							if(src.moves.len != 4)src.moves.len = 4
							var movePos = src.moves.Find(null)
							if(movePos)
								src.moves[movePos] = M
								src.owner.ShowText("[src] has learned the move [M]!")
								continue
							else
								src.owner.ShowText("[src] is trying to learn the move [M].")
								src.owner.ShowText("But [genderGet(src,"he")] already knows four moves.")
								src.owner.ShowText("Delete a move to make room for [M]?")
								if(alert(src.owner,"Delete A Move to make room for [M]?","Delete A Move?","Yes!","No...")=="Yes!")
									var deleted = FALSE
									do
										var pmove/MO = input(src.owner,"Which move will you Delete?","Which Move?") as null|anything in src.moves
										if(isnull(MO))continue move_loop
										if(!MO.canForget(src.owner))
											owner.ShowText("It doesn't seem like it's a good idea to forget this move right now.")
											deleted = FALSE
											continue
										var thePos = src.moves.Find(MO)
										src.moves[thePos] = M
										src.owner.ShowTextInstant("1...")
										src.owner.ShowTextInstant("1... 2...")
										src.owner.ShowTextInstant("1... 2... 3... Poof!")
										src.owner.ShowText("[src] has forgotten the move [MO] and learned [M]!")
										del MO
										deleted = TRUE
									while(!deleted)
		learn_move(just_evolved = FALSE)
			var newMoves[]
			if("[src.level]" in learnset)
				newMoves = splittext(learnset["[src.level]"],";")
				process_moves(newMoves)
			if(just_evolved == TRUE)
				newMoves = splittext(src.evoMoves,";")
				process_moves(newMoves)
		stat_calculate(noChange=FALSE)
			var theStats = getStats(src)
			var base = theStats["HP"]
			var bonus = round(HPEv/4)
			var shinyBonus = (src.savedFlags & SHINY)?(10):(0)
			var oldMaxHP = maxHP

			if(src.pName == "Shedinja")
				src.maxHP = 1
			else
				src.maxHP = round(round((((HPIv + (2 * base) + shinyBonus + bonus + 100)*level)/100)+10)*n_calc(src.nature,"HP"))

			base = theStats["atk"]
			bonus = round(attackEv/4)
			src.attack = round(round((((attackIv + (2 * base) + shinyBonus + bonus)*level)/100)+5)*n_calc(src.nature,"attack"))

			base = theStats["def"]
			bonus = round(defenseEv/4)
			src.defense = round(round((((defenseIv + (2 * base) + shinyBonus + bonus)*level)/100)+5)*n_calc(src.nature,"defense"))

			base = theStats["satk"]
			bonus = round(spAttackEv/4)
			src.spAttack = round(round((((spAttackIv + (2 * base) + shinyBonus + bonus)*level)/100)+5)*n_calc(src.nature,"spAttack"))

			base = theStats["sdef"]
			bonus = round(spDefenseEv/4)
			src.spDefense = round(round((((spDefenseIv + (2 * base) + shinyBonus + bonus)*level)/100)+5)*n_calc(src.nature,"spDefense"))

			base = theStats["speed"]
			bonus = round(speedEv/4)
			src.speed = round(round((((speedIv + (2 * base) + shinyBonus + bonus)*level)/100)+5)*n_calc(src.nature,"speed"))

			if(!noChange)
				HP = (maxHP>oldMaxHP)?((maxHP-oldMaxHP)+HP):(HP)
				if(HP==0)
					src.status = ""
					HP = maxHP-oldMaxHP
					if(HP==0)
						HP = 1
				HP = min(HP,src.maxHP)
		formChange(stat_calc=TRUE)
			switch(src.pName)
				if("Castform")
					if(!owner.client.battle || (owner.client.battle.weatherData["Weather"]==CLEAR))
						src.type1 = NORMAL
						src.type2 = ""
						src.type3 = ""
						src.fsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Sprites/castform.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Sprites/castform.gif"))
						src.bsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/castform.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites/castform.gif"))
					else
						switch(owner.client.battle.weatherData["Weather"])
							if(RAINY)
								src.type1 = WATER
								src.type2 = ""
								src.type3 = ""
								src.fsprite.icon = file("Icon Files/Portrait/Battle Sprites/3D Sprites/castform-rainy.gif")
								src.bsprite.icon = file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/castform-rainy.gif")
							if(SUNNY)
								src.type1 = FIRE
								src.type2 = ""
								src.type3 = ""
								src.fsprite.icon = file("Icon Files/Portrait/Battle Sprites/3D Sprites/castform-sunny.gif")
								src.bsprite.icon = file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/castform-sunny.gif")
							if(HAIL)
								src.type1 = ICE
								src.type2 = ""
								src.type3 = ""
								src.fsprite.icon = file("Icon Files/Portrait/Battle Sprites/3D Sprites/castform-snowy.gif")
								src.bsprite.icon = file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/castform-snowy.gif")
							else
								src.type1 = NORMAL
								src.type2 = ""
								src.type3 = ""
								src.fsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Sprites/castform.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Sprites/castform.gif"))
								src.bsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/castform.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites/castform.gif"))
				if("Groudon")
					if( isnull(src.held) || (!istype(src.held,/item/normal/Red_Orb)))
						var pokemon/P = get_pokemon("Groudon",src.owner,src.shineNumber)
						src.form = P.form
						src.fsprite.icon = P.fsprite.icon
						src.bsprite.icon = P.bsprite.icon
						src.cry = P.cry
						src.ability1 = P.ability1
						src.ability2 = P.ability2
						src.menuIcon = P.menuIcon
						src.sprite.icon = P.sprite.icon
					else
						var pokemon/P = get_pokemon("Groudon-Primal",src.owner,src.shineNumber)
						src.form = P.form
						src.fsprite.icon = P.fsprite.icon
						src.bsprite.icon = P.bsprite.icon
						src.cry = P.cry
						src.ability1 = P.ability1
						src.ability2 = P.ability2
						src.menuIcon = P.menuIcon
						src.sprite.icon = P.sprite.icon
				if("Kyogre")
					if( isnull(src.held) || (!istype(src.held,/item/normal/Blue_Orb)))
						var pokemon/P = get_pokemon("Kyogre",src.owner,src.shineNumber)
						src.form = P.form
						src.fsprite.icon = P.fsprite.icon
						src.bsprite.icon = P.bsprite.icon
						src.cry = P.cry
						src.ability1 = P.ability1
						src.ability2 = P.ability2
						src.menuIcon = P.menuIcon
						src.sprite.icon = P.sprite.icon
					else
						var pokemon/P = get_pokemon("Kyogre-Primal",src.owner,src.shineNumber)
						src.form = P.form
						src.fsprite.icon = P.fsprite.icon
						src.bsprite.icon = P.bsprite.icon
						src.cry = P.cry
						src.ability1 = P.ability1
						src.ability2 = P.ability2
						src.menuIcon = P.menuIcon
						src.sprite.icon = P.sprite.icon
				if("Deoxys")
					switch(src.form)
						if("") // Normal turns to Deoxys-A
							var pokemon/P = get_pokemon("Deoxys-A",src.owner,src.shineNumber)
							src.sprite.icon = P.sprite.icon
							src.fsprite.icon = P.fsprite.icon
							src.bsprite.icon = P.bsprite.icon
							src.form = P.form
							src.menuIcon = P.menuIcon
						if("-A") // Deoxys-A turns to Deoxys-D
							var pokemon/P = get_pokemon("Deoxys-D",src.owner,src.shineNumber)
							src.sprite.icon = P.sprite.icon
							src.fsprite.icon = P.fsprite.icon
							src.bsprite.icon = P.bsprite.icon
							src.form = P.form
							src.menuIcon = P.menuIcon
						if("-D") // Deoxys-D turns to Deoxys-S
							var pokemon/P = get_pokemon("Deoxys-S",src.owner,src.shineNumber)
							src.sprite.icon = P.sprite.icon
							src.fsprite.icon = P.fsprite.icon
							src.bsprite.icon = P.bsprite.icon
							src.form = P.form
							src.menuIcon = P.menuIcon
						else // And finally, Deoxys-S turns to Normal
							var pokemon/P = get_pokemon("Deoxys",src.owner,src.shineNumber)
							src.form = P.form
							src.fsprite.icon = P.fsprite.icon
							src.bsprite.icon = P.bsprite.icon
							src.menuIcon = P.menuIcon
							src.sprite.icon = P.sprite.icon
				if("Burmy")
					if(!owner.client.battle)return
					switch(owner.client.battle.battle_area)
						if(GRASSY)
							src.formID = 0x00
							src.evo = (src.gender==MALE)?("Mothim"):("Wormadam-Plant")
							src.sprite.icon = (!(src.savedFlags & SHINY))?(icon('Region 04.dmi',"Burmy(Plant Cloak)")):(icon('Shiny Region 04.dmi',"Burmy(Plant Cloak)"))
							src.fsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Sprites/burmy.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Sprites/burmy.gif"))
							src.bsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/burmy.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites/burmy.gif"))
							src.menuIcon = icon('Region 04 Mini.dmi',"BurmyPlant")
						if(BEACH,CAVE)
							src.formID = 0x08
							src.evo = (src.gender==MALE)?("Mothim"):("Wormadam-Sandy")
							src.sprite.icon = (!(src.savedFlags & SHINY))?(icon('Region 04.dmi',"Burmy(Sandy Cloak)")):(icon('Shiny Region 04.dmi',"Burmy(Sandy Cloak)"))
							src.fsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Sprites/burmy-sandy.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Sprites/burmy-sandy.gif"))
							src.bsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/burmy-sandy.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites/burmy-sandy.gif"))
							src.menuIcon = icon('Region 04 Mini.dmi',"BurmySand")
						if(URBAN)
							src.formID = 0x10
							src.evo = (src.gender==MALE)?("Mothim"):("Wormadam-Trash")
							src.sprite.icon = (!(src.savedFlags & SHINY))?(icon('Region 04.dmi',"Burmy(Trash Cloak)")):(icon('Shiny Region 04.dmi',"Burmy(Trash Cloak)"))
							src.fsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Sprites/burmy-trash.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Sprites/burmy-trash.gif"))
							src.bsprite.icon = (!(src.savedFlags & SHINY))?(file("Icon Files/Portrait/Battle Sprites/3D Back Sprites/burmy-trash.gif")):(file("Icon Files/Portrait/Battle Sprites/3D Shiny Back Sprites/burmy-trash.gif"))
							src.menuIcon = icon('Region 04 Mini.dmi',"BurmyTrash")
				if("Giratina")
					if( ((isnull(src.held)) || (!istype(src.held,/item/normal/stat_item/Griseous_Orb))) && (src.owner.current_world_region != "Distortion World"))
						var pokemon/P = get_pokemon("Giratina",src.owner,src.shineNumber)
						src.form = P.form
						src.fsprite.icon = P.fsprite.icon
						src.bsprite.icon = P.bsprite.icon
						src.menuIcon = P.menuIcon
						src.sprite.icon = P.sprite.icon
					else
						var pokemon/P = get_pokemon("Giratina-O",src.owner,src.shineNumber)
						src.form = P.form
						src.fsprite.icon = P.fsprite.icon
						src.bsprite.icon = P.bsprite.icon
						src.menuIcon = P.menuIcon
						src.sprite.icon = P.sprite.icon
				if("Shaymin")
					if(src.form != "-Sky")
						src.form = "-Sky"
						var pokemon/transform = get_pokemon("Shaymin-Sky",src.owner)
						src.fsprite.icon = transform.sprite.icon
						src.bsprite.icon = transform.sprite.icon
						src.menuIcon = transform.menuIcon
						src.sprite.icon = transform.sprite.icon
						var pmove/M
						var pmove/E
						var movePos
						M = locate(/pmove/Petal_Blizzard) in src.moves
						if(M)
							movePos = src.moves.Find(M)
							E = new /pmove/Air_Cutter
							E.updateBonus(M.PPbonus)
							src.moves[movePos] = E
						M = locate(/pmove/Leaf_Storm) in src.moves
						if(M)
							movePos = src.moves.Find(M)
							E = new /pmove/Hurricane
							E.updateBonus(M.PPbonus)
							src.moves[movePos] = E
						M = locate(/pmove/Natural_Gift) in src.moves
						if(M)
							movePos = src.moves.Find(M)
							E = new /pmove/Fly
							E.updateBonus(M.PPbonus)
							src.moves[movePos] = E
					else
						src.form = ""
						var pokemon/transform = get_pokemon("Shaymin",src.owner)
						src.fsprite.icon = transform.sprite.icon
						src.bsprite.icon = transform.sprite.icon
						src.menuIcon = transform.menuIcon
						src.sprite.icon = transform.sprite.icon
						var
							pmove
								M
								E
							movePos
						M = locate(/pmove/Air_Cutter) in src.moves
						if(M)
							movePos = src.moves.Find(M)
							E = new /pmove/Petal_Blizzard
							E.updateBonus(M.PPbonus)
							src.moves[movePos] = E
						M = locate(/pmove/Hurricane) in src.moves
						if(M)
							movePos = src.moves.Find(M)
							E = new /pmove/Leaf_Storm
							E.updateBonus(M.PPbonus)
							src.moves += E
						M = locate(/pmove/Fly) in src.moves
						if(M)
							movePos = src.moves.Find(M)
							E = new /pmove/Natural_Gift
							E.updateBonus(M.PPbonus)
							src.moves[movePos] = E
				if("Arceus")
					if(!isnull(src.held))
						var iconThing
						var menuIconThing
						if(src.savedFlags & SHINY)
							iconThing = 'Shiny Large Sprite.dmi'
							menuIconThing = 'Shiny Region 04 Mini.dmi'
						else
							iconThing = 'Large Sprite.dmi'
							menuIconThing = 'Region 04 Mini.dmi'
						var iconState = "Arceus"
						switch(src.held.type)
							if(/item/normal/plate/Draco_Plate)
								src.type1 = DRAGON
								iconState = "Arceus-Dragon"
							if(/item/normal/plate/Dread_Plate)
								src.type1 = DARK
								iconState = "Arceus-Dark"
							if(/item/normal/plate/Earth_Plate)
								src.type1 = GROUND
								iconState = "Arceus-Ground"
							if(/item/normal/plate/Fist_Plate)
								src.type1 = FIGHTING
								iconState = "Arceus-Fighting"
							if(/item/normal/plate/Flame_Plate)
								src.type1 = FIRE
								iconState = "Arceus-Fire"
							if(/item/normal/plate/Icicle_Plate)
								src.type1 = ICE
								iconState = "Arceus-Ice"
							if(/item/normal/plate/Insect_Plate)
								src.type1 = BUG
								iconState = "Arceus-Bug"
							if(/item/normal/plate/Meadow_Plate)
								src.type1 = GRASS
								iconState = "Arceus-Grass"
							if(/item/normal/plate/Mind_Plate)
								src.type1 = FAIRY
								iconState = "Arceus-Fairy"
							if(/item/normal/plate/Pixie_Plate)
								src.type1 = FAIRY
								iconState = "Arceus-Fairy"
							if(/item/normal/plate/Shock_Plate)
								src.type1 = ELECTRIC
								iconState = "Arceus-Electric"
							if(/item/normal/plate/Sky_Plate)
								src.type1 = FLYING
								iconState = "Arceus-Flying"
							if(/item/normal/plate/Splash_Plate)
								src.type1 = WATER
								iconState = "Arceus-Water"
							if(/item/normal/plate/Spooky_Plate)
								src.type1 = GHOST
								iconState = "Arceus-Ghost"
							if(/item/normal/plate/Stone_Plate)
								src.type1 = ROCK
								iconState = "Arceus-Rock"
							if(/item/normal/plate/Toxic_Plate)
								src.type1 = POISON
								iconState = "Arceus-Poison"
							else
								src.type1 = NORMAL
								iconState = "Arceus"
						src.sprite.icon = icon(iconThing,iconState)
						src.menuIcon = icon(menuIconThing,iconState)
						src.fsprite.icon = getFrontImage(src,"[lowertext(iconState)].gif")
						src.bsprite.icon = getBackImage(src,"[lowertext(iconState)].gif")
					else
						src.type1 = NORMAL
						src.fsprite.icon = getFrontImage(src,"arceus.gif")
						src.bsprite.icon = getBackImage(src,"arceus.gif")
						if(!(src.savedFlags & SHINY))
							src.sprite.icon = icon('Large Sprite.dmi',"Arceus")
							src.menuIcon = icon('Region 04 Mini.dmi',"Arceus")
						else
							src.sprite.icon = icon('Shiny Large Sprite.dmi',"Arceus")
							src.menuIcon = icon('Shiny Region 04 Mini.dmi',"Arceus")
				if("Silvally")
					if(isnull(src.held))
						src.type1 = NORMAL
						src.fsprite.icon = getFrontImage(src,"silvally.gif")
						src.bsprite.icon = getBackImage(src,"silvally.gif")
						if(!(src.savedFlags & SHINY))
							src.menuIcon = icon('Region 07 Mini.dmi',"Silvally")
						else
							src.menuIcon = icon('Region 07 Mini.dmi',"Silvally")
					else
						var menuIconThing
						if(!(src.savedFlags & SHINY))
							menuIconThing = 'Region 07 Mini.dmi'
						else
							menuIconThing = 'Shiny Region 07 Mini.dmi'
						var iconState = "Silvally"
						switch(src.held.type)
							if(/item/normal/memory/Bug_Memory)
								src.type1 = BUG
								iconState = "Silvally-Bug"
							if(/item/normal/memory/Dark_Memoy)
								src.type1 = DARK
								iconState = "Silvally-Dark"
							if(/item/normal/memory/Dragon_Memory)
								src.type1 = DRAGON
								iconState = "Silvally-Dragon"
							if(/item/normal/memory/Electric_Memory)
								src.type1 = ELECTRIC
								iconState = "Silvally-Electric"
							if(/item/normal/memory/Fairy_Memory)
								src.type1 = FAIRY
								iconState = "Silvally-Fairy"
							if(/item/normal/memory/Fighting_Memory)
								src.type1 = FIGHTING
								iconState = "Silvally-Fighting"
							if(/item/normal/memory/Fire_Memory)
								src.type1 = FIRE
								iconState = "Silvally-Fire"
							if(/item/normal/memory/Flying_Memory)
								src.type1 = FLYING
								iconState = "Silvally-Flying"
							if(/item/normal/memory/Ghost_Memory)
								src.type1 = GHOST
								iconState = "Silvally-Ghost"
							if(/item/normal/memory/Grass_Memory)
								src.type1 = GRASS
								iconState = "Silvally-Grass"
							if(/item/normal/memory/Ground_Memory)
								src.type1 = GROUND
								iconState = "Silvally-Grass"
							if(/item/normal/memory/Ice_Memory)
								src.type1 = ICE
								iconState = "Silvally-Ice"
							if(/item/normal/memory/Light_Memory)
								src.type1 = LIGHT
								iconState = "Silvally"
							if(/item/normal/memory/Poison_Memory)
								src.type1 = POISON
								iconState = "Silvally-Poison"
							if(/item/normal/memory/Psychic_Memory)
								src.type1 = PSYCHIC
								iconState = "Silvally-Psychic"
							if(/item/normal/memory/Rock_Memory)
								src.type1 = ROCK
								iconState = "Silvally-Rock"
							if(/item/normal/memory/Steel_Memory)
								src.type1 = STEEL
								iconState = "Silvally-Steel"
							if(/item/normal/memory/Water_Memory)
								src.type1 = WATER
								iconState = "Silvally-Water"
							else
								src.type1 = NORMAL
								iconState = "Silvally"
						src.fsprite.icon = getFrontImage(src,"[lowertext(iconState)].gif")
						src.bsprite.icon = getBackImage(src,"[lowertext(iconState)].gif")
						src.menuIcon = icon(menuIconThing,iconState)
			if(stat_calc)
				src.stat_calculate()
		evolve(item/normal/stone/S=new,TradeProxy/T=null)
			if((!src.evo) && (src.pName != "Eevee"))return
			var tHour = text2num(gameTime.Hour())
			if(isnull(T)) // Not a Trade
				switch(src.pName)
					if("Kirlia")
						if(src.gender == "male")
							if(S.sStone & DAWN_STONE){src.evo="Gallade";process_evolution();return}
					if("Snorunt")
						if(src.gender == "female")
							if(S.sStone & DAWN_STONE){src.evo="Froslass";process_evolution();return}
			switch(src.evoType)
				if(LEVEL)
					if(!isnull(T))return
					if(istype(src.held,/item/normal/Everstone))return
					if(evoItem && istype(src.held,src.evoItem))
						process_evolution()
					else if(src.level >= evoLevel)
						process_evolution()
				if(DAYTIME)
					if(!isnull(T))return
					if(tHour in 4 to 17) // if tHour is between 4 and 17, it is daytime.
						if(istype(src.held,/item/normal/Everstone))return
						if(evoItem && istype(src.held,src.evoItem))
							process_evolution()
						else if(src.level >= src.evoLevel)
							process_evolution()
				if(NIGHTTIME)
					if(!isnull(T))return
					if(!(tHour in 4 to 17)) // if tHour is NOT between 4 and 17, it is nighttime.
						if(istype(src.held,/item/normal/Everstone))return
						if(evoItem && istype(src.held,src.evoItem))
							process_evolution()
						else if(src.level >= src.evoLevel)
							process_evolution()
				if(FRIENDSHIP)
					if(istype(src.held,/item/normal/Everstone))return
					if(!isnull(T))return
					if(src.friendship >= 220)
						process_evolution()
				if(TRADE)
					if(istype(src.held,/item/normal/Everstone))return
					if(!isnull(T))
						if(src.evoItem)
							if(!istype(src.held,src.evoItem))return
						else if(src.pName in list("Shelmet","Karrablast"))
							if(src.pokemonDataFlags & TRADE_SWAP_EVO)
								src.pokemonDataFlags &= ~TRADE_SWAP_EVO
							else return
						process_evolution()
				if(STONE)
					if(!isnull(T))return
					if(isnull(S))return
					if(src.evoStone & S.sStone)
						del S
						process_evolution()
				if(LEARN_MOVE)
					if(istype(src.held,/item/normal/Everstone))return
					if(!isnull(T))return
					if(isnull(src.evoTriggerMove))return
					var found = FALSE
					for(var/pmove/M in src.moves)
						if(istype(M,src.evoTriggerMove))
							found = TRUE
							break
					if(found)
						process_evolution()
				else
					switch(src.pName)
						if("Eevee")
							if(!isnull(T))return
							if(S.sStone & WATER_STONE){src.evo = "Vaporeon";process_evolution()}
							else if(S.sStone & THUNDER_STONE){src.evo = "Jolteon";process_evolution()}
							else if(S.sStone & FIRE_STONE){src.evo = "Flareon";process_evolution()}
							if(istype(src.held,/item/normal/Everstone))return
							var searchArea = orange(100,src.owner)
							if(locate(/turf/outdoor/rock/moss_rock) in searchArea){src.evo = "Leafeon";process_evolution()}
							else if(locate(/turf/outdoor/rock/ice_rock) in searchArea){src.evo = "Glaceon";process_evolution()}
							else if(src.affection>=100)
								var found = FALSE
								for(var/pmove/M in src.moves)
									if(M._type == FAIRY)
										found = TRUE
										break
								if(found)
									src.evo="Sylveon"
									process_evolution()
							else if(src.friendship >= 220)
								switch(tHour)
									if(4 to 17)src.evo = "Espeon"
									else src.evo = "Umbreon"
								process_evolution()
						if("Gloom")
							if(isnull(T))
								if(S.sStone & LEAF_STONE){src.evo = "Vileplume";process_evolution()}
								else if(S.sStone & SUN_STONE){src.evo = "Bellossom";process_evolution()}
						if("Poliwhirl")
							if(isnull(T))
								if(S.sStone & WATER_STONE){src.evo = "Poliwrath";process_evolution()}
							else
								if(istype(src.held,/item/normal/evolve_item/trade/King\'\s_Rock)){src.evo = "Politoed";src.held=null;process_evolution()}
						if("Pikachu")
							if(isnull(T))
								if(S.sStone & THUNDER_STONE)
									src.evo = (!(locate(/turf/outdoor/rock/alolan_rock) in orange(100,src.owner)))?("Raichu"):("Raichu-Al")
									process_evolution()
						if("Slowpoke")
							if(isnull(T))
								if(src.level >= src.evoLevel){src.evo = "Slowbro";process_evolution()}
							else
								if(istype(src.held,/item/normal/evolve_item/trade/King\'\s_Rock)){src.evo = "Slowking";src.held=null;process_evolution()}
						if("Tyrogue")
							if(!isnull(T))return
							if(istype(src.held,/item/normal/Everstone))return
							if(src.level >= src.evoLevel) // 20, Durrrrrrrrr
								if(src.attack > src.defense)src.evo = "Hitmonlee"
								else if(src.attack < src.defense)src.evo = "Hitmonchan"
								else if(src.attack == src.defense)src.evo = "Hitmontop"
								process_evolution()
						if("Clamperl")
							if(!isnull(T))
								if(istype(src.held,/item/normal/evolve_item/trade/Deep_Sea_Scale)){src.evo = "Gorebyss";src.held=null;process_evolution()}
								else if(istype(src.held,/item/normal/evolve_item/trade/Deep_Sea_Tooth)){src.evo = "Huntail";src.held=null;process_evolution()}
						if("Budew","Riolu")
							if(!isnull(T))return
							if(istype(src.held,/item/normal/Everstone))return
							if((tHour in 4 to 17) && (src.friendship >= 220))process_evolution()
						if("Rockruff")
							if(isnull(T))
								if(istype(src.held,/item/normal/Everstone))return
								if(src.level >= src.evoLevel)
									if(src.ability1 != "Own Tempo") //
										if(tHour in 4 to 17)src.evo = "Lycanroc-Midday"
										else src.evo = "Lycanroc-Midnight"
										process_evolution()
									else
										if(tHour == 17)
											src.evo = "Lycanroc-Dusk"
											process_evolution()
						if("Cosmoem")
							if(isnull(T))
								if(istype(src.held,/item/normal/Everstone))return
								if(src.level >= src.evoLevel)
									if(tHour in 4 to 19)src.evo = "Solgaleo"
									else src.evo = "Lunala"
									process_evolution()
						if("Feebas")
							if(!isnull(T))
								if(istype(src.held,/item/normal/evolve_item/trade/Prisim_Scale))
									src.held = null
									process_evolution()
							else
								if(istype(src.held,/item/normal/Everstone))return
								if(src.beauty > 170)
									process_evolution()
						if("Magneton","Nosepass","Charjabug")
							if(!isnull(T))return
							if(istype(src.held,/item/normal/Everstone))return
							if(locate(/turf/outdoor/rock/magnet_rock) in orange(100,src.owner)){process_evolution()}
						if("Phione")
							if(!isnull(T))return
							if(src.level >= src.evoLevel)
								if((src.beauty >= 170) && (src.friendship >= 220) && (src.affection >= 100))
									if(istype(src.held,/item/normal/evolve_item/trade/Prisim_Scale))
										src.held = null
										awardMedal("Extreme Evolution",src.owner)
										process_evolution()
						if("Crabrawler")
							if(!isnull(T))
								if(locate(/turf/outdoor/rock/ice_rock) in orange(src.owner,100))
									process_evolution()
			stat_calculate()
		reload(player/P,PC=FALSE)
			var pokemon/X = get_pokemon(tName="[src.pName][src.form]",S=owner,shinyNum=src.shineNumber,PIDhigher=src.PIDhigher,PIDlower=src.PIDlower,
							hidden=(src.savedFlags & HIDDEN_ABILITY),hidden2=(src.savedFlags & HIDDEN_ABILITY_2),formID=src.formID)
			if((!src.OT)||(src.OT=="player"))
				src.OT = P.name
			if((!src.OTgender) || (!(src.OTgender in list(MALE,FEMALE))))
				src.OTgender = P.gender
			src.stats = X.stats
			src.expGroup = X.expGroup
			src.evo = X.evo
			src.learnset = X.learnset
			src.base = X.base
			src.evoLevel = X.evoLevel
			src.evoItem = X.evoItem
			src.evoType = X.evoType
			src.evoTriggerMove = X.evoTriggerMove
			src.evoStone = X.evoStone
			src.megaStoneX = X.megaStoneX
			src.megaStoneY = X.megaStoneY
			src.megaEvolutionX = X.megaEvolutionX
			src.megaEvolutionY = X.megaEvolutionY
			src.sprite.icon = X.sprite.icon
			src.sprite.underlays = X.sprite.underlays
			src.fsprite.icon = X.fsprite.icon
			src.bsprite.icon = X.bsprite.icon
			src.menuIcon = X.menuIcon
			src.cry = X.cry
			src.pixel_x = X.pixel_x
			src.pixel_y = X.pixel_y
			src.type1 = X.type1
			src.type2 = X.type2
			src.type3 = X.type3
			src.eggGroup1 = X.eggGroup1
			src.eggGroup2 = X.eggGroup2
			src.ability1 = X.ability1
			src.ability2 = X.ability2
			if(!(src.exp in getRequiredExp(src.expGroup,src.level) to getRequiredExp(src.expGroup,src.level+1)))
				src.exp = getRequiredExp(src.expGroup,src.level)
			src.stat_calculate(TRUE)
			if(PC)
				src.HP = src.maxHP
				src.status = ""
				if(src.pName in list("Arceus","Silvally"))
					src.formChange(FALSE)
				for(var/pmove/M in src.moves)
					M.PP = M.MaxPP
		process_evolution()
			var oldType1 = "[src.type1]"
			var oldType2 = "[src.type2]"
			var oldPName = "[src.pName]"
			var oldName = "[src.name]"
			var pokemon/P = get_pokemon(src.evo,src.owner,PIDlower=src.PIDlower,PIDhigher=src.PIDhigher,shinyNum=src.shineNumber,
			hidden=(src.savedFlags & HIDDEN_ABILITY),hidden2=(src.savedFlags & HIDDEN_ABILITY_2),formID=src.formID,theGenderByte=src.genderByte,
			noLearn=TRUE)
			if(isnull(P))return // Evolution presumed invalid. Do Not Continue.
			src.ability1 = P.ability1
			src.ability2 = P.ability2
			src.sprite.icon = P.sprite.icon
			src.fsprite.icon = P.fsprite.icon
			src.bsprite.icon = P.bsprite.icon
			src.learnset = P.learnset
			src.pName = P.pName
			src.type1 = P.type1
			src.type2 = P.type2
			src.type3 = P.type3
			src.cry = P.cry
			src.pName = P.pName
			if(cmptext(oldName,oldPName))
				src.name = src.pName
			src.evo = P.evo
			src.evoType = P.evoType
			src.evoLevel = P.evoLevel
			src.evoStone = P.evoStone
			src.evoTriggerMove = P.evoTriggerMove
			src.evoItem = P.evoItem
			if(src.evoItem && istype(P.held,P.evoItem))
				P.held = null
			src.megaEvolutionX = P.megaEvolutionX
			src.megaEvolutionY = P.megaEvolutionY
			src.megaStoneX = P.megaStoneX
			src.megaStoneY = P.megaStoneY
			src.form = P.form
			src.menuIcon = P.menuIcon
			src.evoMoves = P.evoMoves
			src.stat_calculate()
			if(!length(src.learnset))
				if(type1 != oldType1)
					switch(type1)
						if(NORMAL)moves[1] = new /pmove/Tackle
						if(POISON)moves[1] = new /pmove/Acid_Spray
						if(FIRE)moves[1] = new /pmove/Ember
						if(WATER)moves[1] = new /pmove/Water_Gun
						if(GRASS)moves[1] = new /pmove/Absorb
						if(BUG)moves[1] = new /pmove/Leech_Life
						if(ROCK)moves[1] = new /pmove/Smack_Down
						if(DARK)moves[1] = new /pmove/Pursuit
						if(GROUND)moves[1] = new /pmove/Mud\-\Slap
						if(DRAGON)moves[1] = new /pmove/Twister
						if(FLYING)moves[1] = new /pmove/Gust
						if(GHOST)moves[1] = new /pmove/Lick
						if(FAIRY)moves[1] = new /pmove/Fairy_Wind
						if(STEEL)moves[1] = new /pmove/Bullet_Punch
						if(ICE)moves[1] = new /pmove/Icy_Wind
						if(PSYCHIC)moves[1] = new /pmove/Confusion
						if(ELECTRIC)moves[1] = new /pmove/Thunder_Shock
						if(FIGHTING)moves[1] = new /pmove/Power\-\Up_Punch
				if(type2 != oldType2)
					switch(type2)
						if(NORMAL)moves[2] = new /pmove/Tackle
						if(POISON)moves[2] = new /pmove/Acid_Spray
						if(FIRE)moves[2] = new /pmove/Ember
						if(WATER)moves[2] = new /pmove/Water_Gun
						if(GRASS)moves[2] = new /pmove/Absorb
						if(BUG)moves[2] = new /pmove/Leech_Life
						if(ROCK)moves[2] = new /pmove/Smack_Down
						if(DARK)moves[2] = new /pmove/Pursuit
						if(GROUND)moves[2] = new /pmove/Mud\-\Slap
						if(DRAGON)moves[2] = new /pmove/Twister
						if(FLYING)moves[2] = new /pmove/Gust
						if(GHOST)moves[2] = new /pmove/Lick
						if(FAIRY)moves[2] = new /pmove/Fairy_Wind
						if(STEEL)moves[2] = new /pmove/Bullet_Punch
						if(ICE)moves[2] = new /pmove/Icy_Wind
						if(PSYCHIC)moves[2] = new /pmove/Confusion
						if(ELECTRIC)moves[2] = new /pmove/Thunder_Shock
						if(FIGHTING)moves[2] = new /pmove/Power\-\Up_Punch
			if(oldPName=="Nincada")
				var canCreate = src.owner.party.Find(null,1,7) && src.owner.bag.getItem(/item/pokeball/Poke_Ball)
				if(canCreate)
					var pokemon/PK = get_pokemon(tName="Shedinja",S=src.owner,shinyNum=src.shineNumber,PIDlower=src.PIDlower,PIDhigher=src.PIDhigher,
					level=src.level,hidden=(src.savedFlags & HIDDEN_ABILITY),hidden2=(src.savedFlags & HIDDEN_ABILITY_2),formID=src.formID,
					highDNA=src.DNAHighValue,lowDNA=src.DNALowValue,theGenderByte=src.genderByte)
					for(var/stat in list("HP","attack","defense","spAttack","spDefense","speed"))
						PK.vars["[stat]Iv"] = src.vars["[stat]Iv"]
						PK.vars["[stat]Ev"] = src.vars["[stat]Ev"]
					for(var/j in 1 to 4)
						var pmove/M = src.moves[j]
						if(!isnull(M))
							var pmove/X = new M.type
							X.updateBonus(M.PPbonus)
							PK.moves[j] = X
						else
							PK.moves[j] = null
					src.owner.party[canCreate] = PK
			src.learn_move(TRUE)