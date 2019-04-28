var
	static
		cutTrees[0]
		smashBoulders[0]
		headbuttTrees[0]
		strengthBoulders[0]

cutBush
	parent_type = /obj
	icon = 'HM Icons.dmi'
	icon_state = "Bush"
	New()
		..()
		cutTrees += src
		theImage = image('HM Icons.dmi',src,"Bush")
		theImage.override = TRUE
		icon = null
		icon_state = ""
		Load()
	Del()
		cutTrees -= src
		Save()
		..()
	var
		players_passthrough[0]
		tmp
			image/theImage
	proc
		Save()
			fdel("World Objects/Cut Trees/Cut Tree at [x] [y] [z].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("cut tree")),"World Objects/Cut Trees/Cut Tree at [x] [y] [z].esav")
		Load()
			if(!fexists("World Objects/Cut Trees/Cut Tree at [x] [y] [z].esav"))return
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("World Objects/Cut Trees/Cut Tree at [x] [y] [z].esav"),md5("cut tree")))
			src.Read(F)
	Cross(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_passthrough))
				return FALSE
			else
				return ..()
		else
			return ..()
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_passthrough))
				var pokemon/PK
				main_loop:
					for(var/pokemon/PKMN in P.party)
						for(var/pmove/M in PKMN.moves)
							if(istype(M,/pmove/Cut))
								PK = PKMN
								break main_loop
				if(isnull(PK))
					var theQuotes[] = list("No! My new pedicure will be ruined!","[P], Shut Up!","Alright, let me get my invisible garden scissors that don't work.",
					"And you assume I know Cut...?","It's [realTime.Year()]. You really don't remember your Pokémon's moves?")
					var quote = pick(theQuotes)
					var theParty[0]
					for(var/x in 1 to 6)
						if(istype(P.party[x],/pokemon))
							theParty += P.party[x]
					var Color/C1 = (P.gender==FEMALE)?(RedColor):(BlueColor)
					if(rand(1,theQuotes.len+1)==theQuotes.len+1)
						if(theParty.len == 1)
							PK = P.party[1]
							var Color/C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
							P.ShowText("[PK], use Cut!",C1,TRUE)
							P.ShowText("[PK]: Okay!",C2,TRUE)
							P.ShowText("HYAAAAAA!",C2,TRUE)
							P.ShowText("*BANG*",bold=TRUE)
							P.ShowText("...",bold=TRUE)
							P.ShowText("I just broke my arm...",C2,TRUE)
							P.Move(P.respawnpoint)
						else
							PK = pick(theParty)
							var pokemon/PK2 = pick(theParty-PK)
							var
								Color
									C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
									C3 = (PK2.gender==FEMALE)?(RedColor):((PK2.gender==MALE)?(BlueColor):(new/Color))
							P.ShowText("[PK], use Cut!",C1,TRUE)
							P.ShowText("[PK]: Okay!",C2,TRUE)
							P.ShowText("HYAAAAAA!",C2,TRUE)
							P.ShowText("*BANG*",bold=TRUE)
							P.ShowText("[PK]: ...",C2,TRUE)
							P.ShowText("[PK2]: ...",C3,TRUE)
							P.ShowText("[PK2]: WHAT THE HELL? YOU JUST ATTACKED ME!",C3,TRUE)
							P.ShowText("[PK]: Sorry...",C2,TRUE)
						return
					PK = pick(theParty)
					var Color/C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
					P.ShowText("[PK], use Cut!",C1)
					P.ShowText("[PK]: [quote]",C2)
				else
					var image/breakingImage = (seasonTime!="Winter")?(image('HM Icons.dmi',src,"BushA")):(image('HM Icons.dmi',src,"Bush WinterA"))
					P.client.images -= theImage
					P.client.images += breakingImage
					sleep 12
					P.client.images -= breakingImage
					players_passthrough |= "[ckeyEx(P.key)]"
					P.ShowText("You slashed the tree down with [PK]'s cut!")

