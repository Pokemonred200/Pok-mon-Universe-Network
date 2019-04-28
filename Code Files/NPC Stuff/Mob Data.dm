/* Red (Pokemonred200) */

atom/movable
	var
		tmp
			atom/prevLoc
			next_move = 0
			last_move = 0
			move_dir = 0
			move_flags = 0
			atomMovFlags = 0
		dirChange = TRUE
		move_delay = 0
	Cross(atom/movable/O)
		. = ..()
		if(!.)
			CrossFailed(O)
	Move(atom/NewLoc,Dir=0,step_x=0,step_y=0)
		var time = world.time
		if(next_move>time)return 0
		if(!NewLoc)
			move_dir = Dir
			move_flags = MOVE_SLIDE
		else if(isturf(loc)&&isturf(NewLoc))
			var dx = NewLoc.x - x
			var dy = NewLoc.y - y
			if((z==NewLoc.z)&&(abs(dx)<=1)&&(abs(dy)<=1))
				move_dir = 0
				move_flags = MOVE_SLIDE
				if(dx>0) move_dir |= EAST
				else if(dx<0) move_dir |= WEST
				if(dy>0) move_dir |= NORTH
				else if(dy<0) move_dir |= SOUTH
			else
				move_dir = 0
				move_flags = MOVE_JUMP
		else
			move_dir = 0
			move_flags = MOVE_TELEPORT
		glide_size = TILE_WIDTH / max(move_delay,TICK_LAG) * TICK_LAG
		. = ..(NewLoc,Dir,step_x,step_y)
		last_move = time
		if(.)
			next_move = time+move_delay
			Moved(NewLoc,Dir,step_x,step_y)
		else
			MoveFailed(NewLoc,Dir,step_x,step_y)
	proc
		Moved(atom/NewLoc,Dir,step_x,step_y)
		MoveFailed(atom/NewLoc,Dir,step_x,step_y)
		CrossFailed(atom/movable/O)

var static/mob/NPC/NPCTrainer/trainers_list[0]

