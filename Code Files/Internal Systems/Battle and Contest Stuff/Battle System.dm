var theButtons[] = newlist(/battle/fightButton,/battle/runButton,/battle/bagButton,/battle/pkmnButton)

var stages[] = list(1/4, 2/7, 1/3, 2/5, 1/2, 2/3, 1, 1.5, 2, 2.5, 3, 3.5, 4)

battleSystem
	New(combatant/P[],isDoubleBattle,pokemon/wild1,pokemon/wild2,importBattle=FALSE,area_type=GRASSY,storyFlagsChange=0)
		battle_area = area_type
		if(importBattle)
			src.flags |= IMPORT_BATTLE
		src.storyFlagsChange = storyFlagsChange
		src.entryHazardsP[STEALTH_ROCK] = 0
		src.entryHazardsP[SPIKES] = 0
		src.entryHazardsP[TOXIC_SPIKES] = 0
		src.entryHazardsP[STICKY_WEB] = 0
		src.entryHazardsE[STEALTH_ROCK] = 0
		src.entryHazardsE[SPIKES] = 0
		src.entryHazardsE[TOXIC_SPIKES] = 0
		src.entryHazardsE[STICKY_WEB] = 0
		var client/clients[0]
		for(var/pokemon/PKMN in list(wild1,wild2))
			for(var/x in PKMN.ivars)
				PKMN.ivars[x] = PKMN.vars[x]
		for(var/player/PL in P)
			clients += PL.client
			displayHour.removeClient(PL.client)
			displayMinute.removeClient(PL.client)
			displayAPM.removeClient(PL.client)
			PL.playerFlags |= IN_BATTLE
			PL.client.screen += PL.battleBackground
			for(var/pokemon/PKMN in PL.party)
				for(var/x in PKMN.ivars)
					PKMN.ivars[x] = PKMN.vars[x]
			switch(area_type)
				if(GRASSY)
					PL.battleBackground.icon = 'Tall Grass.png'
				if(URBAN)
					PL.battleBackground.icon = 'Indoor.png'
				if(CAVE)
					PL.battleBackground.icon = 'Cave Background.png'
				if(POND)
					PL.battleBackground.icon = 'Pond Area.png'
				if(FOREST)
					PL.battleBackground.icon = 'Forest Tall Grass.png'
				else
					PL.battleBackground.icon = 'Tall Grass.png'
		for(var/client/C in clients)
			displayHour.removeClient(C)
			displayMinute.removeClient(C)
			displayAPM.removeClient(C)
		P.len = 4 // For safety reasons
		if(!isDoubleBattle)
			chosenMoveData = list("P1"=list(pokemon=null,move=null),"E1"=list(pokemon=null,move=null))
		else
			flags |= DOUBLE_BATTLE
			chosenMoveData = list("P1"=list(pokemon=null,move=null),"P2"=list(pokemon=null,move=null),"E1"=list(pokemon=null,move=null),"E2"=list(pokemon=null,move=null))
		owner = P[1]

		if(isnull(owner.party[1]))owner.party[1] = owner.walker
		for(var/pos in 1 to 6)
			var pokemon/PKMN = owner.party[pos]
			if(isnull(PKMN))break
			else if(!istype(PKMN,/pokemon))continue
			PKMN.infoFlags &= ~HAS_LEVELED
			if(PKMN.status != FAINTED)
				P1 = PKMN
				partyPos["P1"] = pos
				ownerParticipatedList += PKMN
				if(isDoubleBattle && (pos<6))
					PKMN = owner.party[pos+1]
					ownerParticipatedList += PKMN
					if(isnull(PKMN))break
					PKMN.infoFlags &= ~HAS_LEVELED
					if(PKMN.status != FAINTED)
						P2 = PKMN
						partyPos["P2"] = pos
				break
		if(isnull(P1))
			del src
		C1 = owner.client
		C1.battle = src // Just to be sure
		hpBars += new /HPBarPlayer(P1,list(C1))

		if(P[2])
			foe = P[2]
			if(foe.client)
				flags |= PVP_BATTLE
				flags &= ~WILD_BATTLE
				C2 = foe.client
				C2.battle = src
			else
				flags |= TRAINER_BATTLE
				flags &= ~WILD_BATTLE
				var mob/NPC/NPCTrainer/trainer = foe
				E1 = trainer.parties["[ckeyEx(owner.key)]"][1]
				partyPos["E1"] = 1
				hpBars += new /HPBarEnem(E1,list(C1))
				if(isDoubleBattle && (isnull(P[3])))
					E2 = trainer.parties["[ckeyEx(owner.key)]"][2]
					partyPos["E2"] = 2
			if(P[3] && P[4])
				player3 = P[3]
				player4 = P[4]
				if(player3.client && player4.client)
					flags |= MULTI_BATTLE
					if(!(flags & DOUBLE_BATTLE))
						flags |= DOUBLE_BATTLE
					C3 = player3.client;C4 = player4.client
					C3.battle = src;C4.battle = src
				else
					flags |= TAG_BATTLE
					if(!(flags & DOUBLE_BATTLE))
						flags |= DOUBLE_BATTLE
		if(wild1)
			flags |= WILD_BATTLE
			E1 = wild1
			hpBars += new /HPBarEnem(E1,list(C1))
			if(wild2)
				if(!(flags & DOUBLE_BATTLE))
					flags |= DOUBLE_BATTLE
					E2 = wild2
					hpBars += new /HPBarEnem(E2,list(C1))
		spawn
			var cryID = 230
			var Channel = 6
			for(var/pokemon/X in list(P1,P2,E1,E2))
				if(X in list(P1,E1))
					X.fsprite.screen_loc = "14:2,8:31"
					var matrix/M = matrix();M.Scale(1.5)
					X.fsprite.transform = M
					M = matrix();M.Scale(1.5)
					X.bsprite.screen_loc = "3:12,2:16"
					X.bsprite.transform = M
					if(X==P1)
						C1.screen.Add(X.bsprite)
						if(!isnull(C3))C3.screen.Add(X.bsprite)
						if(!isnull(C2))C2.screen.Add(X.fsprite)
						if(!isnull(C4))C4.screen.Add(X.fsprite)
						if(istype(X.held,/item/normal/Amulet_Coin))
							moneyFlags |= AMULET_COIN
						else if(istype(X.held,/item/normal/incense/Luck_Incense))
							moneyFlags |= LUCK_INCENSE
					else
						C1.screen.Add(X.fsprite)
						if(!isnull(C3))C3.screen.Add(X.fsprite)
						if(!isnull(C2))C2.screen.Add(X.bsprite)
						if(!isnull(C4))C4.screen.Add(X.bsprite)
					if(X.savedFlags & SHINY)
						var image/I = image('shiny icon.dmi',"Shiny")
						I.plane = 5
						X.fsprite.overlays += I ; X.bsprite.overlays += I
						spawn(10) { X.fsprite.overlays -= I ; X.bsprite.overlays -= I}
						for(var/client/C in list(C1,C2,C3,C4))
							spawn(20) C.Audio.addSound(sound('shiny.wav',channel=Channel+4),"[cryID] Shiny Sound",TRUE)
				else if(X in list(P2,E2))
					X.fsprite.screen_loc = "17:3,8:31"
					var matrix/M = matrix();M.Scale(1.5)
					X.fsprite.transform = M
					M = matrix();M.Scale(1.5)
					X.bsprite.screen_loc = "7:4,2:16"
					X.bsprite.transform = M
					if(X==P2)
						C1.screen.Add(X.bsprite)
						if(!isnull(C3))C3.screen.Add(X.bsprite)
						if(!isnull(C2))C2.screen.Add(X.fsprite)
						if(!isnull(C4))C4.screen.Add(X.fsprite)
					else
						C1.screen.Add(X.fsprite)
						if(!isnull(C3))C3.screen.Add(X.fsprite)
						if(!isnull(C2))C2.screen.Add(X.bsprite)
						if(!isnull(C4))C4.screen.Add(X.bsprite)
					if(X.savedFlags & SHINY)
						var image/I = image('shiny icon.dmi',"Shiny")
						I.plane = 5
						X.fsprite.overlays += I ; X.bsprite.overlays += I
						spawn(10) { X.fsprite.overlays -= I ; X.bsprite.overlays -= I}
						for(var/client/C in list(C1,C2,C3,C4))
							spawn(20) C.Audio.addSound(sound('shiny.wav',channel=Channel+4),"[cryID] Shiny Sound",TRUE)
				for(var/client/C in list(C1,C2,C3,C4))
					spawn(10-Channel)
						C.Audio.addSound(sound(X.cry,channel=Channel),"[cryID]",TRUE)
						spawn(50)C.Audio.removeSound("[cryID]");C.Audio.removeSound("[cryID] Shiny Sound")
				Channel++
				cryID++

		if(!(flags & DOUBLE_BATTLE))
			P2 = new
			P2.status = FAINTED
			E2 = new
			E2.status = FAINTED
		for(var/player/PLAYER in list(owner,foe,player3,player4))
			for(var/pokemon/PKMN in PLAYER.party)
				PKMN.stat_calculate(TRUE)
				if((FLYING in list(PKMN.type1,PKMN.type2,PKMN.type3)) || ("Levitate" in list(PKMN.ability1,PKMN.ability2)) || \
				(istype(PKMN.held,/item/normal/Air_Balloon)))
					PKMN.infoFlags &= ~GROUNDED
		playMusic()
		for(var/pokemon/PK in list(P1,P2,E1,E2))
			switch(PK.pName)
				if("Burmy")
					PK.formChange()
				if("Xerneas")
					PK.fsprite.icon = getFrontImage(PK,"xerneas-active.gif")
					PK.bsprite.icon = getBackImage(PK,"xerneas-active.gif")
					PK.menuIcon = icon('Region 06 Mini.dmi',"Xerneas Active")
		beginturn()
	Del()
		for(var/client/C in list(C1,C2,C3,C4))
			displayHour.addClient(C)
			displayMinute.addClient(C)
			displayAPM.addClient(C)
		if(!successfull_start)
			stopMusic()
			return
		if(!isnull(owner))
			if((!(src.flags & PVP_BATTLE)) && ((src.flags & WILD_BATTLE) || (src.flags & BATTLE_WON)))
				if(moneyFlags&AMULET_COIN)
					payout *= 2
					payDayMoney *= 2
				if(moneyFlags&LUCK_INCENSE)
					payout *= 2
					payDayMoney *= 2
				if(moneyFlags&HAPPY_HOUR)
					payout *= 2
					payDayMoney *= 2
				src.owner.money += payout
				src.owner.money += payDayMoney
				src.owner.client.moneyLabel.Text("[src.owner.money]")
		for(var/client/C in list(C1,C2,C3,C4))
			var player/PL = C.mob
			PL.playerFlags &= ~IN_BATTLE
			for(var/screen/battleIcon/BI in C.screen)
				C.screen -= BI
			for(var/battle/B in C.screen)
				C.screen -= B
			for(var/HP_thing/H in C.screen)
				C.screen -= H
			for(var/HPBar/H in C.screen)
				del H
			C.battle = null
			PL.playerFlags &= ~IN_BATTLE
		#if 0
		for(var/HPBar/H in hpBars)
			del H
		#endif
		for(var/player/P in list(owner,foe,player3,player4))
			P.playerFlags &= ~IN_BATTLE
			P.battleBackground.icon = null
			P.client.screen -= P.battleBackground
			for(var/pokemon/PK in P.party)
				for(var/x in PK.ivars)
					PK.vars[x] = PK.ivars[x]
				PK.rageStacks = 0
				PK.ragedAttack = 0
				PK.stat_calculate(TRUE)
		if(!isnull(owner))
			var totalFainted = 0
			var totalMons = 0
			for(var/pokemon/P in owner.party)
				P.expLevel = null
				if(P.removedItem)
					P.held = P.removedItem
					P.removedItem = null
				for(var/vStatus in P.volatileStatus)
					P.volatileStatus[vStatus] = 0
				for(var/l in list("attack","defense","spAttack","spDefense","speed","accuracy","evasion"))
					P.vars["[l]Boost"] = 0
				switch(P.pName)
					if("Castform")
						P.formChange()
					if("Aegislash")
						if(P.form == "-Blade")
							var pokemon/PL = get_pokemon("Aegislash",P.owner)
							P.fsprite.icon = PL.fsprite.icon
							P.bsprite.icon = PL.bsprite.icon
							P.stats = PL.stats
							P.form = PL.form
							P.stat_calculate()
					if("Xerneas")
						P.fsprite.icon = getFrontImage(P,"xerneas.gif")
						P.bsprite.icon = getBackImage(P,"xerneas.gif")
						P.menuIcon = icon('Region 06 Mini.dmi',"Xerneas")
				for(var/pmove/M in P.moves)
					if(M.upgradeFlags & MOVE_UPGRADED)M.upgradeInitial()
				++totalMons
				if(P.status == FAINTED)
					++totalFainted
				if(P.infoFlags & HAS_LEVELED)
					P.evolve()
				P.infoFlags = (0 | GROUNDED)
				P.protectTurns = 1
				if("Pickup" in list(P.ability1,P.ability2))
					P.held = pickupGet(P)
				else if("Honey Gather" in list(P.ability1,P.ability2))
					P.held = honeyGather(P)
			if(totalMons==totalFainted)
				owner.Move(owner.respawnpoint)
				for(var/pokemon/P in owner.party)
					P.HP = P.maxHP
					for(var/pmove/M in P.moves)
						M.PP = M.MaxPP
					P.status = ""
			else
				for(var/pokemon/P in owner.party)
					if(P.caughtWith == "Heal Ball")
						if(P.status != FAINTED)
							P.status = ""
							P.HP = max(min(P.HP+(P.HP*0.05),5),P.maxHP)
							for(var/pmove/M in P.moves)
								M.PP = max(M.PP+1,M.MaxPP)

		stopMusic()

		..()
	var
		successfull_start = FALSE
		storyFlagsChange = 0
		payout = 0
		payDayMoney = 0
		weatherData = list("Weather"=CLEAR,"Turns"=0)
		battleStage[] = list("owner","foe","player3","player4")
		canCancelSwitch[] = list("owner","foe","player3","player4")
		entryHazardsP[0]
		entryHazardsE[0]
		selectedItem[] = list(
		"owner"=list(list(0,0),list(0,0)),
		"foe"=list(list(0,0),list(0,0)),
		"player3"=list(list(0,0),list(0,0)),
		"player4"=list(list(0,0),list(0,0)),
		)
		flags = 0
		clauses = 0
		runAttempts = 1
		chosenMoveData[]
		activePokemon[] = list("owner","foe","player3","player4")
		hasSwitched[] = list("owner","foe","player3","player4")
		pokemon/P1
		pokemon/P2
		pokemon/E1
		pokemon/E2
		partyPos[] = list("P1"=0,"P2"=0,"E1"=0,"E2"=0)
		client/C1
		client/C2
		client/C3
		client/C4
		battle_area = GRASSY // For Burmy, this value being Grassy will trigger Plant-Cloak, Sand triggers Sandy-Cloak, and Urban triggers Trash-Cloak.
		gravityTurns = 0
		turns = 0
		player/owner
		combatant/foe
		combatant/player3
		combatant/player4
		pokemon/ownerParticipatedList[0]
		pokemon/foeParticipatedList[0] // Used ONLY in PVP
		pokemon/player3participatedList[0]
		pokemon/player4participatedList[0]
		pmove/Struggle/pstrug1 = new
		pmove/Struggle/pstrug2 = new
		pmove/Struggle/estrug1 = new
		pmove/Struggle/estrug2 = new
		moneyFlags = 0
		allPokemonFainted = FALSE
		HPBar/hpBars[0]
	proc
		playMusic()
			src.owner.client.Audio.pauseSound("123")
			src.owner.client.Audio.removeSound("Battle Intro")
			if(src.flags & WILD_BATTLE)
				for(var/mon in list("Regirock","Regice","Registeel","Regigigas"))
					if(mon in list(E1.pName,E2.pName))
						src.owner.client.Audio.addSound(music('Regi Trio Theme.ogg',channel=5),"Battle Music",TRUE)
						return
				for(var/mon in list("Groudon","Kyogre","Rayquaza"))
					if(mon in list(E1.pName,E2.pName))
						src.owner.client.Audio.addSound(music('Weather Trio Theme.ogg',channel=5),"Battle Music",TRUE)
						return
				for(var/mon in list("Dialga","Palkia"))
					if(mon in list(E1.pName,E2.pName))
						src.owner.client.Audio.addSound(music('Dialga and Palkia.ogg',channel=5),"Battle Music",TRUE)
						return
				if("Giratina" in list(E1.pName,E2.pName))
					src.owner.client.Audio.addSound(music('Giratina Battle Theme.ogg',channel=5),"Battle Music",TRUE)
					return
				else if("Deoxys" in list(E1.pName,E2.pName))
					if(src.owner.savedPlayerFlags & GB_SOUNDS)
						src.owner.client.Audio.addSound(music('Deoxys Battle 8-bit.ogg',channel=5),"Battle Music",TRUE)
					else
						src.owner.client.Audio.addSound(music('Deoxys Battle.ogg',channel=5),"Battle Music",TRUE)
					return
				else if("Lugia" in list(E1.pName,E2.pName))
					src.owner.client.Audio.addSound(music('Lugia Battle.ogg',channel=5),"Battle Music",TRUE)
					return
				else if("Ho-Oh" in list(E1.pName,E2.pName))
					src.owner.client.Audio.addSound(music('Ho-Oh Battle.ogg',channel=5),"Battle Music",TRUE)
					return
				switch(src.owner.current_world_region)
					if(HOENN)
						src.owner.client.Audio.addSound(music('Hoenn Wild Remix.ogg',channel=5),"Battle Music",TRUE)
					if(SINNOH)
						src.owner.client.Audio.addSound(music('Sinnoh Wild Battle.ogg',channel=5),"Battle Music",TRUE)
					if(KANTO,SEVII_ISLANDS)
						src.owner.client.Audio.addSound(music('Kanto Wild Battle.ogg',channel=5),"Battle Music",TRUE)
			else if(src.flags & TRAINER_BATTLE)
				if(istype(foe,/mob/NPC/NPCTrainer/Rival))
					src.owner.client.Audio.addSound(music('pkmnrserivalremix.ogg',channel=5),"Battle Music",TRUE)
				else if(istype(foe,/mob/NPC/NPCTrainer/GymLeader))
					if(src.owner.current_world_region == "Hoenn")
						src.owner.client.Audio.addSound(music('Gym Leader.ogg',channel=5),"Battle Music",TRUE)
				else if(src.owner.current_world_region == "Hoenn")
					src.owner.client.Audio.addSound(music('Hoenn Trainer Remix.ogg',channel=5),"Battle Music",TRUE)
		stopMusic()
			src.owner.client.Audio.removeSound("Battle Music")
			src.owner.client.Audio.resumeSound("123")
		traceCheck(pokemon/tracer,pokemon/tracee)
			if(!tracer.traced)
				if(tracer.ability1 == "Trace") // Trace cannot be in the second ability slot
					if(!(tracee.ability1 in list("Trace","Multitype","Illusion","Flower Gift","Imposter","Stance Change")))
						tracer.ability2 = tracee.ability1
						tracer.traced = TRUE
						for(var/player/PL in list(owner,foe,player3,player4))
							PL.ShowText("[tracer] has copied [tracee]'s [tracee.ability1] using Trace!")
		activateEntryHazards(pokemon/P)
			var hazardsList[]
			if(P in list(P1,P2))
				hazardsList = entryHazardsP
			else
				hazardsList = entryHazardsE
			if(hazardsList[STEALTH_ROCK])
				var typeEffect = 1
				for(var/theType in list(P.type1,P.type2,P.type3))
					typeEffect *= getTypeMatchup(ROCK,theType)
				switch(typeEffect)
					if(0.125)P.HP = max(floor(P.HP-(P.maxHP/64)),0)
					if(0.25)P.HP = max(floor(P.HP-(P.maxHP/32)),0)
					if(0.5)P.HP = max(floor(P.HP-(P.maxHP/16)),0)
					if(1)P.HP = max(floor(P.HP-(P.maxHP/8)),0)
					if(2)P.HP = max(floor(P.HP-(P.maxHP/4)),0)
					if(4)P.HP = max(floor(P.HP-(P.maxHP/2)),0)
					if(8)P.HP = 1 // Absolute minimum w/o knocking out
				displayToEveryone("The floating stones have attacked [P]!")
			if(P.infoFlags & GROUNDED)
				if(hazardsList[SPIKES])
					switch(hazardsList[SPIKES])
						if(1)P.HP = max(floor(P.HP-(P.maxHP/8)),0)
						if(2)P.HP = max(floor(P.HP-(P.maxHP/6)),0)
						if(3)P.HP = max(floor(P.HP-(P.maxHP/4)),0)
					displayToEveryone("[P] has fallen into the metal spikes!")
				if(hazardsList[TOXIC_SPIKES])
					var pmove/poisoner = new
					var theSpikes = hazardsList[TOXIC_SPIKES]
					switch(theSpikes)
						if(1)poisoner.poisonTarget(P.owner.client,P)
						if(2)poisoner.poisonTarget(P.owner.client,P,badly=TRUE)
					displayToEveryone("[P] has been [(theSpikes==2)?("badly"):("")] poisoned after tumbling into the poison spikes!")
				if(hazardsList[STICKY_WEB])
					var pmove/theWeb = new
					theWeb.modStats(P.owner.client,P,"speed",-1)
					displayToEveryone("[P] has been caught in the tangled web!")
			for(var/HPBar/H in hpBars)
				if(H.P == P)
					H.updateBar()
		weatherProcess()
			switch(src.weatherData["Weather"])
				if(THUNDERSTORM)
					for(var/player/P in list(owner,foe,player3,player4))
						P.ShowText("The Thunderstorm continues...")
					for(var/pokemon/P in list(P1,P2,E1,E2))
						if(P.status != FAINTED)
							weatherDamage(P,list(ELECTRIC))
				if(SUNNY)
					for(var/player/P in list(owner,foe,player3,player4))
						P.ShowText("The Sun continues to shine...")
				if(RAINY)
					for(var/player/P in list(owner,foe,player3,player4))
						P.ShowText("The Rain continues to fall...")
				if(SANDSTORM)
					for(var/player/P in list(owner,foe,player3,player4))
						P.ShowText("The Sandstorm continues to swirl...")
					for(var/pokemon/P in list(P1,P2,E1,E2))
						if(P.status != FAINTED)
							weatherDamage(P,list(ROCK,GROUND,STEEL))
				if(HAIL)
					for(var/player/P in list(owner,foe,player3,player4))
						P.ShowText("The Hail continues to drop...")
					for(var/pokemon/P in list(P1,P2,E1,E2))
						if(P.status != FAINTED)
							weatherDamage(P,list(ICE))
				if(FOG)
					for(var/player/P in list(owner,foe,player3,player4))
						P.ShowText("The fog continues to creep...")
		weatherDamage(pokemon/P,damageExcept[])
			for(var/pokemon/PK in list(P1,P2,E1,E2))
				if("Air Lock" in list(PK.ability1,PK.ability2))return
				else if("Cloud Nine" in list(PK.ability1,PK.ability2))return
			for(var/except in damageExcept)
				if(except in list(P.type1,P.type2,P.type3))return
			if((src.weatherData["Weather"]!=THUNDERSTORM) && ("Overcoat" in list(P.ability1,P.ability2)))return
			for(var/player/PL in list(owner,foe,player3,player4))
				switch(src.weatherData["Weather"])
					if(THUNDERSTORM)
						PL.ShowText("[P.name] was struck by the thunderstorm's lightning!")
					if(HAIL)
						PL.ShowText("[P.name] was pelted by the hail!")
					if(SANDSTORM)
						PL.ShowText("[P.name] was hit by the sandstorm's rocks!")
			P.HP = floor(max(P.HP-(P.HP/16),0))
			for(var/client/CL in list(C1,C2,C3,C4))
				if(!("Normal Effective" in CL.Audio.sounds))
					CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
				CL.Audio.playSound("Normal Effective")
			for(var/HPBar/bar in hpBars)
				bar.updateBar()
			if(P.HP==0)
				P.status = FAINTED
				for(var/player/PL in list(owner,foe,player3,player4))
					PL.ShowText("[P.name] has fainted!")
				var pokemon/S = Get_Ally(P)
				if((S.status == FAINTED))
					allPokemonFainted = TRUE
		weatherBoost(pmove/A)
			. = 1
			for(var/pokemon/P in list(P1,P2,E1,E2))
				if("Air Lock" in list(P.ability1,P.ability2))return
				else if("Coud Nine" in list(P.ability1,P.ability2))return
			switch(src.weatherData["Weather"])
				if(THUNDERSTORM)
					if(A._type in list(WATER,ELECTRIC))
						. *= 1.5
					else if(A._type==FIRE)
						. *= 0.5
					if(istype(A,/pmove/Thunder))
						. *= 2
				if(RAINY)
					if(A._type == WATER)
						. *= 1.5
				if(SUNNY)
					if(A._type == FIRE)
						. *= 1.5
				if(HAIL)
					if(A._type == ICE)
						. *= 1.5
				if(SANDSTORM)
					if(A._type in list(ROCK,GROUND))
						. *= 1.5
		weatherAbilityCheck()
			var pokemon/plist[0]
			for(var/S in chosenMoveData)
				plist += chosenMoveData[S]["pokemon"]
			for(var/pokemon/P in list(P1,P2,E1,E2))
				plist += P
			if(!length(plist))return
			ls_quicksort_cmp(plist,/proc/sortRawPokemon)
			for(var/pokemon/P in plist)
				if("Drizzle" in list(P.ability1,P.ability2))
					weatherData["Weather"] = RAINY
					weatherData["Turns"] = 5
					displayToEveryone("[P.name]'s Drizzle made it rain!")
					break
				else if("Drought" in list(P.ability1,P.ability2))
					weatherData["Weather"] = SUNNY
					weatherData["Turns"] = 5
					displayToEveryone("[P.name]'s Drought intensified the sun!")
					break
				else if("Sand Stream" in list(P.ability1,P.ability2))
					weatherData["Weather"] = SANDSTORM
					weatherData["Turns"] = 5
					displayToEveryone("[P.name]'s Sand Stream whipped up a sandstorm!")
					break
				else if("Snow Warning" in list(P.ability1,P.ability2))
					weatherData["Weather"] = HAIL
					weatherData["Turns"] = 5
					displayToEveryone("[P.name]'s Snow Warning summoned a hailstorm!")
					break
				else if("Thunder Call" in list(P.ability1,P.ability2))
					weatherData["Weather"] = THUNDERSTORM
					weatherData["Turns"] = 5
					displayToEveryone("[P.name]'s Thunder Call blasted a thunderstorm!")
					break
				else if("Overcast" in list(P.ability1,P.ability2))
					weatherData["Weather"] = FOG
					weatherData["Turns"] = 5
					displayToEveryone("[P.name]'s Overcast fogged the clouds!")
					break
			for(var/pokemon/P in list(P1,P2,E1,E2))
				if(P.pName == "Castform")
					P.formChange()
		displayToEveryone(message)
			for(var/player/P in list(owner,foe,player3,player4))
				P.ShowText(message)
		beginturn()
			turns = 0
			successfull_start = TRUE
			var area/Town_Route/A = owner.loc:loc
			switch(A.weather)
				if("Rain")
					weatherData = list("Weather"=RAINY,"Turns"=1.#INF)
					displayToEveryone("The battle is downcasted with rain!")
				if("Snow")
					weatherData = list("Weather"=HAIL,"Turns"=1.#INF)
					displayToEveryone("The hail has coated the battlefield!")
				if("Sand")
					weatherData = list("Weather"=SANDSTORM,"Turns"=1.#INF)
					displayToEveryone("The sandstorm is raging in the fight!")
				else
					weatherData = list("Weather"=CLEAR,"Turns"=0)
			for(var/HPBar/HPB in hpBars)
				HPB.updateBar()
			if(src.flags & DOUBLE_BATTLE)
				chosenMoveData["P1"]["pokemon"] = P1
				chosenMoveData["P2"]["pokemon"] = P2
				chosenMoveData["E1"]["pokemon"] = E1
				chosenMoveData["E2"]["pokemon"] = E2
			else
				chosenMoveData["P1"]["pokemon"] = P1
				chosenMoveData["E1"]["pokemon"] = E1
			if(src.flags & WILD_BATTLE)
				if(src.flags & IMPORT_BATTLE)
					owner.ShowText("Wow!\n[E1.OT]'s [E1.name] is drawing close!")
				else
					owner.ShowText("A wild [E1.pName] appeared!")
			weatherAbilityCheck()
			while(src.allPokemonFainted != TRUE)
				for(var/x in battleStage)
					battleStage[x] = BATTLE_STAGE_ACTION_SELECT
				++turns
				for(var/client/C in list(C1,C2,C3,C4))
					if(C.selectButtons)
						C.screen -= C.selectButtons
						C.selectButtons = null
				for(var/pokemon/P in list(P1,P2,E1,E2))
					if(P.status==BAD_POISON)++P.bpCounter
				C1.screen += theButtons
				if(src.flags & PVP_BATTLE)
					C2.screen += theButtons
					if(src.flags & (DOUBLE_BATTLE|MULTI_BATTLE))
						C3.screen += theButtons
						C4.screen += theButtons
				else if((src.flags & WILD_BATTLE)||(src.flags & TRAINER_BATTLE))
					ai()
				src.activePokemon["owner"] = P1
				if(!isnull(foe))
					src.activePokemon["foe"] = E1
				if((!isnull(player3))&&(!isnull(player4)))
					src.activePokemon["player3"] = P2
					src.activePokemon["player4"] = E2
				waitturn()
				for(var/x in chosenMoveData)
					switch(x)
						if("P1")
							if(P1.moveState)continue
							else if(P1.volatileStatus["raging"])continue
							if(istype(chosenMoveData["P1"]["move"],/pmove/Rage))
								++P1.rageStacks
								P1.ragedAttack += 5
							else
								P1.rageStacks = max(0,P1.rageStacks - 2)
						if("P2")
							if(P2.moveState)continue
							else if(P2.volatileStatus["raging"])continue
							if(istype(chosenMoveData["P2"]["move"],/pmove/Rage))
								++P2.rageStacks
								P2.ragedAttack += 5
							else
								P2.rageStacks = max(0,P2.rageStacks - 2)
						if("E1")
							if(E1.moveState)continue
							else if(E1.volatileStatus["raging"])continue
							if(istype(chosenMoveData["E1"]["move"],/pmove/Rage))
								++E1.rageStacks
								E1.ragedAttack += 5
							else
								E1.rageStacks = max(0,E1.rageStacks - 2)
						if("E2")
							if(E2.moveState)continue
							else if(E2.volatileStatus["raging"])continue
							if(istype(chosenMoveData["E2"]["move"],/pmove/Rage))
								++E2.rageStacks
								E2.ragedAttack += 5
							else
								E2.rageStacks = max(0,E2.rageStacks - 2)
					chosenMoveData[x]["move"] = null
				weatherProcess()
				if(weatherData["Turns"]>0)
					if((--weatherData["Turns"])==0)
						switch(A.weather)
							if("Rain")
								weatherData = list("Weather"=RAINY,"Turns"=1.#INF)
								displayToEveryone("The rainstorm has returned!")
							if("Snow")
								weatherData = list("Weather"=HAIL,"Turns"=1.#INF)
								displayToEveryone("Who could have a battle without a snowy day?")
							if("Sand")
								weatherData = list("Weather"=SANDSTORM,"Turns"=1.#INF)
								displayToEveryone("Thought you could escape the sandstorm? Think again!")
							else
								weatherData = list("Weather"=CLEAR,"Turns"=0)
						for(var/pokemon/P in list(P1,P2,E1,E2))
							if(P.pName == "Castform")
								P.formChange()
				for(var/pokemon/P in list(P1,P2,E1,E2))
					P.infoFlags &= ~(FLINCHED | PROTECTED)
					if("Truant" in list(P.ability1,P.ability2))
						P.infoFlags ^= LOAFING
					if((!isnull(P.lastMoveUsed)) && (P.lastMoveUsed.type in list(/pmove/Protect,/pmove/Detect,/pmove/Wide_Guard,/pmove/King\'\s_Shield,
					/pmove/Spiky_Shield)))
						++P.protectTurns
					else
						P.protectTurns = 1
					if(P.volatileStatus[CURSED])
						P.HP = max(P.HP-(P.maxHP/4),0)
						if(P.HP==0)
							P.status = FAINTED
					if(P.status == "")
						if(!isnull(P.held))
							switch(P.held.type)
								if(/item/normal/Flame_Orb)
									if(!(FIRE in list(P.type1,P.type2,P.type3)))
										P.status = BURNED
										for(var/player/PL in list(owner,foe,player3,player4))
											PL.ShowText("[P] has been burned by the power of the Flame Orb!")
										for(var/HPBar/HPB in hpBars)
											if(HPB.P == P)
												HPB.updateBar()
								if(/item/normal/Toxic_Orb)
									if((!(POISON in list(P.type1,P.type2,P.type3))) \
									&& (!(STEEL in list(P.type1,P.type2,P.type3))) \
									&& (!("Immunity" in list(P.ability1,P.ability2))))
										P.status = BAD_POISON
										for(var/player/PL in list(owner,foe,player3,player4))
											PL.ShowText("[P] has been badly poisoned by the power of the Toxic Orb!")
										for(var/HPBar/HPB in hpBars)
											if(HPB.P == P)
												HPB.updateBar()
								if(/item/normal/Leftovers)
									if(P.status != FAINTED)
										var oldHP = P.HP
										P.HP = floor(max(min(P.HP+(P.maxHP/16),P.maxHP),0))
										if(P.HP!=oldHP)
											for(var/player/PL in list(owner,foe,player3,player4))
												PL.ShowText("[P] recovered some of \his HP with \his leftovers!")
								if(/item/normal/Black_Sludge)
									if((POISON in list(P.type1,P.type2,P.type3)) && (P.status != FAINTED))
										if(P.status != FAINTED)
											var oldHP = P.HP
											P.HP = floor(max(min(P.HP+(P.maxHP/16),P.maxHP),0))
											if(P.HP!=oldHP)
												for(var/player/PL in list(owner,foe,player3,player4))
													PL.ShowText("[P] recovered some of \his HP with \his Black Sludge!")
					if((P.status != FAINTED) && (P.HP <= (P.maxHP/2)))
						if(!isnull(P.held))
							switch(P.held.type)
								if(/item/berry/Oran_Berry)
									del P.held
									P.HP = floor(max(min(P.HP+10,P.maxHP),0))
									for(var/player/PL in list(owner,foe,player3,player4))
										PL.ShowText("[P] recovered HP with the Oran Berry!")
									for(var/HPBar/HPB in hpBars)
										if(HPB.P == P)
											HPB.updateBar()
								if(/item/berry/Sitrus_Berry)
									del P.held
									P.HP = floor(max(min(P.HP+(P.maxHP/3),P.maxHP),0))
									for(var/player/PL in list(owner,foe,player3,player4))
										PL.ShowText("[P] recovered HP with the Sitrus Berry!")
									for(var/HPBar/HPB in hpBars)
										if(HPB.P == P)
											HPB.updateBar()
			weatherData["Turns"] = 0
			weatherData["Weather"] = CLEAR
			del src
		waitforswitch(thetext)
			set background = 1
			hasSwitched[thetext] = FALSE
			while(!hasSwitched[thetext])sleep TICK_LAG
			hasSwitched[thetext] = FALSE
		waitturn()
			set background = 1 // This procedure must work in the background for technical reasons.
			if(!(src.flags & DOUBLE_BATTLE))
				for(var/client/C in list(C1,C2,C3,C4)) // This nested loop removes all movebuttons in the client's screen.
					for(var/battle/movebutton/M in C.screen)
						C.screen -= M
				while(!(chosenMoveData["P1"]["move"] && chosenMoveData["E1"]["move"])) // All moves must be chosen first.
					sleep TICK_LAG // This is here so the game doesn't lag while a move is being chosen.
				for(var/x in battleStage)
					battleStage[x] = BATTLE_STAGE_MOVE_PROCESS
				var pmove/X1 = chosenMoveData["P1"]["move"]
				var pmove/X2 = chosenMoveData["E1"]["move"]
				if(istype(X1,/pmove/Pursuit))
					if(istype(X2,/pmove/RecallProxy))
						X1.priority = 7
						X1.BP = 80
					else
						X1.BP = 40
						X1.priority = 0
				else if(istype(X2,/pmove/Pursuit))
					if(istype(X1,/pmove/RecallProxy))
						X2.priority = 7
						X2.BP = 80
					else
						X2.BP = 40
						X2.priority = 0
				src.sortMoves()
				move_loop
					for(var/move in chosenMoveData)
						var pmove/A = chosenMoveData[move]["move"]
						for(var/client/C in list(C1,C2,C3,C4))
							var pokemon/P
							switch(move)
								if("P1")P=P1
								if("E1")P=E1
							if(P.status != FAINTED)
								if(!(A.type in list(/pmove/RecallProxy,/pmove/CaptureProxy,/pmove/ItemUseProxy,/pmove/EscapeProxy)))
									if(!(P.infoFlags & LOAFING))
										if(P.status!=ASLEEP)
											A.displayToSystem(C1,"[P] used [A]")
										else
											A.displayToSystem(C1,"[P] is fast asleep!")
									else
										var messageType = pick("is loafing around!","is being lazy!","won't get up!","is taking [genderGet(P,"his")] time!")
										A.displayToSystem(C1,"[P] [messageType]")
										continue move_loop
								if(move=="P1")
									if(P1.status==FAINTED)break
									if(!(A.type in list(/pmove/Fly,/pmove/Dig)))
										if(!(istype(A,/pmove/Rage) && (E1.rageStacks > 0)))
											A.PP = max(A.PP-(("Pressure" in list(E1.ability1,E1.ability2))?(2):(1)),0)
									A.effect(C1,P1,E1)
									A.afterEffect(C1,P1,E1)
								else
									if(E1.status==FAINTED)break
									if(!(A.type in list(/pmove/Fly,/pmove/Dig)))
										if(istype(A,/pmove/Rage) && (P1.rageStacks > 0))
											A.PP = max(A.PP-(("Pressure" in list(P1.ability1,P1.ability2))?(2):(1)),0)
									A.effect(C1,E1,P1)
									A.afterEffect(C1,E1,P1)
				if(P1.status == FAINTED)
					var foundPokemon = FALSE
					for(var/x in 1 to 6)
						var pokemon/P = owner.party[x]
						if(isnull(P))break
						else if(!istype(P,/pokemon))continue
						if(P.status != FAINTED)
							foundPokemon = TRUE
							break
					if(foundPokemon)
						forceSwitch(owner)
						waitforswitch("owner")
					else
						src.allPokemonFainted = TRUE
				if(E1.status == FAINTED)
					if(src.flags & WILD_BATTLE)
						src.allPokemonFainted = TRUE
					else
						if(src.partyPos["E1"]<6)
							++src.partyPos["E1"]
							ownerParticipatedList.len = 0
							ownerParticipatedList += P1
							var pokemon/PKMN
							if(istype(foe,/mob/NPC/NPCTrainer))
								var mob/NPC/NPCTrainer/NT = src.foe
								var thePos = src.partyPos["E1"]
								PKMN = NT.parties["[ckeyEx(owner.key)]"][thePos]
							else
								PKMN = src.foe.party[src.partyPos]
							if(isnull(PKMN)) // All of the Pokemon Are Indeed Fainted
								if(istype(foe,/mob/NPC/NPCTrainer))
									src.flags |= BATTLE_WON
									var mob/NPC/NPCTrainer/NPC = src.foe
									if(!("[NPC.type]" in owner.story.defeatedTrainers))
										owner.story.defeatedTrainers["[NPC.type]"] = list()
									owner.story.defeatedTrainers["[NPC.type]"] |= NPC.theID
									NPC.parties -= "[ckeyEx(owner.key)]"
									payout = NPC.basePay * E1.level
									if(istype(foe,/mob/NPC/NPCTrainer/GymLeader))
										var mob/NPC/NPCTrainer/GymLeader/GML = NPC
										owner.story.badgesObtained |= GML.badge_given
								allPokemonFainted = TRUE
							else
								for(var/HPBar/HPB in hpBars)
									if(HPB.P == E1)
										HPB.changePKMN(PKMN)
								PKMN.fsprite.screen_loc = E1.fsprite.screen_loc
								PKMN.bsprite.screen_loc = E1.bsprite.screen_loc
								PKMN.fsprite.transform = E1.fsprite.transform
								PKMN.bsprite.transform = E1.bsprite.transform
								for(var/client/C in list(C1,C2))
									if(C==C1)
										C.screen += PKMN.fsprite
										C.screen -= E1.fsprite
									else if(C==C2)
										C.screen -= E1.bsprite
										C.screen += PKMN.bsprite
								E1 = PKMN
								activateEntryHazards(E1)
								chosenMoveData["E1"]["pokemon"] = E1
						else
							src.allPokemonFainted = TRUE
							if(istype(foe,/mob/NPC/NPCTrainer))
								src.flags |= BATTLE_WON
								var mob/NPC/NPCTrainer/NPC = src.foe
								if(!("[NPC.type]" in owner.story.defeatedTrainers))
									owner.story.defeatedTrainers["[NPC.type]"] = list()
								owner.story.defeatedTrainers["[NPC.type]"] |= NPC.theID
								NPC.parties -= "[ckeyEx(owner.key)]"
								if(istype(foe,/mob/NPC/NPCTrainer/GymLeader))
									var mob/NPC/NPCTrainer/GymLeader/GML = NPC
									owner.story.badgesObtained |= GML.badge_given
								payout = NPC.basePay * E1.level
			else
				var goBattle = FALSE
				while(!goBattle)
					goBattle = TRUE // If goBattle = FALSE hasn't been executed within this loop, this will remain true.
					for(var/pokemon/P in list(P1,P2,E1,E2))
						if(FAINTED != P.status)
							if(P==P1 && !chosenMoveData["P1"]["move"])
								goBattle = FALSE
							if(P==P2 && !chosenMoveData["P2"]["move"])
								goBattle = FALSE
							if(P==E1 && !chosenMoveData["E1"]["move"])
								goBattle = FALSE
							if(P==E2 && !chosenMoveData["E2"]["move"])
								goBattle = FALSE
						sleep TICK_LAG
				src.sortMoves()
				for(var/move in chosenMoveData)
					for(var/x in battleStage)
						battleStage[x] = BATTLE_STAGE_MOVE_PROCESS
					var pmove/A = chosenMoveData[move]["move"]
					if(move in list("P1","P2"))
						A.PP = max(A.PP-(("Pressure" in list(E1.ability1,E1.ability2,E2.ability1,E2.ability2))?(2):(1)),0)
						if(move=="P1")
							if(A.effect(C1,P1,A.target) && (!(A.battleFlags & SHEER_FORCE)))
								A.secondaryEffect(C1,P1,A.target)
							A.afterEffect(C1,P1,A.target)
						else
							if(A.effect(C1,P2,A.target) && (!(A.battleFlags & SHEER_FORCE)))
								A.secondaryEffect(C1,P2,A.target)
							A.afterEffect(C1,P2,A.target)
					else
						A.PP = max(A.PP-(("Pressure" in list(P1.ability1,P1.ability2,P2.ability1,P2.ability2))?(2):(1)),0)
						if(move=="E1")
							if(A.effect(C1,E1,A.target) && (!(A.battleFlags & SHEER_FORCE)))
								A.secondaryEffect(C1,E1,A.target)
							A.afterEffect(C1,E1,A.target)
						else
							if(A.effect(C1,E2,A.target) && (!(A.battleFlags & SHEER_FORCE)))
								A.secondaryEffect(C1,E1,A.target)
							A.afterEffect(C1,E1,A.target)
				if(P1.status == FAINTED && P2.status == FAINTED)
					src.allPokemonFainted = TRUE
				else if(E1.status == FAINTED && E2.status == FAINTED)
					src.allPokemonFainted = TRUE

		sortMoves() // Sort the move and priority order of the pokémon; speed is sorted first, and priority is sorted afterward.
			ls_quicksort_cmp_a(chosenMoveData,/proc/sortPokemon)
			ls_quicksort_cmp_a(chosenMoveData,/proc/sortMoves)

		faintPokemon(pokemon/A,pokemon/B) // B is the fainted Pokémon.
			B.status = FAINTED
			for(var/client/C in list(C1,C2,C3,C4))
				C.Audio.addSound(sound(B.cry,channel=1),"234",TRUE)
				spawn(50) C.Audio.removeSound("234")
			RewardExp(A,B,src)

		CritCheck(pmove/A,pokemon/B,pokemon/C)
			if(A.name == "Confusion Damage")return 0
			if("Battle Armor" in list(C.ability1,C.ability2))
				return 0
			else if("Shell Armor" in list(C.ability1,C.ability2))
				return 0
			else if(C.infoFlags & LUCKY_CHANT)
				return 0
			if(A.type in list(/pmove/Frost_Breath,/pmove/Storm_Throw))return 1
			var critStage = 0
			if(A.highCrit)critStage += 1
			if(B.infoFlags & FOCUSED)critStage += 2
			var returnValue
			switch(critStage)
				if(0)
					returnValue = prob(6.25)
				if(1)
					returnValue = prob(12.5)
				if(2)
					returnValue = prob(50)
				else
					returnValue = TRUE
			return returnValue
		ai()
			if(flags & PVP_BATTLE)return
			if(!(flags & DOUBLE_BATTLE))
				var useMoves[0]
				for(var/pmove/M in E1.moves)
					if(M.PP <= 0)continue
					useMoves += M
				chosenMoveData["E1"]["move"] = (useMoves.len)?(pick(useMoves)):(estrug1)
			else
				var pmove/useMoves1[0]
				var pmove/useMoves2[0]
				for(var/pmove/M in E1.moves)
					if(M.PP <= 0)continue
					useMoves1 += M
				for(var/pmove/M in E2.moves)
					if(M.PP <= 0)continue
					useMoves2 += M
				chosenMoveData["E1"]["move"] = (useMoves1.len)?(pick(useMoves1)):(estrug1)
				chosenMoveData["E2"]["move"] = (useMoves2.len)?(pick(useMoves2)):(estrug2)
				var pokemon/targets1[0]
				var pokemon/targets2[0]
				for(var/pokemon/P in list(P1,P2))
					if(P.status != FAINTED)
						targets1 += P
						targets2 += P
				var pmove/M = chosenMoveData["E1"]["move"]
				M.target = pick(targets1)
				M = chosenMoveData["E2"]["move"]
				M.target = pick(targets2)
		Get_Type_Effect(pmove/A,pokemon/B,pokemon/C)
			var returnType = 1
			var moveType
			if(istype(A,/pmove))
				moveType = A._type
			else if(istext(A))
				moveType = A
			else
				throw EXCEPTION("This information could not be resolved to a move type.")
			var abilityCancel = abilityCancel(B)
			for(var/monType in list(C.type1,C.type2,C.type3))
				switch(monType)
					if(GHOST)
						if((C.infoFlags & FORESIGHT) && ( (moveType in list(NORMAL,FIGHTING)) || ((!abilityCancel) && \
						("Scrappy" in list(C.ability1,C.ability2))) ))
							returnType *= 1
						else
							returnType *= getTypeMatchup(moveType,monType)
					if(DARK)
						if((C.infoFlags & MIRACLE_EYE) && (moveType==PSYCHIC))
							returnType *= 1
						else
							returnType *= getTypeMatchup(moveType,monType)
					if(GROUND)
						if(((!abilityCancel) && ("Hard Wired" in list(C.ability1,C.ability2))) && (moveType == ELECTRIC))
							returnType *= 1
						else
							returnType *= getTypeMatchup(moveType,monType)

					else
						returnType *= getTypeMatchup(moveType,monType)
			. = returnType
		forceSwitch(client/C)
			var player/P
			if(istype(C,/player))
				P = C
			else
				P = C.mob
			canCancelSwitch[getPlayerText(P)] = FALSE
			P.updatePartySwap()
			for(var/x in 1 to 6)
				winset(P,"PartySwap.partySwap[x]","command=battleSwap+[x]+1")
			winset(P,"PartySwap","is-visible=true")
		Get_Ally(pokemon/A)
			ASSERT(A in list(P1,P2,E1,E2))
			if(A == P1). = P2
			else if(A == P2). = P1
			else if(A == E1). = E2
			else if(A == E2). = E1
		getPlayerMatch(client/C)
			var player/P
			if(istype(C,/player))
				P = C
			else
				P = C.mob
			ASSERT(P in list(owner,foe,player3,player4))
			if(P==owner). = owner
			else if(P==foe). = foe
			else if(P==player3). = player3
			else if(P==player4). = player4
		getPlayerText(client/C)
			var player/P
			if(istype(C,/player))
				P = C
			else
				P = C.mob
			ASSERT(P in list(owner,foe,player3,player4))
			if(P==owner). = "owner"
			else if(P==foe). = "foe"
			else if(P==player3). = "player3"
			else if(P==player4). = "player4"
		getPokemonText(pokemon/P)
			ASSERT(P in list(P1,P2,E1,E2))
			if(P==P1). = "P1"
			else if(P==P2). = "P2"
			else if(P==E1). = "E1"
			else if(P==E2). = "E2"
		getMatchingStruggle(pokemon/P)
			ASSERT(P in list(P1,P2,E1,E2))
			if(P==P1)return src.pstrug1
			else if(P==P2)return src.pstrug2
			else if(P==E1)return src.estrug1
			else if(P==E2)return src.estrug2
		Accuracy_Check(pmove/A,pokemon/B,pokemon/C,extraReturn/mReason=new)
			if(isnull(A.Acc))
				mReason.value = 0
				return 1
			var abilityCancel = abilityCancel(C)
			if(!abilityCancel)
				var pokemon/S = Get_Ally(B)
				if("No Guard" in list(B.ability1,B.ability2,S.ability1,S.ability2))
					mReason.value = 0
					return 1
				if("True Talent" in list(B.ability1,B.ability2))
					if(A.range == SPECIAL)
						mReason.value = 0
						return 1
			var weatherBlock = FALSE
			for(var/pokemon/PK in list(P1,P2,E1,E2))
				if(!abilityCancel)
					if("Air Lock" in list(PK.ability1,PK.ability2))
						weatherBlock = TRUE
						break
					else if("Cloud Nine" in list(PK.ability1,PK.ability2))
						weatherBlock = TRUE
						break
			if(!weatherBlock)
				if(weatherData["Weather"] in list(RAINY,THUNDERSTORM))
					if(A.type in list(/pmove/Thunder,/pmove/Hurricane))
						mReason.value = 0
						return 1
			var tAcc = A.Acc/100
			var accuracy = (B.accuracy*stages[B.accuracyBoost+7])/100
			var evasion = (stages[C.evasionBoost+7])/100
			var P = floor(((tAcc)*(accuracy/evasion))*100)
			if(!weatherBlock)
				if(weatherData["Weather"]==FOG)P *= 0.9
			if(C.moveState & FLIGHT)
				if(!weatherBlock)
					if(A.type in list(/pmove/Thunder,/pmove/Hurricane))
						mReason.value = 2
						return 1
					else return 0
				else
					mReason.value = 2
					return 0
			if(C.infoFlags & PROTECTED)
				var player/PL
				if(A.protectEffect)
					mReason.value = 3
					if(C in list(C1,C2))
						for(var/client/CL in list(C1,C3))
							PL = CL.mob
							PL.ShowText("[C] protected \herself!")
						for(var/client/CL in list(C2,C4))
							PL = CL.mob
							PL.ShowText("Enemy [C] protected \herself!")
					else
						for(var/client/CL in list(C1,C3))
							PL = CL.mob
							PL.ShowText("Enemy [C] protected \herself!")
						for(var/client/CL in list(C2,C4))
							PL = CL.mob
							PL.ShowText("[C] protected \herself!")
					return FALSE
				else
					for(var/client/CL in list(C1,C2,C3,C4))
						PL = CL.mob
						PL.ShowText("[B]'s [A] broke through their protection!")
			var retVal = prob(P)
			var player/M
			if(retVal==0)
				mReason.value = 1
				if(B in list(P1,P2))
					for(var/client/CL in list(C1,C3))
						M = CL.mob
						M.ShowText("[B]'s attack missed!")
					for(var/client/CL in list(C2,C4))
						M = CL.mob
						M.ShowText("Enemy [B]'s attack missed!")
				else
					for(var/client/CL in list(C2,C4))
						M = CL.mob
						M.ShowText("Enemy [B]'s attack missed!")
					for(var/client/CL in list(C1,C3))
						M = CL.mob
						M.ShowText("[B]'s attack missed!")
			. = retVal
		abilityCancel(pokemon/B)
			var pokemon/P = Get_Ally(B)
			var x = ("Mold Breaker" in list(B.ability1,B.ability2,P.ability1,P.ability2))
			var y = ("Teravolt" in list(B.ability1,B.ability2,P.ability1,P.ability2))
			var z = ("Turboblaze" in list(B.ability1,B.ability2,P.ability1,P.ability2))
			return (x || y || z)
		Damage_Calculate(pmove/A,pokemon/B,pokemon/C)
			var abilityCancel = abilityCancel(B)
			if((!abilityCancel) && (A.hasSecondaryEffect))
				if("Sheer Force" in list(B.ability1,B.ability2))
					A.battleFlags |= SHEER_FORCE
				else if("Serene Grace" in list(B.ability1,B.ability2))
					A.battleFlags |= SERENE_GRACE
			var other = 1 // For the modifier
			if(A.range == PHYSICAL)
				if(istype(B.held,/item/normal/choice/Choice_Band))
					other *= 1.5
				else if(istype(B.held,/item/normal/stat_item/Muscle_Band))
					other *= 1.1
				if((!abilityCancel) && (("Huge Power" in list(B.ability1,B.ability2)) || ("Pure Power" in list(B.ability1,B.ability2))))
					other *= 2
				else if((!abilityCancel) && ("Guts" in list(B.ability1,B.ability2)))
					if(B.status in list(BURNED,PARALYZED,POISONED,BAD_POISON,ASLEEP)) // Sleep included because of Sleep Talk
						other *= 1.5
				else if(B.status == BURNED)
					other *= 0.5
			else if(A.range == SPECIAL)
				if(istype(B.held,/item/normal/choice/Choice_Specs))
					other *= 1.5
				else if(istype(B.held,/item/normal/stat_item/Wise_Glasses))
					other *= 1.1
			var STAB = 1
			var typeEffect = 1
			if(A.recoilDamage>0)
				if((!abilityCancel) && ("Reckless" in list(B.ability1,B.ability2)))
					other *= 2
			if(A._type in list(B.type1,B.type2,B.type3))
				STAB = ((!abilityCancel) && ("Adaptability" in list(B.ability1,B.ability2)))?(2):(1.5)
			if(B.held)
				switch(B.held.type)
					if(/item/normal/plate/Draco_Plate)if(A._type==DRAGON)other *= 1.2
					if(/item/normal/plate/Dread_Plate)if(A._type==DARK)other *= 1.2
					if(/item/normal/plate/Earth_Plate)if(A._type==GROUND)other *= 1.2
					if(/item/normal/plate/Fist_Plate)if(A._type in list(FIGHTING,FPRESS))other *= 1.2
					if(/item/normal/plate/Flame_Plate)if(A._type==FIRE)other *= 1.2
					if(/item/normal/plate/Icicle_Plate)if(A._type==ICE)other *= 1.2
					if(/item/normal/plate/Insect_Plate)if(A._type==BUG)other *= 1.2
					if(/item/normal/plate/Iron_Plate)if(A._type==STEEL)other *= 1.2
					if(/item/normal/plate/Meadow_Plate)if(A._type==GRASS)other *= 1.2
					if(/item/normal/plate/Mind_Plate)if(A._type==PSYCHIC)other *= 1.2
					if(/item/normal/plate/Pixie_Plate)if(A._type==FAIRY)other *= 1.2
					if(/item/normal/plate/Shock_Plate)if(A._type==ELECTRIC)other *= 1.2
					if(/item/normal/plate/Sky_Plate)if(A._type in list(FLYING,FPRESS,NPRESS,EPRESS))other *= 1.2
					if(/item/normal/plate/Shine_Plate)if(A._type==LIGHT)other *= 1.2
					if(/item/normal/plate/Splash_Plate)if(A._type==WATER)other *= 1.2
					if(/item/normal/plate/Spooky_Plate)if(A._type==GHOST)other *= 1.2
					if(/item/normal/plate/Stone_Plate)if(A._type==ROCK)other *= 1.2
					if(/item/normal/plate/Toxic_Plate)if(A._type==POISON)other *= 1.2

			if(istype(A,/pmove/Flying_Press))
				if((!abilityCancel) && ("Normalize" in list(B.ability1,B.ability2)))
					A._type = NPRESS
				else if(B.volatileStatus[ELECTRIFIED]>0)
					A._type = EPRESS
				else
					A._type = FPRESS

			if(istype(A,/pmove/Freeze\-\Dry))
				if(WATER in list(C.type1,C.type2,C.type3))
					typeEffect = 2
				else
					typeEffect = Get_Type_Effect(A,B,C)
			else if(istype(A,/pmove/Flying_Press))
				if(( FIGHTING in list(B.type1,B.type2,B.type3) ) || ( FLYING in list(B.type1,B.type2,B.type3)) )
					STAB = ((!abilityCancel) && ("Adapatability" in list(B.ability1,B.ability2)))?(2):(1.5)
				typeEffect = Get_Type_Effect(A,B,C)
			else
				if((!abilityCancel) && ("Normalize" in list(B.ability1,B.ability2)))
					typeEffect = Get_Type_Effect(NORMAL,B,C)
				else if(B.volatileStatus[ELECTRIFIED]>0)
					typeEffect = Get_Type_Effect(ELECTRIC,B,C)
				else if(A._type == NORMAL)
					if((!abilityCancel) && ("Aerilate" in list(B.ability1,B.ability2)))
						typeEffect = Get_Type_Effect(FLYING,B,C)
					else if((!abilityCancel) && ("Pixilate" in list(B.ability1,B.ability2)))
						typeEffect = Get_Type_Effect(FAIRY,B,C)
					else if((!abilityCancel) && ("Refrigerate" in list(B.ability1,B.ability2)))
						typeEffect = Get_Type_Effect(ICE,B,C)
				else
					typeEffect = Get_Type_Effect(A,B,C)

			var critThing = (CritCheck(A,B,C))?(TRUE):(FALSE)

			var attack
			var defense
			var stageMod

			if(A.range==PHYSICAL)
				stageMod = stages[B.attackBoost+7]
				if(critThing)stageMod = max(stageMod,1)
				attack = (B.attack*defeatist(B))*stageMod
				attack += B.ragedAttack // this is a permanent bonus
			else
				stageMod = stages[B.spAttackBoost+7]
				if(critThing)stageMod = max(stageMod,1)
				attack = (B.spAttack*defeatist(B))*stageMod

			switch(A._type)
				if(NORMAL)if(istype(B.held,/item/normal/gem/Normal_Gem)){other *= 1.5;B.held=null}
				if(FIRE)if(istype(B.held,/item/normal/gem/Fire_Gem)){other *= 1.5;B.held=null}
				if(WATER)if(istype(B.held,/item/normal/gem/Water_Gem)){other *= 1.5;B.held=null}
				if(GRASS)if(istype(B.held,/item/normal/gem/Grass_Gem)){other *= 1.5;B.held=null}
				if(ELECTRIC)if(istype(B.held,/item/normal/gem/Electric_Gem)){other *= 1.5;B.held=null}
				if(ROCK)if(istype(B.held,/item/normal/gem/Rock_Gem)){other *= 1.5;B.held=null}
				if(GHOST)if(istype(B.held,/item/normal/gem/Ghost_Gem)){other *= 1.5;B.held=null}
				if(FIGHTING)if(istype(B.held,/item/normal/gem/Fighting_Gem)){other *= 1.5;B.held=null}
				if(POISON)if(istype(B.held,/item/normal/gem/Poison_Gem)){other *= 1.5;B.held=null}
				if(FLYING)if(istype(B.held,/item/normal/gem/Flying_Gem)){other *= 1.5;B.held=null}
				if(FAIRY)if(istype(B.held,/item/normal/gem/Fairy_Gem)){other *= 1.5;B.held=null}
				if(DRAGON)if(istype(B.held,/item/normal/gem/Dragon_Gem)){other *= 1.5;B.held=null}
				if(ICE)if(istype(B.held,/item/normal/gem/Ice_Gem)){other *= 1.5;B.held=null}
				if(BUG)if(istype(B.held,/item/normal/gem/Bug_Gem)){other *= 1.5;B.held=null}
				if(GROUND)if(istype(B.held,/item/normal/gem/Ground_Gem)){other *= 1.5;B.held=null}
				if(DARK)if(istype(B.held,/item/normal/gem/Dark_Gem)){other *= 1.5;B.held=null}
				if(PSYCHIC)if(istype(B.held,/item/normal/gem/Psychic_Gem)){other *= 1.5;B.held=null}

			if(B.pName=="Pikachu")
				if(istype(B.held,/item/normal/stat_item/Light_Ball))
					attack *= 2

			if(A.defendType==PHYSICAL)
				stageMod = stages[C.defenseBoost+7]
				if(critThing)stageMod = min(stageMod,1)
				defense = C.defense*stageMod
			else if(A.defendType==SPECIAL)
				stageMod = stages[C.spDefenseBoost+7]
				if(critThing)stageMod = min(stageMod,1)
				defense = C.spDefense*stageMod
			else // This is for Asura Strike's un-named damage type. This move will effectively deal True Damage (a mechanic from League of Legends)
				defense = 1

			if(weatherData["Weather"] == SANDSTORM)
				var weatherBlocked = FALSE
				for(var/pokemon/P in list(P1,P2,E1,E2))
					if((!abilityCancel) && (("Air Lock" in list(P.ability1,P.ability2)) || ("Cloud Nine" in list(P.ability1,P.ability2))))
						weatherBlocked = TRUE
						break
				if(!weatherBlocked)
					if(ROCK in list(C.type1,C.type2,C.type3))
						if(A.defendType==SPECIAL)
							defense *= 2
					if(ROCK in list(B.type1,B.type2,B.type3))
						if(A.range==PHYSICAL)
							attack *= 1.5

			if(B.name in list("Latias","Latios"))
				if(istype(B.held,/item/normal/stat_item/Soul_Dew))
					other *= 1.5

			if(C.evo || (C.pName == "Eevee"))
				if(istype(C.held,/item/normal/stat_item/Eviolite))
					defense *= 1.5
			if(!abilityCancel(C))
				if(A._type==ELECTRIC)
					if(!("Hard Wired" in list(B.ability1,B.ability2)))
						other *= 1.3
			if(A._type == GROUND)
				if(!(C.infoFlags & GROUNDED))
					other *= 0
			if(A.name != "Confusion Damage")
				if(!abilityCancel)
					if(A._type in list(FIRE,ICE))
						if("Thick Fat" in list(C.ability1,C.ability2))
							other *= 1.5
					if(A._type == FIRE)
						if("Heatproof" in list(C.ability1,C.ability2))
							other *= 0.5
						else if("Dry Skin" in list(C.ability1,C.ability2))
							other *= 1.25
					if(A._type == ELECTRIC)
						if("Volt Absorb" in list(C.ability1,C.ability2))
							other *= 0
							C.HP = min(C.HP * 1.25,C.maxHP)
					if(A._type == WATER)
						if( ( "Water Absorb" in list(C.ability1,C.ability2) ) || ( "Dry Skin" in list(C.ability1,C.ability2) ))
							other *= 0
							C.HP = min(C.HP * 1.25,C.maxHP)
					if(A.BP <= 60)
						if("Technician" in list(B.ability1,B.ability2))
							other *= 1.5
					if(typeEffect < 2) // Not Super-Effective
						if("Wonder Guard" in list(C.ability1,C.ability2))
							other *= 0
					else
						if( ("Solid Rock" in list(C.ability1,C.ability2)) || ("Filter" in list(C.ability1,C.ability2)) )
							other *= 0.75
					if(A.contact)
						if("Tough Claws" in list(C.ability1,C.ability2))
							other *= 1.3
					else
						if("Infusion" in list(C.ability1,C.ability2))
							other *= 1.3
					if(A.Punch_Move)
						if("Iron Fist" in list(C.ability1,C.ability2))
							other *= 1.5
			if((A._type == ELECTRIC) && (B.infoFlags & CHARGED))
				B.infoFlags &= ~CHARGED
				other *= 2

			other *= weatherBoost(A)

			var critDamage = critThing ? 2 : 1

			if((!abilityCancel) && ("Sniper" in list(B.ability1,B.ability2)))
				critDamage *= 1.5

			#if defined(DEBUG) && defined(PUNDEBUG)
			world << "This move's crit damage will be: [critDamage]"
			#endif

			var retVal[0]

			var modifier = STAB * typeEffect * critDamage * other * ((100-rand(0,15))/100)

			var damage = floor((((2*B.level+10)/(250))*(attack/defense)*A.BP+2)*modifier)

			retVal["TypeEffect"] = typeEffect
			retVal["Damage"] = damage
			retVal["Critical"] = critThing

			if((!abilityCancel) && (A._type==POISON) && ("Toxic Theft" in list(B.ability1,B.ability2)))
				var healAmount = (C.status in list(POISONED,BAD_POISON))?(0.75):(0.5)
				B.HP = min(B.HP+(damage*healAmount),B.maxHP)

			#if defined(DEBUG) && defined(PUNDEBUG)
			world << "This move will do [retVal["Damage"]] to its target."
			world << "It has a type effectiveness of [retVal["TypeEffect"]] and its critical hit value is [retVal["Critical"]]."
			#endif

			return retVal