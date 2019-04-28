starterBall
	parent_type = /obj
	density = 1
	icon = 'Item Overworlds.dmi'
	icon_state = "Regular"
	var
		starter in list("Treecko","Torchic","Mudkip")
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(P.story.starterData["Chosen"])
				P.ShowText("You already chose your starter Pokémon.")
				return
			P.ShowText("This Poké Ball contains [starter].")
			var pokemon/S = get_pokemon(starter,P,hidden=prob(50))
			P << S.cry
			if(alert(P,"Would you like to choose [starter] as your starter Pokémon?","Choose your Starter","Yes","No")=="Yes")
				P.story.starterData["Starter"] = starter
				P.story.starterData["Chosen"] = TRUE
				if(P.walker)
					P.walker.loc = null
					P.walker = null
				P.walker = S
				P.walker.loc = P.prevLoc
				P.party[1] = S
				for(var/player/M in global.online_players)
					if(!(M.playerFlags & IN_LOGIN))
						if((P==M) || (!(P.playerFlags & KARNAGE_LOCKED)))
							M.client.images += P.walker.sprite
				var newName
				var keepName = FALSE
				do
					newName = input(P,"What will [S]'s new name be?","New Name","[S.pName]") as null|text
					if(isnull(newName) || (newName=="[S.pName]"))
						newName = "[S.pName]"
						keepName = TRUE
					else if(length(newName)>12)
						keepName = FALSE
						newName = ""
					else
						keepName = (alert(P,"Will you give [S.pName] the nickname [newName]?","Nicnkame {[S.pName]}","Yes","No")=="Yes")
				while(!keepName)
				S.name = "[newName]"
			else
				P.story.starterData["Starter"] = ""
				P.story.starterData["Chosen"] = FALSE
				P.ShowText("Ok. Choose which starter you want wisely.")

turf
	table
		density = 1
		tableMiddle
			icon = 'Item Overworlds.dmi'
			icon_state = "TableMiddle"
		tableLeft
			icon = 'Item Overworlds.dmi'
			icon_state = "TableLeft"
		tableRight
			icon = 'Item Overworlds.dmi'
			icon_state = "TableRight"

atom/movable
	proc
		Interact(atom/movable/O)
			set hidden = 1
			set instant = 1

player
	Interact(player/P)
		if(isnull(P))
			var turf/T
			var atom/movable/M = src
			do
				T = get_step(M,dir)
				M = locate(/skipper) in T
			while(M)
			M = locate(/atom/movable) in T
			if(M)
				if(M.dirChange)
					dirSwitch(src,M)
				M.Interact(src)
		else
			if((!(src.playerFlags & KARNAGE_LOCKED))&&(!(P.playerFlags & KARNAGE_LOCKED)))
				if((!(src.playerFlags & CAN_TRADE)) && (!(P.playerFlags & CAN_TRADE)))
					P.ShowText("Asking [src]([src.key]) to trade Pokémon. If they reply within 60 seconds, you may trade with them.")
					src.playerFlags |= CAN_TRADE
					P.playerFlags |= CAN_TRADE
					checkResponse(P,src)
					if(alert(src,"[P]([P.key]) has asked to trade pokémon with you!","Trade with [P]([P.key])?","Yes","No")=="Yes")
						if((src.playerFlags & CAN_TRADE) && (P.playerFlags & CAN_TRADE))
							src.playerFlags |= RESPONDED
							P.OpenTrade(src)
						else
							src.playerFlags &= ~RESPONDED
							src.ShowText("You took to long to respond to [P]([P.key])'s trade request.")
					else
						src.playerFlags &= ~CAN_TRADE
						P.playerFlags &= ~CAN_TRADE
						P.ShowText("[src]([src.key]) declined your trade request.")
				else
					P.ShowText("It seems one of you is a little bit busy.")
			else
				P.ShowText("It seems one of you is a little bit busy.")
	proc
		checkResponse(player/mainPlayer,player/clientPlayer)
			set waitfor = 0
			sleep 600
			if(clientPlayer.playerFlags & RESPONDED)
				clientPlayer.playerFlags &= ~RESPONDED
				clientPlayer.playerFlags &= ~CAN_TRADE
				mainPlayer.playerFlags &= ~CAN_TRADE
				mainPlayer.playerFlags &= ~RESPONDED