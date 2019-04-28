var berry_trees[0]
var signList[0]

skipper
	parent_type = /obj

atom
	var rin = NORTH | SOUTH | EAST | WEST
	var rout = NORTH | SOUTH | EAST | WEST
	Enter(atom/movable/O,atom/oldloc)
		if(src.type == /turf || (!(O.dir & rin)))
			return FALSE
		else
			return ..()

	Exit(atom/movable/O,atom/newloc)
		if(!(O.dir & rout))
			return FALSE
		else
			return ..()
	Exited(atom/movable/Obj,atom/newLoc)
		. = ..()
		Obj.prevLoc = src
	movable
		Cross(atom/movable/O)
			if(!(O.dir & rin))
				return FALSE
			else
				return ..()
		Uncross(atom/movable/O)
			if(!(O.dir & rout))
				return FALSE
			else
				return ..()



turf
	Exited(atom/movable/O,atom/newloc)
		..()
		var turf/portal/enter_portal/EP = locate() in src
		if(EP)
			if(!(locate(/turf/portal/enter_portal) in newloc))
				O.atomMovFlags &= ~LAST_TILE_TELEPORT
	dense_block
		parent_type = /obj
		plane = -100
		Cross(atom/movable/O)return 0
	indoor
		room_stuff
			icon = 'Room Tiles.dmi'
			floor
				floor_01{icon_state = "lab floor"}
			game_console
				parent_type = /obj
				density = 1
				icon = 'Room Tiles.dmi'
				gamecube
					icon_state = "gamecube"
					Interact(atom/movable/O)
						if(istype(O,/player))
							var player/P = O
							P.ShowText("Playing Super Smash Bros Melee...")
							P.ShowText("I lost hard. Pichu sucks in this game, I'll play Mario next time.")
				wii
					icon_state = "wii"
					Interact(atom/movable/O)
						if(istype(O,/player))
							var player/P = O
							P.ShowText("Playing Pokémon Battle Revolution...")
							P.ShowText("HOW DID MY LEVEl 100 ARCEUS LOSE TO A LEVEL 1 [pick("RATTATA","STARLY")]!!!")
				nes
					icon_state = "nes"
					Interact(atom/movable/O)
						if(istype(O,/player))
							var player/P = O
							P.ShowText("Playing Super Mario Brothers...")
							P.ShowText("The princess got captured AGAIN? Her security sucks. No, not like that you perverted idiots.")
				snes
					icon_state = "snes"
					Interact(atom/movable/O)
						if(istype(O,/player))
							var player/P = O
							P.ShowText("Playing Metroid...")
							P.ShowText("How is it that this lady is infused with a bird but can't fly?")
			bed
				bed_top{icon_state = "bed 2"}
				bed_bot{icon_state = "bed 1" ; density = 1}
			object
				parent_type = /obj
				icon = 'Room Tiles.dmi'
				plant{icon_state = "plant" ; density = 1}
				window{icon_state = "window" ; density = 1}
				stool{parent_type = /turf ; icon = 'Room Tiles.dmi' ; icon_state = "stool"}
				blue_stool{parent_type = /turf ; icon = 'Room Tiles.dmi' ; icon_state = "stool-blue"}
				bookshelf{icon_state = "bookshelf" ; density = 1}
				comp_desk{icon_state = "comp desk" ; density = 1}
				television{icon_state = "tv" ; density = 1}
			stairs
				stairs_left{icon_state = "stairs-left"}
				stairs_right{icon_state = "stairs"}
		object
			bed {icon = 'Indoor.dmi' ; density = 1}
			staircases {icon = 'Indoor.dmi' ; density = 1}
			window{icon = 'Indoor Object.dmi' ; density = 1}
			television{icon = 'Indoor Object.dmi' ; icon_state = "TV" ; density = 1}
			game_console{icon = 'Indoor Object.dmi' ; density = 1}
			chair{icon = 'Indoor Object.dmi' ; density = 1}
		tiles
			wall{icon = 'Indoor Design.dmi' ; density = 1}
			floor{icon = 'Indoor Design.dmi' ; density = 0}
		market_design
			floor
				floor_01{icon = 'Market Design.dmi' ; icon_state = "Floor Tile 01" ; density = 0}
				floor_02{icon = 'Market Design.dmi' ; icon_state = "Floor Tile 02" ; density = 0}
				floor_03{icon = 'Market Design.dmi' ; icon_state = "Floor Tile 03" ; density = 0}
			wall
				wall_01{icon = 'Market Design.dmi' ; icon_state = "Wall 01" ; density = 1}
				wall_02{icon = 'Market Design.dmi' ; icon_state = "Wall 02" ; density = 1}
				wall_03{icon = 'Market Design.dmi' ; icon_state = "Wall 03" ; density = 1}
				wall_04{icon = 'Market Design.dmi' ; icon_state = "Wall 04" ; density = 1}
				wall_05{icon = 'Market Design.dmi' ; icon_state = "Wall 05" ; density = 1}
			market_object
				object_01{icon = 'Market Design.dmi' ; icon_state = "Object 01" ; density = 1}
				object_02{icon = 'Market Design.dmi' ; icon_state = "Object 02" ; density = 1}
				object_03{icon = 'Market Design.dmi' ; icon_state = "Object 03" ; density = 1}
			counter
				counter_01{icon = 'Market Design.dmi' ; icon_state = "Counter 01" ; density = 1}
				counter_02{icon = 'Market Design.dmi' ; icon_state = "Counter 02" ; density = 1}
				counter_03{icon = 'Market Design.dmi' ; icon_state = "Counter 03" ; density = 1}
				counter_04{icon = 'Market Design.dmi' ; icon_state = "Counter 04" ; density = 1}
				counter_05{icon = 'Market Design.dmi' ; icon_state = "Counter 05" ; density = 1}
				counter_06{icon = 'Market Design.dmi' ; icon_state = "Counter 06" ; density = 1}

		center_design
			floor
				floor_01{icon='Center Design.dmi' ; icon_state = "Tile 01" ; density = 0}
				floor_02{icon='Center Design.dmi' ; icon_state = "Tile 02" ; density = 0}
				floor_03{icon='Center Design.dmi' ; icon_state = "Tile 03" ; density = 0}
				floor_04{icon='Center Design.dmi' ; icon_state = "Tile 04" ; density = 0}
				floor_05{icon='Center Design.dmi' ; icon_state = "Tile 05" ; density = 0}
				floor_06{icon='Center Design.dmi' ; icon_state = "Tile 06" ; density = 0}
				floor_07{icon='Center Design.dmi' ; icon_state = "Tile 07" ; density = 0}
				floor_08{icon='Center Design.dmi' ; icon_state = "Tile 08" ; density = 0}
				floor_09{icon='Center Design.dmi' ; icon_state = "Tile 09" ; density = 0}
				floor_10{icon='Center Design.dmi' ; icon_state = "Tile 10" ; density = 0}
				floor_11{icon='Center Design.dmi' ; icon_state = "Tile 11" ; density = 0}
				floor_12{icon='Center Design.dmi' ; icon_state = "Tile 12" ; density = 0}
				pokefloor_01{icon='Center Design.dmi' ; icon_state = "PokeFloor 01" ; density = 0}
				pokefloor_02{icon='Center Design.dmi' ; icon_state = "PokeFloor 02" ; density = 0}
				pokefloor_03{icon='Center Design.dmi' ; icon_state = "PokeFloor 03" ; density = 0}
				pokefloor_04{icon='Center Design.dmi' ; icon_state = "PokeFloor 04" ; density = 0}
				pokefloor_05{icon='Center Design.dmi' ; icon_state = "PokeFloor 05" ; density = 0}
				pokefloor_06{icon='Center Design.dmi' ; icon_state = "PokeFloor 06" ; density = 0}
				pokefloor_07{icon='Center Design.dmi' ; icon_state = "PokeFloor 07" ; density = 0}
				pokefloor_08{icon='Center Design.dmi' ; icon_state = "PokeFloor 08" ; density = 0}
				pokefloor_09{icon='Center Design.dmi' ; icon_state = "PokeFloor 09" ; density = 0}
				pokefloor_10{icon='Center Design.dmi' ; icon_state = "PokeFloor 10" ; density = 0}
				pokefloor_11{icon='Center Design.dmi' ; icon_state = "PokeFloor 11" ; density = 0}
				pokefloor_12{icon='Center Design.dmi' ; icon_state = "PokeFloor 12" ; density = 0}
			wall
				wall_01{icon='Center Design.dmi' ; icon_state = "Wall 01" ; density = 1}
				wall_02{icon='Center Design.dmi' ; icon_state = "Wall 02" ; density = 1}
				wall_03{icon='Center Design.dmi' ; icon_state = "Wall 03" ; density = 1}
				wall_04{icon='Center Design.dmi' ; icon_state = "Wall 04" ; density = 1}
				wall_05{icon='Center Design.dmi' ; icon_state = "Wall 05" ; density = 1}
				wall_06{icon='Center Design.dmi' ; icon_state = "Wall 06" ; density = 1}
				wall_07{icon='Center Design.dmi' ; icon_state = "Wall 07" ; density = 1}
			door
				door_01{icon='Center Design.dmi' ; icon_state = "Door 01" ; density = 0}
				door_02{icon='Center Design.dmi' ; icon_state = "Door 02" ; density = 0}
				door_03{icon='Center Design.dmi' ; icon_state = "Door 03" ; density = 0}
			center_object
				object_01{icon='Center Design.dmi' ; icon_state = "Chair 01" ; density = 0}
				object_02{icon='Center Design.dmi' ; icon_state = "Chair 02" ; density = 0}
				object_03{icon='Center Design.dmi' ; icon_state = "Table 01" ; density = 1}
				object_04{icon='Center Design.dmi' ; icon_state = "Table 02" ; density = 1}
				object_05{icon='Center Design.dmi' ; icon_state = "Table 03" ; density = 1}
				object_06{icon='Center Design.dmi' ; icon_state = "Table 04" ; density = 1}
				object_07{icon='Center Design.dmi' ; icon_state = "Table 05" ; density = 1}
				object_08{icon='Center Design.dmi' ; icon_state = "Table 06" ; density = 1}
				machine_01{icon='Center Design.dmi' ; icon_state = "Machine 01" ; density = 1}
				machine_02{icon='Center Design.dmi' ; icon_state = "Machine 02" ; density = 1}
				PC_01{icon='Center Design.dmi' ; icon_state = "PC 01" ; density = 1}
				PC_02{icon='Center Design.dmi' ; icon_state = "PC 02" ; density = 1}
				Plant_01{icon='Center Design.dmi' ; icon_state = "Plant 01" ; density = 1}
				Plant_02{icon='Center Design.dmi' ; icon_state = "Plant 02" ; density = 1}
				Rug_01{icon='Center Design.dmi' ; icon_state = "Rug 01" ; density = 0}
				Rug_02{icon='Center Design.dmi' ; icon_state = "Rug 02" ; density = 0}
				Escalator_01{icon='Center Design.dmi' ; icon_state = "Escalator 01" ; density = 1}
				Escalator_02{icon='Center Design.dmi' ; icon_state = "Escalator 02" ; density = 1}
				Escalator_03{icon='Center Design.dmi' ; icon_state = "Escalator 03" ; density = 1}
				Escalator_04{icon='Center Design.dmi' ; icon_state = "Escalator 04" ; density = 1}
				Escalator_05{icon='Center Design.dmi' ; icon_state = "Escalator 05" ; density = 1}
			counter
				counter_01{icon='Center Design.dmi' ; icon_state = "Desk 01" ; density = 1}
				counter_02{icon='Center Design.dmi' ; icon_state = "Desk 02" ; density = 1}
				counter_03{icon='Center Design.dmi' ; icon_state = "Desk 03" ; density = 1}
				counter_04{icon='Center Design.dmi' ; icon_state = "Desk 04" ; density = 1}
				counter_05{icon='Center Design.dmi' ; icon_state = "Desk 05" ; density = 1}
				counter_06{icon='Center Design.dmi' ; icon_state = "Desk 06" ; density = 1}
				counter_07{icon='Center Design.dmi' ; icon_state = "Desk 07" ; density = 1}
				counter_08{icon='Center Design.dmi' ; icon_state = "Desk 08" ; density = 1}
				counter_09{icon='Center Design.dmi' ; icon_state = "Desk 09" ; density = 1}
				counter_10{icon='Center Design.dmi' ; icon_state = "Desk 10" ; density = 1}
				counter_11{icon='Center Design.dmi' ; icon_state = "Desk 11" ; density = 1}
				counter_12{icon='Center Design.dmi' ; icon_state = "Desk 12" ; density = 1}
				counter_13{icon='Center Design.dmi' ; icon_state = "PCenter 01" ; density = 1}
				counter_14{icon='Center Design.dmi' ; icon_state = "PCenter 02" ; density = 1}
				counter_15{icon='Center Design.dmi' ; icon_state = "PCenter 03" ; density = 1}

		object

			bed
				NW {icon_state = "Bed1"}
				NE {icon_state = "Bed2"}
				W {icon_state = "Bed3"}
				E {icon_state = "Bed4"}
				SW {icon_state = "Bed5"}
				SE {icon_state = "Bed6"}

			staircases
				LHS_Staircase_Down
					NW {icon_state = "LStairsDown1"}
					NE {icon_state = "LStairsDown2"}
					W {icon_state = "LStairsDown3"}
					E {icon_state = "LStairsDown4"}
					SW {icon_state = "LStairsDown5"}
					SE {icon_state = "LStairsDown6"}
				RHS_Staircase_Down
					NW {icon_state = "RStairsDown1"}
					NE {icon_state = "RStairsDown2"}
					W {icon_state = "RStairsDown3"}
					E {icon_state = "RStairsDown4"}
					SW {icon_state = "RStairsDown5"}
					SE {icon_state = "RStairsDown6"}

	outdoor
		lab {icon = 'Lab.dmi' ; density = 1}
		mainhousebottom {icon = 'House Design 01.dmi' ; density = 1}
		mainhousetop {icon = 'House Design 01.dmi' ; density = 0}
		pokecenter {icon = 'Pokemon Center.dmi' ; density = 0}
		pokemart {icon = 'Pokemon Mart.dmi' ; density = 0}
		pokenetcenter {icon = 'Pokémon Net Center.dmi' ; density = 1}
		seviidock {icon = 'Sevii Dock.dmi' ; density = 1}
		devoncorp {icon = 'Devon Corporation.dmi' ; density = 1}
		oceanicmuseum{icon = 'Oceanic Museum.dmi' ; density = 1}
		dock{icon = 'Dock.dmi' ; density = 1}
		contesthall{icon = 'Contest Hall.dmi' ; density = 1}
		pokemonfanclub{icon = 'Pokémon Fan Club.dmi' ; density = 1}
		lighttower{icon = 'Light Tower.dmi' ; density = 1}
		pokegym {icon = 'Pokemon Gym.dmi' ; density = 1}
		gamecorner {icon = 'Game Corner.dmi' ; density = 0}
		house{icon = 'Houses.dmi' ; density = 1}
		housebottom {icon = 'House Design 02.dmi' ; density = 1}
		housetop {icon = 'House Design 02.dmi' ; density = 0}
		objects {icon = 'Outdoor Object.dmi' ; density = 1}
		water {icon = 'Water Path.dmi' ; density = 1}
		waterfall{icon = 'Waterfall.dmi' ; density = 1}
		terrain {icon = 'Outdoor Design.dmi' ; density = 0}
		spawn_grass{icon = 'Outdoor Design.dmi' ; density = 0}
		patch{icon = 'Outdoor Design.dmi'; density = 0}
		flower{icon = 'Outdoor Design.dmi'; density = 0}
		plant{icon = 'Outdoor Object.dmi'; density = 1}
		tree {density = 1}
		road {icon = 'Outdoor Design.dmi' ; density = 0}
		rock{parent_type=/obj;icon = 'Outdoor Object.dmi' ; density = 1}
		ocean{icon = 'Outdoor Design.dmi' ; density = 0}
		pond{icon = 'Outdoor Design.dmi' ; density = 0}
		mountain_stuff{icon = 'Mountain Icon.dmi';density = 1}
		mountain_stair{icon = 'Mountain Icon.dmi';density = 0}
		mountain_enterance{icon = 'Mountain Icon.dmi'}
		stairs{icon = 'b3.dmi';density = 0}
		fences{icon = 'Outdoor Object.dmi';density = 1}
		forest_ENT{icon = 'Forest Entrance.dmi';density = 0}
		forest_OVL{icon = 'Forest Entrance.dmi';density = 0}
		events{icon = 'Event OBJ.dmi';density = 1}

		events
			icon_state = "Event Area"

		berry_stuff
			parent_type = /obj
			icon = 'Berry Design.dmi'
			icon_state = "Soil"
			density = 1
			New()
				..()
				berry_trees += src
				Load()
			Del()
				berry_trees -= src
				Save()
				..()
			Cross(atom/movable/O)
				return 0
			var
				stage = STAGE_NOTHING
				count = 2
				berry_type = ""
				the_berry
				berry_phase_time = 4
				players_berry[] = list()
			proc
				Save()
					src.icon = initial(src.icon)
					src.icon_state = initial(src.icon_state)
					for(var/x in players_berry)
						players_berry[x] -= "berry_sprite"
					var savefile/F = new
					src.Write(F)
					fdel("World Objects/Berries/Tree At [x] [y] [z].esav")
					text2file(RC5_Encrypt(F.ExportText("/"),md5("berries")),"World Objects/Berries/Tree At [x] [y] [z].esav")
				Load()
					if(!fexists("World Objects/Berries/Tree At [x] [y] [z].esav"))return
					var savefile/F = new
					F.ImportText("/",RC5_Decrypt(file2text("World Objects/Berries/Tree At [x] [y] [z].esav"),md5("berries")))
					src.Read(F)
					for(var/x in players_berry)
						var image/I = image(src.icon,src,src.icon_state)
						I.override = src
						players_berry[x]["berry_sprite"] = I
						berry_update(x,players_berry[x]["berry_stage"])
				initalize_for_player(keytext) // Set to the defaults per player
					var image/I = image(src.icon,src,src.icon_state)
					I.override = src
					if(!istype(players_berry,/list))
						players_berry = list()
					players_berry["[ckeyEx(keytext)]"] = list()
					players_berry["[ckeyEx(keytext)]"]["berry_stage"] = stage
					players_berry["[ckeyEx(keytext)]"]["berry_count"] = count
					players_berry["[ckeyEx(keytext)]"]["berry_type"] = berry_type
					players_berry["[ckeyEx(keytext)]"]["the_berry"] = the_berry
					players_berry["[ckeyEx(keytext)]"]["berry_phase_time"] = berry_phase_time
					players_berry["[ckeyEx(keytext)]"]["berry_sprite"] = I
					players_berry["[ckeyEx(keytext)]"]["watered_this_stage"] = FALSE
					players_berry["[ckeyEx(keytext)]"]["mulch_type"] = "None"
				berry_update(playerkey,starting_state)
					set waitfor = 0
					var image/I = players_berry["[ckeyEx(playerkey)]"]["berry_sprite"]
					switch(starting_state)
						if(STAGE_NOTHING)
							I.icon = 'Berry Design.dmi'
							I.icon_state = "Soil"
							return
						if(STAGE_PLANTED)
							start_growth(playerkey,I)
							wait_for_sprout(playerkey,I)
							wait_for_growing(playerkey,I)
							wait_for_blooming(playerkey,I)
							wait_for_finished(playerkey,I)
						if(STAGE_SPROUTED)
							wait_for_sprout(playerkey,I,FALSE)
							wait_for_growing(playerkey,I)
							wait_for_blooming(playerkey,I)
							wait_for_finished(playerkey,I)
						if(STAGE_GROWING)
							wait_for_growing(playerkey,I,FALSE)
							wait_for_blooming(playerkey,I)
							wait_for_finished(playerkey,I)
						if(STAGE_BLOOMING)
							wait_for_blooming(playerkey,I,FALSE)
							wait_for_finished(playerkey,I)
						if(STAGE_DONE)
							wait_for_finished(playerkey,I,FALSE)
				start_growth(playerkey,image/I)
					players_berry["[ckeyEx(playerkey)]"]["berry_stage"] = STAGE_PLANTED
					players_berry["[ckeyEx(playerkey)]"]["watered_this_stage"] = FALSE
					I.icon = 'Berry Design.dmi'
					I.icon_state = "Seed"
				wait_for_sprout(playerkey,image/I,do_sleep=TRUE)
					if(do_sleep)
						sleep players_berry["[ckeyEx(playerkey)]"]["berry_phase_time"]*(MINUTE*15)
					players_berry["[ckeyEx(playerkey)]"]["berry_stage"] = STAGE_SPROUTED
					players_berry["[ckeyEx(playerkey)]"]["watered_this_stage"] = FALSE
					I.icon_state = "Sprout"
				wait_for_growing(playerkey,image/I,do_sleep=TRUE)
					if(do_sleep)
						sleep players_berry["[ckeyEx(playerkey)]"]["berry_phase_time"]*(MINUTE*15)
					players_berry["[ckeyEx(playerkey)]"]["berry_stage"] = STAGE_GROWING
					players_berry["[ckeyEx(playerkey)]"]["watered_this_stage"] = FALSE
					I.icon = 'Berries Growing.dmi'
					I.icon_state = "[berry_type]"
				wait_for_blooming(playerkey,image/I,do_sleep=TRUE)
					if(do_sleep)
						sleep players_berry["[ckeyEx(playerkey)]"]["berry_phase_time"]*(MINUTE*15)
					players_berry["[ckeyEx(playerkey)]"]["berry_stage"] = STAGE_BLOOMING
					players_berry["[ckeyEx(playerkey)]"]["watered_this_stage"] = FALSE
					I.icon = 'Berries Blooming.dmi'
					I.icon_state = "[berry_type]"
				wait_for_finished(playerkey,image/I,do_sleep=TRUE)
					if(do_sleep)
						sleep players_berry["[ckeyEx(playerkey)]"]["berry_phase_time"]*(MINUTE*15)
					players_berry["[ckeyEx(playerkey)]"]["berry_stage"] = STAGE_DONE
					players_berry["[ckeyEx(playerkey)]"]["watered_this_stage"] = FALSE
					I.icon = 'Berries Grown.dmi'
					I.icon_state = "[berry_type]"
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					var berryType = players_berry["[ckeyEx(P.key)]"]["berry_type"]
					switch(src.players_berry["[ckeyEx(P.key)]"]["berry_stage"])
						if(STAGE_NOTHING)
							P.ShowText("It's soft, loamy soil!")
							if(players_berry["[ckeyEx(P.key)]"]["mulch_type"]=="None")
								var mulch_list[0]
								if(P.bag.hasItem(/item/normal/mulch/Amaze_Mulch))mulch_list["Amaze Mulch"] = /item/normal/mulch/Amaze_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Boost_Mulch))mulch_list["Boost Mulch"] = /item/normal/mulch/Boost_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Damp_Mulch))mulch_list["Damp Mulch"] = /item/normal/mulch/Damp_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Gooey_Mulch))mulch_list["Gooey Mulch"] = /item/normal/mulch/Gooey_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Growth_Mulch))mulch_list["Growth Mulch"] = /item/normal/mulch/Growth_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Rich_Mulch))mulch_list["Rich Mulch"] = /item/normal/mulch/Rich_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Stable_Mulch))mulch_list["Stable Mulch"] = /item/normal/mulch/Stable_Mulch
								if(P.bag.hasItem(/item/normal/mulch/Surprise_Mulch))mulch_list["Surprise Mulch"] = /item/normal/mulch/Surprise_Mulch
								if(mulch_list.len)
									P.ShowText("Fertalize the soil with some Mulch?")
									if(alert(P,"Fertalize the soil with some Mulch?","Fertalize the soil?","Yes!","No...")=="Yes!")
										var which_mulch = input(P,"Which mulch will you use?","Which mulch?") as null|anything in mulch_list
										if(isnull(which_mulch))
											P.ShowText("You didn't plant any mulch.")
											return
										else
											P.bag.getItem(mulch_list[which_mulch])
											P.ShowText("You have planted the [which_mulch].")
											players_berry["[ckeyEx(P.key)]"]["mulch_type"] = which_mulch
							else
								P.ShowText("The [players_berry["[ckeyEx(P.key)]"]["mulch_type"]] is spread across the loamy soil.")
							if(length(P.bag.berries))
								if(alert(P,"Would you like to plant a berry?","Plant a Berry!","Yes","No")=="Yes")
									var item/berry/choice = input(P,"Which Berry?","Pick a Berry") as null|anything in P.bag.berries
									if(isnull(choice))return
									choice = P.bag.getItem(choice)
									if(isnull(choice)){src << "There was a glitch with the berry.";return}
									players_berry["[ckeyEx(P.key)]"]["berry_type"] = "[choice.tree_type]"
									players_berry["[ckeyEx(P.key)]"]["the_berry"] = choice.type
									players_berry["[ckeyEx(P.key)]"]["berry_phase_time"] = list()
									players_berry["[ckeyEx(P.key)]"]["berry_phase_time"] = choice.stage_time/4
									players_berry["[ckeyEx(P.key)]"]["berry_count"] = rand(choice.berry_min,choice.berry_max)
									switch(players_berry["[ckeyEx(P.key)]"]["mulch_type"])
										if("Damp Mulch")
											players_berry["[ckeyEx(P.key)]"]["berry_phase_time"] *= 1.5
										if("Growth Mulch")
											players_berry["[ckeyEx(P.key)]"]["berry_phase_time"] *= 0.75
										if("Boost Mulch")
											players_berry["[ckeyEx(P.key)]"]["berry_phase_time"] *= 0.85
										if("Rich Mulch")
											players_berry["[ckeyEx(P.key)]"]["berry_count"] += 2
										if("Amaze Mulch")
											players_berry["[ckeyEx(P.key)]"]["berry_phase_time"] *= 0.75
											players_berry["[ckeyEx(P.key)]"]["berry_count"] += 2
									P.client.Audio.addSound(sound('sound_berries.wav',channel=13),"Berry Sound",TRUE)
									berry_update("[ckeyEx(P.key)]",STAGE_PLANTED)
									P.ShowText("You planted the [choice] in the soft, loamy soil!")
						if(STAGE_PLANTED)
							P.ShowText("The [berryType] Berry is planted!")
							if(P.bag.hasItem(/item/key/watering_can))
								if(alert(P,"Water these berries?","Water the Berries","Yes!","No...")=="Yes!")
									P.ShowText("[P] waters the berries!")
									if(!players_berry["[ckeyEx(P.key)]"]["watered_this_stage"])
										++players_berry["[ckeyEx(P.key)]"]["berry_count"]
										players_berry["[ckeyEx(P.key)]"]["watered_this_stage"] = TRUE
						if(STAGE_SPROUTED)
							P.ShowText("The [berryType] Tree has sprouted!")
							if(P.bag.hasItem(/item/key/watering_can))
								if(alert(P,"Water these berries?","Water the Berries","Yes!","No...")=="Yes!")
									P.ShowText("[P] waters the berries!")
									if(!players_berry["[ckeyEx(P.key)]"]["watered_this_stage"])
										++players_berry["[ckeyEx(P.key)]"]["berry_count"]
										players_berry["[ckeyEx(P.key)]"]["watered_this_stage"] = TRUE
						if(STAGE_GROWING)
							P.ShowText("The [berryType] Tree is growing!")
							if(P.bag.hasItem(/item/key/watering_can))
								if(alert(P,"Water these berries?","Water the Berries","Yes!","No...")=="Yes!")
									P.ShowText("[P] waters the berries!")
									if(!players_berry["[ckeyEx(P.key)]"]["watered_this_stage"])
										++players_berry["[ckeyEx(P.key)]"]["berry_count"]
										players_berry["[ckeyEx(P.key)]"]["watered_this_stage"] = TRUE
						if(STAGE_BLOOMING)
							P.ShowText("The [berryType] Tree is starting to bloom!")
							if(P.bag.hasItem(/item/key/watering_can))
								if(alert(P,"Water these berries?","Water the Berries","Yes!","No...")=="Yes!")
									P.ShowText("[P] waters the berries!")
									if(!players_berry["[ckeyEx(P.key)]"]["watered_this_stage"])
										++players_berry["[ckeyEx(P.key)]"]["berry_count"]
										players_berry["[ckeyEx(P.key)]"]["watered_this_stage"] = TRUE
						if(STAGE_DONE)
							var
								is_or_are
								berry_plural
								berryCount = players_berry["[ckeyEx(P.key)]"]["berry_count"]
							if(berryCount>1)
								is_or_are = "are"
								berry_plural = "Berries"
							else
								is_or_are = "is"
								berry_plural = "Berry"
							P.ShowText("There [is_or_are] [berryCount] [berryType] [berry_plural] on this [berryType] Tree!")
							if(alert(P,"Would you like to pick the [berryType] [berry_plural]?","Pick The Berry","Yes","No")=="Yes")
								P.client.Audio.addSound(sound('sound_berries.wav',channel=13),"Berry Sound",TRUE)
								src.players_berry["[ckeyEx(P.key)]"]["berry_stage"] = STAGE_NOTHING
								src.players_berry["[ckeyEx(P.key)]"]["watered_this_stage"] = FALSE
								var image/I = players_berry["[ckeyEx(P.key)]"]["berry_sprite"]
								I.icon = 'Berry Design.dmi'
								I.icon_state = "Soil"
								P.bag.addItem(players_berry["[ckeyEx(P.key)]"]["the_berry"],count)
								src.players_berry["[ckeyEx(P.key)]"]["mulch_type"] = "None"
								P.ShowText("The soil returned to its soft and loamy state.")

		rock
			rock_01
				parent_type = /turf
				density = 1
				icon = 'Outdoor Object.dmi'
				icon_state = "Rock 01"
			rock_02
				parent_type = /turf
				density = 1
				icon = 'Outdoor Object.dmi'
				icon_state = "Rock 02"
			boulder_top
				parent_type = /turf
				density = 0
				icon = 'Outdoor Object.dmi'
				icon_state = "Boulder Top"
			boulder_bottom
				parent_type = /turf
				density = 1
				icon = 'Outdoor Object.dmi'
				icon_state = "Boulder Bottom"
			meteorite
				icon_state = "Meteorite"
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						P.ShowText("It's a meteorite from outer space.")
						for(var/i in 1 to 6)
							var pokemon/PK = P.party[i]
							if(isnull(PK))break
							else if(!istype(PK,/pokemon))continue
							if(PK.pName=="Deoxys")
								PK.formChange()
								P.ShowText("[PK.name] has changed its form!")
			moss_rock
				icon_state = "Moss Rock"
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						P.ShowText("This rock is covered in slimy moss. It's disgusting to touch it.")
			ice_rock
				icon_state = "Ice Rock"
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						P.ShowText("This rock is covered in ice. It'll freeze you if you touch it.")
			magnet_rock
				icon_state = "Magnet Rock"
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						P.ShowText("This rock is covered in steel. It'll make your hair stand up if you touch it.")
			alolan_rock
				icon_state = "Alolan Rock"
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						P.ShowText("This rock is radiating tropical energy around it that affects nearby Pokémon. Touching it makes you feel warm.")

		road
			city
				icon = 'Paths Design.dmi'
				city
					SW {icon_state = "City 01"}
					S  {icon_state = "City 02"}
					SE {icon_state = "City 03"}
					W  {icon_state = "City 04"}
					E  {icon_state = "City 06"}
					NE {icon_state = "City 09"}
					N  {icon_state = "City 08"}
					NW {icon_state = "City 07"}
					Center {icon_state = "City 05"}
					SWcon {icon_state = "City 10"}
					SEcon {icon_state = "City 11"}
					NWcon {icon_state = "City 12"}
					NEcon {icon_state = "City 13"}
				city_01
					SW {icon_state = "City1 01"}
					S  {icon_state = "City1 02"}
					SE {icon_state = "City1 03"}
					W  {icon_state = "City1 04"}
					E  {icon_state = "City1 06"}
					NE {icon_state = "City1 09"}
					N  {icon_state = "City1 08"}
					NW {icon_state = "City1 07"}
					Center {icon_state = "City1 05"}
					SWcon {icon_state = "City1 10"}
					SEcon {icon_state = "City1 11"}
					NWcon {icon_state = "City1 12"}
					NEcon {icon_state = "City1 13"}
				city_02
					SW {icon_state = "City2 01"}
					S  {icon_state = "City2 02"}
					SE {icon_state = "City2 03"}
					W  {icon_state = "City2 04"}
					E  {icon_state = "City2 06"}
					NE {icon_state = "City2 09"}
					N  {icon_state = "City2 08"}
					NW {icon_state = "City2 07"}
					Center {icon_state = "City2 05"}
					SWcon {icon_state = "City2 10"}
					SEcon {icon_state = "City2 11"}
					NWcon {icon_state = "City2 12"}
					NEcon {icon_state = "City2 13"}
				city_03
					SW {icon_state = "City3 01"}
					S  {icon_state = "City3 02"}
					SE {icon_state = "City3 03"}
					W  {icon_state = "City3 04"}
					E  {icon_state = "City3 06"}
					NE {icon_state = "City3 09"}
					N  {icon_state = "City3 08"}
					NW {icon_state = "City3 07"}
					Center {icon_state = "City3 05"}
					SWcon {icon_state = "City3 10"}
					SEcon {icon_state = "City3 11"}
					NWcon {icon_state = "City3 12"}
					NEcon {icon_state = "City3 13"}
				city_04
					SW {icon_state = "City4 01"}
					S  {icon_state = "City4 02"}
					SE {icon_state = "City4 03"}
					W  {icon_state = "City4 04"}
					E  {icon_state = "City4 06"}
					NE {icon_state = "City4 09"}
					N  {icon_state = "City4 08"}
					NW {icon_state = "City4 07"}
					Center {icon_state = "City4 05"}
					SWcon {icon_state = "City4 10"}
					SEcon {icon_state = "City4 11"}
					NWcon {icon_state = "City4 12"}
					NEcon {icon_state = "City4 13"}
				city_05
					SW {icon_state = "City5 01"}
					S  {icon_state = "City5 02"}
					SE {icon_state = "City5 03"}
					W  {icon_state = "City5 04"}
					E  {icon_state = "City5 06"}
					NE {icon_state = "City5 09"}
					N  {icon_state = "City5 08"}
					NW {icon_state = "City5 07"}
					Center {icon_state = "City5 05"}
					SWcon {icon_state = "City5 10"}
					SEcon {icon_state = "City5 11"}
					NWcon {icon_state = "City5 12"}
					NEcon {icon_state = "City5 13"}
				city_06
					SW {icon_state = "City6 01"}
					S  {icon_state = "City6 02"}
					SE {icon_state = "City6 03"}
					W  {icon_state = "City6 04"}
					E  {icon_state = "City6 06"}
					NE {icon_state = "City6 09"}
					N  {icon_state = "City6 08"}
					NW {icon_state = "City6 07"}
					Center {icon_state = "City6 05"}
					SWcon {icon_state = "City6 10"}
					SEcon {icon_state = "City6 11"}
					NWcon {icon_state = "City6 12"}
					NEcon {icon_state = "City6 13"}
				city_07
					SW {icon_state = "City7 01"}
					S  {icon_state = "City7 02"}
					SE {icon_state = "City7 03"}
					W  {icon_state = "City7 04"}
					E  {icon_state = "City7 06"}
					NE {icon_state = "City7 09"}
					N  {icon_state = "City7 08"}
					NW {icon_state = "City7 07"}
					Center {icon_state = "City7 05"}
					SWcon {icon_state = "City7 10"}
					SEcon {icon_state = "City7 11"}
					NWcon {icon_state = "City7 12"}
					NEcon {icon_state = "City7 13"}
				city_08
					SW {icon_state = "City8 01"}
					S  {icon_state = "City8 02"}
					SE {icon_state = "City8 03"}
					W  {icon_state = "City8 04"}
					E  {icon_state = "City8 06"}
					NE {icon_state = "City8 09"}
					N  {icon_state = "City8 08"}
					NW {icon_state = "City8 07"}
					Center {icon_state = "City8 05"}
					SWcon {icon_state = "City8 10"}
					SEcon {icon_state = "City8 11"}
					NWcon {icon_state = "City8 12"}
					NEcon {icon_state = "City8 13"}
				city_09
					SW {icon_state = "City9 01"}
					S  {icon_state = "City9 02"}
					SE {icon_state = "City9 03"}
					W  {icon_state = "City9 04"}
					E  {icon_state = "City9 06"}
					NE {icon_state = "City9 09"}
					N  {icon_state = "City9 08"}
					NW {icon_state = "City9 07"}
					Center {icon_state = "City9 05"}
					SWcon {icon_state = "City9 10"}
					SEcon {icon_state = "City9 11"}
					NWcon {icon_state = "City9 12"}
					NEcon {icon_state = "City9 13"}
				city_10
					SW {icon_state = "City10 01"}
					S  {icon_state = "City10 02"}
					SE {icon_state = "City10 03"}
					W  {icon_state = "City10 04"}
					E  {icon_state = "City10 06"}
					NE {icon_state = "City10 09"}
					N  {icon_state = "City10 08"}
					NW {icon_state = "City10 07"}
					Center {icon_state = "City10 05"}
					SWcon {icon_state = "City10 10"}
					SEcon {icon_state = "City10 11"}
					NWcon {icon_state = "City10 12"}
					NEcon {icon_state = "City10 13"}
				city_11
					SW {icon_state = "City11 01"}
					S  {icon_state = "City11 02"}
					SE {icon_state = "City11 03"}
					W  {icon_state = "City11 04"}
					E  {icon_state = "City11 06"}
					NE {icon_state = "City11 09"}
					N  {icon_state = "City11 08"}
					NW {icon_state = "City11 07"}
					Center {icon_state = "City11 05"}
					SWcon {icon_state = "City11 10"}
					SEcon {icon_state = "City11 11"}
					NWcon {icon_state = "City11 12"}
					NEcon {icon_state = "City11 13"}
				city_12
					SW {icon_state = "City12 01"}
					S  {icon_state = "City12 02"}
					SE {icon_state = "City12 03"}
					W  {icon_state = "City12 04"}
					E  {icon_state = "City12 06"}
					NE {icon_state = "City12 09"}
					N  {icon_state = "City12 08"}
					NW {icon_state = "City12 07"}
					Center {icon_state = "City12 05"}
					SWcon {icon_state = "City12 10"}
					SEcon {icon_state = "City12 11"}
					NWcon {icon_state = "City12 12"}
					NEcon {icon_state = "City12 13"}
			SW {icon_state = "Road 01"}
			S  {icon_state = "Road 02"}
			SE {icon_state = "Road 03"}
			W  {icon_state = "Road 04"}
			E  {icon_state = "Road 06"}
			NE {icon_state = "Road 09"}
			N  {icon_state = "Road 08"}
			NW {icon_state = "Road 07"}
			Center {icon_state = "Road 05"}
			SWcon {icon_state = "Road 10"}
			SEcon {icon_state = "Road 11"}
			NWcon {icon_state = "Road 12"}
			NEcon {icon_state = "Road 13"}
			grassy
				SW {icon_state = "Grass Road 01"}
				S  {icon_state = "Grass Road 02"}
				SE {icon_state = "Grass Road 03"}
				W  {icon_state = "Grass Road 04"}
				E  {icon_state = "Grass Road 06"}
				NE {icon_state = "Grass Road 09"}
				N  {icon_state = "Grass Road 08"}
				NW {icon_state = "Grass Road 07"}
				Center {icon_state = "Grass Road 05"}
				SWcon {icon_state = "Grass Road 10"}
				SEcon {icon_state = "Grass Road 11"}
				NWcon {icon_state = "Grass Road 12"}
				NEcon {icon_state = "Grass Road 13"}

		plant
			PottedPlant {icon_state = "Plant 01"}
			BushPlant {icon_state = "Plant 02"}
			BushPlant2 {icon_state = "Plant 03"}

		terrain
			terrain{icon_state = "Terrain"}
		ledge
			parent_type = /obj
			icon = 'Outdoor Object.dmi'
			ledge_south
				rout = SOUTH
				rin = SOUTH
				ledge_left{icon_state = "Ledge 09"}
				ledge_middle{icon_state = "Ledge 10"}
				ledge_right{icon_state = "Ledge 11"}
			ledge_north
				rout = NORTH
				rin = NORTH
				ledge_left
					icon_state = "Ledge 12"
				ledge_middle
					icon_state = "Ledge 13"
				ledge_right
					icon_state = "Ledge 14"
			ledge_east
				rout = EAST
				rin = EAST
				ledge_left
					icon_state = "Ledge 18"
				ledge_middle
					icon_state = "Ledge 19"
				ledge_right
					icon_state = "Ledge 20"
			ledge_west
				rout = WEST
				rin = WEST
				ledge_left
					icon_state = "Ledge 15"
				ledge_middle
					icon_state = "Ledge 16"
				ledge_right
					icon_state = "Ledge 17"
			ledge_northeast
				rout = NORTH | EAST
				rin = NORTH | EAST
				icon_state = "Ledge 06"
			ledge_northwest
				rout = NORTH | WEST
				rin = NORTH | WEST
				icon_state = "Ledge 05"
			ledge_southeast
				rout = SOUTH | EAST
				rin = SOUTH | WEST
				icon_state = "Ledge 08"
			ledge_southwest
				rout = SOUTH | WEST
				rin = SOUTH | WEST
				icon_state = "Ledge 07"
			ledge_northeast_con
				rin = NORTH | EAST
				rout = NORTH | EAST
				icon_state = "Ledge 01"
			ledge_northwest_con
				rin = NORTH | EAST
				rout = NORTH | WEST
				icon_state = "Ledge 02"
			ledge_southwest_con
				rin = SOUTH | WEST
				rout = SOUTH | WEST
				icon_state = "Ledge 03"
			ledge_southeast_con
				rin = SOUTH | EAST
				rout = SOUTH | EAST
				icon_state = "Ledge 04"
			Crossed(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!("Ledge Jump" in P.client.Audio.sounds))
						P.client.Audio.addSound(sound('jump_ledge.wav'),"Ledge Jump")
					P.client.Audio.playSound("Ledge Jump")

		objects
			lamps
				lamp_01
					top{icon_state = "Lamp 01-T"}
					bottom{icon_state = "Lamp 01-B";density=1}
				lamp_02
					top{icon_state = "Lamp 02-T"}
					bottom{icon_state = "Lamp 02-B";density=1}
				lamp_03
					top{icon_state = "Lamp 03-T"}
					bottom{icon_state = "Lamp 03-B";density=1}
				lamp_04
					top{icon_state = "Lamp 04-T"}
					bottom{icon_state = "Lamp 04-B";density=1}
			mailbox
				density = 1
				parent_type = /obj
				var owner = "" as text
				icon = 'Outdoor Object.dmi'
				mailbox_01{icon_state="Mailbox Orange"}
				mailbox_02{icon_state="Mailbox Yellow"}
				mailbox_03{icon_state="Mailbox Blue"}
				mailbox_04{icon_state="Mailbox Gray"}
				mailbox_05{icon_state="Mailbox Red"}
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						if(P.client)
							switch(owner)
								if("player's")
									P.ShowText("[P.name]'s Mailbox.")
								if("rival's")
									if(P.gender=="male")
										P.ShowText("May's Mailbox.")
									else
										P.ShowText("Brendan's Mailbox.")
								else
									P.ShowText("[owner]'s Mailbox.")
			sign
				density = 1
				icon = 'Outdoor Object.dmi'
				parent_type = /obj
				var message = "" as text
				sign_01{icon_state="Sign 01"}
				sign_02{icon_state="Sign 02"}
				sign_03{icon_state="Sign 03"}
				mode_sign
					icon_state="Sign 04"
					var
						tmp
							image
								rubyImage
								sapphireImage
								emeraldImage
					New()
						signList += src
						rubyImage = image('Outdoor Object.dmi',src,"Sign 04")
						sapphireImage = image('Outdoor Object.dmi',src,"Sign 05")
						emeraldImage = image('Outdoor Object.dmi',src,"Sign 06")
						rubyImage.override = 1
						sapphireImage.override = 1
						emeraldImage.override = 1
				sign_04{icon_state = "Scoreboard"}
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						if(P.client)
							if(message)
								P.ShowText("[message]")
							else
								var whichPlayer = (P.gender==MALE)?("May"):("Brendan")
								P.ShowText("The message '[whichPlayer] woz ere' appears to be spray-painted on this sign... It can't be read!")
			bench_01{icon_state="Bench 01"}
			bench_02{icon_state="Bench 02"}
			market_stuff
				tin_01{icon_state = "Gray Tin"}
				tin_02{icon_state = "Gold Tin"}
				box_01{icon_state = "Box Stack"}
				box_02{icon_state = "Little Box"}
				box_03{icon_state = "Cardboard Stack"}
				box_04{icon_state = "Little Cardboard"}
				bowl_01{icon_state = "Big Orange Bowl"}
				bowl_02{icon_state = "Orange Bowl"}
				bowl_03{icon_state = "Green Bowl"}
				scoreboard{icon_state = "Scoreboard"}
				balloon_pile{icon_state = "Baloon Pile"}
				medicine_board{icon_state = "Medicine Board"}
				flower_basker{icon_state = "Flower Basket"}

		stairs
			HorizontalStairs1
				icon_state="3"
			HorizontalStairs2
				icon_state="4"
			VerticalStairs1
				icon_state="1"
			VerticalStairs2
				icon_state="2"

		pokecenter
			pkmncenter{icon_state="Center"}

		pokemart
			pkmnmart{icon_state="Shop"}

		pokegym
			pkmngym{icon_state="Gym"}

		devoncorp
			devoncorp{icon_state="Devon Corp"}

		mainhousebottom
			mainhouseb_01{icon_state="House 1 (1)"}
			mainhouseb_02{icon_state="House 2 (1)"}

		mainhousetop
			mainhouset_01{icon_state="House 1 (2)"}
			mainhouset_02{icon_state="House 2 (2)"}

		house
			slateport{icon_state = "Slateport"}

		housebottom
			houseb_01{icon_state="House 1 (1)"}
			houseb_02{icon_state="House 2 (1)"}

		housetop
			houset_01{icon_state="House 1 (2)"}
			houset_02{icon_state="House 2 (2)"}

		lab
			Lab_01{icon_state="Lab (1)"}
			Lab_02{icon_state="Lab (2)"}

		patch
			patch_01{icon_state="Patch 01"}
			patch_02{icon_state="Patch 02"}
			patch_03{icon_state="Patch 03"}
			patch_04{icon_state="Patch 04"}

		flower
			flower_01{icon_state = "Flower 01"}
			flower_02{icon_state = "Flower 02"}
			flower_03{icon_state = "Flower 03"}
			flower_04{icon_state = "Flower 04"}
			flower_05{icon_state = "Flower 05"}
			flower_06{icon_state = "Flower 06"}
			flower_07{icon_state = "Flower 07"}
			flower_08{icon_state = "Flower 08"}
			flower_bunch{icon_state = "Flower Bunch"}