mob
	NPC
		BeachGirl
			density = 1
			icon = 'Trainer Icon.dmi'
			icon_state = "Girl 12"
			New()
				..()
				underlays += image('Shadow Effects.dmi',"Shadow")
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					P.ShowText("Hey, who are you?",RedColor,TRUE)
					var Color/theColor = (P.gender==MALE)?(BlueColor):(RedColor)
					P.ShowText("...",theColor,TRUE)
					P.ShowText("Oh, hi [P]. I'm Carla! I'm looking around the beach to find items buried under the sand.",RedColor,TRUE)
					P.ShowText("Carla: I'm not sure if you know this, but you can find items such as Shoal Salt and Shoal Shells on beaches sometimes.",
					RedColor,TRUE)
					P.ShowText("Oh, and sometimes, even Pearls or Big Pearls! It's really nice to find these kinds of items.",RedColor,TRUE)
		BlockNerd
			icon = 'Character Icon.dmi'
			icon_state = "Icon 20"
			New()
				..()
				underlays += image('Shadow Effects.dmi',"Shadow")
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!("/mob/NPC/NPCTrainer/Rival" in P.story.defeatedTrainers))
						var{rivalGender;rivalName;rivalGender2}
						if(P.gender==MALE)
							rivalGender = "girl"
							rivalName = "May"
							rivalGender2 = "her"
						else
							rivalGender = "guy"
							rivalName = "Brendan"
							rivalGender2 = "him"
						P.ShowText("Hey! Don't walk over here! I'm sketching the footprints of a rare Pokémon!",BlueColor,TRUE)
						P.ShowText("...",bold=TRUE)
						P.ShowText("So you're that [P.name] kid?",BlueColor,TRUE)
						P.ShowText("That [rivalGender] [rivalName] on Route 103 was looking for you.",BlueColor,TRUE)
						P.ShowText("Why don't you go talk to [rivalGender2]?",BlueColor,TRUE)
						return
					if(1 in P.story.defeatedTrainers["/mob/NPC/NPCTrainer/Rival"])
						P.ShowText("It turned out those footprints were mine...",BlueColor,TRUE)
						P.ShowText("I'VE NEVER FELT MORE OF AN IDIOT IN MY LIFE.",BlueColor,TRUE)
						P.ShowText("THERE'S NO NEED TO LAUGH IN MY FACE YOU JERK!",BlueColor,TRUE)
						return
					else
						var{rivalGender;rivalName;rivalGender2}
						if(P.gender==MALE)
							rivalGender = "girl"
							rivalName = "May"
							rivalGender2 = "her"
						else
							rivalGender = "guy"
							rivalName = "Brendan"
							rivalGender2 = "him"
						P.ShowText("Hey! Don't walk over here! I'm sketching the footprints of a rare Pokémon!",BlueColor,TRUE)
						P.ShowText("...",bold=TRUE)
						P.ShowText("So you're that [P.name] kid?",BlueColor,TRUE)
						P.ShowText("That [rivalGender] [rivalName] on Route 103 was looking for someone that looks like you.",BlueColor,TRUE)
						P.ShowText("Why don't you go talk to [rivalGender2]?",BlueColor,TRUE)
		BeldumGiver
			density = 1
			icon = 'Gymleader Icon.dmi'
			icon_state = "Icon 16"
			New()
				..()
				underlays += image('Shadow Effects.dmi',"Shadow")
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(("shiny beldum" in event.events) && (event.events["shiny beldum"]["active"]))
						if("[ckeyEx(P.key)]" in event.events["shiny beldum"]["players_done"])
							P.ShowText("You've already recieved the Shiny Beldum I have. Come again another time.",BlueColor,TRUE)
						else
							var partyPos = P.party.Find(null,1,7)
							if(partyPos)
								event.events["shiny beldum"]["players_done"] += "[ckeyEx(P.key)]"
								if(!("Success" in P.client.Audio.sounds))
									P.client.Audio.addSound(sound('success.wav',channel=19),"Success")
								P.client.Audio.playSound("Success")
								P.ShowText("Here's a Shiny Beldum!",BlueColor,TRUE)
								var pokemon/PK = get_pokemon("Beldum",P,shinyNum=P.tValue,hidden=1)
								PK.caughtWith = "Cherish Shine Ball"
								PK.moves = newlist(/pmove/Hold_Back,/pmove/Zen_Headbutt,/pmove/Iron_Head,/pmove/Iron_Defense)
								PK.held = new /item/normal/mega_stone/Metagrossite
								P.party[partyPos] = PK
							else
								P.ShowText("You don't have any space in your party for this Pokémon.")
					else
						P.ShowText("I'm sorry, I don't have anything to give you. Come back another time.",BlueColor,TRUE)
		Day_Care_Person
			var
				careType
				friendType
				daycareID
			Day_Care_Boy
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						var breedhandler/BH = P.getBreedHandler("[daycareID]")
						var x = isnull(BH.P1)
						var y = isnull(BH.P2)
						if(x&&y)
							P.ShowText("Hello, I'm the Day-Care [careType]. If you'd like us to take care of your Pokémon, please speak to my [friendType].")
						else if(x&&(!y))
							P.ShowText("Hello, [P]! Your [BH.P2] is doing fine.")
						else if((!x)&&y)
							P.ShowText("Hello, [P]! Your [BH.P1] is doing fine.")
						else
							if(!isnull(BH.theEgg))
								P.ShowText("[P]! I'm so glad you're here. You see, we went to check on your Pokémon, and we found it holding an egg!")
								P.ShowText("Would you like to take this egg?")
								if(alert(P,"Will you take this egg?","Take the egg?","Yes!","No...")=="Yes!")
									var partyIndex = P.party.Find(null,1,7)
									if(partyIndex)
										P.party[partyIndex] = BH.theEgg
										BH.theEgg = null
										P.ShowText("Please, take good care of this egg.")
									else
										P.ShowText("You need to make room for the egg first!")
								else
									P.ShowText("If you don't take the egg, I'll keep it for myself!")
									if(alert(P,"Still won't take this egg?","Take the egg?","Yes!","No...")=="Yes!")
										var partyIndex = P.party.Find(null,1,7)
										if(partyIndex)
											P.party[partyIndex] = BH.theEgg
											BH.theEgg = null
											P.ShowText("Please, take good care of this egg.")
										else
											P.ShowText("I knew you had a reason for not wanting it! If you didn't have enough space, why didn't you say so?")
											P.ShowText("I'll just hold onto this until you free up some space")
							else
								var canBreed[] = BH.canBreed()
								if(canBreed["canBreed"])
									switch(canBreed["chance"])
										if(69.3)
											P.ShowText("Your [BH.P1] and [BH.P2] seem to like each other very much!")
										if(49.5)
											P.ShowText("Your [BH.P1] and [BH.P2] seem to get along.")
										if(19.8)
											P.ShowText("Your [BH.P1] and [BH.P2] seem to not like each other much.")
										if(9.3)
											P.ShowText("Your [BH.P1] and [BH.P2] seme to interact rarely, but prefer to spend time with other Pokémon than with \
											each other.")
										else
											P.ShowText("Your [BH.P1] and [BH.P2] seem to prefer to spend time with other Pokémon than with each other.")
								else
									P.ShowText("Your [BH.P1] and [BH.P2] seem to prefer to spend time with other Pokémon than with each other.")
			Day_Care_Girl
				Interact(atom/movable/O)
					if(istype(O,/player))
						var player/P = O
						var breedhandler/BH = P.getBreedHandler("[daycareID]")
						if(BH.theEgg)
							P.ShowText("Oh, [P]! There you are. My [friendType] was looking for you.")
						else
							P.ShowText("Hello, [P]. I'm the Day-Care [careType].")
							P.DaycareOpen(BH)
		Flower_Girl
			icon = 'Trainer Icon.dmi'
			icon_state = "Girl 12"
			New()
				..()
				underlays += image('Shadow Effects.dmi',"Shadow")
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!(P.story.itemsGivenFlags & RECIEVED_WATERING_CAN))
						P.ShowText("The Machoke Back there are helping me build a flower shop.",RedColor,TRUE)
						P.ShowText("When it's done, the best in berry care will finally be possible!",RedColor,TRUE)
						P.ShowText("Would you like to water berries? Here's a watering can!",RedColor,TRUE)
						P.ShowText("Which watering can would you like?",RedColor,TRUE)
						var can_chosen = FALSE
						var can_type_path
						var which_can
						do
							which_can = input(P,"Which watering can would you like?","Watering Can?") as null|anything in list("Sprayduck",
							"Sprinklotad",
							"Squirtbottle",
							"Wailmer Pail")
							if(isnull(which_can))
								P.ShowText("You don't want a watering can? That makes me kind of sad...",RedColor,TRUE)
								return
							else
								P.ShowText("Are you sure you want the [which_can]?",RedColor,TRUE)
								if(alert("Are you sure you want the [which_can]?","Watering Can","Yes!","No...")=="Yes!")
									can_chosen = TRUE
						while(!can_chosen)
						switch(which_can)
							if("Sprayduck")can_type_path = /item/key/watering_can/Sprayduck
							if("Sprinklotad")can_type_path = /item/key/watering_can/Sprinklotad
							if("Squirtbottle")can_type_path = /item/key/watering_can/Squirtbottle
							if("Wailmer Pail")can_type_path = /item/key/watering_can/Wailmer_Pail
						P.bag.addItem(can_type_path)
						P.ShowText("Thank you for taking the [which_can]!",RedColor,TRUE)
						P.ShowText("Please, make sure you water as many plants as possible, it makes them healthier!",RedColor,TRUE)
						var theThieves = (P.mode in list("Sapphire","Emerald"))?("Team Aqua"):("Team Magma")
						P.ShowText("There have been thieves from [theThieves] running about. Be careful!",RedColor,TRUE)
						P.story.itemsGivenFlags |= RECIEVED_WATERING_CAN
					else
						P.ShowText("Would you like to buy some Mulch? It should help your plant's progress.",RedColor,TRUE)
						var items = newlist(/item/normal/mulch/Damp_Mulch,/item/normal/mulch/Growth_Mulch,/item/normal/mulch/Stable_Mulch,/item/normal/mulch/Gooey_Mulch)
						winset(P,"ShopWindow","is-visible=true")
						P << output(null,"ShopWindow.ShopGrid")
						var Grid/G = new("ShopWindow","ShopGrid",P)
						for(var/index in 1 to 8)
							var item/I = items[index]
							G.Cell(1,index,"\icon[I]")
							G.Cell(2,index,"[I]")
							G.Cell(3,index,"<a href='?src=\ref[I];action=buy;tMob=\ref[P]'>Buy</a>")
							G.Cell(4,index,"Cost: [I.cost]")
						G.Cells(new/Size(4,8))
						while(winget(P,"ShopWindow","is-visible")=="true")sleep TICK_LAG
		Mom
			icon = 'Character Icon.dmi'
			icon_state = "Icon 31"
			New()
				..()
				underlays += image('Shadow Effects.dmi',"Shadow")
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!P.story.starterData["Chosen"])
						P.ShowText("[uppertext(P.name)]! Is it finally the day you get your Pokémon?!",RedColor,TRUE)
						P.ShowText("FINALLY! I'm so happy for you! You can finally start to fend for yourself against gang members and wild animals!",RedColor,TRUE)
						P.ShowText("While I relax at home in my kitchen table watching Soap Operas all day!",RedColor,TRUE)
					else
						P.ShowText("[P.name]? You're back home!",RedColor,TRUE)
						P.ShowText("Did you want me to heal your Pokémon?",RedColor,TRUE)
						if(alert(P,"Heal Your Pokémon?","Heal!","Yes!","No...")=="Yes!")
							for(var/pokemon/S in P.party)
								S.HP = S.maxHP
								for(var/pmove/M in S.moves)
									M.PP = M.MaxPP
								S.status = ""
							if(!("Pokémon Healing" in P.client.Audio.sounds))
								P.client.Audio.addSound(sound('pokemon_heal.wav',channel=10),"Pokémon Healing")
							P.client.Audio.playSound("Pokémon Healing")
							P.ShowText("Your Pokémon are all healed up, kiddo.",RedColor,TRUE)
							P.ShowText("I was setting up for a party with the neighbors. You should probably leave before they get here.",RedColor,TRUE)
							P.respawnpoint = locate("HouseRespawn")
						else
							P.ShowText("Oh. Well, I have a movie to watch. Can you leave me in peace?",RedColor,TRUE)
		NPCTrainer
			parent_type = /combatant
			TID = 65535
			SID = 65535
			density = 0
			New()
				..()
				trainers_list += src
				underlays += image('Shadow Effects.dmi',"Shadow")
				beginDir = dir
			Interact(atom/movable/O,fromClone)
				if(istype(O,/player))
					var player/P = O
					if(P.playerFlags & TRAINER_INTERACTING)return FALSE
					P.playerFlags |= TRAINER_INTERACTING
					if(src.cloneCache && src.cloneCache["[ckeyEx(P.key)]"] && (!fromClone))return null
					var theList[] = P.story.defeatedTrainers["[src.type]"]
					P.playerFlags &= ~TRAINER_INTERACTING
					if(theList && theList.Find(theID))
						return FALSE
					else
						if(autoplayEncounterMusic && encounterMusic)
							P.client.Audio.pauseSound("123")
							P.client.Audio.addSound(music(encounterMusic,channel=56),"Battle Intro",TRUE)
						return TRUE
				else return FALSE
			Cross(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(FOV && cloneCache && ("[ckeyEx(P.key)]" in cloneCache))
						return 1
					else return 0
				else return ..()
			var
				theID
				defeated_quotes[0]
				parties[0]
				quote_list[0]
				tValue = 34
				tmp/beginDir
				route = "Route 101"
				current_world_region = "Hoenn"
				basePay = 100
				encounterMusic
				autoplayEncounterMusic = TRUE
				image/mainImage
				image/imageCache
				mob/cloneCache
				FOV = TRUE
				FOVRange = 12
			proc
				fillTeam(player/P)
				createClone(player/P)
					if(isnull(mainImage))
						mainImage = image(loc=src)
						mainImage.appearance = src.appearance
						mainImage.override = TRUE
						icon = null
						icon_state = ""
						overlays = list()
						underlays = list()
						for(var/player/PL in global.online_players)
							if(!(PL.playerFlags & IN_LOGIN))
								PL.client.images |= mainImage
					if(isnull(imageCache))
						imageCache = list()
					if(isnull(cloneCache))
						cloneCache = list()
					var mob/trainerClone/M = new
					M.trainer = src
					M.loc = src.loc
					var image/I = image(loc=M)
					I.appearance = mainImage.appearance
					I.dir = src.beginDir
					I.override = TRUE
					P.client.images += I
					P.client.images -= src.mainImage
					src.imageCache["[ckeyEx(P.key)]"] = I // Cache the image for later access
					src.cloneCache["[ckeyEx(P.key)]"] = M // Cache the mob for later access
					return M

mob
	eventBattle
		density = 0
		/*SouthernIslandBattle
			icon = 'Region 03.dmi'
			icon_state = "Latios"
			var
				image
					latiosImage
					latiasImage
			Cross(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.story.storyFlags2 & CAUGHT_EON_LEGEND_SOUTHERN)return ..()
					else return 0
				else return ..()
			New()
				..()
				icon = null
				icon_state = ""
				latiosImage = image('Region 03.dmi',src,"Latios")
				latiasImage = image('Region 03.dmi',src,"Latias")
				latiosImage.overlays += image('Shadow Effects.dmi',"Shadow")
				latiasImage.overlays += image('Shadow Effects.dmi',"Shadow")*/
		DarkraiBattle
			icon = 'Region 04.dmi'
			icon_state = "Darkrai"
			var image/sprite
			Cross(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.story.storyFlags2 & CAUGHT_DARKRAI)return ..()
					else return 0
				else return ..()
			New()
				..()
				icon = null
				icon_state = ""
				sprite = image('Region 04.dmi',src,"Darkrai")
				sprite.overlays += image('Shadow Effects.dmi',"Shadow")
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!(P.story.storyFlags2 & CAUGHT_DARKRAI))
						P.client.Audio.addSound(sound('491 Darkrai.wav'),"Pre-Battle Cry",TRUE)
						P.ShowText("...")
						P.client.battle = new /battleSystem(list(P),FALSE,get_pokemon("Darkrai",P,level=(P.mode in list("Ruby","Sapphire"))?(40):(50)),storyFlagsChange=CAUGHT_DARKRAI)
						if(P.story.storyFlags2 & CAUGHT_DARKRAI)
							P.client.images -= sprite
		LugiaBattle
			icon = 'Large Sprite.dmi'
			icon_state = "Lugia"
			var image/sprite
			Cross(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.story.storyFlags2 & CAUGHT_LUGIA)return ..()
					else return 0
				else return ..()
			New()
				..()
				icon = null
				icon_state = ""
				sprite = image('Large Sprite.dmi',src,"Lugia")
				sprite.pixel_x = -6
				sprite.overlays += new/obj{icon='Big Shadow.dmi';icon_state="Big Shadow";pixel_x = -2;layer=-4}
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!(P.story.storyFlags2 & CAUGHT_LUGIA))
						P.client.Audio.addSound(sound('249 Lugia.wav'),"Pre-Battle Cry",TRUE)
						P.ShowText("...")
						P.client.battle = new /battleSystem(list(P),FALSE,get_pokemon("Lugia",P,level=70),storyFlagsChange=CAUGHT_LUGIA,area_type=CAVE)
						// next statement is never executed until battle ends
						if(P.story.storyFlags2 & CAUGHT_LUGIA)
							P.client.images -= sprite
		Ho_Oh_Battle
			icon = 'Large Sprite.dmi'
			icon_state = "Ho-Oh"
			var image/sprite
			Cross(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.story.storyFlags2 & CAUGHT_HO_OH)return ..()
					else return 0
				else return ..()
			New()
				..()
				icon = null
				icon_state = ""
				sprite = image('Large Sprite.dmi',src,"Ho-Oh")
				sprite.pixel_x = -7
				sprite.overlays += new/obj{icon='Big Shadow.dmi';icon_state="Big Shadow";pixel_x = -2;layer=-1}
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!(P.story.storyFlags2 & CAUGHT_HO_OH))
						P.client.Audio.addSound(sound('250 Ho-Oh.wav'),"Pre-Battle Cry",TRUE)
						P.ShowText("...")
						P.client.battle = new /battleSystem(list(P),FALSE,get_pokemon("Ho-Oh",P,level=70),storyFlagsChange=CAUGHT_HO_OH,area_type=CAVE)
						// next statement is never executed until battle ends
						if(P.story.storyFlags2 & CAUGHT_HO_OH)
							P.client.images -= sprite
		DeoxysBattle
			icon = 'Region 03.dmi'
			icon_state = "Deoxys"
			var
				image
					rubyImage
					sapphireImage
					emeraldImage
			New()
				. = ..()
				icon = null
				icon_state = ""
				rubyImage = image('Region 03.dmi',src,"Deoxys-A")
				sapphireImage = image('Region 03.dmi',src,"Deoxys-D")
				emeraldImage = image('Region 03.dmi',src,"Deoxys-S")
				for(var/image/I in list(rubyImage,sapphireImage,emeraldImage))
					I.underlays += image('Shadow Effects.dmi',"Shadow")
			Cross(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.story.storyFlags2 & CAUGHT_DEOXYS)
						return ..()
					else
						return 0
				else
					return ..()
			Interact(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(!(P.story.storyFlags2 & CAUGHT_DEOXYS))
						P.client.Audio.addSound(sound('386 Deoxys.wav'),"Pre-Battle Cry",TRUE)
						P.ShowText("...")
						var pokemon/PK
						switch(P.mode)
							if("Ruby") // Spawns as if Deoxys is from Pokémon FireRed Version
								PK = get_pokemon("Deoxys-A",P,level=30)
								PK.moves = newlist(/pmove/DNA_Boost,/pmove/Pursuit,/pmove/Psychic,/pmove/Superpower)
							if("Sapphire") // Spawns as if Deoxys is from Pokémon LeafGreen Version
								PK = get_pokemon("Deoxys-D",P,level=30)
								PK.moves = newlist(/pmove/Knock_Off,/pmove/DNA_Boost,/pmove/Psychic,/pmove/Snatch)
							if("Emerald") // Spawns as if Deoxys is from Pokémon Emerald Version
								PK = get_pokemon("Deoxys-S",P,level=30)
								PK.moves = newlist(/pmove/Knock_Off,/pmove/Pursuit,/pmove/Psychic,/pmove/DNA_Boost)
							else
								PK = get_pokemon("Deoxys",src,level=30)
						P.client.battle = new /battleSystem(list(P),FALSE,PK,storyFlagsChange=CAUGHT_DEOXYS)
						// the next statement is never executed until the battle ends
						if(P.story.storyFlags2 & CAUGHT_DEOXYS)
							P.client.images.Remove(rubyImage,sapphireImage,emeraldImage)

mob
	trainerClone
		var mob/NPC/NPCTrainer/trainer
		density = 0
		Interact(player/P)trainer.Interact(P,TRUE)
		Cross(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(src==trainer.cloneCache["[ckeyEx(P.key)]"])
					return 0
				else return ..()
			else return ..()

mob/NPC/Vs_Seeker_Guy
	density = 1
	icon = 'Trainer Icon.dmi'
	icon_state = "Boy 14"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!(P.story.storyFlags & GOT_VS_SEEKER))
				P.ShowText("Have you ever wanted to rematch trainers you've beaten?",BlueColor,TRUE)
				P.ShowText("Well, you're in luck! I have a Vs. Seeker, which will let you do just that!",BlueColor,TRUE)
				P.ShowText("But first, answer me this: What's your favorite color?",BlueColor,TRUE)
				var
					colorList = list("Red","Green","Blue","Yellow","Gold","Silver","Crystal","Ruby","Sapphire","Emerald","Orange","Pink","Purple","Magenta",
					"Maroon","Cyan","White","Black")
					choice = input(P,"What's your favorite color?","Pick Your Color") as null|anything in colorList
					item/key/VS_Seeker/V
				switch(choice)
					if(null)
						P.ShowText("Aww... well, maybe next time then.")
					if("Red")V = new/item/key/VS_Seeker/seeker_red
					if("Green")V = new/item/key/VS_Seeker/seeker_green
					if("Blue")V = new/item/key/VS_Seeker/seeker_blue
					if("Yellow")V = new/item/key/VS_Seeker/seeker_yellow
					if("Gold")V = new/item/key/VS_Seeker/seeker_gold
					if("Silver")V = new/item/key/VS_Seeker/seeker_silver
					if("Crystal")V = new/item/key/VS_Seeker/seeker_crystal
					if("Ruby")V = new/item/key/VS_Seeker/seeker_ruby
					if("Sapphire")V = new/item/key/VS_Seeker/seeker_sapphire
					if("Emerald")V = new/item/key/VS_Seeker/seeker_emerald
					if("Orange")V = new/item/key/VS_Seeker/seeker_orange
					if("Pink")V = new/item/key/VS_Seeker/seeker_pink
					if("Purple")V = new/item/key/VS_Seeker/seeker_purple
					if("Magenta")V = new/item/key/VS_Seeker/seeker_magenta
					if("Maroon")V = new/item/key/VS_Seeker/seeker_maroon
					if("Cyan")V = new/item/key/VS_Seeker/seeker_cyan
					if("White")V = new/item/key/VS_Seeker/seeker_white
					if("Black")V = new/item/key/VS_Seeker/seeker_black
					else V = new/item/key/VS_Seeker/seeker_red
				var icon/iconData = icon(V.icon,V.icon_state)
				P.customAlert("Are you sure you want to get the [choice] Vs. Seeker?","You Sure?","Yes","No",iconData)
				if(P.alertResponse=="Yes")
					P.ShowText("Here's your Vs. Seeker!",BlueColor,TRUE)
					if(!("Item Pickup" in P.client.Audio.sounds))
						P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
					P.story.storyFlags |= GOT_VS_SEEKER
					P.bag.addItem(V.type)

mob/NPC/Exp_Share_Guy
	density = 1
	icon = 'Character Icon.dmi'
	icon_state = "Icon 18"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!(P.story.storyFlags & BOUGHT_EXP_SHARE))
				P.ShowText("I have a really good item that allows your Pokémon to Share.",BlueColor,TRUE)
				P.ShowText("Would you like to buy it? It's only 5,000 Poké Dollars!",BlueColor,TRUE)
				if(alert(P,"Would you like to buy the EXP. Share for 5,000 Poké Dollars?","Buy the EXP. Share","Yes","No")=="Yes")
					if(P.money >= 5000)
						P.money -= 5000
						P.client.moneyLabel.Text("[P.money]")
						P.ShowText("Here's your handy dandy EXP. Share!",BlueColor,TRUE)
						P.bag.addItem(/item/normal/exp_item/Exp_Share)
						if(!("Item Pickup" in P.client.Audio.sounds))
							P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
						P.story.storyFlags |= BOUGHT_EXP_SHARE
					else
						P.ShowText("You don't seem to have enough money for the EXP. Share.... what a bummer.",BlueColor,TRUE)
			else
				P.ShowText("Sharing is caring.",BlueColor,TRUE)

