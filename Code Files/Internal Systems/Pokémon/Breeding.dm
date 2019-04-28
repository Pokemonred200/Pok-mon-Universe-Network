/* Breeding System by Red(Pokemonred200) */
partyMon
	parent_type = /atom/movable
	var
		tmp/player/owner
		PIDlower
		PIDhigher
		nature
		// Individual Values , used for in-game stat calculation.
		HPIv
		attackIv
		defenseIv
		spAttackIv
		spDefenseIv
		speedIv
		// Determinant Values, used to prevent inbreeding and to preserve Hidden Power for Generation I and Generation II Pokémon.
		attackDV
		defenseDV
		specialDV
		speedDV
		pmove/moves[]

breedhandler
	New(player/P)
		..()
		owner = P
	var
		tmp
			player/owner
		pokemon/P1
		pokemon/P2
		Egg/theEgg
		totalSteps = 0 // reset back to whenever the references to P1 or P2 are changed to equal a different Pokémon
	proc
		reloadPokemon()
			var player/PL = src.owner
			for(var/pokemon/S in list(P1,P2))
				S.owner = PL
				S.reload(PL,TRUE)
		updateSteps()
			(!((++totalSteps)%256)) && generateEgg()
		depositMon(partypos,index)
			var pokemon/P = owner.party[partypos]
			if(isnull(P))return
			if(owner.party[partypos]==owner.walker)
				owner.walker.loc = null
				owner.walker = null
				owner.party[7] = null
			var pokemon/seventh = owner.party[7]
			owner.party[7] = null
			owner.party.Cut(partypos,partypos+1)
			owner.party.len = 7
			owner.party[7] = seventh
			src.vars["P[index]"] = P
			owner.updateDaycare()
			totalSteps = 0
		withdrawMon(index)
			var pokemon/P = src.vars["P[index]"]
			var theIndex = owner.party.Find(null,1,7)
			if(isnull(P)||(!theIndex))return
			src.vars["P[index]"] = null
			owner.party[theIndex] = P
			owner.updateDaycare()
			totalSteps = 0
		generateEgg()
			if(isnull(theEgg) && P1 && P2)
				var results[] = src.canBreed()
				var eggChance = results["chance"]
				if(eggChance && owner.bag.hasItem(/item/key/Oval_Charm))
					eggChance += 0.2
				if(results["canBreed"] && prob(eggChance))
					theEgg = new /Egg(P1,P2,owner)
		canBreed()
			if(speciesMatch(P1,P2,list("Cyndaquil","Quilava","Typhlosion"),list("Treecko","Grovyle","Sceptile")))
				return list("canBreed"=TRUE,"chance"=9.3)
			else if("Undiscovered" in list(P1.eggGroup1,P1.eggGroup2,P2.eggGroup1,P2.eggGroup2))
				return list("canBreed"=FALSE,"chance"=0)
			else if( ((P1.gender == "male") && (P2.gender == "female")) || (P1.gender == "female" && P2.gender == "male") )
				if( (P1.pName == P2.pName) )
					if(!P1.sameOT(P2))
						return list("canBreed"=TRUE,"chance"=69.3)
					else
						return list("canBreed"=TRUE,"chance"=49.5)
				else if((P1.eggGroup1 in list(P2.eggGroup1,P2.eggGroup2)) || (P1.eggGroup2 in list(P2.eggGroup1,P2.eggGroup2)))
					if(!P1.sameOT(P2))
						return list("canBreed"=TRUE,"chance"=49.5)
					else
						return list("canBreed"=TRUE,"chance"=19.8)
				else if("Ditto" in list(P1.eggGroup1,P1.eggGroup1,P2.eggGroup1,P2.eggGroup2))
					if(!P1.sameOT(P2))
						return list("canBreed"=TRUE,"chance"=49.5)
					else
						return list("canBreed"=TRUE,"chance"=19.8)
				else
					return list("canBreed"=FALSE,"chance"=0)
			else if(((P1.pName=="Ditto")&&(P2.pName!="Ditto")) || ((P1.pName!="Ditto")&&(P2.pName=="Ditto")))
				if(!P1.sameOT(P2))
					return list("canBreed"=TRUE,"chance"=49.5)
				else
					return list("canBreed"=TRUE,"chance"=19.8)
			else
				return list("canBreed"=FALSE,"chance"=0)

