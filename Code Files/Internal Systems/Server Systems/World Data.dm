var
	BaseCamp/Calendar
		gameTime
		realTime
	trees_list[0]
	Event/event
	connect_password = ""
	seasonTime = "Summer"
	timePeriod = "Daytime"
	obj/time_overlay = new/obj{icon='Times.dmi';screen_loc = "NORTHEAST to SOUTHWEST";layer=4500;mouse_opacity=0}
	Color
		RedColor
		BlueColor
	pokemonStats[]
	pokemonEvs[]
	screen/lighting_plane/flashPlane
	regex/number_commas = new("(?<=\\d)(?=(\\d{3})+(?!\\d))","g")
	gameFlags = (0 | RESPAWN_CHECK | USE_SCALED_EXP_FORMULA | TOGGLE_HP_NATURES)

proc
	Day_Night_Change()
		set background = 1
		set waitfor = 0
		for(ever)
			switch(text2num(gameTime.Hour()))
				if(4 to 10) // Morning and Evening
					if(timePeriod!="Dawn")
						timePeriod="Dawn"
						time_overlay.icon_state = "Dawn"
						time_overlay.blend_mode = BLEND_MULTIPLY
				if(11 to 17)
					if(timePeriod!="Day")
						timePeriod="Day"
						time_overlay.icon_state = ""
						time_overlay.blend_mode = BLEND_OVERLAY
				if(18 to 19)
					if(timePeriod!="Dusk")
						timePeriod="Dusk"
						time_overlay.icon_state = "Dusk"
						time_overlay.blend_mode = BLEND_MULTIPLY
				if(20 to 23,0 to 3)
					if(timePeriod!="Night")
						timePeriod="Night"
						time_overlay.icon_state = "Night"
						time_overlay.blend_mode = BLEND_MULTIPLY
			sleep TICK_LAG*60