mob/NPC/Shoal_Guy
	parent_type = /mob
	density = 1
	icon = 'Character Icon.dmi'
	icon_state = "Icon 10"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			P.ShowText("I'm the Shoal Guy!",BlueColor,TRUE)
			P.ShowText("If you can bring me four Shoal Salt and four Shoal Shells, I'll give you something nice!",BlueColor,TRUE)
			var item/I1 = P.bag.hasItem(/item/normal/Shoal_Salt)
			var item/I2 = P.bag.hasItem(/item/normal/Shoal_Shell)
			if(I1 && I2)
				if((I1.itemstack >= 4) && (I2.itemstack >= 4))
					P.ShowText("Oh! I see you do have the Shoal Salt and Shoal Shells.",BlueColor,TRUE)
					P.ShowText("In exchange for these ingredients, I'll give you a Shell Bell!",BlueColor,TRUE)
					P.bag.addItem(/item/normal/Shell_Bell)
					if(!("Item Pickup" in P.client.Audio.sounds))
						P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
					P.client.Audio.playSound("Item Pickup")
					P.bag.removeItem(/item/normal/Shoal_Salt,4)
					P.bag.removeItem(/item/normal/Shoal_Shell,4)

mob/NPC/ParkManager
	parent_type = /mob
	icon = 'Character Icon.dmi'
	icon_state = "Icon 30"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			P.ShowText("Welcome to Pal Park!",BlueColor,TRUE)
			if(!fexists("Transfer Files/[ckeyEx(P.key)].esav"))
				P.ShowText("You have no Pokémon in your Transfer Space...",BlueColor,TRUE)
				P.ShowText("You need to import Pokémon from Pokémon Red, Blue, Green, Yellow, Gold, Silver, Crystal, Ruby, Sapphire, Emerald,\
				FireRed, or LeafGreen before you can continue.",BlueColor,TRUE)
				P.ShowText("You can do this with the Exporter tool.",BlueColor,TRUE)

