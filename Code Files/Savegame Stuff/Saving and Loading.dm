player
	Write(savefile/F)
		F["x"] << src.x
		F["y"] << src.y
		F["z"] << src.z
		F["respawn_x"] << src.respawnpoint.x
		F["respawn_y"] << src.respawnpoint.y
		F["respawn_z"] << src.respawnpoint.z
		if(src.walker)
			F["walker_x"] << src.walker.x
			F["walker_y"] << src.walker.y
			F["walker_z"] << src.walker.z
		else
			F["walker_x"] << 0
			F["walker_y"] << 0
			F["walker_z"] << 0
		F["version"] << 5
		if(src.walker)
			src.party.len = 7 // Gotta make sure lol
			src.party[7] = src.walker
		. = ..()
	Read(savefile/F)
		. = ..()
		var/turf/x = src.loc
		if(x)
			var/area/ar = x.loc
			if(ar)
				ar.Entered(src)
		for(var/Egg/E in src.party)
			E.owner = src
		for(var/pokemon/S in src.party)
			S.owner = src
			S.reload(src)
		src.walker = src.party[7]
		src.sprite.loc = src
		var theCostume = text2path(current_costume)
		var costume/X
		if(!isnull(theCostume))
			X = new theCostume
		else if(src.gender==MALE)
			X = new /costume/special_costume/RSE_character/icon_male_02
		else
			X = new /costume/special_costume/RSE_character/icon_female_02
		X.Switch(src)
		var item/key/Laptop/L = src.bag.getItem(/item/key/Laptop)
		if(!isnull(L))
			if(!isnull(L.comp))
				L.comp.owner = src
		if(breedhandlers)
			for(var/ID in breedhandlers)
				var breedhandler/BH = breedhandlers[ID]
				BH.owner = src
				BH.reloadPokemon()
		if((F["version"] < 3) && (F["z"]>6))
			src.Move(locate(F["x"],F["y"],F["z"]+1))
		else
			src.Move(locate(F["x"],F["y"],F["z"]))
		src.respawnpoint = locate(F["respawn_x"],F["respawn_y"],F["respawn_z"])
		if(!src.respawnpoint)
			src.respawnpoint = locate("HouseRespawn")
		if(src.walker)
			src.walker.loc = locate(F["walker_x"],F["walker_y"],F["walker_z"])
		src.dir = F["dir"]
		src.com.mob = src

pmove
	Read(savefile/F)
		..()
		src.updateBonus(PPbonus)