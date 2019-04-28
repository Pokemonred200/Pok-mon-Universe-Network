var selectableMovesByType[]

pmove
	parent_type = /atom/movable
	desc = "Research is currently underway as to determine what this move does. Currently, it is believed to have no use."
	var
		tmp
			_type = UNKNOWN
			range = STATUS
			contestType = BEAUTY
			BP
			Acc //If an attack "never misses", don't define its accuracy. Null will be the equivalent of never missing.
			recoilDamage = 0
			Absorber
			AbsorbHeal = 0.5
			priority = 0
			pokemon/target // Reference to the target in Double Battles
			contact = null
			soundMove = 0
			Punch_Move = 0
			Snatchable = 0
			Defrost    = 0
			protectEffect = TRUE
			Reflected_by_Magic = 0
			Blocked  = 1
			Copyable = 1
			highCrit = FALSE
			Spore_Move = FALSE
			disabled = FALSE
			letLive = FALSE
			hasSecondaryEffect = FALSE // Specifically for Serene Grace and Sheer Force
			battleFlags = 0 // For abilities like Serene Grace and Sheer Force
			defendType // For moves like Secret Sword, which calculates with Sp. Attack but Physical Defense.
			upgrade_info = ""
		PP = 0
		MaxPP = 0
		PPbonus = 0
		upgradeFlags = 0

	New()
		..()
		if(isnull(defendType))
			defendType = range
		if((range==PHYSICAL)&&isnull(contact))contact = TRUE
		//incase you want to provide code for when attacks are instantiated.

	proc
		canForget(player/P)return TRUE
		getPriority(client/C,pokemon/P)
			var finalPriority = src.priority
			if("Gale Wings" in list(P.ability1,P.ability2))
				if(src._type == FLYING)
					++finalPriority
			if("Prankster" in list(P.ability1,P.ability2))
				if(src.range == STATUS)
					++finalPriority
			return finalPriority
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			if(battleFlags & SHEER_FORCE)return FALSE
			else return TRUE
		missEffect(client/C,pokemon/A,pokemon/D,extraReturn/mReason)
			if(mReason.value == 1)
				return TRUE
			else
				return FALSE
		updateBonus(theBonus)
			if(MaxPP==1)return 0
			theBonus = max(min(theBonus,3),0)
			PPbonus = theBonus
			var initMaxPP = initial(MaxPP)
			var PPtoAdd = (initMaxPP/5)*theBonus
			var oldMaxPP = MaxPP
			MaxPP = initMaxPP+PPtoAdd
			if((PP==oldMaxPP) || (PP > MaxPP))
				PP = MaxPP
			return 1
		displayToSystem(client/C,showtext)
			for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
				var player/P = CL.mob
				P.ShowText(showtext)
		upgrade()
			if((upgradeFlags & MOVE_UPGRADEABLE) && (!(upgradeFlags & MOVE_UPGRADED)))
				upgradeFlags |= MOVE_UPGRADED
				upgradeFlags &= ~MOVE_UPGRADEABLE
				return TRUE
		upgradeInitial() // For moves that change their info for an upgrade
		burnTarget(client/C,pokemon/A,pokemon/D,useAcc)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D))
						displayToSystem(C,"But it missed!")
						return FALSE
				A = D
			var showMessage
			if(A.status != "")
				showMessage = (A.status==FAINTED)?(""):("But it failed!")
			else
				if(FIRE in list(A.type1,A.type2,A.type3))
					showMessage = "[A] cannot be burned since \he's a Fire-Type Pokémon!"
				else
					A.status = BURNED
					showMessage = "[A] has been burned!"
			if(showMessage)
				displayToSystem(C,showMessage)
		blindTarget(client/C,pokemon/A,pokemon/D,useAcc)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D))
						displayToSystem(C,"But it missed!")
				A = D
			var showMessage
			if(A.volatileStatus[BLINDED])
				showMessage = "[A] is already blinded!"
			else
				showMessage = "[A] was blinded! \His attacks can now miss."
			if(showMessage)
				displayToSystem(C,showMessage)
		sleepTarget(client/C,pokemon/A,pokemon/D,useAcc,minTurns=2,maxTurns=7)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D))
						displayToSystem(C,"But it missed!")
						return FALSE
				A = D
			var showMessage
			if(A.status != "")
				showMessage = (A.status==FAINTED)?(""):("But it failed!")
			else
				if("Insomnia" in list(A.ability1,A.ability2))
					showMessage = "[A] cannot be put asleep due to \his Insomnia!"
				else if("Vital Spirit" in list(A.ability1,A.ability2))
					showMessage = "[A] cannot be put asleep due to \his Vital Spirit!"
				else
					showMessage = "[A] has fallen asleep!"
					A.status = ASLEEP
					A.sleepTurns = rand(minTurns,maxTurns)
			if(showMessage)
				displayToSystem(C,showMessage)
		freezeTarget(client/C,pokemon/A,pokemon/D,useAcc)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D))
						displayToSystem(C,"But it missed!")
						return FALSE
				A = D
			var showMessage
			if(A.status != "")
				showMessage = (A.status==FAINTED)?(""):("But it failed!")
			else
				if(ICE in list(A.type1,A.type2,A.type3))
					showMessage = "[A] cannot be frozen as \he's an Ice-Type pokémon!"
				else if(FIRE in list(A.type1,A.type2,A.type3))
					showMessage = "[A] cannot be frozen as \he's a Fire-Type pokémon!"
				else
					showMessage = "[A] has been frozen solid!"
					A.status = FROZEN
			if(showMessage)
				displayToSystem(C,showMessage)
		paralyzeTarget(client/C,pokemon/A,pokemon/D,useAcc)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D))
						displayToSystem(C,"But it missed!")
						return FALSE
				A = D
			var showMessage = ""
			if(A.status != "")
				showMessage = (A.status==FAINTED)?(""):("But it failed!")
			else
				if(ELECTRIC in list(A.type1,A.type2,A.type3))
					showMessage = "[A] cannot be paralyzed as \he's an Electric-Type Pokémon!"
				else
					if((src._type == ELECTRIC) && (GROUND in list(A.type1,A.type2,A.type3)))
						showMessage = "[A] is a Ground type and \he cannot be paralyzed by Electric-Type moves!"
					else
						A.status = PARALYZED
						showMessage = "[A] has been paralyzed! \He may be unable to move!"
			displayToSystem(C,showMessage)
		poisonTarget(client/C,pokemon/A,pokemon/D,useAcc,badly)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D))
						displayToSystem(C,"But it missed!")
						return FALSE
				A = D
			var showMessage
			if(A.status != "")
				showMessage = (A.status==FAINTED)?(""):("But it failed!")
			else
				if(POISON in list(A.type1,A.type2,A.type3))
					showMessage = "[A] cannot be poisoned since \he's a Poison-Type Pokémon!"
				else if(STEEL in list(A.type1,A.type2,A.type3))
					showMessage = "[A] cannot be poisoned since \he's a Steel-Type Pokémon!"
				else if("Immunity" in list(A.ability1,A.ability2))
					showMessage = "[A] cannot be poisoned because of \his Immunity ability!"
				else
					if(badly)
						A.status = BAD_POISON
						A.bpCounter = 1
						showMessage = "[A] has been badly posioned!"
					else
						A.status = POISON
						A.bpCounter = 0
						showMessage = "[A] has been poisoned!"
			displayToSystem(C,showMessage)
		confuseTarget(client/C,pokemon/A,pokemon/D,useAcc=TRUE)
			if(D)
				if(useAcc)
					if(!C.battle.Accuracy_Check(src,A,D,new/extraReturn))
						displayToSystem(C,"But it missed!")
						return FALSE
				A = D
			var showMessage
			if(A.volatileStatus[CONFUSED])
				showMessage = "[A.name] is already confused!"
			else
				A.volatileStatus[CONFUSED] = rand(1,4)
				showMessage = "[A.name] has been confused!"
			displayToSystem(showMessage)
		modStats(client/C,pokemon/D,stat,stages)
			var oldValue = D.vars["[stat]Boost"]
			var contrary = ("Contrary" in list(D.ability1,D.ability2))?(TRUE):(FALSE)
			if(contrary)
				stages = -stages
			D.vars["[stat]Boost"] = (stages>1)?(min(D.vars["[stat]Boost"]+stages,6)):(max(D.vars["[stat]Boost"]+stages,-6))
			var tstat
			switch(stat)
				if("spAttack")tstat = "Special Attack"
				if("spDefense")tstat = "Special Defense"
				else tstat = capitalize(stat)
			var endMessage = (contrary)?(" due to [genderGet(D,"her")] Contrary"):("")
			var displayMessage
			if(oldValue==D.vars["[stat]Boost"])
				if(stages>1)
					displayMessage = "[D]'s [tstat] can't go any higher[endMessage]!"
				else
					displayMessage = "[D]'s [tstat] can't go any lower[endMessage]!"
			else
				switch(stages)
					if(1)
						displayMessage = "[D.name]'s [tstat] rose[endMessage]!"
					if(2)
						displayMessage = "[D.name]'s [tstat] sharply rose[endMessage]!"
					if(3)
						displayMessage = "[D.name]'s [tstat] drastically rose[endMessage]!"
					if(4)
						displayMessage = "[D.name]'s [tstat] amazingly rose[endMessage]!"
					if(5)
						displayMessage = "[D.name]'s [tstat] incredibly rose[endMessage]!"
					if(6)
						displayMessage = "[D.name]'s [tstat] was maximized[endMessage]!"
					if(-1)
						displayMessage = "[D.name]'s [tstat] fell[endMessage]!"
					if(-2)
						displayMessage = "[D.name]'s [tstat] harshly fell[endMessage]!"
					if(-3)
						displayMessage = "[D.name]'s [tstat] severely fell[endMessage]!"
					if(-4)
						displayMessage = "[D.name]'s [tstat] pathetically fell[endMessage]!"
					if(-5)
						displayMessage = "[D.name]'s [tstat] grimly fell[endMessage]!"
					if(-6)
						displayMessage = "[D.name]'s [tstat] was minimized[endMessage]!"
			displayToSystem(C,displayMessage)

		getDamage()
			return BP

		getAccuracy()
			return Acc

		effect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = TRUE
			if(extraEffect)
				if(D.infoFlags & FLINCHED)
					displayToSystem(C,"[D] has flinched!")
					return FALSE
				var item/I = A.held
				if(src.disabled==TRUE)return FALSE
				var showMessage
				switch(A.status)
					if(FROZEN)
						if((isnull(I)) || (!(I.type in list(/item/berry/Aspear_Berry,/item/berry/Lum_Berry))))
							if(prob(20))
								showMessage = "[A] thawed out!"
								A.status = ""
							else
								showMessage = "[A] is frozen!"
								return FALSE
						else
							showMessage = "[A] was thawed out by the effects of the [I] berry!"
							A.status = ""
							A.held = null
							del I
					if(ASLEEP)
						if((isnull(I)) || (!(I.type in list(/item/berry/Chesto_Berry,/item/berry/Lum_Berry))))
							if((--A.sleepTurns)<=0)
								showMessage = "[A] woke up!"
								A.status = ""
							else
								showMessage = "[A] is asleep!"
								return FALSE
						else
							showMessage = "[A] was awoken by the effects of the [I] berry!"
							A.status = ""
							A.held = null
							del I
					if(PARALYZED)
						if((isnull(I)) || (!(I.type in list(/item/berry/Cheri_Berry,/item/berry/Lum_Berry))))
							if(prob(50))
								showMessage = "[A] is paralyzed and \he can't move!"
								return FALSE
						else
							showMessage = "[A] was cured of paralysis by the [I] berry!"
							A.status = ""
							A.held = null
							del I
				if(A.volatileStatus[BLINDED])
					if(prob(50))
						displayToSystem(C,"[A]'s attack missed because \she was blinded!")
						. = FALSE
				if(A.volatileStatus[CONFUSED]>0)
					--A.volatileStatus[CONFUSED]
					displayToSystem(C,"[A.name] is confused!")
					var pmove/M = new
					M.name = "Confusion Damage" // In the battle damage calculation, abilities and critical hits will be ignored
												// if the name of the move is 'Confusion Damage'.
					M._type = UNKNOWN
					M.range = (A.attack>A.spAttack)?(PHYSICAL):(SPECIAL)
					M.Acc = null
					M.defendType = PHYSICAL
					M.BP = 40
					M.doDamage(C,A,A)
					if(prob(50))
						displayToSystem(C,"[A] hurt \himself in \his confusion!")
						. = FALSE
				if(showMessage)displayToSystem(C,showMessage)
			if("Sap Sipper" in list(D.ability1,D.ability2))
				if(GRASS in list(D.type1,D.type2,D.type3))
					displayToSystem(C,"[D]'s Sap Sipper makes it immune to Grass-Type moves!")
					modStats(C,D,"attack",1)
			if(src.Spore_Move)
				if(GRASS in list(D.type1,D.type2,D.type3))
					displayToSystem(C,"[D]'s Grass typing makes it immune to spore moves!")
					return FALSE
				else if("Overcoat" in list(D.ability1,D.ability2))
					displayToSystem(C,"[D]'s Overcoat ability makes it immune to spore moves!")
					return FALSE
			for(var/HPBar/HPB in C.battle.hpBars)
				if(HPB.P == A)
					HPB.updateBar()
			if(A.HP==0)
				A.status = FAINTED
				displayToSystem(C,"[A] has fainted!")
				RewardExp(D,A,C.battle)
				return FALSE
			if(.)
				if(src.soundMove)
					if("Soundproof" in list(D.ability1,D.ability2))
						displayToSystem(C,"[D]'s Soundproof makes it immune to [A]'s [src]!")
						return FALSE
					else if("Cacophony" in list(D.ability1,D.ability2))
						displayToSystem(C,"[D]'s Cacophony makes it immune to [A]'s [src]!")
						return FALSE
				A.lastMoveUsed = src

		afterEffect(client/C,pokemon/A,pokemon/D)
			var item/I = A.held
			var showMessage = ""
			switch(A.status)
				if(POISONED)
					if((isnull(I)) || (!(I.type in list(/item/berry/Pecha_Berry,/item/berry/Lum_Berry))))
						var resultDamage = A.maxHP*(1/16)
						A.HP = max(round(A.HP-resultDamage),0)
						showMessage = "[A] was hurt by [genderGet(A,"his")] poison!"
					else
						showMessage = "[A] was cured of [genderGet(A,"his")] poisoning by the [I] berry!"
						A.status = ""
						A.held = null
						del I
				if(BAD_POISON)
					if((isnull(I)) || (!(I.type in list(/item/berry/Pecha_Berry,/item/berry/Lum_Berry))))
						var resultDamage = (A.maxHP*(1/16))*A.bpCounter
						A.HP = max(round(A.HP-resultDamage),0)
						showMessage = "[A] was hurt [genderGet(A,"his")] bad poisoning!"
					else
						showMessage = "[A] was cured of [genderGet(A,"his")] bad poisoning by the [I] berry!"
						A.status = ""
						A.held = null
						del I
						A.bpCounter = 0
				if(BURNED)
					if((isnull(I)) || (!(I.type in list(/item/berry/Rawst_Berry,/item/berry/Lum_Berry))))
						A.HP = max(round(A.HP-(A.maxHP*(1/8))),0)
						showMessage = "[A] was hurt by [genderGet(A,"his")] burn!"
					else
						showMessage = "[A] was cured of [genderGet(A,"his")] burn by the [I] berry!"
						A.status = ""
						A.held = null
						del I
			if(showMessage)
				displayToSystem(C,showMessage)

		recoverHealth(client/C,pokemon/A)
			if(!(src.type in list(/pmove/Moonlight,/pmove/Synthesis,/pmove/Morning_Sun)))
				if(!istype(src,/pmove/Recharge))
					A.HP = min(A.HP+ceil(A.maxHP/2),A.maxHP)
				else
					if(A.infoFlags & CHARGED)
						A.HP = A.maxHP
					else
						A.HP = min(A.HP+ceil(A.maxHP/2),A.maxHP)
			else
				switch(C.battle.weatherData["Weather"])
					if(SUNNY)
						A.HP = min(A.HP+ceil((A.maxHP*2)/3),A.maxHP)
					if(RAINY,SANDSTORM,HAIL,THUNDERSTORM,FOG)
						A.HP = min(A.HP+ceil(A.maxHP/4),A.maxHP)
					else
						A.HP = min(A.HP+ceil(A.maxHP/2),A.maxHP)
			for(var/HPBar/HPB in C.battle.hpBars)
				if(HPB.P==A)
					HPB.updateBar()
			displayToSystem(C,"[A] recovered health!")

		fixedDamage(client/C,pokemon/A,pokemon/D,damage)
			. = FALSE
			if((A.pName=="Aegislash") && (A.form != "-Blade"))
				var pokemon/P = get_pokemon("Aegislash-Blade",A.owner)
				A.form = P.form
				A.fsprite.icon = P.fsprite.icon
				A.bsprite.icon = P.bsprite.icon
				A.stats = P.stats
				A.stat_calculate()
			var battleSystem/battle = C.battle
			if(battle.Accuracy_Check(src,A,D))
				. = TRUE
				if(istype(C.battle.chosenMoveData[C.battle.getPokemonText(D)]["move"],/pmove/Rage))
					++D.rageStacks
					D.ragedAttack += 5
					displayToSystem(C,"[D]'s rage is getting stronger...")
				if(battle.Get_Type_Effect(src,A,D)!=0)
					D.HP = max(D.HP-damage,0)
					if(src.letLive==TRUE)
						D.HP = max(D.HP,1)
					if(!(battleFlags & SHEER_FORCE))
						if(istype(A.held,/item/normal/Shell_Bell))
							var theRecovery = ceil(damage/8)
							A.HP = min(A.HP+theRecovery,A.maxHP)
							displayToSystem(C,"[A] recovered health using its Shell Bell!")
					for(var/HPBar/HPB in battle.hpBars)
						if(HPB.P in list(A,D))
							HPB.updateBar()
					for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
						if(!("Normal Effective" in CL.Audio.sounds))
							CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
						CL.Audio.playSound("Normal Effective")
					if(D.HP == 0)battle.faintPokemon(A,D)
					else secondaryEffect(C,A,D)
				else
					displayToSystem(C,"It had no effect!")

		multiHit(client/C,pokemon/A,pokemon/D,minHits=2,maxHits=5)
			. = FALSE
			if((A.pName=="Aegislash") && (A.form != "-Blade"))
				var pokemon/P = get_pokemon("Aegislash-Blade",A.owner)
				A.form = P.form
				A.fsprite.icon = P.fsprite.icon
				A.bsprite.icon = P.bsprite.icon
				A.stats = P.stats
				A.stat_calculate()
			var battleSystem/battle = C.battle
			var extraReturn/ETR = new
			if(battle.Accuracy_Check(src,A,D,ETR))
				. = TRUE
				var totalHits = rand(minHits,maxHits)
				var timesHit = 0
				var damage[]
				for(var/x in 1 to totalHits)
					++timesHit
					damage = battle.Damage_Calculate(src,A,D)
					if(damage["Critical"])
						displayToSystem(C,"It's a critical hit!")
					for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
						switch(damage["TypeEffect"])
							if(0)break
							if(1)
								if(!("Normal Effective" in CL.Audio.sounds))
									CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
								CL.Audio.playSound("Normal Effective")
							if(2 to 1.#INF)
								if(!("Super Effective" in CL.Audio.sounds))
									CL.Audio.addSound(sound('super_effective.wav'),"Super Effective")
								CL.Audio.playSound("Super Effective")
							if(-1.#INF to 0.5)
								if(!("Not Very Effective" in CL.Audio.sounds))
									CL.Audio.addSound(sound('not_effective.wav'),"Not Very Effective")
								CL.Audio.playSound("Not Very Effective")
							else
								if(!("Normal Effective" in CL.Audio.sounds))
									CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
								CL.Audio.playSound("Normal Effective")
					if(istype(C.battle.chosenMoveData[C.battle.getPokemonText(D)]["move"],/pmove/Rage))
						++D.rageStacks
						D.ragedAttack += 5
						displayToSystem(C,"[D]'s rage is building...")
					D.HP = max((D.HP - abs(damage["Damage"])),0)
					if(src.letLive==TRUE)
						D.HP = max(D.HP,1)
					if(src.Absorber==TRUE)A.HP = ceil(min(A.HP+min(max(min(damage["Damage"]*AbsorbHeal,D.maxHP/2),0)),A.maxHP))
					if(!(battleFlags & SHEER_FORCE))
						if(istype(A.held,/item/normal/Shell_Bell))
							var theRecovery = ceil(damage["Damage"]/8)
							A.HP = min(A.HP+theRecovery,A.maxHP)
							displayToSystem(C,"[A] recovered health using its Shell Bell!")
					for(var/HPBar/HPB in battle.hpBars)
						if(HPB.P in list(A,D))
							HPB.updateBar()
					if(D.HP == 0)
						battle.faintPokemon(A,D)
						break
					else
						secondaryEffect(C,A,D)
					sleep 1
				for(var/player/P in list(battle.owner,battle.foe,battle.player3,battle.player4))
					P.ShowText("Hit [timesHit] time\s!")
					switch(damage["TypeEffect"])
						if(0)
							P.ShowText("It had no effect!")
						if(1)
						if(2 to 1.#INF)
							P.ShowText("It's Super Effective!")
						if(0.5 to -1.#INF)
							P.ShowText("It's Not Very Effective...")
		doDamage(client/C,pokemon/A,pokemon/D)
			. = FALSE
			if((A.pName=="Aegislash") && (A.form != "-Blade"))
				var pokemon/P = get_pokemon("Aegislash-Blade",A.owner)
				A.form = P.form
				A.fsprite.icon = P.fsprite.icon
				A.bsprite.icon = P.bsprite.icon
				A.stats = P.stats
				A.stat_calculate()
			var battleSystem/battle = C.battle
			var extraReturn/mReason = new
			if(battle.Accuracy_Check(src,A,D,mReason))
				. = TRUE
				var damage[] = battle.Damage_Calculate(src,A,D)
				if(damage["Critical"])
					displayToSystem(C,"It's a critical hit!")
				for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
					var/player/P = CL.mob
					switch(damage["TypeEffect"])
						if(1)
							if(!("Normal Effective" in CL.Audio.sounds))
								CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
							CL.Audio.playSound("Normal Effective")
						if(2 to 1.#INF)
							P.ShowText("It's Super Effective!")
							if(!("Super Effective" in CL.Audio.sounds))
								CL.Audio.addSound(sound('super_effective.wav'),"Super Effective")
							CL.Audio.playSound("Super Effective")
						if(-1.#INF to 0.5)
							if(damage["TypeEffect"]!=0)
								P.ShowText("It's Not Very Effective...")
								if(!("Not Very Effective" in CL.Audio.sounds))
									CL.Audio.addSound(sound('not_effective.wav'),"Not Very Effective")
								CL.Audio.playSound("Not Very Effective")
							else
								P.ShowText("It had no effect!")
						else
							if(!("Normal Effective" in CL.Audio.sounds))
								CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
							CL.Audio.playSound("Normal Effective")
				if(istype(C.battle.chosenMoveData[C.battle.getPokemonText(D)]["move"],/pmove/Rage))
					++D.rageStacks
					D.ragedAttack += 5
					displayToSystem(C,"[A]'s rage is building...")
				D.HP = max((D.HP - abs(damage["Damage"])),0)
				if(src.letLive==TRUE)
					D.HP = max(D.HP,1)
				if(src.Absorber==TRUE)A.HP = min(A.HP+ceil(damage["Damage"]*AbsorbHeal),A.maxHP)
				if(src.recoilDamage>0)
					if(!("Rock Head" in list(A.ability1,A.ability2)))
						var theRecoil = round(damage["Damage"]*(1/recoilDamage))
						A.HP = max(A.HP-theRecoil,0)
						displayToSystem(C,"[A] was hit by recoil damage!")
				if(!(battleFlags & SHEER_FORCE))
					if(istype(A.held,/item/normal/Shell_Bell))
						var theRecovery = ceil(damage["Damage"]/8)
						A.HP = min(A.HP+theRecovery,A.maxHP)
						displayToSystem(C,"[A] recovered health using its Shell Bell!")
				for(var/HPBar/HPB in battle.hpBars)
					if(HPB.P in list(A,D))
						HPB.updateBar()
				if(D.HP == 0)
					battle.faintPokemon(A,D)
				else
					secondaryEffect(C,A,D)
			else
				missEffect(C,A,D,mReason)

/*The following comments represent which group of moves that start with
the following letters are finished or required to be finished:*/
//Finished letters are counting moves existing during Pokémon Black, White, Black 2, and White 2.
//Letters Done w/ exception of unavaiable info: A B C X Y Z
//Letters that Require info in desc var:		D E F G
//Letters Required:								H I J K L M N O P Q R S T U V W
//Note that a review of these moves must be made due to incomplete information on Bulbapedia

	Absorb
		_type = GRASS
		range = SPECIAL
		contestType = SMART
		PP = 25
		MaxPP = 25
		BP = 40
		Acc = 100
		Absorber = TRUE
		desc = "A nutrient-draining attack. The user's HP is restored by half the damage taken by the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Accelerock
		_type = ROCK
		range = SPECIAL
		contestType = SMART
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		priority = 1
		desc = "The user smashes into the target at high speed. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Acid
		_type = POISON
		range = SPECIAL
		contestType = SMART
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100
		desc = "The opposing Pokémon are attacked with a spray of harsh acid. This may also lower their Sp. Def stats."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE) ? (20) : (10)
				if(prob(chance))
					modStats(C,D,"spDefense",-1)

	Acid_Armor
		_type = POISON
		range = STATUS
		contestType = TOUGH
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user alters its cellular structure to liquefy itself, sharply raising its Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",2)

	Acid_Spray
		_type = POISON
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		desc = "The user spits fluid that works to melt the target. This harshly lowers the target's Sp. Def stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,D,"spDefense",-2)

	Acrobatics
		_type = FLYING
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 55
		Acc = 100
		desc = "The user nimbly strikes the target. If the user is not holding an item, this attack inflicts massive damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Acupressure
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user applies pressure to stress points, sharply boosting one of its or its allies' stats."

	Aerial_Ace
		_type = FLYING
		range = PHYSICAL
		contestType = COOL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = null
		desc = "The user confounds the target with speed, then slashes. This attack never misses."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Aeroblast
		_type = FLYING
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 95
		highCrit = TRUE
		desc = "A vortex of air is shot at the target to inflict damage. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	After_You
		_type = NORMAL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user helps the target and makes it use its move right after the user."

	Agility
		_type = PSYCHIC
		range = STATUS
		contestType = COOL
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user relaxes and lightens its body to move faster. This sharply raises the Speed stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"speed",2)

	Air_Cutter
		_type = FLYING
		range = SPECIAL
		contestType = COOL
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 95
		highCrit = TRUE
		desc = "The user launches razor-like wind to slash the opposing Pokémon. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Air_Slash
		_type = FLYING
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 75
		Acc = 95
		desc = "The user attacks with a blade of air that slices even the sky. This may also make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(60):(30)
				if(prob(chance))
					D.infoFlags |= FLINCHED

	Ally_Switch
		_type = PSYCHIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		priority = 1
		desc = "This move is usually used to swap places with an ally, but because Triple Battles have run out of style, the move is only used in Contests."

	Amnesia
		_type = PSYCHIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user temporarily empties its mind to forget its concerns. This sharply raises the user's Sp. Def stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spDefense",2)

	Ancient_Power
		_type = ROCK
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 60
		Acc = 100
		desc = "The user attacks with a prehistoric power. It may also raise all the user's stats at once."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					modStats(C,A,"attack",1)
					modStats(C,A,"defense",1)
					modStats(C,A,"spAttack",1)
					modStats(C,A,"spDefense",1)
					modStats(C,A,"speed",1)

	Aqua_Jet
		_type = WATER
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		priority = 1
		desc = "The user lunges at the target speed that makes it almost invisible. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Aqua_Ring
		_type = WATER
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user envelops itself in a veil made of water. It regains some HP every turn."

	Aqua_Tail
		_type = WATER
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 90
		desc = "The user attacks by swinging its tail as if it were a vicious wave in a raging storm."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Arclight_Tumble // LEAGUE REFERENCE! Hehehehehehe
		_type = LIGHT
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 100
		highCrit = TRUE
		desc = "The user charges itself with powerful light and tumbles into the foe to attack with its claws. This move has a high critical hit ratio."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Arm_Thrust
		_type = FIGHTING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 15
		Acc = 100
		desc = "The user lets loose a flurry of open-palmed arm thrusts that hit two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D)

	Aromatherapy
		_type = GRASS
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "The user releases a soothing scent that heals all status problems affecting the user's party."

	Aromatic_Mist
		_type = FAIRY
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user raises the Sp. Def stat of ally Pokémon with a mysterious aroma."

	Assist
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user hurriedly and randomly uses a move among those known by other Pokémon in the party."

	Assurance
		_type = DARK
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 60
		Acc = 100
		desc = "If the target has already taken some damage in the same turn, this attack's power is doubled."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Astonish
		_type = GHOST
		range = PHYSICAL
		contestType = SMART
		PP = 15
		MaxPP = 15
		BP = 30
		Acc = 100
		desc = "The user attacks the target while shouting in a startling fashion. This may also make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(60):(30)
				if(prob(chance))
					D.infoFlags |= FLINCHED

	Asura_Strike
		_type = UNKNOWN
		range = PHYSICAL
		defendType = CRUSH // CRUSH is an exclusive defendType that causes a move scaling off of physical or special attack to not scale based off of defenses.
		contestType = TOUGH
		PP = 1
		MaxPP = 1
		BP = 1000000
		Acc = null
		desc = "The user unleashes a violent attack on the foe with power so monstrous it's terrifying."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Attack_Order
		_type = BUG
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		highCrit = TRUE
		desc = "The user calls out its underlings to pummel the target. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Attract
		_type = NORMAL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "If it is the opposite gender of the user, the target becomes infatuated and less likely to attack."

	Aura_Sphere
		_type = FIGHTING
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 80
		Acc = null
		desc = "The user lets loose a blast of aura power from deep within its body at the target. This attack never misses."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Aurora_Beam
		_type = ICE
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		desc = "The target is hit with a rainbow-colored beam. This may also lower the target's Attack stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					modStats(C,D,"attack",-1)

	Autotomize
		_type = STEEL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user sheds part of its body to make itself lighter and sharply raise its Speed stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"speed",2)

	Avalanche
		_type = ICE
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 60
		Acc = 100
		desc = "An attack move that inflicts double the damage if the user has been hurt by the target in the same turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Baby\-\Doll_Eyes
		_type = FAIRY
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100
		priority = 1
		desc = "The user stares at the target with its baby-doll eyes, which lowers its Attack stat. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"attack",-1)

	Barrage
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 15
		Acc = 85
		desc = "Round objects are hurled at the target to strike two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D)

	Barrier
		_type = PSYCHIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user throws up a sturdy wall that sharply raises its Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"defense",2)

	Baton_Pass
		_type = NORMAL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The user switches places with a party Pokémon in waiting and passes along any stat changes."

	Beat_Up
		_type = DARK
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The user gets all party Pokémon to attack the target. The more party Pokémon, the greater the number of attacks."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = FALSE
				if((A.pName=="Aegislash") && (A.form != "-Blade"))
					var pokemon/P = get_pokemon("Aegislash-Blade",A.owner)
					A.form = P.form
					A.fsprite.icon = P.fsprite.icon
					A.bsprite.icon = P.bsprite.icon
					A.stats = P.stats
					A.stat_calculate()
				var battleSystem/battle = C.battle
				if(battle.Accuracy_Check(src,A,D))
					. = TRUE
					var pokemonThing[0]
					var player/PL = battle.getPlayerMatch(C)
					var totalHits = 0
					for(var/i in 1 to 6)
						var pokemon/P = PL.party[i]
						if(istype(P,/pokemon) && (P.status != FAINTED))
							pokemonThing[++totalHits] = P
					var timesHit = 0
					var damage[]
					for(var/x in 1 to totalHits)
						var pokemon/P = pokemonThing[++timesHit]
						displayToSystem(C,"[P]'s attack!")
						var theStats = getStats(P)
						BP = ceil(theStats["atk"] / 10 + 5)
						damage = battle.Damage_Calculate(src,A,D)
						#if defined(DEBUG) && defined(PUNDEBUG)
						world << "The critical hit value is: [damage["Critical"]]"
						#endif
						if(damage["Critical"] != 0)
							displayToSystem(C,"It's a critical hit!")
						for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
							switch(damage["TypeEffect"])
								if(0)break
								if(1)
									if(!("Normal Effective" in CL.Audio.sounds))
										CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
									CL.Audio.playSound("Normal Effective")
								if(2 to 1.#INF)
									if(!("Super Effective" in CL.Audio.sounds))
										CL.Audio.addSound(sound('super_effective.wav'),"Super Effective")
									CL.Audio.playSound("Super Effective")
								if(-1.#INF to 0.5)
									if(!("Not Very Effective" in CL.Audio.sounds))
										CL.Audio.addSound(sound('not_effective.wav'),"Not Very Effective")
									CL.Audio.playSound("Not Very Effective")
								else
									if(!("Normal Effective" in CL.Audio.sounds))
										CL.Audio.addSound(sound('normaldamage.wav'),"Normal Effective")
									CL.Audio.playSound("Normal Effective")
						D.HP = max((D.HP - abs(damage["Damage"])),0)
						if(src.Absorber==TRUE)P.HP = ceil(min(P.HP+min(max(min(damage["Damage"]/2,P.maxHP/2),0)),P.maxHP))
						if(!(battleFlags & SHEER_FORCE))
							if(istype(P.held,/item/normal/Shell_Bell))
								var theRecovery = ceil(damage["Damage"]/8)
								P.HP = min(P.HP+theRecovery,A.maxHP)
								displayToSystem(C,"[P] recovered health using its Shell Bell!")
						for(var/HPBar/HPB in battle.hpBars)
							if(HPB.P in list(A,D))
								HPB.updateBar()
						if(D.HP == 0)
							D.status = FAINTED
							for(var/client/CX in list(battle.C1,battle.C2,battle.C3,battle.C4))
								CX.Audio.addSound(sound(D.cry,channel=1),"234",TRUE)
								spawn(50) CX.Audio.removeSound("234")
							RewardExp(A,D,battle)
							break
						sleep 1
					for(var/player/PLAY in list(battle.owner,battle.foe,battle.player3,battle.player4))
						PLAY.ShowText("Hit [timesHit] time\s!")
						switch(damage["TypeEffect"])
							if(0)
								PLAY.ShowText("It had no effect!")
							if(1)
							if(2 to 1.#INF)
								PLAY.ShowText("It's Super Effective!")
							if(0.5 to -1.#INF)
								PLAY.ShowText("It's Not Very Effective...")

	Belch
		_type = POISON
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 90
		desc = "The user lets out a damaging belch on the target. The user must eat a Berry to use this move."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Belly_Drum
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user maximizes its Attack stat in exchange for HP equal to half its max HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.HP > (A.maxHP/2))
					A.HP -= (A.maxHP/2)
					modStats(C,A,"attack",6)
					displayToSystem(C,"Half of [A]'s HP has been taken in enchange.")

	Bestow
		_type = NORMAL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user passes its held item to the target when the target isn't holding an item."

	Bide
		_type = NORMAL
		range = STATUS
		contestType = TOUGH
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		priority = 1
		desc = "The user endures attacks for two turns, then strikes back to cause double the damage taken."

	Bind
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 15
		Acc = 85
		desc = "Things such as long bodies or tentacles are used to bind and squeeze the target for four to five turns."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bite
		_type = DARK
		range = PHYSICAL
		contestType = TOUGH
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 100
		desc = "The target is bitten with viciously sharp fangs. This may also make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(60):(30)
				if(prob(chance))
					D.infoFlags |= FLINCHED

	Blast_Burn
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 90
		desc = "The target is razed by a fiery explosion. The user can't move on the next turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Blaze_Kick
		_type = FIRE
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 85
		Acc = 90
		desc = "The user launches a kick that lands a critical hit more easily. This may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					burnTarget(C,A,D,FALSE)

	Blizzard
		_type = ICE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 110
		Acc = 70
		desc = "A howling blizzard is summoned to strike opposing Pokémon. This may also leave the opposing Pokémon frozen."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					freezeTarget(C,A,D,FALSE)

	Block
		_type = NORMAL
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100
		desc = "The user blocks the target's way with arms spread wide to prevent escape."

	Blood_Drain
		_type = POISON
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		Absorber = TRUE
		desc = "The user sinks its fangs into the enemy, drinking their blood to heal for most of the damage dealt"
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)

	Blue_Flare
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 130
		Acc = 85
		desc = "The user attacks by engulfing the target in an intense, yet beautiful, blue flame. This may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(40):(20)
				if(prob(chance))
					burnTarget(C,A,D,FALSE)

	Body_Slam
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 85
		Acc = 100
		desc = "The user drops onto the target with its full body weight. This may also leave the target with paralysis."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(60):(30)
				if(prob(chance))
					paralyzeTarget(C,A,D,FALSE)

	Bolt_Strike
		_type = ELECTRIC
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 130
		Acc = 85
		desc = "The user surrounds itself with a great amount of electricity and charges its target. This may also leave the target with paralysis."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(40):(20)
				if(prob(chance))
					paralyzeTarget(C,A,D,FALSE)

	Bone_Club
		_type = GROUND
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 85
		desc = "The user clubs the target with a bone. This may also make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					D.infoFlags |= FLINCHED

	Bone_Rush
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 25
		Acc = 90
		desc = "The user strikes the target with a hard bone two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D)

	Bonemerang
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 50
		Acc = 90
		desc = "The user throws the bone it holds. The bone loops to hit the target twice, coming and going."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,2)

	Boomburst
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 140
		Acc = 100
		soundMove = TRUE
		desc = "The user attacks everything around it with the destructive power of a terrible, explosive sound."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bounce
		_type = FLYING
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 85
		Acc = 85
		desc = "The user bounces up high, then drops on the target on the second turn. This may also leave the target with paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Brave_Bird
		_type = FLYING
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		recoilDamage = 3
		desc = "The user tucks in its wings and charges from a low altitude. This also damages the user quite a lot."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Brick_Break
		_type = FIGHTING
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 75
		Acc = 100
		desc = "The user attacks with a swift chop. It can also break barriers, such as Light Screen and Reflect."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Brine
		_type = WATER
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 65
		Acc = 100
		desc = "If the target's HP is half or less, this attack will hit with double the power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Broken_Mind
		_type = PSYCHIC
		range = SPECIAL
		PP = 40
		MaxPP = 40
		BP = 40
		Acc = 100
		letLive = TRUE
		desc = "The user attacks the foe with a wave of psychic energy. However, this cannot knock out the foe."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bubble
		_type = WATER
		range = SPECIAL
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100
		desc = "A spray of countless bubbles is jetted at the opposing Pokémon. This may also lower their Speed stats."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					modStats(C,D,"speed",-1)

	Bubble_Bash
		_type = BUBBLE
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = 100
		desc = "The user blows a bubble to wear as a helmet and strikes whatever is above it. The suds cover the foe's body and may cause a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(80):(40)
				if(prob(chance))
					burnTarget(C,A,D,FALSE)

	Bubble_Beam
		_type = WATER
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		desc = "A spray of bubbles is forcefully ejected at the target. This may also lower its Speed stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					modStats(C,D,"speed",-1)

	Bubble_Bowl
		_type = BUBBLE
		range = PHYSICAL
		contact = FALSE
		PP = 35
		MaxPP = 35
		BP = 80
		Acc = 80
		desc = "The user blows a bubble and bowls it at the foe for a searingly painful blast to the eyes."
		upgrade_info = "When upgraded, this move does damage to both foes in a double battle."
		upgradeFlags = (0 | MOVE_UPGRADEABLE)
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bubble_Spin
		_type = BUBBLE
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 50
		Acc = 100
		desc = "The user spins a bubble wand causing foe's eyes to burn and filling their mouth with a soapy taste."
		upgrade_info = "When upgraded, this move does bonus damage based on the damage taken from the last special move."
		upgradeFlags = (0 | MOVE_UPGRADEABLE)
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bug_Bite
		_type = BUG
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = 100
		desc = "The user bites the target. If the target is holding a Berry, the user eats it and gains its effect."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bug_Buzz
		_type = BUG
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		soundMove = TRUE
		desc = "The user vibrates its wings to generate a damaging sound wave. This may also lower the target's Sp. Def stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					modStats(C,D,"spDefense",-1)

	Bulk_Up
		_type = FIGHTING
		range = STATUS
		contestType = BEAUTY
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user tenses its muscles to bulk up its body, raising both its Attack and Defense stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"attack",1)
				modStats(C,A,"defense",1)

	Bulldoze
		_type = GROUND
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = 100
		desc = "The user strikes everything around it by stomping down on the ground. This lowers the Speed stat of those hit."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,D,"speed",-1)

	Bullet_Punch
		_type = STEEL
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100
		priority = 1
		desc = "The user strikes the target with tough punches as fast as bullets. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Bullet_Seed
		_type = GRASS
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 25
		Acc = 100
		desc = "The user forcefully shoots seeds at the target. Two to five seeds are shot in rapid succession."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,5)

	Calm_Mind
		_type = PSYCHIC
		range = STATUS
		contestType = SMART
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user quietly focuses its mind and calms its spirit to raise its Sp. Atk and Sp. Def stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spAttack",1)
				modStats(C,A,"spDefense",1)

	Camouflage
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user's type is changed depending on its environment, such as at water's edge, in grass, or in a cave."

	Captivate
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "If any opposing Pokémon is the opposite gender of the user, it is charmed, which harshly lowers its Sp. Atk stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(((A.gender==FEMALE)&&(D.gender==MALE))||((A.gender==MALE)&&(D.gender==FEMALE)))
					modStats(C,D,"spAttack",-2)
				else
					displayToSystem(C,"But it failed!")

	CaptureProxy
		_type = UNKNOWN
		range = STATUS
		PP = 1.#INF // Infinite PP
		MaxPP = 1.#INF
		BP = null
		Acc = null
		priority = 6
		var tmp/item/pokeball/ball
		effect(client/C,pokemon/A,pokemon/D)
			var player/P = A.owner
			var catchRate = getStats(D)
			if(catchRate["catch_rate"]==0)
				displayToSystem(C,"[A] has dodged the [ball] and cannot be captured!")
				return
			P.bag.getItem(ball.type)
			displayToSystem(C,"[P] threw a [ball] at [D]!")
			if(hascaught(A,D,ball,C))
				D.caughtLevel = D.level
				RewardExp(A,D,P.client.battle)
				P.story.storyFlags2 |= P.client.battle.storyFlagsChange
				if(!("Success" in P.client.Audio.sounds))
					P.client.Audio.addSound(sound('success.wav',channel=19),"Success")
				P.client.Audio.playSound("Success")
				P.ShowText("[D] has been caught!")
				D.caughtWith = ball.name
				var newName
				var keepName = FALSE
				do
					newName = input(P,"What will [D]'s new name be?","New Name","[D.pName]") as null|text
					if(isnull(newName) || (newName=="[D.pName]"))
						newName = "[D.pName]"
						keepName = TRUE
					else if(length(newName)>12)
						keepName = FALSE
						newName = ""
					else
						keepName = (alert(P,"Will you give [D.pName] the nickname [newName]?","Nickame {[D.pName]}","Yes","No")=="Yes")
				while(!keepName)
				D.name = "[newName]"
				var savedMonInParty = P.party.Find(null,1,7)
				if(!savedMonInParty)
					#ifndef OLD_PC_SYSTEM
					var item/key/Laptop/L = P.bag.getItem(/item/key/Laptop)
					L.comp.depositInEmptySpace(D)
					P.ShowText("[D] is being sent to the PC Boxes!")
					#else
					box_loop
						for(var/box in 1 to 100)
							var boxSaveProxy/theBox = new
							var savefile/F = new
							F.ImportText("/",RC5_Decrypt(file2text("Boxes/Box [box]/[ckeyEx(P.key)].esav"),md5("martin")))
							theBox.Read(F,P)
							for(var/x in 1 to 10)
								for(var/y in 1 to 10)
									if(isnull(theBox.boxList[x][y]))
										theBox.boxList[x][y] = D
										F = new
										fdel("Boxes/Box [box]/[ckeyEx(P.key)].esav")
										theBox.Write(F)
										text2file(RC5_Encrypt(F.ExportText("/"),md5("martin")),"Boxes/Box [box]/[ckeyEx(P.key)].esav")
										break box_loop
					#endif
				else
					P.party[savedMonInParty] = D
				del P.client.battle
			else
				P.ShowText("Aww! [genderGet(D,"He")] seemed like [genderGet(D,"he")] was caught!")

	Cartwheel
		_type = NORMAL
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 90
		Acc = 100
		desc = "The user cartwheels directly into the foe, damaging it harshly in the process."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Celebrate
		_type = NORMAL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The Pokémon congratulates you on your special day!"
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				displayToSystem(C,"It's time to celebrate a special occasion! Woo!")

	Charge
		_type = ELECTRIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user boosts the power of the next damaging electric move it uses. This also raises the user's Sp. Def stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				A.infoFlags |= CHARGED
				modStats(C,A,"spDefense",1)

	Charge_Beam
		_type = ELECTRIC
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 50
		Acc = 90
		desc = "The user attacks with an electric charge. The user may use any remaining electricity to raise its Sp. Atk stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(100):(70)
				if(prob(chance))
					modStats(C,A,"spAttack",1)

	Charm
		_type = FAIRY
		range = STATUS
		contestType = CUTE
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user gazes at the target rather charmingly, making it less wary. This harshly lowers its Attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"attack",-2)

	Charming_Show
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user puts on a show solo or partnered, raising the Speed and Special Attack stats of it and its partner."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spAttack",1)
				modStats(C,A,"speed",1)
				if(C.battle.flags & DOUBLE_BATTLE)
					var pokemon/B = C.battle.Get_Ally(A)
					if(B.status != FAINTED)
						modStats(C,B,"spAttack",1)
						modStats(C,B,"spDefense",1)

	Chatter
		_type = FLYING
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		desc = "The user attacks using a sound wave based on words it has learned. This confuses the target."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				confuseTarget(C,A,D,FALSE)

	Chip_Away
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 70
		Acc = 100
		desc = "Looking for an opening, the user strikes consistently. The target's stat changes don't affect this attack's damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Circle_Throw
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 60
		Acc = 90
		desc = "The target is thrown, and a different Pokémon is dragged out. In the wild, this ends a battle against a single Pokémon."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Clamp
		_type = WATER
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 35
		Acc = 85
		desc = "The target is clamped and squeezed by the user's very thick and sturdy shell for four to five turns."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Clear_Smog
		_type = POISON
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 50
		Acc = null
		desc = "The user attacks by throwing a clump of special mud. All stat changes are returned to normal."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Close_Combat
		_type = FIGHTING
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 100
		desc = "The user fights the target up close without guarding itself. This also lowers the user's Defense and Sp. Def stats."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,A,"defense",-1)
				modStats(C,A,"spDefense",-1)

	Cloud_Mist
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user summons fog thick as soup. It lowers accuracy of all pokémon, but doubles the power of Weather Ball."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				C.battle.weatherData["Weather"] = FOG
				C.battle.weatherData["Turns"] = 5
				for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
					if(P.pName=="Castform")
						P.formChange()

	Coil
		_type = POISON
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user coils up and concentrates. This raises its Attack and Defense stats as well as its accuracy."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"attack",1)
				modStats(C,A,"defense",1)
				modStats(C,A,"speed",1)

	Comet_Punch
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 18
		Acc = 85
		desc = "The target is hit with a flurry of punches that strike two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D)

	Confide
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user tells the target a secret, and the target loses its ability to concentrate. This lowers the target's Sp. Atk. stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spAttack",-1)

	Confuse_Ray
		_type = GHOST
		range = STATUS
		contestType = SMART
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The target is exposed to a sinister ray that triggers confusion."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				confuseTarget(C,A,D)

	Confusion
		_type = PSYCHIC
		range = SPECIAL
		contestType = SMART
		PP = 25
		MaxPP = 25
		BP = 50
		Acc = 100
		desc = "The target is hit by a weak telekinetic force. This may also confuse the target."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					confuseTarget(C,D)

	Constrict
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 35
		MaxPP = 35
		BP = 10
		Acc = 100
		desc = "The target is attacked with long, creeping tentacles or vines. This may also lower the target's Speed stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					modStats(C,D,"speed",-1)

	Conversion
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user changes its type to become the same type as the move at the top of the list of moves it knows."

	Conversion_2
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100
		desc = "The user changes its type to make itself resistant to the type of the attack the opponent used last."

	Copycat
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user mimics the move used immediately before it. The move fails if no other move has been used yet."

	Cosmic_Power
		_type = PSYCHIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user absorbs a mystical power from space to raise its Defense and Sp. Def stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",1)
				modStats(C,A,"spDefense",1)

	Cotton_Guard
		_type = GRASS
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user potects itself by wrapping its body in soft cotton, drastically raising the user's Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",3)

	Cotton_Spore
		_type = GRASS
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = 100
		Spore_Move = TRUE
		desc = "The user releases cotton-like spores that cling to the target, harshly reducing its Speed stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"speed",-2)

	Counter
		_type = FIGHTING
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "A retaliation move that counters any physical attack, inflicting double the damage taken."

	Cover_Shell
		_type = BUG
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user covers its shell in a hard substance, causing its shell to harden, raising its Defense and Special Defense stats by one stage each."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",1)
				modStats(C,A,"spDefense",1)

	Covet
		_type = NORMAL
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 100
		desc = "The user endearingly approaches the target, then steals the target's held item."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Crabhammer
		_type = WATER
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 90
		highCrit = TRUE
		desc = "The target is hammered with a large pincer. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Crafty_Shield
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user protects itself and its allies from status moves with a mysterious power. This does not stop moves that do damage."

	Crimson_Sword
		_type = STEEL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 180
		Acc = null // Crimson Sword... NEVER MISSES! xD
		desc = "A Bloody and Gruesome sword is slashed at the foe. If the foe doesn't faint, it will be Paralyzed."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var attackThing = A.attack*stages[A.attackBoost+7]
				var defenseThing = D.defense*stages[D.defenseBoost+7]
				var spAttackThing = A.spAttack*stages[A.spAttackBoost+7]
				var spDefenseThing = D.spDefense*stages[D.spDefenseBoost+7]
				if(attackThing > spAttackThing)
					range = PHYSICAL
				else if(attackThing < spAttackThing)
					range = SPECIAL
				if(defenseThing > spDefenseThing)
					defendType = SPECIAL
				else if(defenseThing < spDefenseThing)
					defendType = PHYSICAL
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				paralyzeTarget(C,D)

	Cross_Chop
		_type = FIGHTING
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 80
		highCrit = TRUE
		desc = "The user delivers a double chop with its forearms crossed. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Cross_Poison
		_type = POISON
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 70
		Acc = 100
		highCrit = TRUE
		desc = "A slashing attack with a poisonous blade that may also poison the target. Critical hits land more easily."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					poisonTarget(C,A,D,FALSE,FALSE)

	// Cruise Bubble is the only move that will be capable of inflicting Blind. Blind prevents contact moves from dealing damage.
	Cruise_Bubble
		_type = BUBBLE
		range = SPECIAL
		contestType = COOL
		PP = 35
		MaxPP = 35
		BP = 120
		Acc = 100
		desc = "The user steers a bubble through the air that pops on impact. It has a chance to blind the foe."
		upgrade_info = "When upgraded, this move will home in on its target and cannot miss. The blind will also become guaranteed."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(upgradeFlags & MOVE_UPGRADED)
					blindTarget(C,D)
				else
					var chance = (battleFlags & SERENE_GRACE)?(25):(50)
					if(prob(chance))
						blindTarget(C,D)

	Crunch
		_type = DARK
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user crunches up the target with sharp fangs. This may also lower the target's Defense stat or cause it to flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(40):(20)
				if(prob(chance))
					if(prob(50))
						modStats(C,D,"defense",-1)
					else
						D.infoFlags |= FLINCHED

	Crush_Claw
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 75
		Acc = 95
		desc = "The user slashes the target with hard and sharp claws. This may also harshly lower the target's Defense."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(30):(15)
				if(prob(chance))
					modStats(C,D,"defense",-2)

	Crush_Grip
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100
		desc = "The target is crushed with great force. The more HP the target has left, the greater this move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = 1 + 120 * (D.HP/D.maxHP)
				doDamage(C,A,D)

	Curse
		_type = UNKNOWN
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "A move that works differently for the Ghost type than for all other types."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(!checkType(GHOST,A))
					modStats(C,A,"speed",-1)
					modStats(C,A,"attack",1)
					modStats(C,A,"defense",1)
				else
					if(!D.volatileStatus[CURSED])
						if(C.battle.Accuracy_Check(src,A,D))
							displayToSystem(C,"[A] cut down [genderGet(A,"his")] own HP and put a curse on [D]!")
							D.volatileStatus[CURSED] = 1
							A.HP = max(A.HP-(A.maxHP/2),0)
							if(A.HP==0)
								C.battle.faintPokemon(D,A)
					else
						displayToSystem(C,"But [D] is already cursed!")

	Cut
		_type = GRASS
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 90
		Acc = 100
		desc = "The target is cut with a scythe or claw. This can also be used to cut down thin trees."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		canForget(player/P)
			if(istype(P,/client))P = P:mob
			var
				turf/T = P.loc
				area/A = T.loc
				otherPokemonHasMove = FALSE
			if(locate(/cutBush) in A)
				for(var/x in 1 to 6)
					var pokemon/PK = P.party[x]
					if(locate(/pmove/Cut) in PK.moves){otherPokemonHasMove = TRUE;break}
				return otherPokemonHasMove
			else return TRUE

	Dark_Pulse
		_type = DARK
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user releases a horrible aura imbued with dark thoughts. This may also make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(40):(20)
				if(prob(chance))
					D.infoFlags |= FLINCHED

	Dark_Void
		_type = DARK
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "Opposing Pokémon are dragged into a world of total darkness that makes them sleep."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				sleepTarget(C,A,D,FALSE,5,10)
				var pokemon/S = C.battle.Get_Ally(D)
				if(S.pName)
					sleepTarget(C,A,D,FALSE,5,10)

	Dazzling_Gleam
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "The user damages opposing Pokémon by emitting a powerful flash."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Defend_Order
		_type = BUG
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user calls out its underlings to shield its body, sharply raising its Defense and Sp. Def stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",2)
				modStats(C,A,"spDefense",2)

	Defense_Curl
		_type = NORMAL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The user curls up to conceal weak spots and raise its Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",1)

	Defog
		_type = FLYING
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "A strong wind blows away the target's barriers such as Reflect or Light Screen. This also lowers the target's evasiveness."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.weatherData["Weather"]==FOG)
					C.battle.weatherData["Weather"] = CLEAR
					C.battle.weatherData["Turns"] = 0
					for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
						if(P.pName=="Castform")
							P.formChange()

	Destiny_Bond
		_type = GHOST
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "When this move is used, if the user faints, the Pokémon that landed the knockout hit also faints."

	Detect
		_type = FIGHTING
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		priority = 4
		desc = "The user is protected from most attacks. Feint Breaks this move. However, the decay rate is less severe than Protect."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(prob((1/A.protectTurns)*100))
					A.infoFlags |= PROTECTED
				else
					displayToSystem(C,"But it failed!")

	Dig
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "The user burrows, then attacks on the next turn. It can also be used to exit dungeons."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				A.moveState |= DIGGING
				displayToSystem(C,"[A] burrowed \herself deep underground!")
				if(A==C.battle.P1)
					C.battle.chosenMoveData["P1"]["move"] = new/pmove/DigProxy
				else if(A==C.battle.P2)
					C.battle.chosenMoveData["P2"]["move"] = new/pmove/DigProxy
				else if(A==C.battle.E1)
					C.battle.chosenMoveData["E1"]["move"] = new/pmove/DigProxy
				else if(A==C.battle.E2)
					C.battle.chosenMoveData["E1"]["move"] = new/pmove/DigProxy

	DigProxy
		name = "Dig"
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				displayToSystem(C,"[A] came up and attacked!")
				var pmove/Dig/F = locate(/pmove/Dig) in A.moves
				if(C.battle.flags & DOUBLE_BATTLE)
					var pokemon/S = C.battle.Get_Ally(D)
					var a = ("Mold Breaker" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					var b = ("Turboblaze" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					var c = ("Teravolt" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					if(!(a||b||c))
						F.PP = max(PP-(("Pressure" in list(D.ability1,D.ability2,S.ability1,S.ability2))?(2):(1)),0)
					else
						F.PP = max(PP-1,0)
				else
					var a = ("Mold Breaker" in list(D.ability1,D.ability2))
					var b = ("Turboblaze" in list(D.ability1,D.ability2))
					var c = ("Teravolt" in list(D.ability1,D.ability2))
					if(!(a||b||c))
						F.PP = max(PP-(("Pressure" in list(D.ability1,D.ability2))?(2):(1)),0)
					else
						F.PP = max(PP-1,0)
				doDamage(C,A,D)
			A.moveState &= ~DIGGING

	Disable
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "For four turns, this move prevents the target from using the move it last used."

	Disarming_Voice
		_type = FAIRY
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 40
		Acc = null
		desc = "Letting out a charming cry, the user does emotional damage to opposing Pokémon. This attack never misses."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Discharge
		_type = ELECTRIC
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user strikes everything around it by letting loose a flare of electricity. This may also cause paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(60):(30)
				if(prob(chance))
					paralyzeTarget(C,A,D,FALSE)

	Dive
		_type = WATER
		range = PHYSICAL
		contestType = BEAUTY
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "Diving on the first turn, the user floats up and attacks on the next turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				A.moveState |= DIVING
				displayToSystem(C,"[A] dove deep under the water!")
				if(A==C.battle.P1)
					C.battle.chosenMoveData["P1"]["move"] = new/pmove/DiveProxy
				else if(A==C.battle.P2)
					C.battle.chosenMoveData["P2"]["move"] = new/pmove/DiveProxy
				else if(A==C.battle.E1)
					C.battle.chosenMoveData["E1"]["move"] = new/pmove/DiveProxy
				else if(A==C.battle.E2)
					C.battle.chosenMoveData["E1"]["move"] = new/pmove/DiveProxy


	DiveProxy
		name = "Dive"
		_type = WATER
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "Diving on the first turn, the user floats up and attacks on the next turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				displayToSystem(C,"[A] came up and attacked!")
				var pmove/Dive/F = locate(/pmove/Dive) in A.moves
				if(C.battle.flags & DOUBLE_BATTLE)
					var pokemon/S = C.battle.Get_Ally(D)
					var a = ("Mold Breaker" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					var b = ("Turboblaze" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					var c = ("Teravolt" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					if(!(a||b||c))
						F.PP = max(PP-(("Pressure" in list(D.ability1,D.ability2,S.ability1,S.ability2))?(2):(1)),0)
					else
						F.PP = max(PP-1,0)
				else
					var a = ("Mold Breaker" in list(D.ability1,D.ability2))
					var b = ("Turboblaze" in list(D.ability1,D.ability2))
					var c = ("Teravolt" in list(D.ability1,D.ability2))
					if(!(a||b||c))
						F.PP = max(PP-(("Pressure" in list(D.ability1,D.ability2))?(2):(1)),0)
					else
						F.PP = max(PP-1,0)
				doDamage(C,A,D)
			A.moveState &= ~DIVING

	Dizzy_Punch
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 70
		Acc = 100
		desc = "The target is hit with rhythmically launched punches. This may also leave the target confused."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(40):(20)
				if(prob(chance))
					confuseTarget(C,A,D,FALSE)

	DNA_Boost
		name = "DNA-Boost"
		_type = PSYCHIC
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = 0
		Acc = null
		desc = "The Power of this move allows Deoxys to boost its stats depending on form. No other Pokémon can activate this move."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.pName == "Deoxys")
					if(A.form == "")
						modStats(C,A,"attack",3)
						modStats(C,A,"defense",3)
					else if(A.form == "-A")
						modStats(C,A,"attack",3)
						modStats(C,A,"spAttack",3)
					else if(A.form == "-D")
						modStats(C,A,"defense",3)
						modStats(C,A,"spDefense",3)
					else if(A.form == "-S")
						modStats(C,A,"spAttack",3)
						modStats(C,A,"speed",3)
				else
					displayToSystem(C,"[A] can't use this move as it is not a Deoxys!")

	Doom_Desire
		_type = STEEL
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 140
		Acc = 100
		desc = "Two turns after this move is used, the user blasts the target with a concentrated bundle of light."

	Double_Hit
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 35
		Acc = 90
		desc = "The user slams the target with a long tail, vines, or a tentacle. The target is hit twice in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,2)

	Double_Kick
		_type = FIGHTING
		range = PHYSICAL
		contestType = COOL
		PP = 30
		MaxPP = 30
		BP = 30
		Acc = 100
		desc = "The target is quickly kicked twice in succession using both feet."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,2)

	Double_Slap
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 15
		Acc = 85
		desc = "The target is slapped repeatedly, back and forth, two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D)

	Double_Team
		_type = NORMAL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "By moving rapidly, the user makes illusory copies of itself to raise its evasiveness."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"evasion",1)

	Double\-\Edge
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		recoilDamage = 3
		desc = "A reckless, life-risking tackle. This also damages the user quite a lot."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Draco_Meteor
		_type = DRAGON
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 130
		Acc = 90
		desc = "Comets are summoned down from the sky onto the target. The attack's recoil harshly lowers the user's Special Attack stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spAttack",-2)

	Dragon_Ascent
		_type = DRAGON
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 100
		desc = "The Pokémon slams down from the sky to attack its opponent, lowering its defenses in the process."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,A,"defense",-1)
				modStats(C,A,"spDefense",-1)

	Dragon_Breath
		_type = DRAGON
		range = SPECIAL
		contestType = COOL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = 100
		desc = "The user exhales a mighty gust that inflicts damage. This may also leave the target with paralysis."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					paralyzeTarget(C,A,D,FALSE)

	Dragon_Claw
		_type = DRAGON
		range = PHYSICAL
		contestType = COOL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user slashes the target with huge, sharp claws."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Dragon_Dance
		_type = DRAGON
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user vigorously performs a mystic, powerful dance that boosts its Attack and Speed stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"attack",1)
				modStats(C,A,"speed",1)

	Dragon\'\s_Doom
		_type = DRAGON
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		desc = "The user angrily shoots violent beams around it for two to three turns. It then becomes confused, however"

	Dragon_Pulse
		_type = DRAGON
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 85
		Acc = 100
		desc = "The target is attacked with a shock wave generated by the user's gaping mouth."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Dragon_Rage
		_type = DRAGON
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 0
		Acc = 100
		desc = "This attack hits the target with a shock wave of pure rage. This attack always inflicts 40 HP damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				fixedDamage(C,A,D,40)

	Dragon_Rush
		_type = DRAGON
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 75
		desc = "The user tackles the target while exhibiting overwhelming menace. This may also make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,20))
					D.infoFlags |= FLINCHED

	Dragon_Tail
		_type = DRAGON
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 60
		Acc = 90
		desc = "The target is knocked away, and a different Pokémon is dragged out. In the wild, this ends a battle against a single Pokémon."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Drain_Punch
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 75
		Acc = 100
		Absorber = TRUE
		desc = "An energy-draining punch. The user's HP is restored by half the damage taken by the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Draining_Kiss
		_type = FAIRY
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 50
		Acc = 100
		Absorber = TRUE
		desc = "The user steals the target's energy with a kiss. The user's HP is restored by over half of the damage taken by the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Dream_Eater
		_type = PSYCHIC
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 100
		Acc = 100
		Absorber = TRUE
		desc = "The user eats the dreams of a sleeping target. It absorbs half the damage caused to heal the user's HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(D.status != ASLEEP)
					displayToSystem(C,"But it failed because [D] isn't asleep!")
				else
					doDamage(C,A,D)

	Drill_Peck
		_type = FLYING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 80
		Acc = 100
		desc = "A corkscrewing attack with a sharp beak acting as a drill."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Drill_Run
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 95
		highCrit = TRUE
		desc = "The user crashes into its target while rotating its body like a drill. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Dual_Chop
		_type = DRAGON
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 40
		Acc = 90
		desc = "The user attacks its target by hitting it with brutal strikes. The target is hit twice in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,2)

	Dynamic_Punch
		_type = FIGHTING
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 50
		desc = "The user punches the target with full, concentrated power. This confuses the target if it hits."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				confuseTarget(C,D)

	Earth_Power
		_type = GROUND
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		desc = "The user makes the ground under the target erupt with power. This may also lower the target's Sp. Def."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(20):(10)
				if(prob(chance))
					modStats(C,D,"spDefense",-1)

	Earthquake
		_type = GROUND
		range = PHYSICAL
		contestType = TOUGH
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 100
		desc = "The user sets off an earthquake that strikes every Pokémon around it."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Earthshatter
		_type = GROUND
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user shatters the earth apart destroying all Pokémon around it. This move is a Rock, Ground, and Steel type move. This move can also cause Pokémon that are afloat to be hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	EscapeProxy
		_type = UNKNOWN
		range = STATUS
		PP = 1
		MaxPP = 1
		BP = null
		Acc = null
		desc = "The attempt to escape."
		priority = 8
		effect(client/C,pokemon/A,pokemon/D)
			var
				battleSystem/battle = C.battle
				player/P = C.mob
				escaped = FALSE
			if(GHOST in list(A.type1,A.type2,A.type3))
				P.ShowText("[A]'s Ghost Type nade the getaway easy!")
				escaped = TRUE
			else if((!battle.abilityCancel(D)) && ("" in list(A.ability1,A.ability2)))
				P.ShowText("You escaped because of [A]'s Run Away!")
				escaped = TRUE
			else
				var allySpeed = A.speed*stages[A.speedBoost+7]
				var enemySpeed = (((D.speed*stages[D.speedBoost+7]) / (4)) % 256)
				var escapeAttempts = battle.runAttempts++
				var result = ((allySpeed*32)/(enemySpeed))+30*escapeAttempts
				var randomValue = rand(0,255)
				/*P << "((([allySpeed]*30)/[enemySpeed]) + 30 * [escapeAttempts]) = [result]"
				P << "This results in an escape factor of [result]"
				P << "A random number [randomValue] has been generated."*/
				if(result>255)
					P.ShowText("You Ran Away!")
					escaped = TRUE
				else if(randomValue<(result%256))
					//P << "[randomValue] < [(result%256)], allowing escape."
					P.ShowText("You Ran Away!")
					escaped = TRUE
				else
					//P << "[randomValue] >= [(result%256)], preventing escape."
					P.ShowText("You couldn't escape...")
			if(escaped)
				del battle

	Echoed_Voice
		_type = NORMAL
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 40
		Acc = 100
		desc = "The user attacks the target with an echoing voice. If this move is used every turn, it does greater damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Eerie_Impulse
		_type = ELECTRIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		soundMove = TRUE
		desc = "The user's body generates an eerie impulse. Exposing the target to it harshly lowers the target's Sp. Atk stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"spAttack",-2)

	Egg_Bomb
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 75
		desc = "A large egg is hurled at the target with maximum force to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Electric_Terrain
		_type = ELECTRIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user electrifies the ground under everyone's feet for five turns. Pokémon on the ground no longer fall asleep."

	Electrify
		_type = ELECTRIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "For the next two turns, the moves the enemy uses will be of Electric-Type."

	Electro_Ball
		_type = ELECTRIC
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The user hurls an electric orb at the target. The faster the user is than the target, the greater the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = max(A.speed-D.speed,60)
				doDamage(C,A,D)

	Electroweb
		_type = ELECTRIC
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 55
		Acc = 95
		desc = "The user attacks and captures opposing Pokémon by using an electric net. This lowers their Speed stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,D,"speed",-1)

	Embargo
		_type = DARK
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "This move prevents the target from using its held item. Its Trainer is also prevented from using items on it."

	Ember
		_type = FIRE
		range = SPECIAL
		contestType = BEAUTY
		PP = 25
		MaxPP = 25
		BP = 40
		Acc = 100
		desc = "The target is attacked with small flames. This may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					burnTarget(C,D)

	Encore
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100
		desc = "The user compels the target to keep using only the move it last used for three turns."

	Endeavor
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100
		desc = "An attack move that cuts down the target's HP to equal the user's HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.HP>D.HP)
					displayToSystem(C,"But it failed!")
				else
					D.HP = A.HP

	Endure
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user endures any attack with at least 1 HP. Its chance of failing rises if it is used in succession."

	Energy_Ball
		_type = GRASS
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		desc = "The user draws power from nature and fires it at the target. This may also lower the target's Sp. Def."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					modStats(C,D,"spDefense",-1)

	Entrainment
		_type = NORMAL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user dances with an odd rhythm that compels the target to mimic it, making the target's Ability the same as the user's."

	Eruption
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 100
		desc = "The user attacks the opposing team with explosive fury. The lower the user's HP, the less powerful this attack becomes."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = round(150*(A.HP/A.maxHP))
				doDamage()
				BP = 150

	Explosion
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 250
		Acc = 100
		desc = "The user attacks everything around it by causing a tremendous explosion. The user faints upon using this move."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Extrasensory
		_type = PSYCHIC
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 80
		Acc = 100
		desc = "The user attacks with an odd, unseeable power. This may also make the target flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Extreme_Speed
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 80
		Acc = 100
		priority = 2
		desc = "The user charges the target at blinding speed. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Facade
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 70
		Acc = 100
		desc = "An attack move that doubles its power if the user is poisoned, asleep, burned or has paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.status in list(POISONED,BAD_POISON,ASLEEP,BURNED,PARALYZED))
					BP *= 2
				doDamage(C,A,D)

	Fairy_Chant
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user dances and chants a tune of the fairies, raising its Speed and Special Attack stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spAttack",1)
				modStats(C,A,"speed",1)

	Fairy_Lock
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "By locking down the battlefield, the user keeps all Pokémon from fleeing during the next turn."

	Fairy_Wind
		_type = FAIRY
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 40
		Acc = null
		desc = "The user stirs up a fairy wind and strikes the target with it."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fake_Out
		_type = NORMAL
		range = PHYSICAL
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = 40
		Acc = 100
		desc = "An attack that hits first and makes the target flinch. It only works the first turn the user is in battle."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fake_Tears
		_type = DARK
		range = STATUS
		contestType = SMART
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user feigns crying to fluster the target, harshly lowering its Sp. Def stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"spDefense",-2)

	False_Swipe
		_type = NORMAL
		range = PHYSICAL
		PP = 40
		MaxPP = 40
		BP = 40
		Acc = 100
		letLive = TRUE
		desc = "A restrained attack that prevents the target from fainting. The target is left with at least 1 HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Feather_Dance
		_type = FLYING
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user covers the target's body with a mass of down that harshly lowers its Attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"attack",-2)

	Feint
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 30
		Acc = 100
		desc = "An attack that hits a target using Protect or Detect. This also lifts the effects of those moves."
		protectEffect = FALSE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Feint_Attack
		_type = DARK
		range = PHYSICAL
		contestType = SMART
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = null
		desc = "The user approaches the target disarmingly, then throws a sucker punch. This attack never misses."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fell_Stinger
		_type = BUG
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 30
		Acc = 100
		desc = "When the user knocks out a target with this move, the user's Attack stat rises sharply."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fiery_Dance
		_type = FIRE
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "Cloaked in flames, the user dances and flaps its wings. This may also raise the user's Sp. Atk stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,50))
					modStats(C,A,"spAttack",2)

	Final_Gambit
		_type = FIGHTING
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 0
		Acc = 100
		desc = "The user risks everything to attack its target. The user faints but does damage equal to its HP."

	Fire_Blast
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 110
		Acc = 85
		desc = "The target is attacked with an intense blast of all-consuming fire. This may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					burnTarget(C,D)

	Fire_Fang // With the Gen 4 Effect, this move will break through Wonder Guard regardless of type effect.
		_type = FIRE
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 65
		Acc = 95
		desc = "The user bites with flame-cloaked fangs. This may also make the target flinch or leave it with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,20))
					if(prob(50))
						burnTarget(C,D)
					else
						D.infoFlags |= FLINCHED

	Fire_Pledge
		_type = FIRE
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "A column of fire hits opposing Pokémon. When used with its grass equivalent, its damage increases and a vast sea of fire appears."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fire_Punch
		_type = FIRE
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		desc = "The target is punched with a fiery fist. This may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					burnTarget(C,D)

	Fire_Spin
		_type = FIRE
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 35
		Acc = 85
		desc = "The target becomes trapped within a fierce vortex of fire that rages for four to five turns."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fissure
		_type = GROUND
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 0
		Acc = 0
		desc = "The user opens up a fissure in the ground and drops the target in. The target faints instantly if this attack hits."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.level < D.level)
					displayToSystem(C,"But it failed, since [A] is lower level than [D] by [D.level-A.level] levels.")
				else
					var accuracy = (A.level - D.level) + 30
					if(prob(accuracy))
						if(!("Sturdy" in list(D.ability1,D.ability2)))
							if(C.battle.Get_Type_Effect(src,A,D))
								D.HP = 0
								D.status = FAINTED
								for(var/client/CX in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
									CX.Audio.addSound(sound(D.cry,channel=1),"234",TRUE)
									spawn(50) CX.Audio.removeSound("234")
								RewardExp(A,D,C.battle)
							else
								displayToSystem(C,"This Pokémon is immune to the damage caused by this move.")
						else
							displayToSystem(C,"[D] did not get damaged by Fissure due to its Sturdy ability!")
					else
						displayToSystem(C,"But it missed!")

	Flail
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user flails about aimlessly to attack. The less HP the user has, the greater the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = (48 * A.HP) / A.maxHP
				doDamage(C,A,D)

	Flame_Burst
		_type = FIRE
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 70
		Acc = 100
		desc = "The user attacks the target with a bursting flame. The bursting flame damages Pokémon next to the target as well."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Flame_Charge
		_type = FIRE
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 50
		Acc = 100
		desc = "Cloaking itself in flame, the user attacks. Then, building up more power, the user sharply raises its Speed stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,A,"speed",2)

	Flame_Wheel
		_type = FIRE
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 100
		desc = "The user cloaks itself in fire and charges at the target. It may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					burnTarget(C,D)

	Flamethrower
		_type = FIRE
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		desc = "The target is scorched with an intense blast of fire. This may also leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					burnTarget(C,D)

	Flare_Blitz
		_type = FIRE
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		recoilDamage = 3
		desc = "The user cloaks itself in fire and charges the target. This also damages the user quite a lot. This may leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					burnTarget(C,D)

	Flash
		_type = LIGHT
		range = STATUS
		contestType = BEAUTY
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user flashes a bright light that cuts the target's accuracy."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"accuracy",-1)

	Flash_Cannon
		_type = STEEL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "The user gathers all its light energy and releases it at once. This may also lower the target's Sp. Def stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					modStats(C,D,"spDefense",-1)

	Flatter
		_type = DARK
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "Flattery is used to confuse the target. However, this also sharply raises the target's Sp. Atk stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					confuseTarget(C,D)
					modStats(C,D,"spAttack",2)

	Fling
		_type = DARK
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The user flings its held item at the target to attack. This move's power and effects depend on the item."

	Flower_Shield
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user raises the Defense stat of all Grass-type Pokémon in battle with a mysterious power."

	Fly
		_type = FLYING
		range = PHYSICAL
		contestType = SMART
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 95
		desc = "The user soars and then strikes its target on the next turn. This can also be used to fly to any familiar town."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				A.moveState |= FLIGHT
				displayToSystem(C,"[A] flew high up in the sky!")
				if(A==C.battle.P1)
					C.battle.chosenMoveData["P1"]["move"] = new/pmove/FlyProxy
				else if(A==C.battle.P2)
					C.battle.chosenMoveData["P2"]["move"] = new/pmove/FlyProxy
				else if(A==C.battle.E1)
					C.battle.chosenMoveData["E1"]["move"] = new/pmove/FlyProxy
				else if(A==C.battle.E2)
					C.battle.chosenMoveData["E1"]["move"] = new/pmove/FlyProxy

	FlyProxy
		name = "Fly"
		_type = FLYING
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 95
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var pmove/Fly/F = locate(/pmove/Fly) in A.moves
				if(C.battle.flags & DOUBLE_BATTLE)
					var pokemon/S = C.battle.Get_Ally(D)
					var a = ("Mold Breaker" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					var b = ("Turboblaze" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					var c = ("Teravolt" in list(D.ability1,D.ability2,S.ability1,S.ability2))
					if(!(a||b||c))
						F.PP = max(PP-(("Pressure" in list(D.ability1,D.ability2,S.ability1,S.ability2))?(2):(1)),0)
					else
						F.PP = max(PP-1,0)
				else
					var a = ("Mold Breaker" in list(D.ability1,D.ability2))
					var b = ("Turboblaze" in list(D.ability1,D.ability2))
					var c = ("Teravolt" in list(D.ability1,D.ability2))
					if(!(a||b||c))
						F.PP = max(PP-(("Pressure" in list(D.ability1,D.ability2))?(2):(1)),0)
					else
						F.PP = max(PP-1,0)
				displayToSystem(C,"[A] jetted down and attacked!")
				doDamage(C,A,D)
			A.moveState &= ~FLIGHT

	Flying_Press
		_type = FPRESS
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 95
		desc = "Flying Press Deals Damage as Both a Fighting and Flying type move."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Focus_Beam
		_type = FIGHTING
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 130
		Acc = 100
		desc = "A focused, violent beam is shot at the foe. It may make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					D.infoFlags |= FLINCHED

	Focus_Blast
		_type = FIGHTING
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 70
		desc = "The user heightens its mental focus and unleases its power. This may also lower the target's Sp. Def."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Focus_Energy
		_type = NORMAL
		range = STATUS
		contestType = COOL
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user takes a deep breath and focuses so that critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(!(A.infoFlags & FOCUSED))
					A.infoFlags |= FOCUSED
					displayToSystem(C,"It's getting pumped!")
				else
					displayToSystem(C,"It's already pumped up!")

	Focus_Punch
		_type = FIGHTING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 150
		Acc = 100
		desc = "The user focuses its mind before launching a punch. This move fails if the user is hit before it is used."

	Follow_Me
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user draws attention to itself, making all targets take aim only at the user."

	Force_Palm
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 60
		Acc = 100
		desc = "The target is attacked with a shock wave. This may also leave the target with paralysis."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					paralyzeTarget(C,D)

	Foresight
		_type = NORMAL
		range = STATUS
		contestType = SMART
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "Enables a Ghost-type target to be hit by Normal- and Fighting-type attacks. This also enables an evasive target to be hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				D.evasionBoost = 0
				D.infoFlags |= FORESIGHT
				displayToSystem(C,"[D] has been identified!")

	Forest\'\s_Curse
		_type = GRASS
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user puts a forest curse on the target. Afflicted targets are now Grass type as well."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					D.type3 = GRASS

	Foul_Play
		_type = DARK
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 95
		Acc = 100
		desc = "The user turns the target's power against it. The higher the target's Attack stat, the greater the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Freeze_Shock
		_type = ICE
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 140
		Acc = 90
		desc = "On the second turn, the user hits the target with electrically charged ice. This may also leave the target with paralysis."

	Freeze\-\Dry
		_type = ICE
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 70
		Acc = 100
		desc = "The user rapidly cools the target. This may also leave the target frozen. This move is super effective on Water types."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Frenzy_Plant
		_type = GRASS
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 90
		desc = "The user slams the target with an enormous tree. The user can't move on the next turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Frost_Breath
		_type = ICE
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 60
		Acc = 90
		desc = "The user blows its cold breath on the target. This attack always results in a critical hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Frustration
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "A full-power attack that grows more powerful the less the user likes its Trainer."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = ceil(min(max((255 - A.friendship) / 2.5,1),102))
				doDamage(C,A,D)
				BP = null

	Fury_Attack
		_type = NORMAL
		range = PHYSICAL
		contestType = COOL
		PP = 20
		MaxPP = 20
		BP = 15
		Acc = 85
		desc = "The target is jabbed repeatedly with a horn or beak two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,5)

	Fury_Cutter
		_type = BUG
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 95
		desc = "The target is slashed with scythes or claws. This attack becomes more powerful if it hits in succession."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fury_Swipes
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 18
		Acc = 80
		desc = "The target is raked with sharp claws or scythes quickly two to five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,5)

	Fusion_Bolt
		_type = ELECTRIC
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 100
		desc = "The user throws down a giant thunderbolt. This move is more powerful when influenced by an enormous flame."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Fusion_Flare
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 100
		desc = "The user brings down a giant flame. This attack is more powerful when influenced by an enormous thunderbolt."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Future_Sight
		_type = PSYCHIC
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 100
		desc = "Two turns after this move is used, a hunk of psychic energy attacks the target."

	Gastro_Acid
		_type = POISON
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The user hurls up its stomach acids on the target. The fluid eliminates the effect of the target's Ability."

	Gear_Grind
		_type = STEEL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 50
		Acc = 85
		desc = "The user attacks by throwing steel gears at its target twice."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Geomancy
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user absorbs energy and sharply raises its Sp. Atk, Sp. Def, and Speed stats on the next turn."

	Giga_Drain
		_type = GRASS
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		Absorber = TRUE
		desc = "A nutrient-draining attack. The user's HP is restored by half the damage taken by the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Giga_Impact
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 90
		desc = "The user charges at the target using every bit of its power. The user can't move on the next turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Glaciate
		_type = ICE
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 65
		Acc = 95
		desc = "The user attacks by blowing freezing cold air at opposing Pokémon. This lowers their Speed stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Glare
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100
		desc = "The user intimidates the target with the pattern on its belly to cause paralysis."

	Grass_Knot
		_type = GRASS
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user snares the target with grass and trips it. The heavier the target, the greater the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				switch(D.weight)
					if(-1.#INF to 9.9)BP = 20
					if(10 to 24.9)BP = 40
					if(25 to 49.9)BP = 60
					if(50 to 99.9)BP = 80
					if(100 to 199.9)BP = 100
					if(200 to 1.#INF)BP = 120
				doDamage(C,A,D)

	Grass_Pledge
		_type = GRASS
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "A column of grass hits the target. When used with its water equivalent, its damage increases and a vast swamp appears."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Grass_Whistle
		_type = GRASS
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 55
		desc = "The user plays a pleasant melody that lulls the target into a deep sleep."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				sleepTarget(C,A,D)

	Grassy_Terrain
		_type = GRASS
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user turns the ground under everyone's feet to grass for five turns. This restores the HP of Pokémon on the ground a little every turn."

	Gravity
		_type = PSYCHIC
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "Gravity is intensified for five turns, making moves involving flying unusable and negating Levitate."

	Growl
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 40
		MaxPP = 40
		BP = null
		Acc = 100
		desc = "The user growls in an endearing way, making the opposing team less wary. The foes' Attack stats are lowered."
		soundMove = 1
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"attack",-1)

	Growth
		_type = NORMAL
		range = STATUS
		contestType = BEAUTY
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user's body grows all at once, raising the Attack and Sp. Atk stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var theBoost = (C.battle.weatherData["Weather"]==SUNNY)?(2):(1)
				modStats(C,A,"attack",theBoost)
				modStats(C,A,"spAttack",theBoost)

	Grudge
		_type = GHOST
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100
		desc = "If the user faints, the user's grudge fully depletes the PP of the opponent's move that knocked it out."

	Guard_Split
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user employs its psychic powers to average its Defense and Sp. Def stats with those of the target."

	Guard_Swap
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user employs its psychic power to switch changes to its Defense and Sp. Def stats with the target."

	Guillotine
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 0
		Acc = 0
		desc = "A vicious, tearing attack with big pincers. The target faints instantly if this attack hits."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.level < D.level)
					displayToSystem(C,"But it failed, since [A] is lower level than [D] by [D.level-A.level] levels.")
				else
					var accuracy = (A.level - D.level) + 30
					if(prob(accuracy))
						if(!("Sturdy" in list(D.ability1,D.ability2)))
							if(C.battle.Get_Type_Effect(src,A,D))
								D.HP = 0
								D.status = FAINTED
								for(var/client/CX in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
									CX.Audio.addSound(sound(D.cry,channel=1),"234",TRUE)
									spawn(50) CX.Audio.removeSound("234")
								RewardExp(A,D,C.battle)
							else
								displayToSystem(C,"This Pokémon is immune to the damage caused by this move.")
						else
							displayToSystem(C,"[D] did not get damaged by Guillotine due to its Sturdy ability!")
					else
						displayToSystem(C,"But it missed!")

	Gunk_Shot
		_type = POISON
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 80
		desc = "The user shoots filthy garbage at the target to attack. This may also poison the target."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					paralyzeTarget(C,D)

	Gust
		_type = FLYING
		range = SPECIAL
		PP = 35
		MaxPP = 35
		BP = 40
		Acc = 100
		desc = "A gust of wind is whipped up by wings and launched at the target to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Gyro_Ball
		_type = STEEL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100
		desc = "The user tackles the target with a high-speed spin. The slower the user compared to the target, the greater the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = min(25 * ((D.speed+stages[7 + D.speedBoost])/(A.speed+stages[7 + A.speedBoost])),150)
				doDamage(C,A,D)

	Hail
		_type = ICE
		range = STATUS
		contestType = BEAUTY
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user summons a hailstorm lasting five turns. It damages all Pokémon except the Ice type."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			C.battle.weatherData["Weather"] = HAIL
			C.battle.weatherData["Turns"] = 5
			for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
				if(P.pName=="Castform")
					P.formChange()

	Hammer_Arm
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				modStats(C,A,"speed",-1)

	Happy_Hour
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user doubles money gain by instantly duplicating any coins the player gets from battle. This move only works once per match."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var showMessage = ""
				if(!(C.battle.moneyFlags & HAPPY_HOUR))
					C.battle.moneyFlags |= HAPPY_HOUR
					showMessage = "The happy hour has begun!"
				else
					showMessage = "The happy hour has already started!"
				displayToSystem(C,showMessage)

	Harden
		_type = NORMAL
		range = STATUS
		contestType = TOUGH
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user restricts its blood flow in several points to harden its body. This raises its Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"defense",1)

	Haze
		_type = ICE
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user creates a large haze that elimates all stat changes in the battle."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.E1,C.battle.E2))
					for(var/stat in list("attack","defense","spAttack","spDefense","speed","accuracy","evasion"))
						P.vars["[stat]Boost"] = 0

	Head_Charge
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		recoilDamage = 4

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Head_Smash
		_type = ROCK
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 80
		recoilDamage = 2

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Headbutt
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 70
		Acc = 100
		desc = "The user headbutts the foe with a mighty force. This may make the target flinch."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					D.infoFlags |= FLINCHED

	Heal_Bell
		_type = NORMAL
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null


	Heal_Block
		_type = PSYCHIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100


	Heal_Order
		_type = BUG
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && recoverHealth(C,A)

	Heal_Pulse
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Healing_Wish
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Heart_Stamp
		_type = PSYCHIC
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 100

		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(C,pokemon/A,pokemon/D,extraEffect=FALSE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					D.infoFlags |= FLINCHED

	Heart_Swap
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Heat_Crash
		_type = FIRE
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 0
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Heat_Wave
		_type = FIRE
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 95
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Heavy_Slam
		_type = STEEL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 0
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Helping_Hand
		_type = NORMAL
		range = STATUS
		contestType = SMART
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The player claps its hand to help their ally."

	Hex
		_type = GHOST
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 65
		Acc = 100
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hidden_Power
		_type = NORMAL
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				_type = A.hidden_power_type
				doDamage(C,A,D)

	High_Jump_Kick
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 130
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(!doDamage(C,A,D)) // If the move misses
					if(!("Rock Head" in list(A.ability1,A.ability2)))
						A.HP = max(A.HP-(A.HP/2),0)
						for(var/HPBar/HPB in C.battle.hpBars)
							if(HPB.P == A)
								HPB.updateBar()
						displayToSystem(C,"[A] kept going and \he crashed!")

	Hold_Back
		_type = UNKNOWN
		range = PHYSICAL
		PP = 40
		MaxPP = 40
		BP = 40
		Acc = 100
		letLive = TRUE
		desc = "The user attacks the foe with its better strength. The target cannot be knocked out by this move."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hold_Hands
		_type = NORMAL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null


	Hone_Claws
		_type = DARK
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user violently sharpens its claws to raise its attack stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"attack",3)

	Horn_Attack
		_type = NORMAL
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 65
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Horn_Drill
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 0
		Acc = 0


	Horn_Leech
		_type = GRASS
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 75
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Howl
		_type = NORMAL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null


	Hurricane
		_type = FLYING
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 110
		Acc = 70
		desc = "The user attacks by wrapping its opponent in a fierce wind that flies up into the sky. This may also confuse the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var result = doDamage(C,A,D)
				if(result && prob(30))
					confuseTarget(C,D)

	Hydro_Cannon
		_type = WATER
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hydro_Pump
		_type = WATER
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 110
		Acc = 80
		desc = "The target is blasted by a huge volume of water launched under great pressure."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hyper_Beam
		_type = NORMAL
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hyper_Fang
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hyper_Voice
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Hyperspace_Fury
		_type = DARK
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = null


	Hyperspace_Hole
		_type = PSYCHIC
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 80
		Acc = null


	Hypnosis
		_type = PSYCHIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 60
		desc = "The user employs hypnotic suggestion to make the target fall into a deep sleep."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				sleepTarget(C,A,D)

	Ice_Ball
		_type = ICE
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 30
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Ice_Beam
		_type = ICE
		range = SPECIAL
		contestType = BEAUTY
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		desc = "The target is struck with an icy-cold beam of energy. This may also leave the target frozen."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					freezeTarget(C,D)

	Ice_Burn
		_type = ICE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 140
		Acc = 90


	Ice_Fang
		_type = ICE
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 65
		Acc = 95
		desc = "The user bites with cold-infused fangs. This may also make the target flinch or leave it frozen."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,20))
					if(prob(50))
						D.infoFlags |= FLINCHED
					else
						freezeTarget(C,D)

	Ice_Punch
		_type = ICE
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		desc = "The target is punched with an icy fist. This may also leave the target frozen."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,20))
					freezeTarget(C,D)

	Ice_Shard
		_type = ICE
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Icicle_Crash
		_type = ICE
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 85
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Icicle_Spear
		_type = ICE
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 25
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Icy_Wind
		_type = ICE
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 55
		Acc = 95

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Imprison
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100


	Incinerate
		_type = FIRE
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Inferno
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 50
		desc = "The user attacks by engulfing the target in an intense fire. This leaves the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				burnTarget(C,D)

	Infestation
		_type = BUG
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 20
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Ingrain
		_type = GRASS
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null


	Ion_Deluge
		_type = ELECTRIC
		range = STATUS
		PP = 25
		MaxPP = 25
		BP = null
		Acc = null


	Iron_Defense
		_type = STEEL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user hardens its body's surface like iron, sharply raising its Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"defense",2)

	Iron_Head
		_type = STEEL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Iron_Tail
		_type = STEEL
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 100
		Acc = 75
		desc = "The user slams its tail against the target. The force is so strong it may lower the target's defense."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,30))
					modStats(C,D,"defense",-1)

	ItemUseProxy
		_type = UNKNOWN
		range = STATUS
		PP = 1.#INF
		MaxPP = 1.#INF
		BP = null
		Acc = null

		priority = 7
		var tmp/item/usedItem
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(usedItem.battleUse(A.owner,A,D) && usedItem.consume)
					A.owner.bag.getItem(usedItem.type)

	Judgment
		_type = NORMAL // Default. Changes types with each plate.
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 100
		desc = "The user blasts a large beam of light at the foe that changes type with plates."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(!isnull(A.held))
					switch(A.held.type)
						if(/item/normal/plate/Draco_Plate)_type = DRAGON
						if(/item/normal/plate/Dread_Plate)_type = DARK
						if(/item/normal/plate/Earth_Plate)_type = GROUND
						if(/item/normal/plate/Fist_Plate)_type = FIGHTING
						if(/item/normal/plate/Flame_Plate)_type = FIRE
						if(/item/normal/plate/Icicle_Plate)_type = ICE
						if(/item/normal/plate/Insect_Plate)_type = BUG
						if(/item/normal/plate/Iron_Plate)_type = STEEL
						if(/item/normal/plate/Meadow_Plate)_type = GRASS
						if(/item/normal/plate/Mind_Plate)_type = PSYCHIC
						if(/item/normal/plate/Pixie_Plate)_type = FAIRY
						if(/item/normal/plate/Shock_Plate)_type = ELECTRIC
						if(/item/normal/plate/Shine_Plate)_type = LIGHT
						if(/item/normal/plate/Sky_Plate)_type = FLYING
						if(/item/normal/plate/Splash_Plate)_type = WATER
						if(/item/normal/plate/Spooky_Plate)_type = GHOST
						if(/item/normal/plate/Stone_Plate)_type = ROCK
						if(/item/normal/plate/Toxic_Plate)_type = POISON
						else _type = NORMAL
				else
					_type = NORMAL

				doDamage(C,A,D)

	Jump_Kick
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 95

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(!doDamage(C,A,D)) // If the move misses
					if(!("Rock Head" in list(A.ability1,A.ability2)))
						A.HP = max(A.HP-(A.HP/2),0)
						for(var/HPBar/HPB in C.battle.hpBars)
							if(HPB.P == A)
								HPB.updateBar()
						displayToSystem(C,"[A] kept going and \he crashed!")

	Karate_Chop
		_type = FIGHTING
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 50
		Acc = 100
		highCrit = TRUE
		desc = "The user performs a basic Karate Attack. This move has a high critical hit ratio."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Kinesis
		_type = PSYCHIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 80

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"accuracy",-1)

	King\'\s_Shield
		_type = STEEL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "Aegislash will use this move to transform back into Shield forme."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if((A.pName=="Aegislash") && (A.form == "-Blade"))
					var pokemon/P = get_pokemon("Aegislash",A.owner)
					A.fsprite.icon = P.fsprite.icon
					A.bsprite.icon = P.bsprite.icon
					A.stats = P.stats
					A.form = P.form
					A.stat_calculate()

	Knock_Off
		_type = DARK
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(D.held)
					D.removedItem = D.held
					D.held = null
					displayToSystem(C,"[D]'s [D.removedItem] has been knocked off!")


	Land\'\s_Wrath
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100


	Last_Resort
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 140
		Acc = 100


	Lava_Plume
		_type = FIRE
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user torches everything around it with an inferno of scarlet flames. This may also leave those hit with a burn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(30))
					burnTarget(C,A,D)

	Leaf_Blade
		_type = GRASS
		range = PHYSICAL
		contestType = COOL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100


	Leaf_Storm
		_type = GRASS
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 130
		Acc = 90


	Leaf_Tornado
		_type = GRASS
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 65
		Acc = 90


	Leech_Life
		_type = BUG
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		Absorber = TRUE

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Leech_Seed
		_type = GRASS
		range = STATUS
		contestType = SMART
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 90
		desc = "A seed is planted on the target. It steals some HP from the target every turn."

	Leer
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100
		desc = "The user gives opposing Pokémon an intimidating leer that lowers the Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"defense",-1)

	Lick
		_type = GHOST
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 30
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Light_of_Ruin
		_type = FAIRY
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 140
		Acc = 90


	Light_Screen
		_type = PSYCHIC
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "A wondrous wall of light is put up to reduce damage from special attacks for five turns."

	Lock\-\On
		_type = NORMAL
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = 100


	Lovely_Kiss
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 75


	Low_Kick
		_type = FIGHTING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100


	Low_Sweep
		_type = FIGHTING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100


	Lucky_Chant
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null


	Lunar_Dance
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Luster_Purge
		_type = PSYCHIC
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 70
		Acc = 100


	Mach_Punch
		_type = FIGHTING
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100
		priority = 3
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Magic_Coat
		_type = PSYCHIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null


	Magic_Room
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Magical_Leaf
		_type = GRASS
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = null
		desc = "The user scatters curious leaves that chase the target. This attack never misses."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Magma_Storm
		_type = FIRE
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 100
		Acc = 75


	Magnet_Bomb
		_type = STEEL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = null


	Magnet_Rise
		_type = ELECTRIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Magnetic_Flux
		_type = ELECTRIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null


	Magnitude
		_type = GROUND
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var powerLevel = pick(prob( 5 ); 4,
						  prob( 10); 5,
						  prob( 20); 6,
						  prob( 30); 7,
						  prob( 20); 8,
						  prob( 10); 9,
						  prob( 5 );10)
				switch(powerLevel)
					if(4 ) BP = 10
					if(5 ) BP = 30
					if(6 ) BP = 50
					if(7 ) BP = 70
					if(8 ) BP = 90
					if(9 ) BP = 110
					if(10) BP = 150
				if(upgradeFlags & MOVE_UPGRADED)BP += 30
				displayToSystem(C,"Magnitude[(upgradeFlags & MOVE_UPGRADED)?("(U)"):("")] [powerLevel]")
				doDamage(C,A,D)
				BP = null

	Mat_Block
		_type = FIGHTING
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Me_First
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null


	Mean_Look
		_type = NORMAL
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null


	Meditate
		_type = PSYCHIC
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null


	Mega_Drain
		_type = GRASS
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 100
		Absorber = TRUE

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Mega_Kick
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 75

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Mega_Punch
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 80
		Acc = 85

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Megahorn
		_type = BUG
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 85

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Memento
		_type = DARK
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100


	Metal_Burst
		_type = STEEL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100


	Metal_Claw
		_type = STEEL
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 50
		Acc = 95

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(10))
					modStats(C,A,"attack",1)

	Metal_Sound
		_type = STEEL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = 85

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && modStats(C,D,"spDefense",-2)

	Meteor_Mash
		_type = STEEL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 100
		Acc = 90

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && doDamage(C,A,D) && prob(20) && modStats(C,A,"attack",2)

	Metronome
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user someone uses a move they may not have known before."
		New()
			..()
			if(isnull(selectableMovesByType))selectableMovesByType = list()
			if(isnull(selectableMovesByType["Metronome"]))
				selectableMovesByType["Metronome"] = typesof(/pmove)-list(/pmove,/pmove/Metronome)
				for(var/theType in selectableMovesByType["Metronome"])
					if(findtextEx("[theType]","Proxy"))
						selectableMovesByType["Metronome"] -= theType
				var thisListOfShit[] = list(
				"/pmove/After_You",
				"/pmove/Assist",
				"/pmove/Bestow",
				"/pmove/Chatter",
				"/pmove/Copycat",
				"/pmove/Counter",
				"/pmove/Covet",
				"/pmove/Destiny_Bond",
				"/pmove/Detect",
				"/pmove/Dragon's_Doom",
				"/pmove/Endure",
				"/pmove/Feint",
				"/pmove/Focus_Punch",
				"/pmove/Follow_Me",
				"/pmove/Freeze_Shock",
				"/pmove/Helping_Hand",
				"/pmove/Ice_Burn",
				"/pmove/Me_First",
				"/pmove/Mimic",
				"/pmove/Mirror_Coat",
				"/pmove/Mirror_Move",
				"/pmove/Nature_Power",
				"/pmove/Protect",
				"/pmove/Quash",
				"/pmove/Quick_Guard",
				"/pmove/Rage_Powder",
				"/pmove/Relic_Song",
				"/pmove/Secret_Sword",
				"/pmove/Sketch",
				"/pmove/Sleep_Talk",
				"/pmove/Snarl",
				"/pmove/Snatch",
				"/pmove/Snore",
				"/pmove/Struggle",
				"/pmove/Switcheroo",
				"/pmove/Techno_Blast",
				"/pmove/Theif",
				"/pmove/Transform",
				"/pmove/Trick",
				"/pmove/V-create",
				"/pmove/Wide_Guard",
				"/pmove/Outrage")
				for(var/index in 1 to length(thisListOfShit))
					thisListOfShit[index] = text2path(thisListOfShit[index])
				selectableMovesByType["Metronome"] -= thisListOfShit
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var theChosenMove = pick(selectableMovesByType["Metronome"])
				var pmove/M = new theChosenMove
				displayToSystem(C,"[A] called [M] using Metronome!")
				M.effect(C,A,D,0)

	Milk_Drink
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user drinks some milk to restore a great sum of lost health."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && recoverHealth(C,A)

	Mimic
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user copies the foe's move and it gets led with 5 PP."

	Mind_Reader
		_type = PSYCHIC
		range = STATUS
		contestType = SMART
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "The user senses the target's movements with its mind to ensure its next attack does not miss the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				D.lockedOn = TRUE
				displayToSystem(C,"The user has locked onto the target!")

	Minimize
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user compresses its body to make itself look smaller, which sharply raises its evasiveness."

	Miracle_Eye
		_type = PSYCHIC
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The user looks at the foe with a psychic energy. This allows Psychic-Type moves to hit Dark Types and allows evasive foes to be hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				D.evasionBoost = 0
				D.infoFlags |= MIRACLE_EYE
				for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
					var player/P = CL.mob
					P.ShowText("[D] has been identified!")

	Mirror_Coat
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Mirror_Move
		_type = FLYING
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user counters the target by mimicking the target's last move."