var static/mob/NPC/NPCTrainer/Rival/rival_list[0]

mob/NPC/NPCTrainer/NPCDouble
	var
		cloneDir = EAST
		mob/NPC/NPCTrainer/NPCDouble/myLink
	New(loc,createClone=TRUE)
		. = ..()
		if(createClone)
			var turf/T = get_step(src,cloneDir)
			var mob/NPC/NPCTrainer/NPCDouble/NPC = new src.type(T,FALSE)
			NPC.dir = src.dir
			NPC.myLink = src
			src.myLink = NPC
			NPC.parties = src.parties
			NPC.quote_list = src.quote_list
			NPC.theID = src.theID

mob/NPC/NPCTrainer/NPCDouble/Twins
	icon = 'Trainer Icon.dmi'
	twin_male
		icon_state = "Boy 11"
	twin_female
		icon_state = "Girl 11"
		fillTeam(player/P)
			var pokemon/newParty[0]
			switch(theID)
				if(1)
					var pokemon/slot1 = get_pokemon("Plusle",src,shinyNum=4)
					var pokemon/slot2 = get_pokemon("Minun",src,shinyNum=4)
					slot1.level = 15
					slot2.level = 15
					newParty.Add(slot1,slot2)
			for(var/pokemon/S in newParty)
				S.stat_calculate()
				S.HP = S.maxHP
				S.moves.len = 4
			newParty.len = 6
			parties["[ckeyEx(P.key)]"] = newParty
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			. = ..()
			if(isnull(.))return
			if(.)
				for(var/quotes in quote_list)
					P.ShowText("[quotes]")
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src),TRUE)
			else
				P.ShowText("Unfortunately, we couldn't win...")