world
	name = "Pokémon: Universe Network"
	mob = /player
	hub = "Vexxen.PUN"
	hub_password = "PSbG5N7W5IA9keBpl"

	map_format = TOPDOWN_MAP
	visibility = 1
	fps = FPS
	view = "22x16"

	New()
		if(copytext(src.host,1,7)=="Guest-")
			shutdown()
		setTypeMatchups()
		initEXPList()
		. = ..()
		gameTime = new(-5)
		realTime = new(-5)
		gameTime.setTimeSpeed(4)
		event = new
		RedColor = new
		BlueColor = new
		RedColor.red = 255
		BlueColor.blue = 255
		flashPlane = new
		Load_Staff()
		professor_image.loc = map_Locate(10,7,"Intro")
		log = file("PUN Logs.txt")
		tmIncompatible = list("Caterpie","Metapod","Weedle","Kakuna","Magikarp","Ditto","Unown","Smeargle","Wurmple",
		"Silcoon","Cascoon","Beldum","Combee","Scatterbug","Spewpa","Wobbuffet","Wynaut","Kricketot","Burmy","Tynamo")
		pokemonStats = list()
		pokemonEvs = list()
		updateClock()
		Season_Tree_Loop()
		Day_Night_Change()
		//weatherLoop()
		updateCPU()

	IsBanned(key,address,computer_id)
		. = ..()
		if(copytext(key,1,6)=="Guest")
			if(istype(.,/list))
				.["message"] = "No Guests."
			return

	Topic(T,Addr,Master,Keys)
		var T_List[] = splittext(T,";")
		switch(T_List[1])
			if("pokemon_transfer")
				var playerKey = T_List[2]
				if(fexists("Transfer Files/[ckeyEx(playerKey)].esav"))
					return FALSE
				text2file(T_List[3],"Transfer Files/[ckeyEx(playerKey)].esav")
				return TRUE
			if("allow_transfer")
				var playerKey = T_List[2]
				return !(fexists("Transfer Files/[ckeyEx(playerKey)].esav") || length(transferHolder["[ckeyEx(playerKey)].esav"]))
			if("valid_link")
				return 1
			if("can_import_gen_3") // If the player is an admin or moderator, or if they beat the elite 4, this returns true
				var playerKey = T_List[2]
				if((playerKey in Admin_key) || (playerKey in Moderator_key))return TRUE
				if(fexists("Storyline Data/[ckeyEx(playerKey)].esav"))
					var savefile/F = new
					var Storyline/story = new
					F.ImportText("/",RC5_Decrypt(file2text("Storyline Data/[ckeyEx(playerKey)].esav"),md5("Super Data")))
					story.Read(F)
					if(story.storyFlags & BEAT_ELITE_FOUR)
						return TRUE
					else
						return FALSE
				else
					return FALSE
			else
				. = ..()

	Del()
		Save_Staff()
		event = null
		for(var/theSaveObject in berry_trees+itemsList+cutTrees+smashBoulders+strengthBoulders)
			theSaveObject:Save()
		. = ..()
	proc
		updateCPU()
			set waitfor = 0
			set background = 1
			for(ever)
				world.name = "Pokémon Universe Network (Server CPU Usage: [world.cpu]%)"
				sleep TICK_LAG
		#if 0
		weatherLoop()
			set waitfor = 0
			set background = 1
			var areasWeather
			for(ever)
				areasWeather = 0
				Shuffle(townRoutes)
				for(var/area/Town_Route/A in townRoutes)
					if(areasWeather > 5)
						if(A.outdoor && A.weatherChange && (locate(/turf) in A))
							switch(seasonTime)
								if("Spring","Autumn")
									A.weather = pick(prob(10);"Snow",prob(90);"Rain")
								if("Summer")
									A.weather = "Rain"
								if("Winter")
									A.weather = "Snow"
							++areasWeather
					else
						A.weather = ""
					for(var/player/P in A)
						P.weatherOverlay.icon_state = A.weather
				sleep MINUTE*5
		#endif
		Respawn_Loop()
			set waitfor = 0
			set background = 1
		Season_Tree_Loop()
			set waitfor = 0
			set background = 1
			for(ever)
				switch(text2num(realTime.Month()))
					if(12,1,2)
						if(seasonTime!="Winter")
							seasonTime="Winter"
							Season_Tree_Winter()
					if(3 to 5)
						if(seasonTime!="Spring")
							seasonTime="Spring"
							Season_Tree_Spring()
					if(6 to 8)
						if(seasonTime!="Summer")
							seasonTime="Summer"
							Season_Tree_Summer()
					if(9 to 11)
						if(seasonTime!="Autumn")
							seasonTime="Autumn"
							Season_Tree_Autumn()
				sleep TICK_LAG*60
		Season_Tree_Winter()
			set waitfor = 0
			set background = 1
			for(var/turf/outdoor/tree/special_version/summer_tree/T in global.trees_list)
				T.icon_state = "Winter"
			for(var/cutBush/C in global.cutTrees)
				C.theImage.icon_state = "Bush Winter"
			for(var/headbuttTree/H in global.headbuttTrees)
				H.icon_state = "Winter"
		Season_Tree_Summer()
			set waitfor = 0
			set background = 1
			for(var/turf/outdoor/tree/special_version/summer_tree/T in global.trees_list)
				T.icon_state = "Summer"
			for(var/cutBush/C in global.cutTrees)
				C.theImage.icon_state = "Bush"
			for(var/headbuttTree/H in global.headbuttTrees)
				H.icon_state = "Summer"
		Season_Tree_Autumn()
			set waitfor = 0
			set background = 1
			for(var/turf/outdoor/tree/special_version/summer_tree/T in global.trees_list)
				T.icon_state = "Autumn"
			for(var/cutBush/C in global.cutTrees)
				C.theImage.icon_state = "Bush"
			for(var/headbuttTree/H in global.headbuttTrees)
				H.icon_state = "Autumn"
		Season_Tree_Spring()
			set waitfor = 0
			set background = 1
			for(var/turf/outdoor/tree/special_version/summer_tree/T in global.trees_list)
				T.icon_state = "Spring"
			for(var/cutBush/C in global.cutTrees)
				C.theImage.icon_state = "Bush"
			for(var/headbuttTree/H in global.headbuttTrees)
				H.icon_state = "Spring"