/*
	Mirror_Shot
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Mist
		_type = ICE
		range = STATUS
		contestType = BEAUTY
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user cloaks itself and its allies in a white mist that prevents any of their stats from being lowered for five turns."

	Mist_Ball
		_type = PSYCHIC
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 70
		Acc = 100
		desc = "A mist-like flurry of down envelops and damages the target. This may also lower the target's Sp. Atk stat"
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(50))
					modStats(C,D,"spAttack",-1)
/*
	Misty_Terrain
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Moonblast
		_type = FAIRY
		range = SPECIAL
		PP = 25
		MaxPP = 25
		BP = 95
		Acc = 100
		desc = "The user attacks the target using the power of the moon! The foe's Special Attack may be lowered."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && doDamage(C,A,D) && prob(20) && modStats(C,D,"spAttack",-1)

	Moonlight
		_type = DARK
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "This move draws in moon energy to heal the user."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				recoverHealth(C,A)

	Morning_Sun
		_type = LIGHT
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "This move draws in power from the sun to heal the user."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				recoverHealth(C,A)

	Mud_Bomb
		_type = GROUND
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 70
		Acc = 95
		desc = "The user launches a hard-packed mud ball to attack. The target's accuracy may be lowered."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && doDamage(C,A,D) && prob(30) && modStats(C,D,"accuracy",-1)

	Mud_Shot
		_type = GROUND
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 55
		Acc = 100
		desc = "Hurls mud at the foe and reduces speed."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && doDamage(C,A,D) && modStats(C,D,"speed",-1)

	Mud_Sport
		_type = GROUND
		range = STATUS
		contestType = CUTE
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user covers itself up with mud to lower the power of Electric-Type moves."

	Mud\-\Slap
		_type = GROUND
		range = SPECIAL
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = 40
		Acc = 100
		desc = "The user hurls mud in the target's face and lower its accuracy."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					modStats(C,D,"accuracy",-1)


	Muddy_Water
/*
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Multi\-\Attack
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		desc = "The signature attack of Silvally. This move's type will match that of the user's held Memory."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(isnull(A.held))
					src._type = NORMAL
				else
					switch(A.held.type)
						if(/item/normal/memory/Bug_Memory)src._type = BUG
						if(/item/normal/memory/Dark_Memoy)src._type = DARK
						if(/item/normal/memory/Dragon_Memory)src._type = DRAGON
						if(/item/normal/memory/Electric_Memory)src._type = ELECTRIC
						if(/item/normal/memory/Fairy_Memory)src._type = FAIRY
						if(/item/normal/memory/Fighting_Memory)src._type = FIGHTING
						if(/item/normal/memory/Fire_Memory)src._type = FIRE
						if(/item/normal/memory/Flying_Memory)src._type = FLYING
						if(/item/normal/memory/Ghost_Memory)src._type = GHOST
						if(/item/normal/memory/Grass_Memory)src._type = GRASS
						if(/item/normal/memory/Ground_Memory)src._type = GROUND
						if(/item/normal/memory/Ice_Memory)src._type = ICE
						if(/item/normal/memory/Light_Memory)src._type = LIGHT
						if(/item/normal/memory/Poison_Memory)src._type = POISON
						if(/item/normal/memory/Psychic_Memory)src._type = PSYCHIC
						if(/item/normal/memory/Rock_Memory)src._type = ROCK
						if(/item/normal/memory/Steel_Memory)src._type = STEEL
						if(/item/normal/memory/Water_Memory)src._type = WATER
				. = doDamage(C,A,D)

/*

	Mystical_Fire
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Nasty_Plot
		_type = DARK
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user thinks of dirty tricks to help it in combat. This inscreases their special attack by two stages."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			. && modStats(C,A,"spAttack",2)

	Natural_Gift
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user draws power to attack by using its held Berry. The Berry determines the move's type and power."

	Nature_Power
		_type = NORMAL
		range = STATUS
		contestType = BEAUTY
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user calls upon the powers of nature to summon another move."

	Needle_Arm
		_type = GRASS
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 100
		desc = "The user attacks with thorny arms that can cause the foe to flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(. && doDamage(C,A,D) && prob(30))
				D.infoFlags |= FLINCHED

/*
	Night_Daze
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Night_Shade
		_type = GHOST
		range = SPECIAL
		contestType = SMART
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user makes the target see a frightening mirage. It inflicts damage equal to the user's level."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				fixedDamage(C,A,D,A.level)

	Night_Slash
		_type = DARK
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 70
		Acc = 100
		highCrit = TRUE
		desc = "The user slashes the foe the instant an opportunity arises. Crits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Nightmare
		_type = GHOST
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "A sleeping target sees a nightmare that inflicts some damage every turn."


	Noble_Roar
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100
		soundMove = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"attack",-1)
					modStats(C,D,"attack",-1)


/*

	Nuzzle
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Oblivion_Wing
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Obsidian_Crush
		_type = ROCK
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		hasSecondaryEffect = TRUE
		desc = "The user's claws crush the foe with force strong enough to break even obsidian. Hitting a target sharply raises the Attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"attack",2)

	Octazooka
		_type = WATER
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 65
		Acc = 85
		desc = "The user attacks by spraying ink at the target's face or eyes. This may also lower the target's accuracy."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(50))
					modStats(C,D,"accuracy",-1)

	Odor_Sleuth
		_type = NORMAL
		range = STATUS
		contestType = SMART
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The user sniffs out the foe, allowing it to hit Ghost-Types with Normal and Fighting-Type Moves. It also allows evasive foes to be hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				D.evasionBoost = 0
				D.infoFlags |= FORESIGHT
				for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
					var player/P = CL.mob
					P.ShowText("[D] has been identified!")
/*
	Ominous_Wind
		_type =
		range =
		PP
		MaxPP =
		BP =
		Acc =

*/

	Origin_Pulse

	Outrage
		_type = DRAGON
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 100
		desc = "The user rampages and attacks for two to three turns. It then becomes confused, however."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var pmove/Outrager/O = new
				A.volatileStatus["raging"] = pick(2,3)
				if(C.battle.P1 == A)
					C.battle.chosenMoveData["P1"]["move"] = O
				else if(C.battle.P2 == A)
					C.battle.chosenMoveData["P2"]["move"] = O
				else if(C.battle.E1 == A)
					C.battle.chosenMoveData["E1"]["move"] = O
				else if(C.battle.E2 == A)
					C.battle.chosenMoveData["E2"]["move"] = O
				O.effect(C,A,D)

	Outrager
		_type = DRAGON
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 100
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
				if((--A.volatileStatus["raging"])==0)
					confuseTarget(C,A)
			else
				if((--A.volatileStatus["raging"])==0)
					confuseTarget(C,A)
				A.volatileStatus["raging"] = 0

	Overheat
		_type = FIRE
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 70
		desc = "The user overheats violently to attack the foe. It deals a lot of damage, but lowers the Sp. Attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					modStats(C,A,"spAttack",-1)

	Pain_Split
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user adds its HP to the target's HP, then equally shares the combined HP with the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var theHP = A.HP + D.HP
				A.HP = round(max(min(theHP/2,A.maxHP),0))
				D.HP = round(max(min(theHP/2,D.maxHP),0))
				for(var/HPBar/HPB in A.owner.client.battle.hpBars)
					if(HPB.P in list(A,D))
						HPB.updateBar()