mob/NPC/NPCTrainer/Quinn
	icon = 'Heroes Icon.dmi'
	icon_state = "Icon 23"
	basePay = 105
	FOV = FALSE
	Interact(atom/movable/O)
		. = ..()
		if(.)
			if(istype(O,/player))
				var player/P = O
				for(var/quotes in quote_list)
					P.ShowText("[quotes]",RedColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				switch(P.story.starterData["Starter"])
					if("Treecko")
						newParty.Add(get_pokemon("Mudkip",src,shinyNum = 4))
					if("Torchic")
						newParty.Add(get_pokemon("Treecko",src,shinyNum = 4))
					if("Mudkip")
						newParty.Add(get_pokemon("Torchic",src,shinyNum = 4))
					else
						switch(pick("Treecko","Torchic","Mudkip")) // Failsafe for admins
							if("Treecko")
								newParty.Add(get_pokemon("Mudkip",src,shinyNum=4))
							if("Torchic")
								newParty.Add(get_pokemon("Treecko",src,shinyNum=4))
							if("Mudkip")
								newParty.Add(get_pokemon("Torchic",src,shinyNum=4))
				newParty.len = 6
				parties["[ckeyEx(P.key)]"] = newParty

mob/StationNPC
	var quotes[] = list()
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			for(var/quote in quotes)
				P.ShowText(quote,(P.gender==MALE)?(BlueColor):(RedColor),TRUE)
	Pokemon
		var theCry
		Interact(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				P.client.Audio.addSound(sound(theCry,channel=21),"Mah Cry",TRUE)
				..()
	ItemGiver
		var
			itemFlag = 0
			var theItem
			postQuotes[0]
			giveItemQuotes[0]
		Interact(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(P.story.itemsGivenFlags & itemFlag)
					for(var/quote in postQuotes)
						P.ShowText(quote,(P.gender==MALE)?(BlueColor):(RedColor),TRUE)
				else
					..()
					if(istext(theItem))theItem = text2path(theItem)
					if(theItem==/item/tm/hm/HM01)
						if(!("Stone Badge" in P.story.badgesObtained))
							P.ShowText("No. You need the Stone Badge. Come Back when it's worth my time.",TRUE,BlueColor)
							return
						else
							P.ShowText("You've gotten a stone badge? Here, take this Cutting thing.",TRUE,BlueColor)
					else if(theItem==/item/tm/hm/HM07)
						if(!("Dynamo Badge" in P.story.badgesObtained))
							P.ShowText("You're gonna need the Dynamo Badge if you want this thing.",TRUE,BlueColor)
							return
						else
							P.ShowText("You've recieved the Dynamo Badge? This should be worth your while then.",TRUE,BlueColor)
					if(ispath(theItem,/item/key))
						if(!("Key Item Pickup" in P.client.Audio.sounds))
							P.client.Audio.addSound(sound('key_item_get.wav',channel=20),"Key Item Pickup")
						P.client.Audio.playSound("Key Item Pickup")
					else if(ispath(theItem,/item/tm))
						if(!("TM Pickup" in P.client.Audio.sounds))
							P.client.Audio.addSound(sound('tm_get.wav',channel=20),"TM Pickup")
						P.client.Audio.playSound("TM Pickup")
					else
						if(!("Item Pickup" in P.client.Audio.sounds))
							P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
						P.client.Audio.playSound("Item Pickup")
					P.bag.addItem(theItem)
					P.story.itemsGivenFlags |= itemFlag
					var item/I = new theItem
					var loweredData = lowertext("[I.name]")
					P.ShowText(replacetext("You have recieved \a [loweredData]!","[loweredData]","[I.name]"))
					for(var/quote in giveItemQuotes)
						P.ShowText(quote,(P.gender==MALE)?(BlueColor):(RedColor),TRUE)

mob/NPC/NPCTrainer/Rich_Boy
	basePay = 160
	icon = 'Trainer Icon.dmi'
	icon_state = "Boy 15"
	Interact(atom/movable/O)
		. = ..()
		if(istype(O,/player))
			var player/P = O
			if(.)
				for(var/quote in quote_list)
					P.ShowText("[quote]",BlueColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
			else
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",BlueColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Zigzagoon",src,level=8,shinyNum=4),get_pokemon("Litleo",src,level=9,shinyNum=4))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Lady
	basePay = 160
	icon = 'Trainer Icon.dmi'
	icon_state = "Girl 13"
	Interact(atom/movable/O)
		. = ..()
		if(istype(O,/player))
			var player/P = O
			if(.)
				for(var/quote in quote_list)
					P.ShowText("[quote]",RedColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
			else
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",RedColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Zigzagoon",src,level=7,shinyNum=4),get_pokemon("Shinx",src,level=8,shinyNum=4))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Fisherman
	basePay = 16
	icon = 'Character Icon.dmi'
	icon_state = "Icon 22"
	encounterMusic = 'Encounter! Hiker.ogg'
	Interact(atom/movable/O)
		. = ..()
		if(istype(O,/player))
			var player/P = O
			if(.)
				for(var/quote in quote_list)
					P.ShowText("[quote]",BlueColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
			else
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",BlueColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Magikarp",src,level=9,shinyNum=4))
			if(2)
				newParty.Add(get_pokemon("Magikarp",src,level=7,shinyNum=4),get_pokemon("Magikarp",src,level=7,shinyNum=4),
				get_pokemon("Magikarp",src,level=7,shinyNum=4))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Youngster
	basePay = 16
	icon = 'Trainer Icon.dmi'
	icon_state = "Boy 13"
	Interact(atom/movable/O)
		. = ..()
		if(isnull(.))return
		var player/P = O
		if(.)
			if(istype(O,/player))
				for(var/quote in quote_list)
					P.ShowText("[quote]",BlueColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
		else
			if(istype(O,/player))
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",BlueColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Zigzagoon",src,level=5,shinyNum=4))
			if(2)
				newParty.Add(get_pokemon("Poochyena",src,level=5,shinyNum=4),
				get_pokemon("Taillow",src,level=3,shinyNum=4))
			if(3)
				newParty.Add(get_pokemon("Zigzagoon",src,level=5,shinyNum=4),
				get_pokemon("Seedot",src,level=7,shinyNum=4))
			if(4)
				newParty.Add(get_pokemon("Zigzagoon",src,level=7,shinyNum=4,theGenderByte=255),
				get_pokemon("Machop",src,level=9,shinyNum=4,theGenderByte=255))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Lass
	basePay = 16
	icon = 'Trainer Icon.dmi'
	icon_state = "Girl 12"
	Interact(atom/movable/O)
		. = ..()
		if(isnull(.))return
		var player/P = O
		if(.)
			if(istype(O,/player))
				for(var/quote in quote_list)
					P.ShowText("[quote]",RedColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
		else
			if(istype(O,/player))
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",RedColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Zigzagoon",src,shinyNum=4,level=4),
				get_pokemon("Taillow",src,shinyNum=4,level=4))
			if(2)
				switch(P.mode)
					if("Ruby")
						newParty.Add(get_pokemon("Seedot",src,shinyNum=4,level=7),
						get_pokemon("Shroomish",src,shinyNum=4,level=7))
					if("Sapphire")
						newParty.Add(get_pokemon("Lotad",src,shinyNum=4,level=7),
						get_pokemon("Shroomish",src,shinyNum=4,level=7))
					if("Emerald")
						newParty.Add(get_pokemon((P.TID%2)?("Seedot"):("Lotad"),src,shinyNum=4,level=6),
						get_pokemon("Shroomish",src,shinyNum=4,level=7))
			if(3)
				newParty.Add(get_pokemon("Marill",src,shinyNum=4,level=10,theGenderByte=0))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Bug_Catcher
	basePay = 16
	icon = 'Trainer Icon.dmi'
	icon_state = "Boy 12"
	gender = MALE
	Interact(atom/movable/O)
		. = ..()
		if(isnull(.))return
		if(.)
			if(istype(O,/player))
				var player/P = O
				for(var/quote in quote_list)
					P.ShowText("[quote]",(src.gender==MALE)?(BlueColor):(RedColor),TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
		else
			if(istype(O,/player))
				var player/P = O
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",(src.gender==MALE)?(BlueColor):(RedColor),TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Wurmple",src,shinyNum=4,level=4),
				get_pokemon("Wurmple",src,shinyNum=4,level=4))
			if(2)
				newParty.Add(get_pokemon("Wurmple",src,shinyNum=4),get_pokemon("Wurmple",src,shinyNum=4),get_pokemon("Wurmple",src,shinyNum=4))
			if(3)
				newParty.Add(get_pokemon("Wurmple",src,shinyNum=4,level=7,theGenderByte=255),
				get_pokemon("Silcoon",src,shinyNum=4,level=7,theGenderByte=255),
				get_pokemon("Nincada",src,shinyNum=4,level=7,theGenderByte=255))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty
	Girl
		icon_state = "Girl 14"
		gender = FEMALE
		fillTeam(player/P)
			if(isnull(P))return
			var pokemon/newParty[0]
			switch(theID)
				if(1)
					newParty.Add(get_pokemon("Nincada",src,shinyNum=4,level=8),get_pokemon("Surskit",src,shinyNum=4,level=8))
			newParty.len = 7
			src.parties["[ckeyEx(P.key)]"] = newParty