Egg
	parent_type = /partyMon
	New(pokemon/parent1,pokemon/parent2,player/P)
		src.owner = P
		menuIcon = icon('Region 01 Mini.dmi',"Egg")
		parent1 && parent2 && createEgg(parent1,parent2)
	Read(savefile/F)
		..()
		if(src.species=="Manaphy") // If Manaphy Egg
			src.menuIcon = icon('Region 01 Mini.dmi',"Manaphy Egg")
	var
		species
		shinyNum
		hiddenAbility
		eggCycles
		cycleStepsLeft
		eggMetDate = "December 13, 2013"
		eggMetFrom
		tmp/icon/menuIcon
	proc
		createEgg(pokemon/parent1,pokemon/parent2)
			InheritIVs(parent1,parent2)
			InheritNature(parent1,parent2)
			InheritAbility(parent1,parent2)
			PIDlower = rand(0,65535)
			PIDhigher = rand(0,65535)
			var parent2mom = FALSE
			if((parent1.pName == "Ditto") || (parent1.gender == "male"))
				species = parent2.base
				parent2mom = TRUE
				switch(parent2.pName)
					if("Snorlax")
						if(istype(parent2.held,/item/normal/incense/Full_Incense))
							species = "Munchlax"
					if("Wobbuffet")
						if(istype(parent2.held,/item/normal/incense/Lax_Incense))
							species = "Wynaut"
					if("Chansey","Blissey")
						if(istype(parent2.held,/item/normal/incense/Luck_Incense))
							species = "Happiny"
					if("Mr. Mime")
						if(istype(parent2.held,/item/normal/incense/Odd_Incense))
							species = "Mime Jr."
					if("Chimecho")
						if(istype(parent2.held,/item/normal/incense/Pure_Incense))
							species = "Chingling"
					if("Sudowoodo")
						if(istype(parent2.held,/item/normal/incense/Rock_Incense))
							species = "Bonsly"
					if("Roselia","Roserade")
						if(istype(parent2.held,/item/normal/incense/Rose_Incense))
							species = "Budew"
					if("Marill","Azumarill")
						if(istype(parent2.held,/item/normal/incense/Wave_Incense))
							species = "Azurill"
					if("Nidoran-M","Nidorino","Nidoking","Nidoran-F","Nidorina","Nidoqueen")
						species = pick("Nidoran-M","Nidoran-F")
					if("Tauros","Miltank")
						species = pick("Tauros","Miltank")
					if("Volbeat","Illumise")
						species = pick("Volbeat","Illumise")
			else if((parent2.pName == "Ditto") || (parent2.gender == "male"))
				species = parent1.base
				switch(parent1.pName)
					if("Snorlax")
						if(istype(parent1.held,/item/normal/incense/Full_Incense))
							species = "Munchlax"
					if("Wobbuffet")
						if(istype(parent1.held,/item/normal/incense/Lax_Incense))
							species = "Wynaut"
					if("Chansey","Blissey")
						if(istype(parent1.held,/item/normal/incense/Luck_Incense))
							species = "Happiny"
					if("Mr. Mime")
						if(istype(parent1.held,/item/normal/incense/Odd_Incense))
							species = "Mime Jr."
					if("Chimecho")
						if(istype(parent1.held,/item/normal/incense/Pure_Incense))
							species = "Chingling"
					if("Sudowoodo")
						if(istype(parent1.held,/item/normal/incense/Rock_Incense))
							species = "Bonsly"
					if("Roselia","Roserade")
						if(istype(parent1.held,/item/normal/incense/Rose_Incense))
							species = "Budew"
					if("Marill","Azumarill")
						if(istype(parent1.held,/item/normal/incense/Wave_Incense))
							species = "Azurill"
					if("Nidoran-M","Nidorino","Nidoking","Nidoran-F","Nidorina","Nidoqueen")
						species = pick("Nidoran-M","Nidoran-F")
					if("Tauros","Miltank")
						species = pick("Tauros","Miltank")
					if("Volbeat","Illumise")
						species = pick("Volbeat","Illumise")
			if(speciesMatch(parent1,parent2,list("Cyndaquil","Quilava","Typhlosion"),list("Treecko","Grovyle","Sceptile")))
				species = "Snivy"
			if(speciesMatch(parent1,parent2,"Latias","Latios"))
				species = pick("Latias","Latios")
			var pokemon/creationData = get_pokemon(species,src.owner,level=1)
			src.moves = creationData.moves
			var theStats = getStats(creationData)
			eggCycles = theStats["egg_cycles"]
			cycleStepsLeft = 257
			shinyNum = rand(1,8192)
			if((parent1.savedFlags & IMPORTED) && (parent2.savedFlags & IMPORTED))
				if(parent1.language != parent2.language)
					musada()
			else if((parent1.savedFlags & IMPORTED) && (!(parent2.savedFlags & IMPORTED)))
				if(parent1.language != ENGLISH)
					musada()
			else if((!(parent1.savedFlags & IMPORTED)) && (parent2.savedFlags & IMPORTED))
				if(parent2.language != ENGLISH)
					musada()
			var eggMoves = creationData.eggMoves
			if(parent2mom)InheritMoves(parent2,eggMoves,InheritMoves(parent1,eggMoves,1))
			else InheritMoves(parent1,eggMoves,InheritMoves(parent2,eggMoves,1))
			eggMetFrom = "The Pokémon Day Care Association"
			eggMetDate = "[realTime.MonthName()] [realTime.Day()], [realTime.Year()]"
			switch(src.species)
				if("Manaphy") // If Manaphy Egg
					src.menuIcon = icon('Region 01 Mini.dmi',"Manaphy Egg")
				if("Pichu") // If Pichu Egg
					if(istype(parent1.held,/item/normal/stat_item/Light_Ball) || istype(parent2.held,/item/normal/stat_item/Light_Ball))
						src.moves.Insert(1,new/pmove/Volt_Tackle)
						src.moves.len = 4
		musada()
			if(src.shinyNum!=owner.tValue)
				for(var/x in 1 to 5)
					shinyNum = rand(1,8192)
					if(src.shinyNum==owner.tValue)break
		Hatch()
			var pokemon/P = get_pokemon(tName=src.species,level=1,S=src.owner,PIDlower=src.PIDlower,PIDhigher=src.PIDhigher,shinyNum=shinyNum,
			hidden=hiddenAbility)
			P.nature = src.nature
			P.HPIv = src.HPIv
			P.attackIv = src.attackIv
			P.defenseIv = src.defenseIv
			P.spAttackIv = src.spDefenseIv
			P.spDefenseIv = src.spDefenseIv
			P.speedIv = src.speedIv
			P.moves = src.moves.Copy()
			P.attackDV = src.attackDV
			P.defenseDV = src.defenseDV
			P.specialDV = src.specialDV
			P.speedDV = src.speedDV
			P.caughtDate = "[P.caughtDate] (Egg Met: [eggMetDate])"
			P.caughtRoute = "[P.caughtRoute] (Egg Obtained From: [eggMetFrom])"
			var index = src.owner.party.Find(src)
			src.owner.party.Insert(index,P)
			src.owner.party.Cut(index+1,index+2)
			for(var/player/PL in global.online_players)
				PL.client.images |= P.sprite
			P.stat_calculate()
			src = null
			//del src
		InheritMoves(pokemon/parent,inheritList,startingPoint=1)
			if(isnull(startingPoint))return
			if(parent.pName=="Ditto")return startingPoint
			if(startingPoint==0)startingPoint=1
			if(startingPoint>4)return null
			var theMoves = splittext(inheritList,";")
			Shuffle(theMoves)
			var inheritedMoves = startingPoint
			for(var/theMove in theMoves)
				var moveType = text2path(theMove)
				if(isnull(moveType))continue
				var xCase = locate(moveType) in parent.moves
				var yCase = !(locate(moveType) in src.moves)
				if(xCase && yCase)
					src.moves.Insert(1,new theMove)
					if((++inheritedMoves)>4)break
			src.moves.len = 4
			return inheritedMoves
		InheritAbility(pokemon/parent1,pokemon/parent2)
			if((parent1.pName == "Ditto") && (parent2.gender != "female") && (parent2.savedFlags & HIDDEN_ABILITY))
				hiddenAbility = prob(80)
			else if((parent2.pName == "Ditto") && (parent1.gender != "female") && (parent1.savedFlags & HIDDEN_ABILITY))
				hiddenAbility = prob(80)
			else if((parent1.pName != "Ditto") && (parent2.gender == "female") && (parent2.savedFlags & HIDDEN_ABILITY))
				hiddenAbility = prob(60)
			else if((parent2.pName != "Ditto") && (parent1.gender == "female") && (parent1.savedFlags & HIDDEN_ABILITY))
				hiddenAbility = prob(60)
			else
				hiddenAbility = FALSE
		InheritNature(pokemon/parent1,pokemon/parent2)
			var s1 = istype(parent1.held,/item/normal/Everstone)
			var s2 = istype(parent2.held,/item/normal/Everstone)
			if((s1) && (!s2))
				nature = parent1.nature
			else if((!s1) && (s2))
				nature = parent2.nature
			else if(s1 && s2)
				nature = pick(parent1.nature,parent2.nature)
			else
				nature = pick("Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish",
				"Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm",
				"Gentle","Sassy","Careful","Quirky","Caring","Kind","Spirited","Happy","Cheerful","Peaceful"
				"Feeble","Hyper","Morbid","Rude","Stressful")
		InheritIVs(pokemon/parent1,pokemon/parent2)
			set background = 1
			var possibleStats[] = list("HP"="Power_Weight",
									   "attack"="Power_Bracer",
									   "defense"="Power_Belt",
									   "spAttack"="Power_Lens",
									   "spDefense"="Power_Band",
									   "speed"="Power_Anklet")
			var statsToInherit[0]
			if(istype(parent1.held,/item/normal/Destiny_Knot) || istype(parent2.held,/item/normal/Destiny_Knot))
				statsToInherit = 5
			else
				statsToInherit = 3
			var thePath
			var cond1
			var cond2
			for(var/stat in possibleStats.Copy())
				thePath = "/item/normal/power/[possibleStats[stat]]"
				cond1 = istype(parent1.held,text2path(thePath))
				cond2 = istype(parent2.held,text2path(thePath))
				if((cond1) && (!cond2))
					src.vars["[stat]Iv"] = parent1.vars["[stat]Iv"]
					--statsToInherit
					possibleStats -= stat
				else if((!cond1) && (cond2))
					src.vars["[stat]Iv"] = parent2.vars["[stat]Iv"]
					--statsToInherit
					possibleStats -= stat
				else if((cond1) && (cond2))
					src.vars["[stat]Iv"] = pick(parent1.vars["[stat]Iv"],parent2.vars["[stat]Iv"])
					--statsToInherit
					possibleStats -= stat
			for(var/number in 1 to statsToInherit)
				var stat = pick(possibleStats)
				src.vars["[stat]Iv"] = pick(parent1.vars["[stat]Iv"],parent2.vars["[stat]Iv]"])
				possibleStats -= stat
			for(var/stat in possibleStats)
				src.vars["[stat]Iv"] = rand(0,31)
			#if 0
			if(istype(parent1.held,/item/normal/Destiny_Knot) || istype(parent2.held,/item/normal/Destiny_Knot))
				var possibleStats[] = list("HP","attack","defense","spAttack","spDefense","speed")
				var tStat = pick(possibleStats)
				possibleStats -= tStat
				src.vars["[tStat]Iv"] = rand(0,31)
				for(var/X in possibleStats)
					src.vars["[X]Iv"] = pick(parent1.vars["[X]Iv"],parent2.vars["[X]Iv"])
			else
				var possibleStats[] = list("HP","attack","defense","spAttack","spDefense","speed")
				// Remove the non-inherited stats
				var tStat1 = pick(possibleStats)
				possibleStats -= tStat1
				var tStat2 = pick(possibleStats)
				possibleStats -= tStat2
				var tStat3 = pick(possibleStats)
				possibleStats -= tStat3
				// Determine these stats randomly
				src.vars["[tStat1]Iv"] = rand(0,31)
				src.vars["[tStat2]Iv"] = rand(0,31)
				src.vars["[tStat3]Iv"] = rand(0,31)
				// For each stat that will be inherited,
				for(var/X in possibleStats)
					src.vars["[X]Iv"] = pick(parent1.vars["[X]Iv"],parent2.vars["[X]Iv"])
			#endif