/*
	Parabolic_Charge
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Parting_Shot
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Pay_Day
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		desc = "Numerous coins are hurled at the target to inflict damage. Money is earned after the battle."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var moneyAdded = A.level*5
				C.battle.payDayMoney += moneyAdded
				doDamage(C,A,D)
				for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
					var player/P = CL.mob
					P.ShowText("Coins Scattered Everywhere!")
/*
	Payback
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Peck
		_type = FLYING
		range = PHYSICAL
		contestType = COOL
		PP = 35
		MaxPP = 35
		BP = 35
		Acc = 100
		desc = "The target is jabbed with a sharply pointed beak or horn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)


	Perish_Song
		_type = NORMAL
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "Any Pokémon that hears this song faints in three turns, unless it switches out of battle."

	Pursuit
		_type = DARK
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		desc = "An attack move that inflicts double damage if used on a target that is switching out of battle."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Petal_Blizzard
		_type = GRASS
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		desc = "The user stirs up a violent petal blizzard and attacks everything around it."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Petal_Dance
		_type = GRASS
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 100
		desc = "Petals are scattered two to three times to attack the target. The user is temporarily immobolized."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

/*	Phantom_Force
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Pin_Missile
		_type = BUG
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 25
		Acc = 100
		desc = "Sharp spikes are shot at the target in rapid succession. They hit five times in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,5,5)


	Play_Nice
		_type = FAIRY
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user becomes friends with the target, making the target lose its will to fight. All stats other than Accuracy and Evasion are lowered."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"attack",-1)
				modStats(C,D,"defense",-1)
				modStats(C,D,"spAttack",-1)
				modStats(C,D,"spDefense",-1)
				modStats(C,D,"speed",-1)

	Play_Rough
		_type = FAIRY
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 90
		desc = "The user tries to play with the foe, but ends of harshly attacking him."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(. && doDamage(C,A,D) && prob(10))
				modStats(C,D,"attack",-1)

/*
	Pluck
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Poison_Fang
/*
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Poison_Gas
		_type = POISON
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "A cloud of poison gas is sprayed in the face of opposing Pokémon. This may also poison those hit."

/*
	Poison_Jab
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =
		 */

	Poison_Powder
		_type = POISON
		range = STATUS
		contestType = SMART
		PP = 35
		MaxPP = 35
		BP = null
		Acc = 75
		desc = "The user scatters a cloud of poisonous dust on the target. This may also poison the target."
		Spore_Move = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				poisonTarget(C,A,D)

	Poison_Sting
		_type = POISON
		range = PHYSICAL
		contestType = SMART
		PP = 35
		MaxPP = 35
		BP = 15
		Acc = 100
		desc = "The user stabs the target with a poisonous stinger. This may also poison the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(30))
					poisonTarget(C,D)


	Poison_Tail
