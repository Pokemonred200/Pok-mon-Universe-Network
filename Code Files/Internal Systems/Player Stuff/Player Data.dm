/* Red (Pokemonred200) */

var static/player/online_players[0]
var static/playerCkeys[0]
var static/playerKeys[0]
var static/playerCkeyExes[0]

player
	parent_type = /combatant
	layer = MOB_LAYER + 1
	New()
		. = ..()
		com = new(src)
		bag = new
		eventsGiven = list()
		opowert = list()
		opowerl = list()
		sprite = new/image{override=1}
		gear = new
		active_costume = new
		TID = rand(0,65535)
		SID = rand(0,65535)
		tValue = rand(1,8192)
		costumeImage = new(src,"Trainer Card","playerPortrait")
		sprite.loc = src
		sprite.underlays += image('Shadow Effects.dmi',"Shadow")
		weatherOverlay = new /obj
		weatherOverlay.plane = 2
		weatherOverlay.icon = 'Climate Icon.dmi'
		battleBackground = new
		weatherOverlay.screen_loc = "NORTHEAST to SOUTHWEST"
		eventReturnSpots = list()
	Del()
		playerCkeys -= "[src.ckey]"
		playerCkeyExes -= "[ckeyEx(src.key)]"
		playerKeys -= "[src.key]"
		. = ..()
	Moved(atom/NewLoc,Dir,step_x,step_y)
		. = ..()
		var item/key/Laptop/laptop = bag.getItem(/item/key/Laptop)
		if(laptop && (laptop.charge > 0))--laptop.charge
		if(repelsteps > 0)
			if((--repelsteps)==0)
				src.ShowText("The repel's effect wore off...")
		if(rechargeSteps > 0)--rechargeSteps
		gear.steps++
		if(gear.steps%4==0)
			for(var/x in 1 to 6)
				var pokemon/P = src.party[x]
				if(istype(P,/pokemon))P.poisonDamage()
		if(src.walker)
			src.walker.Move(prevLoc)
		if(breedhandlers)
			for(var/ID in breedhandlers)
				var breedhandler/BH = breedhandlers[ID]
				BH.updateSteps()
		if(locate(/Egg) in src.party)
			var fasterEgg = FALSE
			for(var/x in 1 to 6)
				var pokemon/P = src.party[x]
				if(isnull(P))break
				else if(!istype(P,/pokemon))continue
				if("Flame Body" in list(P.ability1,P.ability2))
					fasterEgg = TRUE
					break
				else if("Magma Armor" in list(P.ability1,P.ability2))
					fasterEgg = TRUE
					break
			for(var/x in 1 to 6)
				var Egg/E = src.party[x]
				if(isnull(E))break
				else if(!istype(E,/Egg))continue
				if((--E.cycleStepsLeft)==0)
					E.eggCycles -= ((fasterEgg)?(2):(1))
					if(E.eggCycles<=0)
						E.Hatch()
						break
					else E.cycleStepsLeft = 257
		for(var/x in 1 to 6)
			var pokemon/P = src.party[x]
			if(isnull(P))break
			else if(!istype(P,/pokemon))continue
			if(P!=src.walker)
				P.friendsteps++
			else
				P.friendsteps += 2
			if(P.friendsteps >= 255)
				P.increaseFriendship("walking")
				P.friendsteps = 0
		var trainersList[]
		for(var/mob/NPC/NPCTrainer/N in viewers(src))
			trainersList = src.story.defeatedTrainers["[N.type]"]
			if(N.FOV && (!(trainersList && trainersList.Find(N.theID))) && (get_dist(src,N) <= N.FOVRange))
				var mob/clone
				switch(N.beginDir)
					if(SOUTH)
						if((src.x==N.x)&&(src.y<N.y))
							N.dir = SOUTH
							clone = N.createClone(src)
							src.client.clientFlags |= LOCK_MOVEMENT
					if(NORTH)
						if((src.x==N.x)&&(src.y>N.y))
							N.dir = NORTH
							clone = N.createClone(src)
							src.client.clientFlags |= LOCK_MOVEMENT
					if(WEST)
						if((src.x<N.x)&&(src.y==N.y))
							N.dir = WEST
							clone = N.createClone(src)
							src.client.clientFlags |= LOCK_MOVEMENT
					if(EAST)
						if((src.x>N.x)&&(src.y==N.y))
							N.dir = EAST
							clone = N.createClone(src)
							src.client.clientFlags |= LOCK_MOVEMENT
				if(clone)
					while(get_dist(clone,src)>1)
						step_to(clone,src)
						sleep TICK_LAG+0.75
					walk(clone,0)
					N.Interact(src,TRUE)
					src.client.clientFlags &= ~LOCK_MOVEMENT
					break
	MoveFailed(atom/NewLoc,Dir,step_x,step_y)
		. = ..()
		src << sound('sound_bump.wav')
	Cross(atom/movable/O)
		if(istype(O, /player) || istype(O, /pokemon))
			return TRUE
		else
			return ..()
	var
		communications/com
		inventory/bag
		tValue
		mode
		route
		savedPlayerFlags = 0
		repelsteps = 0
		money = 3000
		coins = 0
		rechargeSteps = 0
		breedhandler/breedhandlers[]
		eventReturnSpots[]
		tmp
			vivillonID
			list/costume
			breedhandler/activeDaycare
			obj/pkbSprite
			turf/respawnpoint
			playerFlags = 0
			staffRoomGrindRate = 0
			obj/weatherOverlay
			background/battleBackground
			Label/costumeImage
			image/sprite
			image/flashlight/lightArea
			costume/active_costume
			pokemon/walker
			Storyline/story
			TradeProxy/tradeProxy
			organization/myTeam
		current_world_region = "Hoenn"
		coin_case
		escape_loc
		escape_dir
		eventsGiven[]
		opowert[]
		opowerl[]
		teamName
		pokegear/gear
		current_costume = ""
	Login()
		src << "Type /help in the chatbox for certain game info."
		vivillonID = (text2num(src.client.computer_id)%18)*8
		. = ..()
		src.client.screen += weatherOverlay
		story = new(src)
		pkbSprite = new
		pkbSprite.screen_loc = "map3:0,0"
		src.client.screen += pkbSprite
		src.Move(locate(220, 158, 1))
		src.playerFlags |= IN_LOGIN
		respawnpoint = locate("HouseRespawn")
		src.client.moneyLabel = new(src,"Trainer Card","moneyDisplay")
		Staff(src)
		if(Server_Private)
			if(!src.Is_staff && !Check(src, Testing_LIST)){src << output("The server is <B>PRIVATE</B>!"); del(src)}
		if(!(global.online_players.Find(src)))
			global.online_players.Add(src)
			global.online_players << "\yellow[src.key] has logged on!"
			src << "<font color = red>Check out our forums (More to be added soon) @ http://pkmnuniversenetwork.proboards.com</font>"
			src << "<font color = red>Check out our Discord server @ https://discord.gg/wtXEUZj</font>"
			src << ""
			src << "<font color = red>Game is not yet complete. Please provide constructive criticism, and report bugs to our forums or discord.</font>"
			playerCkeys["[src.ckey]"] = src
			playerCkeyExes["[ckeyEx(src.key)]"] = src
			playerKeys["[src.key]"] = src
		src.AddLoginObjects()

		awardMedal("Player",src)
		if(world.IsSubscribed(src,"BYOND"))
			awardMedal("BYOND Member",src)
	Logout()
		if((!(src.playerFlags & IN_LOGIN))&&(src.route!=PAL_PARK))
			src.Save()
		src.playerFlags |= LOGGING_OUT
		transferHolder["[ckeyEx(src.key)]"] = list() // Clear Out the Holding Cell for this Player
		caughtTransfers["[ckeyEx(src.key)]"] = list()
		playerCkeys -= "[src.ckey]"
		playerCkeyExes -= "[ckeyEx(src.key)]"
		playerKeys -= "[src.key]"
		for(var/strengthBoulder/ST in strengthBoulders)
			ST.DestroyCloneBoulder(src,FALSE)
		global.online_players << "\yellow[src.name] has logged off!"
		del src.walker
		del src
		. = ..()

	proc
		modCoins(coinChange)
			if(!src.bag.hasItem(/item/key/Coin_Case))return
			src.coins += coinChange
		getBreedHandler(ID)
			if(isnull(breedhandlers))
				breedhandlers = list()
			if(isnull(breedhandlers["[ID]"]))
				breedhandlers["[ID]"] = new/breedhandler(src)
			return breedhandlers["[ID]"]
		add_costumes()
			if(src.playerFlags & LOADED_COSTUMES)return
			src.playerFlags |= LOADED_COSTUMES
			switch(src.gender)
				if(MALE)
					src.costume = newlist(/costume/special_costume/RSE_character/icon_male_01,/costume/special_costume/RSE_character/icon_male_02,
					/costume/special_costume/DPPt_character/icon_male_01,/costume/special_costume/DPPt_character/icon_male_02,
					/costume/special_costume/HGSS_character/icon_male_01,/costume/special_costume/HGSS_character/icon_male_03,
					/costume/special_costume/HGSS_character/icon_male_02,/costume/special_costume/FRLG_character/icon_male_01)
				else
					src.costume = newlist(/costume/special_costume/RSE_character/icon_female_01,/costume/special_costume/RSE_character/icon_female_02,
					/costume/special_costume/DPPt_character/icon_female_01,/costume/special_costume/DPPt_character/icon_female_02,
					/costume/special_costume/FRLG_character/icon_female_01,/costume/special_costume/HGSS_character/icon_female_01,
					/costume/special_costume/HGSS_character/icon_female_02,/costume/special_costume/HGSS_character/icon_female_03,
					/costume/special_costume/HGSS_character/icon_female_04)
			switch(src.key)
				if("Vexxen"){src.costume += new/costume/special_costume/other_character/icon_vexxen}
				if("Cart12"){src.costume += new/costume/special_costume/other_character/icon_rai}
				if("Kitasame Yurikaro"){src.costume += new/costume/special_costume/other_character/icon_skya}
				if("Harzar"){src.costume += new/costume/special_costume/other_character/icon_harzar}
				if("Sara13243"){src.costume += new/costume/special_costume/other_character/icon_amber}
				if("GMCros"){src.costume += new/costume/special_costume/other_character/icon_teal}
				if("Gabriel Draconi"){src.costume += new/costume/special_costume/other_character/icon_draconi}
				if("Sarathesmexy"){src.costume += new/costume/special_costume/other_character/icon_sarah}
				if("Lonefire Blossom"){src.costume += new/costume/special_costume/other_character/icon_lonefire}
				if("Unleashed gohan"){src.costume += new/costume/special_costume/other_character/icon_kenny}
				if("ROBERTTHEKILLER"){src.costume += new/costume/special_costume/other_character/icon_rob}
				if("Scotty-V"){src.costume += new/costume/special_costume/other_character/icon_scotty}
				if("Pokemonred200"){src.costume.Add(new/costume/special_costume/other_character/icon_red_01,new/costume/special_costume/other_character/icon_red_02)}
		display()
			set waitfor = 0
			set background = 1
			src.client.images += src.sprite
			if(src.walker)src.client.images += src.walker.sprite
			for(var/player/P in global.online_players)
				if(P==src)continue
				src.client.images += P.sprite
				if(!isnull(P.walker))
					src.client.images += P.walker.sprite
				P.client.images += src.sprite
				if(!isnull(src.walker))
					P.client.images += src.walker.sprite

			for(var/mob/NPC/NPCTrainer/Rival/R in rival_list)
				if(src.gender == "male")
					src.client.images |= R.femaleIcon
				else
					src.client.images |= R.maleIcon

			for(var/turf/outdoor/berry_stuff/B in berry_trees)
				if(!B.players_berry.Find("[ckeyEx(src.key)]"))
					B.initalize_for_player("[ckeyEx(src.key)]")
				var image/I = B.players_berry["[ckeyEx(src.key)]"]["berry_sprite"]
				src.client.images |= I

			for(var/owItem/O in global.itemsList)
				if(!O.players_pickedup.Find("[ckeyEx(src.key)]"))
					src.client.images |= O.theImage

			for(var/owTMPickup/OTI in itemsList)
				if(!OTI.players_pickedup.Find("[ckeyEx(src.key)]"))
					src.client.images |= OTI.theImage

			for(var/cutBush/C in cutTrees)
				if(!C.players_passthrough.Find("[ckeyEx(src.key)]"))
					src.client.images |= C.theImage

			for(var/smashBoulder/S in smashBoulders)
				if(!S.players_passthrough.Find("[ckeyEx(src.key)]"))
					src.client.images |= S.theImage

			for(var/mob/NPC/NPCTrainer/T in trainers_list)
				if(T.FOV && T.imageCache)
					var image/I = T.imageCache["[ckeyEx(src.key)]"]
					src.client.images |= (I)?(I):(T.mainImage)

			for(var/strengthBoulder/ST in strengthBoulders)
				if(!ST.players_passthrough.Find("[src.ckey]"))
					src.client.images |= ST.theImage
				else if(ST.cloneHasValidLocation(src))
					if(!istype(ST.clonesList["[src.ckey]"],/playerStrengthClone)) // Clone does not exist in RAM
						ST.CreateCloneBoulder(src,TRUE) // Create a clone of the boulder with the old clone's location
					src.client.images |= ST.clonesList["[src.ckey]"].myImage
				else
					src.client.images |= ST.theImage // Clone needs to exist with valid location data
					ST.clonePositions -= "[src.ckey]" // Remove garbage data
			updateEvents(src)
		Save()
			if(fexists("Savefiles/[ckeyEx(src.key)].esav"))
				fdel("Savefiles/[ckeyEx(src.key)].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("125")),file("Savefiles/[ckeyEx(src.key)].esav"))
			story.save()
		Load()
			if(fexists("Savefiles/[ckeyEx(src.key)].esav"))
				src.playerFlags |= IS_LOADING
				src.playerFlags &= ~IN_LOGIN
				src.Interface(1, "Test")
				src.Interface(1, "InGame")
				story.load()
				Process_Transfer(src)
				var savefile/F = new
				F.ImportText("/",RC5_Decrypt(file2text("Savefiles/[ckeyEx(src.key)].esav"),md5("125")))
				src.Read(F)
				add_costumes()
				if(teamName)
					myTeam = get_organization(teamName)
				display()
				src.ShowText("Remember to press TAB to Interact!")
				winset(src,"default.routeLabel","is-visible=true")
				if(F["version"]<2)
					story.storyFlags &= ~GOT_VS_SEEKER
				if(F["version"]<4)
					if(src.route==NAVEL_ROCK)
						src.Move(locate("Navel Rock Harbor"))
				if(F["version"]<5)
					story.storyFlags &= ~4
				src.playerFlags &= ~IS_LOADING
			else
				src.ShowText("You don't have a savefile.")
				src.AddLoginObjects()
		costume(row = 0, number = 0)
			winset(src, "costume", "is-visible=true")
			for(var/costume/a in src.costume)
				if(a in src.costume)
					row ++ ; number ++
					src << output("[number].)", "Cgrid:1,[row]")
					src << output(a, "Cgrid:2,[row]")
			winset(src,"costume window.Cgrid","cells=2x[row]")