turf
	forceRivalBattle
		var
			trainerID
		Entered(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(!(trainerID in P.story.defeatedTrainers["/mob/NPC/NPCTrainer/Rival"]))
					for(var/mob/NPC/NPCTrainer/Rival/R in rival_list)
						if(R.theID==trainerID)
							R.Interact(P)
							break

mob/NPC/NPCTrainer/Rival
	basePay = 110
	var
		image/maleIcon
		image/femaleIcon
		quote_list_female[0]
		deafeated_quotes_female[0]
	autoplayEncounterMusic = FALSE
	FOV = FALSE
	New()
		..()
		maleIcon = image('Heroes Icon.dmi',src,"Icon 16")
		femaleIcon = image('Heroes Icon.dmi',src,"Icon 17")
		maleIcon.underlays += image('Shadow Effects.dmi',"Shadow")
		femaleIcon.underlays += image('Shadow Effects.dmi',"Shadow")
		maleIcon.override = TRUE
		femaleIcon.override = TRUE
		rival_list += src
	Del()
		rival_list -= src
		..()
	Interact(atom/movable/O)
		. = ..()
		if(isnull(.))return
		if(istype(O,/player))
			var player/P = O
			if(.)
				P.client.Audio.pauseSound("123")
				if(P.gender == "male")
					P.client.Audio.addSound(music('May\'s Theme.ogg',channel=56),"Battle Intro",TRUE)
					for(var/quotes in quote_list)
						P.ShowText("[quotes]",RedColor,TRUE)
				else
					P.client.Audio.addSound(music('Brendan\'s Theme.ogg',channel=56),"Battle Intro",TRUE)
					for(var/quotes in quote_list_female)
						P.ShowText("[quotes]",BlueColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
			else
				if(P.gender == "male")
					for(var/quotes in defeated_quotes)
						P.ShowText("[quotes]",RedColor,TRUE)
				else
					for(var/quotes in deafeated_quotes_female)
						P.ShowText("[quotes]",BlueColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				switch(P.story.starterData["Starter"])
					if("Treecko")
						var pokemon/slot1 = get_pokemon("Torchic",src,shinyNum=4,level=5)
						slot1.moves = newlist(/pmove/Scratch,/pmove/Growl)
						newParty += slot1
					if("Torchic")
						var pokemon/slot1 = get_pokemon("Mudkip",src,shinyNum=4,level=5)
						slot1.moves = newlist(/pmove/Tackle,/pmove/Growl)
						newParty += slot1
					if("Mudkip")
						var pokemon/slot1 = get_pokemon("Treecko",src,shinyNum=4,level=5)
						slot1.moves = newlist(/pmove/Pound,/pmove/Leer)
						newParty += slot1
					else
						switch(pick("Treecko","Torchic","Mudkip")) // Failsafe for admins
							if("Treecko")
								var pokemon/slot1 = get_pokemon("Torchic",src,shinyNum=4,level=5)
								slot1.moves = newlist(/pmove/Scratch,/pmove/Growl)
								newParty += slot1
							if("Torchic")
								var pokemon/slot1 = get_pokemon("Mudkip",src,shinyNum=4,level=5)
								slot1.moves = newlist(/pmove/Tackle,/pmove/Growl)
								newParty += slot1
							if("Mudkip")
								var pokemon/slot1 = get_pokemon("Treecko",src,shinyNum=4,level=5)
								slot1.moves = newlist(/pmove/Pound,/pmove/Leer)
								newParty += slot1
			if(2)
				switch(P.story.starterData["Starter"])
					if("Treecko")
						var
							pokemon
								slot1 = get_pokemon("Ducklett",src,shinyNum=4,level=21)
								slot2 = get_pokemon("Phantump",src,shinyNum=4,level=23)
								slot3 = get_pokemon("Combusken",src,shinyNum=4,level=25)
						slot1.moves = newlist(/pmove/Aerial_Ace,/pmove/Scald,/pmove/Steel_Wing,/pmove/Roost)
						slot2.moves = newlist(/pmove/Shadow_Sneak,/pmove/Giga_Drain,/pmove/Synthesis,/pmove/Energy_Ball)
						slot3.moves = newlist(/pmove/Double_Kick,/pmove/Flamethrower,/pmove/Fire_Punch,/pmove/Aerial_Ace)
						newParty.Add(slot1,slot2,slot3)
					if("Torchic")
						var
							pokemon
								slot1 = get_pokemon("Vulpix",src,shinyNum=4,level=21)
								slot2 = get_pokemon("Phantump",src,shinyNum=4,level=23)
								slot3 = get_pokemon("Marshtomp",src,shinyNum=4,level=25)
						slot1.moves = newlist(/pmove/Flamethrower,/pmove/Confusion,/pmove/Lava_Plume,/pmove/Hex)
						slot2.moves = newlist(/pmove/Shadow_Sneak,/pmove/Giga_Drain,/pmove/Synthesis,/pmove/Energy_Ball)
						slot3.moves = newlist(/pmove/Scald,/pmove/Earthquake,/pmove/Ice_Punch,/pmove/Hydro_Pump)
						newParty.Add(slot1,slot2,slot3)
					if("Mudkip")
						var
							pokemon
								slot1 = get_pokemon("Ducklett",src,shinyNum=4,level=21)
								slot2 = get_pokemon("Vulpix",src,shinyNum=4,level=23)
								slot3 = get_pokemon("Grovyle",src,shinyNum=4,level=25)
						slot1.moves = newlist(/pmove/Aerial_Ace,/pmove/Scald,/pmove/Steel_Wing,/pmove/Roost)
						slot2.moves =newlist(/pmove/Flamethrower,/pmove/Confusion,/pmove/Lava_Plume,/pmove/Hex)
						slot3.moves = newlist(/pmove/Energy_Ball,/pmove/Dragon_Claw,/pmove/Leaf_Blade,/pmove/Aerial_Ace)
						newParty.Add(slot1,slot2,slot3)
					else
						switch(pick("Treecko","Torchic","Mudkip")) // Failsafe for admins
							if("Treecko")
								var
									pokemon
										slot1 = get_pokemon("Ducklett",src,shinyNum=4,level=21)
										slot2 = get_pokemon("Phantump",src,shinyNum=4,level=23)
										slot3 = get_pokemon("Combusken",src,shinyNum=4,level=25)
								slot1.moves = newlist(/pmove/Aerial_Ace,/pmove/Scald,/pmove/Steel_Wing,/pmove/Roost)
								slot2.moves = newlist(/pmove/Shadow_Sneak,/pmove/Giga_Drain,/pmove/Synthesis,/pmove/Energy_Ball)
								slot3.moves = newlist(/pmove/Double_Kick,/pmove/Flamethrower,/pmove/Fire_Punch,/pmove/Aerial_Ace)
								newParty.Add(slot1,slot2,slot3)
							if("Torchic")
								var
									pokemon
										slot1 = get_pokemon("Vulpix",src,shinyNum=4,level=21)
										slot2 = get_pokemon("Phantump",src,shinyNum=4,level=23)
										slot3 = get_pokemon("Marshtomp",src,shinyNum=4,level=25)
								slot1.moves = newlist(/pmove/Flamethrower,/pmove/Confusion,/pmove/Lava_Plume,/pmove/Hex)
								slot2.moves = newlist(/pmove/Shadow_Sneak,/pmove/Giga_Drain,/pmove/Synthesis,/pmove/Energy_Ball)
								slot3.moves = newlist(/pmove/Scald,/pmove/Earthquake,/pmove/Ice_Punch,/pmove/Hydro_Pump)
								newParty.Add(slot1,slot2,slot3)
							if("Mudkip")
								var
									pokemon
										slot1 = get_pokemon("Ducklett",src,shinyNum=4,level=21)
										slot2 = get_pokemon("Vulpix",src,shinyNum=4,level=23)
										slot3 = get_pokemon("Grovyle",src,shinyNum=4,level=25)
								slot1.moves = newlist(/pmove/Aerial_Ace,/pmove/Scald,/pmove/Steel_Wing,/pmove/Roost)
								slot2.moves =newlist(/pmove/Flamethrower,/pmove/Confusion,/pmove/Lava_Plume,/pmove/Hex)
								slot3.moves = newlist(/pmove/Energy_Ball,/pmove/Dragon_Claw,/pmove/Leaf_Blade,/pmove/Aerial_Ace)
								newParty.Add(slot1,slot2,slot3)
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Ruin_Mainac
	icon = 'Trainer Icon.dmi'
	icon_state = "Boy 17"
	encounterMusic = 'Encounter! Hiker.ogg'
	basePay = 28
	Interact(atom/movable/O)
		. = ..()
		if(isnull(.))return
		var player/P = O
		if(.)
			if(istype(O,/player))
				for(var/quote in quote_list)
					P.ShowText("[quote]",BlueColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
		else
			if(istype(O,/player))
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",BlueColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Sandshrew",src,shinyNum=4,level=15))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/Hiker
	icon = 'Trainer Icon.dmi'
	icon_state = "Boy 16"
	basePay = 56
	encounterMusic = 'Encounter! Hiker.ogg'
	Interact(atom/movable/O)
		. = ..()
		if(isnull(.))return
		var player/P = O
		if(.)
			if(istype(O,/player))
				for(var/quote in quote_list)
					P.ShowText("[quote]",BlueColor,TRUE)
				fillTeam(P)
				P.client.battle = new /battleSystem(list(P,src))
		else
			if(istype(O,/player))
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",BlueColor,TRUE)
	fillTeam(player/P)
		if(isnull(P))return
		var pokemon/newParty[0]
		switch(theID)
			if(1)
				newParty.Add(get_pokemon("Geodude",src,shinyNum=4,level=15))
			if(2)
				newParty.Add(get_pokemon("Geodude",src,shinyNum=4,level=8),
				get_pokemon("Geodude",src,shinyNum=4,level=10,theGenderByte=255))
		newParty.len = 6
		src.parties["[ckeyEx(P.key)]"] = newParty

mob/NPC/NPCTrainer/GymLeader
	var
		badge_given = "" as text
	icon = 'Gymleader Icon.dmi'
	FOV = FALSE
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			var Color/C = (gender==MALE)?(BlueColor):(RedColor)
			if(!(badge_given in P.story.badgesObtained))
				for(var/quote in quote_list)
					P.ShowText("[quote]",C,TRUE)
				var highestLevel = 0
				for(var/pokemon/PK in P.party)
					if(PK.level > highestLevel)
						highestLevel = PK.level
				fillTeam(P,highestLevel)
				var battleSystem/B = new(list(P,src),area_type=URBAN)
				P.client.battle = B
			else
				for(var/quote in defeated_quotes)
					P.ShowText("[quote]",C,TRUE)
	Roxanne
		icon_state = "Icon 17"
		badge_given = "Stone Badge"
		gender = FEMALE
		fillTeam(player/P,highestLevel)
			if(isnull(P))return
			var
				pokemon
					newParty[0]
					slot1 = get_pokemon("Geodude",src,level=12,shinyNum=4)
					slot2 = get_pokemon("Aron",src,level=13,shinyNum=4)
					slot3 = get_pokemon("Larvitar",src,level=14,shinyNum=4)
					slot4 = get_pokemon("Lileep",src,level=13,shinyNum=4)
					slot5 = get_pokemon("Anorith",src,level=16,shinyNum=4)
					slot6 = get_pokemon("Nosepass",src,level=16,shinyNum=4)
			slot1.moves = newlist(/pmove/Tackle,/pmove/Defense_Curl,/pmove/Rock_Throw,/pmove/Rock_Tomb)
			slot2.moves = newlist(/pmove/Tackle,/pmove/Harden,/pmove/Rock_Tomb,/pmove/Mud\-\Slap)
			slot3.moves = newlist(/pmove/Bite,/pmove/Rock_Tomb,/pmove/Sandstorm,/pmove/Screech)
			slot4.moves = newlist(/pmove/Acid,/pmove/Confuse_Ray,/pmove/Energy_Ball,/pmove/Rock_Tomb)
			slot5.moves = newlist(/pmove/Water_Gun,/pmove/Smack_Down,/pmove/Metal_Claw,/pmove/Rock_Tomb)
			slot6.moves = newlist(/pmove/Block,/pmove/Harden,/pmove/Tackle,/pmove/Rock_Tomb)
			slot1.gender = MALE
			slot2.gender = FEMALE
			slot3.gender = MALE

			slot4.gender = MALE
			slot5.gender = FEMALE
			slot6.gender = FEMALE
			slot6.held = new /item/berry/Oran_Berry
			newParty.Add(slot1,slot2,slot3,slot4,slot5,slot6)
			for(var/pokemon/PK in newParty)
				PK.expLevel = PK.level
				PK.level = min(max(PK.level,highestLevel+2),100)
				PK.stat_calculate()
			src.parties["[ckeyEx(P.key)]"] = newParty
	Brawly
		icon_state = "Icon 19"
		badge_given = "Knuckle Badge"
		gender = MALE
		fillTeam(player/P,highestLevel)
			if(isnull(P))return
			var
				pokemon
					newParty[0]
					slot1 = get_pokemon("Machop",src,level=17,shinyNum=4)
					slot2 = get_pokemon("Timburr",src,level=18,shinyNum=4)
					slot3 = get_pokemon("Riolu",src,level=19,shinyNum=4)
					slot4 = get_pokemon("Meditite",src,level=20,shinyNum=4)
					slot5 = get_pokemon("Hawlucha",src,level=23,shinyNum=4)
					slot6 = get_pokemon("Makuhita",src,level=25,shinyNum=34)
			slot1.moves = newlist(/pmove/Vital_Throw,/pmove/Bulk_Up,/pmove/Low_Sweep,/pmove/Revenge)
			slot2.moves = newlist(/pmove/Facade,/pmove/Bulk_Up,/pmove/Wake\-\Up_Slap,/pmove/Rock_Throw)
			slot3.moves = newlist(/pmove/Force_Palm,/pmove/Aura_Sphere,/pmove/Bulk_Up,/pmove/Thunder_Punch)
			slot4.moves = newlist(/pmove/Drain_Punch,/pmove/Confusion,/pmove/Bulk_Up,/pmove/Calm_Mind)
			slot5.moves = newlist(/pmove/Flying_Press,/pmove/Roost,/pmove/Bulk_Up,/pmove/Aerial_Ace)
			slot6.moves = newlist(/pmove/Arm_Thrust,/pmove/Vital_Throw,/pmove/Bulk_Up,/pmove/Rest)
			slot1.ability1 = "No Guard"
			slot2.ability1 = "Guts"
			slot3.ability1 = "Steadfast"
			slot2.held = new /item/normal/Flame_Orb
			slot6.held = new /item/berry/Lum_Berry
			slot1.gender = MALE
			slot2.gender = MALE
			slot3.gender = MALE
			slot4.gender = FEMALE
			slot5.gender = FEMALE
			slot6.gender = MALE
			newParty.Add(slot1,slot2,slot3,slot4,slot5,slot6)
			for(var/pokemon/PK in newParty)
				PK.expLevel = PK.level
				PK.level = min(max(PK.level,highestLevel+2),100)
				PK.stat_calculate()
			src.parties["[ckeyEx(P.key)]"] = newParty
	Wattson
		icon_state = "Icon 20"
		badge_given = "Dynamo Badge"
		gender = MALE
		fillTeam(player/P,highestLevel)
			if(isnull(P))return
			var
				pokemon
					newParty[0]
					slot1 = get_pokemon("Zebstrika",src,level=25,shinyNum=4)
					slot2 = get_pokemon("Magneton",src,level=25,shinyNum=4)
					slot3 = get_pokemon("Luxray",src,level=25,shinyNum=4)
					slot4 = get_pokemon("Electrode",src,level=27,shinyNum=4)
					slot5 = get_pokemon("Jolteon",src,level=27,shinyNum=4)
					slot6 = get_pokemon("Manectric",src,level=27,shinyNum=34)
			slot1.moves = newlist(/pmove/Flame_Charge,/pmove/Wild_Charge,/pmove/Snatch,/pmove/Pursuit)
			slot2.moves = newlist(/pmove/Thunderbolt,/pmove/Magnet_Bomb,/pmove/Zap_Cannon,/pmove/Flash_Cannon)
			slot3.moves = newlist(/pmove/Wild_Charge,/pmove/Crunch,/pmove/Thunder_Fang,/pmove/Night_Slash)
			slot4.moves = newlist(/pmove/Explosion,/pmove/Thunder,/pmove/Thunderbolt,/pmove/Charge)
			slot5.moves = newlist(/pmove/Wild_Charge,/pmove/Thunder,/pmove/Charge,/pmove/Zap_Cannon)
			slot6.moves = newlist(/pmove/Wild_Charge,/pmove/Thunder_Fang,/pmove/Charge,/pmove/Spark)
			slot1.gender = MALE
			slot3.gender = MALE
			slot5.gender = FEMALE
			slot6.gender = FEMALE
			newParty.Add(slot1,slot2,slot3,slot4,slot5,slot6)
			for(var/pokemon/PK in newParty)
				PK.expLevel = PK.level
				PK.level = min(max(PK.level,highestLevel+2),100)
				PK.stat_calculate()
			src.parties["[ckeyEx(P.key)]"] = newParty
	Flannery
		icon_state = "Icon 21"
		badge_given = "Heat Badge"
		gender = FEMALE
		fillTeam(player/P,highestLevel)
			if(isnull(P))return
			var
				pokemon
					newParty[0]
					slot1 = get_pokemon("Camerupt",src,level=28,shinyNum=4)
					slot2 = get_pokemon("Magcargo",src,level=28,shinyNum=4)
					slot3 = get_pokemon("Ninetales",src,level=28,shinyNum=4)
					slot4 = get_pokemon("Pyroar",src,level=32,shinyNum=4)
					slot5 = get_pokemon("Talonflame",src,level=32,shinyNum=4)
					slot6 = get_pokemon("Blaziken",src,level=36,shinyNum=34)
			slot1.moves = newlist(/pmove/Eruption,/pmove/Earthquake,/pmove/Flamethrower,/pmove/Earth_Power)
			slot2.moves = newlist(/pmove/Ancient_Power,/pmove/Flamethrower,/pmove/Lava_Plume,/pmove/Recover)
			slot3.moves = newlist(/pmove/Psychic,/pmove/Flamethrower,/pmove/Hypnosis,/pmove/Dream_Eater)
			slot4.moves = newlist(/pmove/Flamethrower,/pmove/Noble_Roar,/pmove/Crunch,/pmove/Incinerate)
			slot5.moves = newlist(/pmove/Brave_Bird,/pmove/Flare_Blitz,/pmove/Aerial_Ace,/pmove/Roost)
			slot6.moves = newlist(/pmove/Blaze_Kick,/pmove/Close_Combat,/pmove/Bulk_Up,/pmove/Drain_Punch)
			slot5.ability1 = "Gale Wings"
			slot6.ability1 = "Speed Boost"
			newParty.Add(slot1,slot2,slot3,slot4,slot5,slot6)
			for(var/pokemon/PK in newParty)
				PK.expLevel = PK.level
				PK.level = min(max(PK.level,highestLevel+2),100)
				PK.stat_calculate()
			src.parties["[ckeyEx(P.key)]"] = newParty
	Norman
		icon_state = "Icon 18"
		badge_given = "Balance Badge"
		gender = MALE
		fillTeam(player/P,highestLevel)
			if(isnull(P))return
			var
				pokemon
					newParty[0]
					slot1 = get_pokemon("Watchog",src,level=36,shinyNum=4)
					slot2 = get_pokemon("Chansey",src,level=36,shinyNum=4)
					slot3 = get_pokemon("Exploud",src,level=36,shinyNum=4)
					slot4 = get_pokemon("Lopunny",src,level=38,shinyNum=4)
					slot5 = get_pokemon("Diggersby",src,level=38,shinyNum=4)
					slot6 = get_pokemon("Slaking",src,level=40,shinyNum=34)
			slot1.moves = newlist(/pmove/Crunch,/pmove/Hyper_Fang,/pmove/Earthquake,/pmove/Psychic)
			slot2.moves = newlist(/pmove/Soft\-\Boiled,/pmove/Egg_Bomb,/pmove/Thunder_Wave,/pmove/Confuse_Ray)
			slot3.moves = newlist(/pmove/Hyper_Voice,/pmove/Snore,/pmove/Rest,/pmove/Echoed_Voice)
			slot4.moves = newlist(/pmove/High_Jump_Kick,/pmove/Drain_Punch,/pmove/Return,/pmove/Quick_Attack)
			slot5.moves = newlist(/pmove/Iron_Tail,/pmove/Double\-\Edge,/pmove/Bulldoze,/pmove/Earthquake)
			slot6.moves = newlist(/pmove/Slack_Off,/pmove/Hammer_Arm,/pmove/Giga_Impact,/pmove/Snore)
			slot2.held = new/item/normal/stat_item/Eviolite
			slot4.held = new/item/normal/mega_stone/Lopunnite
			slot5.ability1 = "Huge Power"
			newParty.Add(slot1,slot2,slot3,slot4,slot5,slot6)
			for(var/pokemon/PK in newParty)
				PK.expLevel = PK.level
				PK.level = min(max(PK.level,highestLevel+2),100)
				PK.stat_calculate()
			src.parties["[ckeyEx(P.key)]"] = newParty
		Interact(atom/movable/O)
			if(istype(O,/player))
				var
					player/P = O
					badgeList = list("Stone Badge","Knuckle Badge","Dynamo Badge","Heat Badge")
					hasRequiredBadges = TRUE
				for(var/badge in badgeList)
					if(!(badge in P.story.badgesObtained))
						hasRequiredBadges = FALSE
						break
				if(!hasRequiredBadges)
					P.ShowText("You may be my [(P.gender==MALE)?("son"):("daughter")], but that doesn't leave you excempt from the rules.",BlueColor,TRUE)
					P.ShowText("Come back when you have the badges to prove your worth to me. Until then, don't even bother wasting my time.",BlueColor,TRUE)
					return
				else
					..()

mob/NPC/BlockLady
	icon = 'Trainer Icon.dmi'
	icon_state = "Girl 08"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			P.ShowText("Janice: It's my job to tell idiots they can't leave town without a Pokémon.",RedColor,TRUE)
			P.ShowText("But that gets boring after a while, you know...",RedColor,TRUE)

mob/NPC/NurseJoy
	icon = 'Character Icon.dmi'
	icon_state = "Icon 02"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			for(var/pokemon/S in P.party)
				S.HP = S.maxHP
				for(var/pmove/M in S.moves)
					M.PP = M.MaxPP
				S.status = ""
			if(!("Pokémon Healing" in P.client.Audio.sounds))
				P.client.Audio.addSound(sound('pokemon_heal.wav',channel=10),"Pokémon Healing")
			P.client.Audio.playSound("Pokémon Healing")
			P.ShowText("Your Pokémon have been fully healed.",RedColor,TRUE)
			P.ShowText("Please, come back again any time!",RedColor,TRUE)

mob/NPC/Mart
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		BuyStuff(O)
	proc
		BuyStuff(player/P)
	MartGuy
		icon = 'Character Icon.dmi'
		icon_state = "Icon 04"
		BuyStuff(player/P)
			if(istype(P,/player))
				var item/items[] = newlist(/item/pokeball/Poke_Ball,/item/medicine/Potion,/item/normal/Escape_Rope,/item/medicine/Antidote)
				var badgesList[] = P.story.badgesObtained
				if(badgesList.len>=1)
					items += newlist(/item/medicine/Super_Potion,/item/medicine/Ether,/item/normal/repellent/Repel,/item/medicine/Paralyze_Heal,
					/item/medicine/Awakening,/item/medicine/Burn_Heal,/item/medicine/Ice_Heal,/item/pokeball/Great_Ball)
					if(badgesList.len>=2)
						items += newlist(/item/medicine/Hyper_Potion,/item/medicine/Revive,/item/medicine/Elixir,/item/normal/repellent/Super_Repel)
						if(badgesList.len>=3)
							items += newlist(/item/medicine/Full_Heal,/item/normal/repellent/Max_Repel,/item/pokeball/Ultra_Ball)
							if(badgesList.len>=4)
								items += newlist(/item/medicine/Max_Potion,/item/medicine/Max_Ether)
								if(badgesList.len>=5)
									items += newlist(/item/medicine/Full_Restore,/item/medicine/Max_Elixir)
				var len = length(items)
				winset(P,"ShopWindow","is-visible=true")
				P << output(null,"ShopWindow.ShopGrid")
				var Grid/G = new("ShopWindow","ShopGrid",P)
				for(var/index in 1 to len)
					var item/I = items[index]
					G.Cell(1,index,"\icon[I]")
					G.Cell(2,index,"[I]")
					G.Cell(3,index,"<a href='?src=\ref[I];action=buy;tMob=\ref[P]'>Buy</a>")
					G.Cell(4,index,"Cost: [I.cost]")
				G.Cells(new/Size(4,len))
				while(winget(P,"ShopWindow","is-visible")=="true")sleep TICK_LAG
	MartGirl
		icon = 'Character Icon.dmi'
		icon_state = "Icon 05"
		BuyStuff(player/P)
			if(istype(P,/player))
				var item/items[] = newlist(/item/normal/stone/Dawn_Stone,/item/normal/stone/Dusk_Stone,/item/normal/stone/Fire_Stone,
				/item/normal/stone/Leaf_Stone,/item/normal/stone/Moon_Stone,/item/normal/stone/Shiny_Stone,/item/normal/stone/Sun_Stone,
				/item/normal/stone/Thunder_Stone,/item/normal/stone/Water_Stone)
				var len = length(items)
				winset(P,"ShopWindow","is-visible=true")
				P << output(null,"ShopWindow.ShopGrid")
				var Grid/G = new("ShopWindow","ShopGrid",P)
				for(var/index in 1 to len)
					var item/I = items[index]
					G.Cell(1,index,"\icon[I]")
					G.Cell(2,index,"[I]")
					G.Cell(3,index,"<a href='?src=\ref[I];action=buy;tMob=\ref[P]'>Buy</a>")
					G.Cell(4,index,"Cost: [I.cost]")
				G.Cells(new/Size(4,len))
				while(winget(P,"ShopWindow","is-visible")=="true")sleep TICK_LAG

combatant
	parent_type = /mob
	var
		partyMon/party[7]
		TID
		SID

mob/NPC/ivMan
	parent_type = /mob
	density = 1
	icon = 'Character Icon.dmi'
	icon_state = "Icon 12"
	New()
		..()
		underlays += image('Shadow Effects.dmi',"Shadow")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!P.story.starterData["Chosen"])
				P.ShowText("Hello [P]. My name is Birch.",BlueColor,TRUE)
				P.ShowText("There are three pokémon on this table. I would like you to pick your starter",BlueColor,TRUE)
				P.ShowText("Remember to choose wisely though. Once you've picked, You're not getting a new one.",BlueColor,TRUE)
			else if(!(1 in P.story.defeatedTrainers["/mob/NPC/NPCTrainer/Rival"]))
				var
					kidName
					kidType
					kidGenderSuffix
					kidGender
				if(P.gender==MALE)
					kidName = "May"
					kidType = "daughter"
					kidGenderSuffix = "her"
					kidGender = "she"
				else
					kidName = "Brendan"
					kidType = "son"
					kidGenderSuffix = "his"
					kidGender = "he"
				P.ShowText("My [kidType] [kidName] is out on Route 103 studying Pokémon for me. Mind going to talk to [kidGenderSuffix]?",BlueColor,TRUE)
				P.ShowText("I think [kidGender]'d do a good job of teaching you how to battle.",BlueColor,TRUE)
			else if((!(P.story.storyFlags & GOT_STARTER_MEGA_STONE)) && ("Dynamo Badge" in P.story.badgesObtained))
				P.ShowText("So you've it looks like you've beat Wattson! I think you deserve this then.",BlueColor,TRUE)
				switch(P.story.starterData["Starter"])
					if("Treecko")
						P.bag.addItem(/item/normal/mega_stone/Seceptilite)
						P.ShowText("You have recieved the Sceptileite!")
					if("Torchic")
						P.bag.addItem(/item/normal/mega_stone/Blazikenite)
						P.ShowText("You have recieved the Blazikenite!")
					if("Mudkip")
						P.bag.addItem(/item/normal/mega_stone/Swampertite)
						P.ShowText("You have recieved the Swampertite!")
				if(!("Item Pickup" in P.client.Audio.sounds))
					P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
				P.client.Audio.playSound("Item Pickup")
				P.ShowText("That there is what the folks in the Kalos region call a 'Mega Stone.",BlueColor,TRUE)
				P.ShowText("It will allow you to mega evolve your [P.story.starterData["Starter"]]'s final form.",BlueColor,TRUE)
				P.ShowText("However, this cannot be done without a key stone embedded in a special item.",BlueColor,TRUE)
				var megaItem = (P.gender == MALE)?("Mega Cuff"):("Mega Charm")
				P.ShowText("We are currently developing the [megaItem] for you to use for the stones.",BlueColor,TRUE)
				P.ShowText("I'm not sure when it'll be done. Try coming back if you can manage to defeat your father.",BlueColor,TRUE)
				P.story.storyFlags |= GOT_STARTER_MEGA_STONE
			else if((!(P.story.storyFlags & GOT_KEY_STONE)) && ("Balance Badge" in P.story.badgesObtained))
				P.ShowText("My lazy scientists finally finished this damned thing.",BlueColor,TRUE)
				P.ShowText("Have your [(P.gender == MALE)?("Mega Cuff"):("Mega Charm")].",BlueColor,TRUE)
				P.ShowText("Don't break that shit. It cost a lot of money to make it for you to have for free.",BlueColor,TRUE)
				if(P.gender==MALE)
					P.bag.addItem(/item/key/key_stone/Mega_Cuff)
					P.ShowText("You have recieved the Mega Cuff!")
				else
					P.bag.addItem(/item/key/key_stone/Mega_Charm)
					P.ShowText("You have recieved the Mega Charm!")
				if(!("Key Item Pickup" in P.client.Audio.sounds))
					P.client.Audio.addSound(sound('key_item_get.wav',channel=20),"Key Item Pickup")
				P.client.Audio.playSound("Key Item Pickup")
				P.story.storyFlags |= GOT_KEY_STONE
			else
				P.ShowText("Twiddle Dee, Twiddle Dumb. I'm not sure there's much for me to talk to you about for a while.",BlueColor,TRUE)