/*
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =
		 */

	Pound
		_type = NORMAL
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 40
		Acc = 100
		desc = "The target is physically pounded with a long tail or a foreleg, etc."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

/*	Powder
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Powder_Snow
		_type = ICE
		range = SPECIAL
		contestType = BEAUTY
		PP = 25
		MaxPP = 25
		BP = 40
		Acc = 100
		desc = "The user attacks with a chilling gust of powdery snow. This may also freeze the opposing Pokemon."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
/*
	Power_Gem
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Power_Split
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Power_Swap
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Power_Trick
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Power_Whip
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Power\-\Up_Punch
		_type = FIGHTING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		desc = "Striking the opponent over and over makes the user's fists harder. Hitting a target raises the attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					modStats(C,A,"attack",1)

	Precipice_Blades

	Present
		_type = NORMAL
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user attacks by giving the target a gift with a hidden trap. It restores HP sometimes, however."

	Protect
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		priority = 4
		desc = "The user is protected from most attacks. However, Moves like Feint break it."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var decayTurns = (A.protectTurns>1)?(A.protectTurns*2):(A.protectTurns)
				if(prob((1/decayTurns)*100))
					A.infoFlags |= PROTECTED
				else
					displayToSystem(C,"But it failed!")

	Psybeam
		_type = PSYCHIC
		range = SPECIAL
		contestType = BEAUTY
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		desc = "The user generates odd sound waves from its body that confuse the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var result = doDamage(C,A,D)
				if(result && prob(10))
					confuseTarget(C,D)

	Psych_Up
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Psychic
		_type = PSYCHIC
		range = SPECIAL
		contestType = SMART
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		desc = "The target is hit by a strong telekinetic force. This may also lower the target's Sp. Def stat. Out of combat, \
		this move can move heavy boulders."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(10))
					modStats(C,D,"spDefense",-1)

	Psycho_Boost
/*
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Psycho_Cut
		_type = PSYCHIC
		range = PHYSICAL
		PP =
		MaxPP =
		BP =
		Acc =


	Psycho_Shift
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Psyshock
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Psystrike
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Psywave
		_type = PSYCHIC
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100

/*
	Punishment
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Pursuit
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Quash
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =
		 */

	Quick_Attack
		_type = NORMAL
		range = PHYSICAL
		contestType = COOL
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100
		priority = 1
		desc = "The user lunges at the target at a speed that makes it almost invisible. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