waterInteract
	parent_type = /atom/movable
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P =  O
			P.ShowText("The water is dyed a deep-blue color.")
turf
	outdoor
		ocean
			New(atom/movable/O)
				. = ..()
				if(!istype(src,/turf/outdoor/ocean/Center))
					new /waterInteract(src)
			Ocean
				icon_state = "Ocean"
				density = 1
				Entered(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						if(P.playerFlags & IS_LOADING)return
						if(prob(5))
							var
								levelChoose
								mon
								pokemon/tmon
								thePokemonList[0]
							switch(P.route)
								if(PAL_PARK_SEA)
									if(length(transferHolder["[ckeyEx(P.key)]"]))
										for(var/pokemon/PKMN in transferHolder["[ckeyEx(P.key)]"])
											if(PKMN.pName in palParkLocations["Sea"])
												thePokemonList += PKMN
										if(thePokemonList.len)
											tmon = pick(thePokemonList)
							if(mon)
								if(P.repelsteps > 0)
									for(var/pokemon/PK in P.party)
										if(PK.status != FAINTED)
											if(PK.level > levelChoose)
												return
								var pokemon/S = get_pokemon(mon,P)
								S.level = levelChoose
								S.stat_calculate()
								S.HP = S.maxHP
								var battleSystem/X = new(list(P),FALSE,S,area_type=POND)
								P.client.battle = X // To be safe
							else if(tmon)
								var battleSystem/X = new(list(P),FALSE,tmon,importBattle=TRUE)
								P.client.battle = X
			Center{icon_state = "Sand 01"}//sand Beginning
			NW{icon_state = "Sand 02"}
			N{icon_state ="Sand 03"}
			NE{icon_state = "Sand 04"}
			W{icon_state = "Sand 05"}
			E{icon_state = "Sand 06"}
			SW{icon_state = "Sand 07"}
			S{icon_state = "Sand 08"}
			SE{icon_state = "Sand 09"}
			NWCorner{icon_state = "Sand 10"}
			NECorner{icon_state = "Sand 11"}
			SWCorner{icon_state = "Sand 12"}
			SECorner{icon_state = "Sand 13"}//sand End

		pond
			Center{icon_state = "Pond 01"}
			NW{icon_state = "Pond 02"}
			N{icon_state ="Pond 03"}
			NE{icon_state = "Pond 04"}
			W{icon_state = "Pond 05"}
			E{icon_state = "Pond 06"}
			SW{icon_state = "Pond 07"}
			S{icon_state = "Pond 08"}
			SE{icon_state = "Pond 09"}
			NWCorner{icon_state = "Pond 10"}
			NECorner{icon_state = "Pond 11"}
			SWCorner{icon_state = "Pond 12"}
			SECorner{icon_state = "Pond 13"}


		beachgrass
			icon = 'Outdoor Design.dmi'
			beachgrass01{icon_state = "Beachgrass 01"}
			beachgrass02{icon_state = "Beachgrass 02"}
			beachgrass03{icon_state = "Beachgrass 03"}
			beachgrass04{icon_state = "Beachgrass 04"}
			beachgrass05{icon_state = "Beachgrass 05"}
			beachgrass06{icon_state = "Beachgrass 06"}
			beachgrass07{icon_state = "Beachgrass 07"}
			beachgrass08{icon_state = "Beachgrass 08"}
			beachgrass09{icon_state = "Beachgrass 09"}
			beachgrass10{icon_state = "Beachgrass 10"}
			beachgrass11{icon_state = "Beachgrass 11"}
			beachgrass12{icon_state = "Beachgrass 12"}

		seviihouse
			icon = 'Sevii House.dmi'
			density = 1

		bridges
			icon = 'Outdoor Object.dmi'
			bridge_01{icon_state = "Bridge1 01";rout = EAST|NORTH|SOUTH}
			bridge_02{icon_state = "Bridge1 02";rout = EAST|NORTH|SOUTH}
			bridge_03{icon_state = "Bridge1 03";rout = EAST|NORTH|SOUTH}
			bridge_04{icon_state = "Bridge1 04"}
			bridge_05{icon_state = "Bridge1 05"}
			bridge_06{icon_state = "Bridge1 06"}
			bridge_07{icon_state = "Bridge1 07";rout = WEST|NORTH|SOUTH}
			bridge_08{icon_state = "Bridge1 08";rout = WEST|NORTH|SOUTH}
			bridge_09{icon_state = "Bridge1 09";rout = WEST|NORTH|SOUTH}

		water_object
			density = 1
			icon = 'Water Path.dmi'
			rock{icon_state = "Damp Rock"}
			boulder
				boulder_01{icon_state = "Boulder 01"}
				boulder_02{icon_state = "Boulder 02"}
				boulder_03{icon_state = "Boulder 03"}
				boulder_04{icon_state = "Boulder 04"}

		fences
			fence1
				S {icon_state = "Fence1 02"}
				W {icon_state = "Fence1 04"}
				E {icon_state = "Fence1 05"}
				N {icon_state = "Fence1 07"}
				NE{icon_state = "Fence1 06"}
				NW{icon_state = "Fence1 08"}
				SE{icon_state = "Fence1 03"}
				SW{icon_state = "Fence1 01"}
			fence2
				S {icon_state = "Fence2 02"}
				W {icon_state = "Fence2 04"}
				E {icon_state = "Fence2 05"}
				N {icon_state = "Fence2 07"}
				NE{icon_state = "Fence2 06"}
				NW{icon_state = "Fence2 08"}
				SE{icon_state = "Fence2 03"}
				SW{icon_state = "Fence2 01"}

		forest_ENT
			S {icon_state = "Forest";dir=SOUTH}
			N {icon_state = "Forest";dir=NORTH}
			E {icon_state = "Forest";dir=EAST}
			W {icon_state = "Forest";dir=WEST}

		forest_OVL
			S {icon_state = "Forest Overlay";dir=SOUTH}
			N {icon_state = "Forest Overlay";dir=NORTH}
			E {icon_state = "Forest Overlay";dir=EAST}
			W {icon_state = "Forest Overlay";dir=WEST}

		water
			New(atom/movable/O)
				. = ..()
				new /waterInteract(src)
			NW{icon_state = "River 01"}
			N{icon_state = "River 02"}
			NE{icon_state = "River 03"}
			SW{icon_state = "River 04"}
			S{icon_state = "River 05"}
			SE{icon_state = "River 06"}
			W{icon_state = "River 07"}
			Center
				icon_state = "River 08"
				Entered(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						if(P.playerFlags & IS_LOADING)return
						if(prob(5))
							var
								levelChoose
								mon
								pokemon/tmon
								thePokemonList[0]
							switch(P.route)
								if(PAL_PARK_POND)
									if(length(transferHolder["[ckeyEx(P.key)]"]))
										for(var/pokemon/PKMN in transferHolder["[ckeyEx(P.key)]"])
											if(PKMN.pName in palParkLocations["Pond"])
												thePokemonList += PKMN
										if(thePokemonList.len)
											tmon = pick(thePokemonList)
								if(ROUTE_102)
									switch(P.mode)
										if("Ruby","Sapphire")
											mon = pick(prob(1);"Surskit",prob(99);"Marill")
										if("Emerald")
											mon = pick(prob(1);"Goldeen",prob(99);"Marill")
									switch(mon)
										if("Surskit","Marill")
											levelChoose = rand(20,30)
										if("Marill")
											levelChoose = rand(5,35)
								if(ROUTE_103)
									mon = pick("Dialga","Palkia","Giratina","Giratina-O","Regirock","Regice","Registeel","Groudon","Kyogre","Rayquaza")
									levelChoose = rand(2,4)
							if(mon)
								if(P.repelsteps > 0)
									for(var/pokemon/PK in P.party)
										if(PK.status != FAINTED)
											if(PK.level > levelChoose)
												return
								var pokemon/S = get_pokemon(mon,P)
								S.level = levelChoose
								S.stat_calculate()
								S.HP = S.maxHP
								var battleSystem/X = new(list(P),FALSE,S,area_type=POND)
								P.client.battle = X // To be safe
							else if(tmon)
								var battleSystem/X = new(list(P),FALSE,tmon,importBattle=TRUE)
								P.client.battle = X

			E{icon_state = "River 09"}
			NEcon{icon_state = "River 10"}
			NWcon{icon_state = "River 11"}
			SWcon{icon_state = "River 12"}
			SEcon{icon_state = "River 13"}

		tree
			default_version
				icon = 'Tree-1 Design.dmi'
				layer = FLY_LAYER

				summer_version
					icon_state = "Summer"
				winter_version/icon_state = "Winter"
				stump/icon_state = "Stump"

			special_version
				New(loc)
					. = ..()
					trees_list.Add(src)
				layer = FLY_LAYER
				icon = 'Tree-2.dmi'
				summer_tree
					icon_state = "Summer"
				winter_tree
					icon_state = "Winter"
				autumn_tree
					icon_state = "Autumn"
				spring_tree
					icon_state = "Spring"

		flower_spawns
			icon = 'Outdoor Design.dmi'
			icon_state = "Flower Bunch"
			Entered(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.playerFlags & IS_LOADING)return
					if(prob(5))
						var mon
						var levelChoose
						switch(P.route)
							if(ROUTE_102)
								mon = "Flabébé"
								levelChoose = rand(2,4)
							if(ROUTE_104)
								mon = pick(prob(90);"Flabébé",prob(10);"Combee")
								switch(mon)
									if("Flabébé")
										levelChoose = rand(5,8)
									if("Combee")
										levelChoose = 6
						if(mon)
							if(P.repelsteps > 0)
								for(var/pokemon/PK in P.party)
									if(PK.status != FAINTED)
										if(PK.level > levelChoose)
											return
							var pokemon/S = get_pokemon(mon,P,level=levelChoose)
							S.stat_calculate()
							S.HP = S.maxHP
							var battleSystem/X = new(list(P),FALSE,S)
							P.client.battle = X // To be safe

		spawn_grass
			var canSpawn = TRUE
			poison_grass
				SW {icon_state = "Poison Grass 01";canSpawn=FALSE}
				S  {icon_state = "Poison Grass 02";canSpawn=FALSE}
				SE {icon_state = "Poison Grass 03";canSpawn=FALSE}
				W  {icon_state = "Poison Grass 04"}
				E  {icon_state = "Poison Grass 05"}
				NE {icon_state = "Poison Grass 08"}
				N  {icon_state = "Poison Grass 07"}
				NW {icon_state = "Poison Grass 06"}
				Center
					icon_state = "Poison Grass 09"
				Entered(atom/movable/O)
					if(!canSpawn)return
					if(istype(O,/player))
						var player/P = O
						if(P.playerFlags & IS_LOADING)return
						if(prob(5))
							var levelChoose
							var mon
							switch(P.route)
								if(PETALBURG_WOODS)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(60);"Stunky",prob(30);"Skorupi",prob(10);"Trubbish")
										if("Sapphire")
											mon = pick(prob(30);"Stunky",prob(10);"Skorupi",prob(60);"Trubbish")
										if("Emerald")
											mon = pick(prob(10);"Stunky",prob(60);"Skorupi",prob(30);"Trubbish")
									levelChoose = rand(5,7)
							if(mon)
								if(P.repelsteps > 0)
									for(var/pokemon/PK in P.party)
										if(PK.status != FAINTED)
											if(PK.level > levelChoose)
												return
								var pokemon/S = get_pokemon(mon,P,level=levelChoose)
								S.stat_calculate()
								S.HP = S.maxHP
								var battleSystem/X = new(list(P),FALSE,S)
								P.client.battle = X // To be safe

			tall_grass
				Entered(atom/movable/O)
					if(!canSpawn)return
					if(istype(O,/player))
						var player/P = O
						if(P.playerFlags & IS_LOADING)return
						if(prob(5))
							var
								levelChoose
								mon
								pokemon/tmon
								formID
								theArea = GRASSY
								thePokemonList[0]
							switch(P.route)
								if(PAL_PARK_FIELD)
									if(length(transferHolder["[ckeyEx(P.key)]"]))
										for(var/pokemon/PKMN in transferHolder["[ckeyEx(P.key)]"])
											if(PKMN.pName in palParkLocations["Field"])
												thePokemonList += PKMN
										if(thePokemonList.len)
											tmon = pick(thePokemonList)
								if(PAL_PARK_FOREST)
									if(length(transferHolder["[ckeyEx(P.key)]"]))
										for(var/pokemon/PKMN in transferHolder["[ckeyEx(P.key)]"])
											if(PKMN.pName in palParkLocations["Forest"])
												thePokemonList += PKMN
										if(thePokemonList.len)
											tmon = pick(thePokemonList)
								if(PAL_PARK_MOUNTAIN)
									if(length(transferHolder["[ckeyEx(P.key)]"]))
										for(var/pokemon/PKMN in transferHolder["[ckeyEx(P.key)]"])
											if(PKMN.pName in palParkLocations["Mountain"])
												thePokemonList += PKMN
										if(thePokemonList.len)
											tmon = pick(thePokemonList)
								if(ROUTE_101)
									switch(P.mode)
										if("Ruby","Sapphire")
											mon = pick(prob(25);"Zigzagoon",prob(20);"Meowth",prob(10);"Poochyena",prob(25);"Wurmple",prob(20);"Budew")
										if("Emerald")
											mon = pick(prob(10);"Zigzagoon",prob(20);"Meowth",prob(25);"Poochyena",prob(45);"Wurmple",prob(20);"Budew")
									levelChoose = pick(prob(60);2,prob(30);3)
								if(ROUTE_102)
									switch(P.mode)
										if("Ruby") // For Ruby Mode
											mon = pick(prob(15);"Poochyena",prob(30);"Zigzagoon",prob(30);"Wurmple",prob(20);"Seedot",prob(4);"Ralts",prob(1);"Surskit")
										if("Sapphire")
											mon = pick(prob(15);"Poochyena",prob(30);"Zigzagoon",prob(20);"Lotad",prob(4);"Ralts",prob(1);"Surskit")
										if("Emerald")
											mon = pick(prob(30);"Poochyena",prob(15);"Zigzagoon",prob(30);"Wurmple",prob(20);"Lotad",prob(4);"Ralts",prob(1);"Seedct")
									switch(mon)
										if("Poochyena","Wurmple","Zigzagoon","Lotad","Seedot")
											levelChoose = pick(3,4)
										if("Ralts")
											levelChoose = 4
										if("Surskit")
											levelChoose = 3
								if(ROUTE_103)
									switch(P.mode)
										if("Ruby","Sapphire")
											mon = pick(prob(45);"Zigzagoon",prob(15);"Shinx",prob(15);"Litleo",prob(15);"Poochyena",prob(10);"Wingull")
										if("Emerald")
											mon = pick(prob(15);"Zigzagoon",prob(15);"Shinx",prob(15);"Litleo",prob(45);"Poochyena",prob(10);"Wingull")
									levelChoose = pick(prob(60);2,prob(30);3,prob(10);4)
								if(ROUTE_104)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(30);"Zigzagoon",prob(25);"Wurmple",prob(20);"Rufflet",prob(10);"Taillow",prob(10);"Wingull",prob(5);"Riolu")
										if("Sapphire")
											mon = pick(prob(30);"Zigzagoon",prob(25);"Wurmple",prob(20);"Vullaby",prob(10);"Taillow",prob(10);"Wingull",prob(5);"Riolu")
										if("Emerald")
											mon = pick(prob(20);"Marill",prob(40);"Poochyena",prob(20);"Wurmple",prob(10);"Taillow",prob(10);"Wingull")
									switch(mon)
										if("Marill","Poochyena","Zigzagoon","Taillow","Vullaby","Rufflet","Riolu")
											levelChoose = pick(4,5)
										if("Wurmple")
											switch(P.mode)
												if("Ruby","Sapphire")
													levelChoose = pick(4,5)
												if("Emerald")
													levelChoose = 4
										if("Wingull")
											levelChoose = rand(3,5)
								if(PETALBURG_WOODS)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(15);"Wurmple",prob(15);"Scatterbug",prob(15);"Weedle",prob(10);"Spewpa",prob(10);"Zigzagoon",
											prob(10);"Silcoon",prob(10);"Cascoon",prob(5);"Taillow",prob(15);"Shroomish",prob(5);"Slakoth")
										if("Sapphire")
											mon = pick(prob(15);"Wurmple",prob(15);"Scatterbug",prob(15);"Caterpie",prob(10);"Zigzagoon",prob(10);"Spewpa",
											prob(10);"Silcoon",prob(10);"Cascoon",prob(5);"Taillow",prob(15);"Shroomish",prob(5);"Slakoth")
										if("Emerald")
											mon = pick(prob(25);"Poochyena",prob(15);"Wurmple",prob(15);"Scatterbug",prob(10);"Spewpa",prob(10);"Silcoon",prob(10);"Cascoon",prob(5);"Taillow",prob(15);"Shroomish",prob(5);"Slakoth")
									switch(mon)
										if("Zigzagoon","Poochyena","Wurmple","Taillow","Shroomish","Slakoth","Scatterbug","Weedle","Caterpie")
											levelChoose = pick(5,6)
										if("Silcoon","Cascoon","Spewpa")
											levelChoose = 8
									theArea = FOREST
								if(ROUTE_110)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(38);"Electrike",prob(10);"Zigzagoon",prob(10);"Gulpin",prob(10);"Oddish",prob(10);"Wingull",
											prob(14);"Minun",prob(4);"Voltorb",prob(2);"Shellos",prob(2);"Phantump")
										if("Sapphire")
											mon = pick(prob(38);"Electrike",prob(10);"Zigzagoon",prob(10);"Gulpin",prob(10);"Oddish",prob(10);"Wingull",
											prob(14);"Plusle",prob(4);"Voltorb",prob(2);"Shellos",prob(2);"Pumpkaboo")
										if("Emerald")
											mon = pick(prob(10);"Oddish",prob(20);"Poochyena",prob(8);"Wingull",prob(24);"Electrike",prob(2);"Plusle",
											prob(13);"Minun",prob(2);"Gulpin",prob(2);"Shellos",prob(2);"Pumpkaboo",prob(2);"Phantump")
									switch(mon)
										if("Electrike","Pumkaboo","Phantump")
											levelChoose = rand(10,13)
										if("Zigzagoon","Shellos","Oddish","Gulpin","Wingull","Voltorb")
											levelChoose = 13
											formID = 0x00
										if("Plusle","Minun")
											levelChoose = rand(11,13)
										if("Poochyena","Zigzagoon")
											levelChoose = 12
								if(ROUTE_112)
									switch(P.mode)
										if("Ruby","Sapphire")
											mon = pick(prob(15);"Machop",prob(75);"Numel",prob(10);"Rockruff")
										if("Emerald")
											mon = pick(prob(15);"Marill",prob(75);"Numel",prob(10);"Rockruff")
									levelChoose = rand(14,16)
								if(ROUTE_113)
									switch(P.mode)
										if("Ruby","Sapphire")
											mon = pick(prob(25);"Sandshrew",prob(5);"Skarmory",prob(70);"Spinda")
										if("Emerald")
											mon = pick(prob(25);"Sandshrew",prob(5);"Skarmory",prob(70);"Spinda")
									switch(mon)
										if("Sandshrew","Slugma","Spinda")
											levelChoose = rand(14,16)
										if("Skarmory")
											levelChoose = 16
								if(ROUTE_114)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(30);"Seedot",prob(10);"Nuzleaf",prob(1);"Surskit",prob(40);"Swablu",prob(19);"Zangoose")
										if("Sapphire")
											mon = pick(prob(30);"Lotad",prob(10);"Lombre",prob(1);"Surskit",prob(40);"Swablu",prob(19);"Seviper")
										if("Emerald")
											mon = pick(prob(30);"Lotad",prob(20);"Lombre",prob(1);"Nuzleaf",prob(40);"Swablu",prob(9);"Seviper")
									switch(mon)
										if("Lotad","Seedot")
											levelChoose = pick(15,16)
										if("Lombre")
											levelChoose = pick(16,18)
										if("Nuzleaf")
											if(P.mode == "Ruby")
												levelChoose = pick(16,18)
											else
												levelChoose = 15
										if("Surskit")
											levelChoose = 15
										if("Zangoose","Seviper")
											levelChoose = rand(15,17)
								if(ROUTE_115_SOUTH)
									mon = pick(prob(10);"Jigglypuff",prob(36);"Taillow",prob(10);"Wingull",prob(38);"Swablu",prob(2);"Pidove",
									prob(2);"Clefairy",prob(2);"Misdreavus")
									switch(mon)
										if("Jigglypuff")levelChoose = pick(8,10)
										if("Taillow","Swablu")levelChoose = rand(7,10)
										if("Wingull","Misdreavus","Pidove","Clefairy")levelChoose = 10
								if(ROUTE_115_NORTH)
									mon = pick(prob(10);"Jigglypuff",prob(36);"Taillow",prob(10);"Wingull",prob(38);"Swablu",prob(2);"Pidove",
									prob(2);"Clefairy",prob(2);"Misdreavus")
									switch(mon)
										if("Jigglypuff")levelChoose = pick(18,20)
										if("Taillow","Swablu")levelChoose = rand(17,20)
										if("Wingull")levelChoose = 20
								if(ROUTE_116)
									switch(P.mode)
										if("Ruby","Sapphire")
											mon = pick(prob(20);"Zigzagoon",prob(20);"Taillow",prob(20);"Nincada",prob(30);"Whismur",
											prob(2);"Skitty",prob(2);"Eevee",prob(2);"Joltik",prob(2);"Pidove",prob(2);"Fletchling")
										if("Emerald")
											mon = pick(prob(10);"Abra",prob(20);"Poochyena",prob(20);"Taillow",prob(20);"Nincada",
											prob(20);"Whismur",prob(2);"Skitty",prob(2);"Eevee",prob(2);"Joltik",prob(2);"Pidove",
											prob(2);"Fletchling")
									switch(mon)
										if("Abra")
											levelChoose = 7
										if("Zigzagoon")
											levelChoose = rand(6,8)
										if("Taillow","Nincada","Poochyena")
											levelChoose = pick(6,8)
										if("Whismur")
											levelChoose = rand(5,7)
										if("Pidove","Eevee","Joltik","Fletchling")
											levelChoose = 8
								if(ROUTE_117)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(10);"Oddish",prob(10);"Marill",prob(30);"Zigzagoon",prob(1);"Surskit",prob(1);"Volbeat",
											prob(18);"Illumise",prob(30);"Roselia")
										if("Sapphire")
											mon = pick(prob(10);"Oddish",prob(10);"Marill",prob(30);"Zigzagoon",prob(1);"Surskit",prob(1);"Illumise",
											prob(18);"Volbeat",prob(30);"Roselia")
										if("Emerald")
											mon = pick(prob(40);"Oddish",prob(10);"Marill",prob(30);"Poochyena",prob(1);"Seedot",prob(1);"Volbeat",
											prob(18);"Illumise")
									switch(mon)
										if("Oddish")
											levelChoose = (P.mode in list("Ruby","Sapphire"))?(13):(pick(13,14))
										if("Marill","Seedot","Surskit","Roselia")
											levelChoose = 13
										if("Poocyena","Zigzagoon")
											levelChoose = pick(13,14)
										if("Volbeat")
											levelChoose = (P.mode in list("Ruby","Emerald"))?(13):(pick(13,14))
										if("Illumise")
											levelChoose = (P.mode=="Sapphire")?(13):(pick(13,14))
								if(JAGGED_PASS)
									mon = pick(prob(25);"Machop",prob(55);"Numel",prob(20);"Spoink")
									switch(P.mode)
										if("Ruby")
											levelChoose = rand(18,20)
										if("Sapphire","Emerald")
											levelChoose = rand(20,22)
								if(TREASURE_BEACH) // As Treasure Beach is a Sevii Islands Location, FireRed/LeafGreen locations are used and Emerald uses LeafGreen Spawn Lists.
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(26);"Spearow",prob(30);"Tangela",prob(20);"Fearow",prob(10);"Meowth",prob(5);"Persian",prob(5);"Psyduck",
											prob(2);"Shellos",prob(2);"Gastrodon")
										if("Sapphire","Emerald")
											mon = pick(prob(26);"Spearow",prob(30);"Tangela",prob(20);"Fearow",prob(10);"Meowth",prob(5);"Persian",prob(5);"Slowpoke",
											prob(2);"Shellos",prob(2);"Gastrodon")
									switch(mon)
										if("Spearow")
											levelChoose = pick(31,32)
										if("Tangela","Shellos")
											levelChoose = pick(33,35)
											formID = 0x08
										if("Fearow","Gastrodon")
											levelChoose = pick(36,38,40)
										if("Persian")
											levelChoose = pick(37,40)
										if("Meowth","Slowpoke","Psyduck")
											levelChoose = 31
											formID = 0x08
								if(KINDLE_ROAD)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(30);"Ponyta",prob(25);"Spearow",prob(10);"Fearow",prob(10);"Meowth",prob(10);"Geodude",prob(5);"Persian",
											prob(5);"Psyduck",prob(5);"Rapidash")
										if("Sapphire","Emerald")
											mon = pick(prob(30);"Ponyta",prob(25);"Spearow",prob(10);"Fearow",prob(10);"Meowth",prob(10);"Geodude",prob(5);"Persian",
											prob(5);"Slowpoke",prob(5);"Rapidash")
									switch(mon)
										if("Ponyta")
											levelChoose = pick(31,34)
										if("Spearow")
											levelChoose = pick(30,32)
										if("Fearow")
											levelChoose = 36
										if("Meowth","Geodude")
											levelChoose = 31
										if("Persian","Rapidash")
											levelChoose = pick(37,40)
										if("Psyduck","Slowpoke")
											levelChoose = 34
								if(CAPE_BRINK)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(18);"Oddish",prob(20);"Spearow",prob(15);"Gloom",prob(10);"Fearow",prob(10);"Meowth",prob(10);"Paras",
											prob(5);"Persian",prob(5);"Psyduck",prob(5);"Golduck",prob(2);"Shellos")
										if("Sapphire","Emerald")
											mon = pick(prob(28);"Bellsprout",prob(20);"Spearow",prob(15);"Weepinbell",prob(10);"Fearow",prob(10);"Meowth",
											prob(10);"Paras",prob(5);"Persian",prob(5);"Slowpoke",prob(5);"Slowbro",prob(2);"Shellos")
									switch(mon)
										if("Oddish","Bellsprout")
											levelChoose = pick(15,17)
										if("Spearow","Meowth","Psyduck","Slowpoke","Shellos")
											levelChoose = 16
											formID = 0x08
										if("Gloom","Weepinbell")
											levelChoose = pick(21,23)
										if("Fearow")
											levelChoose = 21
										if("Golduck","Slowbro")
											levelChoose = pick(22,25)
									if(P.bag.hasItem(/item/tm/hm/HM03))
										levelChoose += 15 // If the HM for Surf is in the bag, increase levels back to normal
								if(BOND_BRIDGE)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(30);"Pidgey",prob(20);"Oddish",prob(15);"Pidgeotto",prob(10);"Gloom",prob(10);"Meowth",prob(5);"Venonat",
											prob(5);"Persian",prob(5);"Psyduck")
										if("Sapphire","Emerald")
											mon = pick(prob(30);"Pidgey",prob(20);"Bellsprout",prob(15);"Pidgeotto",prob(10);"Weepinbell",prob(10);"Meowth",
											prob(5);"Venonat",prob(5);"Persian",prob(5);"Slowpoke")
									switch(mon)
										if("Pidgey")
											levelChoose = pick(14,17)
										if("Oddish","Bellsprout")
											levelChoose = 16
										if("Pidgeotto")
											levelChoose = pick(19,22,25)
										if("Gloom","Weepinbell")
											levelChoose = 21
									if(P.bag.hasItem(/item/tm/hm/HM03))
										levelChoose += 15 // If the HM for Surf is in the bag, increase levels back to normal
								if(THREE_ISLE_PORT)
									mon = "Dunsparce"
									levelChoose = pick(10,15,20,25,30,35)
								if(BERRY_FOREST)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(20);"Pidgeotto",prob(20);"Gloom",prob(10);"Pidgey",prob(10);"Oddish",prob(10);"Venonat",prob(10);"Drowzee",
											prob(5);"Venomoth",prob(5);"Psyduck",prob(5);"Hypno",prob(5);"Exeggcute")
										if("Sapphire","Emerald")
											mon = pick(prob(20);"Pidgeotto",prob(20);"Weepinbell",prob(10);"Pidgey",prob(10);"Bellsprout",prob(10);"Venonat",
											prob(10);"Drowzee",prob(5);"Venomoth",prob(5);"Slowpoke",prob(5);"Hypno",prob(5);"Exeggcute")
									switch(mon)
										if("Pidgeotto")
											levelChoose = 22
										if("Gloom","Weepinbell","Exeggcute")
											levelChoose = 20
										if("Pidgey")
											levelChoose = 17
										if("Oddish","Bellsprout")
											levelChoose = 15
										if("Venonat","Drowzee")
											levelChoose = 19
										if("Venomoth","Hypno")
											levelChoose = pick(22,25)
										if("Psyduck","Slowpoke")
											levelChoose = 16
							if(mon)
								if(P.repelsteps > 0)
									for(var/pokemon/PK in P.party)
										if(PK.status != FAINTED)
											if(PK.level > levelChoose)
												return
								var pokemon/S = get_pokemon(mon,P,level=levelChoose,formID=formID)
								S.stat_calculate()
								S.HP = S.maxHP
								var battleSystem/X = new(list(P),FALSE,S,area_type=theArea)
								P.client.battle = X // To be safe
							else if(tmon)
								var battleSystem/X = new(list(P),FALSE,tmon,importBattle=TRUE)
								P.client.battle = X
				SW {icon_state = "Grass 01";canSpawn=FALSE}
				S  {icon_state = "Grass 02";canSpawn=FALSE}
				SE {icon_state = "Grass 03";canSpawn=FALSE}
				W  {icon_state = "Grass 04"}
				E  {icon_state = "Grass 05"}
				NE {icon_state = "Grass 08"}
				N  {icon_state = "Grass 07"}
				NW {icon_state = "Grass 06"}
				Center {icon_state = "Grass 09"}
				Lone_Puff {icon_state = "Grass 10"}
				Vertical_North {icon_state = "Grass 11"}
				Vertical_Center {icon_state = "Grass 12"}
				Vertical_South {icon_state = "Grass 13"}
				Horizontal_West {icon_state = "Grass 14"}
				Horizontal_Center {icon_state = "Grass 15"}
				Horizontal_East {icon_state = "Grass 16"}
				Ash_Grass
					Entered(atom/movable/O)
						if(istype(O,/player))
							var player/P = O
							var item/key/Soot_Sack/sootBag = P.bag.getItem(/item/key/Soot_Sack)
							if(sootBag)++sootBag.totalSoot
						..()
					SW {icon_state = "Ash Grass 01";canSpawn=FALSE}
					S  {icon_state = "Ash Grass 02";canSpawn=FALSE}
					SE {icon_state = "Ash Grass 03";canSpawn=FALSE}
					W  {icon_state = "Ash Grass 04"}
					E  {icon_state = "Ash Grass 05"}
					NE {icon_state = "Ash Grass 08"}
					N  {icon_state = "Ash Grass 07"}
					NW {icon_state = "Ash Grass 06"}
					Center {icon_state = "Ash Grass 09"}
		mountain_stuff
			mountain_ladder
				icon = 'Mount Design.dmi'
				density = 0
				var target_tag
				ladder_down
					ladder_01{icon_state = "Cave Down"}
				ladder_up
					ladder_01{icon_state = "Cave Up"}
				Entered(atom/movable/O)
					if(O.just_teleported == TRUE)return ..()
					var turf/T = locate("[src.target_tag]")
					if(!isnull(T))
						O.just_teleported = TRUE
						spawn(TICK_LAG) O.just_teleported = FALSE
						O.Move(T)
			mountain_spawn
				icon_state = "Mount 05"
				density = 0
				Entered(atom/movable/O)
					. = ..()
					if(istype(O,/player))
						var player/P = O
						if(P.playerFlags & IS_LOADING)return
						if(prob(5))
							var mon
							var levelChoose
							switch(P.route)
								if(GRANITE_CAVE_1F)
									mon = pick(prob(35);"Zubat",prob(15);"Abra",prob(5);"Geodude",prob(37);"Makuhita",prob(2);"Onix",prob(2);"Timburr",prob(2);"Axew",
									prob(2);"Larvitar")
									switch(mon)
										if("Onix","Tumburr","Axew")
											levelChoose = 12
										if("Zubat","Makuhita","Larvitar")
											levelChoose = rand(9,12)
										if("Abra","Geodude")
											levelChoose = pick(10,12)
								if(GRANITE_CAVE_B1F)
									mon = pick(prob(25);"Zubat",prob(20);"Abra",prob(20);"Makuhita",prob(27);"Aron",prob(2);"Onix",prob(2);"Timburr",prob(2);"Axew",
									prob(2);"Larvitar")
									switch(mon)
										if("Onix","Timburr","Axew")
											levelChoose = 12
										if("Zubat","Aron","Larvitar")
											levelChoose = rand(10,12)
										if("Abra","Makuhita")
											levelChoose = pick(10,12)
								if(GRANITE_CAVE_B2F)
									switch(P.mode)
										if("Ruby")
											mon = pick(prob(25);"Zubat",prob(20);"Abra",prob(20);"Mawile",prob(27);"Aron",prob(2);"Onix",prob(2);"Timburr",
											prob(2);"Axew",prob(2);"Larvitar")
										if("Sapphire","Emerald")
											mon = pick(prob(25);"Zubat",prob(20);"Abra",prob(20);"Sableye",prob(27);"Aron",prob(2);"Onix",
											prob(2);"Timburr",prob(2);"Axew",prob(2);"Larvitar")
									switch(mon)
										if("Zubat","Abra","Mawile","Sableye")
											levelChoose = pick(10,12)
										if("Aron","Larvitar")
											levelChoose = rand(10,12)
										if("Onix","Timburr","Axew")
											levelChoose = 12
								if(GRANITE_CAVE_BACK_ROOM)
									mon = pick(prob(28);"Zubat",prob(10);"Abra",prob(50);"Makuhita",prob(10);"Aron",prob(2);"Larvitar")
									switch(mon)
										if("Zubat","Aron")
											levelChoose = pick(7,8)
										if("Makuhita","Larvitar")
											levelChoose = rand(6,10)
										if("Abra")
											levelChoose = 8
								if(RUSTURF_TUNNEL)
									mon = "Whismur"
									levelChoose = rand(5,8)
								if(FIREY_PATH)
									switch(P.mode)
										if("Ruby","Emerald")
											mon = pick(prob(15);"Machop",prob(2);"Grimer",prob(25);"Koffing",prob(10);"Slugma",prob(30);"Numel",
											prob(18);"Torkoal")
										if("Sapphire")
											mon = pick(prob(15);"Machop",prob(25);"Grimer",prob(2);"Koffing",prob(10);"Slugma",prob(30);"Numel",
											prob(18);"Torkoal")
									levelChoose = rand(14,18)
							if(mon)
								if(P.repelsteps > 0)
									for(var/pokemon/PK in P.party)
										if(PK.status != FAINTED)
											if(PK.level > levelChoose)
												return
								var pokemon/S = get_pokemon(mon,P,level=levelChoose)
								S.stat_calculate()
								S.HP = S.maxHP
								var battleSystem/X = new(list(P),FALSE,S,area_type=CAVE)
								P.client.battle = X // To be safe
			mount
				mount_01{icon_state = "Mount 01"}
				mount_02{icon_state = "Mount 02"}
				mount_03{icon_state = "Mount 03"}
				mount_04{icon_state = "Mount 04"}
				mount_05{icon_state = "Mount 05";density=0}
				mount_06{icon_state = "Mount 06"}
				mount_07{icon_state = "Mount 07"}
				mount_08{icon_state = "Mount 08"}
				mount_09{icon_state = "Mount 09"}
				mount_10{icon_state = "Mount 10"}
				mount_11{icon_state = "Mount 11"}
				mount_12{icon_state = "Mount 12"}
				mount_13{icon_state = "Mount 13"}
				mount_14{icon_state = "Mount 14"}
				mount_15{icon_state = "Mount 15"}
				mount_16{icon_state = "Mount 16"}
			mountT
				mount_01{icon_state = "MountT 01"}
				mount_02{icon_state = "MountT 02"}
				mount_03{icon_state = "MountT 03"}
				mount_04{icon_state = "MountT 04"}
				mount_05{icon_state = "MountT 05"}
				mount_06{icon_state = "MountT 06"}
				mount_07{icon_state = "MountT 07"}
				mount_08{icon_state = "MountT 08"}
				mount_09{icon_state = "MountT 09"}
				mount_10{icon_state = "MountT 10"}
				mount_11{icon_state = "MountT 11"}
				mount_12{icon_state = "MountT 12"}
			mountT2
				mount_01{icon_state = "MountT2 01"}
				mount_02{icon_state = "MountT2 02"}
				mount_03{icon_state = "MountT2 03"}
				mount_04{icon_state = "MountT2 04"}
				mount_05{icon_state = "MountT2 05"}
				mount_06{icon_state = "MountT2 06"}
				mount_07{icon_state = "MountT2 07"}
				mount_08{icon_state = "MountT2 08"}
				mount_09{icon_state = "MountT2 09"}
				mount_10{icon_state = "MountT2 10"}
				mount_11{icon_state = "MountT2 11"}
				mount_12{icon_state = "MountT2 12"}
				mount_13{icon_state = "MountT2 13"}
				mount_14{icon_state = "MountT2 14"}
			mountV
				mount_01{icon_state = "V1"}
				mount_02{icon_state = "V2"}
				mount_03{icon_state = "V3"}
				mount_04{icon_state = "V4"}
				mount_05{icon_state = "V5"}
				mount_06{icon_state = "V6"}
				mount_07{icon_state = "V7"}
				mount_08{icon_state = "V8"}
				mount_09{icon_state = "V9"}
				mount_10{icon_state = "V10";density=0}
				mount_11{icon_state = "V11"}
				mount_12{icon_state = "V12"}
				mount_13{icon_state = "V13"}
				mount_14{icon_state = "V14"}
				mount_15{icon_state = "V15"}
				mount_16{icon_state = "V16"}
				mount_18{icon_state = "V18"}
				mount_19{icon_state = "V19"}
				mount_20{icon_state = "V20"}
				mount_21{icon_state = "V21"}
				mount_22{icon_state = "V22"}
				mount_23{icon_state = "V23"}
			mount_ice
				Entered(atom/movable/O,atom/oldloc)
					..()
					if(istype(O,/player))
						var player/P = O
						P.client.clientFlags |= LOCK_MOVEMENT
					step(O,O.dir)
				Exited(atom/movable/O,atom/newloc)
					..()
					if(!istype(newloc,/turf/outdoor/mountain_stuff/mount_ice))
						if(istype(O,/player))
							var player/P = O
							P.client.clientFlags &= ~LOCK_MOVEMENT
				ice_q1{icon_state = "q1"}
				ice_q2{icon_state = "q2"}
				ice_q3{icon_state = "q3"}
				ice_q4{icon_state = "q4"}
				ice_q5{icon_state = "q5"}
				ice_q6{icon_state = "q6"}
				ice_q7{icon_state = "q7"}
				ice_q8{icon_state = "q8"}
				ice_q9{icon_state = "q9"}
		mountain_stair
			stair1
				icon_state = "Stair1"
				left{icon_state = "Stair1 L"}
				middle{icon_state = "Stair1 M"}
				right{icon_state = "Stair1 R"}
			stair2
				icon_state = "Stair2"
				left{icon_state = "Stair2 L"}
				middle{icon_state = "Stair2 M"}
				right{icon_state = "Stair2 R"}
			stair3
				icon_state = "Stair3"
				left{icon_state = "Stair3 L"}
				middle{icon_state = "Stair3 M"}
				right{icon_state = "Stair3 R"}
			vstair
				stair1
					icon_state = "VStair1"
					left{icon_state = "VStair1 L"}
					middle{icon_state = "VStair1 M"}
					right{icon_state = "VStair1 R"}
				stair2
					icon_state = "VStair2"
					left{icon_state = "VStair2 L"}
					middle{icon_state = "VStair2 M"}
					right{icon_state = "VStair2 R"}
				stair3
					icon_state = "VStair3"
					left{icon_state = "VStair3 L"}
					middle{icon_state = "VStair3 M"}
					right{icon_state = "VStair3 R"}
		mountain_enterance
			door_open
				icon_state = "Entrance"
				density = 0
				var
					target_tag
					escape_location = FALSE
					escape_direction = SOUTH
				Entered(atom/movable/O)
					if(O.just_teleported == TRUE)return ..()
					var turf/T = locate("[src.target_tag]")
					if(!isnull(T))
						O.just_teleported = TRUE
						spawn(TICK_LAG) O.just_teleported = FALSE
						O.Move(T)
						if(istype(O,/player))
							var player/P = O
							if(src.escape_location)
								P.escape_loc = src.tag
								P.escape_dir = src.escape_direction
							P.client.Audio.addSound(sound('enter.wav',channel=15),"ENTER PLACE",TRUE)
					. = ..()
			door_close
				density = 1
				icon_state = "Closed"
		waterfall
			waterfall_top
				icon_state = "top"
			waterfall_middle
				icon_state = "middle"
			waterfall_bottom
				icon_state = "bottom"
	indoor
		tiles
			wall
				wall_01{icon_state = "Wall 01"}
				wall_02{icon_state = "Wall 02"}
				wall_03{icon_state = "Wall 03"}
				wall_04{icon_state = "Wall 04"}
				wall_05{icon_state = "Wall 05"}
				wall_06{icon_state = "Wall 06"}
				wall_07{icon_state = "Wall 07"}
				wall_08{icon_state = "Wall 08"}
				wall_09{icon_state = "Wall 09"}
				wall_10{icon_state = "Wall 10"}
				wall_11{icon_state = "Wall 11"}
				wall_12{icon_state = "Wall 12"}
				wall_13{icon_state = "Wall 13"}
				wall_14{icon_state = "Wall 14"}
				wall_15{icon_state = "Wall 15"}
				wall_16{icon_state = "Wall 16"}
				wall_17{icon_state = "Wall 17"}
				wall_18{icon_state = "Wall 18"}
			floor
				floor_01{icon_state = "Floor 01"}
				floor_02{icon_state = "Floor 02"}
				floor_03{icon_state = "Floor 03"}
				floor_04{icon_state = "Floor 04"}
				floor_05{icon_state = "Floor 05"}
				floor_06{icon_state = "Floor 06"}
				floor_07{icon_state = "Floor 07"}
				floor_08{icon_state = "Floor 08"}
				Entered(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						if(P.current_world_region == KANTO)
							if(P.route == STAFF_AREA)
								if(prob(P.staffRoomGrindRate))
									var levelChoose = 0
									var highestLevel = 0
									for(var/pokemon/PK in P.party)
										if(PK.level > highestLevel)
											highestLevel = PK.level
									levelChoose = min(highestLevel+2,100)
									var pokemon/S = get_pokemon("Grindikarp",P,level=levelChoose)
									S.stat_calculate()
									S.HP = S.maxHP
									var battleSystem/X = new(list(P),FALSE,S,area_type=URBAN)
									P.client.battle = X // To be safe
		object
			desk{icon = 'Indoor Object.dmi' ; icon_state = "Desk" ; density = 1}
			chair
				chair_01{icon_state = "Blue Chair"}
				chair_02{icon_state = "Yellow Chair"}
			window
				window_01{icon_state = "Window"}
				window_02{icon_state = "Window Shade"}
			game_console
				wii{icon_state = "Wii"}