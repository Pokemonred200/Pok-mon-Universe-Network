turf
	outdoor
		objects
			Boat
				density = 1
				icon = 'Small Boats.dmi'
				Blue_Boat
					icon_state = "Blue Boat"
				Yellow_Boat
					icon_state = "Yellow Boat"
				Black_Boat
					icon_state = "Black Boat"
				Large_Boat
					icon = 'Boat.dmi'

mob/NPC/EventNPC
	Darkrai
		var returnNPC = FALSE
		icon = 'Character Icon.dmi'
		icon_state = "Icon 21"
		Interact(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(!returnNPC)
					if(P.bag.hasItem(/item/key/event/Member_Card))
						P.ShowText("The strange medium has awoken.")
						P.ShowText("She sees the Member Card and immediately knocks you out, starting a strange dream...")
						var turf/T = P.loc
						P.eventReturnSpots["Darkrai"] = list("x"=T.x,"y"=T.y,"z"=T.z)
						P.Move(locate("New Moon Island Spawn"))
					else
						P.ShowText("This medium appears to be in a rather nightmarish state")
						P.ShowText("It seems like she's whispering 'Member Card' and then screaming in terror.")
				else
					P.ShowText("The medium from before appears to have begun shouting.")
					P.ShowText("Next thing you know, you're wide awake in the same spot you found her.")
					var returnList = P.eventReturnSpots["Darkrai"]
					var turf/T = locate(returnList["x"],returnList["y"],returnList["z"])
					if(!T)
						P << "Could not find your original location. Teleporting back to Player House."
						T = locate("HouseRespawn")
					P.Move(T)
	Nebby
		icon = 'Character Icon.dmi'
		icon_state = "Icon 33"
		Interact(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(("Nebby" in event.events) && (event.events["Nebby"]["active"]))
					if(!("[ckeyEx(P.key)]" in event.events["Nebby"]["players_done"]))
						P.ShowText("Excuse me! You're [P.name], correct?",BlueColor,TRUE)
						P.ShowText("Your old friend from the Alola region, Lillie, asked me to bring you this Pokémon to take care of.",BlueColor,TRUE)
						P.ShowText("She gave me specific instructions to make sure you got it, so here, I request you do take care of it.",BlueColor,TRUE)
						var emptySlot = P.party.Find(null,1,7)
						if(!emptySlot)
							P.ShowText("Oh. It seems like your party is full. You can't accept this Pokémon that way.",BlueColor,TRUE)
							P.ShowText("Return to me with an empty party slot at once!",BlueColor,TRUE)
						else
							var pokemon/PKMN = get_pokemon("Cosmog",P,0)
							PKMN.OT = "Lillie"
							PKMN.name = "Nebby"
							PKMN.OTgender = FEMALE
							PKMN.fromRegion = "Alola"
							PKMN.TID = 12345
							PKMN.SID = 65536
							PKMN.caughtWith = "Cherish Ball"
							PKMN.caughtRoute = "Aether Paradise"
							P.party[emptySlot] = PKMN
							event.events["Nebby"]["players_done"] += "[ckeyEx(P.key)]"
							P.ShowText("That's Nebby, a rare Pokémon Lillie rescued from her mother's experiments in Alola.",BlueColor,TRUE)
							P.ShowText("Remember to tke good care of Nebby. Maybe one day, Lillie will be able to see what became of it.",BlueColor,TRUE)
					else
						P.ShowText("How's Nebby doing? I'm sure Lillie would like to know some day.",BlueColor,TRUE)
				else
					P.ShowText("Maybe some day someone from far away will need something they care for to be taken care of by someone else.",BlueColor,TRUE)
					P.ShowText("Who knows? The small world is a big blace.",BlueColor,TRUE)

mob/NPC/Sailor
	icon = 'Character Icon.dmi'
	icon_state = "Icon 35"
	var targetList[0]
	density = 1
	proc
		Unlock_Condition(player/P,destination)
	to_rustboro
		Unlock_Condition(player/P,destination)
			switch(destination)
				if("Route 104")
					return TRUE
				if("Slateport Beach")
					return ("Knuckle Badge" in P.story.badgesObtained)?(TRUE):(FALSE)
	to_dewford
		Unlock_Condition(player/P,destination)return ("Stone Badge" in P.story.badgesObtained)?(TRUE):(FALSE)
	to_dewford2
		Unlock_Condition(player/P,destination)return TRUE
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			var validDestinations[0]
			for(var/destination in targetList)
				if(Unlock_Condition(P,destination))
					validDestinations += destination
			if(length(validDestinations))
				var choice = input(P,"So where do you want to go today?","Pick your destination.") as null|anything in validDestinations
				if(isnull(choice))return
				P.ShowText("Ahoy there, matey! Let's head to our destination!",BlueColor,TRUE)
				P.Move(locate(targetList[choice]))
			else
				P.ShowText("I'm afraid you're not going anywhere today.",BlueColor,TRUE)

Destination_Sign
	parent_type = /obj
	icon = 'Outdoor Object.dmi'
	icon_state = "Scoreboard"
	density = 1
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			P.ShowText("It's a sign that shows information on what tickets and passes will get you where. Take a look at the sign?")
			P.client.clientFlags |= LOCK_MOVEMENT
			if(alert(P,"Look at the sign to check destinations?","Look at the sign.","Yes","No")=="Yes")
				switch(input(P,"Which Destination would you like to check the information for?","The Sign.") in list("Tri Pass","Rainbow Pass","Mystic Ticket",
				"Aurora Ticket","Eon Ticket","S.S. Ticket"))
					if("Tri Pass")
						alert(P,"The Tri Pass will allow passengers to travel to the Knot, Boon, or Kin islands in the Sevii Islands.\n\
						Attractions include Mt. Ember, Treasure Beach, and One Island on Knot Island, Cape Brink on Boon Island, and the Berry Forest on Kin Island.\n\
						Several Pokémon native to the Kanto region may be caught in these islands.",
						"Tri Pass Information")
					if("Rainbow Pass")
						alert(P,"The Rainbow Pass will allow passengers to travel to the Knot, Boon, Kin, Floe, Chrono, Fortune, and Quest Islands in the Sevii Islands. \
						Trainers in the latter four Sevii Islands are known to have a superiority complex when it comes to battling Hoenn Trainers, as they seem to think \
						people from Hoenn are the weakest of trainers on the planet. Several Pokémon Native to the Kanto and Johto regions may be caught here.",
						"Rainbow Pass Information")
					if("Mystic Ticket")
						alert(P,"The Mystic Ticket allows passengers to travel to Navel Rock, a seemingly empty island in the Sevii Islands that has a cave that reaches \
						very deep underground and a mountain that stretches very high into the sky. The strange, loud screeches discorage many trainers from the island \
						and no Pokémon appear to live here.","Mystic Ticket Information")
					if("Aurora Ticket")
						alert(P,"The Aurora Ticket allows passengers to travel to Birth Island, a strange, triangle-shaped island in the Sevii Islands. Nothing except a \
						large, triangle shaped object is on this island that moves around whenever trainers touch it. No one has figured out the purpose, so the island \
						tends to stay empty.","Aurora Ticket Information")
					if("Eon Ticket")
						alert(P,"The Eon Ticket allows passengers to travel to Southern Island, an island with several streams and waterfalls that make it a popular \
						tourist destination. It is said that when 'The Chosen One' touches the rock in the island center, a legendary pokémon will reveal itself to them. \
						However, such tales are proven to be great nonsense.","Eon Ticket Information")
					if("S.S. Ticket")
						alert(P,"The S.S. Ticket allows passengers to travel between Slateport City and Lilycove City, the port Towns in the Hoenn Region. Recognized \
						trainers may also be allowed to go to the Battle Frontier when construction of the area is finished. Furthermore, the ticket will allow allow \
						trainers to board the S.S. Anne in the Kanto Region's Vermilion City or the S.S. Aqua in the Johto Region's Olivine City.",
						"S.S. Ticket Information")
			P.client.clientFlags &= ~LOCK_MOVEMENT

mob/NPC/Travel_Guy
	icon = 'Character Icon.dmi'
	icon_state = "Icon 35"
	density = 1
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			var destinations[0]
			if(P.bag.hasItem(/item/key/ticket/Rainbow_Pass))
				destinations.Add("Knot Island","Boon Island","Kin Island","Floe Island","Chrono Island","Fortune Island","Quest Island")
			else if(P.bag.hasItem(/item/key/ticket/Tri_Pass))
				destinations.Add("Knot Island","Boon Island","Kin Island")
			if(P.bag.hasItem(/item/key/ticket/Mystic_Ticket))
				destinations.Add("Navel Rock")
			if(P.bag.hasItem(/item/key/ticket/Aurora_Ticket))
				destinations.Add("Birth Island")
			if(P.bag.hasItem(/item/key/ticket/Eon_Ticket))
				destinations.Add("Southern Island")
			if(P.bag.hasItem(/item/key/ticket/Old_Sea_Map))
				destinations.Add("Far Away Island")
			if(P.bag.hasItem(/item/key/ticket/S\.\S\.\_Ticket))
				switch(P.route)
					if(SLATEPORT_CITY)
						destinations.Add("Battle Frontier","Lilycove City")
					else
						destinations.Add("Battle Frontier","Slateport City")
			P.ShowText("You'll need a ticket to take ferry to places. May I see yours?",BlueColor,TRUE)
			if(length(destinations))
				P.ShowText("You flashed the ticket.")
				P.ShowText("Great! That's all you need!",BlueColor,TRUE)
				var chosenDestination = input(P,"Where are you going?","Where would you like to go?") as null|anything in destinations
				switch(chosenDestination)
					if(null)
						P.ShowText("Aww... Well, if you change your mind, there's always an available ferry!")
						return
					if("Knot Island")
						P.Move(locate("Knot Island Harbor"))
					if("Boon Island")
						P.Move(locate("Boon Island Harbor"))
					if("Kin Island")
						P.Move(locate("Kin Island Harbor"))
					if("Floe Island")
						P.Move(locate("Floe Island Harbor"))
					if("Chrono Island")
						P.Move(locate("Chrono Island Harbor"))
					if("Fortune Island")
						P.Move(locate("Fortune Island Harbor"))
					if("Quest Island")
						P.Move(locate("Quest Island Harbor"))
					if("Navel Rock")
						P.Move(locate("Navel Rock Harbor"))
					if("Birth Island")
						P.Move(locate("Birth Island Harbor"))
					if("Southern Island")
						P.Move(locate("Southern Island Shore"))
					if("Far Way Island")
						P.Move(locate("Far Away Island Shore"))
					if("Battle Frontier")
						P.Move(locate("Battle Frontier Pier"))
					if("Lilycove City")
						P.Move(locate("Lilycove City Harbor"))
					if("Slateport City")
						P.Move(locate("Slateport City Harbor"))
				P.ShowText("All Aboard The S.S. Tidal! Off to [chosenDestination]!",BlueColor,TRUE)
			else
				P.ShowText(text("I'm afraid if you don't have any passes or tickets []. You can't board unless you have some tickets.",(P.gender==MALE)?("sir"):("ma'am")))