/*	Quick_Guard
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Quiver_Dance
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Rage
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 50
		Acc = 100
		desc = "As long as this move is in use, this Pokémon gains increased power, attack stat, and flinch change."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = 50 + (10 * (A.rageStacks))
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,etraEffect=TRUE)
			. = ..()
			if(.)
				var flinchChance = 2**A.rageStacks
				if(sereneProb(src,flinchChance))
					D.infoFlags |= FLINCHED

/*
	Rage_Powder
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =
		 */

	Rain_Dance
		_type = WATER
		range = STATUS
		contestType = TOUGH
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "The user summons a heavy rain that falls for five turns, powering up Water-type moves."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				C.battle.weatherData["Weather"] = RAINY
				C.battle.weatherData["Turns"] = 5
				for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
					if(P.pName=="Castform")
						P.formChange()

	Rapid_Spin
		_type = NORMAL
		range = PHYSICAL
		PP = 40
		MaxPP = 40
		BP = 20
		Acc = 100
		desc = "A spin attack that can also eliminate such moves as Bind, Wrap, Leech Seed, and Spikes."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Ray_of_Light
		_type = LIGHT
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user creates a powerful light ray that damages the foe. This also harshly lowers the foe's accuracy."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"accuracy",-2)

	Razor_Leaf
		_type = GRASS
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 55
		Acc = 95
		desc = "Sharp-edged leaves are launched to slash at the opposing Pokémon. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Razor_Shell

	Razor_Wind
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		highCrit = TRUE
		desc = "A two-turn attack. Blades of wind hit opposing Pokémon on the second turn. Critical hits land more easily."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	RecallProxy
		_type = UNKNOWN
		range = STATUS
		PP = 1.#INF
		MaxPP = 1.#INF
		BP = null
		Acc = null
		var pokemon/monSwitch
		var showUserQuote = TRUE
		priority = 6
		effect(client/C,pokemon/A,pokemon/D)
			var player/P = A.owner
			var battleSystem/battle = P.client.battle
			A.rageStacks = 0
			monSwitch.fsprite.screen_loc = A.fsprite.screen_loc
			monSwitch.bsprite.screen_loc = A.bsprite.screen_loc
			monSwitch.fsprite.transform = A.fsprite.transform
			monSwitch.bsprite.transform = A.bsprite.transform
			var quote = pick("come back!","that's enough. Come back!","you did good. Return!")
			displayToSystem(C,"[A], [quote]")
			for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
				CL.screen.Remove(A.fsprite,A.bsprite)
			for(var/x in A.volatileStatus)
				A.volatileStatus[x] = 0
			for(var/x in list("attack","defense","spAttack","spDefense","speed","accuracy","evasion"))
				A.vars["[x]Boost"] = 0
			var theText = battle.getPokemonText(A)
			battle.vars["[theText]"] = monSwitch
			battle.partyPos["[theText]"] = P.party.Find(monSwitch,1,7)
			battle.ownerParticipatedList += monSwitch
			quote = pick("go get em!","attack!","they're weakening. GET IT!","you're up next!")
			displayToSystem(C,"[monSwitch], [quote]")
			battle.chosenMoveData["[theText]"]["pokemon"] = monSwitch
			battle.activePokemon[battle.getPlayerText(P)] = monSwitch
			for(var/x in A.ivars)
				A.vars[x] = A.ivars[x]
			for(var/HPBar/H in battle.hpBars)
				if(H.P==A)
					H.changePKMN(monSwitch)

			for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
				var theSprite
				if(monSwitch in list(battle.P1,battle.P2))
					if(CL in list(battle.C1,battle.C3))
						theSprite = monSwitch.bsprite
					else
						theSprite = monSwitch.fsprite
				else
					if(CL in list(battle.C1,battle.C3))
						theSprite = monSwitch.fsprite
					else
						theSprite = monSwitch.bsprite
				CL.screen += theSprite
			battle.activateEntryHazards(monSwitch)

	Recover
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user recovers half of its HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				recoverHealth(C,A)

	Recharge
		_type = ELECTRIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user recovers half of its HP. If the Pokémon is charged up, it recovers all of its HP instead."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				recoverHealth(C,A)

	Recycle

	Reflect
		_type = PSYCHIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "A wondrous wall of light is put up to reduce damage from physical attacks for five turns."

	Reflective_Shield
		_type = LIGHT
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user creates a light shield that protects it from special energy, sharply raising its Special Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spDefense",2)

	Reflect_Type

	Refresh

	Relic_Song
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 75
		Acc = 100
		desc = "The user sings a long-forgotten song and attacks by touching the hearts of those who listen. It can cause foes to sleep."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(A.pName == "Meloetta")
				var theMon = (A.form=="-P")?("Meloetta"):("Meloetta-P")
				var pokemon/P = get_pokemon(theMon,A.owner)
				A.form = P.form
				A.stats = P.stats
				A.evYield = P.evYield
				A.fsprite.icon = P.fsprite.icon
				A.bsprite.icon = P.bsprite.icon
				A.menuIcon = P.menuIcon
				A.sprite.icon = P.sprite.icon
			if(. && doDamage(C,A,D) && prob(10))
				sleepTarget(C,D,5,10)

	Rest
		_type = PSYCHIC
		range = STATUS
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user takes a nap and recovers all of its HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if((!("Insomnia" in list(A.ability1,A.ability2))) && (!("Vital Spirit" in list(A.ability1,A.ability2))))
					A.status = ""
					A.HP = A.maxHP
					sleepTarget(C,A,minTurns=2,maxTurns=2)
					for(var/HPBar/HPB in C.battle.hpBars)
						if(HPB.P == A)
							HPB.updateBar()
				else
					displayToSystem(C,"[A] couldn't fall asleep!")

	Retaliate

	Return
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 1000
		desc = "The user uses the force of its friendship with its owner to deal damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = ceil(min(max(A.friendship/2.5,1),102))
				doDamage(C,A,D)
				BP = null

	Revenge

	Reversal

	Roar
		_type = NORMAL
		range = STATUS
		contestType = COOL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		priority = -6
		soundMove = TRUE
		desc = "The user roars loudly at the foe, scaring it from battle."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.flags & WILD_BATTLE)
					for(var/player/P in list(C.battle.owner,C.battle.foe,C.battle.player3,C.battle.player4))
						P.ShowText("The enemy has been scared away!")
					del C.battle

	Roar_of_Time

	Rock_Blast
		_type = ROCK
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 25
		Acc = 95
		desc = "The user hurls boulders at the target. Two to five boulders can be launched in a row."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,5)

	Rock_Climb
		_type = ROCK
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 110
		Acc = 90
		desc = "The user charges into the target with incredible force. This attack may cause confusion. It can also be used to scale rocky walls."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect)
			. = ..()
			if(.)
				if(sereneProb(src,20))
					confuseTarget(C,D)

	Rock_Polish
		_type = ROCK
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user polishes its body to reduce drag. This will sharly increase the user's Speed."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"speed",2)

	Rock_Slide
		_type = ROCK
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 75
		Acc = 90
		desc = "Large boulders are hurled at the opposing Pokémon to inflict damage. This may also make the opposing Pokémon flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(30))
					D.infoFlags |= FLINCHED

	Rock_Smash
		_type = FIGHTING
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 150
		Acc = 100
		desc = "The user throws a rock-shattering punch that lowers the target's defense stat. This may also destroy boulders."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(ROCK in list(D.type1,D.type2,D.type3))
					BP = 250
				else
					BP = 150
				if(doDamage(C,A,D))
					modStats(C,D,"defense",-1)
				BP = 150
		canForget(player/P)
			if(istype(P,/client))P = P:mob
			var
				turf/T = P.loc
				area/A = T.loc
				otherPokemonHasMove = FALSE
			for(var/x in 1 to 6)
				var pokemon/PK = P.party[x]
				if(locate(/pmove/Rock_Smash) in PK.moves)otherPokemonHasMove = TRUE
			return ((!otherPokemonHasMove) && (!(locate(/smashBoulder) in A)))

	Rock_Throw
		_type = ROCK
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 50
		Acc = 90
		desc = "The user picks up and throws a small rock at the target to attack."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Rock_Tomb
		_type = ROCK
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 95
		desc = "Boulders are hurled at the target. This also lowers the target's Speed stat by preventing its movement."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					modStats(C,D,"speed",-1)

	Rock_Wrecker

	Role_Play

	Rolling_Kick
		_type = FIGHTING
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 85
		desc = "The user lashes out with a quick, spinning kick. This may also make the target flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Rollout
		_type = ROCK
		range = PHYSICAL
		contestType = TOUGH
		PP = 20
		MaxPP = 20
		BP = 30
		Acc = 90
		desc = "The user continually rolls into the target over five turns. It becomes more powerful each time it hits."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Roost

	Rototiller

	Round
		_type = NORMAL
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 60
		Acc = 100
		desc = "The user sings a song to attack the foe. If an ally joins in the song, the attack will be stronger."
		soundMove = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Sacred_Fire

	Sacred_Sword

	Safeguard
		_type = NORMAL
		range = STATUS
		PP = 25
		MaxPP = 25
		BP = null
		Acc = null
		desc = "The user creates a protective field that prevents status conditions for five turns."

	Sand_Attack
		name = "Sand-Attack"
		_type = GROUND
		range = STATUS
		contestType = CUTE
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"accuracy",-1)

	Sand_Tomb

	Sandstorm
		_type = ROCK
		range = STATUS
		PP = 25
		MaxPP = 25
		BP = null
		Acc = null
		desc = "A five-turn sandstorm is summoned to hurt all combatants except the Rock, Ground, and Steel types."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				C.battle.weatherData["Weather"] = SANDSTORM
				C.battle.weatherData["Turns"] = 5
				for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
					if(P.pName=="Castform")
						P.formChange()

	Scald
		_type = WATER
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 100
		Acc = 100
		desc = "The user shoots boiling hot water at its target. This may leave the target with a burn."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(D.status == FROZEN)
					D.status = ""
					displayToSystem(C,"[A]'s Steam Eruption thawed [D] out from [genderGet(D,"her")] frozen state!")
				if(sereneProb(src,30))
					burnTarget(C,D)

	Scary_Face
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The user frightens the target with a scary face to harshly lower its Speed stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(C,A,src))
					modStats(C,D,"speed",-2)

	Scratch
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 35
		MaxPP = 35
		BP = 40
		Acc = 100
		desc = "Hard, pointed, and sharp claws rake the target to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Screech
		_type = NORMAL
		range = STATUS
		contestType = SMART
		PP = 35
		MaxPP = 35
		BP = null
		Acc = 85
		soundMove = TRUE
		desc = "An earsplitting screech harshly lowers the target's Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"defense",-2)

	Searing_Shot

	Secret_Power

	Secret_Sword
		name = "Secret Sword"
		BP = 100
		range = SPECIAL
		defendType = PHYSICAL
		PP = 10
		MaxPP = 10
		Acc = 100
		desc = "Although the user slashes the foe with a special power, it does physical damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Seed_Bomb
		_type = GRASS
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user slams a barrage of hard-shelled seeds on the target from above."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Seed_Flare

	Seismic_Toss
		_type = FIGHTING
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The target is thrown using the power of gravity. It inflicts damage equal to the user's level."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				fixedDamage(C,A,D,A.level)

	Self\-\Destruct
		_type = NORMAL
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 200
		Acc = 100
		desc = "The user attacks everything around it by causing an explosion. The user faints upon using this move."

	Shadow_Ball
		_type = GHOST
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user hurls a shadowy blob at the target. This may also lower the target's Sp. Def stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(20))
					modStats(C,D,"spDefense",-1)

	Shadow_Claw
		_type = GHOST
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 70
		Acc = 100
		highCrit = TRUE
		desc = "The user slashes the foe with a sharp, shadowy claw. This move will land critical hits more often."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Shadow_Force

	Shadow_Punch

	Shadow_Sneak
		_type = GHOST
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 80
		Acc = 100
		priority = 3
		desc = "The user extends its shadow and attacks the foe from behind. This move will always go first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Sharpen

	Sheer_Cold

	Shell_Smash

	Shift_Gear

	Shine
		_type = LIGHT
		range = SPECIAL
		contestType = BEAUTY
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 100
		desc = "The user shines a bright light in the target's eyes. This may also leave the target with confusion."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				var chance = (battleFlags & SERENE_GRACE)?(60):(30)
				if(prob(chance))
					confuseTarget(C,D)

	Shock_Wave

	Signal_Beam

	Silver_Wind

	Simple_Beam

	Sing
		_type = NORMAL
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 55
		desc = "A soothing lullaby is sung in a calming voice that puts the target into a deep slumber."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				sleepTarget(C,A,D,TRUE)

	Sketch
		_type = NORMAL
		range = STATUS
		PP = 1
		MaxPP = 1
		BP = null
		Acc = null

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var pmove/newMove
				if(!D.lastMoveUsed)
					for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
						var player/P = CL.mob
						P.ShowText("But it failed!")
				else
					newMove = new D.lastMoveUsed.type
					if(D.lastMoveUsed.type in list(/pmove/Sketch,/pmove/Chatter))
						for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
							var player/P = C.mob
							P.ShowText("But it failed!")
						return
					for(var/client/CL in list(C.battle.C1,C.battle.C2,C.battle.C3,C.battle.C4))
						var player/P = CL.mob
						P.ShowText("[A.name] copied [D.name]'s [newMove.name]")
				if(newMove)
					var pos = A.moves.Find(src)
					A.moves.Insert(pos,newMove)
					A.moves.Cut(pos+1,pos+2)
					src = null
					del src

	Skill_Swap

	Skull_Bash
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 130
		Acc = 100
		desc = "The user tucks in its head to raise its Defense in the first turn, then rams the target on the next turn."

	Sky_Attack

	Sky_Drop

	Sky_Uppercut

	Slack_Off
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user lazily loafs around as it takes a nap, restoring HP."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				recoverHealth(C,A)

	Slam
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 80
		Acc = 100
		desc = "The target is slammed with a long tail, vines, or the like to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Slash
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 70
		Acc = 100
		desc = "The target is attacked with a slash of claws or blades. Critical hits land more easily."
		highCrit = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Sleep_Powder
		_type = GRASS
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 75
		desc = "The user scatters a big cloud of sleep-inducing dust around the target."
		Spore_Move = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				sleepTarget(C,A,D)

	Sleep_Talk

	Sludge

	Sludge_Bomb

	Sludge_Wave

	Smack_Down
		_type = ROCK
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 50
		Acc = 100
		desc = "The user throws a stone or similar projectile to attack an opponent. A flying Pokémon will fall to the ground when it's hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Smash
		_type = GROUND
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 80
		Acc = 100
		desc = "The user jumps in the air to slam on the ground quickly after, damaging whatever was under it."
		upgrade_info = "When upgraded, the user slams on its torso and creates a shock wave that stuns an enemy if it misses."
		upgradeFlags = (0 | MOVE_UPGRADEABLE)
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		missEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(. && (upgradeFlags & MOVE_UPGRADED))
				paralyzeTarget(C,D)

	Smelling_Salts

	Smog
		_type = POISON
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 30
		Acc = 70
		desc = "The target is attacked with a discharge of filthy gases. This may also poison the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Smokescreen
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user releases an obscuring cloud of smoke or ink. This lowers the target's accuracy."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"accuracy",-1)

	Snarl

	Snatch

	Snore

	Soak

	Soft\-\Boiled

	Solar_Beam
		_type = LIGHT
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 100
		desc = "A two-turn attack. The user gathers light, then blasts a bundled beam on the next turn."

	Solar_Flare
		_type = LIGHT
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 100
		desc = "A powerful flash of brigntness is created by the user from the power of the sun. This move may blind the foe."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(sereneProb(src,15))
					blindTarget(C,D)

	Sonic_Boom
		_type = NORMAL
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 90
		desc = "The target is hit with a destructive shock wave that always inflicts 20 HP damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				fixedDamage(C,A,D,20)

	Spacial_Rend

	Spark
		_type = ELECTRIC
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		desc = "The user throws an electrically charged tackle at the target. This may also leave the target with paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(30))
					paralyzeTarget(C,A,D)

	Spider_Web

	Spike_Cannon

	Spikes
		_type = STEEL
		range = STATUS
		contestType = SMART
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user throws a line of metal spikes around the opponent's side of the field. Grounded switch-in foes are harmed by these spikes."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var enemyHazardsList[]
				if(A in list(C.battle.P1,C.battle.P2))
					enemyHazardsList = C.battle.entryHazardsE
				else
					enemyHazardsList = C.battle.entryHazardsP
				if(enemyHazardsList[SPIKES]<3)
					enemyHazardsList[SPIKES] += 1
					displayToSystem(C,"[A] has thrown a line of metal spikes around [D]'s side of the field!")
				else
					displayToSystem(C,"There are already three lines of metal spikes around [D]'s side of the field!")

	Spiky_Shield

	Spit_Up
		_type = NORMAL
		range = SPECIAL
		contestType = TOUGH
		PP = 10
		BP = null
		Acc = 100
		desc = "The user unleashes its stockpiled energy to attack. This move is more dangerous when a Pokémon has stockpiled more energy."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.stockpiles == 0)
					displayToSystem(C,"[A] has not stockpiled any energy to spit up!")
				else
					BP = A.stockpiles*100
					displayToSystem(C,"[A] has unleashed its stockpiled energy!")
					. = doDamage(C,A,D)
					modStats(C,A,"defense",-A.stockpiles)
					modStats(C,A,"spDefense",-A.stockpiles)
					A.stockpiles = 0

	Spite

	Splash
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The user just flops and splashes around to no effect at all..."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				for(var/player/P in list(C.battle.owner,C.battle.foe,C.battle.player3,C.battle.player4))
					P.ShowText("But nothing happened!")

	Spore
		_type = GRASS
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		Spore_Move = TRUE
		desc = "The user scatters bursts of spores that induce sleep."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				sleepTarget(C,A,D,TRUE)

	Star_Spin
		_type = FIGHTING
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 70
		Acc = 100
		desc = "The user spins around with its arms extended wide like a starfish."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Stealth_Rock
		_type = ROCK
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user sends floating stones to hover around the opponent's side of the field. Pokémon switching into battle are harmed by these stones."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var enemyHazardsList[]
				if(A in list(C.battle.P1,C.battle.P2))
					enemyHazardsList = C.battle.entryHazardsE
				else
					enemyHazardsList = C.battle.entryHazardsP
				if(!enemyHazardsList[STEALTH_ROCK])
					enemyHazardsList[STEALTH_ROCK] = 1
					displayToSystem(C,"[A] has sent out floating stones to [D]'s side of the field!")
				else
					displayToSystem(C,"There are already floating stones around [D]'s side of the field!")

	Steam_Eruption
		_type = WATER
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 130
		Acc = 100
		desc = "The user immerses the target in superheated steam. This may also burn the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(D.status == FROZEN)
					D.status = ""
					displayToSystem(C,"[A]'s Steam Eruption thawed [D] out from [genderGet(D,"her")] frozen state!")
				if(sereneProb(src,30))
					burnTarget(C,D)

	Steamroller

	Steel_Wing
		_type = STEEL
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 70
		Acc = 90
		desc = "The target is hit with wings of steel. This may also raise the user's defense stat."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					modStats(C,A,"defense",1)

	Sticky_Web
		_type = BUG
		range = STATUS
		contestType = TOUGH
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user weaves a tangling web around the opponents. Any switch ins on the enemy side have their speed dropped."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var enemyHazardsList[]
				if(A in list(C.battle.P1,C.battle.P2))
					enemyHazardsList = C.battle.entryHazardsE
				else
					enemyHazardsList = C.battle.entryHazardsP
				if(!enemyHazardsList[STICKY_WEB])
					enemyHazardsList[STICKY_WEB] = 0
					displayToSystem(C,"[A] has weaved a tangled web on [D]'s side of the field!")
				else
					displayToSystem(C,"There's already a tangled web on the enemy side!")

	Stockpile
		_type = NORMAL
		range = STATUS
		contestType = TOUGH
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user stores energy within itself to rise its defenses. The move can be used up to three times and can be chained with Spit-Up and Swallow."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(A.stockpiles < 3)
					++A.stockpiles
					displayToSystem(C,"[A] is stockpiling energy!")
					modStats(C,A,"defense",1)
					modStats(C,A,"spDefense",1)

	Stomp
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 20
		MaxPP = 20
		BP = 65
		Acc = 100
		desc = "The target is stomped with a big foot. This may also make the target flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Stone_Edge

	Stored_Power

	Storm_Throw
		_type = FIGHTING
		range = PHYSICAL
		BP = 60
		PP = 10
		MaxPP = 10
		Acc = 100
		desc = "The user strikes the target with a fierce blow. This attack always results in a critical hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Strength
		_type = FIGHTING
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 100
		Acc = 100
		desc = "The target is slugged with a punch thrown at maximum power. This can also be used to move heavy boulders."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	String_Shot
		_type = NORMAL
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = 95
		desc = "The opposing Pokémon are bound with silk blown from the user's mouth that harshly lowers the Speed stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"speed",-1)

	Struggle
		_type = UNKNOWN
		range = PHYSICAL
		BP = 40
		Acc = null
		PP = 1.#INF
		MaxPP = 1.#INF
		desc = "A last resort used when all other moves are rendered unusable.."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(src,A,D))
					A.HP = max(min(A.HP-(A.HP/4),A.maxHP),0)
					for(var/HPBar/HPB in C.battle.hpBars)
						if(HPB.P == A)
							HPB.updateBar()

	Struggle_Bug
		_type = BUG
		range = SPECIAL
		BP = 50
		Acc = 100
		PP = 20
		MaxPP = 20
		desc = "While resisting, the user attacks the opposing Pokémon. This lowers the Sp. Atk stat of those hit."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					modStats(C,A,"spAttack",-1)

	Stun_Spore
		_type = GRASS
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 75
		desc = "The user scatters a cloud of paralyzing powder. It may leave the target with paralysis."
		Spore_Move = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				paralyzeTarget(C,A,D)

	Submission
		_type = FIGHTING
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 80
		Acc = 80
		recoilDamage = 4
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Substitute
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null

	Sucker_Punch

	Sunny_Day
		_type = FIRE
		range = STATUS
		contestType = BEAUTY
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "The user intensifies the sun for five turns, powering up Fire-type moves."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				C.battle.weatherData["Weather"] = SUNNY
				C.battle.weatherData["Turns"] = 5
				for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
					if(P.pName=="Castform")
						P.formChange()

	Super_Fang
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 90
		desc = "The user chomps hard on the target with its sharp front fangs. This cuts the target's HP in half."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				fixedDamage(C,A,D,floor(D.HP/2))

	Superpower
		_type = FIGHTING
		range = PHYSICAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 100
		desc = "The user attacks the target with great power. However, this also lowers the user's Attack and Defense stats."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					modStats(C,A,"attack",-1)
					modStats(C,A,"defense",-1)

	Supersonic
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 55
		soundMove = TRUE
		desc = "The user generates odd sound waves from its body that confuses the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				confuseTarget(C,A,D)

	Surf
		_type = WATER
		range = SPECIAL
		contestType = BEAUTY
		PP = 15
		MaxPP = 15
		BP = 95
		Acc = 100
		desc = "The user attacks everything around it by swamping its surroundings with a giant wave. This can also be used for crossing water."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Swagger
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user tries to teach the foe about Swagger, which confuses them, making it angry and sharply raising its attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"attack",2)
					confuseTarget(C,D)

	Swallow

	Sweet_Kiss
		_type = FAIRY
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 75
		desc = "The user kisses the foe sweetly, confusing it because the kiss doesn't cause infatuation."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				confuseTarget(C,A,D)

	Sweet_Scent
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "A sweet scent that harshly lowers opposing Pokémon's evasiveness. This also lures wild Pokémon if used in places such as tall grass."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,D,"evasion",-2)

	Swift
		_type = NORMAL
		range = SPECIAL
		contestType = COOL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = null
		desc = "Star-shaped rays are shot at the opposing Pokémon. This attack never misses."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Switcheroo

	Swords_Dance
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user dances around a flurry of swords to boost its attack power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"attack",2)

	Synchronoise
		_type = PSYCHIC
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		desc = "Using an odd shock wave, the user inflicts damage on any Pokémon of the same type in the area around it."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var matchType = FALSE
				for(var/x in list(A.type1,A.type2,A.type3))
					for(var/y in list(D.type1,D.type2,D.type3))
						if(x==y){matchType=TRUE;break}
				if(matchType)
					doDamage(C,A,D)
				else
					displayToSystem(C,"It had no effect!")

	Synthesis
		_type = GRASS
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = null
		Acc = null
		desc = "The user restores its own HP. The amount of HP regained varies with the weather."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				recoverHealth(C,A)

	Tackle
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 35
		MaxPP = 35
		BP = 50
		Acc = 100
		desc = "A physical attack in which the user charges and slams into the target with its whole body."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Tail_Glow
		_type = BUG
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user stares at flashing lights to focus its mind, drastically raising the Special Attack stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				modStats(C,A,"spAttack",3)

	Tail_Slap
		_type = NORMAL
		range = PHYSICAL
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = 25
		Acc = 85
		desc = "The user attacks by striking its target with its hard tail. It uts the target two to five times in succession."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,2,5)

	Tail_Whip
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = 100
		desc = "The user wags its tail cutely, making opposing Pokémon less wary and lowering their Defense stat."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(C.battle.Accuracy_Check(src,A,D))
					modStats(C,D,"defense",-1)

	Tailwind
		_type = FLYING
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null


	Take_Down
		_type = NORMAL
		range = PHYSICAL
		contestType = TOUGH
		PP = 20
		MaxPP = 20
		BP = 90
		Acc = 85
		recoilDamage = 4
		desc = "A reckless, full-body charge attack for slamming into the target. This also damages the user a little."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Taunt
		_type = DARK
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100


	Techno_Blast
		_type = NORMAL
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 100


	Teeter_Dance
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100


	Telekinesis
		_type = PSYCHIC
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = null
		desc = "The user does a wobbly dance that confuses everyone around it."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				confuseTarget(C,A,D,TRUE)

	Teleport
		_type = PSYCHIC
		range = STATUS
		contestType = COOL
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null


	Thief
		_type = DARK
		range = PHYSICAL
		PP = 25
		MaxPP = 25
		BP = 60
		Acc = 100


	Thousand_Arrows
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100


	Thousand_Waves
		_type = GROUND
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100


	Thrash
		_type = NORMAL
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 120
		Acc = 100


	Throw
		_type = DARK
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 80
		Acc = 90
		desc = "The user picks up and throws items around the area at its foe. It may throw its held item or do more damage to paralyzed targets."
		upgrade_info = "When upgraded, the user throws the items much harder, for a shatteringly painful amount of damage."
		upgradeFlags = (0 | MOVE_UPGRADEABLE)
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(D.status == PARALYZED)
					BP = 100
				if(upgradeFlags & MOVE_UPGRADED)
					BP += 40
				doDamage(C,A,D)

	Thunder
		_type = ELECTRIC
		range = SPECIAL
		contestType = COOL
		PP = 10
		MaxPP = 10
		BP = 110
		Acc = 70
		desc = "A wicked thunderbolt is summoned from the sky to deal damage. This may paralyze the target."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
		secondaryEffect(client/C,pokemon/A,pokemon/D,extraEffect=TRUE)
			. = ..()
			if(.)
				if(sereneProb(src,10))
					paralyzeTarget(C,D)

	Thunder_Fang
		_type = ELECTRIC
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 65
		Acc = 95
		desc = "The user bites with electrified fangs. It may also make the target flinch or leave it with paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Thunder_Punch
		_type = ELECTRIC
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		desc = "The target is punched with an electrified fist. This may also leave the target with paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Thunder_Shock
		_type = ELECTRIC
		range = SPECIAL
		PP = 30
		MaxPP = 30
		BP = 40
		Acc = 100
		desc = "A jolt of electricity crashes down on the target to inflict damage. This may also leave the target with paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Thunder_Storm
		_type = ELECTRIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "An electric bolt is shot into the air to stir up the clouds, creating a massive thunderstorm that boosts the power of \
		Water and Electric-Type moves. It damages pokémon that aren\'t of the Electric-Type."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				C.battle.weatherData["Weather"] = THUNDERSTORM
				C.battle.weatherData["Turns"] = 5
				for(var/pokemon/P in list(C.battle.P1,C.battle.P2,C.battle.C3,C.battle.C4))
					if(P.pName=="Castform")
						P.formChange()

	Thunder_Wave
		_type = ELECTRIC
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = 100
		desc = "The user launches a weak jolt of electricity that paralyzes the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				paralyzeTarget(C,A,D)

	Thunderbolt
		_type = ELECTRIC
		range = SPECIAL
		contestType = COOL
		PP = 15
		MaxPP = 15
		BP = 95
		Acc = 100
		desc = "A strong electric blast crashes down on the target. This may also leave the target with paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(10))
					paralyzeTarget(C,A,D)

	Tickle
