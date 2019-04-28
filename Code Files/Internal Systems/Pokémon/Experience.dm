var expTable[6][100]

var expPassRate[] = list(0.5,0.66,0.8,1,1.2,1.5,2)

proc
	initEXPList()
		set waitfor = 0
		for(var/i in 1 to 6)
			for(var/j in 1 to 100)
				switch(i)
					if(1)
						switch(j)
							if(-1.#INF to 50)
								expTable[i][j] = ((j**3*(100-j))/(50))
							if(50 to 68)
								expTable[i][j] = ((j**3*(150-j))/(100))
							if(68 to 98)
								expTable[i][j] = ((j**3*((1911-10*j)/(3)))/(500))
							if(98 to 100)
								expTable[i][j] = ((j**3*(160-j))/(100))
					if(2)
						expTable[i][j] = ((4*j**3)/5)
					if(3)
						expTable[i][j] = j**3
					if(4)
						expTable[i][j] = (6/5)*j**3-15*j**2+100*j-140
					if(5)
						expTable[i][j] = ((5*j**3)/4)
					if(6)
						switch(j)
							if(-1.#INF to 15)
								expTable[i][j] = j**3*((((j+1)/(3))+24)/(50))
							if(15 to 36)
								expTable[i][j] = j**3*((j+14)/(50))
							if(36 to 100)
								expTable[i][j] = j**3*((((j)/(2))+32)/(50))
		for(var/i in 1 to 6)
			expTable[i][1] = 0
	getRequiredExp(group,level)
		level = min(max(level,1),100)
		switch(group)
			if(ERRATIC,1). = round(expTable[1][level])
			if(FAST,2). = round(expTable[2][level])
			if(MEDIUM_FAST,3). = round(expTable[3][level])
			if(MEDIUM_SLOW,4). = round(expTable[4][level])
			if(SLOW,5). = round(expTable[5][level])
			if(FLUCTUATING,6). = round(expTable[6][level])
			else . = round(expTable[3][level])
	RewardExp(pokemon/P,pokemon/S,battleSystem/B)
		if(!S.expLevel)
			S.expLevel = S.level
		var theStats = getStats(S)
		if(P in list(B.E1,B.E2))return
		var pokemon/O = P
		var anyExpShares = FALSE
		var totalExpShares = 0
		for(var/x in 1 to 6)
			P = O.owner.party[x]
			if(isnull(P))break
			else if(!istype(P,/pokemon))continue
			if(istype(P.held,/item/normal/exp_item/Exp_Share))
				anyExpShares = TRUE
				++totalExpShares
		for(var/x in 1 to 6)
			P = O.owner.party[x]
			if(isnull(P))break
			else if(!istype(P,/pokemon))continue
			var hasExpShare = FALSE
			if(!(P in B.ownerParticipatedList))
				if(istype(P.held,/item/normal/exp_item/Exp_Share))
					hasExpShare = TRUE
				else continue
			var{a;t;b;e;L;Lp;s;p;f;v}
			f = (P.affection >= 100)?(1.2):(1)
			a = (!(B.flags & WILD_BATTLE))?(1.5):(1)
			b = theStats["base_exp"]
			e = (istype(P.held,/item/normal/exp_item/Lucky_Egg))?(1.5):(1)
			L = S.expLevel // same as level EXCEPT in scaled matches
			Lp = P.level
			if(P.owner.opowert[EXP_POINT_POWER])
				p = expPassRate[P.owner.opowerl[EXP_POINT_POWER]+3]
			else
				p = 1
			s = 1
			if(!anyExpShares)
				var count = 0
				for(var/pokemon/PKMN in B.ownerParticipatedList)
					if(P.status != FAINTED)++count
				s = count
			else
				var count = 0
				if(P in B.ownerParticipatedList)
					for(var/pokemon/PKMN in B.ownerParticipatedList)
						if(P.status != FAINTED)++count
				else if(hasExpShare)
					count = totalExpShares
				else
					count = 1
				s = count*2
			t = (!(P.savedFlags & IMPORTED))?((P.withOT())?(1):(1.5)):((P.language!=ENGLISH)?(1.7):(2))
			v = (P.level>=P.evoLevel)?(1.2):(1)
			var expBonus
			if(gameFlags & USE_SCALED_EXP_FORMULA)
				expBonus = floor( (((a*b*L)/(5*s))*(((2*L+10)**2.5)/((L+Lp+10)**2.5))+1)*t*e*p*f*v ) // Scaled EXP Gain, on by default
			else
				expBonus = floor( (a*t*b*e*L*p*f*v)/(7*s) ) // Flat EXP Gain, toggle-able by admins
			P.exp = min(P.exp+expBonus,getRequiredExp(P.expGroup,100))
			var message
			switch(t)
				if(1) // With Original Trainer from PUN
					message = "[P] gained [expBonus] experience points!"
				if(1.5) // Traded from anoter trainer from PUN
					message = "[P] gained a boosted [expBonus] experience points!"
				if(1.7) // Imported from an official Pokémon game
					message = "[P] gained an incredibly boosted [expBonus] experience points!"
				if(2) // Imported from a non-english official Pokémon game
					message = "[P] gained a massively boosted [expBonus] experience points!"
				else
					message = "[P] gained [expBonus] experience points!"
			for(var/client/C in list(B.C1,B.C2,B.C3,B.C4))
				var player/PL = C.mob
				PL.ShowText(message)
			while( (P.level <= 100) && (P.exp>=getRequiredExp(P.expGroup,P.level+1)) )
				P.levelUp()
			if(P.level>100)P.level = 100
			if(P.exp>getRequiredExp(P.expGroup,100))P.exp = getRequiredExp(P.expGroup,100)
			RewardEVs(P,S)
	RewardEVs(pokemon/P,pokemon/S)
		var theEvs = getEvs(S)
		var pokerusStrain = getPokerusStrain(P)
		var HPData = theEvs["HP"]
		var attackData = theEvs["atk"]
		var defenseData = theEvs["def"]
		var spAttackData = theEvs["satk"]
		var spDefenseData = theEvs["sdef"]
		var speedData = theEvs["speed"]
		if(istype(P.held,/item))
			switch(P.held.type)
				if(/item/normal/Macho_Brace)
					HPData *= 2
					attackData *= 2
					defenseData *= 2
					spAttackData *= 2
					spDefenseData *= 2
					speedData *= 2
				if(/item/normal/power/Power_Weight)
					HPData += 8
				if(/item/normal/power/Power_Bracer)
					attackData += 8
				if(/item/normal/power/Power_Belt)
					defenseData += 8
				if(/item/normal/power/Power_Lens)
					spAttackData += 8
				if(/item/normal/power/Power_Band)
					spDefenseData += 8
				if(/item/normal/power/Power_Anklet)
					speedData += 8
		if(pokerusStrain)
			HPData *= 2
			attackData *= 2
			defenseData *= 2
			spAttackData *= 2
			spDefenseData *= 2
			speedData *= 2
		var evTotal = P.HPEv+P.attackEv+P.defenseEv+P.spAttackEv+P.spDefenseEv+P.speedEv
		if(evTotal<510)
			var gainData = min(P.HPEv+HPData,252)
			evTotal += gainData
			if(evTotal>510)
				gainData = min(evTotal - gainData,252)
				P.HPEv = gainData
				return
			P.HPEv = gainData
			gainData = min(P.attackEv+attackData,252)
			evTotal += gainData
			if(evTotal>510)
				gainData = min(evTotal - gainData,252)
				P.attackEv = gainData
				return
			P.attackEv = gainData
			gainData = min(P.defenseEv+defenseData,252)
			evTotal += gainData
			if(evTotal>510)
				gainData = min(evTotal - gainData,252)
				P.defenseEv = gainData
				return
			P.defenseEv = gainData
			gainData = min(P.spAttackEv+spAttackData,252)
			evTotal += gainData
			if(evTotal>510)
				gainData = min(evTotal - gainData,252)
				P.spAttackEv = gainData
				return
			P.spAttackEv = gainData
			gainData = min(P.spDefenseEv+spDefenseData,252)
			evTotal += gainData
			if(evTotal>510)
				gainData = min(evTotal - gainData,252)
				P.spDefenseEv = gainData
				return
			P.spDefenseEv = gainData
			gainData = min(P.speedEv+speedData,252)
			evTotal += gainData
			if(evTotal>510)
				gainData = min(evTotal - gainData,252)
				P.speedEv = gainData
				return
			P.speedEv = gainData