smashBoulder
	parent_type = /obj
	icon = 'HM Icons.dmi'
	icon_state = "Boulder"
	density = 0
	New()
		..()
		smashBoulders += src
		theImage = image('HM Icons.dmi',src,"Boulder")
		theImage.override = TRUE
		icon = null
		icon_state = ""
		Load()
	Del()
		smashBoulders -= src
		Save()
		..()
	Cross(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_passthrough))
				return FALSE
			else
				return ..()
		else
			return ..()
	var
		players_passthrough[0]
		tmp
			image/theImage
	proc
		Save()
			fdel("World Objects/Smash Boulders/Smash Boulder at [x] [y] [z].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("smasher")),"World Objects/Smash Boulders/Smash Boulder at [x] [y] [z].esav")
		Load()
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("World Objects/Smash Boulders/Smash Boulder at [x] [y] [z].esav"),md5("smasher")))
			src.Read(F)
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_passthrough))
				var pokemon/PK
				main_loop:
					for(var/pokemon/PKMN in P.party)
						for(var/pmove/M in PKMN.moves)
							if(istype(M,/pmove/Rock_Smash))
								PK = PKMN
								break main_loop
				if(isnull(PK))
					var theQuotes[] = list("No can do, I could hurt myself.","[P], Shut Up!","Alright, let me get my iron fist. OH WAIT, I don't have one.",
					"How do you figure I can break solid stone with my wee little hands?","It's [realTime.Year()]. You really don't remember your Pokémon's moves?")
					var quote = pick(theQuotes)
					var theParty[0]
					for(var/x in 1 to 6)
						if(istype(P.party[x],/pokemon))
							theParty += P.party[x]
					var
						Color
							C1 = (P.gender==FEMALE)?(RedColor):(BlueColor)
							C2 = null
					if(rand(1,theQuotes.len+1)==theQuotes.len+1)
						if(theParty.len == 1)
							PK = P.party[1]
							C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
							P.ShowText("[PK], use Rock Smash!",C1,TRUE)
							P.ShowText("[PK]: Okay!",C2,TRUE)
							P.ShowText("JUDO FLIP!!",C2,TRUE)
							P.ShowText("*BANG*",new/Color,TRUE)
							P.ShowText("...",new/Color,TRUE)
							P.ShowText("I think I just shattered my hands...",C2,TRUE)
							P.Move(P.respawnpoint)
						else
							PK = pick(theParty)
							var pokemon/PK2 = pick(theParty-PK)
							C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
							var Color/C3 = (PK2.gender==FEMALE)?(RedColor):((PK2.gender==MALE)?(BlueColor):(new/Color))
							P.ShowText("[PK], use Rock Smash!",C1,TRUE)
							P.ShowText("[PK]: Okay!",C2,TRUE)
							P.ShowText("JUDO FLIP!!",C2,TRUE)
							P.ShowText("*BANG*",new/Color,TRUE)
							P.ShowText("[PK]: ...",C2,TRUE)
							P.ShowText("[PK2]: ...",C3,TRUE)
							P.ShowText("[PK2]: WHAT THE HELL? YOU JUST HIT ME!",C3,TRUE)
							P.ShowText("[PK]: Sorry...",C2,TRUE)
					else
						PK = pick(theParty)
						C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
						P.ShowText("[PK], use Rock Smash!",C1,TRUE)
						P.ShowText("[PK]: [quote]",C2,TRUE)
				else
					var image/breakingImage = image('HM Icons.dmi',src,"BoulderA")
					P.client.images -= theImage
					P.client.images += breakingImage
					sleep 12
					P.client.images -= breakingImage
					players_passthrough |= "[ckeyEx(P.key)]"
					P.ShowText("You broke the rock with [PK]'s Rock Smash!")