/*
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Topsy\-\Turvy
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Torment
		_type = DARK
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user torments and enrages the target, making it incapable of using the same move twice in a row."

	Toxic
		_type = POISON
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 85
		desc = "A move that leaves the target badly poisoned. Its poison damage worsens every turn."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(POISON in list(A.type1,A.type2,A.type3))
					Acc = null
				poisonTarget(C,A,D,badly=TRUE)
				Acc = 85

	Toxic_Spikes
		_type = POISON
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The user throws down a set of poison-lined spikes at the opponent's side of the field. These will poison opposing grounded swap-ins."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				var enemyHazardsList[]
				if(A in list(C.battle.P1,C.battle.P2))
					enemyHazardsList = C.battle.entryHazardsE
				else
					enemyHazardsList = C.battle.entryHazardsP
				if(enemyHazardsList[TOXIC_SPIKES]<2)
					enemyHazardsList[TOXIC_SPIKES] += 1
					displayToSystem(C,"[A] has thrown a line of poisonous spikes around [D]'s side of the field!")
				else
					displayToSystem(C,"There are already two lines of poisonous spikes around [D]'s side of the field!")

	Transform
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null


	Tri_Attack
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100


	Trick
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100


/*
	Trick_Room
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Trick\-\or\-\Treat
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Triple_Kick
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 10
		Acc = 90
		desc = "The user spins to kick the foe three times."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				multiHit(C,A,D,3,3)
/*
	Trump_Card
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Twineedle
		_type = BUG
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		desc = "The user damages the target twice in succession by jabbing it with two spikes. This may also poison the target."
		hasSecondaryEffect = TRUE
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				. = multiHit(C,A,D,2,2)
		secondaryEffect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(sereneProb(src,20))
					poisonTarget(C,D,badly=TRUE)

	Twister
		_type = FLYING
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 40
		Acc = 100
		desc = "The user whips up a vicious tornado to tear at the opposing Pokémon. This may also make them flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)
/*
	U\-\turn
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/
	Uproar
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 90
		Acc = 100
		desc = "The user attacks in an uproar for three turns. During that time, no one can fall asleep."

/*
	V\-\create
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Vacuum_Wave
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Venom_Drench
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =


	Venoshock
		_type =
		range =
		PP =
		MaxPP =
		BP =
		Acc =

*/

	Vice_Grip
		_type = NORMAL
		range = PHYSICAL
		PP = 30
		MaxPP = 30
		BP = 55
		Acc = 100
		desc = "The target is gripped and squeezed from both sides to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Vine_Whip
		_type = GRASS
		range = PHYSICAL
		contestType = COOL
		PP = 25
		MaxPP = 25
		BP = 45
		Acc = 100
		desc = "The target is struck with slender, whiplike vines to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Vital_Throw
		_type = FIGHTING
		range = PHYSICAL
		contestType = COOL
		PP = 10
		MaxPP = 10
		BP = 70
		Acc = null
		desc = "The user forces itself to go last on the turn, but never misses as a result."
		priority = -1
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Volt_Switch
		_type = ELECTRIC
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 70
		Acc = 100

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Volt_Tackle
		_type = ELECTRIC
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		recoilDamage = 3

		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Wake\-\Up_Slap
		_type = FIGHTING
		range = PHYSICAL
		PP = 10
		MaxPP = 10
		BP = 70
		Acc = 100
		desc = "This attack inflicts big damage on a sleeping target. This also wakes the target up, however."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Water_Gun
		_type = WATER
		range = SPECIAL
		PP = 25
		MaxPP = 25
		BP = 40
		Acc = 100
		desc = "The target is blasted with a forceful shot of water."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if((A.pName == "Wishiwashi") && (A.form = "-School")) // School Wishiwashi gains access to an 'empowered' Water Gun.
					BP = 150
				else
					BP = 40
				doDamage(C,A,D)

	Water_Pledge
		_type = WATER
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 80
		Acc = 100
		desc = "A column of water strikes the target. When combined with its fire equivalent, the damage increases and a rainbow appears."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Water_Pulse
		_type = WATER
		range = SPECIAL
		PP = 20
		MaxPP = 20
		BP = 60
		Acc = 100
		desc = "The user attacks the target with a pulsing blast of water. This may also confuse the target."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Water_Shuriken
		_type = WATER
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 15
		Acc = 100
		desc = "The user hits the target with throwing stars two to five times in a row. This move always goes first."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Water_Sport
		_type = WATER
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 100
		desc = "The user soaks itself with water. This weakens Fire-type moves for five turns."

	Water_Spout
		_type = WATER
		range = STATUS
		PP = 5
		MaxPP = 5
		BP = 150
		Acc = 100
		desc = "The user spouts water to damage opposing Pokémon. The lower the user's HP, the lower the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = round(150*(A.HP/A.maxHP))
				doDamage(C,A,D)
				BP = 150

	Waterfall
		_type = WATER
		range = PHYSICAL
		contestType = TOUGH
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user charges at the target and may make it flinch. This can also be used to climb a waterfall."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Weather_Ball
		_type = NORMAL
		range = SPECIAL
		PP = 10
		MaxPP = 10
		BP = 50
		Acc = 100
		desc = "An attack move that varies in power and type depending on the weather."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = 100
				switch(C.battle.weatherData["Weather"])
					if(RAINY)
						_type = WATER
					if(SUNNY)
						_type = FIRE
					if(SANDSTORM)
						_type = ROCK
					if(HAIL)
						_type = ICE
					if(THUNDERSTORM)
						_type = ELECTRIC
					if(CLEAR)
						_type = NORMAL
						BP = 50
					else
						_type = NORMAL
				doDamage(C,A,D)

	Whirlpool
		_type = WATER
		range = SPECIAL
		PP = 15
		MaxPP = 15
		BP = 75
		Acc = 85
		desc = "The user traps the target in a violent swirling whirlpool for four to five turns."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Whirlwind
		_type = NORMAL
		range = STATUS
		PP = 20
		MaxPP = 20
		BP = null
		Acc = null
		desc = "The target is blown away, and a different Pokémon is dragged out. In the wild, this ends a battle against a single Pokémon."

	Wide_Guard
		_type = ROCK
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user and its allies are protected from wide-ranging attacks for one turn."

	Wild_Charge
		_type = ELECTRIC
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 90
		Acc = 100
		recoilDamage = 4
		desc = "The user shrouds itself in electricity and smashes into its target. This also damages the user a little."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Will\-\O\-\Wisp
		_type = FIRE
		range = STATUS
		PP = 15
		MaxPP = 15
		BP = null
		Acc = 85
		desc = "The user shoots a sinister, bluish-white flame at the target to inflict a burn."

	Wing_Attack
		_type = FLYING
		range = PHYSICAL
		PP = 35
		MaxPP = 35
		BP = 60
		Acc = 100
		desc = "The target is struck with large, imposing wings spread wide to inflict damage."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Wish
		_type = NORMAL
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "One turn after this move is used, the target's HP is restored by half the user's max HP."

	Withdraw
		_type = WATER
		range = STATUS
		PP = 40
		MaxPP = 40
		BP = null
		Acc = null
		desc = "The user withdraws its body into its hard shell, raising its Defense stat."

	Wonder_Room
		_type = PSYCHIC
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = null
		desc = "The user creates a bizarre area in which Pokémon's Defense and Sp. Def stats are swapped for five turns."

	Wood_Hammer
		_type = GRASS
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 120
		Acc = 100
		recoilDamage = 3
		desc = "The user slams its rugged body into the target to attack. This also damages the user quite a lot."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Work_Up
		_type = NORMAL
		range = STATUS
		PP = 30
		MaxPP = 30
		BP = null
		Acc = null
		desc = "The user is roused, and its Attack and Sp. Atk stats increase."

	Worry_Seed
		_type = GRASS
		range = STATUS
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "Afflicts the target with a Sleepless status condition, even at a distance. It doesn't affect a Pokémon with the Truant ability."

	Wrap
		_type = NORMAL
		range = PHYSICAL
		PP = 20
		MaxPP = 20
		BP = 15
		Acc = 90
		desc = "A long body or vines are used to wrap and squeeze the target for four to five turns."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Wring_Out
		_type = NORMAL
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 0
		Acc = 100
		desc = "The user powerfully wrings the target. The more HP the target has, the greater the move's power."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				BP = 1 + 120 * (D.HP/D.maxHP)
				doDamage(C,A,D)

	X\-\Scissor
		_type = BUG
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 100
		desc = "The user slashes at the target by crossing its scythes or claws as if they were a pair of scissors."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				doDamage(C,A,D)

	Yawn
		_type = NORMAL
		range = STATUS
		contestType = CUTE
		PP = 10
		MaxPP = 10
		BP = null
		Acc = 100
		desc = "The user lets loose a huge yawn that lulls the target into falling asleep on the next turn."

	Zap_Cannon
		_type = ELECTRIC
		range = SPECIAL
		PP = 5
		MaxPP = 5
		BP = 120
		Acc = 50
		desc = "The user fires an electric blast like a cannon to inflict damage and cause paralysis."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D))
					paralyzeTarget(C,D)

	Zen_Headbutt
		_type = PSYCHIC
		range = PHYSICAL
		PP = 15
		MaxPP = 15
		BP = 80
		Acc = 90
		desc = "The user focuses its willpower to its head and attacks the target. This may also make the target flinch."
		effect(client/C,pokemon/A,pokemon/D)
			. = ..()
			if(.)
				if(doDamage(C,A,D) && prob(20))
					D.infoFlags |= FLINCHED