player
	proc
		DaycareOpen(ID)
			if(istype(ID,/breedhandler))
				activeDaycare = ID
			else
				activeDaycare = src.getBreedHandler("[ID]")
			updateDaycare()
			winset(src,"Daycare Window","is-visible=true")
		updateDaycare()
			if(activeDaycare.P1)
				winset(src,"Daycare Window.daycareIcon1","image=\ref[fcopy_rsc(activeDaycare.P1.menuIcon)]")
				winset(src,"Daycare Window.daycareName1",list2params(list("text"="[activeDaycare.P1.name]")))
				winset(src,"Daycare Window.daycareLevel1",list2params(list("text"="Lv.[activeDaycare.P1.level]")))
				winset(src,"Daycare Window.daycareButton1",list2params(list("text"="Take")))
			else
				winset(src,"Daycare Window.daycareIcon1","image=\"\"")
				winset(src,"Daycare Window.daycareName1",list2params(list("text"="")))
				winset(src,"Daycare Window.daycareLevel1",list2params(list("text"="")))
				winset(src,"Daycare Window.daycareButton1",list2params(list("text"="Give")))
			if(activeDaycare.P2)
				winset(src,"Daycare Window.daycareIcon2","image=\ref[fcopy_rsc(activeDaycare.P2.menuIcon)]")
				winset(src,"Daycare Window.daycareName2",list2params(list("text"="[activeDaycare.P2.name]")))
				winset(src,"Daycare Window.daycareLevel2",list2params(list("text"="Lv.[activeDaycare.P2.level]")))
				winset(src,"Daycare Window.daycareButton2",list2params(list("text"="Take")))
			else
				winset(src,"Daycare Window.daycareIcon2","image=\"\"")
				winset(src,"Daycare Window.daycareName2",list2params(list("text"="")))
				winset(src,"Daycare Window.daycareLevel2",list2params(list("text"="")))
				winset(src,"Daycare Window.daycareButton2",list2params(list("text"="Give")))
	verb
		DaycareClose()
			set hidden = 1
			activeDaycare = null
			src.client.clientFlags &= ~LOCK_MOVEMENT
		DaycareGive(index as num,partypos as num)
			set hidden = 1
			var pokemon/P = src.party[partypos]
			if(isnull(P))return
			if(istype(src.party[partypos],/Egg))
				src.ShowText("We don't accept eggs, [(P.gender=="male")?("sir"):("ma'am")].")
				return
			activeDaycare.depositMon(partypos,index)
			winset(src,"partyThing","is-visible=false")
		daycareUse(index as num)
			set hidden = 1
			var pokemon/P = activeDaycare.vars["P[index]"]
			if(!isnull(P))
				if(alert(src,"Are you sure you want to take [P] back from the day care?","Day Care","Yes!","No...")=="Yes!")
					var placeIndex = src.party.Find(null,1,7)
					if(placeIndex)
						activeDaycare.withdrawMon(index)
					else src.ShowText("You need to make space in your party if you want to do that, sir!")
			else
				for(var/x in 1 to 6)
					winset(src,"partyThing.party[x]","image=\"\";command=DaycareGive+[index]+[x]")
					var pokemon/S = src.party[x]
					if(isnull(S))continue
					winset(src,"partyThing.party[x]","image=\ref[fcopy_rsc(S.menuIcon)]")
				winset(src,"partyThing","is-visible=true")