strengthBoulder
	parent_type = /obj
	icon = 'HM Icons.dmi'
	icon_state = "Strength Boulder"
	density = 0
	New()
		..()
		strengthBoulders += src
		theImage = image('HM Icons.dmi',src,"Strength Boulder")
		theImage.override = TRUE
		src.icon = null
		src.icon_state = ""
		Load()
	Del()
		strengthBoulders -= src
		Save()
		..()
	Cross(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[P.ckey]" in players_passthrough))
				return FALSE
			else
				return ..()
		else
			return ..()
	var
		players_passthrough[0]
		clonePositions[0]
		tmp
			playerStrengthClone/clonesList[0]
			image/theImage
	proc
		cloneHasValidLocation(player/P)
			if(islist(clonePositions["[P.ckey]"]))
				var
					xReal = clonePositions["[P.ckey]"]["x"]
					yReal = clonePositions["[P.ckey]"]["y"]
					zReal = clonePositions["[P.ckey]"]["z"]
				if(isnum(xReal) && isnum(yReal) && isnum(zReal))
					if(xReal in 1 to world.maxx)
						if(yReal in 1 to world.maxy)
							if(zReal in 1 to world.maxz)
								return TRUE
							else
								return FALSE
						else
							return FALSE
					else
						return FALSE
				else
					return FALSE
			else
				return FALSE
		Save()
			fdel("World Objects/Strength Boulders/Strength Boulder at [x] [y] [z].esav")
			var savefile/F = new
			F << src
			text2file(RC5_Encrypt(F.ExportText("/"),md5("strength")),"World Objects/Strength Boulders/Strength Boulder at [x] [y] [z].esav")
		Load()
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("World Objects/Strength Boulders/Strength Boulder at [x] [y] [z].esav"),md5("strength")))
			F >> src
		CreateCloneBoulder(player/P,useOldLoc) // Used to Generate a Boulder Clone based on this Boulder
			if(!("[P.ckey]" in src.clonesList))
				var playerStrengthClone/Clone = new
				Clone.sourceBoulder = src
				var hasOldLoc = cloneHasValidLocation(P)
				if((!hasOldLoc) || (!useOldLoc))
					Clone.Move(locate(src.x,src.y,src.z))
				else
					Clone.Move(locate(clonePositions["[P.ckey]"]["x"],clonePositions["[P.ckey]"]["y"],clonePositions["[P.ckey]"]["z"]))
				Clone.myImage = image('HM Icons.dmi',Clone,"Strength Boulder")
				P.client.images -= src.theImage
				P.client.images |= Clone.myImage
				src.players_passthrough |= "[P.ckey]"
		DestroyCloneBoulder(player/P,deleteLoc) // Used to Destroy a Boulder Clone based on this Boulder
			var playerStrengthClone/Clone = src.clonesList["[P.ckey]"]
			if(P.ckey != Clone.owningCkey)return // Only the original player who is resonsible for the clone can be used for its deletion.
			if(isnull(Clone))return // Clone doesn't even exist.
			Clone.loc = null
			P.client.images -= Clone.myImage
			P.client.images |= src.theImage
			if(deleteLoc)
				src.clonePositions -= P.ckey
				players_passthrough -= P.ckey
			src.clonesList["[P.ckey]"] = null
			src.clonesList -= P.ckey
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			var pokemon/PK
			var moveUsed // will be 'Strength' or 'Psychic'
			if(!("[ckeyEx(P.key)]" in players_passthrough))
				break_loop
					for(var/pokemon/PKMN in P.party)
						for(var/pmove/M in PKMN.moves)
							if(istype(M,/pmove/Strength))
								PK = PKMN
								moveUsed = "Strength"
								break break_loop
							else if(istype(M,/pmove/Psychic))
								PK = PKMN
								moveUsed = "Psychic"
								break break_loop
				if(isnull(PK))
					var theQuotes[] = list("What do you think I am, an MMA wrestler?","Sure, let me use my imaginary powers of Telekenesis!",
					"Can't do that, too weak.","It's [realTime.Year()], and you can't remember what moves we know?")
					var quote = pick(theQuotes)
					var theParty[0]
					for(var/x in 1 to 6)
						if(istype(P.party[x],/pokemon))
							theParty += P.party[x]
					var
						Color
							C1 = (P.gender==FEMALE)?(RedColor):(BlueColor)
							C2 = null
					if(rand(1,theQuotes.len+1)==theQuotes.len+1)
						if(theParty.len == 1)
							PK = P.party[1]
							C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
							P.ShowText("[PK], move the boulder!",C1,TRUE)
							P.ShowText("[PK]: Okay!",C2,TRUE)
							var whichQuote = pick("BRAIN POWAH","SEISMIC SHOVE")
							P.ShowText("[whichQuote]!!!",C2,TRUE)
							if(whichQuote != "BRAIN POWAH")
								P.ShowText("*BANG*",new/Color,TRUE)
								P.ShowText("...",new/Color,TRUE)
								P.ShowText("I think I just broke my wrists...",C2,TRUE)
							else
								P.ShowText("AAAIIEEE",new/Color,TRUE)
								P.ShowText("...",new/Color,TRUE)
								P.ShowText("I think I gave myself a severe migraine...",C2,TRUE)
							P.Move(P.respawnpoint)
						else
							PK = pick(theParty)
							var pokemon/PK2 = pick(theParty-PK)
							C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
							var Color/C3 = (PK2.gender==FEMALE)?(RedColor):((PK2.gender==MALE)?(BlueColor):(new/Color))
							P.ShowText("[PK], move the boulder!",C1,TRUE)
							P.ShowText("[PK]: Okay!",C2,TRUE)
							var whichQuote = pick("BRAIN POWAH","SEISMIC SHOVE")
							P.ShowText("[whichQuote]!!!",C2,TRUE)
							if(whichQuote != "BRAIN POWAH")
								P.ShowText("*BANG*",new/Color,TRUE)
								P.ShowText("[PK]: ...",C2,TRUE)
								P.ShowText("[PK2]: ...",C3,TRUE)
								P.ShowText("[PK2]: WHAT THE HELL? YOU JUST HIT ME!",C3,TRUE)
								P.ShowText("[PK]: Sorry...",C2,TRUE)
							else
								P.ShowText("*AAAIIEEE!",new/Color,TRUE)
								P.ShowText("[PK]: ...",C2,TRUE)
								P.ShowText("[PK2]: ...",C3,TRUE)
								P.ShowText("[PK2]: WHAT THE FUCK? STAY OUT OF MY HEAD!!!",C3,TRUE)
								P.ShowText("[PK]: Didn't mean to...",C2,TRUE)
					else
						PK = pick(theParty)
						C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
						P.ShowText("[PK], move the boulder!",C1,TRUE)
						P.ShowText("[PK]: [quote]",C2,TRUE)
				else
					P.client.images -= theImage
					players_passthrough |= "[ckeyEx(P.key)]"
					CreateCloneBoulder(P,FALSE)
					P.ShowText("[PK]'s [moveUsed] allows you to move this boulder around!")

