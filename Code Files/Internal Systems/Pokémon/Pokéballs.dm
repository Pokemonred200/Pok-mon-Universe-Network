proc/get_ball_rate(pokemon/A,pokemon/B,item/pokeball/C)
	. = C.rate
	if(!(A.pName in list("Nihilego","Buzzwole","Pheromosa","Xurkitree","Celesteela","Kartana","Guzzlord")))
		var theStats = getStats(B)
		switch(C.type)
			if(/item/pokeball/Level_Ball)
				if(A.level <= B.level)
					return 1
				else if(A.level < (B.level*2))
					return 2
				else if(A.level in (B.level*2) to (B.level*4))
					return 4
				else
					return 8
			if(/item/pokeball/Lure_Ball)
				return (A.owner.client.battle.flags & FISHING_BATTLE)?(3):(1)
			if(/item/pokeball/Moon_Ball)
				if(A.pName in list("Nidoran M","Nidorino","Nidoking","Nidoran F","Nidorina","Nidoqueen","Cleffa","Clefairy","Clefable",
				"Igglybuff","Jigglypuff","Wigglytuff","Skitty","Delcatty","Munna","Musharana"))
					return 4
				else
					return 1
			if(/item/pokeball/Love_Ball)
				if(A.gender in list("male","female"))
					if(A.pName == B.pName)
						if((A.gender == "male" && B.gender == "female")||(A.gender == "female" && B.gender=="male"))
							return 8
						else
							return 1
			if(/item/pokeball/Heavy_Ball)
				if(A.weight < 102.4)
					return -0.5
				else if(A.weight in 102.4 to 204.7)
					return 1
				else if(A.weight in 204.8 to 307.1)
					return 2
				else if(A.weight in 307.2 to 409.6)
					return 4
				else
					return 8
			if(/item/pokeball/Fast_Ball)
				return (theStats["speed"]>=100)?(4):(1)
			if(/item/pokeball/Net_Ball)
				if(("Bug" in list(B.type1,B.type2,B.type3)) || ("Water" in list(B.type1,B.type2,B.type3)))
					return 3
				else
					return 1
			if(/item/pokeball/Nest_Ball)
				return min(max(((41 - B.level)/10),1),4)
			if(/item/pokeball/Timer_Ball)
				return min(max((1 + A.owner.client.battle.turns * 1229/4096),1),6)
			if(/item/pokeball/Quick_Ball)
				return (A.owner.client.battle.turns==1)?(5):(1)
			if(/item/pokeball/Shine_Ball)
				return (B.savedFlags & SHINY)?(255):(1)
			if(/item/pokeball/Beast_Ball)
				return 0.1
	else
		switch(C.type)
			if(/item/pokeball/Beast_Ball)
				return 5
			if(/item/pokeball/Shine_Ball)
				return (B.savedFlags & SHINY)?(255):(1)
			else
				return 1

proc/calculate_catch_rate(pokemon/P,pokemon/D,item/pokeball/B)
	var theStats = getStats(D)
	var a
	var rate = get_ball_rate(P,D,B)
	switch(D.status)
		if(ASLEEP,FROZEN)
			a = 2.5
		if(PARALYZED,POISONED,BAD_POISON,BURNED)
			a = 1.5
		else
			a = 1

	. = (((3*D.maxHP-2*D.HP)*theStats["catch_rate"]*rate)/(3*D.maxHP))*a

proc/determine_shake(a)
	return round(round(65536 / (round(255/a,1/4096)) ** (round(1/4,1/4096)),1/4096))

proc/hascaught(pokemon/P,pokemon/D,item/pokeball/A,client/C)
	if(A.rate == 255)return 1
	var b = determine_shake( calculate_catch_rate(P,D,A) )
	if(rand(0,65535) > b)return 0 // If true, shake

	C.Audio.playSound("Shake Ball")

	if(rand(0,65535) > b)return 0 // If true, shake again

	C.Audio.playSound("Shake Ball")

	if(rand(0,65535) > b)return 0 // If true, shake a third time

	C.Audio.playSound("Shake Ball")

	if(rand(0,65535) > b)return 0 // If true, pokémon is caught
	return 1