proc
	getMegaEvolution(tName)
		var pokemon/P = new(tName)
		if("Venusaur-Mega")
			P.stats = list("HP"=80,"atk"=100,"def"=123,"satk"=122,"sdef"=120,"speed"=80)
			P.name = "Venusaur"
			P.pName = "Venusaur"
			P.type1 = GRASS
			P.type2 = POISON
			P.type3 = ""
		if("Charizard-Mega X")
			P.stats = list("HP"=78,"atk"=130,"def"=111,"satk"=130,"sdef"=85,"speed"=100,"base_exp"=285,"catch_rate"=45,"base_friend"=70,"egg_cycles"=21)
			P.evYield = list("HP"=0,"atk"=2,"def"=1,"satk"=2,"sdef"=0,"speed"=1)
			P.type1 = FIRE
			P.type2 = DRAGON
			P.type3 = ""
			P.height = 1.7
			P.weight = 110.5
			P.cry = sound('006a - Mega Charizard X.wav')
			P.form = "-Mega X"
			P.dexNumber = "0006mx"
			P.ability1 = "Tough Claws"
		if("Charizard-Mega Y")
			P.stats = list("HP"=78,"atk"=104,"def"=78,"satk"=159,"sdef"=115,"speed"=100)
			P.type1 = FIRE
			P.type2 = FLYING
			P.type3 = ""
		if("Mega Blastoise")
			P.stats = list("HP"=79,"atk"=103,"def"=120,"satk"=135,"sdef"=115,"speed"=78)
			P.type1 = WATER
			P.type2 = ""
			P.type3 = ""
		else
			del P
			return null
		return P