playerStrengthClone // Individual Strength Boulder Clones
	parent_type = /obj
	var
		image/myImage
		strengthBoulder/sourceBoulder
		owningCkey
	Cross(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(P.ckey == src.owningCkey)
				return FALSE
			else
				return ..()
		else
			src.density = 1
			spawn(1) src.density = 0
			return ..()
	CrossFailed(atom/movable/O)
		if(istype(O,/player)) // This should only be called for players anyway
			var player/P = O
			if(P.ckey == src.owningCkey)
				var
					newX = sourceBoulder.clonePositions["[owningCkey]"]["x"]
					newY = sourceBoulder.clonePositions["[owningCkey]"]["y"]
					newZ = sourceBoulder.clonePositions["[owningCkey]"]["z"]
				switch(P.dir)
					if(NORTH)
						newY += 1
					if(SOUTH)
						newY -= 1
					if(EAST)
						newX += 1
					if(WEST)
						newX += 1
				var turf/T = locate(newX,newY,newZ)
				if(T)
					// attempt to move the cloned boulder to T
					src.Move(T)
	Moved(atom/NewLoc,Dir,step_x,step_y)
		if(!islist(sourceBoulder.clonePositions["[owningCkey]"]))
			sourceBoulder.clonePositions["[owningCkey]"] = list("x","y","z")
		sourceBoulder.clonePositions["[owningCkey]"]["x"] = src.x
		sourceBoulder.clonePositions["[owningCkey]"]["y"] = src.y
		sourceBoulder.clonePositions["[owningCkey]"]["z"] = src.z

headbuttTree
	parent_type = /obj
	icon = 'Tree-1 Design.dmi'
	icon_state = "Summer"
	density = 1
	layer = 4.1
	New()
		..()
		headbuttTrees += src
	Del()
		headbuttTrees -= src
		..()
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			var pokemon/PK
			var moveUsed // will be 'Headbutt' or 'Zen Headbutt'
			break_loop:
				for(var/pokemon/PKMN in P.party)
					for(var/pmove/M in PKMN.moves)
						if(istype(M,/pmove/Headbutt))
							PK = PKMN
							moveUsed = "Headbutt"
							break break_loop
						else if(istype(M,/pmove/Zen_Headbutt))
							PK = PKMN
							moveUsed = "Zen Headbutt"
							break break_loop
			if(isnull(PK))
				var theQuotes[] = list("Sorry, I can't. I just got a haircut.","Stop Talking.","Alright, let me get my titanium crushing hat. But wait, \
				it's gone!","You think I can headbutt a tree without getting hurt?","It's [realTime.Year()]. How is it you don't remember what moves I know?")
				var quote = pick(theQuotes)
				var theParty[0]
				for(var/x in 1 to 6)
					if(istype(P.party[x],/pokemon))
						theParty += P.party[x]
				var
					Color
						C1 = (P.gender==FEMALE)?(RedColor):(BlueColor)
						C2 = null
				if(rand(1,theQuotes.len+1)==theQuotes.len+1)
					if(theParty.len==1)
						PK = P.party[1]
						C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
						P.ShowText("[PK], use [pick("Headbutt","Zen Headbutt")]!",C1,TRUE)
						P.ShowText("[PK]: Okay!",C2,TRUE)
						P.ShowText("UPPERCUT HEAD ATTACK!!!",C2,TRUE)
						P.ShowText("*CRASH*",TRUE)
						P.ShowText("...",TRUE)
						P.ShowText("I think I just shattered my hands...",C2,TRUE)
						P.Move(P.respawnpoint)
					else
						PK = pick(theParty)
						var pokemon/PK2 = pick(theParty-PK)
						C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
						var Color/C3 = (PK2.gender==FEMALE)?(RedColor):((PK2.gender==MALE)?(BlueColor):(new/Color))
						P.ShowText("[PK], use [pick("Headbutt","Zen Headbutt")]!",C1)
						P.ShowText("[PK]: Okay!",C2)
						P.ShowText("UPPERCUT HEAD ATTACK!!!",C2)
						P.ShowText("*CRASH*")
						P.ShowText("[PK]: ...",C2)
						P.ShowText("[PK2]: ...",C3)
						P.ShowText("[PK2]: WHAT THE HELL? YOU JUST HIT ME!",C3)
						P.ShowText("[PK]: Sorry...",C2)
				else
					PK = pick(theParty)
					C2 = (PK.gender==FEMALE)?(RedColor):((PK.gender==MALE)?(BlueColor):(new/Color))
					P.ShowText("[PK], use [pick("Headbutt","Zen Headbutt")]!",C1,TRUE)
					P.ShowText("[PK]: [quote]",C2,TRUE)
			else
				P.ShowText("[PK] rammed the tree with [moveUsed]!")
				var mon
				var monLevel
				switch(P.route)
					if(LITTLEROOT_TOWN)
						switch(timePeriod)
							if("Dawn","Day")
								mon = pick(prob(30);"Starly",prob(10);"Bidoof",prob(10);"Pikachu",prob(40);"Buneary",prob(5);"Burmy",prob(5);"Pachirisu")
							if("Dusk","Night")
								mon = pick(prob(30);"Hoothoot",prob(10);"Rattata",prob(10);"Pikachu",prob(40);"Buneary",prob(5);"Burmy",prob(5);"Pachirisu")
						switch(mon)
							if("Starly","Hoothoot","Pikachu","Pachirisu")
								monLevel = rand(2,4)
							if("Rattata","Burmy")
								monLevel = rand(3,5)
				var pokemon/S = get_pokemon(mon,P,level=monLevel)
				S.stat_calculate()
				S.HP = S.maxHP
				var battleSystem/X = new(list(P),FALSE,S,area_type=GRASSY)
				P.client.battle = X // To be safe